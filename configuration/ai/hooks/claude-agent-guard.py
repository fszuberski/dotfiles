"""Scoped Claude guardrails, not a shell sandbox. Uses only the standard library."""

import json
import os
from pathlib import Path
import shlex
import subprocess
import sys


GIT_MUTATIONS = {
    "add", "am", "apply", "bisect", "branch", "checkout", "cherry-pick",
    "clean", "commit", "config", "fetch", "gc", "init", "merge", "mv",
    "pull", "push", "rebase", "reflog", "remote", "reset", "restore",
    "revert", "rm", "stash", "switch", "tag", "update-index", "update-ref",
    "worktree",
}


def decision(effect, reason):
    return {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": effect,
            "permissionDecisionReason": reason,
        }
    }


def within(path, directory):
    return path == directory or directory in path.parents


def project_root(cwd):
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"], cwd=cwd,
        capture_output=True, text=True, check=False, timeout=5,
    )
    if result.returncode:
        raise ValueError("Cannot identify a Git project root; start the agent in the intended repository.")
    return Path(result.stdout.strip()).resolve()


def owning_project(target):
    """Find the Git owner of an existing or not-yet-created/deleted file."""
    parent = target.parent
    while not parent.exists():
        parent = parent.parent
    return project_root(parent)


def direct_git_mutation(command):
    """Recognize common direct Git mutations; all other shell forms still ask."""
    try:
        words = shlex.split(command)
    except ValueError:
        return False
    if not words or Path(words[0]).name != "git":
        return False
    index = 1
    while index < len(words) and words[index].startswith("-"):
        if words[index] in {"-C", "-c", "--git-dir", "--work-tree", "--namespace"}:
            index += 2
        else:
            index += 1
    return index < len(words) and words[index] in GIT_MUTATIONS


def scoped_commit_command(command, cwd):
    """Recognize only ordinary explicit-file staging/new commits, never execute them."""
    # Deliberately reject expansion/compound syntax, even inside a quoted message.
    # Native approvals still apply; this is not a general shell parser or sandbox.
    if any(char in command for char in "\n\r;&|<>`$\\"):
        return False
    try:
        words = shlex.split(command)
    except ValueError:
        return False
    if words[:2] == ["git", "commit"]:
        arguments = words[2:]
        return bool(arguments) and len(arguments) % 2 == 0 and all(
            arguments[index] == "-m" and bool(arguments[index + 1].strip())
            for index in range(0, len(arguments), 2)
        )
    if words[:3] != ["git", "add", "--"] or len(words) < 4:
        return False
    root = project_root(cwd)
    if cwd != root:
        return False
    for value in words[3:]:
        path = Path(value)
        if (not path.parts or path.is_absolute() or ".." in path.parts
                or ".git" in path.parts or any(char in value for char in "*?[:")):
            return False
        target = (root / path).resolve()
        if target == root or not within(target, root) or target.is_dir():
            return False
        if owning_project(target) != root:
            return False
    return True


def check(payload, policy, fallback):
    name = payload.get("agent_type") or fallback
    if name not in policy["agents"]:
        return decision("deny", "No dotfiles guard policy exists for this agent identity.")
    role = policy["agents"][name]
    if role["guard"] in {"plan-commit", "implementation"}:
        # Claude documents this as the original project, even after a cwd change.
        # Fail closed if it is absent; never silently retarget a worker or committer.
        initial = Path(os.environ["CLAUDE_PROJECT_DIR"]).resolve(strict=True)
        current = Path(payload["cwd"]).resolve(strict=True)
        if project_root(current) != project_root(initial):
            return decision("deny", "This worker/committer must stay in the session's original target repository.")
    tool = payload.get("tool_name")
    if tool not in {"Bash", "Edit", "Write", "NotebookEdit", "Agent", "Task"}:
        raise ValueError("Unexpected tool for this scoped guard.")
    arguments = payload.get("tool_input", {})
    if not isinstance(arguments, dict):
        raise ValueError("Malformed tool input.")

    if tool in {"Agent", "Task"}:
        if payload.get("agent_id"):
            return decision("deny", "Run orchestrators in the main thread; nested delegation is disabled.")
        if arguments.get("subagent_type") not in role["delegates"]:
            return decision("deny", "This agent may launch only its configured worker types.")
        return None

    if tool == "Bash":
        command = arguments.get("command")
        if not isinstance(command, str):
            raise ValueError("Missing shell command.")
        if command.strip() in policy["shell_inspections"]:
            return None  # Do not override native permission denies or asks.
        if role["guard"] != "dotfiles" and direct_git_mutation(command):
            if role["guard"] != "plan-commit":
                return decision("deny", "This role cannot mutate Git index, refs, history or working-tree state through Git.")
            cwd = Path(payload["cwd"]).resolve(strict=True)
            if cwd != project_root(cwd) or not scoped_commit_command(command, cwd):
                return decision("deny", "Use only root-local git add -- <explicit files> or git commit -m <message>; no routing, bulk staging, amend, push, or other Git mutations.")
            return decision(
                "ask",
                "Confirm the fixed target repository, attributable task-only changes, "
                "verification and staged diff. This permits only the ordinary local "
                "staging/commit operation, not unrelated changes or broader Git authority.",
            )
        return decision(
            "ask",
            "Command is outside the exact inspection allowlist. Review its side effects; "
            "approval is for verification/authorized applies, not a bypass of this agent's role. "
            "If approval is unavailable, return blocked to the caller.",
        )

    if tool not in {"Edit", "Write", "NotebookEdit"}:
        return None
    if role["guard"] == "read-only":
        return decision("deny", "This reviewer/analyzer cannot write reviewed files or reports.")

    raw = arguments.get("file_path") or arguments.get("notebook_path")
    cwd = Path(payload["cwd"]).resolve(strict=True)
    if not isinstance(raw, str) or not raw:
        raise ValueError("Missing write destination.")
    lexical = Path(raw).expanduser()
    if not lexical.is_absolute():
        lexical = cwd / lexical
    target = lexical.resolve()
    root = project_root(cwd)
    # Block both lexical Git metadata paths and symlinks that resolve into them.
    git_dir = subprocess.run(
        ["git", "rev-parse", "--absolute-git-dir"], cwd=cwd,
        capture_output=True, text=True, check=True, timeout=5,
    )
    metadata = Path(git_dir.stdout.strip()).resolve()
    if ".git" in lexical.parts or ".git" in target.parts or within(target, metadata):
        return decision("deny", "Direct writes to Git metadata are not permitted.")

    guard = role["guard"]
    if guard == "dotfiles":
        repo = (Path.home() / "code/dotfiles").resolve()
        if not within(lexical, repo) or not within(target, repo):
            return decision("deny", "Edit the repository file under ~/code/dotfiles, not a deployed path or symlink escape.")
    elif guard in {"plan", "plan-commit"}:
        allowed = root / "PLAN.md"
        if lexical != allowed or target != allowed:
            return decision("deny", "The orchestrator may edit only the project root's PLAN.md, not a symlink escape.")
    elif guard == "implementation":
        if lexical.name == "PLAN.md" or target.name == "PLAN.md":
            return decision("deny", "Implementation workers cannot edit plan files.")
        if not within(target, root):
            return decision("deny", "Implementation edits must stay in the current project.")
        if owning_project(target) != root:
            return decision("deny", "Implementation edits cannot enter a nested repository or submodule.")
    elif guard == "walkthrough":
        reports = root / "docs/walkthrough"
        if not within(target, reports) or target == reports:
            return decision("deny", "System explorer may write only reports under the root's docs/walkthrough/.")
        return decision("ask", "Approve this walkthrough report destination/content before writing.")
    else:
        raise ValueError("Unknown write guard.")
    return None


def main():
    try:
        policy = json.loads(Path(__file__).with_name("dotfiles-agent-policy.json").read_text())
        payload = json.load(sys.stdin)
        if not isinstance(payload, dict) or payload.get("hook_event_name") != "PreToolUse":
            raise ValueError("Expected a PreToolUse hook object.")
        result = check(payload, policy, sys.argv[1])
    except (KeyError, IndexError, OSError, ValueError, subprocess.SubprocessError):
        # Never log tool arguments: they may contain private file content.
        result = decision("deny", "Dotfiles agent guard could not validate this call; check its installation and input.")
    if result:
        print(json.dumps(result))


if __name__ == "__main__":
    main()
