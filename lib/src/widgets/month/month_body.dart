import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/calendar_interaction.dart';
import 'package:kalender/src/widgets/drag_targets/multi_day_drag_target.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';

/// This widget is used to display a month body.
///
/// The month body's content:
///   - Static content [MonthGrid].
///   - Dynamic content such as the [PageView] which renders [MultiDayEventWidget], [MultiDayDragTarget], [MultiDayEventDraggableWidgets].
class MonthBody<T extends Object?> extends StatelessWidget {
  /// The [EventsController] that will be used by the [MonthBody].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [MonthBody].
  final CalendarController<T>? calendarController;

  /// The [MultiDayBodyConfiguration] that will be used by the [MonthBody].
  final MultiDayHeaderConfiguration? configuration;

  /// The callbacks used by the [MonthBody].
  final CalendarCallbacks<T>? callbacks;

  /// The tile components used by the [MonthBody].
  final TileComponents<T> tileComponents;

  /// The [CalendarInteraction] that will be used by the [MonthBody].
  final ValueNotifier<CalendarInteraction>? interaction;

  /// Creates a new [MonthBody].
  const MonthBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.tileComponents,
    this.configuration,
    required this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    var eventsController = this.eventsController;
    var calendarController = this.calendarController;
    var callbacks = this.callbacks;

    final provider = CalendarProvider.maybeOf<T>(context);
    if (provider == null) {
      assert(
        eventsController != null,
        'The eventsController needs to be provided when the $MonthBody<$T> is not wrapped in a $CalendarProvider<$T>.',
      );
      assert(
        calendarController != null,
        'The calendarController needs to be provided when the $MonthBody<$T> is not wrapped in a $CalendarProvider<$T>.',
      );
    } else {
      eventsController ??= provider.eventsController;
      calendarController ??= provider.calendarController;
      callbacks ??= provider.callbacks;
    }

    assert(
      calendarController!.isAttached,
      'The CalendarController needs to be attached to a $ViewController<$T>.',
    );

    assert(
      calendarController!.viewController is MonthViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MonthViewController<$T>',
    );

    final viewController = calendarController!.viewController as MonthViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final bodyConfiguration = this.configuration ?? MultiDayHeaderConfiguration();
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final pageTriggerConfiguration = bodyConfiguration.pageTriggerConfiguration;
    final tileHeight = bodyConfiguration.tileHeight;

    final calendarComponents = provider?.components;
    final styles = calendarComponents?.monthComponentStyles?.bodyStyles;
    final components = calendarComponents?.monthComponents?.bodyComponents;

    final interaction = this.interaction ?? ValueNotifier(CalendarInteraction());

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final pageHeight = constraints.maxHeight;

        // Calculate the width of a single day.
        final dayWidth = pageWidth / DateTime.daysPerWeek;
        final weekHeight = pageHeight / 5;

        final pageView = PageView.builder(
          controller: viewController.pageController,
          itemCount: pageNavigation.numberOfPages,
          onPageChanged: (index) {
            final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
            viewController.visibleDateTimeRange.value = visibleRange;
            callbacks?.onPageChanged?.call(visibleRange);
          },
          itemBuilder: (context, index) {
            final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);

            final multiDayEvents = List.generate(
              5,
              (index) {
                final visibleDateTimeRange = DateTimeRange(
                  start: visibleRange.start.addDays(index * 7),
                  end: visibleRange.start.addDays((index * 7) + 7),
                );

                final multiDayEvents = MultiDayEventWidget<T>(
                  controller: calendarController!,
                  eventsController: eventsController!,
                  visibleDateTimeRange: visibleDateTimeRange,
                  tileComponents: tileComponents,
                  dayWidth: dayWidth,
                  interaction: interaction,
                  tileHeight: tileHeight,
                  showAllEvents: true,
                  callbacks: callbacks,
                  layoutStrategy: bodyConfiguration.eventLayoutStrategy,
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
                  leftPageTrigger: components?.leftTriggerBuilder,
                  rightPageTrigger: components?.rightTriggerBuilder,
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
                  final monthDayHeder = components?.monthDayHeaderBuilder?.call(date, monthDayHeaderStyle) ??
                      MonthDayHeader(date: date, style: monthDayHeaderStyle);

                  return monthDayHeder;
                });

                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: dates,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              Positioned.fill(child: draggable),
                              ConstrainedBox(
                                constraints: BoxConstraints(minHeight: weekHeight - 32),
                                child: multiDayEvents,
                              ),
                              Positioned.fill(child: multiDayDragTarget),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );

            return Column(children: multiDayEvents);
          },
        );

        final monthGridStyle = styles?.monthGridStyle;
        final monthGrid = components?.monthGridBuilder?.call(monthGridStyle) ?? MonthGrid(style: monthGridStyle);

        return SizedBox(
          width: pageWidth,
          height: pageHeight,
          child: Stack(
            children: [
              Positioned.fill(child: monthGrid),
              Positioned.fill(child: pageView),
            ],
          ),
        );
      },
    );
  }
}
