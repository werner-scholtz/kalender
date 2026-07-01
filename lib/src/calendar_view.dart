import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/calendar_layout_delegate.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

class CalendarView extends StatefulWidget {
  /// The [EventsController] that will be used to populate the events in the calendar view.
  final EventsController eventsController;

  /// The [CalendarController] that is used to control the calendar view.
  final CalendarController calendarController;

  /// The [ViewConfiguration] that will be used to render the calendar view.
  final ViewConfiguration viewConfiguration;

  /// The [CalendarCallbacks] used by the [CalendarView]
  final CalendarCallbacks? callbacks;

  /// The components and styles used by the calendar.
  ///
  /// Components:
  /// - [MultiDayComponents]
  /// - [MonthComponents]
  /// - [ScheduleComponents]
  ///
  /// Styles:
  /// - [MultiDayComponentStyles]
  /// - [MonthComponentStyles],
  /// - [ScheduleComponentStyles]
  final CalendarComponents? components;

  /// The header widget that will be displayed above the body.
  final Widget? header;

  /// The body widget that will be displayed below the header.
  final Widget? body;

  /// The locale used for internationalization ex. `en_US`, `de_DE`, etc.
  ///
  /// If not provided, a default locale be used.
  final dynamic locale;

  /// The location of the calendar view. (from the timezone package)
  ///
  /// If not provided, the default location will be used.
  final Location? location;

  /// Creates a [CalendarView] widget.
  ///
  /// This widget creates a [ViewController] based on the [viewConfiguration].
  /// It then attaches the [ViewController] to the [calendarController].
  const CalendarView({
    super.key,
    required this.eventsController,
    required this.calendarController,
    required this.viewConfiguration,
    this.callbacks,
    this.components,
    this.header,
    this.body,
    this.locale,
    this.location,
  });

  @override
  State<CalendarView> createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  /// The [ViewController] that will be used by the children of the [CalendarView].
  late ViewController _viewController;

  /// A snapshot of what each view last displayed, keyed by its configuration
  /// `name`, plus the most recent multi-day snapshot. These persist across
  /// view-configuration changes (they live on the state, not the disposable
  /// controllers) so the transition policy can restore date / time-of-day / zoom
  /// even after a round-trip through a view without scroll (e.g. Week → Month →
  /// Week). See [ViewConfiguration.dateTransition] and friends.
  final Map<String, ViewSnapshot> _viewHistory = {};
  ViewSnapshot? _lastMultiDaySnapshot;
  // TODO: update this to be a valueNotifier.
  late dynamic _locale = widget.locale;
  late final _location = ValueNotifier<Location?>(widget.location);

  @override
  void initState() {
    super.initState();
    // Create the initial view controller.
    late final now = widget.location == null ? DateTime.now() : TZDateTime.now(widget.location!);
    final initialDateTime = widget.viewConfiguration.initialDateTime ?? now;
    final initialDate = InternalDateTime.fromExternal(initialDateTime, location: widget.location);
    _viewController = _createViewController(initialDate: initialDate);

    // Attach the view controller when the widget is initialized.
    widget.calendarController.attach(_viewController);
  }

  /// TODO: This needs to be improved on.
  @override
  void didUpdateWidget(covariant CalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final didChangeLocale = _locale != widget.locale;
    if (didChangeLocale) {
      _locale = widget.locale;
    }

    final didChangeLocation = widget.location != oldWidget.location;
    if (didChangeLocation) {
      _location.value = widget.location;
    }

    final didChangeViewConfiguration = widget.viewConfiguration != oldWidget.viewConfiguration;
    // If the view configuration has changed or location, recreate the view controller.
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
      );

      // Resolve the date: explicit initialDateTime wins, then the resolver, then
      // the enum policy.
      final initialDate = newConfig.initialDateTime != null
          ? InternalDateTime.fromDateTime(newConfig.initialDateTime!)
          : (newConfig.dateResolver?.call(context) ?? _resolveDate(newConfig.dateTransition, context));

      // Resolve the vertical state (multi-day views only): resolver wins, else enum.
      TimeOfDay? initialTimeOfDay;
      double? initialHeightPerMinute;
      if (newConfig is MultiDayViewConfiguration) {
        initialTimeOfDay =
            newConfig.scrollResolver?.call(context) ?? _resolveScroll(newConfig.scrollTransition, context);
        initialHeightPerMinute =
            newConfig.zoomResolver?.call(context) ?? _resolveZoom(newConfig.zoomTransition, context);
      }

      // Create the new view controller.
      _viewController = _createViewController(
        initialDate: initialDate,
        initialTimeOfDay: initialTimeOfDay,
        initialHeightPerMinute: initialHeightPerMinute,
      );

      // Dispose the old view controller if it exists.
      widget.calendarController.viewController?.dispose();

      // Attach the new view controller.
      widget.calendarController.attach(_viewController);
    }

    if (didChangeViewConfiguration || didChangeLocation || didChangeLocale) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    // Detach the view controller when the widget is deactivated.
    widget.calendarController.detach();
  }

  @override
  void activate() {
    super.activate();
    // Reattach the view controller when the widget is reactivated.
    widget.calendarController.attach(_viewController);
  }

  @override
  void dispose() {
    // Dispose the view controller when the widget is disposed.
    widget.calendarController.viewController?.dispose();
    _location.dispose();
    super.dispose();
  }

  /// Snapshot the outgoing view's current state, keyed by its config `name`.
  void _snapshotOutgoingView(ViewController controller) {
    final range = controller.visibleDateTimeRange.value;
    if (range == null) return;

    final config = controller.viewConfiguration;
    final date = config is MonthViewConfiguration ? InternalDateTime.fromDateTime(range.dominantMonthDate) : range.start;

    final multiDay = controller is MultiDayViewController ? controller : null;
    final snapshot = ViewSnapshot(
      date: date,
      timeOfDay: multiDay?.visibleTimeOfDay.value,
      heightPerMinute: multiDay?.heightPerMinute.value,
    );

    _viewHistory[config.name] = snapshot;
    if (multiDay != null) _lastMultiDaySnapshot = snapshot;
  }

  InternalDateTime _resolveDate(DateTransition transition, ViewTransitionContext context) {
    return switch (transition) {
      DateTransition.carryFocus => kCarryFocusDate(context),
      DateTransition.restorePerView =>
        _viewHistory[context.newViewConfiguration.name]?.date ?? kCarryFocusDate(context),
    };
  }

  TimeOfDay? _resolveScroll(ScrollTransition transition, ViewTransitionContext context) {
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

  /// Create the [ViewController] based on the [ViewConfiguration].
  ViewController _createViewController({
    required InternalDateTime initialDate,
    TimeOfDay? initialTimeOfDay,
    double? initialHeightPerMinute,
  }) {
    final viewConfiguration = widget.viewConfiguration;

    return switch (viewConfiguration.runtimeType) {
      const (MultiDayViewConfiguration) => MultiDayViewController(
          viewConfiguration: viewConfiguration as MultiDayViewConfiguration,
          visibleDateTimeRange: widget.calendarController.internalDateTimeRange,
          visibleEvents: widget.calendarController.visibleEvents,
          initialDate: initialDate,
          initialTimeOfDayOverride: initialTimeOfDay,
          initialHeightPerMinute: initialHeightPerMinute,
          location: widget.location,
        ),
      const (MonthViewConfiguration) => MonthViewController(
          viewConfiguration: viewConfiguration as MonthViewConfiguration,
          visibleDateTimeRange: widget.calendarController.internalDateTimeRange,
          visibleEvents: widget.calendarController.visibleEvents,
          initialDate: initialDate,
          location: widget.location,
        ),
      const (ScheduleViewConfiguration) => switch ((viewConfiguration as ScheduleViewConfiguration).viewType) {
          ScheduleViewType.continuous => ContinuousScheduleViewController(
              viewConfiguration: viewConfiguration,
              visibleDateTimeRange: widget.calendarController.internalDateTimeRange,
              visibleEvents: widget.calendarController.visibleEvents,
              initialDate: initialDate,
              location: widget.location,
            ),
          ScheduleViewType.paginated => PaginatedScheduleViewController(
              viewConfiguration: viewConfiguration,
              visibleDateTimeRange: widget.calendarController.internalDateTimeRange,
              visibleEvents: widget.calendarController.visibleEvents,
              initialDate: initialDate,
              location: widget.location,
            ),
        },
      _ => throw ErrorHint('Unsupported ViewConfiguration'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bodyId = widget.body == null ? null : CalendarLayoutDelegate.body;
    final headerId = widget.header == null ? null : CalendarLayoutDelegate.header;

    return LocationProvider(
      notifier: _location,
      child: LocaleProvider(
        locale: _locale,
        child: Callbacks(
          callbacks: widget.callbacks,
          child: Components(
            components: widget.components ?? CalendarComponents(),
            child: EventsControllerProvider(
              eventsController: widget.eventsController,
              child: CalendarControllerProvider(
                notifier: widget.calendarController,
                child: CustomMultiChildLayout(
                  delegate: CalendarLayoutDelegate(headerId, bodyId),
                  children: [
                    if (bodyId != null)
                      LayoutId(
                        id: bodyId,
                        child: widget.body!,
                      ),
                    if (headerId != null)
                      LayoutId(
                        id: headerId,
                        child: widget.header!,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
