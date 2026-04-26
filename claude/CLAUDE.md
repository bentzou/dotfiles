# General Preferences

## Approach to New Tasks

- When given a prompt, do not start hacking immediately. First, evaluate the architectural fit of what's being asked: does the request align with the existing structure of the code, or does it imply something that would create awkward seams, duplicated responsibilities, leaky abstractions, or a worse overall shape than what exists? Read enough of the surrounding code to form a real opinion, not a guess.
- I care a lot about **extensibility**, **testability**, and **reliability**. Weigh proposed designs against these explicitly:
  - *Extensibility* — will the next reasonable change (new variant, new caller, new backend) fit cleanly, or require ripping things up? Prefer designs where adding is easier than editing.
  - *Testability* — can the behavior be exercised in isolation, with real-ish inputs, without heroic mocking? Avoid designs that are only verifiable end-to-end or that bake side effects into hard-to-reach places.
  - *Reliability* — what happens on the unhappy path (partial failure, retry, concurrent caller, bad input)? Prefer designs where failure modes are explicit and recoverable over ones that work great until they don't.
  - If the task as written trades these away for short-term convenience, flag it.
- If the task as stated would degrade the architecture, say so before writing code. Surface the concern, propose an alternative shape (or a small refactor that should land first), and let the user decide. It's fine to proceed with the user's framing once they've heard the tradeoff — the goal is to make the tradeoff visible, not to block on it.
- If the architecture looks fine for the task, say so briefly and proceed. Don't manufacture concerns to perform diligence; a one-line "the existing X handles this cleanly, going ahead" is enough.

## Dev Workflow

- When making changes that can be verified in a browser, always surface the relevant local server URL (e.g. http://localhost:8000, http://localhost:5173) so the user can easily check the result.
- Repeatedly check whether the current branch's **base branch** has new commits upstream that aren't yet in the current working branch. The base branch is whatever branch the current branch was created from — it may be `main`, `master`, `dev`, a release branch, another feature branch, or anything else. Do not assume a specific name; detect it dynamically (e.g. via `git rev-parse --abbrev-ref <branch>@{upstream}`, `git symbolic-ref refs/remotes/origin/HEAD`, the merge-base against likely candidates, or by asking the user if it's ambiguous). Do NOT automatically pull or merge those updates. Instead, notify the user that new commits exist on the base branch and offer to pull them in. A good cadence is at session start and before starting any significant new piece of work.

## Testing

- Default to test-driven development: write failing tests first, then implement to make them pass. If a task isn't a good fit for TDD (e.g. pure config changes, exploratory spikes, UI tweaks without a test harness), call that out explicitly rather than silently skipping tests.

## Pull Request Descriptions

- Always begin a PR description with a plain-English section that captures, at a high level:
  1. **The problem** — a clear statement of the user or business problem being solved (not just a restatement of the code change).
  2. **The solution** — the approach taken to solve that problem, in conceptual terms.
  3. **The implementation** — a brief walkthrough of how the solution is realized in code (key files, functions, or design decisions).
- This opening section should be readable by someone without deep context on the codebase. Save technical details, checklists, and test plans for sections that come afterward.
