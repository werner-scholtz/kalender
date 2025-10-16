import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';

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

    if (configuration is MonthBodyConfiguration<T>) {
      debugPrint('Warning: The configuration provided to the $MonthBody is not a $MonthBodyConfiguration.');
    }

    final viewController = calendarController.viewController as MonthViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final bodyConfiguration = configuration ?? MonthBodyConfiguration();
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final pageTriggerConfiguration = bodyConfiguration.pageTriggerConfiguration;
    final tileHeight = bodyConfiguration.tileHeight;

    final calendarComponents = context.components<T>();
    final styles = calendarComponents.monthComponentStyles.bodyStyles;
    final components = calendarComponents.monthComponents.bodyComponents;

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final pageHeight = constraints.maxHeight;

        // Calculate the width of a single day.
        final dayWidth = pageWidth / DateTime.daysPerWeek;

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
            final weekHeight = pageHeight / numberOfRows;

            final multiDayEvents = List.generate(
              numberOfRows,
              (index) {
                final visibleDateTimeRange = DateTimeRange(
                  start: visibleRange.start.addDays(index * 7),
                  end: visibleRange.start.addDays((index * 7) + 7),
                );

                final multiDayDragTarget = HorizontalDragTarget<T>(
                  pageTriggerSetup: pageTriggerConfiguration,
                  visibleDateTimeRange: visibleDateTimeRange,
                  dayWidth: dayWidth,
                  pageWidth: pageWidth,
                  tileHeight: tileHeight,
                  configuration: bodyConfiguration,
                  leftPageTrigger: components.leftTriggerBuilder,
                  rightPageTrigger: components.rightTriggerBuilder,
                );

                final draggable = MultiDayDraggable<T>(
                  visibleDateTimeRange: visibleDateTimeRange,
                );

                final dates = List.generate(7, (index) {
                  final date = visibleDateTimeRange.start.addDays(index);
                  return components.monthDayHeaderBuilder.call(date, styles.monthDayHeaderStyle);
                });

                return Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(child: draggable),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: weekHeight,
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: dates),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  // Subtract 1 to account for the extra widget at the bottom.
                                  final maxNumberOfVerticalEvents = (constraints.maxHeight / tileHeight).floor() - 1;
                                  return MultiDayEventWidget<T>(
                                    visibleDateTimeRange: visibleDateTimeRange,
                                    tileHeight: bodyConfiguration.tileHeight,
                                    maxNumberOfRows: maxNumberOfVerticalEvents,
                                    showAllEvents: true,
                                    generateMultiDayLayoutFrame: configuration?.generateMultiDayLayoutFrame,
                                    overlayBuilders: components.overlayBuilders ?? calendarComponents.overlayBuilders,
                                    overlayStyles: styles.overlayStyles,
                                    eventPadding: bodyConfiguration.eventPadding,
                                    multiDayCache: viewController.multiDayCache,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(child: multiDayDragTarget),
                    ],
                  ),
                );
              },
            );

            return SizedBox(
              width: pageWidth,
              height: pageHeight,
              child: Stack(
                children: [
                  Positioned.fill(child: components.monthGridBuilder.call(styles.monthGridStyle, numberOfRows)),
                  Positioned.fill(child: Column(children: multiDayEvents)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
