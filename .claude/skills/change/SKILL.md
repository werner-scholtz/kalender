---
name: change
description: Takes a kalender change from a branch to a pull request the owner can review from its summary. Use for any feature, fix, refactor or docs change to the package, including an issue to fix or a work package from a progress file.
---

# Change

The owner reads a short review block on the pull request, not the whole diff, so the block has to be true. Everything below feeds it.

## Steps

1. Read `AGENTS.md` and the `<version>-progress.md` file for the release the change belongs to, when there is one.
2. Branch from `main`, or from the branch below in a stack: `<type>/<short-name>` with the commit types from `AGENTS.md`.
3. Make the change with its tests and the changelog line. The first change of a release adds the `## <version>` heading. A breaking change gets its migration section and data-driven fix.
4. Run `dart tool/check.dart --quick` until it passes. Commit.
5. Review round one. Start the `reviewer` agent with the base ref, the head ref and the summary you will put on the pull request. Do not pass your reasoning, the issue thread or this conversation. Fix every finding you agree with, commit, and answer the ones you do not in the left-on-purpose list with one line of reason each. One more round at most. Whatever is open after round two stays in the list.
6. Run `dart tool/check.dart` with no flags. It picks the steps from the changed files, up to the full timezone matrix, every example, the frame profiling harness and the web build. All of it has to pass.
7. Push and open a draft pull request with the body below. A pull request that depends on another goes in a stack on top of it.
8. When CI is green, run `/pr-review <number>` for round two. Fix what it finds, push, and update the body.
9. Mark the pull request ready and hand the owner the link and the review block.

## Pull request body

```
<What changed and what it means for the package, one paragraph.>

## Review

Tier: <1, 2 or 3>, <why>
Checked: dart tool/check.dart <mode> green, CI green
Public API: <none | the members added, changed or deprecated>
Rounds: <n> findings fixed in round one, <n> in round two

Left on purpose:
- `<path>:<line>`: <finding>. <reason>.
```

The tiers are in `.claude/agents/reviewer.md`. The owner reads the `lib` diff only at tier 3.

## Rules

- Never force-push a branch someone else has reviewed. Rebase a stack only when the owner asks.
- Never merge, tag or publish.
- Never submit a review on GitHub. Round two leaves a pending review for the owner.
