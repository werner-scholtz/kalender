# Controllers & Callbacks

This is part of the [kalender](README.md) documentation.

Controllers drive the calendar from your code. Callbacks report back what the user
did. Together they are how the calendar connects to the rest of your app.

---

## Controllers

### EventsController

[`EventsController`](https://pub.dev/documentation/kalender/latest/kalender/EventsController-class.html) manages and exposes events to the calendar. Typically one instance per app. Use [`DefaultEventsController`](https://pub.dev/documentation/kalender/latest/kalender/DefaultEventsController-class.html) unless you need a custom storage layer.

Its methods are `addEvent`, `addEvents`, `removeEvent`, `removeEvents`, `removeWhere`, `removeById`, `updateEvent`, `replaceEvents`, `byId`, `clearEvents` and `eventsInRange`.

`eventsInRange` takes a `FloatingDateTimeRange`, not a `KalenderDateTimeRange`.
Convert with `FloatingDateTimeRange.fromDateTimeRange(range)`.

### KalenderController

[`KalenderController`](https://pub.dev/documentation/kalender/latest/kalender/KalenderController-class.html) drives a single `KalenderView` widget.

**State notifiers:**

| Notifier               | Type                                | Description                                            |
| ---------------------- | ----------------------------------- | ------------------------------------------------------ |
| `visibleDateTimeRange` | `ValueNotifier<KalenderDateTimeRange?>`     | The currently visible date range                       |
| `visibleTimeOfDay`     | `ValueNotifier<KalenderTime?>`         | Time aligned with the top of the viewport (multi-day views, `null` otherwise) |
| `visibleEvents`        | `ValueNotifier<Set<KalenderEvent>>` | Events visible on screen                               |
| `selectedEvent`        | `ValueNotifier<KalenderEvent?>`     | The focused event (shows drop target / resize handles) |
| `selectedRange`        | `ValueNotifier<FloatingDateTimeRange?>` | The selected days, ending at midnight after the last one |
| `openDayOverlay`       | `ValueNotifier<FloatingDateTime?>`  | The day whose overlay is open (month view and multi-day header, `null` otherwise) |

**Navigation methods:**

- `jumpToPage(page)` / `jumpToDate(date)`
- `animateToNextPage()` / `animateToPreviousPage()`
- `animateToDate(date)` / `animateToDateTime(dateTime)`
- `animateToEvent(event)`

**Selection methods:** `selectEvent(event)` focuses an event from code, which is
what draws its drop target and resize handles. `deselectEvent()` clears it. Both
drive the `selectedEvent` notifier above. `selectDate(date)` and
`selectRange(range)` select whole days, `deselectRange()` clears them and
`isDateSelected(date)` tests one. They drive `selectedRange`. Pass
`navigate: true` to move the view to a selection that is off screen.

**Day overlay:** `showDayOverlay(date)` opens the overlay listing a day's events
in the month view and the multi-day header, and `hideDayOverlay()` closes it.
Both drive `openDayOverlay`. A day off screen opens nothing unless
`navigate: true` is passed.

### Disposing

Both controllers hold listeners, so dispose them with the widget that owns them:

<!-- snippet: statements -->
```dart
kalenderController.dispose();
eventsController.dispose();
```

An `EventsController` shared across screens belongs to whatever owns it for the
life of the app, and is disposed there rather than in a single screen.

### Building the surrounding UI

The calendar draws no toolbar of its own. Switching views, moving between pages
and showing the current month are all built in your app, using the navigation
methods above and the controller's `viewConfiguration`.

<!-- snippet: file -->
```dart
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(),
    MonthViewConfiguration.singleMonth(),
  ];
  late final kalenderController = KalenderController(viewConfiguration: viewConfigurations.first);

  @override
  void dispose() {
    kalenderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ValueListenableBuilder(
              valueListenable: kalenderController.visibleDateTimeRange,
              builder: (context, range, child) =>
                  Text(range == null ? '' : '${range.start.monthNameLocalized()} ${range.start.year}'),
            ),
            IconButton(onPressed: kalenderController.animateToPreviousPage, icon: const Icon(Icons.chevron_left)),
            IconButton(onPressed: kalenderController.animateToNextPage, icon: const Icon(Icons.chevron_right)),
            ListenableBuilder(
              listenable: kalenderController,
              builder: (context, child) => DropdownButton<ViewConfiguration>(
                value: kalenderController.viewConfiguration,
                items: [for (final c in viewConfigurations) DropdownMenuItem(value: c, child: Text(c.name))],
                onChanged: (value) => kalenderController.viewConfiguration = value!,
              ),
            ),
          ],
        ),
        Expanded(
          child: KalenderView(
            eventsController: eventsController,
            kalenderController: kalenderController,
            header: KalenderHeader(),
            body: KalenderBody(),
          ),
        ),
      ],
    );
  }
}
```

Setting `kalenderController.viewConfiguration` is all a view change takes. What carries over,
such as the date and scroll position, is set on the configuration itself, see
[Views](views.md#switching-between-views).

The [basic example](../examples/example) has a fuller version of this toolbar.

---

## Callbacks

Pass a `KalenderCallbacks` to `KalenderView` to react to user interactions.

<!-- snippet: expression -->
```dart
KalenderCallbacks(
  // --- Event interactions ---

  // Called when an event tile is tapped.
  onEventTapped: (event) {},

  // With tap position and the tile's RenderBox.
  onEventTappedWithDetail: (event, detail) {},

  // Called when an event is secondary tapped (right-clicked).
  onEventSecondaryTapped: (event) {},
  onEventSecondaryTappedWithDetail: (event, detail) {},

  // Called before the calendar creates a new event from a gesture.
  // Return your concrete Event subclass here.
  onEventCreate: (event) {
    return Event(start: event.start,
      end: event.end, title: 'New Event');
  },

  // onEventCreateWithDetail: (event, detail) {...} also receives the gesture
  // detail, and is used instead of onEventCreate when set.

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

  // Called when the user taps an empty area (day / week body, month cell,
  // empty schedule day).
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

  // Taps, secondary taps and long presses on a date label (day number, day
  // name, schedule date) and on a week number. Each listens only for what is set.
  dateLabel: GestureCallbacks(onTap: (detail) {}),
  weekNumber: GestureCallbacks(onTap: (detail) {}),

  // --- Drag-and-drop acceptance ---

  // Day / week vertical drag target. Return false to reject the drop.
  onWillAcceptWithDetailsVertical: (details, controller, configuration) => true,

  // Month / header horizontal drag target.
  onWillAcceptWithDetailsHorizontal: (details, controller, configuration) => true,
)
```
