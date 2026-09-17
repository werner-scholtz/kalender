// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/kalender_layout_delegate.dart';
import 'package:kalender/src/models/providers/gutter_widths.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// {@category Views}
class KalenderView extends StatefulWidget {
  /// The [EventsController] that will be used to populate the events in the calendar view.
  final EventsController eventsController;

  /// The [KalenderController] that is used to control the calendar view.
  final KalenderController kalenderController;

  /// The [ViewConfiguration] that will be used to render the calendar view.
  final ViewConfiguration viewConfiguration;

  /// The [KalenderCallbacks] used by the [KalenderView]
  final KalenderCallbacks? callbacks;

  /// The components and styles used by the calendar.
  ///
  /// Components:
  /// - [MultiDayComponents]
  /// - [MonthComponents]
  /// - [ScheduleComponents]
  ///
  /// Styles live on [KalenderThemeData] rather than here. Register one on
  /// `ThemeData.extensions`, or wrap a calendar in a [KalenderTheme] to scope it.
  final KalenderComponents? components;

  /// The header widget that will be displayed above the body.
  final Widget? header;

  /// The body widget that will be displayed below the header.
  final Widget? body;

  /// The locale used for internationalization, for example `const Locale('en', 'US')`.
  ///
  /// If not provided, intl's default locale is used.
  final Locale? locale;

  /// The location of the calendar view. (from the timezone package)
  ///
  /// If not provided, the default location will be used.
  final Location? location;

  /// Creates a [ViewController] from [viewConfiguration] and attaches it to [kalenderController].
  const KalenderView({
    super.key,
    required this.eventsController,
    required this.kalenderController,
    required this.viewConfiguration,
    this.callbacks,
    this.components,
    this.header,
    this.body,
    this.locale,
    this.location,
  });

  @override
  State<KalenderView> createState() => KalenderViewState();
}

/// {@category Views}
class KalenderViewState extends State<KalenderView> {
  /// The [ViewController] that will be used by the children of the [KalenderView].
  late ViewController _viewController;

  /// Last snapshot of each view, keyed by configuration name.
  final Map<String, ViewSnapshot> _viewHistory = {};
  ViewSnapshot? _lastMultiDaySnapshot;
  // TODO: update this to be a valueNotifier.
  late final _location = ValueNotifier<Location?>(widget.location);

  @override
  void initState() {
    super.initState();
    late final now = widget.location == null ? DateTime.now() : TZDateTime.now(widget.location!);
    final initialDateTime = widget.viewConfiguration.initialDateTime ?? now;
    final initialDate = FloatingDateTime.fromExternal(initialDateTime, location: widget.location);
    _viewController = _createViewController(initialDate: initialDate);
    widget.kalenderController.attach(_viewController);
  }

  @override
  void didUpdateWidget(covariant KalenderView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final didChangeLocale = widget.locale != oldWidget.locale;

    final didChangeLocation = widget.location != oldWidget.location;
    if (didChangeLocation) {
      _location.value = widget.location;
    }

    final didChangeKalenderController = widget.kalenderController != oldWidget.kalenderController;
    if (didChangeKalenderController) {
      oldWidget.kalenderController.detach();
      widget.kalenderController.attach(_viewController);
    }

    final didChangeViewConfiguration = widget.viewConfiguration != oldWidget.viewConfiguration;
    if (didChangeViewConfiguration || didChangeLocation) {
      // Snapshot the outgoing view so its date / time-of-day / zoom can be
      // restored on a later switch. The snapshot is kept even when switching to a
      // view without vertical scroll (e.g. Month), so a Week → Month → Week
      // round-trip still restores the position.
      _snapshotOutgoingView(_viewController);

      final newConfig = widget.viewConfiguration;
      final context = ViewTransitionContext(
        oldViewController: _viewController,
        newViewConfiguration: newConfig,
        byView: _viewHistory,
        lastMultiDay: _lastMultiDaySnapshot,
        locationChanged: didChangeLocation,
      );

      final initialDate = newConfig.dateResolver?.call(context) ?? _resolveDate(newConfig.dateTransition, context);

      // Resolve the vertical state (multi-day views only): resolver wins, else enum.
      KalenderTime? initialTimeOfDay;
      double? initialHeightPerMinute;
      if (newConfig is MultiDayViewConfiguration) {
        initialTimeOfDay =
            newConfig.scrollResolver?.call(context) ?? _resolveScroll(newConfig.scrollTransition, context);
        initialHeightPerMinute =
            newConfig.zoomResolver?.call(context) ?? _resolveZoom(newConfig.zoomTransition, context);
      }

      _viewController = _createViewController(
        initialDate: initialDate,
        initialTimeOfDay: initialTimeOfDay,
        initialHeightPerMinute: initialHeightPerMinute,
      );
      widget.kalenderController.viewController?.dispose();
      widget.kalenderController.attach(_viewController);
    }

    if (didChangeViewConfiguration || didChangeLocation || didChangeLocale || didChangeKalenderController) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.kalenderController.detach();
  }

  @override
  void activate() {
    super.activate();
    widget.kalenderController.attach(_viewController);
  }

  @override
  void dispose() {
    widget.kalenderController.viewController?.dispose();
    _location.dispose();
    super.dispose();
  }

  /// Snapshot the outgoing view's current state, keyed by its config `name`.
  void _snapshotOutgoingView(ViewController controller) {
    final range = controller.floatingVisibleRange.value;
    if (range == null) return;

    final config = controller.viewConfiguration;
    final date = config is MonthViewConfiguration
        ? FloatingDateTime.fromDateTime(range.dominantMonthDate)
        : range.start;

    final multiDay = controller is MultiDayViewController ? controller : null;
    final snapshot = ViewSnapshot(
      date: date,
      timeOfDay: multiDay?.visibleTimeOfDay.value,
      heightPerMinute: multiDay?.heightPerMinute.value,
    );

    _viewHistory[config.name] = snapshot;
    if (multiDay != null) _lastMultiDaySnapshot = snapshot;
  }

  FloatingDateTime _resolveDate(DateTransition transition, ViewTransitionContext context) {
    return switch (transition) {
      DateTransition.carryFocus => kCarryFocusDate(context),
      DateTransition.restorePerView =>
        _viewHistory[context.newViewConfiguration.name]?.date ?? kCarryFocusDate(context),
    };
  }

  KalenderTime? _resolveScroll(ScrollTransition transition, ViewTransitionContext context) {
    return switch (transition) {
      ScrollTransition.preserve => _lastMultiDaySnapshot?.timeOfDay,
      ScrollTransition.reset => null,
      ScrollTransition.restorePerView =>
        _viewHistory[context.newViewConfiguration.name]?.timeOfDay ?? _lastMultiDaySnapshot?.timeOfDay,
    };
  }

  double? _resolveZoom(ZoomTransition transition, ViewTransitionContext context) {
    return switch (transition) {
      ZoomTransition.preserve => _lastMultiDaySnapshot?.heightPerMinute,
      ZoomTransition.reset => null,
      ZoomTransition.restorePerView =>
        _viewHistory[context.newViewConfiguration.name]?.heightPerMinute ?? _lastMultiDaySnapshot?.heightPerMinute,
    };
  }

  ViewController _createViewController({
    required FloatingDateTime initialDate,
    KalenderTime? initialTimeOfDay,
    double? initialHeightPerMinute,
  }) {
    final viewConfiguration = widget.viewConfiguration;

    return switch (viewConfiguration.runtimeType) {
      const (MultiDayViewConfiguration) => MultiDayViewController(
        viewConfiguration: viewConfiguration as MultiDayViewConfiguration,
        floatingVisibleRange: widget.kalenderController.floatingVisibleRange,
        visibleEvents: widget.kalenderController.visibleEvents,
        initialDate: initialDate,
        initialTimeOfDayOverride: initialTimeOfDay,
        initialHeightPerMinute: initialHeightPerMinute,
        location: widget.location,
      ),
      const (MonthViewConfiguration) => MonthViewController(
        viewConfiguration: viewConfiguration as MonthViewConfiguration,
        floatingVisibleRange: widget.kalenderController.floatingVisibleRange,
        visibleEvents: widget.kalenderController.visibleEvents,
        initialDate: initialDate,
        location: widget.location,
      ),
      const (ScheduleViewConfiguration) => switch ((viewConfiguration as ScheduleViewConfiguration).viewType) {
        ScheduleViewType.continuous => ContinuousScheduleViewController(
          viewConfiguration: viewConfiguration,
          floatingVisibleRange: widget.kalenderController.floatingVisibleRange,
          visibleEvents: widget.kalenderController.visibleEvents,
          initialDate: initialDate,
          location: widget.location,
        ),
        ScheduleViewType.paginated => PaginatedScheduleViewController(
          viewConfiguration: viewConfiguration,
          floatingVisibleRange: widget.kalenderController.floatingVisibleRange,
          visibleEvents: widget.kalenderController.visibleEvents,
          initialDate: initialDate,
          location: widget.location,
        ),
      },
      _ => throw ErrorHint('Unsupported ViewConfiguration'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bodyId = widget.body == null ? null : KalenderLayoutDelegate.body;
    final headerId = widget.header == null ? null : KalenderLayoutDelegate.header;

    final components = widget.components ?? const KalenderComponents();
    // Each gutter is measured only for the view that draws it.
    final viewConfiguration = widget.viewConfiguration;
    final multiDayConfiguration = viewConfiguration is MultiDayViewConfiguration ? viewConfiguration : null;
    final monthConfiguration = viewConfiguration is MonthViewConfiguration && viewConfiguration.showWeekNumbers
        ? viewConfiguration
        : null;

    return LocationProvider(
      notifier: _location,
      child: LocaleProvider(
        locale: widget.locale,
        child: Callbacks(
          callbacks: widget.callbacks,
          child: Components(
            components: components,
            child: EventsControllerProvider(
              eventsController: widget.eventsController,
              child: KalenderControllerProvider(
                notifier: widget.kalenderController,
                // Below every provider a width builder may read, and above both
                // halves so they cannot be given different widths.
                child: Builder(
                  builder: (context) => GutterWidths(
                    weekNumber: monthConfiguration == null
                        ? null
                        : components.monthComponents.bodyComponents.buildWeekNumberWidth(context),
                    timeline: multiDayConfiguration == null
                        ? null
                        : components.multiDayComponents.bodyComponents.buildTimelineWidth(
                            context,
                            multiDayConfiguration.timeOfDayRange,
                          ),
                    child: CustomMultiChildLayout(
                      delegate: KalenderLayoutDelegate(headerId, bodyId),
                      children: [
                        if (bodyId != null) LayoutId(id: bodyId, child: widget.body!),
                        if (headerId != null) LayoutId(id: headerId, child: widget.header!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
