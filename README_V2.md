<p align="center">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/banner.png?raw=true" width="100%" style="border-radius:6px; margin-top:8px; margin-bottom:8px;" />
</p>

# Kalender
A Flutter calendar package offering Day, MultiDay, Month, and Schedule views with full control over appearance and behavior. Check out the live demo [here](https://werner-scholtz.github.io/kalender/).

> This package is still in development — API changes may occur before version 1.0.0.

## Features

* **Views:** Day, Multi-day, Month and Schedule. [find out more](#views)
* **Extensible events:** Attach custom data (title, color, etc.) by subclassing `CalendarEvent`. [find out more](#custom-events)
* **Tile components:** Fully customize event tiles — stationary, dragging, feedback, and resize handles. [find out more](#tile-components)
* **Reschedule:** Drag and drop events between days and times.
* **Resize:** Resize events on desktop and mobile.
* **Controllers:** Manage your calendar with dedicated controllers. [find out more](#controllers)
* **Callbacks:** React to taps, long presses, event creation and changes. [find out more](#callbacks)
* **Configuration:** Fine-grained control over interaction, snapping, scroll physics, and layout. [find out more](#header--body-configuration)
* **Appearance:** Style default components or supply custom builders. [find out more](#appearance--custom-components)
* **Event layout:** Built-in strategies or bring your own. [find out more](#event-layout)
* **Locale:** Localize day/month names via the [intl](https://pub.dev/packages/intl) package. [find out more](#locale)
* **Location:** Timezone-aware display via the [timezone](https://pub.dev/packages/timezone) package. [find out more](#location)

## Roadmap

* **Views:** FreeScroll calendar view.

## Preview

### MultiDayView
Displays one or more days with time on the vertical axis — ideal for detailed scheduling.

<div style="padding:8px; display:inline-block; text-align:center;">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_day_light.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_day_dark.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_day_light.png?raw=true" width="9%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_day_dark.png?raw=true" width="9%" style="border-radius:6px;" />
</div>

<div style="padding:8px; display:inline-block; text-align:center;">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_week_light.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_week_dark.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_week_light.png?raw=true" width="9%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_week_dark.png?raw=true" width="9%" style="border-radius:6px;" />
</div>

### MonthView
Shows an entire month at a glance, with days arranged horizontally.

<div style="padding:8px; display:inline-block; text-align:center;">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_month_light.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_month_dark.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_month_light.png?raw=true" width="9%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_month_dark.png?raw=true" width="9%" style="border-radius:6px;" />
</div>

### ScheduleView
Presents events in a continuous, scrollable list focused on upcoming or grouped events.

<div style="padding:8px; display:inline-block; text-align:center;">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_schedule_light.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_schedule_dark.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_schedule_light.png?raw=true" width="9%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_schedule_dark.png?raw=true" width="9%" style="border-radius:6px;" />
</div>

---

## Installation

```yaml
dependencies:
  kalender: ^0.16.0
  timezone: ^0.9.0   # only needed for timezone / location support
```

If you plan to use [locale](#locale) support, also add:

```yaml
dependencies:
  intl: ^0.19.0
```

And call `initializeDateFormatting()` before `runApp`:

```dart
void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}
```

---

## Quick Start

The minimal setup — using only the base `CalendarEvent` class with no custom fields:

```dart
final eventsController = DefaultEventsController();
final calendarController = CalendarController();

Widget build(BuildContext context) {
  return CalendarView(
    eventsController: eventsController,
    calendarController: calendarController,
    viewConfiguration: MultiDayViewConfiguration.singleDay(),
    callbacks: CalendarCallbacks(
      onEventCreated: (event) => eventsController.addEvent(event),
    ),
    header: CalendarHeader(),
    body: CalendarBody(),
  );
}
```

For a real app you almost always want custom fields on your events. See [Custom Events](#custom-events) below.

---

## Custom Events

Since v0.16.0, `CalendarEvent` is no longer generic. The idiomatic way to attach custom data (title, color, description, etc.) is to **extend** `CalendarEvent` directly.

```dart
class Event extends CalendarEvent {
  final String title;
  final String? description;
  final Color? color;

  Event({
    required super.dateTimeRange,
    required this.title,
    this.description,
    this.color,
    super.interaction,
  });

  @override
  Event copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? title,
    String? description,
    Color? color,
  }) {
    final updated = Event(
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      interaction: interaction ?? this.interaction,
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
    // Always carry the existing ID over to the new instance.
    updated.id = id;
    return updated;
  }

  // Override == and hashCode so that the calendar can detect when an event's
  // custom fields have changed and update the tile accordingly.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return super == other &&
        other is Event &&
        other.title == title &&
        other.description == description &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, title, description, color);
}
```

> **Note:** If you don't override `==` and `hashCode`, the calendar cannot detect changes to your custom fields and tiles will not update when those values change (e.g. via `eventsController.updateEvent(...)`). Always override both whenever you add fields to your `CalendarEvent` subclass.

> **`layoutEquals`:** Only override this when a custom property changes the *size or position* of the tile — for example, a flag that makes a tile render taller. It is **not** for content-only changes like color or title. The default implementation compares `id`, `dateTimeRange`, and `interaction`, which is sufficient for most cases.

### Accessing custom fields in tile builders

Cast the event to your subclass. A convenience getter keeps the cast to one place:

```dart
tileBuilder: (event, tileRange) {
  final myEvent = event as Event;
  return Container(
    color: myEvent.color ?? Colors.blue,
    child: Text(myEvent.title),
  );
},
```

### Returning your subclass on event creation

Use `onEventCreate` to intercept the bare `CalendarEvent` created by a gesture and return a fully typed instance:

```dart
callbacks: CalendarCallbacks(
  onEventCreate: (event) => Event(
    dateTimeRange: event.dateTimeRange,
    title: 'New Event',
    color: Colors.blue,
  ),
  onEventCreated: (event) => eventsController.addEvent(event),
),
```

---

## Views

Switch between views by passing a different `ViewConfiguration` to `CalendarView`. When switching, the `initialDateSelectionStrategy` on the view configuration determines which date becomes visible. All configurations accept a `displayRange` and an optional `initialDateTime`.

### MultiDay View
Displays one or more days with time on the vertical axis.

| Constructor | Description |
|---|---|
| `MultiDayViewConfiguration.singleDay()` | Single day |
| `MultiDayViewConfiguration.week()` | Full 7-day week |
| `MultiDayViewConfiguration.workWeek()` | Monday – Friday |
| `MultiDayViewConfiguration.custom(days: n)` | Custom number of days |

### Month View
Shows an entire month at a glance, weeks as rows.

| Constructor | Description |
|---|---|
| `MonthViewConfiguration.singleMonth()` | Single month |

### Schedule View
Presents events in a chronological scrollable list.

| Constructor | Description |
|---|---|
| `ScheduleViewConfiguration.continuous()` | Single continuous list |
| `ScheduleViewConfiguration.paginated()` | Paginated by month |

---

## Controllers

### EventsController

[`EventsController`](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/events_controller.dart#L8) manages and exposes events to the calendar. Typically one instance per app. Use [`DefaultEventsController`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/controllers/events_controller/default_events_controller.dart) unless you need a custom storage layer.

| Method | Description |
|---|---|
| `addEvent(event)` | Add a single event, returns its `String` id |
| `addEvents(events)` | Add multiple events, returns `List<String>` of ids |
| `removeEvent(event)` | Remove a specific event |
| `removeEvents(events)` | Remove a list of events |
| `removeWhere(test)` | Remove events matching a predicate |
| `updateEvent(event, updatedEvent)` | Replace an existing event |
| `byId(id)` | Return the event with the given `String` id, or `null` |
| `clearEvents()` | Remove all events |
| `eventsFromDateTimeRange(range)` | Events occurring during the given range |

### CalendarController

[`CalendarController`](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/calendar_controller.dart#L15) drives a single `CalendarView` widget.

**State notifiers:**

| Notifier | Type | Description |
|---|---|---|
| `visibleDateTimeRange` | `ValueNotifier<DateTimeRange>` | The currently visible date range |
| `visibleEvents` | `ValueNotifier<Set<CalendarEvent>>` | Events visible on screen |
| `selectedEvent` | `ValueNotifier<CalendarEvent?>` | The focused event (shows drop target / resize handles) |

**Navigation methods:**

- `jumpToPage(page)` / `jumpToDate(date)`
- `animateToNextPage()` / `animateToPreviousPage()`
- `animateToDate(date)` / `animateToDateTime(dateTime)`
- `animateToEvent(event)`

> Internally the controller delegates to a [`ViewController`](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/view_controller.dart#L8) — `MultiDayViewController`, `MonthViewController`, or `ScheduleViewController` — depending on the active `ViewConfiguration`.

---

## Tile Components

`TileComponents` is the primary way to control how events look in the calendar. Pass it to `CalendarHeader` and/or `CalendarBody`.

### Simple tile

For most apps a plain `tileBuilder` is all you need:

```dart
CalendarBody(
  tileComponents: TileComponents(
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

    // Customize the position and size of resize handles (extend ResizeHandlePositioner).
    resizeHandlePositioner: myResizeHandlePositioner,

    // The vertical resize handle widget.
    verticalResizeHandle: Container(),

    // The horizontal resize handle widget.
    horizontalResizeHandle: Container(),
  )
  ```
</details>

### ScheduleTileComponents

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

> **Disabling the calendar's built-in tap detector:** The calendar only wraps event tiles in a `GestureDetector` when `onEventTapped` or `onEventTappedWithDetail` is provided in `CalendarCallbacks`. If you omit both callbacks, the wrapper is skipped and a `GestureDetector` inside your custom tile widget receives events unobstructed. This is the intended pattern when using `DayEventTileUtils` or `MultiDayEventTileUtils`.

<details>
  <summary>DayEventTileUtils — for day / multi-day body tiles</summary>

  ```dart
  class CustomDayEventTile extends StatelessWidget with DayEventTileUtils {
    @override
    final CalendarEvent event;

    // tileRange is InternalDateTimeRange to satisfy the mixin contract.
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
          print('Tapped at: $tappedTime');

          // Find events that overlap a ±15-minute window around this one.
          final nearby = nearbyEvents(
            context,
            before: const Duration(minutes: 15),
            after: const Duration(minutes: 15),
          );
          print('Found ${nearby.length} nearby events');
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

    // Static factory — pass directly to TileComponents.tileBuilder.
    static Widget builder(CalendarEvent event, DateTimeRange tileRange) =>
        CustomDayEventTile(
          event: event,
          tileRange: InternalDateTimeRange.fromDateTimeRange(tileRange),
        );
  }
  ```
</details>

<details>
  <summary>MultiDayEventTileUtils — for month view / multi-day header tiles</summary>

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
          print('Tapped on: $tappedDate');

          final overlapping = nearbyEvents(context);
          print('Found ${overlapping.length} overlapping events');
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

## Callbacks

Pass a `CalendarCallbacks` to `CalendarView` to react to user interactions.

<details>
  <summary>CalendarCallbacks reference</summary>

  ```dart
  CalendarCallbacks(
    // --- Event interactions ---

    // Called when an event tile is tapped.
    onEventTapped: (event, renderBox) {},

    // Called when an event tile is tapped — includes tap position detail.
    onEventTappedWithDetail: (event, renderBox, detail) {},

    // Called before the calendar creates a new event from a gesture.
    // Return your concrete Event subclass here.
    onEventCreate: (event) {
      return Event(dateTimeRange: event.dateTimeRange, title: 'New Event');
    },

    // Same as onEventCreate but includes gesture detail (position, renderBox).
    onEventCreateWithDetail: (event, detail) {
      return Event(dateTimeRange: event.dateTimeRange, title: 'New Event');
    },

    // Called after a new event has been committed — add it to your controller here.
    onEventCreated: (event) => eventsController.addEvent(event),

    // Called just before a rescheduled / resized event is applied.
    onEventChange: (event) {},

    // Called after a rescheduled / resized event is applied.
    onEventChanged: (original, updated) {
      // Persist the change to your database / state here.
      eventsController.updateEvent(original, updated);
    },

    // --- Calendar interactions ---

    // Called when the visible page changes.
    onPageChanged: (visibleDateTimeRange) {},

    // Called when the user taps an empty area (day / week body).
    onTapped: (date) {},
    onTappedWithDetail: (detail) {
      // detail.dateTime or detail.dateTimeRange, plus renderBox & localOffset.
    },

    // Called when the user long-presses an empty area.
    onLongPressed: (date) {},
    onLongPressedWithDetail: (detail) {},

    // --- Drag-and-drop acceptance ---

    // Day / week vertical drag target. Return false to reject the drop.
    onWillAcceptWithDetailsVertical: (details, controller, configuration) => true,

    // Month / header horizontal drag target.
    onWillAcceptWithDetailsHorizontal: (details, controller, configuration) => true,
  )
  ```
</details>

---

## Header & Body Configuration

`CalendarHeader` and `CalendarBody` accept view-specific configuration objects:

| View | Header config class | Body config class |
|---|---|---|
| MultiDay | `MultiDayHeaderConfiguration` | `MultiDayBodyConfiguration` |
| Month | — | `MonthBodyConfiguration` |
| Schedule | — | `ScheduleBodyConfiguration` |

Both also accept:
- `interaction: ValueNotifier<CalendarInteraction>` — toggling resize / reschedule / create.
- `snapping: ValueNotifier<CalendarSnapping>` — (body only, MultiDay) snap interval, snap-to-indicator, snap-to-events, custom snap strategy.

### Interaction & Snapping

```dart
CalendarBody(
  interaction: ValueNotifier(CalendarInteraction(
    allowResizing: true,
    allowRescheduling: true,
    allowEventCreation: true,
    // Tap to create (default) or long-press to create:
    createEventGesture: CreateEventGesture.tap,
  )),
  snapping: ValueNotifier(CalendarSnapping(
    snapIntervalMinutes: 15,
    snapToTimeIndicator: true,
    snapToOtherEvents: true,
    snapRange: const Duration(minutes: 5),
    eventSnapStrategy: defaultSnapStrategy,
  )),
)
```

### Configuration details

<details>
  <summary>MultiDayHeaderConfiguration</summary>

  ```dart
  CalendarHeader(
    multiDayHeaderConfiguration: MultiDayHeaderConfiguration(
      showTiles: true,
      tileHeight: 24,
      generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator,
      maximumNumberOfVerticalEvents: null,
      eventPadding: EdgeInsets.zero,
      pageTriggerConfiguration: PageTriggerConfiguration(),
    ),
  )
  ```
</details>

<details>
  <summary>MultiDayBodyConfiguration</summary>

  ```dart
  CalendarBody(
    multiDayBodyConfiguration: MultiDayBodyConfiguration(
      showMultiDayEvents: true,
      horizontalPadding: EdgeInsets.only(left: 0, right: 4),
      minimumTileHeight: 24.0,
      pageTriggerConfiguration: PageTriggerConfiguration(),
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
      eventLayoutStrategy: overlapLayoutStrategy,
      scrollPhysics: BouncingScrollPhysics(),
      pageScrollPhysics: BouncingScrollPhysics(),
    ),
  )
  ```
</details>

<details>
  <summary>MonthBodyConfiguration</summary>

  ```dart
  CalendarBody(
    monthBodyConfiguration: MonthBodyConfiguration(
      tileHeight: 24,
      generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator,
      pageTriggerConfiguration: PageTriggerConfiguration(),
    ),
  )
  ```
</details>

<details>
  <summary>ScheduleBodyConfiguration</summary>

  ```dart
  CalendarBody(
    scheduleBodyConfiguration: ScheduleBodyConfiguration(
      emptyDay: EmptyDayBehavior.hide,
      pageTriggerConfiguration: PageTriggerConfiguration(),
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
      scrollPhysics: BouncingScrollPhysics(),
      pageScrollPhysics: BouncingScrollPhysics(),
    ),
  )
  ```
</details>

### Zoom

It is possible to zoom the calendar in/out by changing `heightPerMinute`. The [`demo`](https://github.com/werner-scholtz/kalender/tree/main/examples/demo) example shows how this is done with [`CalendarZoomDetector`](https://github.com/werner-scholtz/kalender/blob/main/examples/demo/lib/widgets/zoom.dart).

---

## Appearance / Custom Components

Pass a `CalendarComponents` object to `CalendarView` to override default widget builders or just pass style objects to tweak colors, text styles, and padding without rebuilding widgets.

Style classes: [`MultiDayComponentStyles`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/multi_day_styles.dart), [`MonthComponentStyles`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/month_styles.dart), [`ScheduleComponentStyles`](https://github.com/werner-scholtz/kalender/blob/d5f973c176e97118792c919dda58699b24af19f7/lib/src/models/components/schedule_components.dart#L5).

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
          hourLines: (heightPerMinute, timeOfDayRange, style) => CustomWidget(),
          timeline: (heightPerMinute, timeOfDayRange, style) => CustomWidget(),
          daySeparator: (style) => CustomWidget(),
          timeIndicator: (timeOfDayRange, heightPerMinute, timelineWidth, style) => CustomWidget(),
          leftTriggerBuilder: (pageHeight) => SizedBox(width: pageHeight / 20),
          rightTriggerBuilder: (pageHeight) => SizedBox(width: pageHeight / 20),
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
          monthGridBuilder: (style) => SizedBox(),
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
        dayHeaderBuilder: (date, style) => Container(),
        scheduleTileHighlightBuilder: (date, dateTimeRange, style, child) =>
            Container(child: child),
      ),
    ),
  )
  ```
</details>

---

## Event Layout

### Vertical layout (Day / MultiDay body)

The package uses [`CustomMultiChildLayout`](https://api.flutter.dev/flutter/widgets/CustomMultiChildLayout-class.html) with an [`EventLayoutDelegate`](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/layout_delegates/event_layout_delegate.dart) to position tiles.

Built-in strategies (pass via `MultiDayBodyConfiguration.eventLayoutStrategy`):

| Strategy | Behavior |
|---|---|
| `overlapLayoutStrategy` | Tiles stack on top of each other (default) |
| `sideBySideLayoutStrategy` | Tiles placed side by side |

To create a custom strategy, subclass `EventLayoutDelegate` — see [`CustomSideBySideLayoutDelegate`](https://github.com/werner-scholtz/kalender/blob/main/examples/advanced_example/lib/layout_strategy.dart) in the advanced example.

### Horizontal layout (Month view / MultiDay header)

Events are placed in a grid of rows × columns (rows = concurrent events, columns = days). A **layout frame** (`MultiDayLayoutFrame`) generated by `defaultMultiDayFrameGenerator` determines each event's row and column span.

The default generator sorts events by duration then start date. Supply an `eventComparator` to change the order:

```dart
CalendarBody(
  monthBodyConfiguration: MonthBodyConfiguration(
    generateMultiDayLayoutFrame: ({
      required events,
      required textDirection,
      required visibleDateTimeRange,
      required location,
      cache,
    }) =>
        defaultMultiDayFrameGenerator(
          events: events,
          textDirection: textDirection,
          visibleDateTimeRange: visibleDateTimeRange,
          location: location,
          cache: cache,
          eventComparator: (a, b) => a.end.compareTo(b.end),
        ),
  ),
)
```

---

## Locale

`CalendarView` has a `locale` property that controls day/month name formatting.

```dart
CalendarView(
  locale: 'af_ZA',
  // ...
)
```

For the overlay "N more" button text, override the style:

```dart
CalendarView(
  components: CalendarComponents(
    overlayStyles: OverlayStyles(
      multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle(
        stringBuilder: (n) => '$n something',
      ),
    ),
  ),
)
```

> **Setup reminder:** call `initializeDateFormatting()` in `main()` before using any locale. See [Installation](#installation).

---

## Location

`CalendarView` accepts a `Location` from the [timezone](https://pub.dev/packages/timezone) package. All events are stored in UTC and converted to the given location for display.

```dart
import 'package:timezone/timezone.dart' as tz;

CalendarView(
  location: tz.getLocation('America/New_York'),
  eventsController: eventsController,
  calendarController: calendarController,
  viewConfiguration: viewConfiguration,
)
```

Pre-initialize `DefaultEventsController` with the locations you expect to query for best performance:

```dart
final eventsController = DefaultEventsController(
  locations: [
    tz.getLocation('America/New_York'),
    tz.getLocation('Europe/London'),
    tz.getLocation('Asia/Tokyo'),
  ],
);
```

See the [timezone package](https://pub.dev/packages/timezone) for setup instructions per platform. The [web demo](https://github.com/werner-scholtz/kalender/tree/main/examples/web_demo) also provides a working example.

**Notes:**
- Changing `location` at runtime automatically updates visible date/time ranges.
- Location identifiers: [IANA Time Zone Database](https://www.iana.org/time-zones).

---

## Migration Guide

### v0.15.x → v0.16.0

#### `CalendarEvent` is no longer generic

**Before:**
```dart
CalendarEvent<MyData>(dateTimeRange: range, data: MyData(...))
```

**After** — extend `CalendarEvent` instead:
```dart
class MyEvent extends CalendarEvent {
  final MyData data;

  MyEvent({required super.dateTimeRange, required this.data});

  @override
  MyEvent copyWith({DateTimeRange? dateTimeRange, EventInteraction? interaction, MyData? data}) =>
      MyEvent(
        dateTimeRange: dateTimeRange ?? this.dateTimeRange,
        interaction: interaction ?? this.interaction,
        data: data ?? this.data,
      )..id = id;
}
```

#### Event IDs are now `String`

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

#### Renamed symbols

| Old name | New name |
|---|---|
| `MultiDayOverlayEventTile` | `MultiDayEventOverlayTile` |

#### Moved imports

`EventsController` and related files moved into the `controllers` folder. Package-relative imports need updating. The top-level `package:kalender/kalender.dart` barrel export is unaffected.

#### `DefaultEventsController` direct export

`DefaultEventsController` is now exported directly from `package:kalender/kalender.dart`. No changes needed if you already import from there.

#### `DayEventTileUtils` / `MultiDayEventTileUtils` no longer generic

The mixins no longer carry a type parameter. Remove `<T>` from the mixin application and the `event` / `tileRange` field declarations.

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
