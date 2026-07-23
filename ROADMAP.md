# Roadmap

Where kalender is going, and what has to happen before 1.0.0.

Nothing here carries a date. Work is sequenced by release, and a release ships when it is ready. [CHANGELOG.md](CHANGELOG.md) records what has already shipped.

## What 1.0.0 means

kalender is pre-1.0, so a breaking change can land in a minor version. That is why the readme asks you to pin an exact version.

After 1.0.0 a breaking change needs a major version, so the API has to be one worth keeping first. Everything under "Before 1.0.0" has to be settled before the API freezes, either because it cannot be done afterwards without a 2.0.0 or because it shapes the API people will be pinned to. Some of it has a release attached and some does not. Everything under "Not blocking 1.0.0" breaks nothing and can land whenever.

## Before 1.0.0

### 0.24.0

Breaking changes are batched into as few releases as possible. The readme split rides along, because this is the release people will be reading the docs to migrate through.

- **Split the readme.** It is 1,183 lines across 16 top-level sections and serves three readers at once: someone deciding whether to use the package, someone wiring it up for the first time, and someone customizing it months later. Reference material moves to `doc/` and the readme becomes the shop window. The rewrite should also say that 1.0.0 is approaching and that anything wanting an API change is far cheaper to act on before it lands than after.
- **Remove the deprecated string builders.** Seven fields moved to the matching `*Components` classes in 0.23.0, and `MonthDayHeaderStyle.textStyle` was deprecated because it never had any effect. Replacements are in [MIGRATION.md](MIGRATION.md#v022x--v0230).
- **Stop re-exporting the whole `timezone` package.** Twelve of its classes plus its top level functions and constants currently appear in kalender's API reference. `Location` and `TZDateTime` stay. The rest goes.
- **Widen value equality on `CalendarInteraction` and `HorizontalConfiguration`.** `CalendarInteraction` compares five of its eight fields, omitting `throttleMilliseconds`, `createEventGesture` and `modifyEventGesture`. `HorizontalConfiguration` omits `allowSingleDayEvents`. Both propagate through a `ValueNotifier`, which uses `==` to decide whether to notify, so changing only a missing field never reaches the calendar.
- **Fix what counts as a multi-day event.** `CalendarEvent.isMultiDayEvent` is `duration.inDays > 0`, which measures how long an event lasts rather than how many days it touches. An event from 23:00 to 01:00 spans two calendar days but counts as single-day, and ignoring the event's location shifts the boundary on daylight saving days. It decides day versus multi-day layout, so fixing it moves some events.

### 0.25.0, theming shape

The theme extension arrived in 0.21.0 and the string builders moved out of the style classes in 0.23.0. What is left is where kalender still differs from Flutter's own component themes.

- **`KalenderTheme` becomes an `InheritedWidget`.** Today it is a static lookup, so a theme cannot be scoped to part of the widget tree. Flutter's component themes can be, and the current name implies this one can too.
- **Style classes become `Diagnosticable`,** so resolved values appear in Flutter devtools the way Material's theme classes do.
- **Revisit how deeply the style containers nest.** Reaching a single style means `CalendarComponents` to `MultiDayComponentStyles` to `MultiDayHeaderComponentStyles` to `dayHeaderStyle`. Flutter puts the property on the widget instead.
- **Decide how much of Material kalender should require.** `ThemeExtension` is a Material class, so the theming system depends on Material by construction, and `Theme.of` is read in 21 files. Past that the coupling is mostly accidental: 86 of the 104 files in `lib/` import `material.dart` and 58 of them use nothing from it, and only five Material widgets are used at all (`IconButton`, `InkWell`, `Card`, `Material`, `Icons`). Flutter continues to separate Material and Cupertino from the core framework. The likely outcome is that layout and interaction stay framework neutral and Material stays the default look.

### Tests

Coverage is 84% of lines and uneven, and it gates the composability work below. The gaps line up with the known bugs. `CalendarInteraction.==` and its `hashCode` are not covered by a single test, which is how three missing fields went unnoticed.

| Area | Covered | What is missing |
|---|---|---|
| `models/` value classes | 47% | `CalendarInteraction`, `CalendarCallbacks`, `NavigationTriggers`. Their `==`, `hashCode` and `copyWith` are untested. |
| `models/mixins/` | 63% | `event_tile_utils.dart` is at zero. `schedule_map.dart` and the drag target helpers are partial. |
| `widgets/drag_targets/` | 71% | `schedule_drag_target.dart` is at 12%, the largest single gap in the package. |
| `models/view_configurations/` | 78% | The same untested equality as the value classes, including `HorizontalConfiguration`. |
| `widgets/event_tiles/` | 81% | `multi_day_overlay_tile.dart` and `schedule_tile.dart`. |

The rest runs from 78% to 99% with no large gap. The date and timezone extensions read worse than they are, because most of their uncovered lines are a deprecated method and the English fallback tables.

Work in that order. The value classes are public API and cheap to cover, and they are where the bugs already found are hiding.

### Composability

Under investigation, with no release attached yet. It would reshape public API, so the shape has to settle before 1.0.0, and it touches enough of the package that it waits on the test coverage above.

Theming was the first slice of a larger idea: assembling a calendar from parts rather than configuring one whole. Three pieces are unbuilt. The providers carrying calendar state are private, so nothing outside the package can read them. The switches mapping a `ViewConfiguration` to its controller, body and header are hardcoded, so no one can add a view type. The bodies and headers expose no per cell or background slot, which is what [#89](https://github.com/werner-scholtz/kalender/issues/89) and [#262](https://github.com/werner-scholtz/kalender/issues/262) need.

### 1.0.0

When the list above is empty and the API has held still for a release or two.

## Not blocking 1.0.0

None of this breaks anything, so it is ordered by demand rather than by dependency.

### Selection

[#262](https://github.com/werner-scholtz/kalender/issues/262) and [#264](https://github.com/werner-scholtz/kalender/issues/264) want the same thing: a way to select a day or a time slot that the calendar knows about. Selection is app owned today, with no `selectedDate` on the controller and no `isSelected` on a cell.

The month view can be built with the existing cell builder and `onTapped`. The multi-day body cannot, because it exposes no per cell or background builder.

### Views and features

- [#40](https://github.com/werner-scholtz/kalender/issues/40) yearly view
- [#89](https://github.com/werner-scholtz/kalender/issues/89) customize each cell
- [#90](https://github.com/werner-scholtz/kalender/issues/90) hide and show weekends
- [#98](https://github.com/werner-scholtz/kalender/issues/98) named and uneditable time regions
- [#215](https://github.com/werner-scholtz/kalender/issues/215) a portal for every cell in the month body
- [#259](https://github.com/werner-scholtz/kalender/issues/259) long press drag event creation over disabled events
- [#280](https://github.com/werner-scholtz/kalender/issues/280) animated transitions between views
- Multi-column days, so several calendars can sit side by side within one day. Not filed yet.

### Performance

Frame timings for every view and workload are tracked on the [benchmarks dashboard](https://werner-scholtz.github.io/kalender/dev/bench/).

Slow frames come from the size of the widget, render and semantics tree, not from the layout algorithms. A week at fifty events per day is about 350 tiles, and navigating builds all of them. The levers are tile weight and doing less work per navigation.

- **Deferred tile rendering for dense days.** A new column of many events renders no tiles on its first frame and fills them in on the next, moving the cost off the navigation. Prototyped, and opt-in because it changes render timing. One run measured week navigation at 30ms against 54ms, still to be confirmed over several runs.
- **Lighter event tiles.** Every event builds a draggable, a gesture detector, resize handles and an entry in a parallel drop target column. Fewer widgets and semantics nodes per tile is the largest remaining lever. One attempt measured worse than what it replaced.
- **A bounded version of `MultiDayBodyConfiguration.keepPagesAlive`,** which is currently unbounded and grows with the number of distinct pages visited.
- **Recycling day tiles rather than culling them,** building on the geometry model added when culling landed. Culling only helps tiles that are off screen, so it does little for a desktop week at default zoom.
- **Revisit the schedule view,** the slowest of the four when this work started and untouched by the fixes that followed.
- [#222](https://github.com/werner-scholtz/kalender/issues/222) performance when swiping, still unconfirmed.


### Documentation

- Group the API reference. It lists 189 symbols in one alphabetical run with no categories, so nothing marks out the handful most people need.

## Decided against

Asked for often enough to be worth answering here.

- **An event type that carries your data.** Attaching data means subclassing `CalendarEvent` and writing `copyWith`, `==`, `hashCode` and `layoutEquals` yourself. A generic version would save the typing, but those four methods are where calendar performance is won or lost, and hiding them invites a heavy payload and skipped equality checks. The readme documents the pattern.

## Influencing this

Ordering under "Not blocking 1.0.0" follows demand. If something there matters to you, say so on its issue. If what you need is missing, [open one](https://github.com/werner-scholtz/kalender/issues/new).

1.0.0 is approaching. Anything that needs the API to change is far cheaper to act on before it lands, so raise it now rather than later.
