# General Preferences

## Dev Workflow

- When making changes that can be verified in a browser, always surface the relevant local server URL (e.g. http://localhost:8000, http://localhost:5173) so the user can easily check the result.
- Repeatedly check whether the current branch's **base branch** has new commits upstream that aren't yet in the current working branch. The base branch is whatever branch the current branch was created from — it may be `main`, `master`, `dev`, a release branch, another feature branch, or anything else. Do not assume a specific name; detect it dynamically (e.g. via `git rev-parse --abbrev-ref <branch>@{upstream}`, `git symbolic-ref refs/remotes/origin/HEAD`, the merge-base against likely candidates, or by asking the user if it's ambiguous). Do NOT automatically pull or merge those updates. Instead, notify the user that new commits exist on the base branch and offer to pull them in. A good cadence is at session start and before starting any significant new piece of work.

## Pull Request Descriptions

- Always begin a PR description with a plain-English section that captures, at a high level:
  1. **The problem** — a clear statement of the user or business problem being solved (not just a restatement of the code change).
  2. **The solution** — the approach taken to solve that problem, in conceptual terms.
  3. **The implementation** — a brief walkthrough of how the solution is realized in code (key files, functions, or design decisions).
- This opening section should be readable by someone without deep context on the codebase. Save technical details, checklists, and test plans for sections that come afterward.
