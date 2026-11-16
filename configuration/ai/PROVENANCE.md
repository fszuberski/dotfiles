# Provenance

The custom agent names intentionally omit the `alf-` prefix.

The system exploration, presentation, concurrency, and acceptance-test-driven
development techniques were adapted and corrected from the local checkout at
`~/code/claude-code-agents`, revision
`a5c8cb89a6b5afcad009456d1a7c552006e172a9`:

- `alf-system-explorer/alf-system-explorer.md`
- `alf-system-explorer/skills/system-walkthrough/analysis-pipeline.md`
- `alf-system-explorer/skills/system-walkthrough/narrative-structure.md`
- `alf-system-explorer/skills/system-walkthrough/slide-architecture.md`
- `alf-system-explorer/skills/system-walkthrough/code-validation.md`
- `alf-system-explorer/skills/system-walkthrough/comprehension-models.md`
- `alf-concurrency-analyzer/alf-concurrency-analyzer.md`
- `alf-atdd-developer/alf-atdd-developer.md`

The remaining prompts incorporate the user's local-config, TDD orchestration,
and adversarial-review sketches. These are maintained adaptations, not an
automatic upstream mirror. No dependency on the ALF installer or additional
ALF agents remains. Missing upstream skills were reorganized as portable
`SKILL.md` packages; scores and metrics without defensible evidence were removed.

No top-level license file was present in the inspected local ALF checkout.
This provenance record is not a license grant; confirm upstream reuse terms
before redistributing adapted material.

## Platform references

Implementation was checked against OpenCode v2.2.7 and Claude Code 2.1.325,
using the current official documentation:

- <https://opencode.ai/docs/agents>
- <https://opencode.ai/docs/permissions>
- <https://opencode.ai/docs/config>
- <https://opencode.ai/docs/skills>
- <https://opencode.ai/docs/instructions>
- <https://code.claude.com/docs/en/sub-agents>
- <https://code.claude.com/docs/en/hooks>
- <https://code.claude.com/docs/en/memory>

Compatibility decisions and limitations are documented in `README.md` beside
this file. Changes to platform semantics should be made in the corresponding
adapter rather than by forking shared prompt bodies.
