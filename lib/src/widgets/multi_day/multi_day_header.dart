import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_header_layout.dart';
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart';

/// The multi-day header decides which header to display the:
/// - [_SingleDayHeader] this is used for a body that only displays a single day.
/// - [_MultiDayHeader] this is used for a body that displays multiple days.
/// - [_FreeScrollHeader] this is used for a body that scrolls freely.
///
/// The single-day and multi-day headers use an [ExpandablePageView] to size the
/// header to the current page. The free-scroll header instead renders one
/// continuous band (see [_FreeScrollMultiDayBand]) so multi-day events can span
/// day columns.
class MultiDayHeader extends StatelessWidget {
  /// The [MultiDayHeaderConfiguration] that will be used by the [MultiDayHeader].
  final HorizontalConfiguration? configuration;

  /// Creates a new [MultiDayHeader].
  const MultiDayHeader({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController;
    assert(
      calendarController.viewController is MultiDayViewController,
      'The CalendarController\'s $ViewController needs to be a $MultiDayViewController',
    );

    final viewController = calendarController.viewController as MultiDayViewController;
    final viewConfiguration = viewController.viewConfiguration;
    final headerConfiguration = configuration ?? const MultiDayHeaderConfiguration();
    final components = context.components;

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
      valueListenable: context.calendarController.internalDateTimeRange,
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
                    eventsController: context.eventsController,
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
      valueListenable: context.calendarController.internalDateTimeRange,
      builder: (context, value, child) {
        if (value == null) {
          debugPrint('Warning: The visibleDateTimeRange is null in MultiDayHeader.');
          return const SizedBox.shrink();
        }
        return headerComponents.weekNumberBuilder.call(value.forLocation(location: context.location), weekNumberStyle);
      },
    );

    return MultiDayHeaderWidget(
      content: ExpandablePageView(
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
                        eventsController: context.eventsController,
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

/// A header for the free-scroll body.
///
/// Unlike the paged headers, the multi-day events here are drawn as one
/// continuous band (see [_FreeScrollMultiDayBand]) so an event spanning several
/// days renders as a single tile instead of being split across per-day pages.
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
    final headerComponents = components.multiDayComponents.headerComponents;
    final componentStyles = components.multiDayComponentStyles.headerStyles;

    final weekNumberStyle = componentStyles.weekNumberStyle;
    final weekNumberWidget = ValueListenableBuilder(
      valueListenable: context.calendarController.internalDateTimeRange,
      builder: (context, value, child) {
        if (value == null) return const SizedBox.shrink();
        return headerComponents.weekNumberBuilder.call(value.forLocation(location: context.location), weekNumberStyle);
      },
    );

    return MultiDayHeaderWidget(
      content: _FreeScrollMultiDayBand(
        viewController: viewController,
        configuration: configuration,
        components: components,
      ),
      leading: weekNumberWidget,
    );
  }
}

/// The continuous weekday-label and multi-day-event band for the free-scroll
/// header.
///
/// The free-scroll body pages one day at a time (viewport fraction
/// `1 / numberOfDays`), so a per-page multi-day band would clip each day and
/// split a spanning event. Instead this renders the visible days (plus a buffer
/// on each side) as one strip and slides it to follow the body's scroll, so a
/// multi-day event is a single tile positioned across its day columns.
///
/// Only the visible window is rendered, so the strip stays small regardless of
/// how large the display range is. The horizontal position is derived from
/// [MultiDayViewController.pageOffset] and applied synchronously in [build], so
/// re-anchoring the window and its offset compensation happen on the same frame
/// (no visible jump).
class _FreeScrollMultiDayBand extends StatefulWidget {
  final MultiDayViewController viewController;
  final HorizontalConfiguration configuration;
  final CalendarComponents components;

  const _FreeScrollMultiDayBand({
    required this.viewController,
    required this.configuration,
    required this.components,
  });

  @override
  State<_FreeScrollMultiDayBand> createState() => _FreeScrollMultiDayBandState();
}

class _FreeScrollMultiDayBandState extends State<_FreeScrollMultiDayBand> {
  double _dayWidth = 0;
  int _numberOfDays = 1;
  int _numberOfPages = 1;

  /// The absolute day index of the first day of the currently rendered window.
  int? _domainStart;

  /// Extra days rendered on each side of the visible window so tiles that scroll
  /// in are already laid out.
  int get _bufferDays => _numberOfDays;

  @override
  void initState() {
    super.initState();
    widget.viewController.pageOffset.addListener(_maybeReanchor);
  }

  @override
  void didUpdateWidget(covariant _FreeScrollMultiDayBand oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewController != widget.viewController) {
      oldWidget.viewController.pageOffset.removeListener(_maybeReanchor);
      widget.viewController.pageOffset.addListener(_maybeReanchor);
    }
  }

  @override
  void dispose() {
    widget.viewController.pageOffset.removeListener(_maybeReanchor);
    super.dispose();
  }

  /// The current leftmost visible day as a fractional absolute day index.
  ///
  /// Falls back to the view's initial page until the page controller is
  /// attached, because it does not notify [MultiDayViewController.pageOffset] on
  /// first attach.
  double _currentPage() {
    final controller = widget.viewController.pageController;
    if (controller.hasClients && controller.positions.length == 1 && controller.position.hasPixels) {
      return controller.page ?? widget.viewController.initialPage.toDouble();
    }
    return widget.viewController.initialPage.toDouble();
  }

  int _clampStart(int start) {
    if (start < 0) return 0;
    final maxStart = _numberOfPages - 1;
    return start > maxStart ? maxStart : start;
  }

  /// Re-anchors the rendered window when the leftmost visible day changes. The
  /// continuous motion itself is applied in [build], so there is nothing to
  /// correct afterwards.
  void _maybeReanchor() {
    if (_dayWidth == 0) return;
    final desiredStart = _clampStart(_currentPage().floor() - _bufferDays);
    if (_domainStart == null || desiredStart != _domainStart) {
      setState(() => _domainStart = desiredStart);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewController = widget.viewController;
    final viewConfiguration = viewController.viewConfiguration;
    final pageNavigation = viewConfiguration.pageIndexCalculator;
    _numberOfDays = viewConfiguration.numberOfDays;
    _numberOfPages = viewController.numberOfPages;

    final headerComponents = widget.components.multiDayComponents.headerComponents;
    final componentStyles = widget.components.multiDayComponentStyles.headerStyles;

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final dayWidth = pageWidth / _numberOfDays;
        _dayWidth = dayWidth;

        final start = _domainStart ??= _clampStart(_currentPage().floor() - _bufferDays);
        final maxCount = _numberOfPages - start;
        final requested = _numberOfDays + 2 * _bufferDays;
        final domainCount = requested > maxCount ? maxCount : (requested < 1 ? 1 : requested);

        final rangeStart = pageNavigation.dateTimeRangeFromIndex(start, context.location).start;
        final rangeEnd = pageNavigation.dateTimeRangeFromIndex(start + domainCount - 1, context.location).end;
        final windowRange = InternalDateTimeRange(start: rangeStart, end: rangeEnd);
        final windowDates = windowRange.dates();
        final bandWidth = domainCount * dayWidth;

        // Re-anchor once the real scroll position is known (the page controller
        // may not be attached on the first frames).
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _maybeReanchor();
        });

        // Built once per window, not on every scroll frame. The multi-day band
        // layers a create-by-drag target behind the events and a drop/resize
        // target in front, both over the window range so their day<->pixel
        // mapping matches the events (same as the paged headers).
        final content = SizedBox(
          width: bandWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WeekDayHeaders(dates: windowDates, dayHeaderBuilder: DayHeader.fromContext),
              if (widget.configuration.showTiles)
                Stack(
                  children: [
                    Positioned.fill(child: MultiDayDraggable(internalRange: windowRange)),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: widget.configuration.tileHeight),
                      child: MultiDayEventWidget(
                        eventsController: context.eventsController,
                        internalDateTimeRange: windowRange,
                        configuration: widget.configuration,
                        multiDayCache: viewController.multiDayCache,
                        maxNumberOfVerticalEvents: null,
                        overlayBuilders: headerComponents.overlayBuilders ?? widget.components.overlayBuilders,
                        overlayStyles: componentStyles.overlayStyles ?? widget.components.overlayStyles,
                      ),
                    ),
                    Positioned.fill(
                      child: HorizontalDragTarget(
                        visibleDateTimeRange: windowRange,
                        configuration: widget.configuration,
                        // The page-edge triggers are anchored to the viewport
                        // below, not to this window-wide (translated) target,
                        // so disable the built-in ones here.
                        leftPageTrigger: (_) => const SizedBox.shrink(),
                        rightPageTrigger: (_) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );

        // A non-scrolling horizontal viewport sizes its height to the content,
        // lets the strip exceed the viewport width, and clips. The strip is
        // parked at offset 0; the translate below does the windowing. Computing
        // the translate here (not in a post-frame callback) keeps it in lockstep
        // with a re-anchor so pages do not flicker.
        final band = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: ValueListenableBuilder<double>(
            valueListenable: viewController.pageOffset,
            child: content,
            builder: (context, _, child) {
              final maxTranslate = bandWidth - pageWidth;
              final raw = (_currentPage() - start) * dayWidth;
              final translate = maxTranslate <= 0 ? 0.0 : raw.clamp(0.0, maxTranslate);
              return Transform.translate(offset: Offset(-translate, 0), child: child);
            },
          ),
        );

        if (!widget.configuration.showTiles) return band;

        // Page-edge auto-scroll: while a drag hovers the viewport edge, advance
        // to the adjacent day. These triggers are anchored to the viewport (not
        // the translated strip), so they stay reachable at the visible edge.
        final pageTrigger = widget.configuration.pageTriggerConfiguration;
        final triggerWidth = pageWidth / 50;
        Widget edgeTrigger({required bool leading}) {
          final builder = leading ? headerComponents.leftTriggerBuilder : headerComponents.rightTriggerBuilder;
          return CursorNavigationTrigger(
            triggerDelay: pageTrigger.triggerDelay,
            onTrigger: () => leading
                ? viewController.animateToPreviousPage(
                    duration: pageTrigger.animationDuration,
                    curve: pageTrigger.animationCurve,
                  )
                : viewController.animateToNextPage(
                    duration: pageTrigger.animationDuration,
                    curve: pageTrigger.animationCurve,
                  ),
            child: builder?.call(pageWidth) ?? ConstrainedBox(constraints: BoxConstraints.expand(width: triggerWidth)),
          );
        }

        return Stack(
          children: [
            band,
            PositionedDirectional(start: 0, top: 0, bottom: 0, child: edgeTrigger(leading: true)),
            PositionedDirectional(end: 0, top: 0, bottom: 0, child: edgeTrigger(leading: false)),
          ],
        );
      },
    );
  }
}
