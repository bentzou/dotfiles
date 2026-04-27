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

## Code Design

- **Test at multiple levels.** For anything you build, write tests at more than one scope — e.g. unit tests for individual functions/modules plus larger-scope tests (integration, end-to-end, or feature-level) that exercise how the pieces fit together. A single level of coverage is not sufficient.
- **Reflect on whether the change is a hack.** Before finalizing any change, explicitly ask: is this a hack? A hack is a local patch that makes the symptom go away without addressing what the problem actually reveals about the system. When you notice one, stop and think broadly about what ideal architecture the problem is pointing toward, then either implement that or surface the tradeoff to the user. Do not silently ship hacks.
- **Treat extensibility and testability as first-class concerns.** When designing or modifying code, explicitly evaluate how easy it will be to (a) extend with new cases or requirements, and (b) test in isolation. If the design makes either hard, flag it and consider alternatives — don't defer these concerns to "later."

## Testing

- Default to test-driven development: write failing tests first, then implement to make them pass. If a task isn't a good fit for TDD (e.g. pure config changes, exploratory spikes, UI tweaks without a test harness), call that out explicitly rather than silently skipping tests.

## Git Workflow

- Work on **feature branches**, not directly on the base branch. If we're sitting on `main`/`master`/`dev` when non-trivial work begins, cut a branch first.
- Aim for **reasonably chunked commits**: each commit should represent a coherent unit of change with a message that explains the *why*. Don't lump unrelated changes together; don't atomize trivially either. If a session has produced a sprawling pile of edits, propose a sensible commit breakdown rather than dumping it all into one commit.
- **Do not push until asked.** Local commits are fine and encouraged; pushing to a remote is a user-initiated action.
- When opening a PR, **start it as a draft** unless the user says otherwise. The user will mark it ready when they're satisfied.
- **Force push requires explicit confirmation from the user, every time.** Even on a feature branch the user owns, even after a rebase, even if it seems obviously safe — ask first. Never force-push to a shared/base branch.

## Pull Request Descriptions

- Follow the **conventions of the current project** first (look for `.github/PULL_REQUEST_TEMPLATE.md`, recent merged PRs, or repo docs). In the absence of a project convention, fall back to sensible defaults (summary, test plan, screenshots if UI, links to related issues).
- On top of whatever convention applies, **always begin the description with a plain-English summary** at the very top — readable by someone without deep context on the codebase. It should make the *problem*, the *approach*, and (briefly) *how it's implemented* legible without reading the diff. Technical details, checklists, and test plans come after.

## Session Naming

- When Claude Code generates or updates a session topic name, always prefix it with the base name of the current working directory followed by an em dash, then a short description of the work being done.
- Format: `{dir-basename} — {short work description}`.
- Examples:
  - `p3 — tenancy spec iteration`
  - `p3 — agent runtime refactor`
  - `ploy-site — blog redesign`
  - `.claude — hook debugging`
- Keep the description concise (3–6 words). Update it as the session's focus shifts so the name always reflects the current work, not just the initial prompt.
- The base name is the last path segment of `pwd` (e.g. `/Users/bentzou/Code/ploy/p3` → `p3`).
