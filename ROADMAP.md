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

- **Split the readme.** Reference material moved to `doc/` and the readme became the shop window.
- **Remove the deprecated string builders,** along with `MonthDayHeaderStyle.textStyle`.
- **Stop re-exporting the whole `timezone` package.** `Location` and `TZDateTime` stayed.
- **Widen value equality on `CalendarInteraction` and `HorizontalConfiguration`.** Four missing fields, each one a change that never reached the calendar. This grew too. `CalendarSnapping` was dropping its snap strategy, and `ScheduleViewConfiguration` and `PageIndexCalculator` had no `==` at all, so every rebuild recreated the view controller and its layout caches.
- **Fix what counts as a multi-day event.** This grew past the planned fix. Rather than correcting `isMultiDayEvent` in place, the decision became a `MultiDayRule` on the view configuration, with a per-event override, and the old getter is deprecated.

Five further breaking changes landed that were not planned here: `throttleMilliseconds` was removed in favour of combining drag updates per frame, `DragTargetUtilities` became a `State`-only mixin, three long-deprecated members were removed, `ScheduleTileComponents` dropped three parameters that did nothing, and its two row builders moved to `ScheduleComponents`. Ten breaking changes in one release against the four this section planned is worth noting for the next one, since batching them was the reason the section existed.

### 0.25.0, theming shape

The theme extension arrived in 0.21.0 and the string builders moved out of the style classes in 0.23.0. What is left is where kalender still differs from Flutter's own component themes.

- **`KalenderTheme` becomes an `InheritedWidget`.** Today it is a static lookup, so a theme cannot be scoped to part of the widget tree. Flutter's component themes can be, and the current name implies this one can too.
- **Style classes become `Diagnosticable`,** so resolved values appear in Flutter devtools the way Material's theme classes do.
- **Revisit how deeply the style containers nest.** Reaching a single style means `CalendarComponents` to `MultiDayComponentStyles` to `MultiDayHeaderComponentStyles` to `dayHeaderStyle`. Flutter puts the property on the widget instead. The containers on that path are also the only style classes with no `==`, which does not matter while nothing compares them and would start mattering if this work does.
- **Decide how much of Material kalender should require. Settled: Material stays the default look, and the calendar keeps requiring it for now.** Layout and interaction do not depend on it, so a framework neutral core remains reachable, but nothing is split in this release.

  What decided it: `ThemeExtension` is defined in Flutter's Material library and has no equivalent in `widgets.dart`, so as long as the theme rides on it the package requires Material by construction. The widgets are not the obstacle. Six Material widgets are used anywhere in `lib/` (`IconButton`, `Material`, `ListTile`, `Card`, `Icons` and `InkWell`) and each has a plain replacement.

  What this release did instead is shrink where Material is read, so a later split is a move rather than a rewrite. `KalenderTheme` is now an `InheritedTheme`, which lives in `widgets.dart`, so the transport is already framework neutral. Flutter's `Theme.of` is now read directly in six files, down from eight: three widgets were falling back to it for a value `KalenderThemeData.defaults` had already resolved, so they read the theme twice and could disagree with it. Of the six that remain, one is the theme file itself, one guards a public function that accepts any style, one deliberately inherits the app's `CardThemeData`, and three cover values the theme has no field for. Splitting later means moving `defaults` and the extension lookup into a Material layer and leaving the rest alone.

  **Three public fields keep Material in the API regardless**, and are worth revisiting before 1.0.0 since changing them is breaking: `MultiDayOverlayStyle.cardTheme` is a `CardThemeData`, `MultiDayOverlayStyle.closeButtonStyle` is a `ButtonStyle`, and `WeekNumberStyle.visualDensity` is a `VisualDensity`. A neutral core cannot name any of those types.

One unrelated removal rides along, because 0.24.0 promised it here. **`CalendarEvent.isMultiDayEvent` is removed,** as its deprecation message says. `spansMultipleDays` replaces it.

### 0.26.0, the styles and the copy contract

Three items, all breaking. The first is contractual: the deprecation message shipped in 0.25.0 names this release by number, so it is the one item here that has a deadline rather than an argument.

The all-day flag and the `spansMultipleDays` shortener moved to 0.27.0. They add public API and teach a new concept, which does not belong in the same migration guide as the two largest removals the package has done. 0.24.0 shipped ten breaking changes and the section above already calls that worth not repeating.

**1. The deprecated style fields on `CalendarComponents` are removed.** Four fields, along with their constructor and `copyWith` parameters and their places in `==` and `hashCode`. Larger than the deprecation implied: 25 read sites across 17 files, most of them the `fromContext` helpers on the component widgets. The seven container classes reached through those fields go with them, which empties `month_styles.dart`, `multi_day_styles.dart` and `schedule_styles.dart`. Only the fields carry a deprecation, so the classes are removed without a window of their own. Once the fields are gone nothing public reaches them, so a window would protect a type annotation and nothing else.

  `OverlayStyles` is the exception and stays. `MultiDayOverlayPortalBuilder` names it, and that typedef is not deprecated, so the class keeps earning its place as the portal builder's parameter bundle. Its signature does not change.

  The builders receive the theme-resolved style rather than null, which leaves them better off than today, where a custom builder gets an empty style unless the app used the deprecated container.

  The month week number needs rescuing: its top alignment can only be set through `MonthBodyComponentStyles` today, because the month body passes that style to the widget and a passed style wins over the theme, so removing the container would make the alignment unreachable. Dropping the unconditional `Alignment.center` from `KalenderThemeData.defaults` lets the month body read the theme instead, since the widget already falls back to centre on its own. That part is non-breaking on its own and can land ahead of the removal.

  One behavior change follows. Afterwards the only route to that alignment is `KalenderThemeData.weekNumberStyle`, which feeds both the month gutter and the multi-day header, so an app cannot set them apart any more. Defaults are unaffected, so this reaches only an app that set a non-default alignment.

**2. Base class state stops routing through your `copyWith`.** Every field `CalendarEvent` carries that `copyWith` takes no parameter for is a field each subclass has to forward by hand. That is `id`, and `multiDayRule` since 0.24.0. 0.24.0 added a debug assert that reports the omission on the first drag, but the better fix is to make it unrepresentable. This is the largest single break in the release.

  `copyWith` leaves `CalendarEvent` entirely rather than staying on the base as a method subclasses may not override. The base gains a method the calendar calls, a hook a subclass overrides to rebuild its own fields, and a helper that reapplies identity, interaction and classification to whatever the hook returned. A subclass then keeps its own `copyWith` under its own name, with whatever parameters it likes, and stops being an override. Every copy the calendar makes passes only a date range, while consumers use the widened form, so leaving `copyWith` on the base and forbidding overrides would have made `copyWith(title:)` illegal for nothing.

  A subclass that adds no hook still compiles, so the omission is reported twice. `@mustBeOverridden` flags it in the app's own analysis before anything runs, and the debug assert that replaces the 0.24.0 pair checks the returned type on the first drag for anyone who ignores the warning. That assert is stronger than what it replaces, since it catches a subclass that wrote no hook at all rather than one that forgot a field.

**3. Strategy function fields become classes.** [#380](https://github.com/werner-scholtz/kalender/issues/380) carries the full inventory. A function field that takes part in `==` reads as a change on every rebuild when it is written as an inline closure, and one left out of `==` means a change to it never reaches the calendar. Both failure modes have shipped. `MultiDayRule` and `PageIndexCalculator` are the shape to follow, in the form that stays open: a public abstract base with a const constructor and named factories for the built-ins, so an app can write its own strategy and give it value equality. `advanced_example` already passes a custom layout, so a closed set of built-ins would take that away.

  Checking each field rather than treating the six as one group changed the answer for half of them. `generateMultiDayLayoutFrame` is the one that pays: it sits behind a comparison that clears the whole layout frame cache, so an inline closure costs a cache clear and a relayout on every build. `eventSnapStrategy` sits behind a real gate too. `eventLayoutStrategy` currently gates nothing, since it reaches the calendar through the widget tree rather than through `==`, and it converts anyway so the three read as one design. `nowCallback` stays a function, because it takes no arguments and has nothing to model, and its place in `==` is what makes a change reach the calendar at all. The three view-transition resolvers need no work: they are correctly out of `==` and already read from the incoming configuration.

  Two equality gaps turned up while checking, both unrelated to function fields and neither breaking. `MultiDayBodyConfiguration.keepPagesAlive` is not covered by the equality it inherits, and the body and header configuration base classes test only `other is X` with no runtime type check, so two different configuration types with matching fields can compare equal.

### 0.27.0, the event model

Both of these were scoped for 0.26.0 and moved out to keep that release to one migration. Neither is blocked by anything except the copy contract above.

**1. Whether an event is all-day becomes something you can state.** Today the calendar infers it from duration through `MultiDayRule`, and the per-event rule override doubles as the way to force it, which that field's own documentation admits when it describes an event "all-day by nature rather than by duration". Every calendar format models it explicitly instead. The likely outcome is a flag on the event that decides when set, with the rule deciding for the events that carry none, and the rule keeps its place for the events that are not all-day. It comes after the copy contract so it does not become a third field to forward by hand.

  Two questions to answer first. The name collides in prose with `TimeOfDayRange.isAllDay`, which means which hours the body lays out rather than anything about an event, so either the event field takes a different name or that pair gets renamed alongside it. And the ICS example needs more work than first recorded. RFC 5545 encodes all-day as a date-valued `DTSTART`, but the `isAllDayEvent` getter on `enough_icalendar` reads a proprietary Microsoft property instead, so reading the standard signal means inspecting the value type on the property. The example discards it either way, at parse time rather than at mapping time, and the bundled sample file carries neither signal.

**2. A shorter way to call `spansMultipleDays`.** It takes two required named arguments that callers fill from the same two places every time. Additive and small. It waits on the all-day decision, since that may change what the method consults. Worth knowing how little it buys: no example app calls the method, and the only caller outside the package is a generated documentation snippet, so the verbosity is felt almost entirely inside the package.

### Tests

Coverage is 88.2% of lines, up from 84.4% at 0.23.0, and still uneven. It gates the composability work below. The backfill during 0.24.0 went where the known bugs were, so the models improved sharply and the widget directories did not move at all.

Both columns are line coverage of the directory and everything under it, measured with `flutter test --coverage` at each of the two tags.

| Area | 0.23.0 | Now | What is missing |
|---|---|---|---|
| `models/` | 75% | 87% | Covered during 0.24.0. `CalendarInteraction.==` had no test at all, which is how four missing fields went unnoticed. `calendar_callbacks.dart` at 29% is what is left. |
| `models/mixins/` | 63% | 84% | `event_tile_utils.dart` was at zero and is now covered. |
| `models/view_configurations/` | 78% | 83% | `schedule_view_configuration.dart` at 42% and `month_view_configuration.dart` at 68%. Two `copyWith` methods here were still silently dropping fields as late as 0.24.0. |
| `widgets/drag_targets/` | 71% | 71% | Untouched. `schedule_drag_target.dart` covers 10 of its 87 lines, the largest single gap in the package. |
| `widgets/event_tiles/` | 81% | 81% | Untouched. `multi_day_overlay_tile.dart` at 31% and `schedule_tile.dart` at 39%. |
| `theme/` | 78% | 78% | Untouched, and 0.25.0 rewrites this code. The lowest covered area of the package going into the release that changes it most. |

The rest runs from 79% to 100% with no large gap.

The three rows that did not move are the next work, and `schedule_drag_target.dart` is the one to start with. The pattern worth taking from 0.24.0 is that every gap closed turned up a bug that was already shipped.

### Composability

No release attached yet. It reshapes public API, so the shape has to settle before 1.0.0, and it touches enough of the package that it waits on the test coverage above.

Theming was the first slice of a larger idea: assembling a calendar from parts rather than configuring one whole. Three pieces are unbuilt.

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
| [#90](https://github.com/werner-scholtz/kalender/issues/90) hide and show weekends | A view configuration option. Changes which dates a page carries, so it reaches the date arithmetic rather than only the layout. |
| [#98](https://github.com/werner-scholtz/kalender/issues/98) named and uneditable time regions | A second thing the calendar draws besides events, that events sit on top of. The largest new model here. |
| [#259](https://github.com/werner-scholtz/kalender/issues/259) drag to create over a locked event | A drag starting on an unmodifiable event should fall through to creation instead of doing nothing. Mostly behavior. |
| [#280](https://github.com/werner-scholtz/kalender/issues/280) animated transitions between views | Opt-in, default off, reduced-motion aware, wrapping the controller swap in `CalendarView`. |

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
