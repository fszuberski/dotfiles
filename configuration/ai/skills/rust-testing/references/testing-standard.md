# Rust testing standard

## Scope and terminology

These rules define the testing standards and preferred practices for Rust
projects. Verify changes at appropriate testing levels; not every change needs
a test at every level.

- **Must** identifies a requirement.
- **Should** or **prefer** identifies a preferred approach, not an absolute
  requirement. Case-based tests and nested modules are strong preferences;
  use them where applicable and explain meaningful departures during review.
- **May** identifies an optional approach.

Tests should establish observable behavior, not incidental implementation
details. Choose a boundary that provides confidence without unnecessary
complexity. Existing repository requirements and authorized scope remain binding.

## Testing levels and Rust's test layout

### Unit tests

Verify a cohesive behavior without external infrastructure or services. A unit
may be a function, a type, or a small group of collaborating components.

Prefer real, lightweight in-process collaborators. Replace infrastructure and
external-service boundaries with appropriate stubs, fakes, or mocks. Avoid
mocking internal collaborators solely to verify implementation details, and do
not introduce traits or dynamic dispatch everywhere just to enable mocking.
Use existing seams or small behavior-appropriate boundaries.

For example, exercise checkout with the real pricing logic and a fake discount
repository rather than mocking the pricing calculation itself. Verify the
returned order total or persisted business result, not an incidental sequence
of internal calls. Interaction assertions are appropriate when the interaction
itself is part of the required behavior.

Place implementation-local tests in `#[cfg(test)] mod tests` near the relevant
code when that matches project conventions. Access to private items is useful,
but is not a reason to couple assertions to implementation details.

### Integration tests

Verify components across a real integration boundary: for example, a repository
against its database, a client against a protocol-compatible server, or a full
application vertical slice.

Prefer real infrastructure where practical. A mocked database client cannot
establish actual database compatibility. Container-based infrastructure, such
as the project's existing `testcontainers` setup, is useful for supported
services. Use suitable substitutes for dependencies outside the chosen
boundary; containers do not replace every test double.

Cargo calls files under `tests/` integration tests because they compile as
separate crates using the library's public API. Such a test can still exercise
only pure, in-process behavior. Distinguish this layout from the behavioral
integration level when describing coverage.

Prefer `tests/` for public-API tests and cross-component scenarios where useful.
Group shared support under a module such as `tests/common/mod.rs` rather than
an accidental standalone test target.

### Acceptance tests

Establish that agreed acceptance criteria are satisfied. Acceptance describes
what is established, not a mandatory execution boundary: unit, public-API,
infrastructure integration, or E2E tests may provide the needed evidence.

ATDD does not require an E2E test for every change. Use executable BDD scenarios
only when they add value or are an established project convention.

### End-to-end tests

Exercise selected critical journeys through the deployed system or subsystem
from its external API or UI through relevant services and infrastructure.
Cover happy paths and critical edge cases; prefer unit and integration tests
for detailed edge-case matrices. Use realistic test data without copying
secrets or sensitive production records.

### Doctests and compile-time contracts

Use doctests for small public-API examples that should remain valid. Prefer
executable examples over `ignore` or `no_run` when execution is practical;
use those attributes only when the example genuinely needs that limitation.

Use `compile_fail` doctests or existing compile-test tooling when rejection by
the compiler is the behavior being documented or verified. Do not add a
compile-test framework solely to test ordinary runtime errors.

## Rust conventions

### Given/When/Then phase comments

Newly written or modified Rust tests **must** include short, scenario-specific
phase comments:

- `// given: ...` describes relevant preconditions.
- `// when: ...` describes the action under test.
- `// then: ...` describes the observable outcome.

Bare labels are insufficient. Describe intent, not mechanical steps such as
constructing a value or calling a method. When an assertion also executes the
action, use a descriptive combined `// when/then: ...` comment. Do not split
code artificially or rewrite unrelated tests solely to add comments.
Fixture helpers do not require phase comments.

### Strongly prefer case-based tests for equivalent scenarios

Use case-based tests by default when inputs or expected results vary but the
behavior, setup, and assertions are equivalent. Prefer separate tests when
combining materially different scenarios would obscure intent.

Use a small table-driven loop when it is clear and needs no new dependency.
Include the case inputs or a case label in assertion diagnostics. If the
project already uses a parameterization crate such as `rstest`, prefer its
established conventions where appropriate; separately reported cases can
improve failure isolation. Do not add a dependency merely for this preference.

The examples below use a fictional shopping application. Imports, fixture
helpers, and production implementations are omitted; these are illustrations,
not complete runnable files. `random_shopping_cart()` produces a valid cart;
`add_item(&str)` returns `Result<(), CartError>` and rejects empty or
whitespace-only IDs.

```rust
#[test]
fn should_reject_item_given_blank_id() {
    for item_id in ["", " ", "\t"] {
        // given: a valid cart and an empty or whitespace-only item ID
        let mut cart = random_shopping_cart();

        // when: the blank item ID is added
        let result = cart.add_item(item_id);

        // then: each blank ID is rejected as an invalid item
        assert!(
            matches!(result, Err(CartError::InvalidItemId)),
            "expected invalid-item error for {item_id:?}"
        );
    }
}
```

Do not translate Java null cases mechanically: use `None` only when the Rust
API actually accepts an `Option`, and test invalid values representable by the
real type contract.

### Strongly prefer nested modules for related behavior

Group related tests by cohesive behavior using nested modules, rather than
recreating JUnit classes or shared mutable setup. Prefer a flat module when
nesting adds ceremony without improving readability.

```rust
#[cfg(test)]
mod tests {
    use super::*;

    mod add_item {
        use super::*;

        #[test]
        fn should_contain_item_given_valid_id() {
            // given: a cart containing item-2 and no other items
            let mut cart = random_shopping_cart();
            cart.item_ids = vec!["item-2".to_owned()];

            // when: item-1 is added to the cart
            let result = cart.add_item("item-1");

            // then: the addition succeeds and the cart contains both items
            assert!(result.is_ok());
            assert_eq!(cart.item_ids, vec!["item-2", "item-1"]);
        }
    }
}
```

This fictional cart preserves insertion order. For an unordered collection,
assert set membership or compare normalized values instead of imposing an
ordering contract.

### Test naming

Use snake-case names describing the expected outcome and relevant condition:

`should_<expected_outcome>_given_<precondition>`

Examples: `should_reduce_order_total_given_customer_discount` and
`should_reject_item_given_blank_id`. Prefer observable outcomes over names
describing internal steps. Follow justified existing project conventions.

### Assertions and errors

Assert relevant values and error variants. Prefer `assert_eq!`, `assert!`,
`matches!`, or the project's existing assertion library over boolean checks
with unhelpful diagnostics.

For expected failures, assert the relevant `Err` variant and fields rather
than merely `is_err()`. Do not assert debug formatting or full error prose
unless that text is part of the contract.

For expected success, `expect` with a useful message or a test returning
`Result` can keep setup clear. Propagating an error alone does not verify the
successful result's behavior. Use `#[should_panic]` only when panic is the
intended contract, not as a substitute for checking ordinary `Result` errors.

## Fixtures and test models

Prefer fresh, valid fixtures per test. Keep scenario-specific inputs explicit
while preserving intentional semi-random variation in unrelated fields, such
as `random_shopping_cart()`. Do not replace these fixtures with deterministic
data or mandatory seeds merely to satisfy a blanket preference for determinism.
Investigate concrete failures and constrain relevant fields as needed.

Property-based testing is a separate technique: use it when invariants or
input spaces justify it, and preserve the tool's shrinking and failure-replay
information. Do not require it for every behavior or confuse it with fixture
variation.

Use helper functions or builders that produce production types when enough.
When separate test data models are useful, prefer recognizable names such as
`OrderData`; do not mandate wrapper types, `Default`, or trait implementations
only for tests. Group support in test-local modules such as `tests::data` or
`tests/common`, respecting the crate's existing structure. Keep test-only
dependencies in dev-dependencies where appropriate.

## Parallel execution and resource isolation

Tests **must** be parallelizable without interfering with one another.
Shared external resources need unique per-test data or namespaces, isolated
temporary directories, and non-conflicting endpoints. Pure tests with no
shared mutable state do not need artificially unique input values.

Avoid process-wide environment, working-directory, global-state, or tracing
subscriber mutations in concurrently executing tests. Prefer explicit inputs,
per-test handles, or subprocess isolation where the behavior requires a real
process environment. A lock owned by one test module does not coordinate
unrelated tests. Serial execution is not a substitute for fixing isolation;
surface unavoidable project constraints rather than silently disabling
parallelism.

Release owned resources and clean up test-owned infrastructure. Prefer scoped
ownership and RAII where effective; asynchronous cleanup may require explicit
awaited teardown. Do not delete shared or unrelated data during cleanup.

## Async behavior

Use the project's runtime and async test conventions. Do not introduce Tokio,
another runtime, or a multi-threaded runtime solely for a synchronous test.
Exercise multi-threaded execution when the behavior under test requires it.

Synchronize with explicit events, channels, or observable conditions rather
than fixed sleeps. Use bounded waits for potentially hanging operations.
Use the runtime's controlled clock where available and appropriate; account
for real I/O that a paused clock does not control.

Tests must own their spawned work: observe relevant task results, terminate
and await remaining test-owned tasks, and close resources before completion.
Dropping a task handle is not generally cancellation, and detached background
work can leak state or hide failures.

## Tools and verification

Prefer Rust's built-in test harness, assertions, and doctests as the starting
point. Existing justified project tooling takes precedence; do not install or
migrate dependencies solely to match this list.

| Purpose | Default or optional tooling |
| --- | --- |
| Unit and public-API tests | Built-in `#[test]` and assertion macros |
| Equivalent cases | Table-driven cases; existing `rstest` or similar tooling |
| External-boundary doubles | Small fakes/stubs; existing mocking tooling such as `mockall` where useful |
| Real infrastructure | Existing container/service fixtures; `testcontainers` where practical |
| Async tests | Existing runtime's test support |
| Properties | `proptest` or similar when invariant testing adds value |
| Public examples and compile rejection | Doctests; existing compile-test tooling for richer cases |

Choose verification commands from the actual workspace, features, targets,
runtime, and available infrastructure. `cargo test` is a starting point, not
proof that every workspace member or feature combination was exercised.
Select package/workspace, target, and feature flags deliberately; do not
blindly use `--all-features` when features are incompatible. Remember doctests
when relevant: a target-specific run such as `cargo test --tests` does not
replace `cargo test --doc`.

Respect authorization and repository prohibitions on adding tests, dependency
changes, execution, or infrastructure startup. Report actual commands,
coverage boundaries, skipped checks, and limitations without claiming more
than the evidence supports.
