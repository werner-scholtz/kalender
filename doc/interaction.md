# Interaction

This is part of the [kalender](README.md) documentation.

What the user can do inside a view: create, reschedule, resize, snap and zoom.
Reacting to what they did is separate, see
[Controllers & Callbacks](controllers-and-callbacks.md#callbacks).

---

## Interaction & Snapping

`CalendarHeader` and `CalendarBody` both accept these, so a calendar can allow
different things in its header than in its body.

- `interaction: CalendarInteraction`: toggling resize / reschedule / create.
- `snapping: CalendarSnapping`: (body only, MultiDay) snap interval, snap-to-indicator, snap-to-events, custom snap strategy.

```dart
CalendarBody(
  interaction: CalendarInteraction(
    allowResizing: true,
    allowRescheduling: true,
    allowEventCreation: true,
    // Tap to create (desktop default) or long-press to create (mobile default):
    createEventGesture: CreateEventGesture.tap,
    // The gesture that starts modifying an existing event, same defaults:
    modifyEventGesture: CreateEventGesture.tap,
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

---

## Zoom

Zoom the calendar in and out by changing the `heightPerMinute` value on the `MultiDayViewController`. The [`web_demo`](https://github.com/werner-scholtz/kalender/tree/main/examples/web_demo) example shows a full implementation with [`ZoomDetector`](https://github.com/werner-scholtz/kalender/blob/main/examples/web_demo/lib/widgets/calendar/zoom.dart).

Here's a minimal example of wiring up zoom with Ctrl+scroll on desktop. `PointerScrollEvent` and `HardwareKeyboard` are not exported by `material.dart`, so both imports are needed:

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
