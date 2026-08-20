# Migration Guide

Each section covers one upgrade. Versions not listed below need no changes.

| Upgrade | What changes |
| --- | --- |
| [v0.26.x → v0.27.0](#v026x--v0270) | Every builder takes a `BuildContext` and resolves its own styles. `TimeOfDayRange.isAllDay` is removed. |
| [v0.25.x → v0.26.0](#v025x--v0260) | The deprecated style fields on `CalendarComponents` are removed, along with the containers reached through them. The three strategy fields become classes. `CalendarEvent.copyWith` becomes `copyWithData`. |
| [v0.24.x → v0.25.0](#v024x--v0250) | The deprecated `isMultiDayEvent` getter is removed. |
| [v0.23.x → v0.24.0](#v023x--v0240) | The timezone re-export, the deprecated string builders, the multi-day rule, and six smaller removals. |
| [v0.22.x → v0.23.0](#v022x--v0230) | String builders move off the style classes. Nothing stops compiling, but an unchanged calendar renders differently. |
| v0.19.x → v0.22.x | No changes needed. |
| [v0.18.x → v0.19.0](#v018x--v0190) | The timeline gutter width, view-transition controls, and the month day header's date type. |
| [v0.16.x → v0.17.0](#v016x--v0170) | Input mode replaces the mobile/desktop split. |
| [v0.15.x → v0.16.0](#v015x--v0160) | `CalendarEvent` is no longer generic and event ids become `String`. |

## v0.26.x → v0.27.0

### `TimeOfDayRange.isAllDay` is removed

Deprecated in 0.26.0, which named this release. The getter reports whether the
range runs from 00:00 to 23:59, and it was renamed so `isAllDay` could describe
an event instead.

```dart
// Before
if (timeOfDayRange.isAllDay) { ... }

// After
if (timeOfDayRange.coversWholeDay) { ... }
```

`TimeOfDayRange.allDay()` is a different member and is unaffected.

### Every builder takes a `BuildContext`

Each builder gained a context as its first argument. The fifteen that carried a
style lost it, and resolve one from the context instead.

| Before | After |
| --- | --- |
| `hourLines: (heightPerMinute, range, style, timelineStyle) =>` | `hourLines: (context, heightPerMinute, range) =>` |
| `timeline: (heightPerMinute, range, style, dragged, visible) =>` | `timeline: (context, heightPerMinute, range, dragged, visible) =>` |
| `timelineWidth: (context, range, style) =>` | `timelineWidth: (context, range) =>` |
| `daySeparator: (style) =>` | `daySeparator: (context) =>` |
| `timeIndicator: (range, heightPerMinute, style, location) =>` | `timeIndicator: (context, range, heightPerMinute, location) =>` |
| `dayHeaderBuilder: (date, style) =>` | `dayHeaderBuilder: (context, date) =>` |
| `weekNumberBuilder: (range, style) =>` | `weekNumberBuilder: (context, range) =>` |
| `weekDayHeaderBuilder: (date, style) =>` | `weekDayHeaderBuilder: (context, date) =>` |
| `monthDayHeaderBuilder: (date, style) =>` | `monthDayHeaderBuilder: (context, date) =>` |
| `monthGridBuilder: (style, numberOfRows) =>` | `monthGridBuilder: (context, numberOfRows) =>` |
| `monthDayCellBuilder: (details) =>` | `monthDayCellBuilder: (context, details) =>` |
| `leadingDateBuilder: (date, style) =>` | `leadingDateBuilder: (context, date) =>` |
| `scheduleTileHighlightBuilder: (date, range, style, child) =>` | `scheduleTileHighlightBuilder: (context, date, range, child) =>` |
| `emptyItemBuilder: (tileRange) =>` | `emptyItemBuilder: (context, tileRange) =>` |
| `monthItemBuilder: (monthRange) =>` | `monthItemBuilder: (context, monthRange) =>` |
| `multiDayPortalOverlayButtonBuilder: (controller, rows, style) =>` | `multiDayPortalOverlayButtonBuilder: (context, controller, rows) =>` |
| `tileBuilder: (event, tileRange) =>` | `tileBuilder: (context, event, tileRange) =>` |
| `overlayTileBuilder: (event, tileRange) =>` | `overlayTileBuilder: (context, event, tileRange) =>` |
| `tileWhenDraggingBuilder: (event) =>` | `tileWhenDraggingBuilder: (context, event) =>` |
| `feedbackTileBuilder: (event, size) =>` | `feedbackTileBuilder: (context, event, size) =>` |
| `dropTargetTile: (event) =>` | `dropTargetTile: (context, event) =>` |
| `leftTriggerBuilder: (pageWidth) =>` | `leftTriggerBuilder: (context, pageWidth) =>` |
| `topTriggerBuilder: (viewPortHeight) =>` | `topTriggerBuilder: (context, viewPortHeight) =>` |

A builder that read the style it was passed reads it from the context instead:

```dart
// Before
daySeparator: (style) => ColoredBox(color: style?.color ?? Colors.grey),

// After
daySeparator: (context) {
  final style = KalenderTheme.of(context).daySeparatorStyle;
  return ColoredBox(color: style?.color ?? Colors.grey);
},
```

A builder written as a named function or a static takes the context the same way:

```dart
// Before
static EventTile builder(CalendarEvent event, DateTimeRange tileRange) => EventTile(event: event);

// After
static EventTile builder(BuildContext context, CalendarEvent event, DateTimeRange tileRange) =>
    EventTile(event: event);
```

The package's own `defaultTileBuilder`, `defaultTileWhenDraggingBuilder`,
`defaultFeedbackTileBuilder` and `defaultDropTargetBuilder` gained the context
the same way. Passing one as a tear-off needs no change. Calling one inside a
builder of your own means passing the context along.

Four cases need more than the signature change.

#### The timeline resolves from `GutterStyles`, not the theme

Its style decides the gutter width, which the body, the header and the drag
overlay all measure from. A theme scoped inside the calendar cannot move it.

```dart
timelineWidth: (context, range) => GutterStyles.timelineStyleOf(context).width ?? 56,
```

`defaultTimelineWidth` resolves the style the same way, so it no longer takes
one. A builder that measured the default and adjusted it drops the argument:

```dart
// Before
timelineWidth: (context, range, style) => defaultTimelineWidth(context, range, style) + 8,

// After
timelineWidth: (context, range) => defaultTimelineWidth(context, range) + 8,
```

#### The month week number keeps its top alignment

The gutter publishes the style it measures with to the scope it draws in, so
`KalenderTheme.of(context).weekNumberStyle` returns the month's value there and
the calendar-wide value everywhere else.

```dart
// Before
weekNumberBuilder: (range, style) => Align(
  alignment: style?.alignment ?? Alignment.center,
  child: Text(weekNumberOf(range)),
),

// After
weekNumberBuilder: (context, range) {
  final style = KalenderTheme.of(context).weekNumberStyle;
  return Align(
    alignment: style?.alignment ?? Alignment.center,
    child: Text(weekNumberOf(range)),
  );
},
```

#### The two overlay builders take the context positionally

They take all their other arguments by name, so the context goes in front of
them:

```dart
// Before
multiDayOverlayBuilder: ({required date, required events, ..., required style}) => MyOverlay(style: style),

// After
multiDayOverlayBuilder: (context, {required date, required events, ...}) {
  final style = KalenderTheme.of(context).multiDayOverlayStyle;
  return MyOverlay(style: style);
},
```

`MultiDayOverlayPortalBuilder` loses its `overlayStyles` parameter the same way.
`OverlayStyles` is removed with it: once no signature named it, the class could
not answer anything. Read `multiDayOverlayStyle` and
`multiDayPortalOverlayButtonStyle` off `KalenderTheme.of(context)` instead.

The overlay is built into an `Overlay` rather than below the calendar.
`KalenderTheme` is an `InheritedTheme`, so `KalenderTheme.of` still reaches it
from the overlay builder's context.

#### `ResizeHandlePositioner` returns a plain `Widget`

It was the only builder that made you subclass an abstract class. `ResizeHandles`
is removed and its six values and nine helpers move to `ResizeHandleDetails`,
which the positioner receives. Return any widget you like.

```dart
// Before
resizeHandlePositioner: (event, interaction, tileComponents, dateTimeRange, size, axis, isImprecise) =>
    MyHandles(
      event: event,
      interaction: interaction,
      tileComponents: tileComponents,
      dateTimeRange: dateTimeRange,
      size: size,
      axis: axis,
      isImprecise: isImprecise,
    ),

class MyHandles extends ResizeHandles {
  const MyHandles({
    required super.event,
    required super.interaction,
    required super.tileComponents,
    required super.dateTimeRange,
    required super.size,
    required super.axis,
    required super.isImprecise,
  });

  @override
  Widget build(BuildContext context) => resizeHandle(axis);
}

// After
resizeHandlePositioner: (context, details) => details.resizeHandle(context),
```

`showStart`, `showEnd`, `continuesBefore`, `continuesAfter`, `isVertical`,
`eventInteraction`, `startResizeDetector` and `endResizeDetector` are unchanged
and are read off `details`. `resizeHandle` takes the context and resolves the
handle widgets from it, where it read them off a `tileComponents` field before,
so the axis is now optional and defaults to the one being resized.

The two key factories move to `ResizeDetector`, the widget they key, which
reaches any test that looks one up. The key strings change with them: both named
`DayEventTile` whatever the tile actually was.

```dart
// Before
find.byKey(ResizeHandles.startResizeDraggableKey(eventId))

// After
find.byKey(ResizeDetector.startResizeDraggableKey(eventId))
```

`ResizeDetector` is the draggable that wraps the handle widget you supply through
`TileComponents.verticalResizeHandle`. It is exported now, so a handle can also
be found without a key. It carries `event` and `direction`, which pin down one
where the type alone matches several:

```dart
find.byWidgetPredicate((w) => w is ResizeDetector && w.event.id == eventId && w.direction == ResizeDirection.top)
```

Scope with `find.descendant` where the same event may be built more than once,
which a page kept alive or an overlay can do.

`TileComponents.buildResizeHandles` takes the details rather than seven
positional arguments, and returns a `Widget`:

```dart
// Before
ResizeHandles.builder(event, interaction, tileComponents, dateTimeRange, size, axis, isImprecise)

// After
tileComponents.buildResizeHandles(context, details)
```

An app that needs its own `TileComponents` inside a positioner already holds the
object it passed to the calendar, so it can close over that.

### The `builder` and `fromContext` statics are removed

`TimeLine`, `HourLines`, `DaySeparator`, `TimeIndicator`, `DayHeader`,
`WeekNumber`, `WeekDayHeader`, `MonthGrid`, `MonthDayHeader`, `MonthDayCell`,
`ScheduleDate` and `ScheduleTileHighlight` no longer carry them. Construct the widget directly, or call the matching
`buildX` on the components class, which applies your override when you set one.
`MonthDayCell.shadeAdjacentMonths` is unaffected.

```dart
// Before
MultiDayBodyComponents(daySeparator: DaySeparator.builder)

// After: pass nothing. Null selects the default.
MultiDayBodyComponents()
```

## v0.25.x → v0.26.0

### The style fields on `CalendarComponents` are removed

Deprecated in 0.25.0, which named this release. Move each style to `KalenderThemeData`.

```dart
- CalendarComponents(
-   multiDayComponentStyles: MultiDayComponentStyles(
-     bodyStyles: MultiDayBodyComponentStyles(
-       hourLinesStyle: HourLinesStyle(thickness: 2),
-     ),
-   ),
- )

+ KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 2))
```

Register that on `ThemeData.extensions` for the whole app, or wrap one calendar in a `KalenderTheme` to scope it. `CalendarComponents` keeps its builder fields, so only the four style arguments are deleted.

The seven container classes go with the fields, without a deprecation of their own, because nothing public reached them once the fields were gone. If you held one in a variable or named it in a signature, delete it:

`MonthComponentStyles`, `MonthBodyComponentStyles`, `MonthHeaderComponentStyles`, `MultiDayComponentStyles`, `MultiDayBodyComponentStyles`, `MultiDayHeaderComponentStyles`, `ScheduleComponentStyles`.

`OverlayStyles` is not one of them and stays, because `MultiDayOverlayPortalBuilder` names it. That typedef is unchanged. Its `overlayStyles` argument is now resolved from the theme, so a portal builder that reads it gets the app's overlay styles rather than an empty pair.

**If you styled the same thing differently per view,** the containers were how you did it, and a `KalenderTheme` around `CalendarHeader` or `CalendarBody` is how you do it now:

```dart
CalendarView(
  header: KalenderTheme(data: headerStyles, child: CalendarHeader()),
  body: KalenderTheme(data: bodyStyles, child: CalendarBody()),
)
```

`weekNumberStyle` and `timelineStyle` are the exception. They size the gutters that both halves have to agree on, so the calendar resolves them above the header and the body and a scope inside either one does not reach them. Set those two above the `CalendarView`. A scoped value the calendar ignores is reported in debug builds.

### Custom component builders receive a resolved style

Nothing to change unless a builder falls back on the style argument being null.

A builder used to be handed whatever the deprecated container carried, which was an empty style unless the app had set one. It is now handed the style resolved from the theme, so the fallback below never runs:

```dart
- weekNumberBuilder: (range, style) => MyWeekNumber(textStyle: style?.textStyle ?? myBoldStyle)
+ weekNumberBuilder: (range, style) => MyWeekNumber(textStyle: myBoldStyle)
```

Override the fields you want rather than falling back on null, or merge your own over what you are given:

```dart
weekNumberBuilder: (range, style) => MyWeekNumber(
  textStyle: myBoldStyle.merge(style?.textStyle),
)
```

This applies to `dayHeaderBuilder`, `daySeparator`, `hourLines`, `monthDayHeaderBuilder`, `monthGridBuilder`, `timeIndicator`, `timeline`, `weekDayHeaderBuilder`, `weekNumberBuilder` and `leadingDateBuilder`, and to the `OverlayStyles` a `MultiDayOverlayPortalBuilder` receives.

`HourLines.fromContext` loses its `style` argument in the same pass. It resolved the style from the theme and discarded whatever was passed, so it silently did nothing. Delete the argument.

### The month week number's alignment moves to the theme

Nothing to change unless you set `KalenderThemeData.weekNumberStyle.alignment`. That had no effect in the month view before and now applies, so the month week number may move. It still sits at the top when the theme sets no alignment.

The theme field feeds both the month gutter and the multi-day header, so the two can no longer be given different alignments. `MonthBodyComponentStyles` was the only way to set them apart and it is gone.

Set it above the `CalendarView` rather than on a `KalenderTheme` scoped to the header or the body. `weekNumberStyle` sizes the month gutter, which the header reserves space for, so it is resolved once above both.

### `CalendarEvent.copyWith` becomes `copyWithData`

Every subclass changes. `copyWith` is gone from `CalendarEvent`, so an override of it no longer compiles.

Rebuild only the fields your subclass adds:

```dart
- @override
- Event copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction, String? title}) {
-   return Event(
-     id: id,
-     dateTimeRange: dateTimeRange ?? this.dateTimeRange,
-     interaction: interaction ?? this.interaction,
-     multiDayRule: multiDayRule,
-     title: title ?? this.title,
-   );
- }

+ @override
+ Event copyWithData({required DateTimeRange dateTimeRange}) {
+   return Event(dateTimeRange: dateTimeRange, title: title);
+ }
```

`id`, `interaction` and `multiDayRule` are restored afterwards by `carryOver`, so do not pass them. That is the point of the change: a field added to `CalendarEvent` later reaches every subclass without any of them changing.

The calendar calls `withDateTimeRange`, which is not overridable. It applies your hook, asserts in debug that it returned your own type, then restores the base state.

**If you called `copyWith` yourself,** keep a method of your own. It is no longer an override, so it can take whatever parameters you like. Wrap the result in `carryOver` to keep the copy's identity:

```dart
Event copyWith({DateTimeRange? dateTimeRange, String? title}) {
  return carryOver(
    Event(dateTimeRange: dateTimeRange ?? this.dateTimeRange, title: title ?? this.title),
  );
}
```

**If you only moved an event,** call `withDateTimeRange` instead:

```dart
- final moved = event.copyWith(dateTimeRange: newRange);
+ final moved = event.withDateTimeRange(newRange) as Event;
```

**A subclass that writes no hook is reported twice.** `@mustBeOverridden` flags it in your own project's analysis, and a debug assert names the type on the first drag if the warning is ignored:

```
Event.copyWithData returned a CalendarEvent. Override copyWithData to return your own type,
otherwise every drag and resize replaces the event with a plain CalendarEvent and the data
your subclass adds is lost.
```

`CalendarEvent.interaction` and `CalendarEvent.multiDayRule` are getters rather than fields now, so that `carryOver` can restore them. Reading either is unchanged, and neither was assignable before.

### The three strategy fields become classes

`eventLayoutStrategy`, `generateMultiDayLayoutFrame` and `eventSnapStrategy` were function typedefs. Each is now an abstract class with value equality and named factories for the built-ins. A function cannot be deprecated into a class, so there is no window for these.

The layout strategy:

```dart
- MultiDayBodyConfiguration(eventLayoutStrategy: sideBySideLayoutStrategy)
+ MultiDayBodyConfiguration(eventLayoutStrategy: const EventLayoutStrategy.sideBySide())
```

`overlapLayoutStrategy` becomes `EventLayoutStrategy.overlap()`, the default either way.

The snap strategy:

```dart
- CalendarSnapping(eventSnapStrategy: defaultSnapStrategy)
+ CalendarSnapping(eventSnapStrategy: const EventSnapStrategy.interval())
```

`EventSnapStrategy.none()` is new and leaves the cursor position alone.

The multi-day frame generator also changes name, since the field now holds a strategy rather than a function:

```dart
- MonthBodyConfiguration(generateMultiDayLayoutFrame: myGenerator)
+ MonthBodyConfiguration(multiDayLayoutStrategy: const MyStrategy())
```

The field is no longer nullable. Passing `null` for the default becomes `const MultiDayLayoutStrategy.byDuration()`, or leave the argument out.

**If you wrote a custom layout strategy as a function,** it becomes a class. This is the shape `examples/advanced_example` had, as an inline closure:

```dart
- eventLayoutStrategy: (events, date, timeOfDayRange, heightPerMinute, minimumTileHeight, cache, location) {
-   return MyLayoutDelegate(events: events, date: date, /* ... */);
- }

+ class MyLayoutStrategy extends EventLayoutStrategy {
+   const MyLayoutStrategy();
+
+   @override
+   EventLayoutDelegate createDelegate({
+     required Iterable<CalendarEvent> events,
+     required InternalDateTime date,
+     required TimeOfDayRange timeOfDayRange,
+     required double heightPerMinute,
+     required double? minimumTileHeight,
+     required EventLayoutDelegateCache? cache,
+     required Location? location,
+   }) {
+     return MyLayoutDelegate(events: events, date: date, /* ... */);
+   }
+
+   @override
+   bool operator ==(Object other) => other.runtimeType == runtimeType;
+
+   @override
+   int get hashCode => (MyLayoutStrategy).hashCode;
+ }
+
+ eventLayoutStrategy: const MyLayoutStrategy(),
```

A strategy that carries fields compares them as well, as `PeopleLayoutStrategy` in `examples/advanced_example` does.

**If you wrote a custom multi-day strategy,** extend the base class and give it `==` and `hashCode`. `defaultMultiDayFrameGenerator` stays public, so a custom multi-day strategy can reuse the built-in row assignment and change only the sort order:

```dart
class FrameSortedByEnd extends MultiDayLayoutStrategy {
  const FrameSortedByEnd();

  @override
  MultiDayLayoutFrame generateFrame({
    required InternalDateTimeRange visibleDateTimeRange,
    required List<CalendarEvent> events,
    required TextDirection textDirection,
    required Location? location,
    required MultiDayLayoutFrameCache? cache,
  }) {
    return defaultMultiDayFrameGenerator(
      visibleDateTimeRange: visibleDateTimeRange,
      events: events,
      textDirection: textDirection,
      location: location,
      cache: cache,
      eventComparator: (a, b) => a.end.compareTo(b.end),
    );
  }

  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => (FrameSortedByEnd).hashCode;
}
```

Compare on `runtimeType` rather than `other is FrameSortedByEnd`, so a subclass of your strategy does not compare equal to it. Without `==` at all the class compares by identity, which is what the function fields did. A strategy constructed inline in `build` then reads as a change on every build, so give it value equality or hold a single instance in a field.

The methods take named parameters where the typedefs took positional ones. `EventLayoutStrategy.createDelegate` and `EventSnapStrategy.snap` both changed shape this way.

## v0.24.x → v0.25.0

### Styles move off `CalendarComponents`

Deprecated in 0.25.0, removed in 0.26.0. Nothing breaks yet.

```dart
- CalendarComponents(
-   multiDayComponentStyles: MultiDayComponentStyles(
-     bodyStyles: MultiDayBodyComponentStyles(
-       hourLinesStyle: HourLinesStyle(thickness: 2),
-     ),
-   ),
- )

+ KalenderThemeData(hourLinesStyle: HourLinesStyle(thickness: 2))
```

Register that on `ThemeData.extensions` for the whole app, or wrap one calendar in a `KalenderTheme` to scope it. The same thirteen styles are reachable either way, and `multiDayOverlayStyle` in particular had four different homes.

`CalendarComponents` keeps its builder fields. Styles go to the theme, builders stay where they are.

**If you styled the same thing differently per view,** the containers were how you did it, and a `KalenderTheme` around `CalendarHeader` or `CalendarBody` is how you do it now:

```dart
CalendarView(
  header: KalenderTheme(data: headerStyles, child: CalendarHeader()),
  body: KalenderTheme(data: bodyStyles, child: CalendarBody()),
)
```

### `isMultiDayEvent` is removed

```dart
- if (event.isMultiDayEvent) { ... }
+ if (event.spansMultipleDays(location: location, defaultRule: viewConfiguration.multiDayRule)) { ... }
```

Deprecated in 0.24.0, and the deprecation message named this release. The 0.24.0 section below covers why the name changed and what to pass.

To keep the old answer exactly, including its two limitations, pass `location: null` and `defaultRule: defaultMultiDayRule`. Prefer the calendar's own location and rule unless you are pinning existing behaviour in a test.

## v0.23.x → v0.24.0

### The deprecated string builders are gone

The seven `String Function(...)` fields on the component style classes, deprecated in 0.23.0, are removed, along with `MonthDayHeaderStyle.textStyle`, which never had any effect.

If you are coming from 0.22.x or earlier and still setting them, the replacement table is under [v0.22.x → v0.23.0](#string-builders-moved-off-the-style-classes) below. Nothing about the replacements changed in this release, so a project already on the `*Components` builders needs no action.

### The timezone package is no longer re-exported

```dart
+ import 'package:timezone/timezone.dart';
```

kalender still exports `Location` and `TZDateTime`, since both appear in its own signatures. Everything else from the timezone package, most commonly `getLocation` and `initializeTimeZones`, now needs the direct import above. Add the package to your pubspec if it is not there yet:

```bash
flutter pub add timezone
```

If you only ever pass a `Location` into the calendar, nothing changes.

### Removals that outlived their deprecation window

- `CalendarCallbacks.onMultiDayTapped`: deprecated in 0.13.0 and never called since then, so deleting the argument changes nothing.
- `DateTimeExtensions.monthNameEnglish` and `dayNameEnglish`: use `monthNameLocalized('en')` and `dayNameLocalized('en')`.

### `ScheduleTileComponents` drops three parameters that did nothing

```dart
  ScheduleTileComponents(
    tileBuilder: MyTile.builder,
-   dropTargetTile: MyDropTarget.builder,
-   overlayTileBuilder: MyOverlayTile.builder,
-   resizeDragAnchorStrategy: childDragAnchorStrategy,
  )
```

Delete the arguments. The schedule view has no overflow overlay and cannot resize tiles, so it never read any of them.

The schedule marks the drop target by highlighting the destination row rather than rendering a tile at it. To change that highlight, set `ScheduleComponents.scheduleTileHighlightBuilder` or `ScheduleTileHighlightStyle` on the theme.

### `emptyItemBuilder` and `monthItemBuilder` moved to `ScheduleComponents`

```dart
  CalendarBody(
    scheduleTileComponents: ScheduleTileComponents(
      tileBuilder: MyTile.builder,
-     emptyItemBuilder: (tileRange) => MyEmptyItem(),
-     monthItemBuilder: (monthRange) => MyMonthItem(),
    ),
  )

  CalendarView(
    components: CalendarComponents(
      scheduleComponents: ScheduleComponents(
+       emptyItemBuilder: (tileRange) => MyEmptyItem(),
+       monthItemBuilder: (monthRange) => MyMonthItem(),
      ),
    ),
  )
```

These two build list rows rather than event tiles, so they now live with the other schedule row builders. Signatures and defaults are unchanged.

### `throttleMilliseconds` is gone

```dart
  CalendarInteraction(
    allowResizing: true,
-   throttleMilliseconds: 16,
  )
```

Delete the argument. Nothing replaces it.

Drag updates are now coalesced to one per frame rather than throttled against the clock, so they follow whatever rate the display refreshes at. The old default of 16ms assumed a 60Hz screen and capped updates at about 62 per second, which is half what a 120Hz display can show. There is no longer a value to choose.

### `DragTargetUtilities` can only be applied to a `State`

Only affects you if you apply the mixin yourself. Applied to a `State`, which is the usual case, nothing changes. The type argument is inferred from the superclass:

```dart
class _MyDragTargetState extends State<MyDragTarget> with DragTargetUtilities { }
```

Applied to anything else, it no longer compiles:

```dart
- class MyDragHandler with DragTargetUtilities {
-   @override
-   BuildContext get context => ...;
- }
```

The mixin defers move handling to the end of the frame, so it can outlive disposal and has to know whether its context is still usable. Reading `State.context` after disposal throws rather than returning null, so the host has to answer `mounted` correctly. `State` already does.

### `isMultiDayEvent` became `spansMultipleDays`

```dart
- if (event.isMultiDayEvent) { ... }
+ if (event.spansMultipleDays(location: location, defaultRule: viewConfiguration.multiDayRule)) { ... }
```

Pass the calendar's `location` and the rule from your view configuration. If you never set one, that rule is `defaultMultiDayRule`.

The old getter still works in 0.24.0 and is gone in 0.25.0. It answers as if the calendar were in UTC, because a getter cannot take a location, and as if no rule were set on the view.

The name had to change. Dart rejects a class declaring both a getter and a method called `isMultiDayEvent`, so reusing the name would have meant no deprecation period at all. Worse, `event.isMultiDayEvent` would have kept compiling anywhere a `dynamic` is accepted, silently becoming a function object rather than a boolean.

### Choosing what counts as multi-day

The rule is a `MultiDayRule` on the view configuration. The default is `MultiDayRule.minimumDuration(Duration(hours: 24))`, which is exactly the previous behavior, so nothing renders differently until you change it.

| Rule | Multi-day when |
| --- | --- |
| `MultiDayRule.minimumDuration(d)` | the event lasts at least `d` |
| `MultiDayRule.calendarDays()` | the event covers part of more than one calendar day |

Set it once, for the whole calendar:

```dart
MultiDayViewConfiguration.week(
  multiDayRule: const MultiDayRule.calendarDays(),
)
```

Changing it re-sorts the events you already have. There is no need to rebuild or re-add them.

One event can disagree with the rest, which is the closest the package gets to marking something all-day:

```dart
CalendarEvent(
  dateTimeRange: range,
  multiDayRule: const MultiDayRule.calendarDays(),
)
```

`CalendarEvent.multiDayRule` is null unless you set it, and null means "use the calendar's rule". It takes part in `layoutEquals`, so two events differing only in their rule are not equal. A subclass overriding `layoutEquals` needs no change, since `super`'s comparison already covers it.

`copyWith` takes no `multiDayRule` parameter, because adding one to `CalendarEvent.copyWith` would make every subclass override invalid. A subclass has to forward it:

```dart
  Event({
    super.id,
    required super.dateTimeRange,
    required this.title,
+   super.multiDayRule,
  });

  @override
  Event copyWith({DateTimeRange? dateTimeRange, String? title}) {
    return Event(
      id: id,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
+     multiDayRule: multiDayRule,
      title: title ?? this.title,
    );
  }
```

Without it, every drag or resize produces a copy without the rule.

For a rule none of these express, override `spansMultipleDays` rather than implementing `MultiDayRule`. Its signature is:

```dart
@override
bool spansMultipleDays({required Location? location, required MultiDayRule defaultRule}) => ...;
```

If you do implement `MultiDayRule`, its one method is `isMultiDay(event, location:)`. The concrete rules behind the two factories are private, so `MultiDayRule` and those factories are the whole surface.

### `eventsFromDateTimeRange` takes the rule

Only affects you if you implement `EventsController` yourself. The method sorts events into the header and the body, so it needs to know the rule:

```dart
  Iterable<CalendarEvent> eventsFromDateTimeRange(
    InternalDateTimeRange dateTimeRange, {
+   required MultiDayRule multiDayRule,
    bool includeMultiDayEvents = true,
    bool includeDayEvents = true,
    Location? location,
  });
```

Pass it on to `event.spansMultipleDays(location: location, defaultRule: multiDayRule)`. Callers supply the current view's `ViewConfiguration.multiDayRule`.

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

**If you only set `bodyStyles.timelineStyle`** (including a custom `stringBuilder`): no change needed. The header and body now always match.

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
| Zoom (`heightPerMinute`) | Preserved only between *adjacent* multi-day views. Lost through a non-scrolling view, for example Month | **Preserved**, including across a round-trip through Month (`ZoomTransition.preserve`) |
| Visible date | Carried forward from the outgoing view | Unchanged (`DateTransition.carryFocus`) |

To restore the old "always reset the scroll on a view change" behaviour:

```dart
MultiDayViewConfiguration.week(
  scrollTransition: ScrollTransition.reset,
  zoomTransition: ZoomTransition.reset, // if you also relied on zoom resetting
)
```

### `EmptyDayBehavior.showToday` renamed to `showOnlyToday`

`EmptyDayBehavior.showToday` has been renamed to `EmptyDayBehavior.showOnlyToday`. The behaviour is unchanged: among empty days, only today is shown. The new name removes the ambiguity, since it never showed *all* empty days plus today.

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

- **Date** (all views): `dateTransition`, either `DateTransition.carryFocus` (default) or `restorePerView`, plus an optional `dateResolver` for custom logic.
- **Scroll and zoom** (`MultiDayViewConfiguration` only): `scrollTransition` and `zoomTransition`, either `preserve` (default), `reset`, or `restorePerView`, plus optional `scrollResolver` and `zoomResolver`.

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
| `auto` (default) | Detect dynamically. Hover indicates precise input, selection indicates imprecise |
| `precise` | Mouse, stylus, trackpad. Full-width handles, shown on hover |
| `imprecise` | Touch or finger. Corner handles, shown on selection |

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

**After**, extend `CalendarEvent` instead:
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
> You **must** override `==` and `hashCode` to include your custom fields. The base `CalendarEvent` equality compared only `id`, `dateTimeRange`, and `interaction` at the time of this release, and `multiDayRule` joined it in 0.24.0. Either way it never covers your own fields, so without the override, calls like `eventsController.updateEvent(event: original, updatedEvent: updated)` will not cause tile rebuilds when only custom fields (title, color, etc.) change.

#### `layoutEquals`

`layoutEquals` is used internally to skip expensive layout recalculations. The default implementation compares `id`, `dateTimeRange`, and `interaction`, joined by `multiDayRule` in 0.24.0, which is correct for most subclasses. Only override it if a custom property changes the **size or position** of the tile (e.g. a flag that makes a tile render taller). Do **not** override it for content-only changes like color or title.

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
