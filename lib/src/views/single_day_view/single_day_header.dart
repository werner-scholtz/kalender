import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/material_header/material_header.dart';
import 'package:kalender/src/components/tile_stacks/multi_day_tile_stack.dart';
import 'package:kalender/src/models/view_configurations/view_configuration_export.dart';
import 'package:kalender/src/providers/calendar_scope.dart';

class SingleDayHeader<T> extends StatelessWidget {
  const SingleDayHeader({
    super.key,
    required this.dayWidth,
    required this.viewConfiguration,
  });

  final double dayWidth;
  final SingleDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    return CalendarHeaderBackground(
      child: ValueListenableBuilder<DateTimeRange>(
        valueListenable: scope.state.visibleDateTimeRangeNotifier,
        builder: (
          context,
          visibleDateTimeRange,
          child,
        ) {
          return Column(
            children: <Widget>[
              RepaintBoundary(
                child: scope.components.calendarHeaderBuilder?.call(
                  visibleDateTimeRange,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: viewConfiguration.timelineWidth,
                        child: scope.components.dayHeaderBuilder(
                          visibleDateTimeRange.start,
                          null,
                        ),
                      ),
                    ],
                  ),
                  MultiDayTileStack<T>(
                    pageWidth: dayWidth,
                    dayWidth: dayWidth,
                    multiDayEventLayout:
                        scope.layoutControllers.multiDayTileLayoutController(
                      dayWidth: dayWidth,
                      visibleDateRange: visibleDateTimeRange,
                      tileHeight: viewConfiguration.multidayTileHeight,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
