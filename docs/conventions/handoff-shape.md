# Structured human handoff shape

When work cannot continue, replace vague status messages with this structure in the mail body, bead notes, or escalation text. The goal is actionable context: what was assumed, what must be decided, and how execution resumes.

## Required sections

Use these exact Markdown headings in the handoff body so humans and tools can scan consistently.

| Heading | Purpose |
| --- | --- |
| `## Assumptions Made` | What you assumed to proceed as far as you did. List them; they may be wrong. |
| `## Questions for Human` | Specific, answerable questions. Not "what should I do?" Example: "Should the retry limit be 3 or 5? The API docs do not specify a rate limit." |
| `## Impact if Assumptions Wrong` | What breaks or misleads if section 1 is incorrect. Helps prioritize which questions to answer first. |
| `## Proposed Revision Plan` | What you will do differently once you have answers. Shows a path forward; the handoff is not a dead end. |
| `## Current State` | Completed, in progress, and untouched work. Include branch name, last commit (hash or message), and modified file paths. |

### Template

```markdown
## Assumptions Made

- …

## Questions for Human

1. …

## Impact if Assumptions Wrong

- …

## Proposed Revision Plan

- …

## Current State

- Completed: …
- In progress: …
- Untouched: …
- Branch: …
- Last commit: …
- Files modified: …
```

## When to use

- `gt done` with incomplete work
- `bd update <id> --status blocked`
- Handoff mail: `gt mail send mayor/ -s "HANDOFF: ..."`
- `gt escalate`

## Anti-patterns

- "I'm stuck" with no context
- "Need human input" without specific questions
- Assumptions only in narrative prose instead of an explicit list
- No revision plan (handoff reads as giving up)
- Omitting current state so the next agent cannot resume

## See also

- Short injectable summary: `/gt/settings/handoff-convention.md`
