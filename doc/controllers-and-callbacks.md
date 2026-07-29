# Controllers & Callbacks

This is part of the [kalender](README.md) documentation.

Controllers drive the calendar from your code. Callbacks report back what the user
did. Together they are how the calendar connects to the rest of your app.

---

## Controllers

### EventsController

[`EventsController`](https://pub.dev/documentation/kalender/latest/kalender/EventsController-class.html) manages and exposes events to the calendar. Typically one instance per app. Use [`DefaultEventsController`](https://pub.dev/documentation/kalender/latest/kalender/DefaultEventsController-class.html) unless you need a custom storage layer.

| Method                               | Description                                                                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| `addEvent(event)`                    | Add a single event, returns its `String` id                                                                                    |
| `addEvents(events)`                  | Add multiple events, returns `List<String>` of ids                                                                             |
| `removeEvent(event)`                 | Remove a specific event                                                                                                        |
| `removeEvents(events)`               | Remove a list of events                                                                                                        |
| `removeWhere(test)`                  | Remove events matching a predicate                                                                                             |
| `removeById(id)`                     | Remove the event with the given `String` id                                                                                    |
| `updateEvent({event, updatedEvent})` | Replace an existing event (named parameters)                                                                                   |
| `replaceEvents(events)`              | Replace every stored event with the given list, returns `List<String>` of ids                                                  |
| `byId(id)`                           | Return the event with the given `String` id, or `null`                                                                         |
| `clearEvents()`                      | Remove all events                                                                                                              |
| `eventsFromDateTimeRange(range)`     | Events occurring during the given range (requires the view's `multiDayRule`, plus optional `includeMultiDayEvents`, `includeDayEvents`, and `location` filters) |

### CalendarController

[`CalendarController`](https://pub.dev/documentation/kalender/latest/kalender/CalendarController-class.html) drives a single `CalendarView` widget.

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

> Internally the controller delegates to a [`ViewController`](https://pub.dev/documentation/kalender/latest/kalender/ViewController-class.html) (`MultiDayViewController`, `MonthViewController`, or `ScheduleViewController`) depending on the active `ViewConfiguration`.

### Building the surrounding UI

The calendar draws no toolbar of its own. Switching views, moving between pages
and showing the current month are all built in your app, using the navigation
methods above and a `ViewConfiguration` held in state.

```dart
class _CalendarScreenState extends State<CalendarScreen> {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();

  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(),
    MultiDayViewConfiguration.singleDay(),
    MonthViewConfiguration.singleMonth(),
  ];
  late ViewConfiguration viewConfiguration = viewConfigurations.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // The visible range drives the label, so it follows every scroll,
            // page change and view switch without any extra wiring.
            ValueListenableBuilder(
              valueListenable: calendarController.visibleDateTimeRange,
              builder: (context, range, child) {
                if (range == null) return const SizedBox.shrink();
                return Text('${range.start.monthNameLocalized()} ${range.start.year}');
              },
            ),
            IconButton(
              onPressed: calendarController.animateToPreviousPage,
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              onPressed: calendarController.animateToNextPage,
              icon: const Icon(Icons.chevron_right),
            ),
            IconButton(
              onPressed: () => calendarController.animateToDate(DateTime.now()),
              icon: const Icon(Icons.today),
            ),
            const Spacer(),
            DropdownButton<ViewConfiguration>(
              value: viewConfiguration,
              items: [
                for (final configuration in viewConfigurations)
                  DropdownMenuItem(value: configuration, child: Text(configuration.name)),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => viewConfiguration = value);
              },
            ),
          ],
        ),
        Expanded(
          child: CalendarView(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: viewConfiguration,
            header: CalendarHeader(),
            body: CalendarBody(),
          ),
        ),
      ],
    );
  }
}
```

Switching `viewConfiguration` is all a view change takes. What carries over,
such as the date and scroll position, is set on the configuration itself, see
[Views](views.md#switching-between-views).

The [basic example](https://github.com/werner-scholtz/kalender/tree/main/examples/example) has a fuller version of this toolbar.

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
