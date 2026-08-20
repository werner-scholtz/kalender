## 0.27.0

See [MIGRATION.md](MIGRATION.md#v026x--v0270) for what to change.

### Breaking Changes

- `TimeOfDayRange.isAllDay` is removed, as its 0.26.0 deprecation message named. Use `coversWholeDay`. `TimeOfDayRange.allDay()` is unaffected.
- The multi-day body builders take a `BuildContext` as their first argument and no longer take a style: `hourLines`, `timeline`, `timelineWidth`, `daySeparator` and `timeIndicator`. Resolve appearance with `KalenderTheme.of(context)`, and the timeline's own style with `GutterStyles.timelineStyleOf(context)`, the value the gutter width is measured from.
- Those five fields are nullable and default to `null`, which selects the package default. `MultiDayBodyComponents` gained a `buildX` method per field that applies the override or the default.
- `builder` and `fromContext` are removed from `TimeLine`, `HourLines`, `DaySeparator` and `TimeIndicator`. Construct the widget, or call the matching `MultiDayBodyComponents.buildX`.
- `defaultTimelineWidth` no longer takes a `TimelineStyle`. It resolves one from the context.
- The multi-day header and month builders take a `BuildContext` as their first argument and no longer take a style: `dayHeaderBuilder`, `weekNumberBuilder`, `weekDayHeaderBuilder`, `monthDayHeaderBuilder`, `monthGridBuilder` and `monthDayCellBuilder`. Resolve the style with `KalenderTheme.of(context)`.
- Those fields are nullable and default to `null`. `MultiDayHeaderComponents`, `MonthHeaderComponents` and `MonthBodyComponents` gained a `buildX` method per field.
- `builder` and `fromContext` are removed from `DayHeader`, `WeekNumber`, `WeekDayHeader`, `MonthGrid`, `MonthDayHeader` and `MonthDayCell`. `MonthDayCell.shadeAdjacentMonths` stays.
- The schedule builders take a `BuildContext` as their first argument: `leadingDateBuilder`, `scheduleTileHighlightBuilder`, `emptyItemBuilder` and `monthItemBuilder`. The first two also lost their style parameter and are nullable, and `ScheduleComponents` gained `buildLeadingDate` and `buildScheduleTileHighlight`. `ScheduleDate.builder` and `ScheduleTileHighlight.builder` are removed.
- The tile builders take a `BuildContext` as their first argument: `tileBuilder`, `overlayTileBuilder`, `tileWhenDraggingBuilder`, `feedbackTileBuilder` and `dropTargetTile`, along with `defaultTileBuilder` and the other three `default*` functions.
- `ResizeHandlePositioner` takes a `BuildContext` and a `ResizeHandleDetails` and returns a `Widget`. It was the only builder that required subclassing an abstract class, so `ResizeHandles` is removed and its six values and seven helpers move to `ResizeHandleDetails`.
- `ResizeHandles.startResizeDraggableKey` and `endResizeDraggableKey` move to `ResizeHandle`, the widget they key. Both key strings named `DayEventTile` whatever the tile actually was, and now name the handle.
- `ResizeHandleDetails.resizeHandle` resolves the handle widgets from the context rather than from a `tileComponents` field, and its axis is optional, defaulting to the one being resized. `showStart`, `showEnd`, `continuesBefore`, `continuesAfter`, `isVertical`, `eventInteraction`, `startResizeDetector` and `endResizeDetector` are otherwise unchanged.
- `ResizeHandles.builder` is replaced by `TileComponents.buildResizeHandles`, which takes the details rather than seven positional arguments and returns a `Widget`. `DefaultResizeHandles` takes a `ResizeHandleDetails`.
- The trigger builders take a `BuildContext` as their first argument: `HorizontalTriggerWidgetBuilder` and `VerticalTriggerWidgetBuilder`, which covers `leftTriggerBuilder`, `rightTriggerBuilder`, `topTriggerBuilder` and `bottomTriggerBuilder` on every components class.
- The overlay builders take a `BuildContext` as their first positional argument, ahead of their named parameters: `multiDayOverlayBuilder`, `multiDayOverlayPortalBuilder`, `multiDayPortalOverlayButtonBuilder` and `MultiDayOverlayEventTileBuilder`. `MultiDayOverlayBuilder` drops `style` and `MultiDayOverlayPortalBuilder` drops `overlayStyles`. Resolve either with `KalenderTheme.of(context)`.
- `OverlayStyles` is removed. `MultiDayOverlayPortalBuilder` was the only signature that named it, so once that parameter went the class had no entry point left. Read the two styles off `KalenderTheme.of(context)`.

### Features

- The month week number gutter publishes the style it measures with, including its top alignment, to the scope it draws in. A custom `weekNumberBuilder` reads the month's value with `KalenderTheme.of(context)` where it previously had to be handed one.
- `ResizeHandle` is exported. It was already reachable as the return of `ResizeHandleDetails.startResizeDetector` with no way for an app to name it. It carries `event` and `direction`, so a handle is findable with `find.byType` and a predicate rather than only by key.
- `GutterStyles` is public, with `GutterStyles.timelineStyleOf` and `GutterStyles.weekNumberStyleOf`. A custom gutter builder can resolve the style the gutter is measured from, which a `KalenderTheme` scoped inside the calendar cannot move.

## 0.26.0

See [MIGRATION.md](MIGRATION.md#v025x--v0260) for what to change.

### Breaking Changes

- The style fields on `CalendarComponents` are removed, as their 0.25.0 deprecation named: `monthComponentStyles`, `multiDayComponentStyles`, `scheduleComponentStyles` and `overlayStyles`, along with their constructor and `copyWith` parameters and their places in `==` and `hashCode`. Use `KalenderThemeData`, or `KalenderTheme` to scope it to one calendar. The builder fields stay.
- The seven style container classes those fields reached go with them: `MonthComponentStyles`, `MonthBodyComponentStyles`, `MonthHeaderComponentStyles`, `MultiDayComponentStyles`, `MultiDayBodyComponentStyles`, `MultiDayHeaderComponentStyles` and `ScheduleComponentStyles`. `OverlayStyles` stays, since `MultiDayOverlayPortalBuilder` names it.
- `eventLayoutStrategy`, `generateMultiDayLayoutFrame` and `eventSnapStrategy` are classes rather than function typedefs, each with value equality and named factories for the built-ins: `EventLayoutStrategy.overlap()` and `.sideBySide()`, `MultiDayLayoutStrategy.byDuration()`, and `EventSnapStrategy.interval()`. A function cannot be deprecated into a class, so there is no window. [#380](https://github.com/werner-scholtz/kalender/issues/380)
- `HorizontalConfiguration.generateMultiDayLayoutFrame` is renamed to `multiDayLayoutStrategy` and is no longer nullable. It defaults to `MultiDayLayoutStrategy.byDuration()`, which `null` selected before.
- `CalendarEvent.copyWith` is removed. Override `copyWithData` instead and rebuild only what your subclass adds. The calendar calls `withDateTimeRange`, which applies that hook and then restores `id`, `interaction`, `multiDayRule` and `isAllDay` through `carryOver`. A missing hook is reported by `@mustBeOverridden` at analysis time and by a debug assert on the first drag. Your own `copyWith` is no longer an override, so it can take whatever parameters suit you.
- `CalendarEvent.interaction` and `CalendarEvent.multiDayRule` are getters rather than fields. Reading either is unchanged, and neither was assignable before.
- `HourLines.fromContext` no longer takes a `style` argument. It resolved the style from the theme and discarded what was passed. `timelineStyle` is unaffected.

### Behavior Changes

- A custom component builder receives the theme-resolved style rather than an empty one, so `style?.textStyle ?? myFallback` reaches the theme value where it used to reach the fallback. Read the fields you want to override rather than falling back on null. This affects `dayHeaderBuilder`, `daySeparator`, `hourLines`, `monthDayHeaderBuilder`, `monthGridBuilder`, `timeIndicator`, `timeline`, `weekDayHeaderBuilder`, `weekNumberBuilder` and `leadingDateBuilder`.
- `MultiDayOverlayPortalBuilder` receives a populated `OverlayStyles`, built by the new `OverlayStyles.fromContext`.
- `KalenderThemeData.weekNumberStyle.alignment` reaches the month week number, which ignored it before. The month still sits at the top by default, so only a calendar that set a non-default alignment moves. [#423](https://github.com/werner-scholtz/kalender/pull/423)
- A custom `weekNumberBuilder` receives the same resolved style in the month header as in the month body. [#423](https://github.com/werner-scholtz/kalender/pull/423)

### Features

- `CalendarEvent.isAllDay` places an event in the multi-day header lane whatever its duration, with no `MultiDayRule` consulted. It defaults to false, leaves the date range untouched, is carried across drags and resizes by `carryOver`, and takes part in `layoutEquals` and `hashCode`.
- `PageIndexCalculator` and its subclasses are exported. `ViewConfiguration.pageIndexCalculator` returns the type, which an app had no way to name. [#444](https://github.com/werner-scholtz/kalender/issues/444)
- `EventSnapStrategy.none()` leaves a dragged event where the cursor is.
- `defaultMultiDayFrameGenerator` stays public, so a custom `MultiDayLayoutStrategy` can reuse the built-in row assignment and change only the order events are placed in.
- `meta` is a direct dependency at `^1.9.0`, the version that introduced `@mustBeOverridden`.

### Deprecations

- `TimeOfDayRange.isAllDay` is renamed to `coversWholeDay` and will be removed in 0.27.0. It reports whether the range runs from 00:00 to 23:59, and the old name is wanted for `CalendarEvent.isAllDay`. `TimeOfDayRange.allDay()` is unchanged.

### Fixes

- `MultiDayViewConfiguration.week` and `.workWeek` honour `numberOfDays`. Both built their page index calculator with a hardcoded 7 and 5, so the body laid out `numberOfDays` columns under a header showing a full week, and every column sat out of line with its header. Both take 1 through 7, which shortens the page and leaves the weekly pagination alone. `copyWith` carries the value, where it reset it to the default before. [#444](https://github.com/werner-scholtz/kalender/issues/444)
- The month week number gutter and the multi-day timeline are measured once above both the header and the body, so the two halves cannot be given different widths. A `KalenderTheme` scoped to one half moved it and left the other behind, which put every day column out of line with its header. A scoped `weekNumberStyle` or `timelineStyle` the calendar has to ignore is now reported in debug builds.
- The week number label is centred when the visible range crosses a week boundary. The gutter is sized by the timeline rather than by the label, so `32 - 33` wraps and the short second line sat against the leading edge. [#427](https://github.com/werner-scholtz/kalender/pull/427)
- A custom `multiDayOverlayBuilder` or `multiDayPortalOverlayButtonBuilder` receives the style resolved from the theme.
- The overlay styles are resolved once, where a custom overlay builder needs them, rather than at four call sites in the header and the month body. `MultiDayOverlayPortal.overlayStyles` is optional, where null leaves each overlay widget to resolve its own.
- The Material defaults are built once per `ThemeData` rather than on every `KalenderTheme.of` call, which runs on nearly every widget build. The cache is keyed weakly on the theme.
- A schedule row resolves the theme only when it reads one of the two styles that need it.
- `MultiDayBodyConfiguration.keepPagesAlive` takes part in `==` and `hashCode`, so changing only that value reaches the calendar.
- `MonthBodyConfiguration` and `MultiDayHeaderConfiguration` no longer compare equal to each other, and the same for the two `VerticalConfiguration` subclasses. The base `==` tested only `other is HorizontalConfiguration` with no runtime type check.
- `MultiDayViewConfiguration.nowCallback` is included in `hashCode`, where it already took part in `==`.

### Tests

- Added coverage for the copy contract: a moved event keeps the identity, interaction and rule its subclass never mentions, the copy is the subclass's own type, a subclass with no hook is named by the assert, and the events controller still finds a dragged event by its id.
- Added coverage for `multiDayOverlayPortalBuilder`, which had none, across the `Overlay` boundary it is built into.
- Added coverage that a `KalenderTheme` scoped to the body cannot move the month week number gutter or the multi-day timeline away from what the header reserves, and that an ignored scoped value is reported once rather than on every frame.
- Added coverage that the drag target's gutter spacer matches the drawn gutter and that the timeline labels fit the box measured for them.
- Added equality coverage for the three strategy classes.
- Added coverage for a shortened week: the page length, that the pagination stays weekly, that `copyWith` carries the value, and that the header renders that many day headers.

## 0.25.0

See [MIGRATION.md](MIGRATION.md#v024x--v0250) for what to change.

### Breaking Changes

- `CalendarEvent.isMultiDayEvent` is removed. It was deprecated in 0.24.0, which named this release. Use `spansMultipleDays(location:, defaultRule:)`. See [MIGRATION.md](MIGRATION.md#v024x--v0250). [#410](https://github.com/werner-scholtz/kalender/pull/410)

### Features

- `KalenderTheme` is a widget, so a theme can be applied to part of the tree instead of the whole app. Wrap a calendar in `KalenderTheme(data: ..., child: ...)` and two calendars in one app can look different. The nearest one wins when they nest, and fields it leaves out still come from the `KalenderThemeData` registered on `ThemeData.extensions`, which keeps working as before. It is an `InheritedTheme`, so the theme also reaches the tile that follows a drag, which is built into an `Overlay` rather than below the calendar. [#414](https://github.com/werner-scholtz/kalender/pull/414)
- The style classes and `KalenderThemeData` are `Diagnosticable`, so their resolved values appear in the Flutter devtools inspector and in `toString()` instead of a bare instance hash. Fields left unset are omitted rather than printed as null. [#412](https://github.com/werner-scholtz/kalender/pull/412)

### Deprecations

- The style fields on `CalendarComponents` are deprecated and are removed in 0.26.0. Use `KalenderThemeData` for the whole app, or a `KalenderTheme` to scope one calendar. The same thirteen styles were reachable both ways, and `multiDayOverlayStyle` had four different homes. `CalendarComponents` keeps its builder fields. See [MIGRATION.md](MIGRATION.md#v024x--v0250). [#416](https://github.com/werner-scholtz/kalender/pull/416)

### Fixes

- Styling the month view's week number no longer moves it to the middle of its row. The top alignment came from a default on `MonthBodyComponentStyles`, so setting any week number style there replaced it. The month body now applies that alignment under your style, and keeps it unless you set an alignment of your own. In the month view a `KalenderThemeData` cannot change this alignment, because the style the month body passes to the widget takes precedence over the theme. The rest of `WeekNumberStyle` resolves from the theme as usual. [#416](https://github.com/werner-scholtz/kalender/pull/416) [#419](https://github.com/werner-scholtz/kalender/pull/419)
- `CalendarComponents`, the containers reached through it, `TileComponents` and `ScheduleTileComponents` compare by value, and `CalendarComponents` can be `const`. The inherited widgets carrying them reported a change on every rebuild because they compared by identity, and now report one only when something differs. [#409](https://github.com/werner-scholtz/kalender/pull/409)
- `CalendarComponents` and the containers reached through it gain `copyWith`. [#409](https://github.com/werner-scholtz/kalender/pull/409)

### Tests

- Added coverage for the scoped `KalenderTheme`: it applies below itself, takes precedence over the extension, and fills in from it field by field. The nearest scope wins when they nest, two calendars in one app can be themed differently, changing the data notifies dependents where an equal value does not, and `wrap` carries the theme into a tree built outside the calendar. [#414](https://github.com/werner-scholtz/kalender/pull/414)
- Added `Diagnosticable` coverage for every style class: a style reports the fields it sets and omits the ones it does not, and the theme reports the styles it carries. [#412](https://github.com/werner-scholtz/kalender/pull/412)
- Added equality coverage for `CalendarComponents`, the containers reached through it and `TileComponents`: each field breaks equality when it differs, a builder held as a top-level function stays equal across instances, and one written as a closure does not. [#409](https://github.com/werner-scholtz/kalender/pull/409)
- Added coverage that the month week number sits at the top of its row by default, and that a style set for the month keeps that alignment when it does not mention one. [#416](https://github.com/werner-scholtz/kalender/pull/416)
- Added the `KalenderThemeData` coverage no test reached: `hashCode`, the fields `==` compares after the third, and one `copyWith` fallback. [#408](https://github.com/werner-scholtz/kalender/pull/408)
- Added coverage that the time indicator follows the day while the app runs: it moves to the next column when the day rolls over, a rebuild every 30 seconds does not stop the day being noticed, a full day passing moves it off a page it no longer belongs to, and resuming the app corrects it after time passed. [#413](https://github.com/werner-scholtz/kalender/pull/413)

## 0.24.0

See [MIGRATION.md](MIGRATION.md#v023x--v0240) for what to change.

### Breaking Changes

- kalender no longer re-exports the whole `timezone` package. `Location` and `TZDateTime` are still exported. Everything else, including `getLocation` and `initializeTimeZones`, now needs `package:timezone` imported directly. [#375](https://github.com/werner-scholtz/kalender/pull/375)
- The seven string builders deprecated in 0.23.0 are removed from the component style classes. Their replacements on the matching `*Components` classes are unchanged. See [MIGRATION.md](MIGRATION.md#v022x--v0230) for the mapping. [#372](https://github.com/werner-scholtz/kalender/pull/372)
- `MonthDayHeaderStyle.textStyle` is removed. It never had any effect. The day number is styled by `numberTextStyle`. [#372](https://github.com/werner-scholtz/kalender/pull/372)
- Three long-deprecated members are removed. `CalendarCallbacks.onMultiDayTapped` was never called, so deleting it changes nothing. `DateTimeExtensions.monthNameEnglish` and `dayNameEnglish` are replaced by `monthNameLocalized('en')` and `dayNameLocalized('en')`. [#374](https://github.com/werner-scholtz/kalender/pull/374)
- `EventsController.eventsFromDateTimeRange` takes a required `multiDayRule`. This only affects code implementing `EventsController`. Pass the view configuration's rule. [#371](https://github.com/werner-scholtz/kalender/pull/371)
- `CalendarEvent.spansMultipleDays` takes a required `defaultRule` alongside `location`. A subclass overriding it must widen its signature to match. [#371](https://github.com/werner-scholtz/kalender/pull/371)
- `ScheduleTileComponents` no longer accepts `dropTargetTile`, `overlayTileBuilder` or `resizeDragAnchorStrategy`. None of them had any effect. Delete the arguments. To style the drop target, use `ScheduleComponents.scheduleTileHighlightBuilder` and `ScheduleTileHighlightStyle`. [#381](https://github.com/werner-scholtz/kalender/pull/381)
- `ScheduleTileComponents.emptyItemBuilder` and `monthItemBuilder` are moved to `ScheduleComponents`. Set them on `CalendarComponents.scheduleComponents` instead. Signatures and defaults are unchanged. See [MIGRATION.md](MIGRATION.md#v023x--v0240). [#383](https://github.com/werner-scholtz/kalender/pull/383)
- `CalendarInteraction.throttleMilliseconds` is removed. Drag updates are now combined into one per frame and follow the display's refresh rate. Nothing replaces it. Delete the argument. [#368](https://github.com/werner-scholtz/kalender/pull/368)
- `DragTargetUtilities` can only be applied to a `State`. It supplies `context` and `mounted` itself instead of requiring them from the host. A class applying the mixin to a `State` needs no change. Anything else no longer compiles. [#368](https://github.com/werner-scholtz/kalender/pull/368)

### Features

- Dragging a multi-day event down over the body keeps moving its drop target in the header, instead of freezing it until the cursor returns. Releasing over the body applies the date and keeps the time of day and duration. [#369](https://github.com/werner-scholtz/kalender/pull/369)
- `MultiDayRule` decides which events belong in the multi-day header rather than the day timeline. Set it once on the view configuration. `MultiDayRule.minimumDuration` at 24 hours is the default and matches the previous behavior. `MultiDayRule.calendarDays` treats anything crossing midnight as multi-day. A single event can override the rule with `CalendarEvent.multiDayRule`. [#367](https://github.com/werner-scholtz/kalender/pull/367) [#371](https://github.com/werner-scholtz/kalender/pull/371) [#376](https://github.com/werner-scholtz/kalender/pull/376)
- In debug builds, a drag or resize asserts that the event's `copyWith` forwarded `id` and `multiDayRule`. `copyWith` takes no parameter for either, so an override that omits them drops them on every copy, silently until selection or multi-day placement goes wrong. The message names the subclass and the argument to add. [#367](https://github.com/werner-scholtz/kalender/pull/367)

### Deprecations

- `CalendarEvent.isMultiDayEvent` is replaced by `spansMultipleDays(location:)`. The getter measured calendar days in UTC. It will be removed in 0.25.0. See [MIGRATION.md](MIGRATION.md#v023x--v0240). [#367](https://github.com/werner-scholtz/kalender/pull/367)

### Fixes

- View configurations built with the same arguments compare equal, so a rebuild no longer recreates the view controller and its layout caches. `PageIndexCalculator` and `ScheduleViewConfiguration` had no `==`. At 50 events a day, five rebuilds went from 105 vertical layout computations to none. [#404](https://github.com/werner-scholtz/kalender/pull/404)
- `ViewConfiguration.nowCallback` takes part in `==`. Pass a top-level or static function. [#404](https://github.com/werner-scholtz/kalender/pull/404)
- `CalendarView` attaches to a replaced `calendarController` instead of staying on the old one. [#404](https://github.com/werner-scholtz/kalender/pull/404)
- `CalendarInteraction` and `HorizontalConfiguration` compare every field in `==`. Four fields were missing, so changing only one of them never updated the calendar. [#364](https://github.com/werner-scholtz/kalender/pull/364)
- `CalendarSnapping` compares and copies `eventSnapStrategy`. Changing only the strategy had no effect, and `copyWith` reset it to `defaultSnapStrategy`. Pass a top-level or static function. [#402](https://github.com/werner-scholtz/kalender/pull/402)
- Dragging to create an event no longer reacts to a drag that started on a different calendar. [#366](https://github.com/werner-scholtz/kalender/pull/366)
- `ScrollTriggerConfiguration.copyWith` keeps `scrollAmount` instead of resetting it to the default. [#366](https://github.com/werner-scholtz/kalender/pull/366)
- `MultiDayViewConfiguration.copyWith` and `MonthViewConfiguration.copyWith` keep `multiDayRule` instead of resetting it to the default, and take a parameter to change it. `MonthViewConfiguration.copyWith` also keeps `nowCallback` and no longer takes an `eventPadding` parameter, which set nothing. [#387](https://github.com/werner-scholtz/kalender/pull/387)
- Removing an event no longer throws when its date index was never populated for that location. [#366](https://github.com/werner-scholtz/kalender/pull/366)
- Tapping the trailing edge of an event tile resolves to the last visible day instead of one day past it. [#366](https://github.com/werner-scholtz/kalender/pull/366)
- The two drag-target guards that decide whether an event may be dropped in the header or the body now use the calendar's location, so they agree with the rest of the calendar near midnight and across daylight saving changes. [#367](https://github.com/werner-scholtz/kalender/pull/367)
- A calendar whose locale has no intl data loaded now names the locale, the `initializeDateFormatting()` call to add and the library it comes from, instead of throwing intl's `LocaleDataException` from inside a build. [#382](https://github.com/werner-scholtz/kalender/pull/382)
- `TileComponents.overlayTileBuilder` is used again by the tiles in the multi-day overflow overlay. It had been ignored since 0.14.0. [#381](https://github.com/werner-scholtz/kalender/pull/381)
- The vertical layout delegate returns layout data for every event, even when two events share a hash code. The layout cache is keyed by that hash, so events sharing one previously left a tile with no layout data. `CalendarEvent.hashCode` is built from `id`, `start`, `end`, `interaction` and `multiDayRule`, so this needs a custom `EventsController` that gives two events the same `id`. [#370](https://github.com/werner-scholtz/kalender/pull/370)

### Tests

- Added equality coverage for the configuration classes: every field of `VerticalConfiguration` and `HorizontalConfiguration` breaks equality when it differs, two configurations built from the same arguments compare equal, and `nowCallback`, `initialTimeOfDay` and `initialHeightPerMinute` take part. [#364](https://github.com/werner-scholtz/kalender/pull/364) [#404](https://github.com/werner-scholtz/kalender/pull/404)
- Added `copyWith` round-trip coverage for the view and body configurations, so a field that is not being changed survives the copy. [#366](https://github.com/werner-scholtz/kalender/pull/366) [#387](https://github.com/werner-scholtz/kalender/pull/387)
- Added coverage that the vertical layout delegate returns one entry per child when two events share a hash code, including a subclass whose `hashCode` ignores the id, and when the cache is already warm. [#370](https://github.com/werner-scholtz/kalender/pull/370)
- Added coverage that a drag or resize asserts when the event's `copyWith` drops `id` or `multiDayRule`, and stays silent for an override that forwards both. [#367](https://github.com/werner-scholtz/kalender/pull/367)
- Added coverage that `TileComponents.overlayTileBuilder` renders the overflow overlay tiles, and falls back to `tileBuilder` when it is not set. [#381](https://github.com/werner-scholtz/kalender/pull/381)
- Added coverage that drag moves arriving within one frame coalesce into a single update, that the update uses the newest move, and that a move queued at the moment of the drop is discarded. [#368](https://github.com/werner-scholtz/kalender/pull/368)
- Added coverage for the multi-day rule on the view configurations, and that dragging a multi-day tile into the body keeps moving its header preview. [#367](https://github.com/werner-scholtz/kalender/pull/367) [#369](https://github.com/werner-scholtz/kalender/pull/369) [#371](https://github.com/werner-scholtz/kalender/pull/371)

## 0.23.0

Nothing in this release stops existing code from compiling. See [MIGRATION.md](MIGRATION.md#v022x--v0230) for what to change.

### Behavior Changes

Each of these changes what an unchanged calendar renders.

- The overflow button is labelled `+3` instead of `3 more`, with the number formatted for the calendar's locale so locales with their own numerals read correctly. [#349](https://github.com/werner-scholtz/kalender/pull/349)
- The schedule view abbreviates day names with `DateFormat.E` instead of cutting the full name at three characters, which was only correct in English. German reads `Mi` rather than `Mit`. [#354](https://github.com/werner-scholtz/kalender/pull/354)
- `MonthDayHeaderStyle.stringBuilder` was declared but never called. Its replacement is wired up, so a calendar that set the old field will now see the day number change. [#349](https://github.com/werner-scholtz/kalender/pull/349)
- `MonthBodyComponents.overlayBuilders` defaults to null, so `CalendarComponents.overlayBuilders` applies in the month view instead of being shadowed by an empty default. The builder-side twin of the style-side fix in 0.22.0. [#349](https://github.com/werner-scholtz/kalender/pull/349)

### Deprecations

Both are removed in 0.24.0.

- The seven string builders moved from the component style classes to the matching `*Components` classes and gained a `BuildContext` parameter, so a custom builder can read the calendar's locale. The old fields still apply when the new one is not set. [#349](https://github.com/werner-scholtz/kalender/pull/349)
- `MonthDayHeaderStyle.textStyle` has never had any effect. `MonthDayHeader` renders only a day number, styled by `numberTextStyle`. [#354](https://github.com/werner-scholtz/kalender/pull/354)

### Features

- `context.calendarLocale` reads the locale of the enclosing calendar, which is not necessarily the app's. [#349](https://github.com/werner-scholtz/kalender/pull/349)
- `EventsController` gained `replaceEvents`, which swaps the whole event set in one call. `DefaultEventsController` does it atomically: a single notification and no intermediate empty state, which suits reloading events from a source such as an imported `.ics` file. The base class provides a default that clears then adds, so custom controllers keep working unchanged. [#344](https://github.com/werner-scholtz/kalender/pull/344)

### Fixes

- The overflow button is now attributed to the day its events are on in right-to-left layouts. The layout frame orders its columns by text direction, but read them back as if they always ran left to right, so every button landed on the mirrored date. In a right-to-left month view with events on Wednesday the 29th, the buttons appeared on the 30th and 31st. `MultiDayLayoutFrame` gained an optional `textDirection`, which defaults to left to right, so a custom frame generator is unaffected. [#334](https://github.com/werner-scholtz/kalender/pull/334)

## 0.22.0

### Features

- `MultiDayOverlayStyle` gained `cardTheme`, `closeButtonStyle`, `barrierColor`, `width`, and `headerHeight`, so the overlay card, its close button, and the area behind it can be styled to match the rest of the app. The card and button take Flutter's own `CardThemeData` and `ButtonStyle`. All of them default to null, so the stock appearance is unchanged. [#325](https://github.com/werner-scholtz/kalender/pull/325)
- The date in the overlay header no longer looks like a button that does nothing when tapped, and it is highlighted when it is today, like the day number in every other view. [#325](https://github.com/werner-scholtz/kalender/pull/325) [#328](https://github.com/werner-scholtz/kalender/pull/328)
- The today highlight is now tonal in every view, instead of grey. It is drawn with a disabled button so that it is not tappable, and a disabled button paints itself in the disabled colors, which made the highlight read as "unavailable" rather than "today". The day header, month day header, schedule date, and multi-day overlay all share one implementation now, so they cannot drift apart. [#328](https://github.com/werner-scholtz/kalender/pull/328)

### Fixes

- The month view now uses the overlay builders and styles set on `monthComponents`/`monthComponentStyles` instead of letting the global `CalendarComponents.overlayBuilders` and `overlayStyles` shadow them. This matches what `CalendarComponents` documents and what the multi-day header already did. Only apps that set both are affected. [#323](https://github.com/werner-scholtz/kalender/pull/323)
- The multi-day overlay card no longer runs past the bottom of the view and gets clipped. It was positioned without being measured, so only its top and sides were clamped, which showed up when a day low in the month grid had more events than fit. The card now stays inside the view on all four sides, and its event list scrolls when the card would be taller than the view. [#324](https://github.com/werner-scholtz/kalender/pull/324)

## 0.21.0

### Features

- All component style classes (`DayHeaderStyle`, `TimelineStyle`, `HourLinesStyle`, and the rest) now support `copyWith`, `merge`, `lerp`, and value equality. This is groundwork for the upcoming theme extension. [#314](https://github.com/werner-scholtz/kalender/pull/314)
- Added `KalenderThemeData`, a `ThemeExtension` with one field per component style, and `KalenderTheme.of(context)`, which resolves it against centralized Material 3 defaults. Register it on `ThemeData.extensions` to style every calendar in the app, with animated theme changes supported. [#315](https://github.com/werner-scholtz/kalender/pull/315)
- The component widgets now resolve their appearance as widget style over theme extension over Material 3 defaults, so a registered `KalenderThemeData` takes effect everywhere. Two defaults changed on purpose: the time indicator line uses the color scheme's error color instead of always red, and the day number text in the month body and schedule view defaults to `bodyMedium` instead of being unstyled. [#316](https://github.com/werner-scholtz/kalender/pull/316)
- The month view's day number now has a small margin so the today highlight floats clear of the gridline above and the event tiles below. The margin and the button size can be adjusted through the new `MonthDayHeaderStyle.margin` and `MonthDayHeaderStyle.buttonSize` fields. [#320](https://github.com/werner-scholtz/kalender/pull/320)

### Fixes

- `MultiDayOverlayStyle.eventPadding` is now applied to each event in the overlay. It was ignored, and `eventsPadding` was used for both the event list and each individual event. [#316](https://github.com/werner-scholtz/kalender/pull/316)

## 0.20.0

### Features

- Multi-day and all-day events now render in the free-scroll view as a single tile spanning the day columns, instead of being split at each page boundary. They support the same interactions as the paged headers: create by dragging across the header, reschedule, resize, auto-scroll when a drag reaches the viewport edge, right-to-left layout, and the "+N more" overflow. [#78](https://github.com/werner-scholtz/kalender/issues/78) [#297](https://github.com/werner-scholtz/kalender/pull/297) [#298](https://github.com/werner-scholtz/kalender/pull/298) [#299](https://github.com/werner-scholtz/kalender/pull/299) [#300](https://github.com/werner-scholtz/kalender/pull/300) [#301](https://github.com/werner-scholtz/kalender/pull/301)

### Fixes

- `PageTriggerConfiguration.triggerWidth` is now applied. It was accepted but ignored, and `copyWith` dropped it, so the edge strip that starts a page change while dragging was always `pageWidth / 50`. That is still the default, but it can now be set. [#302](https://github.com/werner-scholtz/kalender/pull/302)
- Fixed free-scroll multi-day events disappearing after scrolling back to a day before the event's start. The multi-day layout cache is keyed by date range and is shared across the free-scroll band's moving window, so a window cached before an event existed kept returning an event-less frame. Changing events now clears the whole cache instead of only the visible window. [#306](https://github.com/werner-scholtz/kalender/pull/306)
- Fixed an event jumping to a neighbouring day when resizing it by its top or bottom edge. The resize handle anchored the drag to the column's edge, so the smallest sideways movement flipped the day. It now follows the pointer, so a small drift no longer changes the day while a deliberate drag across columns still does. [#312](https://github.com/werner-scholtz/kalender/pull/312)

### Tests

- Added free-scroll multi-day coverage: spanning tiles render as one tile and stay single while scrolling, create-by-drag, reschedule and edge auto-scroll work in the band, right-to-left renders and scrolls the right way, and the "+N more" overflow opens. [#297](https://github.com/werner-scholtz/kalender/pull/297) [#298](https://github.com/werner-scholtz/kalender/pull/298) [#300](https://github.com/werner-scholtz/kalender/pull/300) [#301](https://github.com/werner-scholtz/kalender/pull/301)
- Added coverage that dragging an event to the viewport edge advances the page in the paged header and body, and scrolls the body vertically. [#302](https://github.com/werner-scholtz/kalender/pull/302) [#304](https://github.com/werner-scholtz/kalender/pull/304)
- Added coverage that a free-scroll multi-day event stays visible when scrolling back to windows that were cached before the event was created. [#306](https://github.com/werner-scholtz/kalender/pull/306)
- Added coverage that resizing an event's bottom edge with a small horizontal drift keeps it on its own day. [#312](https://github.com/werner-scholtz/kalender/pull/312)

## 0.19.1

### Features

- Added `MultiDayBodyConfiguration.keepPagesAlive` (default `false`). When enabled, each visited multi-day page is kept alive and reused, so navigating back to it skips rebuilding every event tile. It is opt-in because cached pages stay in memory for the lifetime of the view. [#293](https://github.com/werner-scholtz/kalender/pull/293)

### Fixes

- Fixed back-to-back events (one ending exactly when the next begins) rendering as overlapping at some zoom levels. An event's top and bottom now come from one shared time-to-pixel conversion, so touching tiles line up exactly instead of splitting on a rounding difference. [#291](https://github.com/werner-scholtz/kalender/pull/291)

### Performance

- Sped up multi-day frame generation. [#289](https://github.com/werner-scholtz/kalender/pull/289)
- The `visibleEvents` notifier now only publishes when the set of visible events actually changes, avoiding redundant work for listeners. [#290](https://github.com/werner-scholtz/kalender/pull/290)
- The day view now builds only the event tiles within the visible scroll window (plus an overscan margin) instead of every event of the day, and skips the resize-handle scaffolding when resizing is disabled. [#292](https://github.com/werner-scholtz/kalender/pull/292)

### Tests

- Added a regression sweep that back-to-back events stay in separate groups across a wide range of zoom levels, start offsets and durations. [#291](https://github.com/werner-scholtz/kalender/pull/291)
- Added coverage that off-screen day tiles are culled and rebuilt when scrolled into view, and that a partially visible tile stays built. [#292](https://github.com/werner-scholtz/kalender/pull/292)

## 0.19.0

### Breaking Changes

- `monthDayHeaderBuilder` now receives a localized wall-clock `DateTime` instead of a UTC-flagged `InternalDateTime`, matching `dayHeaderBuilder`. [#248](https://github.com/werner-scholtz/kalender/issues/248)
- Replaced `ViewConfiguration.initialDateSelectionStrategy` with per-dimension view-transition options: `dateTransition` on all views, and `scrollTransition` / `zoomTransition` on `MultiDayViewConfiguration`, each with an optional resolver for custom logic. [#249](https://github.com/werner-scholtz/kalender/issues/249)
- View switches now preserve the vertical scroll (time-of-day) and zoom by default instead of resetting to `initialTimeOfDay`; opt out with `ScrollTransition.reset` / `ZoomTransition.reset`. [#249](https://github.com/werner-scholtz/kalender/issues/249)
- Renamed `EmptyDayBehavior.showToday` to `EmptyDayBehavior.showOnlyToday`, since it shows only today among empty days. [#253](https://github.com/werner-scholtz/kalender/issues/253)
- Replaced `MultiDayBodyComponents.prototypeTimeLine` with a `timelineWidth` builder that returns the gutter width directly (`double`). The multi-day body, header and drag overlay now share this one width, so customizing the timeline can no longer misalign the header. Removed the `PrototypeTimeline` widget and `PrototypeTimeLineBuilder`. [#180](https://github.com/werner-scholtz/kalender/issues/180)

### Features

- Added `restorePerView` transitions so each view can reopen its own last date, scroll, and zoom. [#249](https://github.com/werner-scholtz/kalender/issues/249)
- Added `CalendarController.visibleTimeOfDay` and the `CalendarCallbacks.onScrollPositionChanged` callback. [#249](https://github.com/werner-scholtz/kalender/issues/249)
- Added `ScheduleBodyConfiguration.leadingWidth` to control the schedule view's date-column width. [#253](https://github.com/werner-scholtz/kalender/issues/253)
- Added `TimelineStyle.width` to set an explicit multi-day timeline gutter width. [#180](https://github.com/werner-scholtz/kalender/issues/180)
- Added `MonthBodyComponents.monthDayCellBuilder` to style individual month-view day cells. Each call reports the cell's date, whether it is today, and whether it falls in the focused month (so adjacent-month days can be styled differently). Also added the ready-made `MonthDayCell.shadeAdjacentMonths()` builder, which shades leading/trailing adjacent-month days. Pass a `color` or let it default to a low-opacity `onSurface` overlay that greys them out. [#140](https://github.com/werner-scholtz/kalender/issues/140)
- Added `eventPadding` to `MonthBodyConfiguration` (forwarded from the constructor and through `copyWith`), so month event tiles can be spaced like `MultiDayHeaderConfiguration` already allows. [#252](https://github.com/werner-scholtz/kalender/issues/252)

### Fixes

- Fixed schedule view event tiles not lining up; every row now shares a fixed-width leading column whether or not it shows a date. [#253](https://github.com/werner-scholtz/kalender/issues/253)
- Fixed the continuous schedule view scrolling to the wrong position when today has no events; the initial scroll and `animateToDateTime` now target today, or the nearest day when it is hidden. [#253](https://github.com/werner-scholtz/kalender/issues/253)
- Fixed the free-scroll multi-day header "wobbling" (re-animating its height) whenever a calendar item changed; its paged content now keeps its state across rebuilds instead of being rebuilt from scratch. [#282](https://github.com/werner-scholtz/kalender/pull/282)
- Fixed the free-scroll multi-day header clipping days that have more events than the leading day; the header now sizes to the tallest day currently in view. [#283](https://github.com/werner-scholtz/kalender/pull/283)
- Fixed the multi-day/week header drifting out of alignment with the body when the timeline used a custom `stringBuilder` or width; the gutter width now has a single source. [#180](https://github.com/werner-scholtz/kalender/issues/180)
- The timeline gutter width now accounts for the text scale factor, so it no longer under-sizes when text is enlarged. [#180](https://github.com/werner-scholtz/kalender/issues/180)
- The timeline gutter now measures every label across the day rather than a single sample, so a custom label format whose widest entry is not at 23:59 no longer clips. [#180](https://github.com/werner-scholtz/kalender/issues/180)

### Tests

- Added end-to-end `CalendarView` regression coverage for the time indicator, run across the timezone matrix. [#261](https://github.com/werner-scholtz/kalender/issues/261)
- Added end-to-end `CalendarView` today-highlighting coverage, run across the timezone matrix. [#254](https://github.com/werner-scholtz/kalender/issues/254) [#251](https://github.com/werner-scholtz/kalender/issues/251)
- Added continuous schedule regression coverage for row alignment and the no-events-today scroll target. [#253](https://github.com/werner-scholtz/kalender/issues/253)
- Added end-to-end month-view regression coverage for a custom `generateMultiDayLayoutFrame`. [#235](https://github.com/werner-scholtz/kalender/issues/235)
- Added regression coverage that the free-scroll header keeps its paged content's state across rebuilds. [#282](https://github.com/werner-scholtz/kalender/pull/282)
- Added regression coverage that the free-scroll header fits the tallest visible day rather than only the leading page. [#283](https://github.com/werner-scholtz/kalender/pull/283)
- Added regression coverage that the multi-day header and body day columns stay aligned across custom label formats, explicit widths, and right-to-left. [#180](https://github.com/werner-scholtz/kalender/issues/180)
- Added regression coverage that a selected month-view event's focus aligns to its own row. [#233](https://github.com/werner-scholtz/kalender/issues/233)
- Added coverage that `monthDayCellBuilder` is invoked per day with the correct focused-month flags, and that `MonthDayCell.shadeAdjacentMonths()` shades only the adjacent-month days. [#140](https://github.com/werner-scholtz/kalender/issues/140)

## 0.18.7

### Fixes

- Fixed a blank page when a `displayRange` spanned exactly one month, and the same off-by-one page count that dropped the final in-range page in the week, custom multi-day, and paginated schedule views. [#266](https://github.com/werner-scholtz/kalender/issues/266)
- Fixed the month view showing a "+N more" overflow button when there were no events, and on very short row heights. Added end-to-end regression coverage. [#255](https://github.com/werner-scholtz/kalender/issues/255)

## 0.18.6

### Features

- Added optional month-view week numbers via `MonthViewConfiguration.showWeekNumbers`, with customizable `MonthBodyComponents.weekNumberBuilder` and `MonthBodyComponentStyles.weekNumberStyle`.

### Fixes 

- Fixed a month-view regression where the `dropTargetTile` preview could fail to render while resizing an event.

## 0.18.5

### Fixes

- Fixed an issue where the highlighted selection border (`dropTargetTile`) was painted on the wrong tile or missing entirely in month view overlapping events and the "X more" overflow drop-down.
- Fixed a bug where the `TimeIndicator` would disappear when zooming the calendar before any page navigation had occurred.

## 0.18.4

### Fixes

- Reverted `ResizeHandle` and `ResizeHandles` now take a `length` parameter.

### Features

- Added `resizeDragAnchorStrategy` to TileComponents.

## 0.18.3

### Fixes

- `ResizeHandle` and `ResizeHandles` now take a `length` parameter to provide properly sized `Draggable` feedback widgets instead of an empty layout, improving the resizing feedback.

## 0.18.2

### Features

- `TapDetail` from `*WithDetail` callbacks now calculates the exact `DateTime` under the cursor or finger tap based on spatio-temporal position within the event UI, rather than returning the event's start time.

---

## 0.18.1

### Features

- Added support for secondary gestures (right-clicks) on empty calendar spaces: `onSecondaryTapped`, `onSecondaryLongPressed` and their `WithDetail` variants. 
- Added support for secondary gestures (right-clicks) on events: `onEventSecondaryTapped` and `onEventSecondaryTappedWithDetail`.

### Fixes

- Fixed an issue where `DayDetail` and `MultiDayDetail` exposed internal `InternalDateTime` and `InternalDateTimeRange` objects without timezone offsets applied. All tap details now correctly apply `.forLocation()` to expose wall-clock DateTimes to consumers.
- Fixed some raw callbacks (`onLongPressed`, `onSecondaryLongPressed`) leaking internal representations instead of `.forLocation()` adjusted ones.

---

## 0.18.0

### Features

- New `NowCallback` typedef and `ViewConfiguration.nowCallback` field to decouple the time indicator, today highlighting, and schedule empty-day logic from the calendar's configured `Location`.
- `InternalDateTime.isToday()` now accepts an optional `DateTime? now` parameter, allowing callers to override what "today" means.
- `DayHeader`, `MonthDayHeader`, and `ScheduleDate` read `nowCallback` from the view configuration and use it for today highlighting. When set, it takes priority over the `Location`-based check.
- `EmptyDayBehavior.showToday` in `ScheduleBody` now respects `nowCallback`.
- Added static `todayKey` constants on `DayHeader`, `MonthDayHeader`, and `ScheduleDate` for easier widget-test assertions.

### Fixes

- TimeOfDay extensions (incorrect copyWith)
- Week and DayHeaders returning InternalDateTime
- Resize handle dragAnchorStrategy
- CalendarEvent passed to builders (sometimes outdated)

### Tests

- Added unit tests for `InternalDateTime.isToday(now:)` parameter.
- Added widget tests for `nowCallback`-driven today highlighting across `DayHeader`, `MonthDayHeader`, and `ScheduleDate`.
- Added widget tests for time indicator positioning with `nowCallback`.

---

## 0.17.0

### Breaking Changes

- `ResizeHandlePositioner` typedef now takes an additional `bool isImprecise` parameter.
- `ResizeHandles` abstract class now requires an `isImprecise` constructor parameter.

### Features

- New `InputMode` enum (`auto`, `precise`, `imprecise`) on `CalendarInteraction` replaces platform-based mobile/desktop detection for resize handle behavior.
- Resize handle positioning and visibility is now driven by input precision (mouse/stylus/trackpad vs touch) instead of platform (`iOS`/`Android`).
- `InputMode.auto` (default) detects input type dynamically — hover triggers precise mode, selection triggers imprecise mode.
- New `allowHorizontalImpreciseResize` option on `CalendarInteraction` to opt-in to horizontal resize handles for touch input (disabled by default).
- `CalendarInteraction.resolveIsImprecise()` provides a way to query the resolved input mode.
- Removed direct `isMobileDevice` usage from resize handle widgets.

---

## 0.16.0

### Breaking Changes

- `CalendarEvent` is no longer generic. The `data` field and `<T>` type parameter have been removed. Custom data should now be added by **extending** `CalendarEvent` directly.
- Event IDs changed from `int` to `String`. This affects `addEvent` (returns `String`), `addEvents` (returns `List<String>`), `removeById`, `byId`, and any code that stores or compares event IDs.
- `EventTile.eventId` is now a `String`.
- `MultiDayOverlayEventTile` renamed to `MultiDayEventOverlayTile`.
- `EventsController` folder moved into the `controllers` folder; update any direct imports.

### Features

- `CalendarEvent` is now extensible. Attach custom fields (title, color, etc.) by sub-classing and overriding `copyWith`. See the updated examples for guidance.
- `CalendarEvent` gained a `layoutEquals` method used internally for optimized layout rebuilds.

### Fixes

- `fix:` SnapPoints calculation.
- `fix:` Visible events not updating correctly after a change.
- `fix:` Pointer events now pass through the time indicator widget.
- Various bugs uncovered by the expanded test suite.

### Improvements

- `EventLayoutDelegateCache` is now cleared automatically when `heightPerMinute` changes.
- `eventsFromDateTimeRange` — the `location` parameter is no longer required.
- Vertical drag-target behavior improved.
- `DefaultEventsController` is now exported from `kalender.dart` directly.

### Tests

- Extensive test additions and refactoring across controllers, layout delegates, drag targets, interactions, view configurations and callbacks.
- Added a tool (`tool/test_timezones_linux.dart`) for running the test suite under multiple timezones on Linux.

### Contributors

- `CalendarEvent` extensibility, `EventsController` as a full interface, and event/group ID migration to `String` contributed by [RedDuality](https://github.com/RedDuality).

## 0.15.0
- feat: Added timezone support.
- feat: Use `linked_pageview` package for linked scrolling between multi-day header and body. [PR #247](https://github.com/werner-scholtz/kalender/pull/247)
- fix: Wrong current date highlighting due to extension method issues. [PR #260](https://github.com/werner-scholtz/kalender/pull/260) / [#251](https://github.com/werner-scholtz/kalender/issues/251)
- fix: Schedule body rendering issue.
- fix: SnapPoints calculation.
- fix: `EventLayoutDelegateCache` not being cleared when `heightPerMinute` changes.
- fix: `MultiDayViewController` now correctly exposes a page offset listener.
        
### Breaking Changes

- Added InternalDateTime and InternalDateTimeRange classes accessible through `kalender/extensions.dart`.
- Moved `asUtc` and `asLocal` extensions to InternalDateTime.
- `EventLayoutStrategy` now takes a `InternalDateTime` instead of a DateTime.
- `GenerateMultiDayLayoutFrame` now takes a `InternalDateTimeRange` instead of a DateTime.
- `CalendarEvent` stores start and end times in utc format.
- Removed initial date from `CalendarController`  this is now set in the `ViewConfiguration` of the `CalendarWidget`. ****
- Replaced `visibleDateTimeRangeUtc` valueNotifier in the `CalendarController` with a nullable `internalDateTimeRange`. (`visibleDateTimeRange` is remains the same).
- The `EventsController.eventsFromDateTimeRange` now uses `InternalDateTimeRange` and takes a nullable `Location` from the timezone package.
- Changes to the `DefaultDateMap` to accommodate different timezones, any custom implementations will need to be updated.
- `EventTileUtils` mixin was also updated to use the new internal date time classes.
- `PageNavigationFunctions` was renamed to `PageIndexCalculator` and updated to use internal date time classes.
- Multiple default components where updated to use the new internal date time classes instead of date time classes.
- ViewConfiguration renamed `selectedDate` to `initialDateTime`.
- `CalendarHeader` and `CalendarBody` no longer take `ValueNotifiers` and will instead create and dispose ValueNotifiers created from values passed to them.

## 0.14.3
- feat: Made TextAlign and TextOverflow configurable for TimelineStyle. [PR #242](https://github.com/werner-scholtz/kalender/pull/242) Thanks to [quaaantumdev](https://github.com/quaaantumdev)
- fix: Various issues while dragging events on multi-day view. [PR #240](https://github.com/werner-scholtz/kalender/pull/240) Thanks to [redninjacat](https://github.com/redninjacat).
- fix: Drag and drop issues. [PR #238](https://github.com/werner-scholtz/kalender/pull/238) Thanks to [redninjacat](https://github.com/redninjacat).
- fix: erroneous warning in month_body [PR #237](https://github.com/werner-scholtz/kalender/pull/237) Thanks to [redninjacat](https://github.com/redninjacat).

## 0.14.2
- fix: Tile and ResizeHandleWidget rebuild issues.

## 0.14.0
- feat: Custom onWillAcceptWithDetails functions for DragTargets. [#213](https://github.com/werner-scholtz/kalender/issues/213)

### API Change
- Resize Handles are now only rendered when the cursor is hovering on a tile or when a tile is selected on mobile.
- Added a [ResizeHandles] abstract widget and [DefaultResizeHandles] widget that allows for more customization.
- Replaced vertical/horizontal resize handle positioners from [TileComponents] with a single [ResizeHandlePositioner].

## 0.13.1
- fix: MultiDayLayoutFrameCache using `toString()` to generate map key. [#225](https://github.com/werner-scholtz/kalender/issues/225)

## 0.13.0
- feat: Improved TimeLine and HourLines widgets. [#216](https://github.com/werner-scholtz/kalender/issues/30?issue=werner-scholtz%7Ckalender%7C216)
- feat: Improved DayHeader and DayHeaderStyle. [PR #218](https://github.com/werner-scholtz/kalender/pull/218)
- feat: Improved CalendarCallbacks. [#133](https://github.com/werner-scholtz/kalender/issues/133) / [#30](https://github.com/werner-scholtz/kalender/issues/30)
        - Added `onTappedWithDetail`, `onLongPressed` and `onLongPressedWithDetail` callbacks.
        - Deprecated `onMultiDayTapped`. (Use `onTappedWithDetail` instead).
        - Not providing `onEventTapped` and `onEventTappedWithDetail` will remove internal gesture detectors for events, removing interference for GestureDetectors added to EventTileBuilders.
        - Added mixins (`DayEventTileUtils` and `MultiDayEventTileUtils`) for EventTileBuilders that have their own gesture detectors.
        - Added `onEventCreateWithDetail` as used in the new advanced example.
- fix: DayDragTarget `calculateLocalCursorPosition`, add scroll offset after converting to local coordinate space.

## 0.12.0
- feat: Added `eventComparator` to `defaultMultiDayFrameGenerator` thanks to [captaingerhard](https://github.com/captaingerhard). [PR #210](https://github.com/werner-scholtz/kalender/pull/210)

## 0.11.1
- fix: Too many day separators in MultiDayView Free Scroll [#208](https://github.com/werner-scholtz/kalender/issues/208)
- fix: PageNavigationFunctions.indexFromDate [#211](https://github.com/werner-scholtz/kalender/issues/211)

## 0.11.0
- feat: Added interaction (EventInteraction) property to calendar events for fine grained control. [#194](https://github.com/werner-scholtz/kalender/pull/194)
- fix: Events rendered as overlapping under certain conditions when they are not overlapping. [#200](https://github.com/werner-scholtz/kalender/issues/200)
- fix: Overlay positioning and dismiss behavior. [#203](https://github.com/werner-scholtz/kalender/issues/203)

## 0.10.2
- fix: DefaultEventsController ConcurrentModificationError. [#184](https://github.com/werner-scholtz/kalender/issues/184)

## 0.10.1
- fix: Time indicator not rendered under the correct date. [#182](https://github.com/werner-scholtz/kalender/issues/182)

## 0.10.0

- feat: Added locale property to CalenderView allowing users to specify a language with the [intl](https://pub.dev/packages/intl) package. [#172](https://github.com/werner-scholtz/kalender/issues/172)
- feat: Add string builder to MultiDayPortalOverlayButtonStyle for easy override of the text. [#172](https://github.com/werner-scholtz/kalender/issues/172)
- fix: MultiDayPortalOverlayButtonStyle not using style overrides. [#172](https://github.com/werner-scholtz/kalender/issues/172)
- fix: Overlap when scrolling. [#174](https://github.com/werner-scholtz/kalender/issues/174)
- fix: ScheduleView reload issues. [#170](https://github.com/werner-scholtz/kalender/issues/170)

## 0.9.1

- fix: ScheduleViewController ItemPositionsListener was not initialized. [#170](https://github.com/werner-scholtz/kalender/issues/170)

## 0.9.0

- feat: preserve visible date when switching between different views. [#165](https://github.com/werner-scholtz/kalender/issues/165)
- docs: updated `MonthBodyComponents` in readme to include all custom components. [#168](https://github.com/werner-scholtz/kalender/issues/168)

## 0.8.0

### Features

- Reimplemented schedule view. [discussion 122](https://github.com/werner-scholtz/kalender/discussions/122), [#130
](https://github.com/werner-scholtz/kalender/issues/130)
- The tile builder is no longer a required parameter, default tiles are now provided. (Highly recommended to override these.)

## 0.7.2

- fix: Calendar event at 00:00 not visible (zero duration) [#159](https://github.com/werner-scholtz/kalender/issues/158)
- fix: Export the necessary classes to allow for custom a `GenerateMultiDayLayoutFrame`. [#162](https://github.com/werner-scholtz/kalender/issues/162)

## 0.7.1

- fix: Calendar event at 00:00 not visible [#159](https://github.com/werner-scholtz/kalender/issues/158)
  * Note: This makes minor changes to the abstract class EventLayoutDelegate.
- fix: Long event causes all following events to intend. [#142](https://github.com/werner-scholtz/kalender/issues/142)

## 0.7.0

### Features
- Ability to limit the number of events in MultiDayHeader.  [#141](https://github.com/werner-scholtz/kalender/pull/141) / [#147](https://github.com/werner-scholtz/kalender/issues/147)
    - `MultiDayHeaderConfiguration` Changes:
        - Added `maximumNumberOfVerticalEvents`
        - Added `generateMultiDayLayoutFrame`
    - Added `overlayBuilders` to `MultiDayHeaderComponents` for customizing the overlay.
- MonthBody limits the number of events displayed based on size constraints. [#141](https://github.com/werner-scholtz/kalender/pull/141) / [#147](https://github.com/werner-scholtz/kalender/issues/147)
    - Added `overlayBuilders` to `MonthBodyComponents` for customizing the overlay.
- Added a new callback `OnEventTappedWithDetail`. [#141](https://github.com/werner-scholtz/kalender/pull/141) / [#148](https://github.com/werner-scholtz/kalender/issues/148)

### Migrations
- Deprecated [MultiDayEventLayoutStrategy](https://github.com/werner-scholtz/kalender/blob/dc009aa40b80d1ee04a1b950f449389b3130f644/lib/src/layout_delegates/multi_day_event_layout_delegate.dart#L8) this should be migrated to use the new `GenerateMultiDayLayoutFrame`

### Improvements
- The `defaultMultiDayGenerateFrame` improves on the `defaultMultiDayLayoutStrategy` by allowing events to fill empty spaces.

### Fixes
- Week view not showing correct range when first day of week is something other than monday. [#150](https://github.com/werner-scholtz/kalender/issues/150)
- Events not snapping to closest. [#155](https://github.com/werner-scholtz/kalender/issues/155)

## 0.6.7

- fix: Rescheduling event triggering an assert. [#144](https://github.com/werner-scholtz/kalender/issues/144)
- fix: TimeIndicator rendering on incorrect day. [#143](https://github.com/werner-scholtz/kalender/issues/143) 

## 0.6.6

- fix: MultiDayHeaderWidget layout regressions.
- Added widget tests for MultiDayHeaderWidget.

## 0.6.5

- fix: SingleDayView RenderFlex overflow.

## 0.6.4

- fix: MonthGrid not taking number of rows into consideration. [#131](https://github.com/werner-scholtz/kalender/issues/131)

## 0.6.3

- fix: Event snapping not always working.

## 0.6.2

- fix: Calendar sometimes displays wrong initial date. [314ff4e](https://github.com/werner-scholtz/kalender/commit/314ff4e3a649f9d6dc97442a13207de7c382dd39)

## 0.6.1

- Changed `VerticalTileResizeHandlePositioner` to never use more than 1/4 of the height of the event tile on desktop.

## 0.6.0
* Package will use Semantic versioning from 0.6.0 onwards.

### Breaking changes
- The `EventsController` is now an abstract class, use `DefaultEventsController` instead.
- The `ViewConfiguration` no longer contains the configuration for `interaction` and `snapping`.
    These are now separate classes that are passed directly to the `Body`/`Header`.

### What's new
- There is a new callback `onTapped` in `CalendarCallbacks`.
    * This is now called when the user taps on an empty space a calendar (Multiday body).
- There is a new callback `onMultiDayTapped` in `CalendarCallbacks`.
    * This is called when the user taps on an empty space in the calendar (Multiday Header / Month body).
- MultiDayBodyConfiguration added `horizontalPadding` this padding is located between events and the edge of day.
- There is now a `CalendarInteraction` and `CalendarSnapping` class that can be passed to the `CalendarBody` / `CalendarHeader` as a ValueNotifier.
    This allows the calendar view to change these behaviors without rebuilding the entire view.
- `CalendarSnapping` now has a `eventSnapStrategy` that can be used to define custom snapping behavior when creating new events. [#119](https://github.com/werner-scholtz/kalender/issues/119)

### Fixes
- Month day header export [PR #115](https://github.com/werner-scholtz/kalender/pull/115)
- Month grid export [PR #112](https://github.com/werner-scholtz/kalender/pull/112)
- Month not display all dates [PR #129](https://github.com/werner-scholtz/kalender/pull/129)

### Boring stuff
- Lots of new unit tests that run in multiple timezones to ensure there are no regressions.
- Example directory layout has changed.

## 0.5.0

### Breaking changes:
Version 0.5.0 has quite a few Breaking changes, there is no easy way to migrate to this version. Here are a few important things that have changed.

- The [CalendarView](https://github.com/werner-scholtz/kalender/blob/main/lib/src/calendar_view.dart) now takes a `header` [CalendarHeader](https://github.com/werner-scholtz/kalender/blob/main/lib/src/calendar_header.dart) and `body` [CalendarBody](https://github.com/werner-scholtz/kalender/blob/main/lib/src/calendar_body.dart) widgets. You can wrap these widgets in other widgets to style them as seen [here](https://github.com/werner-scholtz/kalender/blob/9a053c9daac51985bbbb336393d5013ef3977bd0/example/lib/main.dart#L112)

- Event tiles now make use of the [Draggable](https://api.flutter.dev/flutter/widgets/Draggable-class.html) widget provided by flutter.
Take a look at the [TileComponents](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/tile_components.dart) for more details on how tiles work now. This opens some interesting possibilities for displaying multiple calendars.

- The [CalendarCallbacks](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/calendar_callbacks.dart) (previously `CalendarEventHandlers`) have been changed so more information is given when an interaction occurs.

- The schedule view has been removed, but will be reimplemented in the future.

### What's new

- Auto scroll/paging (https://github.com/werner-scholtz/kalender/issues/75 && https://github.com/werner-scholtz/kalender/issues/64)
- Calender can now accept Draggable's (https://github.com/werner-scholtz/kalender/issues/48)
- More information for the TileBuilder (https://github.com/werner-scholtz/kalender/issues/83)

## pre-0.5.0
- https://github.com/werner-scholtz/kalender/blob/main-0.4.2/CHANGELOG.md