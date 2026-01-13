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
class MonthBody extends StatelessWidget {
  /// The [MultiDayBodyConfiguration] that will be used by the [MonthBody].
  final HorizontalConfiguration? configuration;

  /// Creates a new [MonthBody].
  const MonthBody({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController();

    assert(
      calendarController.viewController is MonthViewController,
      'The CalendarController\'s $ViewController needs to be a $MonthViewController',
    );

    if (this.configuration is! MonthBodyConfiguration) {
      debugPrint('Warning: The configuration provided to the $MonthBody is not a $MonthBodyConfiguration.');
    }

    final viewController = calendarController.viewController as MonthViewController;
    final viewConfiguration = viewController.viewConfiguration;
    final configuration = this.configuration ?? MonthBodyConfiguration();
    final pageNavigation = viewConfiguration.pageIndexCalculator;

    return PageView.builder(
      controller: viewController.pageController,
      itemCount: pageNavigation.numberOfPages(context.location),
      onPageChanged: (index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index, context.location);
        final controller = context.calendarController();
        controller.internalDateTimeRange.value = visibleRange;
        context.callbacks()?.onPageChanged?.call(controller.visibleDateTimeRange.value!);
      },
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index, context.location);
        final numberOfRows = pageNavigation.numberOfRowsForRange(visibleRange);

        return Stack(
          children: [
            Positioned.fill(child: MonthGrid.fromContext(context, numberOfRows)),
            Positioned.fill(
              child: Column(
                children: List.generate(
                  numberOfRows,
                  (index) {
                    final start = visibleRange.start.addDays(index * 7);
                    final visibleDateTimeRange = InternalDateTimeRange(start: start, end: start.addDays(7));

                    return Expanded(
                      child: MonthWeek(
                        key: ValueKey('MonthWeek-${visibleDateTimeRange.start.toIso8601String()}'),
                        internalRange: visibleDateTimeRange,
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
class MonthWeek extends StatelessWidget {
  final InternalDateTimeRange internalRange;
  final HorizontalConfiguration configuration;
  final ViewController viewController;
  const MonthWeek({
    super.key,
    required this.internalRange,
    required this.configuration,
    required this.viewController,
  });

  @override
  Widget build(BuildContext context) {
    final components = context.components();
    final monthComponents = components.monthComponents;

    return Stack(
      children: [
        Positioned.fill(
          child: MultiDayDraggable(
            key: ValueKey('MultiDayDraggable-${internalRange.start.toIso8601String()}'),
            internalRange: internalRange,
          ),
        ),
        Positioned.fill(
          child: Column(
            children: [
              WeekDayHeaders(
                dates: internalRange.dates(),
                dayHeaderBuilder: MonthDayHeader.fromContext,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Subtract 1 to account for the extra widget at the bottom.
                    final maxNumberOfVerticalEvents = (constraints.maxHeight / configuration.tileHeight).floor() - 1;

                    return MultiDayEventWidget(
                      eventsController: context.eventsController(),
                      internalDateTimeRange: internalRange,
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
          child: HorizontalDragTarget(
            visibleDateTimeRange: internalRange,
            configuration: configuration,
            leftPageTrigger: components.monthComponents.bodyComponents.leftTriggerBuilder,
            rightPageTrigger: components.monthComponents.bodyComponents.rightTriggerBuilder,
          ),
        ),
      ],
    );
  }
}
