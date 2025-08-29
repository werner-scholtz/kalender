import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/multi_day_drag_target.dart';
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
  final MultiDayHeaderConfiguration<T>? configuration;

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
  final MultiDayHeaderConfiguration<T> configuration;

  const _SingleDayHeader({
    super.key,
    required this.configuration,
    required this.viewController,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final components = context.provider<T>().components;
    final headerComponents = components?.multiDayComponents?.headerComponents ?? MultiDayHeaderComponents<T>();
    final componentStyles = components?.multiDayComponentStyles?.headerStyles;

    final dayHeaderStyle = componentStyles?.dayHeaderStyle;
    final dayHeaderWidget = ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, visibleRange, child) {
        return headerComponents.dayHeaderBuilder.call(visibleRange.start.asLocal, dayHeaderStyle);
      },
    );

    final pageView = LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        return ExpandablePageView(
          controller: viewController.headerController,
          itemCount: viewController.numberOfPages,
          itemBuilder: (context, index) {
            final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);

            // Minimum constraints for the multiDayEvents.
            final constraints = BoxConstraints(minHeight: configuration.tileHeight * 2, minWidth: pageWidth);
            final multiDayEvents = MultiDayEventWidget<T>(
              visibleDateTimeRange: visibleRange,
              showAllEvents: false,
              tileHeight: configuration.tileHeight,
              maxNumberOfRows: configuration.maximumNumberOfVerticalEvents,
              generateMultiDayLayoutFrame: configuration.generateMultiDayLayoutFrame,
              eventPadding: configuration.eventPadding,
              overlayBuilders: headerComponents.overlayBuilders ?? components?.overlayBuilders,
              overlayStyles: componentStyles?.overlayStyles ?? components?.overlayStyles,
              multiDayCache: viewController.multiDayCache,
            );

            final multiDayDragTarget = MultiDayDragTarget<T>(
              pageTriggerSetup: configuration.pageTriggerConfiguration,
              visibleDateTimeRange: visibleRange,
              dayWidth: pageWidth,
              pageWidth: pageWidth,
              tileHeight: configuration.tileHeight,
              allowSingleDayEvents: false,
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
      },
    );

    return MultiDayHeaderWidget<T>(content: pageView, leading: dayHeaderWidget);
  }
}

/// A header catered for displaying multi-day events for a multi-day body.
class _MultiDayHeader<T extends Object?> extends StatelessWidget {
  final MultiDayViewController<T> viewController;
  final MultiDayHeaderConfiguration<T> configuration;

  const _MultiDayHeader({
    super.key,
    required this.configuration,
    required this.viewController,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final components = context.provider<T>().components;
    final headerComponents = components?.multiDayComponents?.headerComponents ?? MultiDayHeaderComponents<T>();
    final componentStyles = components?.multiDayComponentStyles?.headerStyles;

    final weekNumberStyle = componentStyles?.weekNumberStyle;
    final weekNumberWidget = ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, value, child) {
        return headerComponents.weekNumberBuilder.call(value, weekNumberStyle);
      },
    );

    final pageView = LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final dayWidth = pageWidth / viewConfiguration.numberOfDays;

        return ExpandablePageView(
          controller: viewController.headerController,
          itemCount: viewController.numberOfPages,
          itemBuilder: (context, index) {
            final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
            final visibleDates = visibleRange.dates();

            final dayHeaderStyle = componentStyles?.dayHeaderStyle;
            final dayHeaders = visibleDates.map((date) {
              final dayHeader = headerComponents.dayHeaderBuilder.call(date.asLocal, dayHeaderStyle);
              return SizedBox(width: dayWidth, child: dayHeader);
            }).toList();

            final constraints = BoxConstraints(minHeight: configuration.tileHeight, minWidth: pageWidth);
            final multiDayEvents = MultiDayEventWidget<T>(
              visibleDateTimeRange: visibleRange,
              showAllEvents: false,
              tileHeight: configuration.tileHeight,
              maxNumberOfRows: configuration.maximumNumberOfVerticalEvents,
              generateMultiDayLayoutFrame: configuration.generateMultiDayLayoutFrame,
              eventPadding: configuration.eventPadding,
              overlayBuilders: headerComponents.overlayBuilders ?? components?.overlayBuilders,
              overlayStyles: componentStyles?.overlayStyles ?? components?.overlayStyles,
              multiDayCache: viewController.multiDayCache,
            );

            final multiDayDragTarget = MultiDayDragTarget<T>(
              pageTriggerSetup: configuration.pageTriggerConfiguration,
              visibleDateTimeRange: visibleRange,
              dayWidth: dayWidth,
              pageWidth: pageWidth,
              tileHeight: configuration.tileHeight,
              allowSingleDayEvents: false,
              leftPageTrigger: headerComponents.leftTriggerBuilder,
              rightPageTrigger: headerComponents.rightTriggerBuilder,
            );

            return Column(
              children: [
                Row(children: [...dayHeaders]),
                if (configuration.showTiles)
                  Stack(
                    children: [
                      Positioned.fill(child: MultiDayDraggable<T>(visibleDateTimeRange: visibleRange)),
                      ConstrainedBox(constraints: constraints, child: multiDayEvents),
                      Positioned.fill(child: multiDayDragTarget),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );

    return MultiDayHeaderWidget<T>(content: pageView, leading: weekNumberWidget);
  }
}

/// TODO: Fix and Ensure this works.
class _FreeScrollHeader<T extends Object?> extends StatelessWidget {
  final MultiDayViewController<T> viewController;
  final MultiDayHeaderConfiguration<T> configuration;

  const _FreeScrollHeader({
    super.key,
    required this.viewController,
    required this.configuration,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
    final components = context.provider<T>().components;
    final headerComponents = components?.multiDayComponents?.headerComponents ?? MultiDayHeaderComponents<T>();
    final componentStyles = components?.multiDayComponentStyles?.headerStyles;

    final weekNumberStyle = componentStyles?.weekNumberStyle;
    final weekNumberWidget = ValueListenableBuilder(
      valueListenable: viewController.visibleDateTimeRange,
      builder: (context, value, child) {
        return headerComponents.weekNumberBuilder.call(value, weekNumberStyle);
      },
    );

    final pageView = LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final dayWidth = pageWidth / viewConfiguration.numberOfDays;

        /// TODO: figure out how to get multi-day events to work with FreeScroll.
        ///
        /// To do this the header would need to display a single page and not multiple. see viewport fraction.
        return ExpandablePageView(
          controller: viewController.headerController,
          itemCount: viewController.numberOfPages,
          itemBuilder: (context, index) {
            final visibleRange = pageNavigation.dateTimeRangeFromIndex(index);
            final visibleDates = visibleRange.dates();

            final dayHeaderStyle = componentStyles?.dayHeaderStyle;
            final dayHeaders = visibleDates.map((date) {
              final dayHeader = headerComponents.dayHeaderBuilder.call(date.asLocal, dayHeaderStyle);
              return SizedBox(width: dayWidth, child: dayHeader);
            }).toList();

            final multiDayEvents = MultiDayEventWidget<T>(
              visibleDateTimeRange: visibleRange,
              showAllEvents: false,
              tileHeight: configuration.tileHeight,
              maxNumberOfRows: configuration.maximumNumberOfVerticalEvents,
              generateMultiDayLayoutFrame: configuration.generateMultiDayLayoutFrame,
              eventPadding: configuration.eventPadding,
              overlayBuilders: headerComponents.overlayBuilders ?? components?.overlayBuilders,
              overlayStyles: componentStyles?.overlayStyles ?? components?.overlayStyles,
              multiDayCache: viewController.multiDayCache,
            );

            final multiDayDragTarget = MultiDayDragTarget<T>(
              pageTriggerSetup: configuration.pageTriggerConfiguration,
              visibleDateTimeRange: visibleRange,
              dayWidth: dayWidth,
              pageWidth: pageWidth,
              tileHeight: configuration.tileHeight,
              allowSingleDayEvents: false,
              leftPageTrigger: headerComponents.leftTriggerBuilder,
              rightPageTrigger: headerComponents.rightTriggerBuilder,
            );

            final constraints = BoxConstraints(
              minHeight: configuration.tileHeight,
              minWidth: pageWidth,
            );

            return Column(
              children: [
                Row(children: [...dayHeaders]),
                if (configuration.showTiles)
                  Stack(
                    children: [
                      Positioned.fill(child: MultiDayDraggable<T>(visibleDateTimeRange: visibleRange)),
                      ConstrainedBox(constraints: constraints, child: multiDayEvents),
                      Positioned.fill(child: multiDayDragTarget),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );

    return MultiDayHeaderWidget<T>(content: pageView, leading: weekNumberWidget);
  }
}
