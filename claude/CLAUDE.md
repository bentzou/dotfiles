# General Preferences

## Dev Workflow

- When making changes that can be verified in a browser, always surface the relevant local server URL (e.g. http://localhost:8000, http://localhost:5173) so the user can easily check the result.
- Repeatedly check whether the `main` branch (or the repo's default branch) has new commits upstream that aren't in the current working branch. Do NOT automatically pull or merge those updates. Instead, notify the user that new commits exist on `main` and offer to pull them in. A good cadence is at session start and before starting any significant new piece of work.

## Pull Request Descriptions

- Always begin a PR description with a plain-English section that captures, at a high level:
  1. **The problem** — a clear statement of the user or business problem being solved (not just a restatement of the code change).
  2. **The solution** — the approach taken to solve that problem, in conceptual terms.
  3. **The implementation** — a brief walkthrough of how the solution is realized in code (key files, functions, or design decisions).
- This opening section should be readable by someone without deep context on the codebase. Save technical details, checklists, and test plans for sections that come afterward.
