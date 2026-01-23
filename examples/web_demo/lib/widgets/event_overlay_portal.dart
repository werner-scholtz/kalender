import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/main.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/event_overlay.dart';

class EventOverlayPortal extends StatefulWidget {
  final Widget child;
  const EventOverlayPortal({super.key, required this.child});

  static void createEventOverlay(BuildContext context, CalendarEvent event, RenderBox renderBox) {
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
  CalendarEvent? selectedEvent;
  RenderBox? selectedRenderBox;

  EventsController get eventsController => MyApp.eventsController(context);

  void createOverlay(CalendarEvent event, RenderBox renderBox) {
    selectedEvent = event;
    selectedRenderBox = renderBox;
    controller.show();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: controller,
      overlayChildBuilder: (overlayContext) {
        return LayoutBuilder(
          builder: (context, constraints) {
            var width = min(300.0, constraints.maxWidth);
            var height = 300.0;

            var position = selectedRenderBox!.localToGlobal(Offset.zero);
            final size = constraints.biggest;

            if (position.dy + height > size.height) {
              // if the overlay goes out of bounds, move it up
              position = position.translate(0, size.height - (position.dy + height) - 25);
            } else if (position.dy < 0) {
              // if the overlay goes out of bounds, move it down
              position = position.translate(0, -position.dy);
            }

            var overlapsHorizontally = false;
            if (position.dx + width + selectedRenderBox!.size.width > size.width) {
              // if the overlay goes out of bounds, move it left
              position = position.translate(-width - 16, 0);
              overlapsHorizontally = position.dx.isNegative;
            } else {
              // if the overlay goes out of bounds, move it right
              position = position.translate(selectedRenderBox!.size.width, 0);
              overlapsHorizontally = position.dx + width > size.width;
            }

            if (overlapsHorizontally) {
              final centerDx = (size.width / 2) - (width / 2);
              position = Offset(centerDx, constraints.maxHeight - height - 16);
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
                    event: Event.fromCalendarEvent(selectedEvent!),
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
        );
      },
      child: widget.child,
    );
  }
}
