# Completion report convention

Polecats attach a **structured completion report** to a bead’s **`notes`** field immediately before closing it (`bd close`). The report is plain text: one `key: value` per line, no JSON or YAML nesting, so tools can parse it with `grep`, `awk`, or similar.

Convention reference: Gas Town “Structured completion artifacts” task.

## Format rules

- One field per line: `key: value` (space after colon is recommended).
- Keys use dot notation for subsections (for example `validation.tests`).
- Lines that are not part of the report (freeform prose) are discouraged inside the notes block; keep the report self-contained.
- **Parse check:** `grep '^outcome:' notes.txt` must match exactly one logical outcome line.

## Required fields

Every completion report must include all keys below. Values are a single line each (no line breaks inside a value).

### `outcome`

Terminal state of the work. Value must be exactly one of:

- `success` — Delivered as intended.
- `partial` — Some deliverables or checks incomplete; document in `summary`.
- `failure` — Did not complete; explain in `summary`.
- `blocked` — Could not proceed (external dependency, missing access, etc.).
- `deferred` — Intentionally left for later (link or reason in `summary` if helpful).

Example: `outcome: success`

### `validation` (dimensions)

All four lines are required. Each value must be exactly one of `pass`, `fail`, or `skipped`:

| Key | Meaning |
|-----|---------|
| `validation.tests` | Did tests pass? |
| `validation.lint` | Did linting pass? |
| `validation.build` | Did the build succeed? |
| `validation.typecheck` | Did type checking pass? |

Use `skipped` when that check did not apply (for example, docs-only change: `validation.build: skipped`).

### `artifacts` (evidence)

All three lines are required:

| Key | Meaning |
|-----|---------|
| `artifacts.commit_hash` | Git commit SHA if code changed; otherwise `skipped` or `none`. |
| `artifacts.pr_url` | Pull request URL if a PR was opened; otherwise `skipped` or `none`. |
| `artifacts.files_changed` | Non-negative integer (0 if no files changed). |

### `metrics`

| Key | Meaning |
|-----|---------|
| `metrics.duration_minutes` | Wall-clock minutes spent on the bead (integer). |

### `summary`

One or two sentences describing what was done and any important caveats. The value after `summary:` must not be empty.

## Example

```
outcome: success
validation.tests: pass
validation.lint: pass
validation.build: skipped
validation.typecheck: pass
artifacts.commit_hash: abc1234
artifacts.pr_url: https://github.com/org/repo/pull/42
artifacts.files_changed: 5
metrics.duration_minutes: 23
summary: Implemented retry logic for API calls with exponential backoff.
```

## Workflow reminder

1. Finish work and run checks.
2. `bd update <id> --notes="$(cat report.txt)"` (or paste equivalent), **or** build notes in the shell with a here-document.
3. `bd close <id> --reason "..."`.

Closing without a structured report breaks automation that audits completions (for example the Deacon `completion-audit` plugin).
