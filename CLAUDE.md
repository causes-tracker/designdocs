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

We use [Jujutsu (`jj`)](https://github.com/jj-vcs/jj) for local version control.
`jj` layers over Git transparently — GitHub, CI, and the merge queue are unaffected.

The master branch is protected: the `build` CI job must pass and all merges go through the merge queue (Merge mode).

**Key concepts:**

- `@` is the working copy change — edits are tracked automatically, no staging area.
- Bookmarks are `jj`'s name for Git branches.
- `jj undo` safely reverses any operation.

**Starting new work:**

```sh
jj git fetch
jj new master -m "what you're doing"
# edit files — changes are part of @ immediately
jj describe -m "final message"        # refine when ready
```

**Opening a PR:**

```sh
jj bookmark create <name> -r @
jj git push -b <name>
gh pr create ...
```

**Keeping a branch up to date with master (never merge):**

```sh
jj git fetch
jj rebase -d master
jj git push -b <name> --force-with-lease
```

**Useful commands:**

```sh
jj log       # graph of changes
jj diff      # what changed in @
jj squash    # fold @ into its parent
```
