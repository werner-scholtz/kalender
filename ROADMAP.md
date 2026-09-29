# Roadmap

> [!WARNING]
> Work in progress. This is a draft of the intended direction, not a commitment. Anything here can change or be dropped, and nothing in it should be planned around. [CHANGELOG.md](CHANGELOG.md) is the record of what has actually shipped.

Where kalender is going, and what has to happen before 1.0.0.

Nothing here carries a date. A release ships when it is ready.

## What 1.0.0 means

kalender is pre-1.0, so a breaking change can land in a minor version.

After 1.0.0 a breaking change needs a major version, so the API has to be one worth keeping first. That cuts two ways. Anything that would **change** existing API has to happen before the freeze, or it costs a 2.0.0. Anything that **adds** API wants to happen before it too, because a feature designed under a freeze has to live with whatever shape it was given on the first attempt.

So "Before 1.0.0" holds both: the breaking work, and the features that introduce new surface. "Not blocking 1.0.0" is what changes no public API at all.

## Settled

### Theming

`KalenderTheme` is an `InheritedTheme`, and Material is the default look and a requirement.

Every builder takes a `BuildContext` first and resolves its own styles from it, the way Flutter's widgets read their component theme in `build`. Builder fields are nullable, and each default lives on the components class that holds it.

**Two public fields keep Material types in the API**: `MultiDayOverlayStyle.cardTheme` is a `CardThemeData` and `MultiDayOverlayStyle.closeButtonStyle` is a `ButtonStyle`. They stay, see [Decided against](#decided-against).

intl stays the default formatter, since a calendar with no localized names out of the box is a regression. `examples/intl4x` shows the substitution.

### Events

**Base class state does not route through your `copyWith`.** `KalenderEvent` has no `copyWith`. The calendar calls `withDateTimeRange`, which calls the subclass's `copyWithData` hook and then reapplies identity, interaction and classification through `carryOver`. A subclass keeps its own `copyWith` under its own name, with whatever parameters it likes. `copyWithData` is `@mustBeOverridden`, and a debug assert checks the type it returns.

**`KalenderEvent.isAllDay` is a plain `bool`** defaulting to false. A nullable tri-state was rejected: "not all-day" and "no opinion" want the same answer, since an event spanning several days has to stay in the header either way.

### API conventions

**Strategy function fields are classes.** Each is a public abstract base with a const constructor and named factories for the built-ins, the shape of `MultiDayRule` and `PageIndexCalculator`. The base stays open, so an app can write its own strategy and give it value equality. A function field included in `==` reads as a change on every rebuild when it is written as an inline closure, and one left out of `==` never reaches the calendar. `nowCallback` stays a function, since it takes no arguments and has nothing to model.

**A callback is named for the detail type it carries.** `OnTappedWithDetail` takes a `TapDetail`, and the two `OnWillAccept` typedefs keep the plural of `DragTargetDetails`.

**`MultiDayBodyConfiguration` and `VerticalConfiguration` stay separate.** Merging would type `VerticalDragTarget` against a concrete view class while `HorizontalDragTarget` stays typed against an abstract axis base.

**Public top-level constants take a `k` prefix.** Top-level functions and static constants keep their names.

**The tile key factories are internal.** `AGENTS.md` carries the rule.

**Members are named for what they are, not for their type.** [AGENTS.md](AGENTS.md#naming-the-two-range-spaces) carries the rule.

### The state layer

**The state layer is public as `KalenderScope`, in the shape of `MediaQuery`.** It has one static accessor per value, each depending on that value alone. The providers behind it are not exported, so apps cannot depend on the tree shape, and the granularity can change without a break.

**An accessor reads the nearest value.** Most values exist once per calendar. The ones a header or body widget takes, such as the callbacks, the interaction and the tile components, are scoped to that widget. Gutter widths are shared as measured numbers rather than styles, so the rule has no exception.

### Material and the value types

Flutter moved Material into the `material_ui` package, which redefines `DateTimeRange` and `TimeOfDay` as its own classes.

**kalender owns the types rather than depending on a compatibility package.** No standard package exists to depend on. Flutter closed [#53059](https://github.com/flutter/flutter/issues/53059), the umbrella for moving style-neutral code down into the widgets layer before decoupling, without these two, and its own text says not everything would be refactored into the core. Converters for the SDK's Material ship in a `package:kalender/material.dart`, which costs nothing in the pubspec since Material ships with the SDK and only affects users who import it. `material_ui` converters stay out of the core, because pub has no optional dependencies and shipping them would put `material_ui` in the graph of every user who will never touch it.

**The core keeps Material for now, and only becomes able to drop it.** Owning the value types is required in every end state, since without it a `material_ui` app cannot compile against kalender at all. Dropping Material from the core is a separate question, and the answer is not yet. `_defaultsFor(ThemeData)` takes a kalender-owned palette as its input with Material still feeding it, which makes the split possible later without doing it now. A separate `kalender_ui` package is rejected: the engine is the most Material-bound part and became free when the value types were owned, so a split along that line would put the coupling in the wrong package. A `kalender_material_ui` companion waits until someone asks.

**The types are `KalenderDateTimeRange`, `KalenderTime` and `KalenderTimeRange`.** `Local` is wrong in Dart, where local means the local timezone, the opposite of what the type is. `Wall` was dropped because the repository uses "wall-clock" in its doc comments to mean the zoned value, so the name would invert its own vocabulary. `Plain` was dropped because the package uses `Kalender` as its ownership marker, and a second marker would cut across that. There is no `KalenderDateTime`: only the range type extended a Material class, and `FloatingDateTime` extends `dart:core`'s `DateTime`. That settles the model: events hold absolute instants as `DateTime`, layout and view coordinates are `FloatingDateTime` and `FloatingDateTimeRange`, and `KalenderDateTimeRange` is the boundary type an app hands in and reads back.

If Flutter promotes a canonical range type ([#97496](https://github.com/flutter/flutter/issues/97496)), kalender adds a converter and deprecates its own.

### Selection

**Selection, held by the controller.** An app selects through `KalenderController`: `selectDate`, `selectRange` and `deselectRange`, with the selection in `selectedRange`. The controller holds it rather than a predicate the app passes in, since a predicate gives the day numbers nothing to listen to, and [#215](https://github.com/werner-scholtz/kalender/issues/215) and [#264](https://github.com/werner-scholtz/kalender/issues/264) need to read the selection rather than test one day at a time. On the controller it also survives a view switch. A selection is whole days, and its range ends at the start of the next day like every other range in the package, so a selection read back and passed in again is unchanged. The calendar draws it on the day number in the month view, the day header, the schedule and the overlay, with a ring by default, and a day number rebuilds only when its own state changes. This is the selection half of [#262](https://github.com/werner-scholtz/kalender/issues/262).

**Taps on dates and week numbers.** `KalenderCallbacks.dateLabel` and `weekNumber` report taps, secondary taps and long presses, one `GestureCallbacks` group per part, so the callbacks do not grow by eight fields for every part that reports gestures. An empty day in the schedule reports the `onTapped` callbacks, the way an empty month cell does.

**The calendar does not select on its own.** An app selects from the callbacks, so it always knows what changed, and there is no selection-changed callback.

### Composability

**Composability is a pairing problem.** [#264](https://github.com/werner-scholtz/kalender/issues/264) raised the question of whether a compact month grid is a view inside `KalenderView` or a separate widget sharing its controllers. A month configuration, controller, header and body that belong together needed to be expressed as a set. `TabBar` and `TabBarView` have the same shape: two widgets, one shared controller.

**The controller holds the view configuration and location, and the views are sets of widgets.** `KalenderController` takes `viewConfiguration` and `location` and creates the view controller, so a view switch is a setter call. `KalenderView` takes a list of `ViewParts`, each a header and a body with an `accepts` check against the active configuration, rather than a configuration of its own. The configuration still picks the active view, which keeps one place for it. An app adds a view with a `ViewParts`, a `ViewConfiguration` that implements `createViewController`, and a `ViewController`.

**Each `KalenderView` holds the view controller it shows.** Two views on one controller, during a route transition or with a calendar route pushed over another, do not share page controllers, and a view mounted again reopens where the last one was. An animated switch between views needs the same thing, an outgoing view that stays on screen, so [#280](https://github.com/werner-scholtz/kalender/issues/280) builds on it.

## Before 1.0.0

### The next breaking window

A breaking change with no release attached waits for the next release that already breaks. None is queued.

### Theming, still open

**An example of the calendar in an app that installs no Material.** `examples/material_ui` proved the value type breaks by building them rather than predicting them, and the same treatment is what would show whether an app on `WidgetsApp` or `CupertinoApp` can render the calendar at all, importing neither `package:flutter/material.dart` nor `package:kalender/material.dart` and theming it through `KalenderTheme`. The default components are in the way, not the engine: the day number and the week number build an `IconButton`, the multi-day overflow button an `InkWell` and the schedule a `ListTile`, and each needs a `Material` ancestor the app no longer supplies. The overlay's `Card` supplies its own for the close button inside it, and `MaterialLocalizations` is already an optional lookup. Whether the fix is to wrap them, to replace them, or to tell the app to wrap the calendar, is for the example to answer.

### Known defects

The `TODO` comments in `lib/` mark possible defects, none confirmed. `grep -rn TODO lib/` lists them. Measure before changing one about rebuild cost.

### Composability, still open

It reshapes public API, so the shape has to settle before 1.0.0.

Theming was the first part of a larger idea: assembling a calendar from parts rather than configuring one whole. The state layer, `KalenderScope`, was the second, and the view parts the third. What is left:

- **The multi-day body has no cell or background slots.** It exposes nowhere to draw behind or inside a cell. The month body has `monthDayCellBuilder`. The slots are what [#89](https://github.com/werner-scholtz/kalender/issues/89), the multi-day half of [#262](https://github.com/werner-scholtz/kalender/issues/262) and a selection drawn behind a cell wait on.
- **The calendar selecting on its own,** on tap or as a range dragged across days ([#89](https://github.com/werner-scholtz/kalender/issues/89)).
- **A yearly view and a mobile month view,** [#40](https://github.com/werner-scholtz/kalender/issues/40) and [#264](https://github.com/werner-scholtz/kalender/issues/264), possible as `ViewParts` and not built.

### Features

Most of the open issues should land before 1.0.0 rather than after it. Each one adds public API, and 1.0.0 is the point where adding it stops being cheap. They are grouped by what they are waiting on rather than by demand, because the grouping is what decides the order.

**Waiting on new structure.** These cannot be built cleanly against the package as it stands.

| Issue | Needs |
|---|---|
| [#89](https://github.com/werner-scholtz/kalender/issues/89) customize each cell | Cell slots in the multi-day body, plus selection for its range-drag half. The controller holds the selection. |
| [#262](https://github.com/werner-scholtz/kalender/issues/262) select a cell | Selection as a concept the calendar knows about. The day number draws it. Drawing it on a multi-day body cell needs the slots. |
| [#40](https://github.com/werner-scholtz/kalender/issues/40) yearly view | Its own `ViewParts`, configuration and view controller. |
| [#264](https://github.com/werner-scholtz/kalender/issues/264) mobile month view | Its own `ViewParts`, configuration and view controller. A grid of days over a list, not a configuration of the current month view. |

Selection runs through [#89](https://github.com/werner-scholtz/kalender/issues/89), [#262](https://github.com/werner-scholtz/kalender/issues/262) and [#264](https://github.com/werner-scholtz/kalender/issues/264). The controller holds it.

**Independent.** These wait on nothing and can land in any release.

| Issue | Shape |
|---|---|
| [#90](https://github.com/werner-scholtz/kalender/issues/90) hide and show weekends | A set of visible weekdays on the view configuration. Changes which dates a page carries, so it reaches the date arithmetic rather than only the layout. Scoped below. |
| [#98](https://github.com/werner-scholtz/kalender/issues/98) named and uneditable time regions | A second thing the calendar draws besides events, that events sit on top of. The largest new model here. |
| [#280](https://github.com/werner-scholtz/kalender/issues/280) animated transitions between views | Opt-in, default off, reduced-motion aware. `animateTo` and `animation` sit beside the `viewConfiguration` setter, and `KalenderView` keeps the outgoing view controller until the animation ends. |

**Arbitrary visible weekdays, [#90](https://github.com/werner-scholtz/kalender/issues/90), needs the page to stop being one date range.** `numberOfDays` on `week` and `workWeek` covers the contiguous case, which is what the reporter of [#444](https://github.com/werner-scholtz/kalender/issues/444) asked for. Every contiguous span starting on `firstDayOfWeek` is expressible that way, so what a set of weekdays adds is the non-contiguous case, Monday, Wednesday and Friday, and a span that starts somewhere other than `firstDayOfWeek`.

That is not a parameter. A page is a contiguous `FloatingDateTimeRange` throughout the package, and a day's index within that range is what maps to pixels. Six places do that arithmetic: `event_tile_utils.dart` turns a drag position into a date by dividing by the column count and indexing the range's dates, the multi-day event widget and both layout strategies place a header tile by its first and last day index, the day separator count and the time indicator both derive from the column count, and the free-scroll band is built on day index equalling pixel offset. Each needs a column-to-date mapping instead. `KalenderController.visibleDateTimeRange` and the `onPageChanged` callback are a single range, which a gapped page makes untrue, and both are public. The events controller fetches by range, so hidden-day events arrive and have to be dropped per column. An app asking for Monday to Saturday most likely wants the month grid at six columns too, which reaches the month body, the week number gutter and the row-count logic in `MonthIndexCalculator`.

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
- **Lighter event tiles.** Every event builds a draggable, a gesture detector and an entry in a parallel drop target column. Fewer widgets per tile is the largest remaining lever. One attempt measured worse than what it replaced.
- **A bounded version of `MultiDayBodyConfiguration.keepPagesAlive`,** which is currently unbounded and grows with the number of distinct pages visited.
- **Recycling day tiles rather than culling them,** building on the geometry model added when culling landed. Culling only helps tiles that are off screen, so it does little for a desktop week at default zoom.
- **Revisit the schedule view,** the slowest of the four when this work started and untouched by the fixes that followed.
- **Explain the schedule rescheduling step change.** The benchmark roughly doubled at the merge that replaced `throttleMilliseconds` with per-frame coalescing, to 1.97ms at ten events per day and 3.92ms at fifty. Part of it is expected, since the old throttle dropped moves and the average was taken over frames that did no work, but the missed frames in the same run are not explained by that.
- [#222](https://github.com/werner-scholtz/kalender/issues/222) performance when swiping, still unconfirmed.

### Documentation

- **The API reference is grouped** into seven categories that match the guides: Views, Events, Controllers and callbacks, Interaction, Appearance, Layout, and Dates and times. Every public symbol carries its category, and each category's topic page is its guide.

## Decided against

- **An event type that carries your data.** Attaching data means subclassing `KalenderEvent` and writing `copyWithData`, `==`, `hashCode` and `layoutEquals` yourself. A generic version would save the typing, but those four methods are where calendar performance is won or lost, and hiding them invites a heavy payload and skipped equality checks. [doc/events.md](doc/events.md#custom-events) documents the pattern.
- **Replacing `MultiDayOverlayStyle.cardTheme` and `closeButtonStyle`.** Each is the override point over a Flutter type and interpolates with that type's `lerp`, so re-declaring either means reimplementing a Flutter type. Removing them makes nothing framework neutral while `KalenderThemeData` is a `ThemeExtension`.
- **A public `KalenderPalette`.** It would only save an app from naming the styles it already has to name, and a second way to set the same values is worth less than the one that already works.

## Influencing this

Within each group under "Features" the ordering follows demand. If something there matters to you, say so on its issue. If what you need is missing, [open one](https://github.com/werner-scholtz/kalender/issues/new).

Anything that needs the API to change or to grow is far cheaper to act on before 1.0.0 than after it, so raise it now rather than later.
