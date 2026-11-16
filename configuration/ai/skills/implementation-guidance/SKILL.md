---
name: implementation-guidance
description: "Shared development guidance for TDD and task-directed implementation: respect existing architecture, default to pragmatic hexagonal architecture when absent, develop tracer-bullet slices, preserve scope, and verify honestly."
---

# Shared implementation guidance

Read this self-contained skill before implementing or choosing an architecture.
It applies to both `atdd-developer` and `developer`. It does not prescribe test
order: the assigned role determines whether strict TDD is required. Repository
instructions, user requirements, phase ownership, and native permissions remain
binding. Do not use this skill to grant yourself more authority.

## Architectural default: hexagonal architecture

When the project has no clearly established architecture and the caller has not
specified one, default to hexagonal architecture—ports and adapters—following
*Get Your Hands Dirty on Clean Architecture*, 2nd edition, by Tom Hombergs.

- Inspect before choosing. Read architecture documentation, ADRs, dependency boundaries, and representative code. A coherent architecture expressed in code counts even without documentation.
- Respect existing architecture. Follow an established pattern rather than introducing a competing one. If documentation and implementation conflict materially, return the conflict to the caller rather than silently choosing or migrating.
- Keep business logic inside. Domain behavior should remain independent of web, persistence, and infrastructure concerns. Application use cases coordinate that behavior.
- Make boundary ownership explicit. Incoming ports express application capabilities; outgoing ports express external capabilities the application needs. Inbound adapters invoke incoming ports; outbound adapters implement outgoing ports. Source dependencies point inward.
- Map deliberately. Keep transport and persistence representations from dictating domain and use-case contracts. Introduce mappings where boundaries justify them, not mechanically for every layer.
- Stay pragmatic. Treat the book as design guidance, not a requirement to copy its example framework, package structure, or every abstraction. Do not create an interface for every class or add speculative adapters and modules.
- Develop incrementally. Combine this default with tracer bullets and the assigned development/testing mode: establish the smallest working path through necessary boundaries, then evolve it. Do not scaffold an entire architecture before delivering behavior.
- Preserve scope. Do not restructure unrelated code. If establishing the architecture requires work beyond the authorized step, return a proposal to the caller.
- Briefly identify whether the step follows an existing architecture or introduces this default, including relevant boundaries.

## Tracer-bullet development

Use tracer-bullet development as described in *The Pragmatic Programmer* by
David Thomas and Andrew Hunt: build a narrow, working path that provides early
feedback on the design and integration, then evolve that working code.

- Within the authorized step, start with the thinnest meaningful slice through relevant layers, rather than implementing entire layers separately.
- Prefer a representative path that tests important assumptions or uncertain boundaries early. Use real wiring for the boundaries being validated; mocks must not conceal the integration the slice is intended to prove.
- Follow the assigned testing mode. `atdd-developer` must evidence RED/GREEN and honor explicit REFACTOR ownership. `developer` chooses coverage according to the task, repository requirements, risk, and user instructions; it need not manufacture a failing run. Tracer bullets determine development order, not permission to weaken either role's contract.
- Keep the code as part of the evolving implementation. This is not a disposable prototype, and temporary shortcuts must not compromise correctness or safety.
- Expand the working slice until the authorized acceptance criteria are satisfied. An initial tracer bullet is not sufficient grounds to declare the step complete.
- Stay within scope. If a useful tracer bullet requires additional work, return that proposal to the caller rather than expanding the task yourself.
- Scale the approach to the change: a local library behavior does not require constructing an artificial full-stack path.

## Correctness, tests, and evidence

- Inspect applicable instructions, relevant code/consumers, existing changes, and baseline failures before editing. Preserve other people's work and coordinate if the baseline changes unexpectedly or another worker is still active.
- Implement minimal correct behavior, not unsafe shortcuts, hardcoded fixture answers, disabled assertions, or mocked-away behavior merely to obtain green output. Preserve public and error contracts unless the task explicitly changes them.
- Select verification at a useful behavior boundary. Acceptance criteria do not automatically require an E2E harness or a test at every level. Use property-based, contract, snapshot/golden-master, or walking-skeleton techniques only where the behavior and existing infrastructure justify them.
- For Java testing decisions, independently load `java-testing` and read its full reference. Preserve intentional semi-random fixtures, strong parameterized/nested-test preferences, real lightweight internal collaborators, and justified project-specific alternatives. Preferred tooling is not mandatory tooling.
- Respect prohibitions on tests and dependency changes. A task-directed developer may work without new tests when permitted; a strict TDD developer must return the conflicting requirement, not silently switch modes.
- Run applicable agreed checks with required approval. Inspect unfamiliar commands and their side effects first. Separate pre-existing failures from new regressions, disclose checks not run, and never claim verification based only on another agent's report.
- Keep cleanup small and behavior-preserving. Do not do substantial untested refactoring, broad migrations, or material test redesign as incidental implementation work. Return optional improvements separately when another worker owns REFACTOR.
- Report actual commands, exit status, relevant output, files changed, acceptance coverage, and limitations. Never fabricate RED evidence, timings, quality ratios, commit counts, or complexity scores.
