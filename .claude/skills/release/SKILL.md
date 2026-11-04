---
name: release
description: Prepares a kalender release pull request and the checks before tagging. Use when asked to release, cut, or prepare a version, or to check whether main is ready to tag.
---

# Release

The owner merges the release pull request and pushes the tag. `publish.yml` does the rest. See Releasing in `AGENTS.md`.

## Steps

1. Confirm every pull request in the `<version>-progress.md` table is merged and CI on `main` is green: `gh run list --branch main --limit 5`.
2. Branch `chore/release-<version>` from `main`.
3. Set `version` in `pubspec.yaml`. Confirm `CHANGELOG.md` has the `## <version>` heading with every change since the last tag: compare `git log v<previous>..main --oneline` against the entries, and add what is missing, one line each. The heading goes in when the first change of the release does, so it is usually already there.
4. For a minor release: every `### Breaking Changes` entry has a section in `MIGRATION.md`, and every rename ships a fix in `lib/fix_data/` with its fixture pair. `grep -rn "@Deprecated" lib/` shows nothing past its removal version.
5. Run `dart tool/check.dart --full`.
6. Run `flutter pub publish --dry-run` and check the file list against `.pubignore`.
7. Preview the pinned links: `dart run tool/pin_release_links.dart v<version>`, read the diff, then `git checkout -- README.md example/README.md CHANGELOG.md doc/`.
8. Commit `chore: release <version>`, push, open the pull request, and hand the owner the tag command for after the merge:

```
git checkout main && git pull && git tag -s v<version> -m v<version> && git push origin v<version>
```

9. After `publish.yml` finishes, confirm the version on pub.dev and that `site.yml` rebuilt the demo. Start the next `<version>-progress.md` from the open questions and deferred items of the one just released.

## Rules

- Never tag or publish.
- A pre-release takes `-dev.N` and skips step 4.
