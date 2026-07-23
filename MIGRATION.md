# Migration Guide

## v0.23.x → v0.24.0

### `isMultiDayEvent` became `spansMultipleDays`

```dart
- if (event.isMultiDayEvent) { ... }
+ if (event.spansMultipleDays(location: context.location)) { ... }
```

The old getter still works and is removed in 0.25.0. It answers as if the calendar were in UTC, because a getter cannot take a location.

The name had to change. Dart rejects a class declaring both a getter and a method called `isMultiDayEvent`, so reusing the name would have meant no deprecation period at all. Worse, `event.isMultiDayEvent` would have kept compiling anywhere a `dynamic` is accepted, silently becoming a function object rather than a boolean.

### Choosing what counts as multi-day

The rule is now a `MultiDayRule` on the event. The default is `MultiDayRule.minimumDuration(Duration(hours: 24))`, which is exactly the previous behaviour, so nothing renders differently until you change it.

| Rule | Multi-day when |
| --- | --- |
| `MultiDayRule.minimumDuration(d)` | the event lasts at least `d` |
| `MultiDayRule.calendarDays()` | the event covers part of more than one calendar day |
| `MultiDayRule.always()` | always, for events that are all-day by nature |

Set it for one event:

```dart
CalendarEvent(dateTimeRange: range, multiDayRule: const MultiDayRule.calendarDays())
```

Or for your whole app, from the subclass you already have:

```dart
class Event extends CalendarEvent {
  Event({required super.dateTimeRange, required this.title})
      : super(multiDayRule: const MultiDayRule.calendarDays());
}
```

For a rule none of these express, override `spansMultipleDays` instead.

`multiDayRule` takes part in `layoutEquals`, so two events differing only in their rule are not equal. A subclass overriding `layoutEquals` does not need to do anything, since `super`'s comparison already covers it.

## v0.22.x → v0.23.0

Nothing here stops existing code from compiling. The old fields still work and are deprecated, and the changes that need action are ones that alter what the calendar renders.

### String builders moved off the style classes

The `String Function(...)` fields on the component style classes moved to the matching `*Components` class, and each now takes a `BuildContext` as its first argument.

They are formatting hooks, not visual style. Since 0.21.0 the style classes also live inside `KalenderThemeData`, a `ThemeExtension`, where a function field cannot interpolate during a theme animation and an inline lambda breaks the style's value equality on every rebuild. The `BuildContext` closes an older gap too: a custom builder could not read the calendar's locale, while the package's own defaults could.

| Old | New |
| --- | --- |
| `DayHeaderStyle.stringBuilder` | `MultiDayHeaderComponents.dayHeaderStringBuilder` |
| `DayHeaderStyle.numberStringBuilder` | `MultiDayHeaderComponents.dayHeaderNumberStringBuilder` |
| `TimelineStyle.stringBuilder` | `MultiDayBodyComponents.timelineStringBuilder` |
| `MonthDayHeaderStyle.stringBuilder` | `MonthBodyComponents.monthDayHeaderStringBuilder` |
| `WeekDayHeaderStyle.stringBuilder` | `MonthHeaderComponents.weekDayHeaderStringBuilder` |
| `ScheduleDateStyle.stringBuilder` | `ScheduleComponents.leadingDateStringBuilder` |
| `MultiDayPortalOverlayButtonStyle.stringBuilder` | `OverlayBuilders.multiDayPortalOverlayButtonStringBuilder` |

The old fields are used whenever the new one is not set, so there is no rush. They are removed in 0.24.0.

**Before:**
```dart
CalendarComponents(
  multiDayComponentStyles: MultiDayComponentStyles(
    headerStyles: MultiDayHeaderComponentStyles(
      dayHeaderStyle: DayHeaderStyle(
        stringBuilder: (date) => DateFormat.E('de_DE').format(date),
      ),
    ),
  ),
)
```

**After:**
```dart
CalendarComponents(
  multiDayComponents: MultiDayComponents(
    headerComponents: MultiDayHeaderComponents(
      dayHeaderStringBuilder: (context, date) => DateFormat.E(context.calendarLocale).format(date),
    ),
  ),
)
```

Note the hardcoded locale is gone. `context.calendarLocale` is the locale the calendar formats with, which is not necessarily the app's.

### The overflow button is labelled `+3`

The button standing in for events that do not fit was labelled `3 more`. That was English, with no way for the calendar's locale to reach it. It is now a plus sign and the count, with the number formatted for the locale, so locales with their own numerals read correctly.

To keep the old wording:

```dart
CalendarComponents(
  overlayBuilders: OverlayBuilders(
    multiDayPortalOverlayButtonStringBuilder: (context, count) => '$count more',
  ),
)
```

### Schedule day names use the locale's own abbreviation

The schedule view built its abbreviation by cutting the full day name at three characters, which only matches the real abbreviation in English. German showed `Mit` instead of `Mi`, Russian `сре` instead of `ср`. It now uses `DateFormat.E`, like every other component.

No action needed unless you relied on the three-character width for layout.

### `MonthDayHeaderStyle.stringBuilder` now has an effect

The field was declared but never called, so setting it did nothing. Its replacement, `MonthBodyComponents.monthDayHeaderStringBuilder`, is wired up.

If you set the old field and worked around it doing nothing, the day number will now change. Remove the field, or move the value to the new builder.

### `MonthDayHeaderStyle.textStyle` is deprecated

It is documented as styling the day name, but `MonthDayHeader` renders only a day number, styled by `numberTextStyle`. It has never had any effect. Remove it. The Material 3 defaults no longer assign it either.

### Global overlay builders now apply in the month view

`MonthBodyComponents.overlayBuilders` defaulted to an empty `OverlayBuilders` rather than null, and the month body resolves the specific value before the global one, so the empty default always shadowed `CalendarComponents.overlayBuilders`.

If you set overlay builders globally and worked around them not applying in the month view, that workaround can go.

## v0.18.x → v0.19.0

### Timeline gutter width is now a single value (`prototypeTimeLine` removed)

The multi-day body, header and drag overlay previously worked out the left timeline gutter width in separate places, which could drift apart and misalign the header (see [#180](https://github.com/werner-scholtz/kalender/issues/180)). They now share one width, resolved by `MultiDayBodyComponents.timelineWidth`.

`MultiDayBodyComponents.prototypeTimeLine`, the `PrototypeTimeline` widget, and the `PrototypeTimeLineBuilder` typedef have been removed.

**If you only set `bodyStyles.timelineStyle`** (including a custom `stringBuilder`): no change needed — the header and body now always match.

**If you overrode `prototypeTimeLine`:** return the width as a `double` from `timelineWidth` instead of building a widget.

**Before:**
```dart
MultiDayBodyComponents(
  prototypeTimeLine: (heightPerMinute, timeOfDayRange, style) => const SizedBox(width: 80),
)
```

**After:**
```dart
MultiDayBodyComponents(
  timelineWidth: (context, timeOfDayRange, style) => 80,
)
```

**If you provide a fully custom `timeline` widget:** the body now fixes the gutter to `timelineWidth`, so you no longer need to make your widget's width match by hand. Build the timeline to fill the given width, and set the width with either `TimelineStyle(width: …)` or a `timelineWidth` builder.

A new `TimelineStyle.width` field lets you set the gutter width directly without a builder:
```dart
MultiDayBodyComponentStyles(timelineStyle: TimelineStyle(width: 72))
```

### `monthDayHeaderBuilder` receives a localized `DateTime`

`monthDayHeaderBuilder` now provides a localized wall-clock `DateTime` (via `.forLocation()`), consistent with `dayHeaderBuilder`, instead of a UTC-flagged `InternalDateTime`. This fixes incorrect "today" comparisons against `DateTime.now()` in custom month-view day headers ([#248](https://github.com/werner-scholtz/kalender/issues/248)).

This only affects custom `monthDayHeaderBuilder` implementations that annotate the `date` parameter. Change the type from `InternalDateTime` to `DateTime`:

**Before:**
```dart
MonthComponents(
  bodyComponents: MonthBodyComponents(
    monthDayHeaderBuilder: (InternalDateTime date, style) => MyHeader(date),
  ),
)
```

**After:**
```dart
MonthComponents(
  bodyComponents: MonthBodyComponents(
    monthDayHeaderBuilder: (DateTime date, style) => MyHeader(date),
  ),
)
```

The received `date` is already in the calendar's configured location, so any manual `.forLocation()` conversion inside the builder is no longer needed.

### Default behaviour change: scroll & zoom are now preserved across view switches

> [!IMPORTANT]
> This changes what an unchanged calendar does on a view switch, even if you never touch the new API.

| On switching view type (e.g. Week → Month → Week) | Before (`0.18.x`) | Now (`0.19.0`) |
|---|---|---|
| Vertical scroll (time-of-day) | **Reset** to `initialTimeOfDay` every time | **Preserved** (`ScrollTransition.preserve`) |
| Zoom (`heightPerMinute`) | Preserved only between *adjacent* multi-day views; lost through a non-scrolling view (e.g. Month) | **Preserved**, including across a round-trip through Month (`ZoomTransition.preserve`) |
| Visible date | Carried forward from the outgoing view | Unchanged (`DateTransition.carryFocus`) |

To restore the old "always reset the scroll on a view change" behaviour:

```dart
MultiDayViewConfiguration.week(
  scrollTransition: ScrollTransition.reset,
  zoomTransition: ZoomTransition.reset, // if you also relied on zoom resetting
)
```

### `EmptyDayBehavior.showToday` renamed to `showOnlyToday`

`EmptyDayBehavior.showToday` has been renamed to `EmptyDayBehavior.showOnlyToday`. The behaviour is unchanged — among empty days, only today is shown — the new name just removes the ambiguity (it never showed *all* empty days plus today).

**Before:**
```dart
ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.showToday)
```

**After:**
```dart
ScheduleBodyConfiguration(emptyDay: EmptyDayBehavior.showOnlyToday)
```

### `initialDateSelectionStrategy` replaced by per-dimension view-transition controls

`ViewConfiguration.initialDateSelectionStrategy` has been removed. How a view switch transfers state is now expressed per dimension:

- **Date** (all views): `dateTransition` — `DateTransition.carryFocus` (default) or `restorePerView` — plus an optional `dateResolver` for custom logic.
- **Scroll / zoom** (`MultiDayViewConfiguration` only): `scrollTransition` / `zoomTransition` — `preserve` (default), `reset`, or `restorePerView` — plus optional `scrollResolver` / `zoomResolver`.

A custom `initialDateSelectionStrategy` becomes a `dateResolver`. The signature changes from named parameters to a single `ViewTransitionContext`, and the built-in `kDefaultTo*` helpers now take the outgoing `ViewController` directly (or use `kCarryFocusDate(transition)`).

**Before:**
```dart
InternalDateTime myStrategy({
  required ViewController oldViewController,
  required ViewConfiguration newViewConfiguration,
}) => nextBusinessDay(oldViewController.visibleDateTimeRange.value!.start);

MultiDayViewConfiguration.week(initialDateSelectionStrategy: myStrategy)
```

**After:**
```dart
InternalDateTime myResolver(ViewTransitionContext transition) =>
    nextBusinessDay(kCarryFocusDate(transition));

MultiDayViewConfiguration.week(dateResolver: myResolver)
```

Common intents map directly to enum values:

```dart
// Reopen each view where it last was (Day → Month → Day restores the day):
MultiDayViewConfiguration.singleDay(dateTransition: DateTransition.restorePerView)

// Always reset the scroll to initialTimeOfDay on a view change:
MultiDayViewConfiguration.week(scrollTransition: ScrollTransition.reset)
```

## v0.16.x → v0.17.0

### Input mode replaces platform-based mobile/desktop split

Resize handle behavior is now driven by **input precision** (`InputMode`) instead of platform detection (`isMobileDevice`). This affects how resize handles are positioned and when they become visible.

**New `InputMode` enum:**

| Value | Meaning |
|-------|---------|
| `auto` (default) | Detect dynamically — hover indicates precise input, selection indicates imprecise |
| `precise` | Mouse, stylus, trackpad — full-width handles, shown on hover |
| `imprecise` | Touch/finger — corner handles, shown on selection |

**`CalendarInteraction` has two new fields:**
```dart
CalendarInteraction(
  inputMode: InputMode.auto,                  // NEW — default is auto
  allowHorizontalImpreciseResize: false,      // NEW — opt-in for horizontal touch resize
)
```

### `ResizeHandlePositioner` typedef has a new `isImprecise` parameter

If you provide a custom `resizeHandlePositioner` in `TileComponents`, update it to accept the new parameter:

**Before:**
```dart
TileComponents(
  resizeHandlePositioner: (event, interaction, components, range, size, axis) {
    return MyCustomResizeHandles(...);
  },
)
```

**After:**
```dart
TileComponents(
  resizeHandlePositioner: (event, interaction, components, range, size, axis, isImprecise) {
    return MyCustomResizeHandles(..., isImprecise: isImprecise);
  },
)
```

### `ResizeHandles` abstract class requires `isImprecise`

If you extend `ResizeHandles`, add `isImprecise` to your constructor:

**Before:**
```dart
class MyResizeHandles extends ResizeHandles {
  const MyResizeHandles({
    required super.event,
    required super.axis,
    required super.interaction,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.size,
  });
}
```

**After:**
```dart
class MyResizeHandles extends ResizeHandles {
  const MyResizeHandles({
    required super.event,
    required super.axis,
    required super.interaction,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.size,
    required super.isImprecise,
  });
}
```

---

## v0.15.x → v0.16.0

### `CalendarEvent` is no longer generic

**Before:**
```dart
CalendarEvent<MyData>(dateTimeRange: range, data: MyData(...))
```

**After** — extend `CalendarEvent` instead:
```dart
class MyEvent extends CalendarEvent {
  final String title;
  final Color? color;

  MyEvent({
    required super.dateTimeRange,
    required this.title,
    this.color,
    super.interaction,
  });

  @override
  MyEvent copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? title,
    Color? color,
  }) {
    final updated = MyEvent(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      title: title ?? this.title,
      color: color ?? this.color,
    );
    // Always carry the existing ID over to the new instance.
    updated.id = id;
    return updated;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return super == other &&
        other is MyEvent &&
        other.title == title &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, title, color);
}
```

> [!IMPORTANT]
> You **must** override `==` and `hashCode` to include your custom fields. The base `CalendarEvent` equality only compares `id`, `dateTimeRange`, and `interaction`. Without the override, calls like `eventsController.updateEvent(event: original, updatedEvent: updated)` will not cause tile rebuilds when only custom fields (title, color, etc.) change.

#### `layoutEquals`

`layoutEquals` is used internally to skip expensive layout recalculations. The default implementation compares `id`, `dateTimeRange`, and `interaction` — which is correct for most subclasses. Only override it if a custom property changes the **size or position** of the tile (e.g. a flag that makes a tile render taller). Do **not** override it for content-only changes like color or title.

### Event IDs are now `String`

**Before:**
```dart
int id = eventsController.addEvent(event);
CalendarEvent? found = eventsController.byId(42);
```

**After:**
```dart
String id = eventsController.addEvent(event);
CalendarEvent? found = eventsController.byId('some-id');
```

IDs are auto-generated (10-character alphanumeric) when not provided.

### Renamed symbols

| Old name | New name |
|---|---|
| `MultiDayOverlayEventTile` | `MultiDayEventOverlayTile` |

### Extensions moved to `InternalDateTime` / `InternalDateTimeRange`

Most date/time extensions that were previously on `DateTime` and `DateTimeRange` have moved to `InternalDateTime` and `InternalDateTimeRange` for DST-safe arithmetic. `DateTime` retains only the locale-aware formatting extensions (`dayNameLocalized`, `monthNameLocalized`, etc.).

| Previously on `DateTime` | Now on `InternalDateTime` |
|---|---|
| `startOfDay` / `endOfDay` / `dayRange` | `InternalDateTime.startOfDay` / `.endOfDay` / `.dayRange` |
| `startOfMonth` / `endOfMonth` / `monthRange` | `InternalDateTime.startOfMonth` / `.endOfMonth` / `.monthRange` |
| `startOfYear` / `endOfYear` / `yearRange` | `InternalDateTime.startOfYear` / `.endOfYear` / `.yearRange` |
| `startOfWeek()` / `endOfWeek()` / `weekRange()` | `InternalDateTime.startOfWeek()` / `.endOfWeek()` / `.weekRange()` |
| `isSameDay()` | `InternalDateTime.isSameDay()` |

Range operations like `dates()`, `overlaps()`, and `dateTimeRangeOnDate()` are now on `InternalDateTimeRange`.

Use `InternalDateTime.fromExternal(dateTime)` and `InternalDateTimeRange.fromDateTimeRange(range)` to convert from the standard types when needed.

### `DayEventTileUtils` / `MultiDayEventTileUtils` no longer generic

The mixins no longer carry a type parameter. Remove `<T>` from the mixin application and update the `tileRange` field type from `DateTimeRange` to `InternalDateTimeRange`.

**Before:**
```dart
class MyTile extends StatelessWidget with DayEventTileUtils<MyData> {
  @override final CalendarEvent<MyData> event;
  @override final DateTimeRange tileRange;
```

**After:**
```dart
class MyTile extends StatelessWidget with DayEventTileUtils {
  @override final CalendarEvent event;
  @override final InternalDateTimeRange tileRange;
```
