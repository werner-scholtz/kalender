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
    final provider = context.provider<T>();
    final eventsController = provider.eventsController;
    final calendarController = provider.calendarController;
    final callbacks = provider.callbacks;
    assert(
      calendarController.viewController is MultiDayViewController<T>,
      'The CalendarController\'s $ViewController<$T> needs to be a $MultiDayViewController<$T>',
    );

    final viewController = calendarController.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final headerConfiguration = this.configuration ?? MultiDayHeaderConfiguration<T>();

    final calendarComponents = provider.components;
    final headerProvider = context.headerProvider<T>();
    final tileComponents = headerProvider.tileComponents;
    final interaction = headerProvider.interaction;

    return LayoutBuilder(
      builder: (context, constraints) {
        final header = switch (viewConfiguration.type) {
          MultiDayViewType.freeScroll => _FreeScrollHeader<T>(
              key: ValueKey(viewConfiguration.hashCode),
              eventsController: eventsController,
              calendarController: calendarController,
              configuration: headerConfiguration,
              tileComponents: tileComponents,
              components: calendarComponents,
              tileHeight: headerConfiguration.tileHeight,
              callbacks: callbacks,
              interaction: interaction,
            ),
          MultiDayViewType.singleDay => _SingleDayHeader<T>(
              key: ValueKey(viewConfiguration.hashCode),
              eventsController: eventsController,
              calendarController: calendarController,
              configuration: headerConfiguration,
              tileComponents: tileComponents,
              components: calendarComponents,
              tileHeight: headerConfiguration.tileHeight,
              callbacks: callbacks,
              interaction: interaction,
            ),
          _ => _MultiDayHeader<T>(
              key: ValueKey(viewConfiguration.hashCode),
              eventsController: eventsController,
              calendarController: calendarController,
              configuration: headerConfiguration,
              tileComponents: tileComponents,
              components: calendarComponents,
              tileHeight: headerConfiguration.tileHeight,
              callbacks: callbacks,
              interaction: interaction,
            )
        };

        return Column(children: [header]);
      },
    );
  }
}

/// A header catered for displaying multi-day events for a single day body.
class _SingleDayHeader<T extends Object?> extends StatelessWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;
  final CalendarCallbacks<T>? callbacks;
  final MultiDayHeaderConfiguration<T> configuration;
  final TileComponents<T> tileComponents;
  final CalendarComponents<T>? components;
  final double tileHeight;
  final ValueNotifier<CalendarInteraction> interaction;

  const _SingleDayHeader({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.configuration,
    required this.tileComponents,
    required this.components,
    required this.tileHeight,
    required this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    final viewController = calendarController.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
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
            final constraints = BoxConstraints(minHeight: tileHeight * 2, minWidth: pageWidth);
            final multiDayEvents = MultiDayEventWidget<T>(
              eventsController: eventsController,
              controller: calendarController,
              tileComponents: tileComponents,
              visibleDateTimeRange: visibleRange,
              dayWidth: pageWidth,
              interaction: interaction,
              showAllEvents: false,
              callbacks: callbacks,
              tileHeight: configuration.tileHeight,
              maxNumberOfRows: configuration.maximumNumberOfVerticalEvents,
              generateMultiDayLayoutFrame: configuration.generateMultiDayLayoutFrame,
              eventPadding: configuration.eventPadding,
              overlayBuilders: headerComponents.overlayBuilders ?? components?.overlayBuilders,
              overlayStyles: componentStyles?.overlayStyles ?? components?.overlayStyles,
            );

            final multiDayDragTarget = MultiDayDragTarget<T>(
              eventsController: eventsController,
              calendarController: calendarController,
              callbacks: callbacks,
              tileComponents: tileComponents,
              pageTriggerSetup: configuration.pageTriggerConfiguration,
              visibleDateTimeRange: visibleRange,
              dayWidth: pageWidth,
              pageWidth: pageWidth,
              tileHeight: tileHeight,
              allowSingleDayEvents: false,
              leftPageTrigger: headerComponents.leftTriggerBuilder,
              rightPageTrigger: headerComponents.rightTriggerBuilder,
            );

            final draggable = MultiDayEventDraggableWidgets<T>(
              eventsController: eventsController,
              controller: calendarController,
              callbacks: callbacks,
              visibleDateTimeRange: visibleRange,
              dayWidth: pageWidth,
              interaction: interaction,
            );

            return Stack(
              children: [
                Positioned.fill(child: draggable),
                ConstrainedBox(constraints: constraints, child: multiDayEvents),
                Positioned.fill(child: multiDayDragTarget),
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
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;

  final CalendarCallbacks<T>? callbacks;
  final MultiDayHeaderConfiguration<T> configuration;
  final TileComponents<T> tileComponents;
  final CalendarComponents<T>? components;
  final double tileHeight;
  final ValueNotifier<CalendarInteraction> interaction;

  const _MultiDayHeader({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.configuration,
    required this.tileComponents,
    required this.components,
    required this.tileHeight,
    required this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    final viewController = calendarController.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
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

            final constraints = BoxConstraints(minHeight: tileHeight, minWidth: pageWidth);
            final multiDayEvents = MultiDayEventWidget<T>(
              controller: calendarController,
              eventsController: eventsController,
              visibleDateTimeRange: visibleRange,
              tileComponents: tileComponents,
              dayWidth: dayWidth,
              interaction: interaction,
              showAllEvents: false,
              callbacks: callbacks,
              tileHeight: configuration.tileHeight,
              maxNumberOfRows: configuration.maximumNumberOfVerticalEvents,
              generateMultiDayLayoutFrame: configuration.generateMultiDayLayoutFrame,
              eventPadding: configuration.eventPadding,
              overlayBuilders: headerComponents.overlayBuilders ?? components?.overlayBuilders,
              overlayStyles: componentStyles?.overlayStyles ?? components?.overlayStyles,
            );

            final multiDayDragTarget = MultiDayDragTarget<T>(
              calendarController: calendarController,
              eventsController: eventsController,
              callbacks: callbacks,
              tileComponents: tileComponents,
              pageTriggerSetup: configuration.pageTriggerConfiguration,
              visibleDateTimeRange: visibleRange,
              dayWidth: dayWidth,
              pageWidth: pageWidth,
              tileHeight: tileHeight,
              allowSingleDayEvents: false,
              leftPageTrigger: headerComponents.leftTriggerBuilder,
              rightPageTrigger: headerComponents.rightTriggerBuilder,
            );

            final draggable = MultiDayEventDraggableWidgets<T>(
              eventsController: eventsController,
              controller: calendarController,
              callbacks: callbacks,
              visibleDateTimeRange: visibleRange,
              dayWidth: dayWidth,
              interaction: interaction,
            );

            return Column(
              children: [
                Row(children: [...dayHeaders]),
                if (configuration.showTiles)
                  Stack(
                    children: [
                      Positioned.fill(child: draggable),
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
  final EventsController<T> eventsController;
  final CalendarController<T> calendarController;

  final CalendarCallbacks<T>? callbacks;
  final MultiDayHeaderConfiguration<T> configuration;
  final TileComponents<T> tileComponents;
  final CalendarComponents<T>? components;
  final double tileHeight;
  final ValueNotifier<CalendarInteraction> interaction;

  const _FreeScrollHeader({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.callbacks,
    required this.configuration,
    required this.tileComponents,
    required this.components,
    required this.tileHeight,
    required this.interaction,
  });

  @override
  Widget build(BuildContext context) {
    final viewController = calendarController.viewController as MultiDayViewController<T>;
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageNavigationFunctions;
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
              controller: calendarController,
              eventsController: eventsController,
              visibleDateTimeRange: visibleRange,
              tileComponents: tileComponents,
              dayWidth: dayWidth,
              interaction: interaction,
              showAllEvents: false,
              callbacks: callbacks,
              tileHeight: configuration.tileHeight,
              maxNumberOfRows: configuration.maximumNumberOfVerticalEvents,
              generateMultiDayLayoutFrame: configuration.generateMultiDayLayoutFrame,
              eventPadding: configuration.eventPadding,
              overlayBuilders: headerComponents.overlayBuilders ?? components?.overlayBuilders,
              overlayStyles: componentStyles?.overlayStyles ?? components?.overlayStyles,
            );

            final multiDayDragTarget = MultiDayDragTarget<T>(
              calendarController: calendarController,
              eventsController: eventsController,
              callbacks: callbacks,
              tileComponents: tileComponents,
              pageTriggerSetup: configuration.pageTriggerConfiguration,
              visibleDateTimeRange: visibleRange,
              dayWidth: dayWidth,
              pageWidth: pageWidth,
              tileHeight: tileHeight,
              allowSingleDayEvents: false,
              leftPageTrigger: headerComponents.leftTriggerBuilder,
              rightPageTrigger: headerComponents.rightTriggerBuilder,
            );

            final draggable = MultiDayEventDraggableWidgets<T>(
              eventsController: eventsController,
              controller: calendarController,
              callbacks: callbacks,
              visibleDateTimeRange: visibleRange,
              dayWidth: dayWidth,
              interaction: interaction,
            );

            final constraints = BoxConstraints(
              minHeight: tileHeight,
              minWidth: pageWidth,
            );

            return Column(
              children: [
                Row(children: [...dayHeaders]),
                if (configuration.showTiles)
                  Stack(
                    children: [
                      Positioned.fill(child: draggable),
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
