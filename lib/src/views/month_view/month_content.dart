import 'package:flutter/material.dart';
import 'package:kalender/src/components/general/date_icon_button.dart';
import 'package:kalender/src/components/general/month_cell.dart';
import 'package:kalender/src/components/tile_stacks/month_cell_stack.dart';
import 'package:kalender/src/models/calendar/calendar_model_export.dart';
import 'package:kalender/src/models/view_configurations/view_confiuration_export.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class MonthContent<T extends Object?> extends StatelessWidget {
  const MonthContent({
    super.key,
    required this.viewConfiguration,
    required this.cellWidth,
  });

  final MonthViewConfiguration viewConfiguration;

  final double cellWidth;

  @override
  Widget build(BuildContext context) {
    CalendarInternals<T> internals = CalendarInternals.of<T>(context);
    CalendarComponents<T> components = internals.components;
    CalendarFunctions<T> functions = internals.functions;
    CalendarState state = internals.state;
    CalendarConfiguration configuration = internals.configuration;

    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double cellHeight = constraints.maxHeight / 6;

          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: PageView.builder(
              key: Key(viewConfiguration.name),
              controller: state.pageController,
              itemCount: state.itemCount,
              onPageChanged: functions.onPageChanged,
              itemBuilder: (BuildContext context, int index) {
                DateTimeRange visibleDateRange =
                    viewConfiguration.calculateVisibleDateRangeForIndex(
                  index,
                  state.dateTimeRange.start,
                  configuration.firstDayOfWeek,
                );

                return GridView.builder(
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: cellWidth / cellHeight,
                  ),
                  itemCount: 42,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    DateTime date = visibleDateRange.start.add(Duration(days: index));
                    return MonthCell<T>(
                      child: Column(
                        children: <Widget>[
                          DateIconButton(
                            date: date,
                            onTapped: (DateTime date) => functions.onDateTapped?.call(date),
                            visualDensity: VisualDensity.compact,
                          ),
                          Expanded(
                            child: MonthCellStack<T>(
                              viewConfiguration: viewConfiguration,
                              date: date,
                              cellHeight: cellHeight,
                              cellWidth: cellWidth,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
