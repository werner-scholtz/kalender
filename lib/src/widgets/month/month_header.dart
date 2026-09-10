import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
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
      'The KalenderController\'s $ViewController needs to be a $MonthViewController',
    );

    // final viewController = calendarController.viewController as MonthViewController;
    final viewController = calendarController.viewController as MonthViewController;
    final viewConfiguration = viewController.viewConfiguration;
    final calendarComponents = context.components;
    final components = calendarComponents.monthComponents.headerComponents;

    return ValueListenableBuilder(
      valueListenable: calendarController.visibleDateTimeRange,
      builder: (context, visibleDateTimeRange, child) {
        if (visibleDateTimeRange == null) {
          debugPrint('Warning: The visibleDateTimeRange is null in MonthHeader.');
          return const SizedBox.shrink();
        }
        final showWeekNumbers = viewConfiguration.showWeekNumbers;

        return Row(
          children: [
            if (showWeekNumbers) const MonthWeekNumberSpacer(),
            Expanded(
              child: Row(
                children: List<Widget>.generate(
                  7,
                  (index) {
                    final date = visibleDateTimeRange.start.add(Duration(days: index));
                    return Expanded(child: components.buildWeekDayHeader(context, date));
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
