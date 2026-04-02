import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/calendar/detail_card.dart';

class EventDetailOverlay extends StatefulWidget {
  final Widget child;
  final Location? location;
  const EventDetailOverlay({super.key, required this.child, required this.location});

  static void createEventOverlay(BuildContext context, Event event, RenderBox renderBox) {
    final state = context.findAncestorStateOfType<EventDetailOverlayState>();
    if (state == null) throw Exception('EventDetailOverlayState not found in context');
    state.createOverlay(event, renderBox);
  }

  @override
  State<EventDetailOverlay> createState() => EventDetailOverlayState();
}

class EventDetailOverlayState extends State<EventDetailOverlay> with SingleTickerProviderStateMixin {
  /// The controller for the overlay portal.
  final controller = OverlayPortalController();

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final CurvedAnimation _curvedAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0.85,
    end: 1.0,
  ).animate(_curvedAnimation);

  /// The selected event and its render box.
  CalendarEvent? selectedEvent;
  RenderBox? selectedRenderBox;

  void createOverlay(CalendarEvent event, RenderBox renderBox) {
    selectedEvent = event;
    selectedRenderBox = renderBox;
    controller.show();
    _animationController.forward(from: 0.0);
  }

  void _dismissOverlay() {
    _animationController.reverse().then((_) {
      if (controller.isShowing) controller.hide();
    });
  }

  @override
  void dispose() {
    _curvedAnimation.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: controller,
      overlayChildBuilder: (overlayContext) {
        return LayoutBuilder(
          builder: (context, constraints) {
            var width = min(300.0, constraints.maxWidth);
            var height = 200.0;

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
                  child: FadeTransition(
                    opacity: _curvedAnimation,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _dismissOverlay,
                      child: const ColoredBox(color: Colors.black12),
                    ),
                  ),
                ),
                Positioned(
                  top: position.dy,
                  left: position.dx,
                  child: FadeTransition(
                    opacity: _curvedAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: EventDetailCard(
                        event: selectedEvent! as Event,
                        position: position,
                        height: height,
                        width: width,
                        onDismiss: _dismissOverlay,
                        eventsController: context.eventsController,
                        location: widget.location,
                      ),
                    ),
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
