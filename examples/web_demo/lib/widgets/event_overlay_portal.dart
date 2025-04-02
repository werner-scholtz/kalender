import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/main.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/event_overlay.dart';

class EventOverlayPortal extends StatefulWidget {
  final Widget child;
  const EventOverlayPortal({super.key, required this.child});

  static void createEventOverlay(BuildContext context, CalendarEvent<Event> event, RenderBox renderBox) {
    final state = context.findAncestorStateOfType<EventOverlayPortalState>();
    if (state == null) throw Exception('EventOverlayPortalState not found in context');
    state.createOverlay(event, renderBox);
  }

  @override
  State<EventOverlayPortal> createState() => EventOverlayPortalState();
}

class EventOverlayPortalState extends State<EventOverlayPortal> {

  /// The controller for the overlay portal.
  final controller = OverlayPortalController();

  /// The selected event and its render box.
  CalendarEvent<Event>? selectedEvent;
  RenderBox? selectedRenderBox;

  EventsController get eventsController => MyApp.eventsController(context);

  void createOverlay(CalendarEvent<Event> event, RenderBox renderBox) {
    selectedEvent = event;
    selectedRenderBox = renderBox;
    controller.show();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: controller,
      overlayChildBuilder: (overlayContext) {
        var position = selectedRenderBox!.localToGlobal(Offset.zero);
        const height = 300.0;
        const width = 300.0;

        final size = MediaQuery.sizeOf(context);

        if (position.dy + height > size.height) {
          position = position.translate(0, size.height - (position.dy + height) - 25);
        } else if (position.dy < 0) {
          position = position.translate(0, -position.dy);
        }

        if (position.dx + width + selectedRenderBox!.size.width > size.width) {
          position = position.translate(-width - 16, 0);
        } else {
          position = position.translate(selectedRenderBox!.size.width, 0);
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.hide,
              ),
            ),
            Positioned(
              top: position.dy,
              left: position.dx,
              child: EventOverlayCard(
                event: selectedEvent!,
                position: position,
                height: height,
                width: width,
                onDismiss: controller.hide,
                eventsController: eventsController,
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}
