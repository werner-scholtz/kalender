# Views & Interaction

This is part of the [kalender](../README.md) documentation.

## Views

Switch between views by passing a different `ViewConfiguration` to `CalendarView`. What carries over on a switch is controlled per dimension:

- **Date** (all views): `dateTransition`. Use `DateTransition.carryFocus` (default, follows your current date) or `DateTransition.restorePerView` (each view reopens its own last date, matched by `name`).
- **Scroll & zoom** (multi-day views): `scrollTransition` / `zoomTransition`. Use `preserve` (default), `reset`, or `restorePerView`.

For custom logic, provide a `dateResolver` / `scrollResolver` / `zoomResolver`. Each overrides the matching enum. `kCarryFocusDate(transition)` gives you the default carry-focus date to build on.

All configurations accept:
- `displayRange`: the total date range the calendar can navigate within (e.g. Jan 2024 to Dec 2025). Defaults to one year either side of today.
- `initialDateTime`: the date to show on first render. Defaults to `DateTime.now()`.

```dart
MultiDayViewConfiguration.week(
  displayRange: DateTimeRange(
    start: DateTime(2024, 1, 1),
    end: DateTime(2025, 12, 31),
  ),
  initialDateTime: DateTime(2024, 6, 15),
)
```

### MultiDay View
Displays one or more days with time on the vertical axis.

| Constructor                                             | Description                                    |
| -------------------------------------------------------- | ---------------------------------------------- |
| `MultiDayViewConfiguration.singleDay()`                  | Single day                                     |
| `MultiDayViewConfiguration.week()`                       | Full 7-day week                                |
| `MultiDayViewConfiguration.workWeek()`                   | Monday to Friday                               |
| `MultiDayViewConfiguration.custom(numberOfDays: n)`      | Custom number of days                          |
| `MultiDayViewConfiguration.freeScroll(numberOfDays: n)`  | Scrolls freely across days, without page snaps |

### Month View
Shows an entire month at a glance, weeks as rows.

| Constructor                            | Description  |
| -------------------------------------- | ------------ |
| `MonthViewConfiguration.singleMonth()` | Single month |

Month view can be adjusted with `firstDayOfWeek` and `showWeekNumbers`:

```dart
MonthViewConfiguration.singleMonth(
  initialDateTime: DateTime(2025, 1, 1),
  firstDayOfWeek: DateTime.monday,
  showWeekNumbers: true,
)
```

When `showWeekNumbers` is enabled, the month body adds a leading gutter with one week number per visible row while keeping the day grid at 7 columns.

### Schedule View
Presents events in a chronological scrollable list.

| Constructor                              | Description            |
| ---------------------------------------- | ---------------------- |
| `ScheduleViewConfiguration.continuous()` | Single continuous list |
| `ScheduleViewConfiguration.paginated()`  | Paginated by month     |

---

## Controllers

### EventsController

[`EventsController`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/controllers/events_controller.dart) manages and exposes events to the calendar. Typically one instance per app. Use [`DefaultEventsController`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/controllers/events_controller/default_events_controller.dart) unless you need a custom storage layer.

| Method                               | Description                                                                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| `addEvent(event)`                    | Add a single event, returns its `String` id                                                                                    |
| `addEvents(events)`                  | Add multiple events, returns `List<String>` of ids                                                                             |
| `removeEvent(event)`                 | Remove a specific event                                                                                                        |
| `removeEvents(events)`               | Remove a list of events                                                                                                        |
| `removeWhere(test)`                  | Remove events matching a predicate                                                                                             |
| `updateEvent({event, updatedEvent})` | Replace an existing event (named parameters)                                                                                   |
| `byId(id)`                           | Return the event with the given `String` id, or `null`                                                                         |
| `clearEvents()`                      | Remove all events                                                                                                              |
| `eventsFromDateTimeRange(range)`     | Events occurring during the given range (accepts optional `includeMultiDayEvents`, `includeDayEvents`, and `location` filters) |

### CalendarController

[`CalendarController`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/controllers/calendar_controller.dart) drives a single `CalendarView` widget.

**State notifiers:**

| Notifier               | Type                                | Description                                            |
| ---------------------- | ----------------------------------- | ------------------------------------------------------ |
| `visibleDateTimeRange` | `ValueNotifier<DateTimeRange?>`     | The currently visible date range                       |
| `visibleTimeOfDay`     | `ValueNotifier<TimeOfDay?>`         | Time aligned with the top of the viewport (multi-day views, `null` otherwise) |
| `visibleEvents`        | `ValueNotifier<Set<CalendarEvent>>` | Events visible on screen                               |
| `selectedEvent`        | `ValueNotifier<CalendarEvent?>`     | The focused event (shows drop target / resize handles) |

**Navigation methods:**

- `jumpToPage(page)` / `jumpToDate(date)`
- `animateToNextPage()` / `animateToPreviousPage()`
- `animateToDate(date)` / `animateToDateTime(dateTime)`
- `animateToEvent(event)`

> Internally the controller delegates to a [`ViewController`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/controllers/view_controller.dart) (`MultiDayViewController`, `MonthViewController`, or `ScheduleViewController`) depending on the active `ViewConfiguration`.

---

## Callbacks

Pass a `CalendarCallbacks` to `CalendarView` to react to user interactions.

```dart
CalendarCallbacks(
  // --- Event interactions ---

  // Called when an event tile is tapped.
  onEventTapped: (event, renderBox) {},

  // Called when an event tile is tapped. Includes tap position detail.
  // The 'detail' parameter provides the tap location and its exact calculated 'DateTime'
  // position based on the tapped position within the event UI.
  onEventTappedWithDetail: (event, renderBox, detail) {},

  // Called when an event is secondary tapped (right-clicked).
  onEventSecondaryTapped: (event, renderBox) {},
  onEventSecondaryTappedWithDetail: (event, renderBox, detail) {},

  // Called before the calendar creates a new event from a gesture.
  // Return your concrete Event subclass here.
  onEventCreate: (event) {
    return Event(dateTimeRange: event.dateTimeRange, title: 'New Event');
  },

  // Same as onEventCreate but includes gesture detail (position, renderBox).
  onEventCreateWithDetail: (event, detail) {
    return Event(dateTimeRange: event.dateTimeRange, title: 'New Event');
  },

  // Called after a new event has been committed. Add it to your controller here.
  onEventCreated: (event) => eventsController.addEvent(event),

  // Called just before a rescheduled / resized event is applied.
  onEventChange: (event) {},

  // Called after a rescheduled / resized event is applied.
  onEventChanged: (original, updated) {
    eventsController.updateEvent(event: original, updatedEvent: updated);
  },

  // --- Calendar interactions ---

  // Called when the visible page changes.
  onPageChanged: (visibleDateTimeRange) {},

  // Called when the vertical scroll position of a multi-day view changes.
  // 'visibleTimeOfDay' is the time aligned with the top of the viewport.
  onScrollPositionChanged: (visibleTimeOfDay) {},

  // Called when the user taps an empty area (day / week body).
  onTapped: (date) {},
  onTappedWithDetail: (detail) {
    // detail.dateTime or detail.dateTimeRange, plus renderBox & localOffset.
  },

  // Called when the user secondary taps (right-clicks) an empty area.
  onSecondaryTapped: (date) {},
  onSecondaryTappedWithDetail: (detail) {},

  // Called when the user long-presses an empty area.
  onLongPressed: (date) {},
  onLongPressedWithDetail: (detail) {},

  // Called when the user secondary long-presses an empty area.
  onSecondaryLongPressed: (date) {},
  onSecondaryLongPressedWithDetail: (detail) {},

  // --- Drag-and-drop acceptance ---

  // Day / week vertical drag target. Return false to reject the drop.
  onWillAcceptWithDetailsVertical: (details, controller, configuration) => true,

  // Month / header horizontal drag target.
  onWillAcceptWithDetailsHorizontal: (details, controller, configuration) => true,
)
```

---

## Configuration & Interaction

`CalendarHeader` and `CalendarBody` accept view-specific configuration objects:

| View     | Header config class           | Body config class           |
| -------- | ----------------------------- | --------------------------- |
| MultiDay | `MultiDayHeaderConfiguration` | `MultiDayBodyConfiguration` |
| Month    | None                          | `MonthBodyConfiguration`    |
| Schedule | None                          | `ScheduleBodyConfiguration` |

Both also accept:
- `interaction: CalendarInteraction`: toggling resize / reschedule / create.
- `snapping: CalendarSnapping`: (body only, MultiDay) snap interval, snap-to-indicator, snap-to-events, custom snap strategy.

### Interaction & Snapping

```dart
CalendarBody(
  interaction: CalendarInteraction(
    allowResizing: true,
    allowRescheduling: true,
    allowEventCreation: true,
    // Tap to create (default) or long-press to create:
    createEventGesture: CreateEventGesture.tap,
    // Input mode affects resize handle positioning and visibility:
    //   auto (default): detects dynamically from pointer events
    //   precise:        mouse, stylus, trackpad (full-width handles, hover-to-show)
    //   imprecise:      touch/finger (corner handles, selection-to-show)
    inputMode: InputMode.auto,
    // Opt-in to horizontal resize handles in imprecise/touch mode (default: false):
    allowHorizontalImpreciseResize: false,
  ),
  snapping: CalendarSnapping(
    snapIntervalMinutes: 15,
    snapToTimeIndicator: true,
    snapToOtherEvents: true,
    snapRange: const Duration(minutes: 5),
    eventSnapStrategy: defaultSnapStrategy,
  ),
)
```

### Configuration details

Each view has its own configuration class with sensible defaults. Expand the references below for the full set of options.

<details>
  <summary>MultiDayHeaderConfiguration</summary>

  ```dart
  CalendarHeader(
    multiDayHeaderConfiguration: MultiDayHeaderConfiguration(
      showTiles: true,
      tileHeight: 24,
      generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator,
      maximumNumberOfVerticalEvents: null,
      eventPadding: EdgeInsets.only(left: 0, right: 4, bottom: 2),
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
      eventPadding: EdgeInsets.only(left: 0, right: 4, bottom: 2),
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

Zoom the calendar in and out by changing the `heightPerMinute` value on the `MultiDayViewController`. The [`demo`](https://github.com/werner-scholtz/kalender/tree/main/examples/demo) example shows a full implementation with [`CalendarZoomDetector`](https://github.com/werner-scholtz/kalender/blob/main/examples/demo/lib/widgets/zoom.dart).

Here's a minimal example of wiring up zoom with Ctrl+scroll on desktop:

```dart
class ZoomableCalendar extends StatelessWidget {
  final CalendarController calendarController;
  final Widget child;

  const ZoomableCalendar({
    super.key,
    required this.calendarController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (!HardwareKeyboard.instance.isControlPressed) return;
        if (event is! PointerScrollEvent) return;

        final viewController = calendarController.viewController;
        if (viewController is! MultiDayViewController) return;

        final heightPerMinute = viewController.heightPerMinute;
        final delta = event.scrollDelta.dy.sign * -0.1;
        heightPerMinute.value = (heightPerMinute.value + delta).clamp(0.5, 2.0);
      },
      child: child,
    );
  }
}
```

Wrap your `CalendarView` with this widget to enable Ctrl+scroll zooming.
