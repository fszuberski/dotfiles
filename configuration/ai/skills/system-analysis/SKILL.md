---
name: system-analysis
description: Evidence-based codebase SCAN and ANALYZE techniques. Use selectively for lightweight feature planning or more deeply for a requested system assessment; no presentations or writes by default.
---

# System analysis

Use the smallest analysis that answers the question. This skill does not grant
write, execution, delegation, network, or installation authority.

## Lightweight feature planning (default)

Perform these steps in the calling agent's own context:
1. Read applicable instructions, relevant docs/manifests, and existing changes.
2. Map the relevant modules, entry points, public behavior and dependency boundaries.
3. Trace the affected data/control flow through actual call sites and error paths.
4. Read representative tests, test configuration and verification commands. Identify the smallest observable acceptance seam and any baseline failures or side effects.
5. Identify likely change locations, affected callers, compatibility constraints and missing evidence. Spot-check each claim that the plan depends on.
6. Return a concise map, `path:line` evidence, constraints and open questions. No decks, report files, exhaustive metrics, or compulsory history mining.

Expand analysis only when the feature crosses an unexamined boundary. Do not
turn every planning step into a repository-wide audit. If scope grows materially,
explain why and agree the additional work with the user.

## Comprehensive SCAN and ANALYZE

For an explicitly requested assessment, read `references/analysis-layers.md`
and select the relevant layers. Inventory source separately from vendored,
generated and build output. State scope, exclusions and unavailable evidence.
Use bounded file/history reads before deciding whether deeper tooling is worth
the cost. Inspect scripts and get approval before executing tools with side
effects; do not install dependencies as part of analysis.

Every claim must be marked as documented, directly observed, inferred (with
confidence), measured (with method/window), estimated, or unknown. Cite actual
files/lines, commit SHAs, ADRs, or sources you read. Never fabricate coverage,
complexity, architecture rationale, performance impact or quality scores.

Return findings in the caller's requested format. This skill intentionally
contains no narration, slide generation or file-writing phase.
