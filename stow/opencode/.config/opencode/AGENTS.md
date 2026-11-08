## Workflow protocol
### PLAN.md

Use a `PLAN.md` file in the project root for every development plan.

- Materialize the plan in `PLAN.md` before implementing.
- Keep the file current: mark what is done what is not yet done.
- One subsection per branch. The subsection heading is the branch name.
- Each branch plan is a sequence of iterative implementation steps.
- Each step is a minimal change that is ready to commit once implemented.

**Format:**
```
## branch-name
- [ ] Step description
- [x] Completed step

## another-branch-name
- [ ] Step description
```

**When PLAN.md already exists:**
- Read it before doing any work.
- Find the section for the  current branch.
- Verify which steps are done (`[x]`) and which remain (`[ ]`).
- Continue from the first incomplete step.
- Update checkboxes as steps are finished.
- When all steps for a branch are complete, suggest removing that branch's section from PLAN.md.

**Step loop:**

For each step:

1. Start with a failing test.
2. Implement only enough to make that test pass.
3. Stop. Suggest a commit description. Do not commit.
4. Wait for an explicit signal before starting the next step.

Never create commits. Suggest the message and wait.

## Hard Constraints

- Never add secrets, tokens, or credentials to any file that will be committed.
- Never silence linter warnings with suppression comments without a written justification in the same commit message.