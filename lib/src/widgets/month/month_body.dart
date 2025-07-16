import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/multi_day_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';

/// This widget is used to display a month body.
///
/// The month body's content:
///   - Static content [MonthGrid].
///   - Dynamic content such as the [PageView] which renders [MultiDayEventWidget], [MultiDayDragTarget], [MultiDayEventDraggableWidgets].
class MonthBody<T extends Object?> extends StatelessWidget {
  /// The [MultiDayBodyConfiguration] that will be used by the [MonthBody].
  final MultiDayHeaderConfiguration<T>? configuration;

  /// Creates a new [MonthBody].
  const MonthBody({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final provider = context.provider<T>();
    final eventsController = provider.eventsController;
    final calendarController = provider.calendarController;

    final bodyProvider = context.bodyProvider<T>();
    final callbacks = bodyProvider.callbacks;

    assert(
      calendarController.viewController is MonthViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    if (configuration is MonthBodyConfiguration<T>) {
      debugPrint('Warning: The configuration provided to the $MonthBody is not a $MonthBodyConfiguration.');
    }

    final viewController = calendarController.viewController as MonthViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final bodyConfiguration = this.configuration ?? MultiDayHeaderConfiguration();
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final pageTriggerConfiguration = bodyConfiguration.pageTriggerConfiguration;
    final tileHeight = bodyConfiguration.tileHeight;

    final calendarComponents = provider.components;
    final styles = calendarComponents?.monthComponentStyles?.bodyStyles;
    final components = calendarComponents?.monthComponents?.bodyComponents ?? MonthBodyComponents<T>();
    final tileComponents = bodyProvider.tileComponents;
    final interaction = bodyProvider.interaction;

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
            callbacks?.onPageChanged?.call(visibleRange);
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

                final multiDayDragTarget = MultiDayDragTarget<T>(
                  eventsController: eventsController,
                  calendarController: calendarController,
                  callbacks: callbacks,
                  tileComponents: tileComponents,
                  pageTriggerSetup: pageTriggerConfiguration,
                  visibleDateTimeRange: visibleDateTimeRange,
                  dayWidth: dayWidth,
                  pageWidth: pageWidth,
                  tileHeight: tileHeight,
                  allowSingleDayEvents: true,
                  leftPageTrigger: components.leftTriggerBuilder,
                  rightPageTrigger: components.rightTriggerBuilder,
                );

                final draggable = MultiDayEventDraggableWidgets<T>(
                  eventsController: eventsController,
                  controller: calendarController,
                  callbacks: callbacks,
                  visibleDateTimeRange: visibleDateTimeRange,
                  dayWidth: dayWidth,
                  interaction: interaction,
                );

                final dates = List.generate(7, (index) {
                  final date = visibleDateTimeRange.start.addDays(index);
                  final monthDayHeaderStyle = styles?.monthDayHeaderStyle;
                  final monthDayHeder = components.monthDayHeaderBuilder.call(date, monthDayHeaderStyle);
                  return monthDayHeder;
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
                                    controller: calendarController,
                                    eventsController: eventsController,
                                    visibleDateTimeRange: visibleDateTimeRange,
                                    tileComponents: tileComponents,
                                    dayWidth: dayWidth,
                                    interaction: interaction,
                                    tileHeight: bodyConfiguration.tileHeight,
                                    maxNumberOfRows: maxNumberOfVerticalEvents,
                                    showAllEvents: true,
                                    callbacks: callbacks,
                                    generateMultiDayLayoutFrame: configuration?.generateMultiDayLayoutFrame,
                                    overlayBuilders: components.overlayBuilders ?? calendarComponents?.overlayBuilders,
                                    overlayStyles: styles?.overlayStyles ?? calendarComponents?.overlayStyles,
                                    eventPadding: bodyConfiguration.eventPadding,
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

            final monthGridStyle = styles?.monthGridStyle;
            final monthGrid = components.monthGridBuilder.call(monthGridStyle, numberOfRows);

            return SizedBox(
              width: pageWidth,
              height: pageHeight,
              child: Stack(
                children: [
                  Positioned.fill(child: monthGrid),
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
