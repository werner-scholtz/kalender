import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/internal_components/month_week_number_gutter.dart';

/// The month header is a simple widget that just displays the day names.
class MonthHeader extends StatelessWidget {
  /// Creates a new [MonthHeader].
  const MonthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController;

    assert(
      calendarController.viewController is MonthViewController,
      'The CalendarController\'s $ViewController needs to be a $MonthViewController',
    );

    // final viewController = calendarController.viewController as MonthViewController;
    final viewController = calendarController.viewController as MonthViewController;
    final viewConfiguration = viewController.viewConfiguration;
    final calendarComponents = context.components;
    final bodyStyles = calendarComponents.monthComponentStyles.bodyStyles;
    final bodyComponents = calendarComponents.monthComponents.bodyComponents;
    final styles = calendarComponents.monthComponentStyles.headerStyles;
    final components = calendarComponents.monthComponents.headerComponents;

    return ValueListenableBuilder(
      valueListenable: calendarController.visibleDateTimeRange,
      builder: (context, visibleDateTimeRange, child) {
        if (visibleDateTimeRange == null) {
          debugPrint('Warning: The visibleDateTimeRange is null in MonthHeader.');
          return const SizedBox.shrink();
        }
        final internalVisibleRange = InternalDateTimeRange.fromDateTimeRange(visibleDateTimeRange);
        final style = styles.weekDayHeaderStyle;
        final showWeekNumbers = viewConfiguration.showWeekNumbers;
        final numberOfRows = viewConfiguration.pageIndexCalculator.numberOfRowsForRange(internalVisibleRange);

        return Row(
          children: [
            if (showWeekNumbers)
              MonthWeekNumberSpacer(
                visibleRange: internalVisibleRange,
                numberOfRows: numberOfRows,
                weekNumberBuilder: bodyComponents.weekNumberBuilder,
                weekNumberStyle: bodyStyles.weekNumberStyle,
              ),
            Expanded(
              child: Row(
                children: List<Widget>.generate(
                  7,
                  (index) {
                    final date = visibleDateTimeRange.start.add(Duration(days: index));
                    return Expanded(child: components.weekDayHeaderBuilder.call(date, style));
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
