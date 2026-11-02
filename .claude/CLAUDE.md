# Agent Instructions

## Code structure

Code should be structured for readability. Humans still review code, so it should be easy to follow.

- Variable names should describe what the variable holds and how it is used, but stay short.

## Code comments

Comment the non-obvious only: the why, a surprising constraint, a workaround, a gotcha the code cannot express. Never restate what the code already says.

A comment can explain the right _why_ and still be wrong. Avoid these:

- Over-length. One or two lines by default. A docblock past ~6 lines needs a reason to exist; longer rationale belongs in the ticket or PR.
- Repetition. State each rationale once. When two files share a _why_, put it in the canonical one and point at it (`see Foo.bar above`).
- Paraphrasing the identifier. `/** Start of the term the document describes. */` above `documentTermBegin` is noise. If a field needs a comment to be understood, rename the field.

## Git

- Never use `--force` or `--no-verify`.
- Use Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`).
- PR titles and commit messages: direct, human-readable summary of the full diff, no tool prefix such as `[codex]`.

### Pull request descriptions

Keep it short and descriptive: what changed and why it is needed, nothing more. Reviewers should understand the shape of the PR in ~15 seconds. Use bullet points, not prose paragraphs.

- Summary — one short paragraph of _why_, then one bullet per surface/area changed, each opening with a bold label. Keep it well under a screen. A bullet needing a second sentence is ticket material.
- If there is a UI change, add a before/after Markdown table with screenshots so it is easy to review.

## Plan Mode

- Make the plan extremely concise. Sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.

@RTK.md
