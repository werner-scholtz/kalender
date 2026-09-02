# Contributing to Kalender

Kalender is a work-in-progress package. This project is meant to be a fun way to explore Flutter and learn together. All contributions are welcome, whether it's fixing a bug, improving architecture, improving documentation, or adding a new feature.

## Getting started

1. Fork the repository and clone it locally.
2. Install dependencies:

```bash
flutter pub get
```

3. Run the analyzer and tests to make sure everything passes before making changes:

```bash
dart analyze && flutter analyze
flutter test
```

## Making changes

- Create a branch for your work.
- Try to keep pull requests focused on a single change.
- If you're adding a new feature, try to follow the existing architecture and patterns, but don't stress about it. We can always iterate together during review.
- Ensure `dart analyze` and `flutter analyze` report no issues.
- Add or update tests where appropriate. You can run the full timezone matrix locally on Linux with:

```bash
dart tool/test_timezones_linux.dart
```

- Adding or changing a code sample in the README or the guides? Every fenced dart block carries a directive comment saying how it is compiled, and CI compiles them all:

```bash
dart run tool/analyze_doc_snippets.dart
```

A block without a directive fails the run, so a new snippet cannot go in unchecked. `tool/analyze_doc_snippets.dart` documents the directives at the top.

- Removing or renaming anything public? The rules for deprecating it, how long it stays, and what to write in the changelog and migration guide are in [AGENTS.md](AGENTS.md#breaking-changes-and-deprecations). They also cover the changes that cannot be deprecated at all.
- Renaming anything public also ships a data-driven fix so `dart fix --apply` does it for the user, with a fixture pair in `test_fixes/`. See [AGENTS.md](AGENTS.md#automating-a-migration). Check it with:

```bash
dart fix --compare-to-golden test_fixes
```

## Reporting issues

If you find a bug or have a feature request, open an issue on [GitHub](https://github.com/werner-scholtz/kalender/issues). Include as much detail as you can, Flutter version, platform, a minimal reproduction if possible.
