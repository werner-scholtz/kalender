# Roadmap

> [!WARNING]
> Work in progress. This is a draft of the intended direction, not a commitment. Anything here can change or be dropped, and nothing in it should be planned around. [CHANGELOG.md](CHANGELOG.md) is the record of what has actually shipped.

Where kalender is going, and what has to happen before 1.0.0.

Nothing here carries a date. Work is sequenced by release, and a release ships when it is ready.

## What 1.0.0 means

kalender is pre-1.0, so a breaking change can land in a minor version. A caret range keeps you on the minor version you chose, which is where fixes land, and every minor bump has an entry in the [migration guide](MIGRATION.md).

After 1.0.0 a breaking change needs a major version, so the API has to be one worth keeping first. That cuts two ways. Anything that would **change** existing API has to happen before the freeze, or it costs a 2.0.0. Anything that **adds** API wants to happen before it too, because a feature designed under a freeze has to live with whatever shape it was given on the first attempt.

So "Before 1.0.0" holds both: the breaking work, and the features that introduce new surface. Some of it has a release attached and some does not. "Not blocking 1.0.0" is what changes no public API at all.

## Before 1.0.0

### 0.24.0, done

All five items planned for this release shipped. See [CHANGELOG.md](CHANGELOG.md) for the full list, which is longer, since the release also absorbed work that was never planned here.

- **Split the readme.** Reference material moved to `doc/` and the readme kept the overview.
- **Remove the deprecated string builders,** along with `MonthDayHeaderStyle.textStyle`.
- **Stop re-exporting the whole `timezone` package.** `Location` and `TZDateTime` stayed.
- **Widen value equality on `CalendarInteraction` and `HorizontalConfiguration`.** Four missing fields, each one a change that never reached the calendar. This grew too. `CalendarSnapping` was dropping its snap strategy, and `ScheduleViewConfiguration` and `PageIndexCalculator` had no `==` at all, so every rebuild recreated the view controller and its layout caches.
- **Fix what counts as a multi-day event.** This grew past the planned fix. Rather than correcting `isMultiDayEvent` in place, the decision became a `MultiDayRule` on the view configuration, with a per-event override, and the old getter is deprecated.

Five further breaking changes landed that were not planned here: `throttleMilliseconds` was removed in favour of combining drag updates per frame, `DragTargetUtilities` became a `State`-only mixin, three long-deprecated members were removed, `ScheduleTileComponents` dropped three parameters that did nothing, and its two row builders moved to `ScheduleComponents`. Ten breaking changes in one release against the four this section planned is worth noting for the next one, since batching them was the reason the section existed.

### 0.25.0, theming shape, done

The theme extension arrived in 0.21.0 and the string builders moved out of the style classes in 0.23.0. What is left is where kalender still differs from Flutter's own component themes.

- **`KalenderTheme` becomes an `InheritedWidget`.** Today it is a static lookup, so a theme cannot be scoped to part of the widget tree. Flutter's component themes can be, and the current name implies this one can too.
- **Style classes become `Diagnosticable`,** so resolved values appear in Flutter devtools the way Material's theme classes do.
- **Revisit how deeply the style containers nest.** Reaching a single style means `CalendarComponents` to `MultiDayComponentStyles` to `MultiDayHeaderComponentStyles` to `dayHeaderStyle`. Flutter puts the property on the widget instead. The containers on that path are also the only style classes with no `==`, which does not matter while nothing compares them and would start mattering if this work does.
- **Decide how much of Material kalender should require. Settled: Material stays the default look, and the calendar keeps requiring it for now.** Layout and interaction do not depend on it, so a framework neutral core remains reachable, but nothing is split in this release.

  What decided it: `ThemeExtension` is defined in Flutter's Material library and has no equivalent in `widgets.dart`, so as long as the theme rides on it the package requires Material by construction. The widgets are not the obstacle. Six Material widgets are used anywhere in `lib/` (`IconButton`, `Material`, `ListTile`, `Card`, `Icons` and `InkWell`) and each has a plain replacement.

  What this release did instead is shrink where Material is read, so a later split is a move rather than a rewrite. `KalenderTheme` is now an `InheritedTheme`, which lives in `widgets.dart`, so the transport is already framework neutral. Flutter's `Theme.of` is now read directly in six files, down from eight: three widgets were falling back to it for a value `KalenderThemeData.defaults` had already resolved, so they read the theme twice and could disagree with it. Of the six that remain, one is the theme file itself, one guards a public function that accepts any style, one deliberately inherits the app's `CardThemeData`, and three cover values the theme has no field for. Splitting later means moving `defaults` and the extension lookup into a Material layer and leaving the rest alone.

  **Three public fields keep Material in the API regardless**, and are worth revisiting before 1.0.0 since changing them is breaking: `MultiDayOverlayStyle.cardTheme` is a `CardThemeData`, `MultiDayOverlayStyle.closeButtonStyle` is a `ButtonStyle`, and `WeekNumberStyle.visualDensity` is a `VisualDensity`. A neutral core cannot name any of those types.

One unrelated removal rides along, because 0.24.0 promised it here. **`CalendarEvent.isMultiDayEvent` is removed,** as its deprecation message says. `spansMultipleDays` replaces it.

### 0.26.0, the styles and the copy contract, done

Three breaking items, plus the all-day flag and one fix that arrived while the release was still open. The first is contractual: the deprecation message shipped in 0.25.0 names this release by number, so it is the one item here that has a deadline rather than an argument.

The all-day flag was scoped out to 0.27.0, on the argument that new public API does not belong in the same migration guide as the two largest removals the package has done. It came back. Only `0.26.0-dev.1` ever reached pub.dev, so the release was still open when the flag merged, and nothing about it is breaking, so it costs the migration guide nothing.

**1. The deprecated style fields on `CalendarComponents` are removed.** Four fields, along with their constructor and `copyWith` parameters and their places in `==` and `hashCode`. Larger than the deprecation implied: 25 read sites across 17 files, most of them the `fromContext` helpers on the component widgets. The seven container classes reached through those fields go with them, which empties `month_styles.dart`, `multi_day_styles.dart` and `schedule_styles.dart`. Only the fields carry a deprecation, so the classes are removed without a window of their own. Once the fields are gone nothing public reaches them, so a window would protect a type annotation and nothing else.

  `OverlayStyles` is the exception and stays. `MultiDayOverlayPortalBuilder` names it, and that typedef is not deprecated, so the class keeps earning its place as the portal builder's parameter bundle. Its signature does not change.

  The builders receive the theme-resolved style rather than null, which leaves them better off than today, where a custom builder gets an empty style unless the app used the deprecated container.

  The month week number needs one fix first. Its top alignment can only be set through `MonthBodyComponentStyles` today, because the month body passes that style to the widget and a passed style wins over the theme, so removing the container would make the alignment unreachable. Dropping the unconditional `Alignment.center` from `KalenderThemeData.defaults` lets the month body read the theme instead, since the widget already falls back to centre on its own. That part is non-breaking on its own and can land ahead of the removal.

  One behavior change follows. Afterwards the only route to that alignment is `KalenderThemeData.weekNumberStyle`, which feeds both the month gutter and the multi-day header, so an app cannot set them apart any more. Defaults are unaffected, so this reaches only an app that set a non-default alignment.

**2. Base class state stops routing through your `copyWith`.** Every field `CalendarEvent` carries that `copyWith` takes no parameter for is a field each subclass has to forward by hand. That is `id`, and `multiDayRule` since 0.24.0. 0.24.0 added a debug assert that reports the omission on the first drag, but the better fix is to make it unrepresentable. This is the largest single break in the release.

  `copyWith` leaves `CalendarEvent` entirely rather than staying on the base as a method subclasses may not override. The base gains a method the calendar calls, a hook a subclass overrides to rebuild its own fields, and a helper that reapplies identity, interaction and classification to whatever the hook returned. A subclass then keeps its own `copyWith` under its own name, with whatever parameters it likes, and stops being an override. Every copy the calendar makes passes only a date range, while consumers use the widened form, so leaving `copyWith` on the base and forbidding overrides would have made `copyWith(title:)` illegal for nothing.

  A subclass that adds no hook still compiles, so the omission is reported twice. `@mustBeOverridden` flags it in the app's own analysis before anything runs, and the debug assert that replaces the 0.24.0 pair checks the returned type on the first drag for anyone who ignores the warning. That assert is stronger than what it replaces, since it catches a subclass that wrote no hook at all rather than one that forgot a field.

**3. Strategy function fields become classes.** [#380](https://github.com/werner-scholtz/kalender/issues/380) carries the full inventory. A function field that takes part in `==` reads as a change on every rebuild when it is written as an inline closure, and one left out of `==` means a change to it never reaches the calendar. Both failure modes have shipped. `MultiDayRule` and `PageIndexCalculator` are the shape to follow, in the form that stays open: a public abstract base with a const constructor and named factories for the built-ins, so an app can write its own strategy and give it value equality. `advanced_example` already passes a custom layout, so a closed set of built-ins would take that away.

  Checking each field rather than treating the six as one group changed the answer for half of them. `generateMultiDayLayoutFrame` is the one that pays: it sits behind a comparison that clears the whole layout frame cache, so an inline closure costs a cache clear and a relayout on every build. `eventSnapStrategy` sits behind a real gate too. `eventLayoutStrategy` currently gates nothing, since it reaches the calendar through the widget tree rather than through `==`, and it converts anyway so the three read as one design. `nowCallback` stays a function, because it takes no arguments and has nothing to model, and its place in `==` is what makes a change reach the calendar at all. The three view-transition resolvers need no work: they are correctly out of `==` and already read from the incoming configuration.

  Two equality gaps turned up while checking, both unrelated to function fields and neither breaking. `MultiDayBodyConfiguration.keepPagesAlive` is not covered by the equality it inherits, and the body and header configuration base classes test only `other is X` with no runtime type check, so two different configuration types with matching fields can compare equal.

**4. Whether an event is all-day becomes something you can state.** The calendar inferred it from duration through `MultiDayRule`, and the per-event rule override doubled as the way to force it, which that field's own documentation admitted when it described an event "all-day by nature rather than by duration". That never worked for the case it named: an event under 24 hours inside one calendar day satisfies neither built-in rule, so forcing it meant overriding `spansMultipleDays`.

  `CalendarEvent.isAllDay` states it. A plain `bool` defaulting to false, so nothing changes for an event that does not set it. True means the multi-day header lane whatever the duration, with no rule consulted. A nullable tri-state was rejected: "not all-day" and "no opinion" want the same answer, since an event spanning several days has to stay in the header either way. The date range is untouched, and `carryOver` carries the flag across drags like `id` and `multiDayRule`, so it is not a third field to forward by hand.

  The name went to the event, because that is what every calendar format calls it. `TimeOfDayRange.isAllDay` becomes `coversWholeDay`, deprecated for one release: it reports whether the range runs 00:00 to 23:59, which is about the hours the body lays out, so it had the wrong name regardless. The `TimeOfDayRange.allDay()` factory is left alone, since renaming it touches every example, doc and test for a cosmetic gain and a constructor named "all day" does not read as an event property.

  The ICS example needed more than first recorded. RFC 5545 encodes all-day as a date-valued `DTSTART`, but the `isAllDayEvent` getter on `enough_icalendar` reads a proprietary Microsoft property instead, so the standard signal is read off the value type of the property. The example discarded it at parse time and exported an all-day event as a timed one. It now maps to `isAllDay` and writes `VALUE=DATE` back out, a date-valued `DTSTART` with no `DTEND` lasts one day rather than one hour, and `sample.ics` carries one.

  A shorter way to call `spansMultipleDays` was scoped alongside the flag and is dropped. Every verbose call site is inside the package, and the shortest form needs a `BuildContext` that two of the eight sites do not have. Making `defaultRule` optional is the only shape that reads shorter everywhere, and omitting it would silently substitute the package default for the calendar's own rule, which compiles and renders wrong. What is left is an internal tidy-up with no public API in it.

**5. A week view honours `numberOfDays`.** [#444](https://github.com/werner-scholtz/kalender/issues/444). `MultiDayViewConfiguration.week` and `.workWeek` both took the parameter and built their page index calculator with a hardcoded 7 and 5, so the body laid out `numberOfDays` columns under a header showing the hardcoded count, and every column sat out of line with its header. `WeekIndexCalculator` already carries `daysToDisplay`, which shortens the page and leaves the weekly pagination alone, so the fix is to pass the value in. `copyWith` dropped it too.

  `PageIndexCalculator` is exported with it, the second half of the same issue. `ViewConfiguration.pageIndexCalculator` returns the type, so it was already public with no way for an app to name it.

  What this does not do is let an app pick arbitrary visible days. See [#90](https://github.com/werner-scholtz/kalender/issues/90) below.

### 0.27.0, the builders take a context, done

One concept, across the widest customisation surface the package has. It gets a release of its own rather than riding along with model changes, and it happens before 1.0.0 because a freeze would put it behind a 2.0.0. What the plan below did not anticipate is how much doing it turned up, which the last three items record.

`TimeOfDayRange.isAllDay` is removed here, as its 0.26.0 deprecation message names. `coversWholeDay` replaces it. Done, and it leaves `lib/` with no deprecation outstanding.

**Every builder typedef takes a `BuildContext` first.** Fifteen of the twenty-four carry a style, and fourteen of those take no context, so a custom builder cannot call `KalenderTheme.of` and resolve anything for itself. The package resolves on its behalf and passes the result in, which is the only reason a style parameter sits on those signatures at all. The nine that carry no style take no context either. They change in the same release because a typedef signature cannot be deprecated in place, so each round of this is a hard break and splitting the work would break one concept twice.

Flutter does the opposite, and does it inside the widget. `Divider` and `Card` read the component theme in `build` and fall back per property. `ButtonStyleButton` does the same for a whole style object, resolving the widget's style over the theme's over the defaults. Nothing in Flutter hands a child a pre-resolved style through its constructor, and the two merge helpers that look like exceptions, `DefaultTextStyle.merge` and `IconTheme.merge`, merge into the inherited scope so descendants still resolve from context themselves.

kalender's own widgets already follow the Flutter shape. `WeekNumber.build` resolves the passed style over the theme over its own fallback. Only the builder path cannot, and only for want of a context.

Giving the builders one removes the reason for every pre-merge in the package, and the style parameters go with them, with no exceptions. The gutter family looked like one. `TimelineWidthBuilder`, `TimeLineBuilder` and `HourLinesBuilder` resolve against `GutterStyles`, the scope the multi-day body, header and drag overlay all measure from, rather than against the theme, and a debug assert reports the case where a scoped theme moves the two apart. `GutterStyles` is already an `InheritedWidget` with `of` and `maybeOf`, so it becomes public here and a custom builder resolves from it exactly as `TimeLineUtils.effectiveStyle` already does. `MultiDayOverlayPortalBuilder` drops its `OverlayStyles` parameter, and the bundle goes with it: it was the only signature that named the class, so nothing was left for it to answer.

The default for each builder moves off the widget and onto the components class that holds it, the shape `ScrollConfiguration.of(context).buildScrollbar(context, child, details)` uses. Fields become nullable and default to null, which makes "did the app override this" a question the package can ask. It cannot today: `month_body.dart` decides whether to build the day cell layer by comparing the field against `MonthDayCell.builder`, because a non-null tear-off default leaves nothing else to compare. Both statics on each component, `builder` and `fromContext`, are removed.

**`ResizeHandlePositioner` was reshaped as well, which the plan above did not cover.** Giving it a context exposed that it was the odd one of the twenty-four on three counts at once: seven parameters against five for the next largest, a return type constrained to an abstract class, and the only builder anywhere in the package that required subclassing. The six values it received were exactly the constructor arguments of the class it had to return, so every implementation forwarded them by hand, and the appearance guide showed no way to write one at all. It pointed at a preamble symbol that threw `UnimplementedError`, whose comment pointed back at the guide.

  `ResizeHandles` is removed. Its six values and seven helpers move to `ResizeHandleDetails` and the positioner returns a plain `Widget`, which is the shape `MonthDayCellBuilder` already had with `MonthDayCellDetails`. Doing it in this release rather than the next one costs a single migration entry, where waiting would have broken the same typedef twice for one concept.

**Three times now, public API has named a type nothing exported.** `PageIndexCalculator` was the first, returned by `ViewConfiguration.pageIndexCalculator` and fixed in 0.26.0. `ResizeHandleDetails.startResizeDetector` returns the resize draggable, which no app could name. `MultiDayOverlayEventTileBuilder` returns `MultiDayEventOverlayTile`, which made that typedef public but impossible to implement. Both remaining ones are exported now, and a test implements every builder with a constrained return type, so the analyzer catches the next one rather than a user.

  Exporting the resize draggable also renamed it. `ResizeHandle` is the obvious name for the widget an app supplies through `TileComponents.verticalResizeHandle`, so publishing the package's own class under that name collided with the expected case, and the web demo stopped compiling. It is `ResizeDetector`, which is what `ResizeHandleDetails` already called it.

**The tile key factories are unreachable.** Nine of the package's twenty-two `static Key` factories sit on classes nothing exports, so `DayEventTile.tileKey` and its siblings are internal test helpers with public spelling. Whether they are API or not is unsettled and is not urgent, since a widget carrying its own identifying fields is findable without one. Flutter's answer is worth recording: the framework publishes no key factories at all, and its own tests use `find.byType` over `find.byKey` roughly four to one.

### 0.28.0, the next breaking window

The breaking changes with nowhere cheaper to go. None has a deprecation path that costs less than doing it in a release that already breaks, so they wait for the next such release rather than for 1.0.0. Batching them is the point: a break that lands on its own costs a migration entry and a minor version for one item.

**`OnEventTapped` drops its `RenderBox`, and so does `OnEventTappedWithDetail`.** `TapDetail` carries the same object, so the parameter was a duplicate on the second and the only route to the box on the first. Both are trimmed rather than one, which leaves a short form and a full form instead of one callback being a subset of the other. That is the shape `OnEventCreate` and `OnEventCreateWithDetail` already had. Of the eight call sites in the examples and the guides, seven ignored the box. The web demo used it to anchor an event overlay and moves to the detail callback.

  The naming settled with it. A callback is named for the detail type it carries, so `OnTappedWithDetails` and `OnLongPressedWithDetails` lose the plural to match their single `TapDetail`, and the two `OnWillAccept` typedefs keep it to match `DragTargetDetails`. Every field already used the singular.

**`MultiDayBodyConfiguration` and `VerticalConfiguration` stay separate.** The TODO on the first said to merge them and has been dropped. It was written when `VerticalConfiguration` was extracted, at which point the subclass added nothing, and `keepPagesAlive` landed nine months later without the TODO being revisited.

Merging needs a concrete survivor, since `MultiDayBody` builds an instance and `VerticalConfiguration` is abstract. `HorizontalDragTarget` would then stay typed against an abstract axis base while `VerticalDragTarget` became typed against a concrete view class, which is the asymmetry that matters, since it is in the code rather than in the names. `CalendarBody` also names its three configuration fields after views rather than axes, so renaming would leave one field whose name does not match its type. No second vertical implementation exists or is planned: the two views on this roadmap are grids, and `ScheduleBodyConfiguration` shares three of the eight fields and takes no configuration object in its drag target at all. The cost of keeping both is about sixty lines, mostly `copyWith`.

**`CreateEventGesture` is now `EventInteractionGesture`.** The old name said "create" and the enum also decides how an event is modified, which is why `CalendarInteraction` carries it twice, as `createEventGesture` and `modifyEventGesture`. A public enum cannot be renamed behind a deprecation, so it went into this batch or nowhere. The two field names are unchanged.

**The `default*` constants take a `k` prefix.** Twelve public top-level constants are renamed, and four already carried the prefix, so the package spelled the same kind of constant two ways. Flutter prefixes its public top-level constants and Effective Dart says not to use prefix letters, and the tie is broken by the four that already have it. The `default*` top-level functions keep their names, as do the `static const default*` members on `CalendarInteraction` and `CalendarSnapping`, since a class already namespaces its own.

**Whether the tile key factories are public API.** Nine of the twenty-two `static Key` factories sit on classes nothing exports, so `DayEventTile.tileKey` and its siblings cannot be reached from an app at all. Either the tiles are exported or the factories stop being public, and both are breaking. 0.27.0 showed the third option works: `ResizeDetector` carries `event` and `direction`, so it is findable with `find.byType` and a predicate and needs no key. Flutter publishes no key factories anywhere and its own tests use `find.byType` over `find.byKey` about four to one.

**A `ResizeHandleStyle`, moved here from the theming list.** It adds rather than changes API, so it needs no breaking window, but it belongs with the resize handle work the previous release started. `KalenderThemeData` carries thirteen style classes and the resize handles are the only thing the calendar draws without one. The handle length is a hardcoded 24 for imprecise input and 16 otherwise, with a TODO on it in `DefaultResizeHandles`. Less pressing since 0.27.0, because changing the layout is now a lambda where it used to mean subclassing an abstract class.

**`FreeScrollFunctions` is removed, and it took a defect with it.** Its TODO asked whether `DayIndexCalculator` could replace it. The two were the same code but for one line, and that line rounded the end of the display range up to the next midnight whatever it was, so a range already ending at midnight gained a day and the band drew a column outside it. Every other calculator guards that end with a conditional. The default range ends at midnight, as does any range written the usual way, so most free scroll calendars had it. `MultiDayViewConfiguration.type` joins `==` and `hashCode` with it, since the calculator's runtime type was what told a free scroll configuration apart from a single day one.

### Theming, still open

**Three public fields keep Material in the API,** carried forward from 0.25.0 since changing them is breaking: `MultiDayOverlayStyle.cardTheme` is a `CardThemeData`, `MultiDayOverlayStyle.closeButtonStyle` is a `ButtonStyle`, and `WeekNumberStyle.visualDensity` is a `VisualDensity`. A framework neutral core cannot name any of those types. No release is attached, so they can ride along with the next breaking one or wait.

The missing `ResizeHandleStyle` moved to 0.28.0 above.

### Tests

Coverage is 92.3% of lines, up from 88.2% at 0.24.0 and 84.4% at 0.23.0. It gates the composability work below, and that gate is now met.

Both columns are line coverage of the directory and everything under it, measured with `flutter test --coverage`.

| Area | 0.24.0 | Now | What is missing |
|---|---|---|---|
| `models/` | 87% | 89% | Recovered, and past the 0.24.0 figure, once the directory below was covered. |
| `models/components/` | not tracked | 98% | Done. `copyWith`, `==` and `hashCode` on the nine components classes had no test at all. What is left is six bare `@override` lines that lcov counts and no test can reach. |
| `models/mixins/` | 84% | 84% | Untouched. |
| `models/view_configurations/` | 83% | 84% | `schedule_view_configuration.dart` at 42%. |
| `widgets/drag_targets/` | 71% | 91% | Done. `schedule_drag_target.dart` went from 10 of its 87 lines to 82, which covered the whole reschedule path in the schedule view. |
| `widgets/event_tiles/` | 81% | 82% | Barely moved. `multi_day_overlay_tile.dart` at 31% and `schedule_tile.dart` at 39%. |
| `theme/` | 78% | 97% | Done. 0.25.0 rewrote this code and tested it, taking it from the lowest covered area to one of the highest. |

The rest runs from 79% to 100% with no large gap.

Both areas the 0.24.0 backfill named are now closed, so the coverage gate on the composability work below is met. What is left is smaller and spread out: `schedule_view_configuration.dart` at 42%, `multi_day_overlay_tile.dart` at 31% and `schedule_tile.dart` at 39%.

The pattern from 0.24.0 held again, in that closing a gap turned something up. Covering the schedule drag target showed that a drop takes the time of day from the target day rather than keeping the event's, so a 09:00 meeting moved to another day lands at midnight. The multi-day body keeps it. The components classes were sound: the tests found no dropped field, which matches the audit done during 0.27.0.

### Composability

No release attached yet. It reshapes public API, so the shape has to settle before 1.0.0, and it touches enough of the package that it waits on the test coverage above.

Theming was the first part of a larger idea: assembling a calendar from parts rather than configuring one whole. Three pieces are unbuilt.

- **The state layer is closed.** The providers carrying calendar state are private, so nothing outside the package can read them.
- **View types are hardcoded.** Three switches map a `ViewConfiguration` to its controller, body and header, so a view type cannot be added without forking.
- **There are no cell or background slots.** The bodies and headers expose nowhere to draw behind or inside a cell.

This is also the gate on most of the feature list below, which is the argument for doing it rather than leaving it under investigation. Five of the nine open feature issues are waiting on one of those three pieces.

### Features

Most of the open issues should land before 1.0.0 rather than after it. Each one adds public API, and 1.0.0 is the point where adding it stops being cheap. They are grouped by what they are waiting on rather than by demand, because the grouping is what decides the order.

**Waiting on composability.** These cannot be built cleanly against the package as it stands.

| Issue | Needs |
|---|---|
| [#215](https://github.com/werner-scholtz/kalender/issues/215) a portal for every cell in the month body | The state layer. The overlay portal controller is created privately. |
| [#89](https://github.com/werner-scholtz/kalender/issues/89) customize each cell | Cell slots in the multi-day body, plus selection for its range-drag half. |
| [#262](https://github.com/werner-scholtz/kalender/issues/262) select a cell | Selection as a concept the calendar knows about. Buildable in the month view today, not in the multi-day body. |
| [#40](https://github.com/werner-scholtz/kalender/issues/40) yearly view | A view registry, and the state layer to build against. |
| [#264](https://github.com/werner-scholtz/kalender/issues/264) mobile month view | The same two. A grid of days over a list, not a configuration of the current month view. |

Selection is the thread through the middle three. There is no `selectedDate` on the controller and no `isSelected` on a cell, so it is app owned today, and one addition serves all of them.

**Independent.** These wait on nothing and can land in any release.

| Issue | Shape |
|---|---|
| [#90](https://github.com/werner-scholtz/kalender/issues/90) hide and show weekends | A set of visible weekdays on the view configuration. Changes which dates a page carries, so it reaches the date arithmetic rather than only the layout. Scoped below. |
| [#98](https://github.com/werner-scholtz/kalender/issues/98) named and uneditable time regions | A second thing the calendar draws besides events, that events sit on top of. The largest new model here. |
| [#259](https://github.com/werner-scholtz/kalender/issues/259) drag to create over a locked event | A drag starting on an unmodifiable event should fall through to creation instead of doing nothing. Mostly behavior. |
| [#280](https://github.com/werner-scholtz/kalender/issues/280) animated transitions between views | Opt-in, default off, reduced-motion aware, wrapping the controller swap in `CalendarView`. |

**Arbitrary visible weekdays, [#90](https://github.com/werner-scholtz/kalender/issues/90), needs the page to stop being one date range.** 0.26.0 covers the contiguous case with `numberOfDays` on `week` and `workWeek`, which is what the reporter of [#444](https://github.com/werner-scholtz/kalender/issues/444) asked for. Every contiguous span starting on `firstDayOfWeek` is expressible that way, so what a set of weekdays adds is the non-contiguous case, Monday, Wednesday and Friday, and a span that starts somewhere other than `firstDayOfWeek`.

That is not a parameter. A page is a contiguous `DateTimeRange` throughout the package, and a day's index within that range is what maps to pixels. Six places do that arithmetic: `event_tile_utils.dart` turns a drag position into a date by dividing by the column count and indexing the range's dates, the multi-day event widget and both layout strategies place a header tile by its first and last day index, the day separator count and the time indicator both derive from the column count, and the free-scroll band is built on day index equalling pixel offset. Each needs a column-to-date mapping instead. `CalendarController.visibleDateTimeRange` and the `onPageChanged` callback are a single range, which a gapped page makes untrue, and both are public. The events controller fetches by range, so hidden-day events arrive and have to be dropped per column. An app asking for Monday to Saturday most likely wants the month grid at six columns too, which reaches the month body, the week number gutter and the row-count logic in `MonthIndexCalculator`.

One design question comes first: does a hidden day vanish, leaving six columns, or is it skipped, leaving a page that still spans seven calendar days with six drawn? The two are the same for Monday to Saturday and differ for Monday, Wednesday and Friday, and the answer decides what `visibleDateTimeRange` reports. Adding the set later costs no deprecation, since `numberOfDays` can be derived from its length.

Multi-column days, so several calendars can sit side by side within one day, is not filed yet and belongs in the first group.

### 1.0.0

When the list above is settled and the API has held still for a release or two. How much of the feature list lands first is a judgement call rather than a fixed bar, but the ones that add API are far cheaper before the freeze than after.

## Not blocking 1.0.0

Neither of these changes public API, so neither one is a reason to hold the release.

### Performance

Frame timings for every view and workload are tracked on the [benchmarks dashboard](https://werner-scholtz.github.io/kalender/dev/bench/).

Slow frames come from the size of the widget, render and semantics tree, not from the layout algorithms. A week at fifty events per day is about 350 tiles, and navigating builds all of them. The levers are tile weight and doing less work per navigation.

- **Deferred tile rendering for dense days.** A new column of many events renders no tiles on its first frame and fills them in on the next, moving the cost off the navigation. Prototyped, and opt-in because it changes render timing. One run measured week navigation at 30ms against 54ms, still to be confirmed over several runs.
- **Lighter event tiles.** Every event builds a draggable, a gesture detector, resize handles and an entry in a parallel drop target column. Fewer widgets and semantics nodes per tile is the largest remaining lever. One attempt measured worse than what it replaced.
- **A bounded version of `MultiDayBodyConfiguration.keepPagesAlive`,** which is currently unbounded and grows with the number of distinct pages visited.
- **Recycling day tiles rather than culling them,** building on the geometry model added when culling landed. Culling only helps tiles that are off screen, so it does little for a desktop week at default zoom.
- **Revisit the schedule view,** the slowest of the four when this work started and untouched by the fixes that followed.
- **Explain the schedule rescheduling step change at 0.24.0.** The benchmark roughly doubled at the merge that replaced `throttleMilliseconds` with per-frame coalescing, to 1.97ms at ten events per day and 3.92ms at fifty. Part of it is expected, since the old throttle dropped moves and the average was taken over frames that did no work, but the missed frames in the same run are not explained by that.
- [#222](https://github.com/werner-scholtz/kalender/issues/222) performance when swiping, still unconfirmed.

### Documentation

- Group the API reference. It lists 189 symbols in one alphabetical run with no categories, so nothing marks out the handful most people need.

## Decided against

Asked for often enough to be worth answering here.

- **An event type that carries your data.** Attaching data means subclassing `CalendarEvent` and writing `copyWith`, `==`, `hashCode` and `layoutEquals` yourself. A generic version would save the typing, but those four methods are where calendar performance is won or lost, and hiding them invites a heavy payload and skipped equality checks. The readme documents the pattern.

## Influencing this

Within each group under "Features" the ordering follows demand. If something there matters to you, say so on its issue. If what you need is missing, [open one](https://github.com/werner-scholtz/kalender/issues/new).

Anything that needs the API to change or to grow is far cheaper to act on before 1.0.0 than after it, so raise it now rather than later.
