import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// The [Stack] that contains the [PositionedMultiDayTileData] that is being modified.
class ChaningMultiDayTileStack<T extends Object?> extends StatelessWidget {
  const ChaningMultiDayTileStack({
    super.key,
    required this.multiDayEventLayout,
  });

  final MultiDayLayoutController<T> multiDayEventLayout;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);
    CalendarEventsController<T> controller = scope.eventController;
    CalendarTileComponents<T> components = scope.tileComponents;
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        if (controller.hasChaningEvent && controller.isMultidayEvent) {
          return ListenableBuilder(
            listenable: controller.chaningEvent!,
            builder: (BuildContext context, Widget? child) {
              PositionedMultiDayTileData<T> arragnedEvent = multiDayEventLayout.arrangeEvent(
                controller.chaningEvent!,
              );
              return MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: arragnedEvent.top,
                      left: arragnedEvent.left,
                      width: arragnedEvent.width,
                      height: arragnedEvent.height,
                      child: components.multiDayEventTileBuilder!(
                        arragnedEvent.event,
                        TileType.selected,
                        arragnedEvent.continuesBefore,
                        arragnedEvent.continuesAfter,
                      ),
                    )
                  ],
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
}
