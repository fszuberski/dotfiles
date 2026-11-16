# Shared OpenCode and Claude Code configuration

One source of behavioral instructions, with native platform adapters. Do not
symlink one platform's agent definition into the other: permissions, hooks,
models, delegation controls and agent modes have different meanings.

## Sources and generated output

| Source | Purpose |
| --- | --- |
| `instructions.md` | Global instructions shared by both tools |
| `agent-contract.md` | Safety, delegation and handback contract embedded in every agent |
| `agents.json` | Unique names, descriptions, required skills and permitted delegates |
| `agents/*.md` | Complete platform-neutral role prompts |
| `skills/` | Portable skills and supporting references |
| `adapters/opencode.json` | Native V2 modes and ordered permission rules |
| `adapters/claude.json` | Claude models, tools and write-guard profiles |
| `shell-inspections.json` | Exact routine inspection commands; no wildcard shell approvals |
| `hooks/claude-agent-guard.py` | Source for Claude's scoped PreToolUse guard |

Run from the dotfiles root:

```sh
./render-ai-configs.sh
./render-ai-configs.sh --check
```

The root-level shell wrapper also works when invoked by path from another
directory and forwards all options to `deployment/render-ai-configs.py`. It
does not deploy files or reload OpenCode automatically.

The renderer uses only Python 3.9+ standard-library modules. It embeds full
prompts and native frontmatter into `stow/opencode/.config/opencode/agents/`
and `stow/claude/.claude/agents/`, generates the two global instruction files,
and copies shared skills and Claude hooks/policy into the Claude package.
OpenCode discovers `~/.claude/skills` natively, so skills are installed once.

The manifest's `skills` lists are required for applicable work, not just catalog
suggestions. The renderer includes explicit loading/reference-reading instructions
in both platforms' agent prompts and also emits Claude's native `skills` preload
field. OpenCode agents load skills through the skill tool; they have no equivalent
native preload field in this configuration. Preloading a skill body does not
preload its reference files, and a parent's loaded context does not replace the
worker's own required reading.

### Java testing skill

`skills/java-testing/` is the self-contained source artifact: `SKILL.md` contains
the operational instructions and `references/testing-standard.md` contains the
agent-relevant testing rules and sanitized examples. There is no runtime or
render-time dependency on an external draft document. Both tools use the
generated/deployed copy under `~/.claude/skills/java-testing/`.

`atdd-developer`, `tdd-workflow`, and `adversary-reviewer` must load `java-testing`
and read its full reference before applicable Java testing work. They apply its
requirements, strong parameterization/nesting preferences, intentional
semi-random fixtures and preferred tool defaults. The reference excludes manual
testing, CI/CD expectations, build-failure rules and future plans. It does not
impose Java conventions on unrelated languages or override repository restrictions.
Reports include a brief testing-standard entry and material deviations, not a
long compliance checklist.

To update the rules, edit the files under `skills/java-testing/`, review the
change, then run `./render-ai-configs.sh` and `./render-ai-configs.sh --check`.
Use Stow to link newly added skill files and reload OpenCode as described below.
For a future agent, add `java-testing` to its manifest `skills` list and describe
its role-specific use in the agent prompt. The skill is instruction context,
not mechanical proof of compliance; existing permissions and independent review
still matter.

Output is deterministic, has no timestamps or machine-specific absolute paths,
and carries a generation marker. `--check` validates sources and detects missing,
changed or stale generated files without writing. Normal rendering changes only
marked generated files, rejects collisions/symlinked destinations, and never
deletes unknown or stale files. When removing/renaming an agent or skill, inspect
and explicitly remove its obsolete generated files and deployed links; neither
the renderer nor the Stow wrapper silently cleans them up. Unmarked user-defined
agents can coexist and are not overwritten.

Changing canonical sources does not immediately change behavior; rendering does.
Once deployed, generated files are Stow-linked, so rendering updates live
instructions/definitions. Review source diffs before rendering and remember that
some settings are hot-reloaded. Do not run rendering automatically from an agent
edit hook. The main playbook performs `--check`, not generation.

## Agents

| Agent | OpenCode mode | Delegates | Default model |
| --- | --- | --- | --- |
| `local-config` | primary | adversary-reviewer, concurrency-analyzer | inherit |
| `tdd-workflow` | primary | atdd-developer, adversary-reviewer | OpenCode: inherit; Claude: opus |
| `atdd-developer` | subagent | none | OpenCode: inherit; Claude: sonnet |
| `adversary-reviewer` | subagent | none | inherit |
| `system-explorer` | primary | adversary-reviewer, concurrency-analyzer | inherit |
| `concurrency-analyzer` | all | none | OpenCode: inherit; Claude: sonnet |

In OpenCode, select a primary agent through the agent selector. In Claude Code,
start an orchestrator as the main thread, for example:

```sh
claude --agent local-config
claude --agent tdd-workflow
claude --agent system-explorer
```

Claude does not have an equivalent primary-only frontmatter field. Orchestrators
are documented as main-thread roles, their Agent tool allowlist is generated
from the shared delegate list, and the guard blocks nested delegation. Other
main agents must not invoke these orchestrators as workers. No increased nesting
depth, agent-team setting, or third-party plugin is required.

TDD uses one `atdd-developer` worker for stories, instructions and plan steps.
The branch-based orchestrator and Claude write guards require a Git project;
start orchestrators at its root. They do not initialize repositories themselves.
An approved step completes RED → GREEN → REFACTOR → independent verification →
independent review, then waits for the user's explicit next-step signal. Plan
approval alone does not authorize the first implementation step. Lightweight
exploration runs in the orchestrator using `system-analysis`; a full walkthrough
is a separate, explicitly requested `system-explorer` task. Project constraints
win: in this repository adding tests is forbidden, so the TDD agents must stop
and surface that conflict rather than inventing an exemption.

## Permission and enforcement boundaries

### OpenCode

- Each custom agent starts from an explicit deny-by-default action policy. Discovery, skills and web reads are allowed; access outside the workspace asks. Existing `.env` read prompts are preserved.
- Shell commands outside the exact inspection list ask. No broad `git *`, interpreter or test-command allowance is generated. Common direct Git mutations are additionally denied for the TDD orchestrator/worker.
- The orchestrator's native edit permission permits only location-relative `PLAN.md`. Start it at the project root. The worker cannot directly edit plans or Git metadata. Reviewers/analyzers have no edit permission. Explorer report writes under `docs/walkthrough/` ask.
- Local-config edits all ask for approval; its prompt requires repository targets. OpenCode's location-relative internal paths do not provide the same hard-coded `~/code/dotfiles` root guard as the Claude hook. Review edit destinations instead of assuming exact parity.
- Only configured delegates are allowed. Children have their own policies, not the parent's policy. MCP and other unlisted tool actions are denied for these agents; add deliberate exceptions in the adapter if needed.

### Claude Code

- Explicit tool lists exclude editing/delegation from reviewers and leaf analyzers. Normal permission mode is retained, not `acceptEdits` or `bypassPermissions`.
- Scoped agent hooks ask for shell commands outside the exact inspection list, even if a previous shell approval was broad. They do not auto-approve inspection calls or override native permission denies.
- File-tool guards resolve paths/symlinks, deny direct Git metadata edits, restrict local-config to repository paths under `~/code/dotfiles` (not their deployed symlink aliases), restrict the orchestrator to a non-escaping root `PLAN.md`, keep worker edits in its project and out of plans, and require approval for explorer reports under root `docs/walkthrough/`.
- Hook input uses the actual child agent identity, so an inherited orchestrator hook cannot accidentally grant its own permissions to a worker. A missing/broken hook uses `onFailure: block` (requires Claude Code 2.1.295+); Python must be on `PATH`.
- Agent definitions do not rewrite global/project settings. Native permission rules, workspace trust and other hooks still apply. If a background worker cannot obtain approval for a verification command, it returns blocked; the main agent/user arranges approval rather than silently bypassing it.

These are guardrails, **not an OS sandbox or proof of read-only execution**.
An approved shell command can execute arbitrary project code, write artifacts,
modify external services or run nested interpreters. Exact command approval
does not approve arbitrary script contents. Common Git command denials are not
a complete shell parser; alternative forms still need review. Never approve a
command that violates the role, and use isolation when reviewing untrusted code.
Prompt scope constraints still matter, especially when using skills or approving
verification side effects. Disabling hooks, auto-approving OpenCode requests or
overriding definitions changes these guarantees.

## Deploy and verify

Keep private OpenCode `opencode.json(c)`/`service.json` and Claude
`settings.json`, credentials, sessions, caches and memory machine-local. Neither
package includes them. The existing OpenCode CLI theme is not generated.

Validate and preview both packages before linking either:

```sh
python3 deployment/render-ai-configs.py --check
claude plugin validate --strict stow/claude/.claude/agents
claude plugin validate --strict stow/claude/.claude/skills
sh deployment/deploy.sh --check stow/opencode "$HOME"
sh deployment/deploy.sh --check stow/claude "$HOME"
```

Then deploy explicitly:

```sh
sh deployment/deploy.sh stow/opencode "$HOME"
sh deployment/deploy.sh stow/claude "$HOME"
```

The shared Arch `main.yml --tags config` includes both packages but also the
other selected dotfiles; use individual wrapper invocations for this scope.
Existing-file conflicts require inspection and explicit user-directed handling;
never adopt or overwrite them automatically. Validate macOS separately.

After regenerating deployed Stow-linked definitions, run `opencode reload`
(or `/reload` in the client) to ensure cached prompts and skills refresh; changes
to symlink targets are not always noticed by the watcher. No service restart is
needed. In Claude, a newly created first `agents/` directory needs a new session;
subsequent definition edits are watched. Confirm the agent names in the client
and use `/context all` in Claude to inspect loaded instructions. Current Claude
supports project `AGENTS.md`; older installations may need an explicit
`CLAUDE.md` import. Do not copy project instructions into the global file.

For rollback, first inspect the current diff and deployed links. Revert this
change's commit if committed, or reverse only this task's edits if not. Before
removing generated files, explicitly unlink only their matching Stow symlinks
so they do not dangle; do not delete runtime/private files or unrelated agents.
Re-render and re-apply the retained packages as appropriate. No automatic
rollback or cleanup is performed.

See [PROVENANCE.md](PROVENANCE.md) for ALF source revision, adaptations and
upstream reuse caveats.
