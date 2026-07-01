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

  /// The last known vertical scroll offset / zoom of a [MultiDayViewController].
  ///
  /// These persist across view-configuration changes (they live on the state, not
  /// the disposable controller) so the scroll position and zoom can be restored
  /// even after a round-trip through a view that has no vertical scroll (e.g.
  /// Week → Month → Week). See [MultiDayViewConfiguration.preserveVerticalScrollOnViewChange].
  double? _rememberedScrollOffset;
  double? _rememberedHeightPerMinute;

  /// The last visible date each view showed, keyed by its view configuration's
  /// `name`. Persisted on the state (survives view-configuration changes) so
  /// history-aware strategies like [kRestoreLastVisitedDate] can restore a view's
  /// own last-visited date. See [ViewConfiguration.initialDateSelectionStrategy].
  final Map<String, InternalDateTime> _lastVisibleDatePerView = {};
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
      // Remember the current vertical scroll offset / zoom so it can be restored
      // when returning to a multi-day view. These are kept even when switching to a
      // view without vertical scroll (e.g. Month), so a Week → Month → Week
      // round-trip still restores the position.
      if (_viewController is MultiDayViewController) {
        final multiDay = _viewController as MultiDayViewController;
        _rememberedHeightPerMinute = multiDay.heightPerMinute.value;
        if (multiDay.scrollController.hasClients) {
          _rememberedScrollOffset = multiDay.scrollController.offset;
        }
      }

      // Record the outgoing view's current date under its config name so
      // history-aware strategies can restore each view's own last-visited date.
      final oldRange = _viewController.visibleDateTimeRange.value;
      if (oldRange != null) {
        final oldConfig = _viewController.viewConfiguration;
        _lastVisibleDatePerView[oldConfig.name] = oldConfig is MonthViewConfiguration
            ? InternalDateTime.fromDateTime(oldRange.dominantMonthDate)
            : oldRange.start;
      }

      // Use selectedDate if available, otherwise use the initial date selection strategy
      final initialDate = widget.viewConfiguration.initialDateTime != null
          ? InternalDateTime.fromDateTime(widget.viewConfiguration.initialDateTime!)
          : widget.viewConfiguration.initialDateSelectionStrategy(
              oldViewController: _viewController,
              newViewConfiguration: widget.viewConfiguration,
              lastVisibleDates: _lastVisibleDatePerView,
            );

      // Restore the remembered scroll offset / zoom only when the new view is a
      // multi-day view that opts into preservation.
      final newConfig = widget.viewConfiguration;
      final preserve = newConfig is MultiDayViewConfiguration && newConfig.preserveVerticalScrollOnViewChange;

      // Create the new view controller.
      _viewController = _createViewController(
        initialDate: initialDate,
        initialScrollOffset: preserve ? _rememberedScrollOffset : null,
        initialHeightPerMinute: preserve ? _rememberedHeightPerMinute : null,
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

  /// Create the [ViewController] based on the [ViewConfiguration].
  ViewController _createViewController({
    required InternalDateTime initialDate,
    double? initialScrollOffset,
    double? initialHeightPerMinute,
  }) {
    final viewConfiguration = widget.viewConfiguration;

    return switch (viewConfiguration.runtimeType) {
      const (MultiDayViewConfiguration) => MultiDayViewController(
          viewConfiguration: viewConfiguration as MultiDayViewConfiguration,
          visibleDateTimeRange: widget.calendarController.internalDateTimeRange,
          visibleEvents: widget.calendarController.visibleEvents,
          initialDate: initialDate,
          initialScrollOffset: initialScrollOffset,
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
