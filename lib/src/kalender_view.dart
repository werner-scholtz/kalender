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

  /// The [KalenderController] that holds the view configuration and location.
  final KalenderController kalenderController;

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

  const KalenderView({
    super.key,
    required this.eventsController,
    required this.kalenderController,
    this.callbacks,
    this.components,
    this.header,
    this.body,
    this.locale,
  });

  @override
  State<KalenderView> createState() => KalenderViewState();
}

/// {@category Views}
class KalenderViewState extends State<KalenderView> {
  /// The [ViewController] this view shows.
  late ViewController _viewController;

  KalenderController get _controller => widget.kalenderController;

  @override
  void initState() {
    super.initState();
    _viewController = _controller.attachView(this);
    _controller.addListener(_onControllerChanged);
  }

  /// Follows a switch of view or location while this view is the active one.
  void _onControllerChanged() {
    if (!_controller.isActiveView(this)) return;
    final next = _controller.attachView(this);
    setState(() => _show(next, _controller));
  }

  /// Shows [next] and releases the view controller shown before once its widgets are gone.
  void _show(ViewController next, KalenderController controller) {
    final old = _viewController;
    if (identical(next, old)) return;
    _viewController = next;
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.releaseView(this, old));
  }

  @override
  void didUpdateWidget(covariant KalenderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldController = oldWidget.kalenderController;
    if (_controller == oldController) return;
    oldController
      ..removeListener(_onControllerChanged)
      ..detachView(this);
    final old = _viewController;
    _viewController = _controller.attachView(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => oldController.releaseView(this, old));
    _controller.addListener(_onControllerChanged);
  }

  @override
  void deactivate() {
    super.deactivate();
    _controller.detachView(this);
  }

  @override
  void activate() {
    super.activate();
    _show(_controller.attachView(this), _controller);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onControllerChanged)
      ..releaseView(this, _viewController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyId = widget.body == null ? null : KalenderLayoutDelegate.body;
    final headerId = widget.header == null ? null : KalenderLayoutDelegate.header;

    final components = widget.components ?? const KalenderComponents();
    // Each gutter is measured only for the view that draws it.
    final viewConfiguration = _viewController.viewConfiguration;
    final multiDayConfiguration = viewConfiguration is MultiDayViewConfiguration ? viewConfiguration : null;
    final monthConfiguration = viewConfiguration is MonthViewConfiguration && viewConfiguration.showWeekNumbers
        ? viewConfiguration
        : null;

    return LocationProvider(
      location: _viewController.location,
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
                child: ViewControllerProvider(
                  viewController: _viewController,
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
      ),
    );
  }
}
