"""Scoped Claude guardrails, not a shell sandbox. Uses only the standard library."""

import json
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


def check(payload, policy, fallback):
    name = payload.get("agent_type") or fallback
    if name not in policy["agents"]:
        return decision("deny", "No dotfiles guard policy exists for this agent identity.")
    role = policy["agents"][name]
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
            return decision("deny", "This role cannot mutate Git index, refs, history or working-tree state through Git.")
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
    elif guard == "plan":
        allowed = root / "PLAN.md"
        if lexical != allowed or target != allowed:
            return decision("deny", "The orchestrator may edit only the project root's PLAN.md, not a symlink escape.")
    elif guard == "implementation":
        if lexical.name == "PLAN.md" or target.name == "PLAN.md":
            return decision("deny", "Implementation workers cannot edit plan files.")
        if not within(target, root):
            return decision("deny", "Implementation edits must stay in the current project.")
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
