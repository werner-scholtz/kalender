# Appearance

This is part of the [kalender](README.md) documentation.

What the calendar looks like: event tiles, theming, and replacing the default
components. For where tiles are placed rather than how they look, see
[Layout](layout.md).

## Tile Components

`TileComponents` is the primary way to control how events look in the calendar. Pass it to `CalendarHeader` and/or `CalendarBody` for day, multi-day, and month views.

For schedule views, use `ScheduleTileComponents` instead (passed via `CalendarBody.scheduleTileComponents`).

### Simple tile

For most apps a plain `tileBuilder` is all you need:

<!-- snippet: expression -->
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
Only `tileBuilder` is required. Every other field defaults to null, which keeps
the package's own behavior, so set only what you want to change.

<details>
  <summary>TileComponents reference</summary>

  <!-- snippet: expression -->
  ```dart
  TileComponents(
    // Required: the stationary event tile.
    tileBuilder: (event, tileRange) => Container(),

    // Shown over the calendar in portal overlays instead of tileBuilder.
    overlayTileBuilder: (event, tileRange) => Container(),

    // Shown in place of the tile while it is being dragged.
    tileWhenDraggingBuilder: (event) => Container(),

    // The tile that follows the cursor / finger during a drag.
    feedbackTileBuilder: (event, dropTargetWidgetSize) => Container(),

    // Rendered beneath the dragged tile to show where it will land.
    dropTargetTile: (event) => Container(),

    // The drag anchor strategy used by feedbackTileBuilder.
    dragAnchorStrategy: childDragAnchorStrategy,

    // Position and size the resize handles (a function returning your ResizeHandles subclass).
    resizeHandlePositioner: myResizeHandlePositioner,

    // The vertical resize handle widget.
    verticalResizeHandle: Container(),

    // The horizontal resize handle widget.
    horizontalResizeHandle: Container(),
  )
  ```
</details>

> [!WARNING]
> `resizeDragAnchorStrategy` is left out above on purpose. It defaults to a
> pointer anchor, and setting it to `childDragAnchorStrategy` makes a vertical
> resize jump to the neighbouring day on the smallest sideways movement. Change
> it only if you have a reason to.

### ScheduleTileComponents

Schedule view tiles have a different set of builders since they are laid out in a list rather than a grid.

<details>
  <summary>ScheduleTileComponents reference</summary>

  <!-- snippet: expression -->
  ```dart
  ScheduleTileComponents(
    // Required: the stationary event tile.
    tileBuilder: (event, tileRange) => Container(),

    // Shown in place of the tile while it is being dragged.
    tileWhenDraggingBuilder: (event) => Container(),

    // The tile that follows the cursor / finger during a drag.
    feedbackTileBuilder: (event, dropTargetWidgetSize) => Container(),

    // The drag anchor strategy used by feedbackTileBuilder.
    dragAnchorStrategy: childDragAnchorStrategy,
  )
  ```
</details>

Schedule tiles cannot be resized, so `ScheduleTileComponents` takes no resize handles. It also takes no `dropTargetTile`: during a drag the schedule marks the destination by highlighting the row, built by `ScheduleComponents.scheduleTileHighlightBuilder` and styled by `ScheduleTileHighlightStyle`. The empty-day and month heading rows are list rows rather than event tiles, so their builders live on [`ScheduleComponents`](#appearance--custom-components) as well.

### Advanced tiles with event-tile utilities

For tiles that need to know the exact tapped time or find nearby events, use the provided mixins.

> [!TIP]
> **Disabling the calendar's built-in tap detector:** The calendar only wraps event tiles in a `GestureDetector` when `onEventTapped` or `onEventTappedWithDetail` is provided in `CalendarCallbacks`. If you omit both callbacks, the wrapper is skipped and a `GestureDetector` inside your custom tile widget can receive events unobstructed. This is the intended pattern when using `DayEventTileUtils` or `MultiDayEventTileUtils`.

<details>
  <summary>DayEventTileUtils (day / multi-day body tiles)</summary>

  <!-- snippet: file -->
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

  <!-- snippet: file -->
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

<!-- snippet: expression -->
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

<!-- snippet: expression -->
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

Style classes: [`MultiDayComponentStyles`](https://pub.dev/documentation/kalender/latest/kalender/MultiDayComponentStyles-class.html), [`MonthComponentStyles`](https://pub.dev/documentation/kalender/latest/kalender/MonthComponentStyles-class.html), [`ScheduleComponentStyles`](https://pub.dev/documentation/kalender/latest/kalender/ScheduleComponentStyles-class.html).

<details>
  <summary>MultiDayComponents</summary>

  <!-- snippet: expression -->
  ```dart
  CalendarComponents(
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
  )
  ```
</details>

<details>
  <summary>MonthComponents</summary>

  <!-- snippet: expression -->
  ```dart
  CalendarComponents(
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
  )
  ```
</details>

<details>
  <summary>ScheduleComponents</summary>

  <!-- snippet: expression -->
  ```dart
  CalendarComponents(
    scheduleComponents: ScheduleComponents(
      // The date column shown beside the first row of each day.
      leadingDateBuilder: (date, style) => Container(),

      // Wraps a row to highlight it as the drop target during a drag.
      scheduleTileHighlightBuilder: (date, dateTimeRange, style, child) =>
          Container(child: child),

      // Optional: builder for days with no events.
      emptyItemBuilder: (tileRange) => Container(),

      // Optional: builder for the month heading rows.
      monthItemBuilder: (monthRange) => Container(),
    ),
  )
  ```
</details>
