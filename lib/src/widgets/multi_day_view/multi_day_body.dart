import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/controllers/view_controller.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/models/providers/multi_day_body_provider.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_drag_target.dart';
import 'package:kalender/src/widgets/multi_day_view/multi_day_page_view.dart';

/// This widget is used to display a multi-day body.
class MultiDayBody<T extends Object?> extends StatelessWidget {
  /// The [EventsController] that will be used by the [MultiDayBody].
  final EventsController<T>? eventsController;

  /// The [CalendarController] that will be used by the [MultiDayBody].
  final CalendarController<T>? calendarController;

  /// The callbacks used by the [MultiDayBody].
  final CalendarCallbacks<T>? callbacks;

  /// The components used by the [MultiDayBody].
  final DayTileComponents<T> tileComponents;

  /// The components used by the [MultiDayBody].
  final MultiDayBodyComponents? components;

  /// The styles of the components.
  final MultiDayBodyComponentStyles? componentStyles;

  /// The [ValueNotifier] containing the [heightPerMinute] value.
  final ValueNotifier<double>? heightPerMinute;

  /// The [ScrollController] used by the scrollable body.
  final ScrollController? scrollController;

  /// The [ScrollPhysics] used by the scrollable body.
  final ScrollPhysics? scrollPhysics;

  /// The [ScrollPhysics] used by the page view.
  final ScrollPhysics? pageScrollPhysics;

  const MultiDayBody({
    super.key,
    this.eventsController,
    this.calendarController,
    this.callbacks,
    required this.tileComponents,
    this.components,
    this.componentStyles,
    this.scrollController,
    this.heightPerMinute,
    this.scrollPhysics,
    this.pageScrollPhysics,
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
        'The eventsController needs to be provided when the $MultiDayBody<$T> is not wrapped in a $CalendarProvider<$T>.',
      );
      assert(
        calendarController != null,
        'The calendarController needs to be provided when the $MultiDayBody<$T> is not wrapped in a $CalendarProvider<$T>.',
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
      calendarController!.viewController is MultiDayViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MultiDayViewController<$T>',
    );

    final viewController =
        calendarController!.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the width of the page.
        final timelineWidth = viewConfiguration.timelineWidth;
        final pageWidth = constraints.maxWidth - timelineWidth;

        // Calculate the width of a single day.
        final numberOfDays = viewConfiguration.numberOfDays;
        final dayWidth = pageWidth / numberOfDays;

        final viewPortHeight = constraints.maxHeight;

        return ValueListenableBuilder(
          valueListenable: viewController.heightPerMinute,
          builder: (context, heightPerMinute, child) {
            // Calculate the height of the page.
            final dayDuration = viewConfiguration.timeOfDayRange.duration;
            final pageHeight = heightPerMinute * dayDuration.inMinutes;

            final hourLines = components?.hourLines?.call(
                  heightPerMinute,
                  viewConfiguration.timeOfDayRange,
                  componentStyles?.hourLinesStyle,
                ) ??
                HourLines(
                  timeOfDayRange: viewConfiguration.timeOfDayRange,
                  heightPerMinute: heightPerMinute,
                  style: componentStyles?.hourLinesStyle,
                );

            final timeline = components?.timeline?.call(
                  heightPerMinute,
                  viewConfiguration.timeOfDayRange,
                  componentStyles?.timelineStyle,
                ) ??
                TimeLine(
                  timeOfDayRange: viewConfiguration.timeOfDayRange,
                  heightPerMinute: heightPerMinute,
                  style: componentStyles?.timelineStyle,
                  eventBeingDragged: viewController.eventBeingDragged,
                );

            final pageView = MultiDayPageView(
              eventsController: eventsController!,
              calendarController: calendarController!,
              eventBeingDragged: viewController.eventBeingDragged,
              tileComponents: tileComponents,
              callbacks: callbacks,
            );

            final dragTarget = MultiDayDragTarget(
              eventsController: eventsController,
              viewController: viewController,
              eventBeingDragged: viewController.eventBeingDragged,
              callbacks: callbacks,
            );

            return MultiDayBodyProvider(
              viewController: viewController,
              feedbackWidgetSize: eventsController.feedbackWidgetSize,
              pageScrollPhysics: pageScrollPhysics,
              viewportHeight: viewPortHeight,
              pageWidth: pageWidth,
              dayWidth: dayWidth,
              components: components,
              componentStyles: componentStyles,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Scrollbar(
                      controller: viewController.scrollController,
                      child: SingleChildScrollView(
                        controller: viewController.scrollController,
                        physics: scrollPhysics,
                        child: SizedBox(
                          height: pageHeight,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                width: 56.0,
                                child: timeline,
                              ),
                              Positioned.fill(child: hourLines),
                              Positioned.fill(child: pageView),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: timelineWidth,
                    height: min(pageHeight, viewPortHeight),
                    child: dragTarget,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
