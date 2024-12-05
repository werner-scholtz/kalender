import 'package:demo/data/event.dart';
import 'package:demo/widgets/overlay_card.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

mixin CalendarOverlay {
  BuildContext get context;
  EventsController<Event> get eventsController;

  final portalController = OverlayPortalController();
  CalendarEvent<Event>? selectedEvent;
  RenderBox? selectedRenderBox;

  void createOverlay(CalendarEvent<Event> event, RenderBox renderBox) {
    selectedEvent = event;
    selectedRenderBox = renderBox;
    portalController.show();
  }

  Widget buildOverlay(BuildContext overlayContext) {
    var position = selectedRenderBox!.localToGlobal(Offset.zero);
    const height = 180.0;
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
            onTap: portalController.hide,
          ),
        ),
        Positioned(
          top: position.dy,
          left: position.dx,
          child: OverlayCard(
            event: selectedEvent!,
            position: position,
            height: height,
            width: width,
            onDismiss: portalController.hide,
            eventsController: eventsController,
          ),
        ),
      ],
    );
  }
}
