---
name: system-walkthrough
description: Prepare evidence-based Marp system walkthroughs, overview decks, decision records and Mermaid architecture diagrams after analysis. Use only when these deliverables are requested.
---

# System walkthrough presentation

Use `system-analysis` first. Analysis is not permission to write reports.
Agree audience, scope, depth, format and exact destinations before generation.

## Narrative and slide architecture

Organize the explanation as a story, not a directory catalog:
1. Setting: users, problem, important system behavior and boundaries.
2. Context: actors and external systems, preferably a C4 context diagram.
3. Components: deployable units and relevant internal modules, with evidence.
4. Journeys: trace selected requests/jobs, including errors and trust boundaries.
5. Decisions: documented context → decision → consequences; label inference.
6. Working with the system: evidenced entry points, test/deployment workflow and constraints.
7. Risks and evolution: substantiated risks, unknowns and explicitly separate recommendations.

Use one concept per slide, diagrams before dense text, and grouped lists of
roughly seven items or fewer. Do not omit necessary qualifications to meet a
slide quota. Label overview/detail/appendix tiers and audience where useful.
Keep explanation, reference, tutorial and how-to content distinct; put deeper
evidence in presenter notes or an appendix. A short overview can reuse the
top-level story without duplicating all implementation detail.

## Marp source

Use Markdown frontmatter with `marp: true`, a title and `paginate: true`, with
`---` slide separators. Use standard fenced Mermaid blocks for C4, flowchart
and sequence diagrams. Do not assume the user's renderer supports Mermaid
without an appropriate integration; state that requirement rather than
installing tooling. Supply source only; no implicit HTML/PDF/PPTX export.

Architecture diagrams must match actual deployable units and dependency
direction. Include C4 code-level diagrams only on demand, not for every class.
Sequence diagrams should show real call paths and failures, not an imagined
ideal architecture.

## Evidence, decisions and validation

- Every material architectural/behavioral claim needs a `path:line`, commit SHA, ADR or actually read issue/PR reference; presenter notes may hold citations.
- Label inference and confidence. Do not manufacture motivations, considered alternatives, exact counts, coverage or quality scores.
- Re-check diagrams against code and deployment definitions. Distinguish observed repository state from live-system verification.
- For decision records, include context, decision, evidenced alternatives, consequences, evidence and confidence. Unknown alternatives remain unknown.
- Check narrative completeness, slide readability, scope, existing-file preservation and requested deliverables. Have the caller arrange independent review for non-trivial work when permitted.
- State missing evidence, stale reports, excluded areas, renderer prerequisites and commands not run.

If files are requested, the system-explorer agent restricts writes to approved
paths under `docs/walkthrough/`. JSON analysis is optional and should contain
scope, findings/evidence, methodology and unknowns, not a mandatory score.
