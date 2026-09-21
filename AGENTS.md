# Kalender: Project Guidelines

## Overview

Kalender is a Flutter calendar widget package providing four views: **MultiDay** (day/week), **Month**, **Schedule**, and a generic **KalenderView** orchestrator. The library is pre-1.0 and actively developed.

- **Key dependencies**: `intl`, `timezone`, `collection`, `linked_pageview`, `scrollable_positioned_list`

## Repository Layout

| Path | Purpose |
|------|---------|
| `lib/kalender.dart` | Main barrel export: organized by category (Widgets, Enumerations, Layout, Models, Components, Utils) |
| `lib/kalender_extensions.dart` | Public extension APIs: `DateTimeExtensions`, `FloatingDateTime`, `FloatingDateTimeRange`, `KalenderDateTimeRange` |
| `lib/src/` | All implementation code |
| `lib/src/models/` | Core data structures: controllers, events, view configurations, providers, components, mixins |
| `lib/src/models/controllers/` | `KalenderController` (ChangeNotifier), `EventsController` (abstract), `ViewController` (abstract), view-specific controllers |
| `lib/src/models/providers/` | InheritedWidget providers (`KalenderControllerProvider`, `EventsControllerProvider`, `Components`, `Callbacks`, `Interaction`, `Snapping`, `HeightPerMinute`, `TileComponentProvider`, `LocaleProvider`, `LocationProvider`) |
| `lib/src/models/components/` | Customizable builder classes: `TileComponents`, `KalenderComponents`, view-specific components and styles |
| `lib/src/models/mixins/` | Reusable mixins: `KalenderNavigationFunctions`, `DragTargetUtilities`, `EventTileUtils`, `NewEvent`, `SnapPoints`, `ScheduleMap` |
| `lib/src/models/view_configurations/` | `ViewConfiguration` (abstract base), `MultiDayViewConfiguration`, `MonthViewConfiguration`, `ScheduleViewConfiguration` |
| `lib/src/models/kalender_events/` | `KalenderEvent` base class (extensible via subclassing) |
| `lib/src/widgets/` | UI widgets by view (`month/`, `multi_day/`, `schedule/`) plus shared (`components/`, `event_tiles/`, `draggable/`, `drag_targets/`) |
| `lib/src/layout_delegates/` | Event layout/positioning strategies (`EventLayoutStrategy`, `MultiDayLayoutStrategy`) with caching |
| `lib/src/extensions/` | `DateTimeExtensions`: localized day, month and time strings |
| `lib/src/kalender_body.dart` | Top-level body widget that delegates to the correct view |
| `lib/src/kalender_header.dart` | Top-level header widget |
| `lib/src/kalender_view.dart` | Main KalenderView orchestrator widget |
| `test/` | Unit and widget tests (mirrors `lib/src/` structure) |
| `test/utilities.dart` | Shared test helpers: `TestProvider`, `wrapWithMaterialApp`, `testWithTimeZones`, `WidgetTesterUtils` |
| `doc/` | The user-facing guides, indexed by `doc/README.md` |
| `examples/` | Example projects, indexed by `examples/README.md` |
| `example/` | README only: the pub.dev Example tab, which links to `examples/` |
| `tool/` | Dev scripts: `test_timezones_linux.dart` replicates the CI timezone matrix locally, `pin_release_links.dart` pins documentation links at publish, `license_headers.dart` adds the license header to Dart files |
| `.github/workflows/` | CI: `flutter_analyze_and_test.yml`, `analyze_examples.yml`, `performance_profiling.yml`, `deploy_dashboard.yml`, `publish.yml`, `web_demo.yml` |

## Code Style

- **Lints and formatter width**: `analysis_options.yaml`.
- **License header**: `dart run tool/license_headers.dart`.
- **Naming**: View widgets use `Body`/`Header` suffixes, such as `MonthBody` and `MonthHeader`.

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
dart tool/test_timezones_linux.dart test/models/floating_date_time_test.dart
```

### CI Pipeline (`.github/workflows/flutter_analyze_and_test.yml`)

- **Flutter version**: Every job runs the version in `.fvmrc`, except `minimum-flutter`, which runs the floor `pubspec.yaml` declares, and `latest-stable`, which runs the newest stable and does not fail the workflow. Format with the `.fvmrc` version.
- **Analyze job**: `dart analyze` + `flutter analyze` on `ubuntu-latest`.
- **Test job**: Matrix strategy over 6 timezones: `America/New_York`, `Europe/London`, `Asia/Tokyo`, `Australia/Sydney`, `Africa/Johannesburg`, `UTC`. Sets system timezone via `timedatectl` and `TZ` env var.

### Test Conventions

- Test directory mirrors `lib/src/` structure: `test/extensions/`, `test/configuration/`, `test/interactions/`, `test/layout/`, `test/models/`, `test/widgets/`.
- Use the shared `test/utilities.dart` helpers:
  - `testWithTimeZones()`: wraps test groups to run against the current `TZ` environment variable.
  - `TestProvider`: wraps widgets with all required InheritedWidget providers for widget tests.
  - `wrapWithMaterialApp()` / `pumpAndSettleWithMaterialApp()`: standard MaterialApp + Scaffold wrappers.
  - `WidgetTesterUtils.hoverOn()` / `createMouseGesture()`: mouse interaction helpers.
- DST transition dates from multiple regions are defined in `datesToTest` for thorough timezone coverage.
- Timezone-sensitive tests **must** use `testWithTimeZones` and the shared `datesToTest` / `locationsToTest` lists.
- A `static Key` factory on an unexported class is a test helper. Do not add one
  to reach a widget from an app. Give the widget identifying fields and use
  `find.byType` with a predicate.

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

`GutterWidths` sits in `lib/src/models/providers/gutter_widths.dart`. `KalenderView` measures the month week number column and the multi-day timeline once and publishes the widths there. A width is null where the view draws no such gutter.

`KalenderScope` in `lib/src/models/providers/kalender_scope.dart` is the exported accessor for the table above, one static per value. The providers themselves are not exported. Add an accessor there when a provider gains something an app should reach.

### Event Model

- `KalenderEvent` is the base class: extend it to attach custom data (title, colour, etc.).
- Events store UTC internally (`start` and `end` as `DateTime` in UTC). Use `floatingStart()`/`floatingEnd()` for calendar-position access.
- Event IDs are `String` (10-char random alphanumeric, auto-generated).
- Override `copyWithData()`, `==`, and `hashCode` in subclasses. `copyWithData` carries `@mustBeOverridden`, and `KalenderEvent` reapplies `id`, `interaction` and `multiDayRule` through `carryOver` afterwards, so a subclass never forwards those manually.
- `EventInteraction` controls per-event permissions (resizing, rescheduling).
- `layoutEquals()` is used for render optimisation: returns true if the event occupies the same visual space.

### Controller Hierarchy

- **KalenderController** (`ChangeNotifier` + mixins): top-level orchestrator. Manages `visibleDateTimeRange`, `visibleEvents`, `selectedEvent`. Attaches/detaches from a `ViewController`.
- **EventsController** (abstract `ChangeNotifier`): event CRUD interface. `addEvent()` returns `String` id. Implement or use `DefaultEventsController`.
- **ViewController** (abstract): view-specific state. Implementations: `MultiDayViewController`, `MonthViewController`, `ScheduleViewController`.

### DateTime & Timezone Handling

- **All dates stored in UTC**: `KalenderEvent.start`/`.end` are always UTC.
- **Calendar arithmetic** uses `FloatingDateTime` and `FloatingDateTimeRange` (in `lib/src/models/`) to handle DST transitions safely.
- Use `FloatingDateTime.fromExternal(utcDateTime, location: location)` to convert for display.
- The `timezone` package provides `Location` objects for timezone-aware logic.
- `DateTimeExtensions` (public) provide localized day/month names via `intl`.

#### Naming the two range spaces

`KalenderDateTimeRange` holds instants and is what an app hands in and reads
back. `FloatingDateTimeRange` names no timezone and carries the date arithmetic.
They are not interchangeable.

**Name a member for what it is, not for its type.** Say `range` rather than
`dateTimeRange`, and let the type annotation say which space the value is in.
Add a `floating` marker only where one class carries both spaces, as
`KalenderEvent`, `KalenderController` and `PageIndexCalculator` do.

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
- **Input validation** via asserts (e.g. `KalenderTimeRange` start ≤ end).
- No custom exception classes (pre-1.0 assert-based approach).

## Versioning & Migration

This is a pre-1.0 package, so the minor version is the breaking slot. Breaking changes are batched into as few releases as possible rather than dribbled out.

### Breaking changes and deprecations

**Deprecate only when the old member still gives a correct answer.** A deprecated member that compiles but silently does nothing is worse than a compile error, because the build stays green while the behaviour is gone.

The same reasoning removes a public **type** outright once every entry point to it has gone.

**The window is one minor release.** Deprecated in 0.23.0 means removed in 0.24.0. Do not extend it, and do not remove early.

**Every `@Deprecated` message names the replacement and the removal version.** Both, every time:

```dart
@Deprecated('Use spansMultipleDays, which takes a location. Will be removed in 0.25.0.')
```

Check with `grep -rn "@Deprecated" lib/`.

**Some changes cannot be deprecated at all.** There is no window available for any of these, so they go straight into a breaking batch with a migration entry:

- Turning a getter into a method of the same name. Dart rejects declaring both (`duplicate_definition`), so the getter has to vanish the moment the method appears.
- Adding a named parameter to a method that subclasses override, including optional ones. An override must accept every named parameter its supertype declares, so `copyWith` and `eventsInRange` break every implementer either way.
- Adding a member to a public mixin or abstract class, or narrowing what it can be applied to, such as constraining `DragTargetUtilities` to `State`.
- Changing a function typedef's signature. A typedef cannot be deprecated into a new shape, so a builder that gains or loses a parameter breaks every implementer at once.

**Record it in both places.** A deprecation gets a `### Deprecations` entry in the changelog naming the removal version. A breaking change gets a `### Breaking Changes` entry plus a section in [MIGRATION.md](MIGRATION.md) showing the before and after.

### Automating a migration

**Ship a fix for everything that can carry one.** Data-driven fixes live in `lib/fix_data/fix_*.yaml` and ship inside the package, so `dart fix --apply` in a user's project applies them. The format is at https://dart.dev/go/data-driven-fixes.

What a fix can do:

- Rename a class, typedef, mixin, enum, constructor, method, getter, setter or field.
- Rename, add or remove a named parameter.
- Derive a new argument from an old one, so one parameter can become two. `KalenderEvent(dateTimeRange: r)` to `KalenderEvent(start: r.start, end: r.end)` is an `addParameter` pair with `argumentValue.expression` reading `arguments[dateTimeRange]`, plus a `removeParameter`.

What it cannot do: rewrite the body of an override, or reshape an override's parameters. Both are manual edits the migration guide has to carry.

A type change with no rename has nothing to trigger on, since kalender cannot deprecate another package's type. Rename the parameter alongside the type change and the fix can wrap the old value.

**`date` is when the change landed, not when the fix was written.** Use the date the pull request merged and name that pull request in a comment above the transform, the way `material_ui` does.

**What a fix reaches depends on the change kind.** Measured against a subclass overriding a `@mustBeOverridden` member:

| Change | Call sites | Override signature | Override body |
| --- | --- | --- | --- |
| `rename` of a method | yes | yes, the override is renamed | not applicable |
| `renameParameter` | yes | yes | no, references to the parameter are left undefined |
| `addParameter` with `removeParameter` | yes | no, reported as `invalid_override` | not applicable |

So a parameter reshape, which is the shape a signature change usually takes, fixes every call site and leaves every subclass to be edited manually. Say so in the migration guide for any change to a `@mustBeOverridden` member.

**A `renameParameter` reaches only the element it names.** A transform on `defaultMultiDayFrameGenerator` does not rename the same parameter on `MultiDayLayoutStrategy.generateFrame`. Give each function and method an app calls or overrides its own transform, and give a probe override a body that uses the parameter, or the body edit stays hidden.

**A `renameParameter` on a constructor does not reach a `super.` parameter** declared by a subclass constructor. That declaration is a manual edit the migration guide has to carry.

**Every fix is tested.** The fixture pair lives in `test_fixes/<name>.dart` and `<name>.dart.expect`, and CI runs:

```bash
dart fix --compare-to-golden test_fixes
```

`test_fixes/` is excluded from the package analysis, since the fixtures use deprecated members on purpose, and excluded from the published archive.

**`### Breaking Changes` is for code that stops compiling. `### Behavior Changes` is for code that still compiles and renders differently.** They ask the reader for different things: one is "fix your code", the other is "look at your screenshots". Do not put them under one heading.

**If the version is not tagged yet, amend the existing entries rather than appending.**

### Verifying a removal

`flutter analyze` at the root excludes `examples/**`. It also does not warn when the package uses its own deprecated members. Run the examples directly:

```bash
for d in examples/*/; do (cd "$d" && flutter analyze); done
```

### Releasing

Publishing is triggered by a tag, not by a merge. Bump `version` in `pubspec.yaml`, merge that to main, then tag the merge commit:

```bash
git tag -m v0.23.0 v0.23.0 && git push origin v0.23.0
```

The `-m` is required because tags are signed.

`publish.yml` refuses the tag unless it points at a commit on main and `pubspec.yaml` matches it, then analyzes, tests, pins the repository links to the tag and publishes.

The published archive is not byte-identical to the tag. Before packaging, the workflow runs `dart run tool/pin_release_links.dart <tag>`, which rewrites README.md, example/README.md, CHANGELOG.md and doc/*.md so the pub.dev pages link to the tag's documentation instead of main. The rewrite is committed only inside the runner and is never pushed, so the repository keeps its relative links. To preview the published pages locally, run the script with any release tag, inspect with `git diff`, then restore with `git checkout -- README.md example/README.md CHANGELOG.md doc/`.

The same tag rebuilds the [live demo](https://werner-scholtz.github.io/kalender/), so it always shows the published package rather than whatever is on main. To rebuild it from main instead, push a commit whose message contains `web demo`.

### Pre-releases

To ship a preview of the next version, add a `-dev.N` suffix:

```bash
git tag -m v0.24.0-dev.1 v0.24.0-dev.1 && git push origin v0.24.0-dev.1
```

This suits breaking releases, where the removals want trying before they are final.

Patching an older release after main has moved on does not need a branch prepared in advance. Cut one from the tag when it is needed:

```bash
git branch release/0.23.x v0.23.0
```

### Before 1.0.0

A pre-1.0.0 release can carry unfinished work that a 1.0.0 cannot. Audit these
before tagging it:

- **TODOs on public API.** Renames and removals get held for the next breaking
  window rather than done piecemeal. Find them with `grep -rn "TODO" lib/`. Each
  one is a decision still owed. Keep TODOs as `//`. A `///` TODO renders in the
  API reference. Check: `grep -rn "/// TODO" lib/`.
- **Deprecations past their window.** Run `grep -rn "@Deprecated" lib/` and check
  each removal version. See [Verifying a removal](#verifying-a-removal).
- **Function fields included in `==`.** A closure written inline is a new function
  on every build, so a value holding one never equals its predecessor. These are
  included: `ViewConfiguration.nowCallback`, every builder on `TileComponents`,
  `OverlayBuilders` and the month, multi-day and schedule component classes, and
  `PageTriggerConfiguration.triggerWidth` and
  `ScrollTriggerConfiguration.triggerHeight`. Decide per field whether it becomes
  a class, as the layout and snap strategies did, or stays a function with the
  rule on its doc comment.

## Documentation

- [README.md](README.md): feature list, quick-start, previews.
- [doc/README.md](doc/README.md): index of the guides.
- [MIGRATION.md](MIGRATION.md): breaking-change migration guides between versions.
- [CHANGELOG.md](CHANGELOG.md): version history.

A guide links to a class with its pub.dev API page, not a `lib/src` blob URL.
`pin_release_links.dart` rewrites both, so a published version keeps linking to
the documentation it shipped with.

Every fenced dart block in `README.md`, `example/README.md` and `doc/*.md` needs a
directive comment. `tool/analyze_doc_snippets.dart` documents them and CI runs it.
