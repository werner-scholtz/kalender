import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';
import 'package:kalender/src/models/tile_layout_controllers/tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// This stack is used to display the selected event when the user is moving or resizing it.
class ChangingTileStack<T extends Object?> extends StatelessWidget {
  const ChangingTileStack({
    super.key,
    required this.tileLayoutController,
  });

  final TileLayoutController<T> tileLayoutController;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return ListenableBuilder(
      listenable: scope.eventsController,
      builder: (BuildContext context, Widget? child) {
        if (shouldDisplayTile(scope.eventsController)) {
          return ListenableBuilder(
            listenable: scope.eventsController.chaningEvent!,
            builder: (BuildContext context, Widget? child) {
              List<PositionedTileData<T>> arragnedEvents = tileLayoutController.positionSingleEvent(
                scope.eventsController.chaningEvent!,
              );
              return MouseRegion(
                cursor: scope.eventsController.isResizing
                    ? SystemMouseCursors.resizeRow
                    : SystemMouseCursors.move,
                child: Stack(
                  children: arragnedEvents
                      .map(
                        (PositionedTileData<T> e) => Positioned(
                          top: e.top,
                          left: e.left,
                          width: e.width,
                          height: e.height,
                          child: scope.tileComponents.eventTileBuilder!(
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

  bool shouldDisplayTile(CalendarEventsController<T> controller) =>
      controller.hasChaningEvent &&
      (controller.isMoving || controller.isResizing || controller.isNewEvent);
}
