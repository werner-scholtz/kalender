# Appearance

This is part of the [kalender](README.md) documentation.

What the calendar looks like: event tiles, theming, and replacing the default
components. For where tiles are placed rather than how they look, see
[Layout](layout.md).

## Tile Components

`TileComponents` is the primary way to control how events look in the calendar. Pass it to `KalenderHeader` and/or `KalenderBody` for day, multi-day, and month views.

For schedule views, use `ScheduleTileComponents` instead (passed via `KalenderBody.scheduleTileComponents`).

### Simple tile

For most apps a plain `tileBuilder` is all you need:

<!-- snippet: expression -->
```dart
KalenderBody(
  multiDayTileComponents: TileComponents(
    tileBuilder: (context, event, tileRange) {
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
    tileBuilder: (context, event, tileRange) => Container(),

    // Shown over the calendar in portal overlays instead of tileBuilder.
    overlayTileBuilder: (context, event, tileRange) => Container(),

    // Shown in place of the tile while it is being dragged.
    tileWhenDraggingBuilder: (context, event) => Container(),

    // The tile that follows the cursor / finger during a drag.
    feedbackTileBuilder: (context, event, dropTargetWidgetSize) => Container(),

    // Rendered beneath the dragged tile to show where it will land.
    dropTargetTile: (context, event) => Container(),

    // The drag anchor strategy used by feedbackTileBuilder.
    dragAnchorStrategy: childDragAnchorStrategy,

    // Position and size the resize handles. `details` carries the tile's geometry
    // and builds the detectors, so decide the layout and place them.
    resizeHandlePositioner: (context, details) => Stack(
      fit: StackFit.expand,
      children: [
        if (details.showStart())
          Positioned(top: 0, left: 0, right: 0, height: 8, child: details.startResizeDetector),
        if (details.showEnd())
          Positioned(bottom: 0, left: 0, right: 0, height: 8, child: details.endResizeDetector),
      ],
    ),

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
    tileBuilder: (context, event, tileRange) => Container(),

    // Shown in place of the tile while it is being dragged.
    tileWhenDraggingBuilder: (context, event) => Container(),

    // The tile that follows the cursor / finger during a drag.
    feedbackTileBuilder: (context, event, dropTargetWidgetSize) => Container(),

    // The drag anchor strategy used by feedbackTileBuilder.
    dragAnchorStrategy: childDragAnchorStrategy,
  )
  ```
</details>

Schedule tiles cannot be resized, so `ScheduleTileComponents` takes no resize handles. It also takes no `dropTargetTile`: during a drag the schedule marks the destination by highlighting the row, built by `ScheduleComponents.scheduleTileHighlightBuilder` and styled by `ScheduleTileHighlightStyle`. The empty-day and month heading rows are list rows rather than event tiles, so their builders live on [`ScheduleComponents`](#appearance--custom-components) as well.

### Advanced tiles with event-tile utilities

For tiles that need to know the exact tapped time or find nearby events, use the provided mixins.

> [!TIP]
> **Disabling the calendar's built-in tap detector:** The calendar only wraps event tiles in a `GestureDetector` when `onEventTapped` or `onEventTappedWithDetail` is provided in `KalenderCallbacks`. If you omit both callbacks, the wrapper is skipped and a `GestureDetector` inside your custom tile widget can receive events unobstructed. This is the intended pattern when using `DayEventTileUtils` or `MultiDayEventTileUtils`.

<details>
  <summary>DayEventTileUtils (day / multi-day body tiles)</summary>

  <!-- snippet: file -->
  ```dart
  class CustomDayEventTile extends StatelessWidget with DayEventTileUtils {
    @override
    final KalenderEvent event;

    @override
    final KalenderDateTimeRange tileRange;

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
    static Widget builder(BuildContext context, KalenderEvent event, KalenderDateTimeRange tileRange) =>
        CustomDayEventTile(
          event: event,
          tileRange: tileRange,
        );
  }

  const dayTileComponents = TileComponents(tileBuilder: CustomDayEventTile.builder);
  ```
</details>

<details>
  <summary>MultiDayEventTileUtils (month view / multi-day header tiles)</summary>

  <!-- snippet: file -->
  ```dart
  class CustomMultiDayEventTile extends StatelessWidget with MultiDayEventTileUtils {
    @override
    final KalenderEvent event;

    @override
    final KalenderDateTimeRange tileRange;

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

    static Widget builder(BuildContext context, KalenderEvent event, KalenderDateTimeRange tileRange) =>
        CustomMultiDayEventTile(
          event: event,
          tileRange: tileRange,
        );
  }

  const multiDayTileComponents = TileComponents(tileBuilder: CustomMultiDayEventTile.builder);
  ```
</details>

---

## Theming

By default the calendar follows your app's Material 3 theme: line colors, text styles, and the rest are derived from the ambient `ColorScheme` and `TextTheme`.

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

### Theming part of the app

Registering on `ThemeData` covers every calendar in the app. To theme one of
them differently, wrap it in a `KalenderTheme`:

<!-- snippet: expression -->
```dart
KalenderTheme(
  data: const KalenderThemeData(
    hourLinesStyle: HourLinesStyle(thickness: 2),
  ),
  child: KalenderView(
    eventsController: DefaultEventsController(),
    calendarController: KalenderController(),
    viewConfiguration: MultiDayViewConfiguration.week(),
    body: KalenderBody(),
  ),
)
```

The nearest one wins when they nest, and fields it leaves out fall through to
the theme registered on `ThemeData`, so a scope can change one thing without
restating the rest.

This is an `InheritedTheme`, so it also reaches widgets the calendar builds into
an `Overlay`, such as the tile that follows a drag. Those are not descendants of
your calendar, so an ordinary inherited widget would not reach them.

### How a style is resolved

Four layers, most specific first. Each one fills in the fields the layer above
it leaves null.

1. A style passed directly to a widget, which is how a custom builder styles the widget it returns (see [Appearance](#appearance--custom-components)).
2. The nearest `KalenderTheme` above the calendar.
3. The `KalenderThemeData` registered on `ThemeData.extensions`.
4. The Material 3 defaults.

> [!NOTE]
> Gutter widths are not styles. The month week number column and the multi-day timeline are drawn in the body and reserved again in the header, so the calendar measures each once and both halves read that number. A `KalenderTheme` scoped inside one half restyles the gutter there without resizing it. Set the width with `MonthBodyComponents.weekNumberWidth` or `MultiDayBodyComponents.timelineWidth`.

Theme changes animate: because `KalenderThemeData` is a `ThemeExtension` with `lerp`, switching themes transitions the calendar's colors along with the rest of the app. A `KalenderTheme` scope does not animate on its own, since it is a plain widget rather than part of `ThemeData`.

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

Pass a `KalenderComponents` object to `KalenderView` to override the default widget builders.

> [!NOTE]
> `KalenderComponents` carries builders only. Styles live on `KalenderThemeData`:
> register one on `ThemeData.extensions` for the whole app, or wrap a calendar in
> a [`KalenderTheme`](#theming-part-of-the-app) to style one of them.
>
> Every builder receives a `BuildContext` as its first argument and resolves what
> it needs from it: styles with `KalenderTheme.of(context)`, and the state of the
> enclosing calendar with `KalenderScope`, one accessor per value.

<details>
  <summary>MultiDayComponents</summary>

  <!-- snippet: expression -->
  ```dart
  KalenderComponents(
    multiDayComponents: MultiDayComponents(
      headerComponents: MultiDayHeaderComponents(
        dayHeaderBuilder: (context, date) => CustomWidget(),
        weekNumberBuilder: (context, visibleDateTimeRange) => CustomWidget(),
        leftTriggerBuilder: (context, pageWidth) => SizedBox(width: pageWidth / 20),
        rightTriggerBuilder: (context, pageWidth) => SizedBox(width: pageWidth / 20),
        overlayBuilders: OverlayBuilders(
          multiDayPortalOverlayButtonBuilder:
              (context, portalController, numberOfHiddenRows) => SizedBox(),
        ),
      ),
      bodyComponents: MultiDayBodyComponents(
        hourLines: (context, heightPerMinute, timeOfDayRange) => CustomWidget(),
        timeline: (context, heightPerMinute, timeOfDayRange, eventBeingDragged, visibleDateTimeRange) =>
            CustomWidget(),
        // Sizes the timeline gutter, for example to fit a custom timeline's labels.
        timelineWidth: (context, timeOfDayRange) => 48,
        daySeparator: (context) => CustomWidget(),
        timeIndicator: (context, timeOfDayRange, heightPerMinute, location) => CustomWidget(),
        leftTriggerBuilder: (context, pageWidth) => SizedBox(width: pageWidth / 20),
        rightTriggerBuilder: (context, pageWidth) => SizedBox(width: pageWidth / 20),
        topTriggerBuilder: (context, viewPortHeight) => SizedBox(height: viewPortHeight / 20),
        bottomTriggerBuilder: (context, viewPortHeight) => SizedBox(height: viewPortHeight / 20),
      ),
    ),
  )
  ```
</details>

<details>
  <summary>MonthComponents</summary>

  <!-- snippet: expression -->
  ```dart
  KalenderComponents(
    monthComponents: MonthComponents(
      headerComponents: MonthHeaderComponents(
        weekDayHeaderBuilder: (context, date) => SizedBox(),
      ),
      bodyComponents: MonthBodyComponents(
        monthDayHeaderBuilder: (context, date) => SizedBox(),
        // Custom per-cell background, or use the ready-made
        // MonthDayCell.shadeAdjacentMonths() to shade adjacent-month days.
        monthDayCellBuilder: (context, details) => SizedBox(),
        monthGridBuilder: (context, numberOfRows) => SizedBox(),
        weekNumberBuilder: (context, visibleDateTimeRange) => SizedBox(),
        leftTriggerBuilder: (context, pageWidth) => SizedBox(),
        rightTriggerBuilder: (context, pageWidth) => SizedBox(),
        overlayBuilders: OverlayBuilders(
          multiDayPortalOverlayButtonBuilder:
              (context, portalController, numberOfHiddenRows) => SizedBox(),
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
  KalenderComponents(
    scheduleComponents: ScheduleComponents(
      // The date column shown beside the first row of each day.
      leadingDateBuilder: (context, date) => Container(),

      // Wraps a row to highlight it as the drop target during a drag.
      scheduleTileHighlightBuilder: (context, date, dateTimeRange, child) =>
          Container(child: child),

      // Optional: builder for days with no events.
      emptyItemBuilder: (context, tileRange) => Container(),

      // Optional: builder for the month heading rows.
      monthItemBuilder: (context, monthRange) => Container(),
    ),
  )
  ```
</details>
