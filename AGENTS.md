# Kalender: Project Guidelines

## Overview

Kalender is a Flutter calendar widget package providing four views: **MultiDay** (day/week), **Month**, **Schedule**, and a generic **KalenderView** orchestrator. The library is pre-1.0 and actively developed.

- **SDK constraints**: Dart `>=3.0.0 <4.0.0`, Flutter `>=3.22.0`
- **Key dependencies**: `intl`, `timezone`, `collection`, `linked_pageview`, `scrollable_positioned_list`

## Repository Layout

| Path | Purpose |
|------|---------|
| `lib/kalender.dart` | Main barrel export: organized by category (Widgets, Enumerations, Layout, Models, Components, Utils) |
| `lib/kalender_extensions.dart` | Public extension APIs: `DateTimeExtensions`, `InternalDateTime`, `InternalDateTimeRange`, `TimeOfDay` |
| `lib/src/` | All implementation code |
| `lib/src/models/` | Core data structures: controllers, events, view configurations, providers, components, mixins |
| `lib/src/models/controllers/` | `KalenderController` (ChangeNotifier), `EventsController` (abstract), `ViewController` (abstract), view-specific controllers |
| `lib/src/models/providers/` | InheritedWidget providers (`KalenderControllerProvider`, `EventsControllerProvider`, `Components`, `Callbacks`, `Interaction`, `Snapping`, `HeightPerMinute`, `TileComponentProvider`, `LocaleProvider`, `LocationProvider`) |
| `lib/src/models/components/` | Customizable builder classes: `TileComponents`, `KalenderComponents`, view-specific components and styles |
| `lib/src/models/mixins/` | Reusable mixins: `KalenderNavigationFunctions`, `DragTargetUtils`, `EventTileUtils`, `NewEvent`, `SnapPoints`, `ScheduleMap` |
| `lib/src/models/view_configurations/` | `ViewConfiguration` (abstract base), `MultiDayViewConfiguration`, `MonthViewConfiguration`, `ScheduleViewConfiguration` |
| `lib/src/models/kalender_events/` | `KalenderEvent` base class (extensible via subclassing) |
| `lib/src/widgets/` | UI widgets by view (`month/`, `multi_day/`, `schedule/`) plus shared (`components/`, `event_tiles/`, `draggable/`, `drag_targets/`) |
| `lib/src/layout_delegates/` | Event layout/positioning strategies (`EventLayoutStrategy`, `MultiDayLayoutStrategy`) with caching |
| `lib/src/extensions/` | Internal DateTime/TimeOfDay utilities (DST-safe wall-clock arithmetic) |
| `lib/src/kalender_body.dart` | Top-level body widget that delegates to the correct view |
| `lib/src/kalender_header.dart` | Top-level header widget |
| `lib/src/kalender_view.dart` | Main KalenderView orchestrator widget |
| `test/` | Unit and widget tests (mirrors `lib/src/` structure) |
| `test/utilities.dart` | Shared test helpers: `TestProvider`, `wrapWithMaterialApp`, `testWithTimeZones`, `WidgetTesterUtils` |
| `doc/` | The user-facing guides, indexed by `doc/README.md` |
| `examples/` | Example Flutter apps (`example/`, `advanced_example/`, `riverpod/`, `recurrence/`, `ics/`, `testing/`, `web_demo/`) |
| `example/` | README only: the pub.dev Example tab, which links to `examples/` |
| `tool/` | Dev scripts: `test_timezones_linux.dart` replicates the CI timezone matrix locally, `pin_release_links.dart` pins documentation links at publish |
| `.github/workflows/` | CI: `flutter_analyze_and_test.yml`, `analyze_examples.yml`, `performance_profiling.yml`, `deploy_dashboard.yml`, `publish.yml`, `web_demo.yml` |

## Code Style

- **Linting**: `package:flutter_lints` with strict-inference and strict-raw-types enabled. See `analysis_options.yaml`.
- **Formatter page width**: 120 characters.
- **Imports**: Always use `package:` imports (never relative). Enforced by `always_use_package_imports: true`. Follow `directives_ordering` (dart:, package:, relative in that order).
- **Strings**: Prefer `single_quotes`.
- **Variables/fields**: Prefer `final` locals (`prefer_final_locals`) and `final` fields (`prefer_final_fields`). Use `omit_local_variable_types` and `avoid_types_on_closure_parameters` so type inference does the work.
- **Constructors**: Prefer `const` constructors (`prefer_const_constructors`).
- **Trailing commas**: Required on every multi-line argument list (`require_trailing_commas`).
- **No print**: `avoid_print` is enforced.
- **Widget ordering**: `sort_child_properties_last`: the `child` parameter goes last.
- **Unnecessary wrappers**: `avoid_unnecessary_containers` and `unnecessary_lambdas`.
- **Naming**: snake_case for files (`kalender_event.dart`), PascalCase for classes. Widget files match their class name. View widgets use `Body`/`Header` suffixes (e.g. `MonthBody`, `MonthHeader`).

## Build & Test

```bash
# Install dependencies
flutter pub get

# Analyse (CI runs both)
dart analyze && flutter analyze

# Run tests (root package)
flutter test

# Run tests in a specific timezone (CI runs six timezones)
TZ=America/New_York flutter test

# Run all timezones locally (Linux), mirroring the CI matrix
dart tool/test_timezones_linux.dart

# Run specific test file across all timezones
dart tool/test_timezones_linux.dart test/extensions/internal_date_time_test.dart
```

### CI Pipeline (`.github/workflows/flutter_analyze_and_test.yml`)

- **Analyze job**: `dart analyze` + `flutter analyze` on `ubuntu-latest`.
- **Test job**: Matrix strategy over 6 timezones: `America/New_York`, `Europe/London`, `Asia/Tokyo`, `Australia/Sydney`, `Africa/Johannesburg`, `UTC`. Sets system timezone via `timedatectl` and `TZ` env var.
- **Additional workflows**: `performance_profiling.yml`, `publish.yml`, `web_demo.yml`.

### Test Conventions

- Test directory mirrors `lib/src/` structure: `test/extensions/`, `test/configuration/`, `test/interactions/`, `test/layout/`, `test/models/`, `test/widgets/`.
- Use the shared `test/utilities.dart` helpers:
  - `testWithTimeZones()`: wraps test groups to run against the current `TZ` environment variable.
  - `TestProvider`: wraps widgets with all required InheritedWidget providers for widget tests.
  - `wrapWithMaterialApp()` / `pumpAndSettleWithMaterialApp()`: standard MaterialApp + Scaffold wrappers.
  - `WidgetTesterUtils.hoverOn()` / `createMouseGesture()`: mouse interaction helpers.
- DST transition dates from multiple regions are defined in `datesToTest` for thorough timezone coverage.
- Timezone-sensitive tests **must** use `testWithTimeZones` and the shared `datesToTest` / `locationsToTest` lists.
- A `static Key` factory on a class the package does not export is an internal
  test helper, not public API. Ten of the twenty-three sit on `DayEventTile`,
  `MultiDayEventTile`, `ScheduleEventTile` and `DayEventsWidget`, which no app
  can name. The package's own tests reach them by importing the source path.
  Do not add one to reach a widget from an app: give the widget the fields that
  identify it and find it with `find.byType` and a predicate, the way
  `ResizeDetector` carries `event` and `direction`.

## Architecture Conventions

### View Pattern

Each calendar view (MultiDay, Month, Schedule) follows the same layered structure:

1. **ViewController** (`models/controllers/view_controllers/`): manages view-specific state (page index, visible range). Abstract base: `ViewController`.
2. **ViewConfiguration** (`models/view_configurations/`): holds layout parameters. Configuration mixins: `VerticalConfiguration` (event layout strategy, scroll physics), `HorizontalConfiguration` (tile height, multi-day layout).
3. **Body widget** (`widgets/<view>/<view>_body.dart`): renders the main content area.
4. **Header widget** (`widgets/<view>/<view>_header.dart`): renders the top navigation/day headers.
5. **TileComponents**: customizable builder functions for rendering event tiles.

`KalenderBody` and `KalenderHeader` select the correct sub-widget via a `switch` on the active `ViewController` type.

### State Management (InheritedWidget only, no external packages)

All state flows through InheritedWidget providers in `lib/src/models/providers/kalender_provider.dart`:

| Provider | Wraps | Purpose |
|----------|-------|---------|
| `KalenderControllerProvider` | `KalenderController` | Top-level calendar state (visible range, selected event, navigation) |
| `EventsControllerProvider` | `EventsController` | Event storage/retrieval |
| `Components` | `KalenderComponents` | Visual component builders |
| `TileComponentProvider` | `TileComponents` | Event tile builders |
| `Callbacks` | `KalenderCallbacks` | User interaction callbacks |
| `Interaction` | `KalenderInteraction` | Interaction permissions (create, resize, reschedule) |
| `Snapping` | `KalenderSnapping` | Snap-to-grid configuration |
| `HeightPerMinute` | `double` | Vertical zoom level |
| `LocaleProvider` | `Locale?` | Internationalization locale |
| `LocationProvider` | `Location?` | Timezone location |

`GutterWidths` sits in `lib/src/models/providers/gutter_widths.dart`. `KalenderView` measures the month week number column and the multi-day timeline once and publishes the widths there, so the header and the body cannot be given different ones. A width is null where the view draws no such gutter.

`KalenderScope` in `lib/src/models/providers/kalender_scope.dart` is the exported accessor for the table above, one static per value. The providers themselves are not exported. Add an accessor there when a provider gains something an app should reach.

### Event Model

- `KalenderEvent` is the base class: extend it to attach custom data (title, colour, etc.).
- Events store UTC internally (`start` and `end` as `DateTime` in UTC). Use `internalStart()`/`internalEnd()` for wall-clock access.
- Event IDs are `String` (10-char random alphanumeric, auto-generated).
- Override `copyWithData()`, `==`, and `hashCode` in subclasses. `copyWithData` carries `@mustBeOverridden`, and `KalenderEvent` reapplies `id`, `interaction` and `multiDayRule` through `carryOver` afterwards, so a subclass never forwards those by hand.
- `EventInteraction` controls per-event permissions (resizing, rescheduling).
- `layoutEquals()` is used for render optimisation: returns true if the event occupies the same visual space.

### Controller Hierarchy

- **KalenderController** (`ChangeNotifier` + mixins): top-level orchestrator. Manages `visibleDateTimeRange`, `visibleEvents`, `selectedEvent`. Attaches/detaches from a `ViewController`.
- **EventsController** (abstract `ChangeNotifier`): event CRUD interface. `addEvent()` returns `String` id. Implement or use `DefaultEventsController`.
- **ViewController** (abstract): view-specific state. Implementations: `MultiDayViewController`, `MonthViewController`, `ScheduleViewController`.

### DateTime & Timezone Handling

- **All dates stored in UTC**: `KalenderEvent.start`/`.end` are always UTC.
- **Wall-clock arithmetic** uses `InternalDateTime` and `InternalDateTimeRange` (in `lib/src/extensions/`) to handle DST transitions safely.
- Use `InternalDateTime.fromExternal(utcDateTime, location: location)` to convert for display.
- The `timezone` package provides `Location` objects for timezone-aware logic.
- `DateTimeExtensions` (public) provide localized day/month names via `intl`.

### Layout Delegates

- `EventLayoutStrategy` is an abstract class whose `createDelegate` returns an `EventLayoutDelegate`.
- Built-in strategies: `EventLayoutStrategy.overlap()` (layered stacking), `EventLayoutStrategy.sideBySide()` (adjacent columns).
- The base stays open, so an app can extend it. Compare on `runtimeType` rather than `other is X`, or a subclass compares equal to what it extends.
- `EventLayoutDelegateCache` caches layouts per date/heightPerMinute/timeRange for performance.
- Custom strategies can be provided via `VerticalConfiguration.eventLayoutStrategy`.

### Component / Builder Pattern

`TileComponents` provides customizable widget builders:

| Builder | Purpose |
|---------|---------|
| `tileBuilder` | Default stationary event tile `(KalenderEvent, DateTimeRange) → Widget` |
| `overlayTileBuilder` | Tile variant for overlay display |
| `tileWhenDraggingBuilder` | Placeholder shown at original position during drag |
| `feedbackTileBuilder` | Widget shown under the pointer during drag |
| `dropTargetTile` | Preview of where the event will land |
| `resizeHandlePositioner` | Positions resize handles on tiles |
| `verticalResizeHandle` / `horizontalResizeHandle` | Resize handle widgets |

Default builders are in `lib/src/widgets/components/default_tile_components.dart`. Use `TileComponents.defaultComponents()` as a starting point.

Mixins `DayEventTileUtils` and `MultiDayEventTileUtils` provide helper methods for custom tile builders.

### Drag & Drop

- Native `Draggable`/`LongPressDraggable` for existing events. `NewDraggable` mixin for creating new events.
- Drag targets: `VerticalDragTarget` (day/week), `HorizontalDragTarget` (month/header), `ScheduleDragTarget`.
- Drag data: `DraggableEvent` for existing events, create markers for new events, `ResizeDirection` enum for resize operations.
- Platform-aware gestures: Desktop uses tap, mobile uses long-press (configurable via `EventInteractionGesture`).
- Callbacks: `onEventCreate()`, `onEventChange()`, `onWillAcceptWithDetails*()`.

### Error Handling

- **Asserts** for provider lookups ("No XyzProvider found"): these are development-time checks.
- **Input validation** via asserts (e.g. `TimeOfDayRange` start ≤ end).
- No custom exception classes (pre-1.0 assert-based approach).

## Versioning & Migration

This is a pre-1.0 package, so the minor version is the breaking slot. Breaking changes are batched into as few releases as possible rather than dribbled out.

### Breaking changes and deprecations

These are rules, not preferences.

**Deprecate only when the old member still gives a correct answer.** A deprecated member that compiles but silently does nothing is worse than a compile error, because the build stays green while the behaviour is gone. `KalenderInteraction.throttleMilliseconds` was removed outright in 0.24.0 for exactly this reason: nothing was left behind it. `KalenderEvent.isMultiDayEvent` was deprecated instead, because it still returns a usable answer.

The same reasoning removes a public **type** outright once every entry point to it has gone. It cannot answer anything, and a window would protect a type annotation and nothing else. The style container classes are removed in 0.26.0 alongside the `KalenderComponents` fields that reached them, without a deprecation of their own.

**The window is one minor release.** Deprecated in 0.23.0 means removed in 0.24.0. Do not extend it, and do not remove early.

**Every `@Deprecated` message names the replacement and the removal version.** Both, every time:

```dart
@Deprecated('Use spansMultipleDays, which takes a location. Will be removed in 0.25.0.')
```

A message without a version has no deadline and will sit there for years. `lib/` currently carries no `@Deprecated` at all, and `grep -rn "@Deprecated" lib/` is the check that keeps it that way.

**Some changes cannot be deprecated at all.** There is no window available for any of these, so they go straight into a breaking batch with a migration entry:

- Turning a getter into a method of the same name. Dart rejects declaring both (`duplicate_definition`), so the getter has to vanish the moment the method appears.
- Adding a named parameter to a method that subclasses override, including optional ones. An override must accept every named parameter its supertype declares, so `copyWith` and `eventsFromDateTimeRange` break every implementer either way.
- Adding a member to a public mixin or abstract class, or narrowing what it can be applied to, such as constraining `DragTargetUtilities` to `State`.
- Changing a function typedef's signature. A typedef cannot be deprecated into a new shape, so a builder that gains or loses a parameter breaks every implementer at once. 0.27.0 moved all twenty-four builders to a leading `BuildContext` in one release for that reason: splitting the work by component would have broken the same concept twice.

**Record it in both places.** A deprecation gets a `### Deprecations` entry in the changelog naming the removal version. A breaking change gets a `### Breaking Changes` entry plus a section in [MIGRATION.md](MIGRATION.md) showing the before and after.

### Automating a migration

**Ship a fix for everything that can carry one.** A migration step a user performs by hand is a step some users will not perform. Data-driven fixes live in `lib/fix_data/fix_*.yaml` and ship inside the package, so `dart fix --apply` in a user's project applies them. The format is at https://dart.dev/go/data-driven-fixes.

What a fix can do:

- Rename a class, typedef, mixin, enum, constructor, method, getter, setter or field.
- Rename, add or remove a named parameter.
- Derive a new argument from an old one, so one parameter can become two. `KalenderEvent(dateTimeRange: r)` to `KalenderEvent(start: r.start, end: r.end)` is an `addParameter` pair with `argumentValue.expression` reading `arguments[dateTimeRange]`, plus a `removeParameter`.

What it cannot do: rewrite a declaration in the user's own code. An override of a changed `@mustBeOverridden` method is a hand edit, and the migration guide has to carry it.

A type change with no rename has nothing to trigger on, since kalender cannot deprecate another package's type. Rename the parameter alongside the type change and the fix can wrap the old value.

**`date` is when the change landed, not when the fix was written.** Use the date the pull request merged and name that pull request in a comment above the transform, the way `material_ui` does. It does not affect behaviour: chained renames resolve whatever order the dates are in, tested by inverting them.

**What a fix reaches depends on the change kind.** Measured against a subclass overriding a `@mustBeOverridden` member:

| Change | Call sites | Override signature | Override body |
| --- | --- | --- | --- |
| `rename` | yes | not applicable | not applicable |
| `renameParameter` | yes | yes | no, references to the parameter are left undefined |
| `addParameter` with `removeParameter` | yes | no, reported as `invalid_override` | not applicable |

So a parameter reshape, which is the shape a signature change usually takes, fixes every call site and leaves every subclass to be edited by hand. Say so in the migration guide for any change to a `@mustBeOverridden` member.

**Every fix is tested.** The fixture pair lives in `test_fixes/<name>.dart` and `<name>.dart.expect`, and CI runs:

```bash
dart fix --compare-to-golden test_fixes
```

`test_fixes/` is excluded from the package analysis, since the fixtures use deprecated members on purpose, and excluded from the published archive.

**`### Breaking Changes` is for code that stops compiling. `### Behavior Changes` is for code that still compiles and renders differently.** They ask the reader for different things: one is "fix your code", the other is "look at your screenshots". Do not put them under one heading. 0.23.0 is the reference for the second kind, 0.24.0 for the first.

**If the version is not tagged yet, amend the existing entries rather than appending.** Someone upgrading should read what the release does, not the history of how it got there.

### Verifying a removal

`flutter analyze` at the root will not catch a break for two separate reasons, and both have bitten:

- `deprecated_member_use_from_same_package` is not enabled, so in-package uses of a deprecated member never warn.
- `analysis_options.yaml` excludes `examples/**`, so the only consumer-shaped code in the repo is invisible to it.

So always run the examples directly:

```bash
for d in examples/*/; do (cd "$d" && flutter analyze); done
```

This is what caught a `copyWith` change in 0.24.0 that broke all seven while the package analyze stayed clean.

### Releasing

Publishing is triggered by a tag, not by a merge. Bump `version` in `pubspec.yaml`, merge that to main, then tag the merge commit:

```bash
git tag -m v0.23.0 v0.23.0 && git push origin v0.23.0
```

The `-m` is not optional. `tag.gpgsign` is set globally, so every tag is signed and therefore annotated, and an annotated tag needs a message. Without it the command fails with `fatal: no tag message?` and nothing is created. Every release from v0.18.0 onwards uses the tag name as its message, and is signed. The tags before that are lightweight and predate the setting.

`publish.yml` refuses the tag unless it points at a commit on main and `pubspec.yaml` matches it, then analyzes, tests, pins the repository links to the tag and publishes. A published version is permanent: it can be retracted within seven days, but the number can never be reused.

The published archive is not byte-identical to the tag. Before packaging, the workflow runs `dart run tool/pin_release_links.dart <tag>`, which rewrites README.md, example/README.md, CHANGELOG.md and doc/*.md so the pub.dev pages link to the tag's documentation instead of main. The rewrite is committed only inside the runner to keep the publish validator's clean-git check meaningful and is never pushed, so the repository keeps its relative links. To preview the published pages locally, run the script with any release tag, inspect with `git diff`, then restore with `git checkout -- README.md example/README.md CHANGELOG.md doc/`.

The same tag rebuilds the [live demo](https://werner-scholtz.github.io/kalender/), so it always shows the published package rather than whatever is on main. To rebuild it from main instead, push a commit whose message contains `web demo`.

### Pre-releases

To ship a preview of the next version, add a `-dev.N` suffix:

```bash
git tag -m v0.24.0-dev.1 v0.24.0-dev.1 && git push origin v0.24.0-dev.1
```

pub.dev never resolves a pre-release as `latest`, so `dart pub add kalender` is unaffected and people opt in explicitly. This suits breaking releases, where the removals want trying before they are final.

Patching an older release after main has moved on does not need a branch prepared in advance. Cut one from the tag when it is needed:

```bash
git branch release/0.23.x v0.23.0
```

### Before 1.0.0

A pre-1.0.0 release can carry unfinished work that a 1.0.0 cannot. Audit these
before tagging it:

- **TODOs on public API.** Renames and removals get held for the next breaking
  window rather than done piecemeal. Find them with `grep -rn "TODO" lib/`. Each
  one is a decision still owed. Keep them
  as `//` comments: a `///` one renders as prose in the API reference, which is
  how `FreeScrollFunctions` shipped with a TODO as its entire published
  documentation before it was removed in 0.28.0. `grep -rn "/// TODO" lib/` is
  the check.
- **Deprecations past their window.** None. `lib/` carries no `@Deprecated` at
  all: `TimeOfDayRange.isAllDay` was removed in 0.27.0 as its 0.26.0 message
  named, and the `KalenderComponents` style fields with the seven containers they
  reached went in 0.26.0. `grep -rn "@Deprecated" lib/` is the check. See
  [Verifying a removal](#verifying-a-removal).
- **Function fields compared with `==`.** `ViewConfiguration.nowCallback` is the
  one left. It is included in equality, so a closure written inline is a new
  function every build and defeats the caching the comparison exists to enable.
  It stays a function because it takes no arguments and has nothing to model, and
  its place in `==` is what makes a change reach the calendar at all. Documented
  on the field. The other three converted to classes in 0.26.0
  ([#380](https://github.com/werner-scholtz/kalender/issues/380)):
  `KalenderSnapping.eventSnapStrategy`, `VerticalConfiguration.eventLayoutStrategy`
  and `HorizontalConfiguration.multiDayLayoutStrategy`, renamed from
  `generateMultiDayLayoutFrame`.

Key breaking changes to be aware of:
- **v0.16.0**: `KalenderEvent` removed generic type parameter (use subclassing instead of `KalenderEvent<T>`). Event IDs changed from `int` to `String`. `EventsController` refactored to abstract interface.
- **v0.15.0**: Full timezone support added. `InternalDateTime` classes introduced. `ViewConfiguration.selectedDate` renamed to `initialDateTime`.

## Documentation

- [README.md](README.md): feature list, quick-start, previews.
- [doc/README.md](doc/README.md): index of the guides. One guide per topic: views, events, interaction, controllers and callbacks, appearance, layout, timezones and locales.
- [MIGRATION.md](MIGRATION.md): breaking-change migration guides between versions.
- [CHANGELOG.md](CHANGELOG.md): version history.

A guide links to a class with its pub.dev API page, not a `lib/src` blob URL.
`pin_release_links.dart` rewrites both, so a published version keeps linking to
the documentation it shipped with.

### Snippets in the documentation

Every fenced dart block in `README.md`, `example/README.md` and `doc/*.md` is
compiled by `tool/analyze_doc_snippets.dart`, which CI runs. Each block needs a
directive comment above it saying how, and a block without one fails the run:

```markdown
<!-- snippet: file -->          top-level declarations
<!-- snippet: statements -->    wrapped in an async function body
<!-- snippet: expression -->    wrapped in a variable initializer
<!-- snippet: continues -->     appended to the block above
<!-- snippet: skip: reason -->  not compiled, reason required
```

A snippet may assume only `material.dart` and `kalender.dart`. Anything else has
to be imported in the block itself, so a snippet a reader copies whole actually
compiles. That rule exists because a wider implied header hid the missing
`gestures.dart` and `services.dart` in the zoom example for as long as it was
there. Placeholder identifiers such as the `Event` subclass come from
`examples/doc_snippets/lib/preamble.dart`, which is analyzed too.

Diagnostics are reported against the markdown line, not the generated file.
