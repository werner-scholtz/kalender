import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/month_cell_header.dart';
import 'package:kalender/src/components/general/month_cell_scroll_view.dart';
import 'package:kalender/src/components/tile_stacks/month_tile_stack.dart';
import 'package:kalender/src/models/calendar/calendar_style.dart';
import 'package:kalender/src/models/tile_layout_controllers/month_tile_layout_controller.dart';
import 'package:kalender/src/providers/calendar_style.dart';

class MonthCellsStyle {
  const MonthCellsStyle({
    this.cellHeaderHeight,
  });

  final double? cellHeaderHeight;
}

class MonthCells<T> extends StatelessWidget {
  const MonthCells({
    super.key,
    required this.cellHeight,
    required this.cellWidth,
    required this.visibleDateRange,
    required this.pageWidth,
  });

  final DateTimeRange visibleDateRange;
  final double cellHeight;
  final double cellWidth;
  final double pageWidth;

  @override
  Widget build(BuildContext context) {
    CalendarStyle style = CalendarStyleProvider.of(context).style;

    return Stack(
      children: <Widget>[
        for (int c = 0; c < 5; c++)
          Positioned(
            top: c * cellHeight,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    for (int r = 0; r < 7; r++)
                      SizedBox(
                        width: cellWidth,
                        height: style.monthCellsStyle?.cellHeaderHeight ?? 32,
                        child: Center(
                          child: MonthCellHeader<T>(
                            date: visibleDateRange.start.add(Duration(days: (c * 7) + r)),
                          ),
                        ),
                      ),
                  ],
                ),
                Builder(
                  builder: (BuildContext context) {
                    DateTimeRange weekDateRange = DateTimeRange(
                      start: visibleDateRange.start.add(Duration(days: c * 7)),
                      end: visibleDateRange.start.add(Duration(days: (c * 7) + 7)),
                    );

                    return SizedBox(
                      width: pageWidth,
                      height: cellHeight - (style.monthCellsStyle?.cellHeaderHeight ?? 32),
                      child: MonthCellScrollView(
                        child: PositionedMonthTileStack<T>(
                          pageWidth: pageWidth,
                          cellWidth: cellWidth,
                          cellHeight: cellHeight - (style.monthCellsStyle?.cellHeaderHeight ?? 32),
                          visibleDateRange: weekDateRange,
                          monthVisibleDateRange: visibleDateRange,
                          monthEventLayout: MonthLayoutController<T>(
                            visibleDateRange: weekDateRange,
                            cellWidth: cellWidth,
                            tileHeight: 24,
                            isMobileDevice: false,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
