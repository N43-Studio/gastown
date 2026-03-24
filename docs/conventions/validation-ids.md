# Validation IDs (Gas Town Agent Protocol)

Stable IDs for validation checks so surfaces can compare results and automation can parse pass/fail reliably.

## ID Format

`GT-NNN` where NNN is a zero-padded number. IDs are permanent: never reused or renumbered.

## Registry

### Agent Startup (GT-001 to GT-099)

| ID | Check | Pass condition |
|----|-------|----------------|
| GT-001 | Environment variables | `GT_ROLE`, `GT_RIG`, `GT_ROOT` are set |
| GT-002 | gt CLI available | `gt --version` exits 0 |
| GT-003 | bd CLI available | `bd --version` exits 0 |
| GT-004 | Hook assignment | `gt hook` shows assigned work |
| GT-005 | Rig access | `gt rig list` succeeds |
| GT-006 | Beads access | `bd stats` succeeds |
| GT-007 | Prime context | `gt prime` output includes role header |

### Work Completion (GT-100 to GT-199)

| ID | Check | Pass condition |
|----|-------|----------------|
| GT-100 | Completion notes present | Bead has non-empty notes field |
| GT-101 | Outcome field | Notes contain `outcome:` line with valid enum |
| GT-102 | Validation dimensions | Notes contain at least one `validation.*:` line |
| GT-103 | Summary present | Notes contain non-empty `summary:` line |
| GT-104 | Artifacts present | Notes contain at least one `artifacts.*:` line |
| GT-105 | Git state clean | `git status` shows no uncommitted changes in worktree |

### Handoff Quality (GT-200 to GT-299)

| ID | Check | Pass condition |
|----|-------|----------------|
| GT-200 | Assumptions section | Handoff contains `## Assumptions Made` |
| GT-201 | Questions section | Handoff contains `## Questions for Human` |
| GT-202 | Impact section | Handoff contains `## Impact if Assumptions Wrong` |
| GT-203 | Revision plan | Handoff contains `## Proposed Revision Plan` |
| GT-204 | Current state | Handoff contains `## Current State` |

### Communication (GT-300 to GT-399)

| ID | Check | Pass condition |
|----|-------|----------------|
| GT-300 | Mail delivery | `gt mail send` exits 0 |
| GT-301 | Mail receipt | `gt mail inbox` shows expected message |
| GT-302 | Nudge delivery | `gt nudge` exits 0 |

### Infrastructure (GT-400 to GT-499)

| ID | Check | Pass condition |
|----|-------|----------------|
| GT-400 | Dolt server running | `gt dolt status` shows running |
| GT-401 | Dolt databases verified | All databases pass verification |
| GT-402 | No orphan databases | `gt dolt cleanup --dry-run` shows 0 orphans |

## Reporting Format

Validation results should be reported as:

```
GT-001: PASS  Environment variables set
GT-002: PASS  gt CLI v0.42.0
GT-003: PASS  bd CLI v0.51.2
GT-004: FAIL  No work on hook
GT-005: PASS  5 rigs listed
```

One line per check. `PASS`, `FAIL`, or `SKIP` followed by a short detail string.

## Rules

- IDs are append-only. Never remove or renumber.
- `SKIP` means the check was not applicable (e.g., GT-105 when no code was changed).
- New checks get the next available ID in their range.
- Ranges can be extended (GT-500+) for project-specific checks.
