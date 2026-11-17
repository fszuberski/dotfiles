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
python3 deployment/render-ai-configs.py
python3 deployment/render-ai-configs.py --check
```

The renderer also works when invoked by path from another directory. It does
not deploy files or reload OpenCode automatically.

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

Both developer workers, `clean-coder`, all four implementation workflows, and
`adversary-reviewer` must load `java-testing` and read its full reference before
applicable Java testing work. They apply its
requirements, strong parameterization/nesting preferences, intentional
semi-random fixtures and preferred tool defaults. The reference excludes manual
testing, CI/CD expectations, build-failure rules and future plans. It does not
impose Java conventions on unrelated languages or override repository restrictions.
Reports include a brief testing-standard entry and material deviations, not a
long compliance checklist.

To update the rules, edit the files under `skills/java-testing/`, review the
change, then run `python3 deployment/render-ai-configs.py` and the same command
with `--check`.
Use Stow to link newly added skill files and reload OpenCode as described below.
For a future agent, add `java-testing` to its manifest `skills` list and describe
its role-specific use in the agent prompt. The skill is instruction context,
not mechanical proof of compliance; existing permissions and independent review
still matter.

### Rust testing skill

`skills/rust-testing/` is a separate, self-contained adaptation of the Java
testing philosophy, not a dependency on or replacement for `java-testing`.
`SKILL.md` provides operational instructions; `references/testing-standard.md`
provides the full Rust standard and illustrative examples.

The same developer workers, refactorer, four implementation workflows, and
reviewer require this skill for applicable Rust work. It preserves
behavior-focused boundaries, real lightweight collaborators, intentional
semi-random fixtures, descriptive Given/When/Then comments, and strong
case-based/grouping preferences. Rust adaptations cover nested modules,
snake-case names, Cargo test layouts versus behavioral testing levels,
doctests, errors, parallel resource isolation, and async task ownership.
Built-in testing support is the starting point; optional crates are not
mandatory dependencies.

Edit the source under `skills/rust-testing/`, render and check using the
commands above, then deploy new files through Stow as described below.
Both tools discover the deployed copy under `~/.claude/skills/rust-testing/`.
There is no shared testing-core skill or change to the Java standard.

### Shared implementation guidance

`skills/implementation-guidance/SKILL.md` contains the development guidance
shared by `atdd-developer` and `developer`: inspect/respect existing architecture,
otherwise default to pragmatic ports/adapters following Tom Hombergs' *Get Your
Hands Dirty on Clean Architecture*, 2nd edition; develop narrow tracer-bullet
slices following David Thomas and Andrew Hunt's *The Pragmatic Programmer*;
preserve scope, correctness, user work, and honest verification evidence.
Both workers must load it independently. It does not impose test order:
`atdd-developer` remains strict TDD, while `developer` chooses coverage according
to the task, repository requirements, risk, and user instructions. Applicable
Java conventions still come from the same `java-testing` skill.

### Design principles skill

`skills/design-principles/SKILL.md` is a self-contained adaptation of ALF's
SOLID, GRASP, simplicity, coupling/cohesion, and state-management guidance.
`clean-coder` must load it before design assessment/refactoring. Its quick map
connects observed problems to candidate transformations, not mandatory patterns.
Correctness, established architecture, scope, and contextual trade-offs take
precedence over mechanical rules. It requires no additional ALF agents and
does not impose metrics quotas or override `java-testing` fixture conventions.

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
| `adversarial-tdd` | primary | atdd-developer, clean-coder, adversary-reviewer | OpenCode: inherit; Claude: opus |
| `tdd` | primary | atdd-developer, clean-coder | OpenCode: inherit; Claude: opus |
| `simple` | primary | developer, clean-coder | inherit |
| `yolo` | primary | developer, clean-coder | inherit |
| `atdd-developer` | subagent | none | OpenCode: inherit; Claude: sonnet |
| `developer` | subagent | none | OpenCode: inherit; Claude: sonnet |
| `clean-coder` | subagent | none | OpenCode: inherit; Claude: sonnet |
| `adversary-reviewer` | subagent | none | inherit |
| `system-explorer` | primary | adversary-reviewer, concurrency-analyzer | inherit |
| `concurrency-analyzer` | all | none | OpenCode: inherit; Claude: sonnet |

In OpenCode, select a primary agent through the agent selector. In Claude Code,
start an orchestrator as the main thread, for example:

```sh
claude --agent local-config
claude --agent adversarial-tdd
claude --agent tdd
claude --agent simple
claude --agent yolo
claude --agent system-explorer
```

Claude does not have an equivalent primary-only frontmatter field. Orchestrators
are documented as main-thread roles, their Agent tool allowlist is generated
from the shared delegate list, and the guard blocks nested delegation. Other
main agents must not invoke these orchestrators as workers. No increased nesting
depth, agent-team setting, or third-party plugin is required.

### Workflow choices

| Workflow | Testing mode | Separate cleanup | Adversarial review | Step approval | Local commits |
| --- | --- | --- | --- | --- | --- |
| `adversarial-tdd` | strict TDD | required gate, no-change result valid | yes | each step | no |
| `tdd` | strict TDD | required gate, no-change result valid | no | each step | no |
| `simple` | task-directed coverage | only useful, safely covered work | no | each step | no |
| `yolo` | task-directed coverage | only useful, safely covered work | no | autonomous within authorized task | ordinary task-only local commits |

Every workflow verifies independently in the orchestrator; omitting adversarial
review never means accepting a worker's success claim without inspection/checks.
All workers are launched directly and sequentially, with no nested delegation.
The branch-based workflows and Claude guards require a Git project and a named
branch; start at its root. They do not initialize repositories or switch branches.
Lightweight exploration uses `system-analysis`; a full walkthrough remains a
separate explicitly requested `system-explorer` task.

`adversarial-tdd` is the renamed former `tdd-workflow`, with its original
behavior preserved. There is no old-name alias. The two TDD workflows run
RED/GREEN (`atdd-developer`) → independent GREEN verification → REFACTOR
(`clean-coder`) → independent re-verification; only `adversarial-tdd` then
launches `adversary-reviewer`. Standalone `atdd-developer` retains its full-cycle
default unless REFACTOR is explicitly assigned separately. A worker's completion
covers only its assigned phases, not the entire workflow step.

`simple` and `yolo` use `developer`, not a weakened TDD worker. Coverage follows
the task, repository instructions, risk, and user guidance; there is no mandatory
RED run or new-test quota. Existing applicable checks still run. Optional cleanup
does not override `clean-coder`'s coverage/green safety gate: unsafe cleanup may
be deferred before edits, but partial edits/regressions must be resolved before
completion. All workflows route repairs to the responsible worker, invalidate
stale evidence, and allow at most two repair rounds per step before escalation.

`adversarial-tdd`, `tdd`, and `simple` require approval to record the branch plan
and an explicit first/next-step signal. Plan approval alone does not start work
unless it expressly includes that signal. They suggest commits, never make them.
`yolo` executes the user's scoped task without routine next-step prompts and
can make ordinary local commits unless the user restricts them. It keeps the
execution breakdown in conversation unless plan-file writes are explicitly
authorized. Merely selecting an agent, discussing a plan, or receiving a worker
report is not task execution authorization.

When authorized to write `PLAN.md`, all four workflows keep each branch section
concise: a one-sentence goal, checks listed once, important constraints or
approved side effects, and one outcome-focused checkbox per step. They add short
notes only for blockers, accepted exceptions, or deferred work; detailed evidence
belongs in conversation or worker reports. This does not change workflow gates.

Project constraints win: here adding tests is forbidden, so strict TDD must stop
and surface that conflict. Task-directed workflows can use permitted validation
without new tests when the accepted task allows it, but cannot silently ignore
conflicting mandatory coverage requirements.

### Autonomous commit boundaries

`yolo` fixes one target root/branch for the authorized task and must re-check it
before delegation, verification, and commits. It never authorizes edits to other
repositories, submodules, global/home configuration, credentials, or escaping
symlink targets. Native approvals still apply; autonomy is not blanket shell
approval, an OS sandbox, or permission to disable safeguards.

Only the `yolo` orchestrator can stage/commit its task; both developer workers
and `clean-coder` remain non-committing. The commit procedure requires verified,
attributable task-only changes, an empty starting index, explicit file paths,
inspection of the complete staged diff, and inspection of commit hooks/side
effects. Pre-existing staged work or overlapping user edits block automatic
committing rather than being absorbed, unstaged, or discarded. Plan files are
not included automatically. Use `git add -- <explicit-relative-file> ...` and
ordinary `git commit -m "<subject>"` (repeated `-m` for additional paragraphs).
No bulk staging, `commit -a`, push, amend, history rewrite, destructive cleanup,
branch changes, Git configuration changes, or hook/signing bypass is authorized.
After a successful commit, inspect its content/hash and remaining status.

## Permission and enforcement boundaries

### OpenCode

- Each custom agent starts from an explicit deny-by-default action policy. Discovery, skills and web reads are allowed; access outside the workspace asks. Existing `.env` read prompts are preserved.
- The four workflow orchestrators and their `developer`, `atdd-developer`, `clean-coder`, and `adversary-reviewer` workers allow general shell commands, while direct `rm`, `rmdir`, `unlink`, and `shred` requests ask. Common explicit outside-path forms of `rm` (parent traversal, absolute and home paths) are denied, including absolute paths inside the target; use relative paths for legitimate removals. Other agents still ask for shell commands outside the exact inspection list. Common direct Git mutations remain denied for non-committing workflows and these workers. `yolo` defaults direct `git *` to deny, with ask-level inspection, explicit staging, and ordinary commit forms; common amend/all/hook-bypass variants remain denied. These wildcard rules are not an argument parser or a repository-boundary sandbox: inspect commands, paths, and side effects, including when no permission prompt appears. The reviewer's read-only role is an instruction, not a shell-enforced boundary.
- Every workflow's native edit permission permits only location-relative `PLAN.md`. Start it at the project root. Workers cannot directly edit plans or Git metadata. Reviewers/analyzers have no edit permission. Explorer report writes under `docs/walkthrough/` ask. Target-root/branch pinning and nested-repository exclusion also remain prompt obligations; native static rules do not dynamically pin a session root.
- Local-config edits all ask for approval; its prompt requires repository targets. OpenCode's location-relative internal paths do not provide the same hard-coded `~/code/dotfiles` root guard as the Claude hook. Review edit destinations instead of assuming exact parity.
- Only configured delegates are allowed. Children have their own policies, not the parent's policy. MCP and other unlisted tool actions are denied for these agents; add deliberate exceptions in the adapter if needed.

### Claude Code

- Explicit tool lists exclude editing/delegation from reviewers and leaf analyzers. Normal permission mode is retained, not `acceptEdits` or `bypassPermissions`.
- Scoped agent hooks ask for shell commands outside the exact inspection list, even if a previous shell approval was broad. They do not auto-approve inspection calls or override native permission denies. The new `plan-commit` profile retains root-plan-only file edits and permits only simple explicit-file `git add -- ...` and ordinary `git commit -m ...` mutation requests at ask level; routing options, bulk/directory staging, amend, push, compound/expanding mutation forms, and other recognized direct Git mutations are denied. This limited recognizer is not a general shell parser; alternative wrappers still ask and must not bypass the role.
- File-tool guards resolve paths/symlinks, deny direct Git metadata edits, restrict local-config to repository paths under `~/code/dotfiles` (not their deployed symlink aliases), restrict workflows to a non-escaping root `PLAN.md`, keep worker edits in their project and out of plans/nested repositories, and require approval for explorer reports under root `docs/walkthrough/`. Workers and the committer compare the current Git root with Claude's original `CLAUDE_PROJECT_DIR` and fail closed if it is missing or the root changes. Branch identity, authorization, attribution, and staged-content inspection still require the agent's explicit checks.
- Hook input uses the actual child agent identity, so an inherited orchestrator hook cannot accidentally grant its own permissions to a worker. A missing/broken hook uses `onFailure: block` (requires Claude Code 2.1.295+); Python must be on `PATH`.
- Agent definitions do not rewrite global/project settings. Native permission rules, workspace trust and other hooks still apply. If a background worker cannot obtain approval for a verification command, it returns blocked; the main agent/user arranges approval rather than silently bypassing it.

These are guardrails, **not an OS sandbox or proof of read-only execution**.
A shell command can execute arbitrary project code, write artifacts,
modify external services or run nested interpreters. Exact command approval
does not approve arbitrary script contents. Common Git command denials are not
a complete shell parser; alternative forms still need review. Do not run or approve a
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
