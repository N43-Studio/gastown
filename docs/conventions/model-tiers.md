# Model tier routing convention

Gas Town rigs route work to language models by **capability tier**, not by hardcoding vendor model names. Operators map each tier to a concrete model in rig settings. This document defines the tiers, default tier expectations by Gas Town role, configuration shape, formula integration, and cost guidance.

Tiers describe **task classes**; model IDs live in configuration only.

## Tier definitions

| Tier | Capability | Use for |
|------|------------|---------|
| premium | Highest reasoning, architecture, security review | Orchestration, cross-rig coordination, architecture decisions, PR review, security audit |
| balanced | Good reasoning, efficient | Implementation from spec, feature work, bug fixes, refactoring |
| fast | Speed-optimized, lower cost | Validation, linting, formatting, simple queries, health checks |

## Mapping to Gas Town roles

These defaults are **policy guidance** for operators choosing tier-to-model mappings. Actual models are always set in `config.json` (see below).

| Role | Default tier | Rationale |
|------|--------------|-----------|
| mayor | premium | Coordination requires high-context reasoning |
| witness | fast | Monitoring is procedural, low-reasoning |
| refinery | balanced | Merge review needs good judgment but is bounded |
| polecat (code) | balanced | Implementation work |
| polecat (review) | premium | Code review needs deep reasoning |
| dog | fast | Plugin execution is scripted |

## Configuration

Tiers are configured via rig settings, not hardcoded. Values are **concrete model identifiers** (whatever your provider uses); the tier names (`premium`, `balanced`, `fast`) are the conceptual labels you assign when documenting or choosing models.

Per-rig example:

```json
// ~/gt/<rig>/settings/config.json
{
  "role_agents": {
    "polecat": "balanced-model-name",
    "witness": "fast-model-name",
    "refinery": "balanced-model-name"
  }
}
```

Town-level defaults live in `~/gt/settings/config.json` and are overridden per rig when the same keys are set under `~/gt/<rig>/settings/config.json`.

Extend or mirror this pattern for any setting surface your rig uses to bind **roles or task classes** to models, as long as the binding remains configuration-driven.

## Formula integration

Formulas can expose tier choice as a variable so steps declare how much reasoning they need:

```toml
[vars.model_tier]
description = "Model capability tier for this step"
required = false
default = "balanced"
```

Steps that need premium reasoning (architecture, review) should declare it explicitly. Execution-oriented steps should default to **balanced** unless they are trivially procedural (then **fast** is appropriate).

## Cost awareness

- Track token usage in completion reports; see [completion-report.md](./completion-report.md) for the structured notes convention.
- Using **premium** for validation, linting, or formatting is usually waste; prefer **fast**.
- Using **fast** for architecture, security, or deep review is risky; prefer **premium**.
- When unsure, **balanced** is the safe default.
