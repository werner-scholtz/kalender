import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_header_layout.dart';
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart';

/// The multi-day header decides which header to display the:
/// - [_SingleDayHeader] this is used for a body that only displays a single day.
/// - [_MultiDayHeader] this is used for a body that displays multiple days.
/// - [_FreeScrollHeader] this is a special case for a body that scrolls freely (WIP/Not working)
///
/// All Header widgets make use of the [ExpandablePageView] which uses a [SizeReportingWidget]to set the the Height of the header, this is so they can resize dynamically.
class MultiDayHeader extends StatelessWidget {
  /// The [MultiDayHeaderConfiguration] that will be used by the [MultiDayHeader].
  final HorizontalConfiguration? configuration;

  /// Creates a new [MultiDayHeader].
  const MultiDayHeader({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController();
    assert(
      calendarController.viewController is MultiDayViewController,
      'The CalendarController\'s $ViewController needs to be a $MultiDayViewController',
    );

    final viewController = calendarController.viewController as MultiDayViewController;
    final viewConfiguration = viewController.viewConfiguration;
    final headerConfiguration = configuration ?? const MultiDayHeaderConfiguration();
    final components = context.components();

    final header = switch (viewConfiguration.type) {
      MultiDayViewType.freeScroll => _FreeScrollHeader(
          key: ValueKey(viewConfiguration.hashCode),
          viewController: viewController,
          configuration: headerConfiguration,
          components: components,
        ),
      MultiDayViewType.singleDay => _SingleDayHeader(
          key: ValueKey(viewConfiguration.hashCode),
          viewController: viewController,
          configuration: headerConfiguration,
          components: components,
        ),
      _ => _MultiDayHeader(
          key: ValueKey(viewConfiguration.hashCode),
          viewController: viewController,
          configuration: headerConfiguration,
          components: components,
        )
    };

    return Column(children: [header]);
  }
}

/// A header catered for displaying multi-day events for a single day body.
class _SingleDayHeader extends StatelessWidget {
  final MultiDayViewController viewController;
  final HorizontalConfiguration configuration;
  final CalendarComponents components;

  const _SingleDayHeader({
    super.key,
    required this.configuration,
    required this.viewController,
    required this.components,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageIndexCalculator;

    final headerComponents = components.multiDayComponents.headerComponents;
    final componentStyles = components.multiDayComponentStyles.headerStyles;

    final dayHeaderStyle = componentStyles.dayHeaderStyle;
    final dayHeaderWidget = ValueListenableBuilder(
      valueListenable: context.calendarController().internalDateTimeRange,
      builder: (context, value, child) {
        if (value == null) {
          debugPrint('Warning: The visibleDateTimeRange is null in MultiDayHeader.');
          return const SizedBox.shrink();
        }
        return headerComponents.dayHeaderBuilder.call(value.start, dayHeaderStyle);
      },
    );

    return MultiDayHeaderWidget(
      content: ExpandablePageView(
        key: UniqueKey(),
        controller: viewController.headerController,
        itemCount: viewController.numberOfPages,
        itemBuilder: (context, index) {
          final visibleRange = pageNavigation.dateTimeRangeFromIndex(index, context.location);

          // Minimum constraints for the multiDayEvents.
          final constraints = BoxConstraints(minHeight: configuration.tileHeight * 2);

          return Stack(
            children: [
              if (configuration.showTiles) ...[
                Positioned.fill(child: MultiDayDraggable(internalRange: visibleRange)),
                ConstrainedBox(
                  constraints: constraints,
                  child: MultiDayEventWidget(
                    internalDateTimeRange: visibleRange,
                    configuration: configuration,
                    multiDayCache: viewController.multiDayCache,
                    maxNumberOfVerticalEvents: null,
                    overlayBuilders: headerComponents.overlayBuilders ?? components.overlayBuilders,
                    overlayStyles: componentStyles.overlayStyles ?? components.overlayStyles,
                  ),
                ),
                Positioned.fill(
                  child: HorizontalDragTarget(
                    visibleDateTimeRange: visibleRange,
                    configuration: configuration,
                    leftPageTrigger: headerComponents.leftTriggerBuilder,
                    rightPageTrigger: headerComponents.rightTriggerBuilder,
                  ),
                ),
              ] else
                ConstrainedBox(constraints: constraints, child: const SizedBox.shrink()),
            ],
          );
        },
      ),
      leading: dayHeaderWidget,
    );
  }
}

/// A header catered for displaying multi-day events for a multi-day body.
class _MultiDayHeader extends StatelessWidget {
  final MultiDayViewController viewController;
  final HorizontalConfiguration configuration;
  final CalendarComponents components;

  const _MultiDayHeader({
    super.key,
    required this.configuration,
    required this.viewController,
    required this.components,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageIndexCalculator;
    final headerComponents = components.multiDayComponents.headerComponents;
    final componentStyles = components.multiDayComponentStyles.headerStyles;

    final weekNumberStyle = componentStyles.weekNumberStyle;
    final weekNumberWidget = ValueListenableBuilder(
      valueListenable: context.calendarController().internalDateTimeRange,
      builder: (context, value, child) {
        if (value == null) {
          debugPrint('Warning: The visibleDateTimeRange is null in MultiDayHeader.');
          return const SizedBox.shrink();
        }
        return headerComponents.weekNumberBuilder.call(value, weekNumberStyle);
      },
    );

    return MultiDayHeaderWidget(
      content: ExpandablePageView(
        key: UniqueKey(),
        controller: viewController.headerController,
        itemCount: viewController.numberOfPages,
        itemBuilder: (context, index) {
          final visibleRange = pageNavigation.dateTimeRangeFromIndex(index, context.location);
          final visibleDates = visibleRange.dates();

          return Column(
            children: [
              WeekDayHeaders(
                dates: visibleDates,
                dayHeaderBuilder: DayHeader.fromContext,
              ),
              if (configuration.showTiles)
                Stack(
                  children: [
                    Positioned.fill(child: MultiDayDraggable(internalRange: visibleRange)),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: configuration.tileHeight),
                      child: MultiDayEventWidget(
                        internalDateTimeRange: visibleRange,
                        configuration: configuration,
                        multiDayCache: viewController.multiDayCache,
                        maxNumberOfVerticalEvents: null,
                        overlayBuilders: headerComponents.overlayBuilders ?? components.overlayBuilders,
                        overlayStyles: componentStyles.overlayStyles ?? components.overlayStyles,
                      ),
                    ),
                    Positioned.fill(
                      child: HorizontalDragTarget(
                        visibleDateTimeRange: visibleRange,
                        configuration: configuration,
                        leftPageTrigger: headerComponents.leftTriggerBuilder,
                        rightPageTrigger: headerComponents.rightTriggerBuilder,
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
      leading: weekNumberWidget,
    );
  }
}

/// TODO: Fix and Ensure this works.
class _FreeScrollHeader extends StatelessWidget {
  final MultiDayViewController viewController;
  final HorizontalConfiguration configuration;
  final CalendarComponents components;

  const _FreeScrollHeader({
    super.key,
    required this.viewController,
    required this.configuration,
    required this.components,
  });

  @override
  Widget build(BuildContext context) {
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageIndexCalculator;
    final headerComponents = components.multiDayComponents.headerComponents;
    final componentStyles = components.multiDayComponentStyles.headerStyles;

    final weekNumberStyle = componentStyles.weekNumberStyle;
    final weekNumberWidget = ValueListenableBuilder(
      valueListenable: context.calendarController().internalDateTimeRange,
      builder: (context, value, child) {
        if (value == null) {
          debugPrint('Warning: The visibleDateTimeRange is null in FreeScrollHeader.');
          return const SizedBox.shrink();
        }
        return headerComponents.weekNumberBuilder.call(value, weekNumberStyle);
      },
    );

    return MultiDayHeaderWidget(
      /// TODO: figure out how to get multi-day events to work with FreeScroll.
      ///
      /// To do this the header would need to display a single page and not multiple. see viewport fraction.
      content: ExpandablePageView(
        key: UniqueKey(),
        controller: viewController.headerController,
        itemCount: viewController.numberOfPages,
        itemBuilder: (context, index) {
          final visibleRange = pageNavigation.dateTimeRangeFromIndex(index, context.location);
          final visibleDates = visibleRange.dates();

          return Column(
            children: [
              WeekDayHeaders(
                dates: visibleDates,
                dayHeaderBuilder: DayHeader.fromContext,
              ),
              if (configuration.showTiles)
                Stack(
                  children: [
                    Positioned.fill(child: MultiDayDraggable(internalRange: visibleRange)),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: configuration.tileHeight),
                      child: MultiDayEventWidget(
                        internalDateTimeRange: visibleRange,
                        configuration: configuration,
                        multiDayCache: viewController.multiDayCache,
                        maxNumberOfVerticalEvents: null,
                        overlayBuilders: headerComponents.overlayBuilders ?? components.overlayBuilders,
                        overlayStyles: componentStyles.overlayStyles ?? components.overlayStyles,
                      ),
                    ),
                    Positioned.fill(
                      child: HorizontalDragTarget(
                        visibleDateTimeRange: visibleRange,
                        configuration: configuration,
                        leftPageTrigger: headerComponents.leftTriggerBuilder,
                        rightPageTrigger: headerComponents.rightTriggerBuilder,
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
      leading: weekNumberWidget,
    );
  }
}
