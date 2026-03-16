# Causes — Claude instructions

## Markdown style

All `.md` files use **sentence-per-line** formatting:
one sentence per line, blank lines between paragraphs.
This keeps diffs small and reviewable.
List item continuation sentences are indented to align with the list marker.

## Commit discipline

Each commit must do exactly one thing.
Commits must pass all linting and tests before being made.
Commits are kept strictly small: **400–500 lines maximum** (diff lines added + removed).
If a change is larger, split it into a sequence of focused commits.

## Git workflow

Work on feature branches and merge via pull request.
The master branch is protected: the `build` CI job must pass and all merges go through the merge queue (Merge mode — creates a merge commit).

Keep feature branches up to date using **rebase, never merge**:

```sh
git fetch origin
git rebase origin/master
```

This preserves a clean, linear commit history within each PR so the merge commit added by the queue stands out clearly.
