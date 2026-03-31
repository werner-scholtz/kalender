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
dart tools/test_timezones_linux.dart
```

## Reporting issues

If you find a bug or have a feature request, open an issue on [GitHub](https://github.com/werner-scholtz/kalender/issues). Include as much detail as you can, Flutter version, platform, a minimal reproduction if possible.
