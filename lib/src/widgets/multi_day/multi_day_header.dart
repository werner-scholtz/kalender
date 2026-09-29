// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/cursor_navigation_trigger.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_header_layout.dart';
import 'package:kalender/src/widgets/internal_components/time_indicator_positioner.dart';
import 'package:kalender/src/widgets/internal_components/view_providers.dart';
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart';

/// The multi-day header decides which header to display the:
/// - [_SingleDayHeader] this is used for a body that only displays a single day.
/// - [_MultiDayHeader] this is used for a body that displays multiple days.
/// - [_FreeScrollHeader] this is used for a body that scrolls freely.
///
/// {@category Views}
class MultiDayHeader extends StatelessWidget {
  /// The [MultiDayHeaderConfiguration] that will be used by the [MultiDayHeader].
  final MultiDayHeaderConfiguration? configuration;

  /// See [KalenderView.callbacks].
  final KalenderCallbacks? callbacks;

  /// See [KalenderView.interaction].
  final KalenderInteraction? interaction;

  /// The tile components. Defaults to [TileComponents.defaultComponents].
  final TileComponents? tileComponents;

  const MultiDayHeader({super.key, this.configuration, this.callbacks, this.interaction, this.tileComponents});

  @override
  Widget build(BuildContext context) {
    return ViewProviders(
      callbacks: callbacks,
      interaction: interaction,
      tileComponents: tileComponents ?? TileComponents.defaultComponents(),
      child: _MultiDayHeaderSwitch(configuration: configuration),
    );
  }
}

class _MultiDayHeaderSwitch extends StatelessWidget {
  final MultiDayHeaderConfiguration? configuration;

  const _MultiDayHeaderSwitch({this.configuration});

  @override
  Widget build(BuildContext context) {
    assert(
      context.viewController is MultiDayViewController,
      'The KalenderController\'s $ViewController needs to be a $MultiDayViewController',
    );

    final viewController = context.viewController as MultiDayViewController;
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
      ),
    };

    return Column(children: [header]);
  }
}

/// A header catered for displaying multi-day events for a single day body.
class _SingleDayHeader extends StatelessWidget {
  final MultiDayViewController viewController;
  final HorizontalConfiguration configuration;
  final KalenderComponents components;

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
    final dayHeaderWidget = _visibleRangeBuilder(
      viewController,
      (context, range) => headerComponents.buildDayHeader(context, range.start.forLocation(location: context.location)),
    );

    return MultiDayHeaderWidget(
      content: ExpandablePageView(
        controller: viewController.headerController,
        itemCount: viewController.numberOfPages,
        itemBuilder: (context, index) {
          final visibleRange = pageNavigation.rangeFromIndex(index, context.location);

          final minHeight = configuration.tileHeight * 2;

          if (!configuration.showTiles) {
            return Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minHeight),
                  child: const SizedBox.shrink(),
                ),
              ],
            );
          }
          return _multiDayTiles(
            context,
            range: visibleRange,
            configuration: configuration,
            viewController: viewController,
            components: components,
            minHeight: minHeight,
            leftPageTrigger: headerComponents.leftTriggerBuilder,
            rightPageTrigger: headerComponents.rightTriggerBuilder,
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
  final KalenderComponents components;

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
    final weekNumberWidget = _visibleRangeBuilder(
      viewController,
      (context, range) => headerComponents.buildWeekNumber(context, range.forLocation(location: context.location)),
    );

    return MultiDayHeaderWidget(
      content: ExpandablePageView(
        controller: viewController.headerController,
        itemCount: viewController.numberOfPages,
        itemBuilder: (context, index) {
          final visibleRange = pageNavigation.rangeFromIndex(index, context.location);
          final visibleDates = visibleRange.dates();

          return Column(
            children: [
              WeekDayHeaders(
                dates: visibleDates,
                dayHeaderBuilder: (context, date) => context.components.multiDayComponents.headerComponents
                    .buildDayHeader(context, date.forLocation(location: context.location)),
              ),
              if (configuration.showTiles)
                _multiDayTiles(
                  context,
                  range: visibleRange,
                  configuration: configuration,
                  viewController: viewController,
                  components: components,
                  minHeight: configuration.tileHeight,
                  leftPageTrigger: headerComponents.leftTriggerBuilder,
                  rightPageTrigger: headerComponents.rightTriggerBuilder,
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
  final KalenderComponents components;

  const _FreeScrollHeader({
    super.key,
    required this.viewController,
    required this.configuration,
    required this.components,
  });

  @override
  Widget build(BuildContext context) {
    final headerComponents = components.multiDayComponents.headerComponents;
    final weekNumberWidget = _visibleRangeBuilder(
      viewController,
      (context, range) => headerComponents.buildWeekNumber(context, range.forLocation(location: context.location)),
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
/// [MultiDayViewController.pageOffset] and applied synchronously in `build`, so
/// re-anchoring the window and its offset compensation happen on the same frame
/// (no visible jump).
class _FreeScrollMultiDayBand extends StatefulWidget {
  final MultiDayViewController viewController;
  final HorizontalConfiguration configuration;
  final KalenderComponents components;

  const _FreeScrollMultiDayBand({required this.viewController, required this.configuration, required this.components});

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
    final desiredStart = _clampStart(widget.viewController.currentPage().floor() - _bufferDays);
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final pageWidth = constraints.maxWidth;
        final dayWidth = pageWidth / _numberOfDays;
        _dayWidth = dayWidth;

        final start = _domainStart ??= _clampStart(widget.viewController.currentPage().floor() - _bufferDays);
        final maxCount = _numberOfPages - start;
        final requested = _numberOfDays + 2 * _bufferDays;
        final domainCount = requested > maxCount ? maxCount : (requested < 1 ? 1 : requested);

        final rangeStart = pageNavigation.rangeFromIndex(start, context.location).start;
        final rangeEnd = pageNavigation.rangeFromIndex(start + domainCount - 1, context.location).end;
        final windowRange = FloatingDateTimeRange(start: rangeStart, end: rangeEnd);
        final windowDates = windowRange.dates();
        final bandWidth = domainCount * dayWidth;

        // Re-anchor once the real scroll position is known (the page controller
        // may not be attached on the first frames).
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _maybeReanchor();
        });

        // Built once per window. The drag targets span the window range so they map days to pixels like the events.
        final content = SizedBox(
          width: bandWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WeekDayHeaders(
                dates: windowDates,
                dayHeaderBuilder: (context, date) => context.components.multiDayComponents.headerComponents
                    .buildDayHeader(context, date.forLocation(location: context.location)),
              ),
              if (widget.configuration.showTiles)
                _multiDayTiles(
                  context,
                  range: windowRange,
                  configuration: widget.configuration,
                  viewController: viewController,
                  components: widget.components,
                  minHeight: widget.configuration.tileHeight,
                  // The page-edge triggers are anchored to the viewport
                  // below, not to this window-wide (translated) target,
                  // so disable the built-in ones here.
                  leftPageTrigger: (_, __) => const SizedBox.shrink(),
                  rightPageTrigger: (_, __) => const SizedBox.shrink(),
                ),
            ],
          ),
        );

        // The strip stays at offset 0 and the translate below windows it, in the same build as a re-anchor.
        final band = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: ValueListenableBuilder<double>(
            valueListenable: viewController.pageOffset,
            child: content,
            builder: (context, _, child) {
              final maxTranslate = bandWidth - pageWidth;
              final raw = (widget.viewController.currentPage() - start) * dayWidth;
              final translate = maxTranslate <= 0 ? 0.0 : raw.clamp(0.0, maxTranslate);
              // In right-to-left the day columns are mirrored, so scrolling
              // forward moves the strip the other way.
              final sign = Directionality.of(context) == TextDirection.rtl ? 1.0 : -1.0;
              return Transform.translate(offset: Offset(sign * translate, 0), child: child);
            },
          ),
        );

        if (!widget.configuration.showTiles) return band;

        // Page-edge triggers anchored to the viewport, not the translated strip, so a drag at the edge can reach them.
        final pageTrigger = widget.configuration.pageTriggerConfiguration;
        Widget edgeTrigger({required bool leading}) {
          return CursorNavigationTrigger.page(
            configuration: pageTrigger,
            viewController: viewController,
            forward: !leading,
            pageWidth: pageWidth,
            builder: leading ? headerComponents.leftTriggerBuilder : headerComponents.rightTriggerBuilder,
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

/// A [ValueListenableBuilder] on the [ViewController.floatingVisibleRange] of [viewController] that builds nothing
/// while it is null.
Widget _visibleRangeBuilder(
  ViewController viewController,
  Widget Function(BuildContext context, FloatingDateTimeRange range) builder,
) {
  return ValueListenableBuilder(
    valueListenable: viewController.floatingVisibleRange,
    builder: (context, value, child) {
      if (value == null) return const SizedBox.shrink();
      return builder(context, value);
    },
  );
}

/// The [MultiDayDraggable], [MultiDayEventWidget] and [HorizontalDragTarget] of [range], stacked.
Widget _multiDayTiles(
  BuildContext context, {
  required FloatingDateTimeRange range,
  required HorizontalConfiguration configuration,
  required MultiDayViewController viewController,
  required KalenderComponents components,
  required double minHeight,
  required HorizontalTriggerWidgetBuilder? leftPageTrigger,
  required HorizontalTriggerWidgetBuilder? rightPageTrigger,
}) {
  return Stack(
    children: [
      Positioned.fill(child: MultiDayDraggable(floatingRange: range)),
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: MultiDayEventWidget(
          eventsController: context.eventsController,
          floatingRange: range,
          configuration: configuration,
          viewController: viewController,
          maxNumberOfVerticalEvents: null,
          overlayBuilders: components.multiDayComponents.headerComponents.overlayBuilders ?? components.overlayBuilders,
        ),
      ),
      Positioned.fill(
        child: HorizontalDragTarget(
          visibleRange: range,
          configuration: configuration,
          leftPageTrigger: leftPageTrigger,
          rightPageTrigger: rightPageTrigger,
        ),
      ),
    ],
  );
}
