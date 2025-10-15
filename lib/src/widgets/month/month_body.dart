import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/multi_day_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';

/// This widget is used to display a month body.
///
/// The month body's content:
///   - Dynamic content such as the [PageView] which renders [MultiDayEventWidget], [MultiDayDragTarget], [MultiDayDraggable].
class MonthBody<T extends Object?> extends StatelessWidget {
  /// The [MultiDayBodyConfiguration] that will be used by the [MonthBody].
  final MultiDayHeaderConfiguration<T>? configuration;

  /// Creates a new [MonthBody].
  const MonthBody({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController<T>();

    assert(
      calendarController.viewController is MonthViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    if (configuration is MonthBodyConfiguration<T>) {
      debugPrint('Warning: The configuration provided to the $MonthBody is not a $MonthBodyConfiguration.');
    }

    final viewController = calendarController.viewController as MonthViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final bodyConfiguration = configuration ?? MultiDayHeaderConfiguration();
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    return PageView.builder(
      controller: viewController.pageController,
      itemCount: pageNavigation.numberOfPages,
      allowImplicitScrolling: true,
      onPageChanged: (index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
        viewController.visibleDateTimeRange.value = visibleRange;
        context.callbacks<T>()?.onPageChanged?.call(visibleRange);
      },
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
        final numberOfRows = pageNavigation.numberOfRowsForRange(visibleRange);
        return Stack(
          children: [
            Positioned.fill(child: MonthGrid.fromContext<T>(context, numberOfRows)),
            Positioned.fill(
              child: Column(
                children: List.generate(
                  numberOfRows,
                  (index) {
                    final start = visibleRange.start.addDays(index * 7);
                    final visibleDateTimeRange = DateTimeRange(start: start, end: start.addDays(7));
                    return Expanded(
                      child: MonthWeek<T>(
                        visibleDateTimeRange: visibleDateTimeRange,
                        bodyConfiguration: bodyConfiguration,
                      ),
                    );
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

class MonthWeek<T> extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;
  final MultiDayHeaderConfiguration<T> bodyConfiguration;
  const MonthWeek({
    super.key,
    required this.visibleDateTimeRange,
    required this.bodyConfiguration,
  });

  @override
  Widget build(BuildContext context) {
    final components = context.components<T>();
    final eventController = context.eventsController<T>();
    return Stack(
      children: [
        Positioned.fill(child: MultiDayDraggable<T>(visibleDateTimeRange: visibleDateTimeRange)),
        Positioned.fill(
          child: Column(
            children: [
              WeekDayHeaders<T>(dates: visibleDateTimeRange.dates()),
              MultiDayEventWidget(
                eventsController: eventController,
                visibleDateTimeRange: visibleDateTimeRange,
                configuration: bodyConfiguration,
                maxNumberOfRows: 1,
                overlayBuilders:
                    components?.monthComponents?.bodyComponents?.overlayBuilders ?? components?.overlayBuilders,
                overlayStyles: components?.monthComponentStyles?.bodyStyles?.overlayStyles ?? components?.overlayStyles,
                includeDayEvents: true,
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: MultiDayDragTarget<T>(
            pageTriggerSetup: bodyConfiguration.pageTriggerConfiguration,
            visibleDateTimeRange: visibleDateTimeRange,
            tileHeight: bodyConfiguration.tileHeight,
            allowSingleDayEvents: true,
            leftPageTrigger: components?.monthComponents?.bodyComponents?.leftTriggerBuilder,
            rightPageTrigger: components?.monthComponents?.bodyComponents?.rightTriggerBuilder,
          ),
        ),
      ],
    );
  }
}

class WeekDayHeaders<T> extends StatelessWidget {
  final List<DateTime> dates;
  const WeekDayHeaders({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: dates.map((date) => MonthDayHeader.fromContext<T>(context, date)).toList(),
    );
  }
}
