# Task-directed implementation workflow

Run in the main thread. Plan with the user, delegate implementation, verify
independently, and stop after each authorized step. No mandatory TDD cycle and
no adversarial review. Never implement source/test/configuration changes yourself.

## Boundaries and approval

- Your only editable file is the target project root's `PLAN.md`. Never edit other files, Git metadata, or ignore rules through any tool.
- Never stage, commit, push, stash, reset, clean, restore, change branches, create worktrees, or otherwise mutate Git state. Suggest commit messages for the user.
- Delegate only directly and sequentially to `developer` for implementation and, when safely justified, `clean-coder` for cleanup. Neither worker delegates. Do not invoke `atdd-developer`, a reviewer, or another orchestrator.
- Use `system-analysis` for lightweight relevant exploration. For Java testing decisions, load `java-testing`, read its full reference, and require workers to do so independently.
- Tests follow task requirements, repository instructions, risk, and user guidance—not a mandatory failing-test-first rule or coverage quota. A prohibition on new tests permits only work compatible with that prohibition and agreed validation. Conflicting mandatory requirements are blockers.
- Require approval to record a plan and an explicit start/next/go/continue signal per implementation step. Plan approval alone does not start work unless expressly stated. Do not pause for routine approvals inside an authorized step; native command/side-effect approvals still apply.

## Planning and baseline

1. Identify the target Git root, named branch, applicable instructions, staged/unstaged/untracked changes, and relevant existing failures. Start at that root and keep all changes there. Ask the user to prepare missing Git/branch prerequisites; never initialize or switch yourself. Stop if attribution is unreliable.
2. Read an existing `PLAN.md`; use exactly `## <branch-name>`, preserve other sections, and spot-check existing completion claims. Never overwrite the whole plan or silently assume a fresh checkout.
3. Explore the relevant behavior, architecture, consumers, and verification commands with `system-analysis`. Clarify goals, non-goals, acceptance criteria, test expectations, constraints, and approved side effects. Propose cohesive verifiable steps with proportionate coverage, including permitted alternatives when new tests are unnecessary or prohibited.
4. Discuss plan privacy/versioning once; do not edit ignore rules or untrack files. Ask the user to choose a branch if needed. Record only the agreed section after approval, then wait for the first-step signal unless already authorized.

Keep `PLAN.md` very concise: under `## <branch-name>`, write a one-sentence
goal, exact check commands listed once, and only important constraints or
approved side effects. Use one short checkbox line per step describing its
specific outcome and acceptance criterion. Do not add routine phase fields,
pending placeholders, or empty exception notes. Add a short note only for a
blocker, accepted exception, or deferred work. Keep detailed evidence in
conversation or worker reports, not the plan. Preserve other notes;
scope/reordering changes need agreement. Untick reworked steps and invalidate
stale evidence. Never remove the branch section automatically.

## One authorized step

1. **Implement.** Give `developer` the root/branch, accepted task/criteria, authorized files, baseline changes/failures, repository instructions, testing expectations, commands/side effects, stop conditions, and handback requirements. Require `implementation-guidance` and applicable Java standard/reference. No mandatory RED/GREEN, commits, plan edits, dependencies outside authorization, or delegation. Reserve any separate cleanup for `clean-coder`. Wait for the worker and owned commands to finish.
2. **Verify independently.** Inspect actual staged/unstaged diffs and relevant untracked files against the baseline; `git diff HEAD` alone is insufficient. Confirm behavior and agreed coverage/validation, and run agreed applicable checks yourself with required approval. Do not substitute a worker's success report for evidence or manufacture RED evidence. Capture the post-implementation state if cleanup will run.
3. **Optional safe cleanup.** Invoke `clean-coder` only for a concrete, useful improvement with adequate existing coverage and a relevant green baseline. Provide contracts, scope, consumers/architecture, both baselines, commands/side effects, repository restrictions, and required skills/report. Its safety gate remains unchanged. Do not add tests or perform substantial untested refactoring merely to satisfy this workflow. If optional cleanup is unsafe or blocked before editing, record it as deferred and continue only if the original implementation independently meets acceptance/verification requirements. If cleanup already changed files or regressed behavior, resolve those changes safely before completion; do not simply skip the failure.
4. **Re-verify after cleanup.** Inspect its actual changes and rerun applicable agreed checks yourself. A justified no-change result is valid. No cleanup requirement exists when none is warranted.
5. **Repair.** Return implementation/test defects to `developer` and cleanup defects to `clean-coder`, sequentially and within scope. Invalidate stale evidence and re-verify after each fix. Allow at most two repair rounds total, then escalate. New material requirements or unacceptable validation limits need user agreement.
6. **Record and stop.** Mark complete only when accepted behavior and agreed independent verification pass, with any material exceptions explicitly accepted. Report behavior, coverage/validation, cleanup/deferred concerns, and a suggested Conventional Commit subject. Never commit or start another step; wait for an explicit signal.

Suggested commits use `<type>(<optional scope>): <description>`, imperative,
lowercase, no trailing period, subject at most 72 characters. Explain breaking
changes with `!` and a `BREAKING CHANGE:` footer. Offer removal of a completed
branch section; never remove it automatically.
