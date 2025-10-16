import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_header_layout.dart';

/// The multi-day header decides which header to display the:
/// - [_SingleDayHeader] this is used for a body that only displays a single day.
/// - [_MultiDayHeader] this is used for a body that displays multiple days.
/// - [_FreeScrollHeader] this is a special case for a body that scrolls freely (WIP/Not working)
///
/// All Header widgets make use of the [ExpandablePageView] which uses a [SizeReportingWidget]to set the the Height of the header, this is so they can resize dynamically.
class MultiDayHeader<T extends Object?> extends StatelessWidget {
  /// The [MultiDayHeaderConfiguration] that will be used by the [MultiDayHeader].
  final HorizontalConfiguration<T>? configuration;

  /// Creates a new [MultiDayHeader].
  const MultiDayHeader({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController<T>();
    assert(
      calendarController.viewController is MultiDayViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MultiDayViewController<$T>',
    );

    final viewController = calendarController.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final headerConfiguration = configuration ?? MultiDayHeaderConfiguration<T>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final header = switch (viewConfiguration.type) {
          MultiDayViewType.freeScroll => _FreeScrollHeader<T>(
              key: ValueKey(viewConfiguration.hashCode),
              viewController: viewController,
              configuration: headerConfiguration,
            ),
          MultiDayViewType.singleDay => _SingleDayHeader<T>(
              key: ValueKey(viewConfiguration.hashCode),
              viewController: viewController,
              configuration: headerConfiguration,
            ),
          _ => _MultiDayHeader<T>(
              key: ValueKey(viewConfiguration.hashCode),
              viewController: viewController,
              configuration: headerConfiguration,
            )
        };

        return Column(children: [header]);
      },
    );
  }
}

/// A header catered for displaying multi-day events for a single day body.
class _SingleDayHeader<T extends Object?> extends StatelessWidget {
  final MultiDayViewController<T> viewController;
  final HorizontalConfiguration<T> configuration;

  const _SingleDayHeader({
    super.key,
    required this.configuration,
    required this.viewController,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final components = context.components<T>();
    final headerComponents = components.multiDayComponents.headerComponents;
    final componentStyles = components.multiDayComponentStyles.headerStyles;

    final dayHeaderStyle = componentStyles.dayHeaderStyle;
    final dayHeaderWidget = ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, visibleRange, child) {
        return headerComponents.dayHeaderBuilder.call(visibleRange.start.asLocal, dayHeaderStyle);
      },
    );

    final pageView = ExpandablePageView(
      controller: viewController.headerController,
      itemCount: viewController.numberOfPages,
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);

        // Minimum constraints for the multiDayEvents.
        final constraints = BoxConstraints(minHeight: configuration.tileHeight * 2);
        final multiDayEvents = MultiDayEventWidget<T>(
          eventsController: context.eventsController<T>(),
          visibleDateTimeRange: visibleRange,
          configuration: configuration,
          overlayBuilders: headerComponents.overlayBuilders ?? components.overlayBuilders,
          overlayStyles: componentStyles.overlayStyles ?? components.overlayStyles,
        );

        final multiDayDragTarget = HorizontalDragTarget<T>(
          visibleDateTimeRange: visibleRange,
          configuration: configuration,
          leftPageTrigger: headerComponents.leftTriggerBuilder,
          rightPageTrigger: headerComponents.rightTriggerBuilder,
        );

        return Stack(
          children: [
            if (configuration.showTiles) ...[
              Positioned.fill(child: MultiDayDraggable<T>(visibleDateTimeRange: visibleRange)),
              ConstrainedBox(constraints: constraints, child: multiDayEvents),
              Positioned.fill(child: multiDayDragTarget),
            ] else
              ConstrainedBox(constraints: constraints, child: const SizedBox.shrink()),
          ],
        );
      },
    );

    return MultiDayHeaderWidget<T>(content: pageView, leading: dayHeaderWidget);
  }
}

/// A header catered for displaying multi-day events for a multi-day body.
class _MultiDayHeader<T extends Object?> extends StatelessWidget {
  final MultiDayViewController<T> viewController;
  final HorizontalConfiguration<T> configuration;

  const _MultiDayHeader({
    super.key,
    required this.configuration,
    required this.viewController,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final components = context.components<T>();
    final headerComponents = components.multiDayComponents.headerComponents;
    final componentStyles = components.multiDayComponentStyles.headerStyles;

    final weekNumberStyle = componentStyles.weekNumberStyle;
    final weekNumberWidget = ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, value, child) {
        return headerComponents.weekNumberBuilder.call(value, weekNumberStyle);
      },
    );

    final pageView = ExpandablePageView(
      controller: viewController.headerController,
      itemCount: viewController.numberOfPages,
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
        final visibleDates = visibleRange.dates();

        final multiDayEvents = MultiDayEventWidget<T>(
          eventsController: context.eventsController<T>(),
          visibleDateTimeRange: visibleRange,
          configuration: configuration,
          overlayBuilders: headerComponents.overlayBuilders ?? components.overlayBuilders,
          overlayStyles: componentStyles.overlayStyles ?? components.overlayStyles,
        );

        final multiDayDragTarget = HorizontalDragTarget<T>(
          visibleDateTimeRange: visibleRange,
          configuration: configuration,
          leftPageTrigger: headerComponents.leftTriggerBuilder,
          rightPageTrigger: headerComponents.rightTriggerBuilder,
        );

        return Column(
          children: [
            DayHeaders<T>(
              viewConfiguration: viewConfiguration,
              visibleDates: visibleDates,
              headerComponents: headerComponents,
              componentStyles: componentStyles,
            ),
            if (configuration.showTiles)
              IntrinsicHeight(
                child: Stack(
                  children: [
                    Positioned.fill(child: MultiDayDraggable<T>(visibleDateTimeRange: visibleRange)),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: configuration.tileHeight),
                      child: multiDayEvents,
                    ),
                    Positioned.fill(child: multiDayDragTarget),
                  ],
                ),
              ),
          ],
        );
      },
    );

    return MultiDayHeaderWidget<T>(content: pageView, leading: weekNumberWidget);
  }
}

/// TODO: Fix and Ensure this works.
class _FreeScrollHeader<T extends Object?> extends StatelessWidget {
  final MultiDayViewController<T> viewController;
  final HorizontalConfiguration<T> configuration;

  const _FreeScrollHeader({
    super.key,
    required this.viewController,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final components = context.components<T>();
    final headerComponents = components.multiDayComponents.headerComponents;
    final componentStyles = components.multiDayComponentStyles.headerStyles;

    final weekNumberWidget = ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, value, child) {
        return headerComponents.weekNumberBuilder.call(value, componentStyles.weekNumberStyle);
      },
    );

    final pageView = ExpandablePageView(
      controller: viewController.headerController,
      itemCount: viewController.numberOfPages,
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
        final visibleDates = visibleRange.dates();

        final multiDayEvents = MultiDayEventWidget<T>(
          eventsController: context.eventsController<T>(),
          visibleDateTimeRange: visibleRange,
          configuration: configuration,
          overlayBuilders: headerComponents.overlayBuilders ?? components.overlayBuilders,
          overlayStyles: componentStyles.overlayStyles ?? components.overlayStyles,
        );

        final multiDayDragTarget = HorizontalDragTarget<T>(
          visibleDateTimeRange: visibleRange,
          configuration: configuration,
          leftPageTrigger: headerComponents.leftTriggerBuilder,
          rightPageTrigger: headerComponents.rightTriggerBuilder,
        );

        return Column(
          children: [
            DayHeaders<T>(
              viewConfiguration: viewConfiguration,
              visibleDates: visibleDates,
              headerComponents: headerComponents,
              componentStyles: componentStyles,
            ),
            if (configuration.showTiles)
              Stack(
                children: [
                  Positioned.fill(child: MultiDayDraggable<T>(visibleDateTimeRange: visibleRange)),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: configuration.tileHeight),
                    child: multiDayEvents,
                  ),
                  Positioned.fill(child: multiDayDragTarget),
                ],
              ),
          ],
        );
      },
    );

    return MultiDayHeaderWidget<T>(content: pageView, leading: weekNumberWidget);
  }
}

class DayHeaders<T extends Object?> extends StatelessWidget {
  const DayHeaders({
    super.key,
    required this.viewConfiguration,
    required this.visibleDates,
    required this.headerComponents,
    required this.componentStyles,
  });

  final MultiDayViewConfiguration viewConfiguration;
  final List<DateTime> visibleDates;
  final MultiDayHeaderComponents<T> headerComponents;
  final MultiDayHeaderComponentStyles componentStyles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final dayWidth = pageWidth / viewConfiguration.numberOfDays;
        final dayHeaders = visibleDates.map((date) {
          final dayHeader = headerComponents.dayHeaderBuilder.call(
            date.asLocal,
            componentStyles.dayHeaderStyle,
          );
          return SizedBox(width: dayWidth, child: dayHeader);
        }).toList();
        return Row(children: [...dayHeaders]);
      },
    );
  }
}
