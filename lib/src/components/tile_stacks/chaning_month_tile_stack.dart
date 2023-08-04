import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller.dart';
import 'package:kalender/src/models/tile_layout_controllers/multi_day_tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

/// The [ChaningMonthTileStack] displays a single [PositionedMultiDayTileData] that is being modified.
class ChaningMonthTileStack<T> extends StatelessWidget {
  const ChaningMonthTileStack({
    super.key,
    required this.monthEventLayout,
  });

  final MonthLayoutController<T> monthEventLayout;

  @override
  Widget build(BuildContext context) {
    CalendarScope<T> scope = CalendarScope.of(context);

    return ListenableBuilder(
      listenable: scope.eventsController.chaningEvent!,
      builder: (BuildContext context, Widget? child) {
        PositionedMonthTileData<T> arragnedEvent = monthEventLayout.arrangeEvent(
          scope.eventsController.chaningEvent!,
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
                child: scope.tileComponents.monthTileBuilder!(
                  arragnedEvent.event,
                  TileType.selected,
                  arragnedEvent.dateRange.start,
                  arragnedEvent.continuesBefore,
                  arragnedEvent.continuesAfter,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
