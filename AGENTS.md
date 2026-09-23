# Kalender: Project Guidelines

Kalender is a Flutter calendar package with three views, multi-day (day and week), month and schedule, composed through `KalenderView`, `KalenderHeader` and `KalenderBody`. It is pre-1.0, so a minor version can break.

`examples/web_demo/AGENTS.md` covers the web demo.

## Repository layout

| Path | Purpose |
|------|---------|
| `lib/kalender.dart` | The public API, one export per file |
| `lib/kalender_extensions.dart` | `DateTimeExtensions`, `FloatingDateTime`, `FloatingDateTimeRange`, `KalenderDateTimeRange`, and `Location` and `TZDateTime` re-exported from `timezone` |
| `lib/material.dart` | Converters between the Material `DateTimeRange` and `TimeOfDay` and the kalender types |
| `lib/fix_data/` | Data-driven fixes for `dart fix`, see [Automating a migration](#automating-a-migration) |
| `lib/src/models/` | Controllers, events, view configurations, components, providers, mixins |
| `lib/src/widgets/` | One folder per view (`month/`, `multi_day/`, `schedule/`), plus `components/` (the replaceable defaults), `internal_components/`, `event_tiles/`, `events_widgets/`, `draggable/` and `drag_targets/` |
| `lib/src/layout_delegates/` | `EventLayoutStrategy` and `MultiDayLayoutStrategy` with their caches |
| `test/` | Mirrors `lib/src/`. `test/utilities.dart` holds the shared helpers and `test/tool/` tests the scripts |
| `test_fixes/` | Golden fixtures for the `dart fix` data |
| `doc/` | The guides, indexed by `doc/README.md`. Each is also a dartdoc category page |
| `examples/` | Runnable apps, indexed by `examples/README.md`. `example/` is the pub.dev Example tab and only links there |
| `tool/` | `test_timezones_linux.dart`, `analyze_doc_snippets.dart`, `license_headers.dart` and `pin_release_links.dart` |
| `.github/workflows/` | `flutter_analyze_and_test.yml`, `analyze_examples.yml`, `performance_profiling.yml`, `deploy_dashboard.yml`, `publish.yml` and `web_demo.yml` |

Every example depends on the package by path, `../../../kalender/` for most of them, so the checkout has to sit in a folder named `kalender`.

## Commands

Use the Flutter version in `.fvmrc`. Formatting output depends on it.

```bash
flutter pub get
dart format lib test tool benchmark
dart run tool/license_headers.dart           # --check in CI
dart analyze && flutter analyze
flutter test
TZ=America/New_York flutter test             # one timezone
dart tool/test_timezones_linux.dart [file]   # the CI timezone matrix, Linux only
dart run tool/analyze_doc_snippets.dart      # compiles the snippets in README.md and doc/
dart fix --compare-to-golden test_fixes      # the dart fix data
for d in examples/*/; do (cd "$d" && flutter analyze); done
```

CI runs all of these. The `test` job runs in six timezones (`America/New_York`, `Europe/London`, `Asia/Tokyo`, `Australia/Sydney`, `Africa/Johannesburg` and `UTC`). `minimum-flutter` runs the floor `pubspec.yaml` declares, and `latest-stable` runs the newest stable without failing the workflow.

`flutter analyze` at the root excludes `examples/**` and does not warn when the package uses its own deprecated members, which is what the examples loop is for.

## Code style

- Lints and the formatter width are in `analysis_options.yaml`.
- Every Dart file carries the license header. `tool/license_headers.dart` adds it.
- View widgets take a `Body` or `Header` suffix, such as `MonthBody`.
- Public top-level constants take a `k` prefix. Top-level functions and static constants do not.
- Every public symbol carries a `{@category ...}` tag naming one of the seven categories in `dartdoc_options.yaml`. The category's page is the matching guide.
- Comments say what the code does now, not how it got there. A `TODO` stays `//`, since a `///` one renders in the API reference.

### Naming the two range spaces

`KalenderDateTimeRange` holds instants and is what an app hands in and reads back. `FloatingDateTimeRange` names no timezone and carries the date arithmetic. They are not interchangeable.

Name a member for what it is, not for its type. Say `range` rather than `dateTimeRange`, and let the type annotation say which space the value is in. Add a `floating` marker only where one class carries both spaces, as `KalenderEvent`, `KalenderController` and `PageIndexCalculator` do.

## Tests

- `test/` mirrors `lib/src/`.
- Build widgets with the helpers in `test/utilities.dart`: `pumpKalender`, `pumpOverflowingMonth`, `freeScrollView`, `wrapWithMaterialApp`, `pumpAndSettleWithMaterialApp` and `TestProvider`. `resizeHandleFor`, `WidgetTesterUtils` and `KalenderControllerUtils` drive interactions.
- Timezone-sensitive tests use `testWithTimeZones` with the shared `datesToTest` and `locationsToTest`.
- A `static Key` factory on an unexported class is a test helper. Do not add one to reach a widget from an app. Give the widget identifying fields and use `find.byType` with a predicate.

## Architecture

### Views

Each view has a `ViewController` (`models/controllers/view_controllers/`), a `ViewConfiguration` (`models/view_configurations/`), and a body and a header widget (`widgets/<view>/`). `KalenderBody` and `KalenderHeader` pick the widget with a `switch` on the controller type. `VerticalConfiguration` and `HorizontalConfiguration` are the configuration mixins for the two axes.

### State

State reaches widgets through the `InheritedWidget` providers in `lib/src/models/providers/kalender_provider.dart`, one per value, plus `GutterWidths`, which `KalenderView` fills with the measured week number and timeline widths. The providers are not exported. `KalenderScope` in `kalender_scope.dart` is the public accessor, one static per value in the shape of `MediaQuery`. Add an accessor there when a provider gains something an app should reach.

### Events

- `KalenderEvent` is extended to attach data. `start` and `end` are UTC. `floatingStart()` and `floatingEnd()` give the calendar position.
- A subclass overrides `copyWithData`, `==` and `hashCode`. `copyWithData` is `@mustBeOverridden`. `carryOver` reapplies `id`, `interaction`, `multiDayRule` and `isAllDay` afterwards, so a subclass never forwards them.
- `layoutEquals` returns true when two events occupy the same space on screen. The day body lays out again only when an event fails it.
- `EventInteraction` holds the per-event permissions.

### Controllers

- `KalenderController` drives one `KalenderView`: navigation, `visibleDateTimeRange`, `visibleEvents`, `selectedEvent`, `selectedRange` and `openDayOverlay`. It holds the active `viewConfiguration` and `location`, and owns the `ViewController` built from them.
- `EventsController` is the abstract store. `DefaultEventsController` is the one apps use.
- The calendar never selects a day on its own. An app selects from the callbacks.

### Dates and timezones

Events hold instants as UTC `DateTime`. Layout and view coordinates are `FloatingDateTime` and `FloatingDateTimeRange`, which carry the DST-safe arithmetic. `FloatingDateTime.fromExternal(dateTime, location: location)` converts for display. `Location` comes from the `timezone` package.

### Strategies

`EventLayoutStrategy.createDelegate` returns an `EventLayoutDelegate`, and `MultiDayLayoutStrategy.generateFrame` returns a `MultiDayLayoutFrame`. The bases stay open so an app can extend them. A strategy compares on `runtimeType` rather than `other is X`, or a subclass compares equal to what it extends. `EventSnapStrategy` follows the same rule.

### Components

`TileComponents` and `ScheduleTileComponents` hold the event tile builders, with defaults in `lib/src/widgets/components/default_tile_components.dart`. `KalenderComponents` holds the rest, one class per view. Every builder takes a `BuildContext` first and resolves its styles from `KalenderTheme.of(context)`. Only `tileBuilder` is required.

### Errors

Asserts are the only error handling: provider lookups and input validation, such as a `KalenderTimeRange` whose start is after its end. There are no exception classes.

## Versioning and migration

The minor version is the breaking slot until 1.0.0. Breaking changes are batched into as few releases as possible.

### Deprecations

- Deprecate only when the old member still gives a correct answer. A member that compiles and does nothing is worse than a compile error.
- The window is one minor release. Deprecated in 0.32.0 means removed in 0.33.0. Do not extend it or remove early.
- Every `@Deprecated` message names the replacement and the removal version. Check with `grep -rn "@Deprecated" lib/`.

```dart
@Deprecated('Use spansMultipleDays, which takes a location. Will be removed in 0.25.0.')
```

Some changes cannot be deprecated and go straight into a breaking batch with a migration entry:

- Turning a getter into a method of the same name. Dart rejects declaring both.
- Adding a named parameter to a method that subclasses override, optional or not. An override must accept every named parameter its supertype declares.
- Adding a member to a public mixin or abstract class, or narrowing what it can be applied to.
- Changing a function typedef's signature.

### Recording a change

- A deprecation gets a `### Deprecations` changelog entry naming the removal version.
- A breaking change gets a `### Breaking Changes` entry and a section in [MIGRATION.md](MIGRATION.md) with before and after code. `### Behavior Changes` is for code that still compiles and renders differently. Keep the two headings apart.
- Changelog entries are one line each and say what changed. The reasoning goes in the pull request.
- Until the version is tagged, amend the existing entries rather than appending.

### Automating a migration

Ship a fix for everything that can carry one. Fixes live in `lib/fix_data/fix_*.yaml` and ship inside the package, so `dart fix --apply` in a user's project applies them. The format is at https://dart.dev/go/data-driven-fixes.

A fix can rename a class, typedef, mixin, enum, constructor, method, getter, setter or field, and rename, add or remove a named parameter. `addParameter` with an `argumentValue.expression` derives a new argument from an old one, so `dateTimeRange: r` can become `start: r.start, end: r.end`. A fix cannot rewrite the body of an override or reshape an override's parameters, and a type change with no rename gives it nothing to trigger on, so rename the parameter alongside the type change.

What a fix reaches, measured against a subclass overriding a `@mustBeOverridden` member:

| Change | Call sites | Override signature | Override body |
| --- | --- | --- | --- |
| `rename` of a method | yes | yes | not applicable |
| `renameParameter` | yes | yes | no, references are left undefined |
| `addParameter` with `removeParameter` | yes | no, reported as `invalid_override` | not applicable |

- A `renameParameter` reaches only the element it names. Give each function and method an app calls or overrides its own transform.
- A `renameParameter` on a constructor does not reach a subclass's `super.` parameter.
- `date` is the day the pull request merged. Name the pull request in a comment above the transform.
- Every fix has a fixture pair in `test_fixes/<name>.dart` and `<name>.dart.expect`, checked by `dart fix --compare-to-golden test_fixes`.

Say in the migration guide which edits the fixes leave to the reader.

### Before 1.0.0

Audit before tagging it:

- `grep -rn "TODO" lib/`. Each is a decision still owed, held for a breaking window.
- `grep -rn "@Deprecated" lib/`. Nothing may be past its removal version.
- Function fields included in `==`. A closure written inline is a new function on every build. [ROADMAP.md](ROADMAP.md) carries the list and the options.

## Releasing

Publishing is triggered by a tag. Bump `version` in `pubspec.yaml` and add the `## <version>` changelog heading, merge to main, then tag the merge commit:

```bash
git tag -s v0.32.0 -m v0.32.0 && git push origin v0.32.0
```

`publish.yml` refuses a tag that is not on main, does not match `pubspec.yaml` or has no changelog heading. It then analyzes, tests, runs `tool/pin_release_links.dart <tag>` and publishes. The pinning rewrites the links in `README.md`, `example/README.md`, `CHANGELOG.md` and `doc/*.md` to the tag, inside the runner only, so the pub.dev pages link to the documentation they shipped with and the repository keeps its relative links. Preview it locally by running the script with any tag and restore with `git checkout -- README.md example/README.md CHANGELOG.md doc/`.

The same tag rebuilds the [live demo](https://werner-scholtz.github.io/kalender/). A push to main whose message contains `web demo` rebuilds it from main.

A pre-release takes a `-dev.N` suffix, as in `v0.33.0-dev.1`. A patch for an older release starts from its tag when needed: `git branch release/0.32.x v0.32.0`.

`.pubignore` keeps `AGENTS.md`, `ROADMAP.md`, the tests, examples and tools out of the archive. `flutter pub publish --dry-run` lists what ships.

## Documentation

- [README.md](README.md): features, quick start and links.
- [doc/README.md](doc/README.md): the guide index. A new public API rarely needs a new guide section.
- [CHANGELOG.md](CHANGELOG.md): what changed, one line per entry.
- [MIGRATION.md](MIGRATION.md): what to do about it, with before and after code.
- [ROADMAP.md](ROADMAP.md): why it was decided that way.

A guide links to a class through its pub.dev API page, not a `lib/src` URL. Every fenced Dart block in `README.md`, `example/README.md` and `doc/*.md` needs a directive comment, and `tool/analyze_doc_snippets.dart` documents them.

## Commits and pull requests

- Subject: `type: what changed`, lower case, no period. Types in use: `feat`, `fix`, `docs`, `refactor`, `test`, `chore` and `ci`. A breaking change takes `!`, as in `refactor!:`.
- Body: one line per change, saying what was done. No reasoning and no test counts.
- A pull request body says what changed and what it means for the package. Pull requests merge with a merge commit.
- Dependent pull requests are grouped in a GitHub stack. Merging one retargets the ones above it.
