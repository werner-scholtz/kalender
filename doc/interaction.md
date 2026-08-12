# Interaction

This is part of the [kalender](README.md) documentation.

What the user can do inside a view: create, reschedule, resize, snap and zoom.
Reacting to what they did is separate, see
[Controllers & Callbacks](controllers-and-callbacks.md#callbacks).

---

## Interaction & Snapping

`interaction` sets what the user may do. `CalendarHeader` and `CalendarBody` both
accept it, so a calendar can allow different things in its header than in its
body. `snapping` is accepted by `CalendarBody` only, and only the multi-day body
reads it.

Both blocks below show every option **at its default value**.

<!-- snippet: expression -->
```dart
CalendarBody(
  interaction: CalendarInteraction(
    allowResizing: true,
    allowRescheduling: true,
    allowEventCreation: true,
    // Tap on desktop, long-press on mobile, when left unset.
    createEventGesture: CreateEventGesture.tap,
    // The gesture that starts modifying an existing event, same defaults.
    modifyEventGesture: CreateEventGesture.tap,
    // Input mode affects resize handle positioning and visibility:
    //   auto:      detects dynamically from pointer events
    //   precise:   mouse, stylus, trackpad (full-width handles, hover-to-show)
    //   imprecise: touch/finger (corner handles, selection-to-show)
    inputMode: InputMode.auto,
    // Opt in to horizontal resize handles in imprecise/touch mode.
    allowHorizontalImpreciseResize: false,
  ),
  snapping: CalendarSnapping(
    snapIntervalMinutes: 10,
    snapToTimeIndicator: true,
    snapToOtherEvents: true,
    snapRange: const Duration(minutes: 15),
    eventSnapStrategy: const EventSnapStrategy.interval(),
  ),
)
```

---

## Locking a single event

`CalendarInteraction` applies to the whole calendar. To hold one event in place
while the rest stay editable, give it an `EventInteraction`. Anything the event
forbids stays forbidden even where the calendar allows it.

<!-- snippet: expression -->
```dart
CalendarEvent(
  dateTimeRange: range,
  // Movable, but its start and end are fixed.
  interaction: EventInteraction(
    allowStartResize: false,
    allowEndResize: false,
    allowRescheduling: true,
  ),
)
```

`EventInteraction.allowNone()` makes an event fully read-only, and
`EventInteraction.allowAll()` is the default every event gets. A subclass passes
it through with `super.interaction`, as in [Custom Events](events.md#custom-events).

---

## Zoom

Zoom the calendar in and out by changing the `heightPerMinute` value on the `MultiDayViewController`. The [`web_demo`](../examples/web_demo) example shows a full implementation with [`ZoomDetector`](../examples/web_demo/lib/widgets/calendar/zoom.dart).

Here's a minimal example of wiring up zoom with Ctrl+scroll on desktop. `PointerScrollEvent` and `HardwareKeyboard` are not exported by `material.dart`, so both imports are needed:

<!-- snippet: file -->
```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

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
