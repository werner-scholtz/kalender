import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart';

/// This widget is used to display a month body.
///
/// The month body's content:
///   - Static content [MonthGrid].
///   - Dynamic content such as the [PageView] which renders [MultiDayEventWidget], [HorizontalDragTarget], [MultiDayDraggable].
class MonthBody<T extends Object?> extends StatelessWidget {
  /// The [MultiDayBodyConfiguration] that will be used by the [MonthBody].
  final HorizontalConfiguration<T>? configuration;

  /// Creates a new [MonthBody].
  const MonthBody({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController<T>();

    assert(
      calendarController.viewController is MonthViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    if (this.configuration is! MonthBodyConfiguration<T>) {
      debugPrint('Warning: The configuration provided to the $MonthBody is not a $MonthBodyConfiguration.');
    }

    final viewController = calendarController.viewController as MonthViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final configuration = this.configuration ?? MonthBodyConfiguration();
    final pageNavigation = viewConfiguration.pageNavigationFunctions;

    return PageView.builder(
      controller: viewController.pageController,
      itemCount: pageNavigation.numberOfPages,
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
                        key: ValueKey('MonthWeek-${visibleDateTimeRange.start.toIso8601String()}'),
                        visibleDateTimeRange: visibleDateTimeRange,
                        configuration: configuration,
                        viewController: viewController,
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

/// A single week in the month view.
///
/// It contains the [WeekDayHeaders], the [MultiDayEventWidget], the [HorizontalDragTarget] and the [MultiDayDraggable].
class MonthWeek<T extends Object?> extends StatelessWidget {
  final DateTimeRange visibleDateTimeRange;
  final HorizontalConfiguration<T> configuration;
  final ViewController<T> viewController;
  const MonthWeek({
    super.key,
    required this.visibleDateTimeRange,
    required this.configuration,
    required this.viewController,
  });

  @override
  Widget build(BuildContext context) {
    final components = context.components<T>();
    final monthComponents = components.monthComponents;

    return Stack(
      children: [
        Positioned.fill(
          child: MultiDayDraggable<T>(
            key: ValueKey('MultiDayDraggable-${visibleDateTimeRange.start.toIso8601String()}'),
            visibleDateTimeRange: visibleDateTimeRange,
          ),
        ),
        Positioned.fill(
          child: Column(
            children: [
              WeekDayHeaders<T>(
                dates: visibleDateTimeRange.dates(),
                dayHeaderBuilder: MonthDayHeader.fromContext<T>,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Subtract 1 to account for the extra widget at the bottom.
                    final maxNumberOfVerticalEvents = (constraints.maxHeight / configuration.tileHeight).floor() - 1;

                    return MultiDayEventWidget<T>(
                      visibleDateTimeRange: visibleDateTimeRange,
                      configuration: configuration,
                      maxNumberOfVerticalEvents: maxNumberOfVerticalEvents,
                      multiDayCache: viewController.multiDayCache,
                      overlayBuilders: components.overlayBuilders ?? monthComponents.bodyComponents.overlayBuilders,
                      overlayStyles:
                          components.overlayStyles ?? components.monthComponentStyles.bodyStyles.overlayStyles,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: HorizontalDragTarget<T>(
            visibleDateTimeRange: visibleDateTimeRange,
            configuration: configuration,
            leftPageTrigger: components.monthComponents.bodyComponents.leftTriggerBuilder,
            rightPageTrigger: components.monthComponents.bodyComponents.rightTriggerBuilder,
          ),
        ),
      ],
    );
  }
}
