# Appearance

This is part of the [kalender](../README.md) documentation.

## Tile Components

`TileComponents` is the primary way to control how events look in the calendar. Pass it to `CalendarHeader` and/or `CalendarBody` for day, multi-day, and month views.

For schedule views, use `ScheduleTileComponents` instead (passed via `CalendarBody.scheduleTileComponents`).

### Simple tile

For most apps a plain `tileBuilder` is all you need:

```dart
CalendarBody(
  multiDayTileComponents: TileComponents(
    tileBuilder: (event, tileRange) {
      final myEvent = event as Event;
      return Container(
        decoration: BoxDecoration(
          color: myEvent.color ?? Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(4),
        child: Text(myEvent.title, style: const TextStyle(color: Colors.white)),
      );
    },
  ),
)
```

### All TileComponents options

Every aspect of an event tile's appearance and drag behavior can be overridden.

<details>
  <summary>TileComponents reference</summary>

  ```dart
  TileComponents(
    // Required: the stationary event tile.
    tileBuilder: (event, tileRange) => Container(),

    // Optional: shown over the calendar in portal overlays instead of tileBuilder.
    overlayTileBuilder: (event, tileRange) => Container(),

    // Optional: shown in place of the tile while it is being dragged.
    tileWhenDraggingBuilder: (event) => Container(),

    // Optional: the tile that follows the cursor / finger during a drag.
    feedbackTileBuilder: (event, dropTargetWidgetSize) => Container(),

    // Optional: rendered beneath the dragged tile to show where it will land.
    dropTargetTile: (event) => Container(),

    // The drag anchor strategy used by feedbackTileBuilder.
    dragAnchorStrategy: childDragAnchorStrategy,

    // The drag anchor strategy used while resizing.
    resizeDragAnchorStrategy: childDragAnchorStrategy,

    // Position and size the resize handles (a function returning your ResizeHandles subclass).
    resizeHandlePositioner: myResizeHandlePositioner,

    // The vertical resize handle widget.
    verticalResizeHandle: Container(),

    // The horizontal resize handle widget.
    horizontalResizeHandle: Container(),
  )
  ```
</details>

### ScheduleTileComponents

Schedule view tiles have a different set of builders since they are laid out in a list rather than a grid.

<details>
  <summary>ScheduleTileComponents reference</summary>

  ```dart
  ScheduleTileComponents(
    tileBuilder: (event, tileRange) => Container(),
    tileWhenDraggingBuilder: (event) => Container(),
    feedbackTileBuilder: (event, dropTargetWidgetSize) => Container(),
    dropTargetTile: (event) => Container(),
    dragAnchorStrategy: childDragAnchorStrategy,

    // Builder for days with no events.
    emptyItemBuilder: (tileRange) => Container(),

    // Builder for the month heading rows.
    monthItemBuilder: (monthRange) => Container(),
  )
  ```
</details>

### Advanced tiles with event-tile utilities

For tiles that need to know the exact tapped time or find nearby events, use the provided mixins.

> [!TIP]
> **Disabling the calendar's built-in tap detector:** The calendar only wraps event tiles in a `GestureDetector` when `onEventTapped` or `onEventTappedWithDetail` is provided in `CalendarCallbacks`. If you omit both callbacks, the wrapper is skipped and a `GestureDetector` inside your custom tile widget receives events unobstructed. This is the intended pattern when using `DayEventTileUtils` or `MultiDayEventTileUtils`.

<details>
  <summary>DayEventTileUtils (day / multi-day body tiles)</summary>

  ```dart
  class CustomDayEventTile extends StatelessWidget with DayEventTileUtils {
    @override
    final CalendarEvent event;

    @override
    final InternalDateTimeRange tileRange;

    const CustomDayEventTile({
      super.key,
      required this.event,
      required this.tileRange,
    });

    Event get myEvent => event as Event;

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTapUp: (details) {
          // Convert a local tap position into an exact DateTime.
          final tappedTime = dateTimeFromPosition(context, details.localPosition);
          debugPrint('Tapped at: $tappedTime');

          // Find events that overlap a ±15-minute window around this one.
          final nearby = nearbyEvents(
            context,
            before: const Duration(minutes: 15),
            after: const Duration(minutes: 15),
          );
          debugPrint('Found ${nearby.length} nearby events');
        },
        child: Container(
          decoration: BoxDecoration(
            color: myEvent.color ?? Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Text(myEvent.title, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    // Static factory. Pass directly to TileComponents.tileBuilder.
    static Widget builder(CalendarEvent event, DateTimeRange tileRange) =>
        CustomDayEventTile(
          event: event,
          tileRange: InternalDateTimeRange.fromDateTimeRange(tileRange),
        );
  }
  ```
</details>

<details>
  <summary>MultiDayEventTileUtils (month view / multi-day header tiles)</summary>

  ```dart
  class CustomMultiDayEventTile extends StatelessWidget with MultiDayEventTileUtils {
    @override
    final CalendarEvent event;

    @override
    final InternalDateTimeRange tileRange;

    const CustomMultiDayEventTile({
      super.key,
      required this.event,
      required this.tileRange,
    });

    Event get myEvent => event as Event;

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTapUp: (details) {
          // Convert a horizontal tap position into a specific date.
          final tappedDate = dateFromPosition(context, details.localPosition);
          debugPrint('Tapped on: $tappedDate');

          final overlapping = nearbyEvents(context);
          debugPrint('Found ${overlapping.length} overlapping events');
        },
        child: Container(
          decoration: BoxDecoration(
            color: myEvent.color ?? Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            myEvent.title,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    static Widget builder(CalendarEvent event, DateTimeRange tileRange) =>
        CustomMultiDayEventTile(
          event: event,
          tileRange: InternalDateTimeRange.fromDateTimeRange(tileRange),
        );
  }
  ```
</details>

---

## Theming

Out of the box the calendar follows your app's Material 3 theme: line colors, text styles, and the rest are derived from the ambient `ColorScheme` and `TextTheme`.

To change how every calendar in the app looks, register a `KalenderThemeData` on your theme. Any field you leave out keeps its Material 3 default.

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    extensions: [
      KalenderThemeData(
        hourLinesStyle: HourLinesStyle(thickness: 2),
        timeIndicatorStyle: TimeIndicatorStyle(lineColor: Colors.pink),
      ),
    ],
  ),
)
```

Styles resolve in three layers, most specific first:

1. A style passed to a single calendar through `CalendarComponents` (see [Appearance](#appearance--custom-components)).
2. The `KalenderThemeData` registered on the theme.
3. The Material 3 defaults.

Theme changes animate: because `KalenderThemeData` is a `ThemeExtension` with `lerp`, switching themes transitions the calendar's colors along with the rest of the app.

### The overflow overlay

The overlay that opens from the `+3` button, which stands in for events that do not fit, is themed the same way. Its card and close button take Flutter's own `CardThemeData` and `ButtonStyle`, so anything you can do to a `Card` or an `IconButton` you can do here.

```dart
KalenderThemeData(
  multiDayOverlayStyle: MultiDayOverlayStyle(
    cardTheme: CardThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    closeButtonStyle: IconButton.styleFrom(backgroundColor: Colors.amber),
    // Dims the calendar behind the card. Transparent by default.
    barrierColor: Colors.black54,
    width: 320,
  ),
)
```

`closeButtonStyle` merges over the defaults of a filled tonal icon button, so it only has to set what it wants to change.

## Appearance / Custom Components

Pass a `CalendarComponents` object to `CalendarView` to override default widget builders or just pass style objects to tweak colors, text styles, and padding without defining your own widgets. Styles passed here apply to that one `CalendarView` and win over the [theme](#theming).

Style classes: [`MultiDayComponentStyles`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/multi_day_styles.dart), [`MonthComponentStyles`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/month_styles.dart), [`ScheduleComponentStyles`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/schedule_styles.dart).

<details>
  <summary>MultiDayComponents</summary>

  ```dart
  CalendarView(
    components: CalendarComponents(
      multiDayComponents: MultiDayComponents(
        headerComponents: MultiDayHeaderComponents(
          dayHeaderBuilder: (date, style) => CustomWidget(),
          weekNumberBuilder: (visibleDateTimeRange, style) => CustomWidget(),
          leftTriggerBuilder: (pageWidth) => SizedBox(width: pageWidth / 20),
          rightTriggerBuilder: (pageWidth) => SizedBox(width: pageWidth / 20),
          overlayBuilders: OverlayBuilders(
            multiDayPortalOverlayButtonBuilder:
                (portalController, numberOfHiddenRows, style) => SizedBox(),
          ),
        ),
        bodyComponents: MultiDayBodyComponents(
          hourLines: (heightPerMinute, timeOfDayRange, style, timelineStyle) => CustomWidget(),
          timeline: (heightPerMinute, timeOfDayRange, style, eventBeingDragged, visibleDateTimeRange) =>
              CustomWidget(),
          // Sizes the timeline gutter, for example to fit a custom timeline's labels.
          timelineWidth: (context, timeOfDayRange, style) => 48,
          daySeparator: (style) => CustomWidget(),
          timeIndicator: (timeOfDayRange, heightPerMinute, style, location) => CustomWidget(),
          leftTriggerBuilder: (pageWidth) => SizedBox(width: pageWidth / 20),
          rightTriggerBuilder: (pageWidth) => SizedBox(width: pageWidth / 20),
          topTriggerBuilder: (viewPortHeight) => SizedBox(height: viewPortHeight / 20),
          bottomTriggerBuilder: (viewPortHeight) => SizedBox(height: viewPortHeight / 20),
        ),
      ),
    ),
  )
  ```
</details>

<details>
  <summary>MonthComponents</summary>

  ```dart
  CalendarView(
    components: CalendarComponents(
      monthComponents: MonthComponents(
        headerComponents: MonthHeaderComponents(
          weekDayHeaderBuilder: (date, style) => SizedBox(),
        ),
        bodyComponents: MonthBodyComponents(
          monthDayHeaderBuilder: (date, style) => SizedBox(),
          // Custom per-cell background, or use the ready-made
          // MonthDayCell.shadeAdjacentMonths() to shade adjacent-month days.
          monthDayCellBuilder: (details) => SizedBox(),
          monthGridBuilder: (style, numberOfRows) => SizedBox(),
          weekNumberBuilder: (visibleDateTimeRange, style) => SizedBox(),
          leftTriggerBuilder: (pageWidth) => SizedBox(),
          rightTriggerBuilder: (pageWidth) => SizedBox(),
          overlayBuilders: OverlayBuilders(
            multiDayPortalOverlayButtonBuilder:
                (portalController, numberOfHiddenRows, style) => SizedBox(),
          ),
        ),
      ),
    ),
  )
  ```
</details>

<details>
  <summary>ScheduleComponents</summary>

  ```dart
  CalendarView(
    components: CalendarComponents(
      scheduleComponents: ScheduleComponents(
        leadingDateBuilder: (date, style) => Container(),
        scheduleTileHighlightBuilder: (date, dateTimeRange, style, child) =>
            Container(child: child),
      ),
    ),
  )
  ```
</details>
