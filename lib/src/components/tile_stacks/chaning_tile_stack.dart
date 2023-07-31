import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/tile_layout_controllers/tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

/// This stack is used to display the selected event when the user is moving or resizing it.
class ChangingTileStack<T extends Object?> extends StatelessWidget {
  const ChangingTileStack({
    super.key,
    required this.tileLayoutController,
  });

  final TileLayoutController<T> tileLayoutController;

  @override
  Widget build(BuildContext context) {
    CalendarInternals<T> internals = CalendarInternals.of<T>(context);
    CalendarController<T> controller = internals.controller;
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        if (shouldDisplayTile(controller)) {
          return ListenableBuilder(
            listenable: controller.chaningEvent!,
            builder: (BuildContext context, Widget? child) {
              List<PositionedTileData<T>> arragnedEvents = tileLayoutController.positionSingleEvent(
                controller.chaningEvent!,
              );
              return MouseRegion(
                cursor:
                    controller.isResizing ? SystemMouseCursors.resizeRow : SystemMouseCursors.move,
                child: Stack(
                  children: arragnedEvents
                      .map(
                        (PositionedTileData<T> e) => Positioned(
                          top: e.top,
                          left: e.left,
                          width: e.width,
                          height: e.height,
                          child: internals.components.eventTileBuilder(
                            e.event,
                            TileType.selected,
                            false,
                            e.event.isSplitAcrossDays && !e.date.isSameDay(e.event.start),
                            e.event.isSplitAcrossDays && e.date.isSameDay(e.event.start),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  bool shouldDisplayTile(CalendarController<T> controller) =>
      controller.hasChaningEvent &&
      (controller.isMoving || controller.isResizing || controller.isNewEvent);
}
