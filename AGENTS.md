# Kalender – Project Guidelines

## Overview

Kalender is a Flutter calendar widget package providing four views: **MultiDay** (day/week), **Month**, **Schedule**, and a generic **CalendarView** orchestrator. The library is pre-1.0 (v0.15.0) and actively developed.

- **SDK constraints**: Dart `>=3.0.0 <4.0.0`, Flutter `>=3.22.0`
- **Key dependencies**: `intl`, `timezone`, `collection`, `linked_pageview`, `scrollable_positioned_list`

## Repository Layout

| Path | Purpose |
|------|---------|
| `lib/kalender.dart` | Main barrel export — organized by category (Widgets, Enumerations, Layout, Models, Components, Utils) |
| `lib/kalender_extensions.dart` | Public extension APIs — `DateTimeExtensions`, `InternalDateTime`, `InternalDateTimeRange`, `TimeOfDay` |
| `lib/src/` | All implementation code |
| `lib/src/models/` | Core data structures: controllers, events, view configurations, providers, components, mixins |
| `lib/src/models/controllers/` | `CalendarController` (ChangeNotifier), `EventsController` (abstract), `ViewController` (abstract), view-specific controllers |
| `lib/src/models/providers/` | InheritedWidget providers (`CalendarControllerProvider`, `EventsControllerProvider`, `Components`, `Callbacks`, `Interaction`, `Snapping`, `HeightPerMinute`, `TileComponentProvider`, `LocaleProvider`, `LocationProvider`) |
| `lib/src/models/components/` | Customizable builder classes: `TileComponents`, `CalendarComponents`, view-specific components and styles |
| `lib/src/models/mixins/` | Reusable mixins: `CalendarNavigationFunctions`, `DragTargetUtils`, `EventTileUtils`, `NewEvent`, `SnapPoints`, `ScheduleMap` |
| `lib/src/models/view_configurations/` | `ViewConfiguration` (abstract base), `MultiDayViewConfiguration`, `MonthViewConfiguration`, `ScheduleViewConfiguration` |
| `lib/src/models/calendar_events/` | `CalendarEvent` base class (extensible via subclassing) |
| `lib/src/widgets/` | UI widgets by view (`month/`, `multi_day/`, `schedule/`) plus shared (`components/`, `event_tiles/`, `draggable/`, `drag_targets/`) |
| `lib/src/layout_delegates/` | Event layout/positioning strategies (`overlapLayoutStrategy`, `sideBySideLayoutStrategy`) with caching |
| `lib/src/extensions/` | Internal DateTime/TimeOfDay utilities (DST-safe wall-clock arithmetic) |
| `lib/src/calendar_body.dart` | Top-level body widget that delegates to the correct view |
| `lib/src/calendar_header.dart` | Top-level header widget |
| `lib/src/calendar_view.dart` | Main CalendarView orchestrator widget |
| `test/` | Unit and widget tests (mirrors `lib/src/` structure) |
| `test/utilities.dart` | Shared test helpers: `TestProvider`, `wrapWithMaterialApp`, `testWithTimeZones`, `WidgetTesterUtils` |
| `examples/` | Example Flutter apps (`example/`, `demo/`, `advanced_example/`, `riverpod/`, `recurrence/`, `testing/`, `web_demo/`) |
| `tool/` | Dev scripts — `test_timezones_linux.dart` replicates CI timezone matrix locally |
| `.github/workflows/` | CI: `flutter_analyze_and_test.yml`, `performance_profiling.yml`, `publish.yml`, `web_demo.yml` |

## Code Style

- **Linting**: `package:flutter_lints` with strict-inference and strict-raw-types enabled. See `analysis_options.yaml`.
- **Formatter page width**: 120 characters.
- **Imports**: Always use `package:` imports (never relative). Enforced by `always_use_package_imports: true`. Follow `directives_ordering` (dart:, package:, relative in that order).
- **Strings**: Prefer `single_quotes`.
- **Variables/fields**: Prefer `final` locals (`prefer_final_locals`) and `final` fields (`prefer_final_fields`). Use `omit_local_variable_types` and `avoid_types_on_closure_parameters` — let type inference work.
- **Constructors**: Prefer `const` constructors (`prefer_const_constructors`).
- **Trailing commas**: Required on every multi-line argument list (`require_trailing_commas`).
- **No print**: `avoid_print` is enforced.
- **Widget ordering**: `sort_child_properties_last` — the `child` parameter goes last.
- **Unnecessary wrappers**: `avoid_unnecessary_containers` and `unnecessary_lambdas`.
- **Naming**: snake_case for files (`calendar_event.dart`), PascalCase for classes. Widget files match their class name. View widgets use `Body`/`Header` suffixes (e.g. `MonthBody`, `MonthHeader`).

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

# Run all timezones locally (Linux) — mirrors CI matrix
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
  - `testWithTimeZones()` — wraps test groups to run against the current `TZ` environment variable.
  - `TestProvider` — wraps widgets with all required InheritedWidget providers for widget tests.
  - `wrapWithMaterialApp()` / `pumpAndSettleWithMaterialApp()` — standard MaterialApp + Scaffold wrappers.
  - `WidgetTesterUtils.hoverOn()` / `createMouseGesture()` — mouse interaction helpers.
- DST transition dates from multiple regions are defined in `datesToTest` for thorough timezone coverage.
- Timezone-sensitive tests **must** use `testWithTimeZones` and the shared `datesToTest` / `locationsToTest` lists.

## Architecture Conventions

### View Pattern

Each calendar view (MultiDay, Month, Schedule) follows the same layered structure:

1. **ViewController** (`models/controllers/view_controllers/`) — manages view-specific state (page index, visible range). Abstract base: `ViewController`.
2. **ViewConfiguration** (`models/view_configurations/`) — holds layout parameters. Configuration mixins: `VerticalConfiguration` (event layout strategy, scroll physics), `HorizontalConfiguration` (tile height, multi-day layout).
3. **Body widget** (`widgets/<view>/<view>_body.dart`) — renders the main content area.
4. **Header widget** (`widgets/<view>/<view>_header.dart`) — renders the top navigation/day headers.
5. **TileComponents** — customizable builder functions for rendering event tiles.

`CalendarBody` and `CalendarHeader` select the correct sub-widget via a `switch` on the active `ViewController` type.

### State Management (InheritedWidget only — no external packages)

All state flows through InheritedWidget providers in `lib/src/models/providers/calendar_provider.dart`:

| Provider | Wraps | Purpose |
|----------|-------|---------|
| `CalendarControllerProvider` | `CalendarController` | Top-level calendar state (visible range, selected event, navigation) |
| `EventsControllerProvider` | `EventsController` | Event storage/retrieval |
| `Components` | `CalendarComponents` | Visual component builders |
| `TileComponentProvider` | `TileComponents` | Event tile builders |
| `Callbacks` | `CalendarCallbacks` | User interaction callbacks |
| `Interaction` | `CalendarInteraction` | Interaction permissions (create, resize, reschedule) |
| `Snapping` | `CalendarSnapping` | Snap-to-grid configuration |
| `HeightPerMinute` | `double` | Vertical zoom level |
| `LocaleProvider` | `dynamic` | Internationalization locale |
| `LocationProvider` | `Location?` | Timezone location |

### Event Model

- `CalendarEvent` is the base class — extend it to attach custom data (title, colour, etc.).
- Events store UTC internally (`start` and `end` as `DateTime` in UTC). Use `internalStart()`/`internalEnd()` for wall-clock access.
- Event IDs are `String` (10-char random alphanumeric, auto-generated).
- Override `copyWith()`, `==`, and `hashCode` in subclasses.
- `EventInteraction` controls per-event permissions (resizing, rescheduling).
- `layoutEquals()` is used for render optimisation — returns true if the event occupies the same visual space.

### Controller Hierarchy

- **CalendarController** (`ChangeNotifier` + mixins) — top-level orchestrator. Manages `visibleDateTimeRange`, `visibleEvents`, `selectedEvent`. Attaches/detaches from a `ViewController`.
- **EventsController** (abstract `ChangeNotifier`) — event CRUD interface. `addEvent()` returns `String` id. Implement or use `DefaultEventsController`.
- **ViewController** (abstract) — view-specific state. Implementations: `MultiDayViewController`, `MonthViewController`, `ScheduleViewController`.

### DateTime & Timezone Handling

- **All dates stored in UTC** — `CalendarEvent.start`/`.end` are always UTC.
- **Wall-clock arithmetic** uses `InternalDateTime` and `InternalDateTimeRange` (in `lib/src/extensions/`) to handle DST transitions safely.
- Use `InternalDateTime.fromExternal(utcDateTime, location: location)` to convert for display.
- The `timezone` package provides `Location` objects for timezone-aware logic.
- `DateTimeExtensions` (public) provide localized day/month names via `intl`.

### Layout Delegates

- `EventLayoutStrategy` is a typedef — a function returning an `EventLayoutDelegate`.
- Built-in strategies: `overlapLayoutStrategy` (layered stacking), `sideBySideLayoutStrategy` (adjacent columns).
- `EventLayoutDelegateCache` caches layouts per date/heightPerMinute/timeRange for performance.
- Custom strategies can be provided via `VerticalConfiguration.eventLayoutStrategy`.

### Component / Builder Pattern

`TileComponents` provides customizable widget builders:

| Builder | Purpose |
|---------|---------|
| `tileBuilder` | Default stationary event tile `(CalendarEvent, DateTimeRange) → Widget` |
| `overlayTileBuilder` | Tile variant for overlay display |
| `tileWhenDraggingBuilder` | Placeholder shown at original position during drag |
| `feedbackTileBuilder` | Widget shown under the pointer during drag |
| `dropTargetTile` | Preview of where the event will land |
| `resizeHandlePositioner` | Positions resize handles on tiles |
| `verticalResizeHandle` / `horizontalResizeHandle` | Resize handle widgets |

Default builders are in `lib/src/widgets/components/default_tile_components.dart`. Use `TileComponents.defaultComponents()` as a starting point.

Mixins `DayEventTileUtils` and `MultiDayEventTileUtils` provide helper methods for custom tile builders.

### Drag & Drop

- Native `Draggable`/`LongPressDraggable` for existing events; `NewDraggable` mixin for creating new events.
- Drag targets: `VerticalDragTarget` (day/week), `HorizontalDragTarget` (month/header), `ScheduleDragTarget`.
- Drag data: `DraggableEvent` for existing events, create markers for new events, `ResizeDirection` enum for resize operations.
- Platform-aware gestures: Desktop uses tap, mobile uses long-press (configurable via `CreateEventGesture`).
- Callbacks: `onEventCreate()`, `onEventChange()`, `onWillAcceptWithDetails*()`.

### Error Handling

- **Asserts** for provider lookups ("No XyzProvider found") — these are development-time checks.
- **Input validation** via asserts (e.g. `TimeOfDayRange` start ≤ end).
- No custom exception classes (pre-1.0 assert-based approach).

## Versioning & Migration

This is a pre-1.0 package, so the minor version is the breaking slot. Breaking changes are batched into as few releases as possible rather than dribbled out.

### Breaking changes and deprecations

These are rules, not preferences.

**Deprecate only when the old member still gives a correct answer.** A deprecated member that compiles but silently does nothing is worse than a compile error, because the build stays green while the behaviour is gone. `CalendarInteraction.throttleMilliseconds` was removed outright in 0.24.0 for exactly this reason: nothing was left behind it. `CalendarEvent.isMultiDayEvent` was deprecated instead, because it still returns a usable answer.

**The window is one minor release.** Deprecated in 0.23.0 means removed in 0.24.0. Do not extend it, and do not remove early.

**Every `@Deprecated` message names the replacement and the removal version.** Both, every time:

```dart
@Deprecated('Use spansMultipleDays, which takes a location. Will be removed in 0.25.0.')
```

A message without a version has no deadline and will sit there for years. Three currently do.

**Some changes cannot be deprecated at all.** There is no window available for any of these, so they go straight into a breaking batch with a migration entry:

- Turning a getter into a method of the same name. Dart rejects declaring both (`duplicate_definition`), so the getter has to vanish the moment the method appears.
- Adding a named parameter to a method that subclasses override, including optional ones. An override must accept every named parameter its supertype declares, so `copyWith` and `eventsFromDateTimeRange` break every implementer either way.
- Adding a member to a public mixin or abstract class, such as `DragTargetUtilities.mounted`.

**Record it in both places.** A deprecation gets a `### Deprecations` entry in the changelog naming the removal version. A breaking change gets a `### Breaking Changes` entry plus a section in [MIGRATION.md](MIGRATION.md) showing the before and after.

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
git tag v0.23.0 && git push origin v0.23.0
```

`publish.yml` refuses the tag unless it points at a commit on main and `pubspec.yaml` matches it, then analyzes, tests and publishes. A published version is permanent: it can be retracted within seven days, but the number can never be reused.

The same tag rebuilds the [live demo](https://werner-scholtz.github.io/kalender/), so it always shows the published package rather than whatever is on main. To rebuild it from main instead, push a commit whose message contains `web demo`.

### Pre-releases

To ship a preview of the next version, add a `-dev.N` suffix:

```bash
git tag v0.24.0-dev.1 && git push origin v0.24.0-dev.1
```

pub.dev never resolves a pre-release as `latest`, so `dart pub add kalender` is unaffected and people opt in explicitly. This suits breaking releases, where the removals want trying before they are final.

Patching an older release after main has moved on does not need a branch prepared in advance. Cut one from the tag when it is needed:

```bash
git branch release/0.23.x v0.23.0
```

Key breaking changes to be aware of:
- **v0.16.0**: `CalendarEvent` removed generic type parameter (use subclassing instead of `CalendarEvent<T>`). Event IDs changed from `int` to `String`. `EventsController` refactored to abstract interface.
- **v0.15.0**: Full timezone support added. `InternalDateTime` classes introduced. `ViewConfiguration.selectedDate` renamed to `initialDateTime`.

## Documentation

- [README.md](README.md) — feature list, quick-start, previews.
- [MIGRATION.md](MIGRATION.md) — breaking-change migration guides between versions.
- [CHANGELOG.md](CHANGELOG.md) — version history.
