---
name: java-testing
description: Apply the user's approved Java testing standard when planning, implementing, or reviewing Java behavior and tests. Includes strong parameterization/nesting preferences, real internal collaborators, and intentional semi-random fixtures.
---

# Java testing standard

## Applicability and required reading

Use this skill before planning, implementing, or reviewing tests or testing
decisions for Java code, including Java modules in mixed-language projects.
Do not impose Java-specific frameworks or conventions on unrelated languages.

Before that work, **read `references/testing-standard.md` in full**, relative
to this skill's directory. It is the authoritative, self-contained testing
standard for this skill. A skill description, this operational checklist, or
the caller's summary is not
a substitute for reading the standard. Do not assume a parent agent's loaded
context reaches a worker. Examples illustrate techniques, not application APIs
to copy verbatim or complete runnable test files.

If the skill/reference is missing or unreadable, return a blocker before the
affected work. If repository requirements conflict with the standard, identify
the conflict and ask the caller/user how to proceed. Never bypass a repository
prohibition on adding tests or grant yourself execution, editing, dependency
installation, or other additional authority through this skill.

## Apply the document without strengthening or weakening it

- Preserve its distinction between requirements, strong preferences, and optional approaches. Treat the full reference as authoritative; report any contradiction in this checklist rather than silently choosing an interpretation.
- Select the testing boundary for the behavior. Acceptance criteria do not automatically require an E2E test, Cucumber, or a test at every level.
- Prefer real, lightweight internal collaborators and appropriate test doubles at external boundaries. Prefer Testcontainers for supported infrastructure in integration tests where practical; do not replace every kind of test double with a container.
- Strongly prefer parameterized tests for equivalent scenarios and JUnit 5 `@Nested` classes for grouping related behavior. A justified, clearer alternative is allowed; explain material departures instead of treating these preferences as absolute requirements or ignoring them.
- Treat JUnit 5, Mockito, Testcontainers, and Cucumber as preferred Java defaults. Respect justified existing project conventions; do not add dependencies or migrate tooling solely to match the list.
- Preserve intentional semi-random fixture variation such as `randomShoppingCart()`. Do not replace it with deterministic fixtures or mandatory seeding merely to satisfy a general preference for determinism. Set scenario-specific inputs as needed; investigate concrete failures rather than dismissing all semi-random fixtures as defects.
- In newly written or modified Java tests, add Given/When/Then phase comments with short, scenario-specific descriptions of preconditions, the action, and the observable outcome—not bare labels or mechanical code narration. Use descriptive combined `// when/then: ...` comments when an assertion executes the action; do not split code artificially or rewrite unrelated tests. Phase comments are not required in `@BeforeEach` methods or fixture helpers.
- Apply the document's naming, test-model, and parallel-execution guidance. Do not invent additional testing requirements.
- Stay within the authorized change. The skill covers test design and implementation, not unrelated process or infrastructure changes.

## Role checklist and handback

- **Planner:** choose relevant levels/boundaries and commands, include applicable conventions in the agreed plan, and tell each worker to load this skill and read the reference independently.
- **Developer:** use the standard when choosing and writing the RED test, implementing GREEN, and refactoring tests. Keep the caller's test-first evidence and scope boundaries intact.
- **Reviewer:** check the actual tests/plan against the applicable sections. Distinguish real requirement violations from justified preference deviations. Do not manufacture findings merely because fixtures are semi-random or an alternative framework is used.

For applicable Java work, include a short **Testing standard** entry in the
normal plan/handback/review: identify `java-testing` and the reference read,
the selected test boundary, and material deviations or unresolved conflicts.
Do not add a lengthy compliance report or claim adherence without reading the
reference and checking the work. For unrelated work, this policy is not applicable.
