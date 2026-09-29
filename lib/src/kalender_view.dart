// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/kalender_layout_delegate.dart';
import 'package:kalender/src/models/device_time_zone.dart';
import 'package:kalender/src/models/providers/gutter_widths.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// A calendar that shows the events of [eventsController] in the view [kalenderController] holds.
///
/// {@category Views}
class KalenderView extends StatefulWidget {
  /// The [EventsController] that will be used to populate the events in the calendar view.
  final EventsController eventsController;

  /// The [KalenderController] that holds the view configuration and location.
  final KalenderController kalenderController;

  /// The callbacks of every view. A header or body given its own `callbacks` uses those instead.
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

  /// The header and body shown for each kind of view configuration. See [ViewParts].
  final List<ViewParts> views;

  /// The interaction of every view. A header or body given its own `interaction` uses that instead.
  final KalenderInteraction? interaction;

  /// The locale used for internationalization, for example `const Locale('en', 'US')`.
  ///
  /// If not provided, intl's default locale is used.
  final Locale? locale;

  const KalenderView({
    super.key,
    required this.eventsController,
    required this.kalenderController,
    this.views = defaultViews,
    this.callbacks,
    this.interaction,
    this.components,
    this.locale,
  });

  /// The built-in parts of every view.
  static const defaultViews = <ViewParts>[MultiDayViewParts(), MonthViewParts(), ScheduleViewParts()];

  @override
  State<KalenderView> createState() => KalenderViewState();
}

/// {@category Views}
class KalenderViewState extends State<KalenderView> {
  /// The [ViewController] this view shows.
  late ViewController _viewController;

  KalenderController get _controller => widget.kalenderController;

  late final _interaction = ValueNotifier(widget.interaction ?? KalenderInteraction());

  /// The configuration types and names already reported as matching several parts.
  final _reportedDuplicates = <(Type, String)>{};

  @override
  void initState() {
    super.initState();
    DeviceTimeZone.observe();
    _viewController = _controller.attachView(this);
    _controller.addListener(_onControllerChanged);
  }

  /// Follows a switch of view or location while this view is the active one.
  void _onControllerChanged() {
    if (_controller.isActiveView(this)) becameActive();
  }

  /// Shows the controller's view controller, after a switch or when the view above this one left.
  @internal
  void becameActive() {
    final next = _controller.attachView(this);
    setState(() => _show(next, _controller));
  }

  /// The view controllers shown before [_viewController], with the controller of each, until a build replaces them.
  final _replaced = <(ViewController, KalenderController)>[];

  /// Shows [next] and releases the view controller shown before once a build has replaced its widgets.
  void _show(ViewController next, KalenderController controller) {
    final old = _viewController;
    if (identical(next, old)) return;
    _viewController = next;
    _replaced.add((old, controller));
  }

  void _release(List<(ViewController, KalenderController)> replaced) {
    for (final (viewController, controller) in replaced) {
      controller.releaseView(this, viewController);
    }
  }

  @override
  void didUpdateWidget(covariant KalenderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.interaction != oldWidget.interaction) _interaction.value = widget.interaction ?? KalenderInteraction();
    final oldController = oldWidget.kalenderController;
    if (_controller == oldController) return;
    oldController
      ..removeListener(_onControllerChanged)
      ..detachView(this);
    _show(_controller.attachView(this), oldController);
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
    _release(_replaced);
    _controller
      ..removeListener(_onControllerChanged)
      ..releaseView(this, _viewController);
    _interaction.dispose();
    super.dispose();
  }

  /// The parts that show [configuration], or null when none do.
  ViewParts? _partsFor(ViewConfiguration configuration) {
    final accepting = widget.views.where((parts) => parts.accepts(configuration));
    final named = accepting.where((parts) => parts.name != null).toList();
    final candidates = named.isNotEmpty ? named : accepting.toList();
    assert(
      candidates.isNotEmpty,
      'No ViewParts in KalenderView.views accepts the ${configuration.runtimeType} named "${configuration.name}". '
      'The built-in parts are MultiDayViewParts, MonthViewParts and ScheduleViewParts.',
    );
    if (candidates.length > 1 && _reportedDuplicates.add((configuration.runtimeType, configuration.name))) {
      final advice = named.isEmpty
          ? "Put the parts meant for it before the others, or give them name: '${configuration.name}'."
          : 'Put the parts meant for it before the others.';
      debugPrint(
        'KalenderView: ${candidates.length} ViewParts in views accept the ${configuration.runtimeType} named '
        '"${configuration.name}", and the first of them is shown. $advice',
      );
    }
    return candidates.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    if (_replaced.isNotEmpty) {
      final replaced = [..._replaced];
      _replaced.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _release(replaced));
    }
    final parts = _partsFor(_viewController.viewConfiguration);
    final header = parts?.header ?? parts?.builtInHeader;
    final body = parts?.body ?? parts?.builtInBody;
    final headerId = header == null ? null : KalenderLayoutDelegate.header;
    final bodyId = body == null ? null : KalenderLayoutDelegate.body;
    final components = widget.components ?? const KalenderComponents();

    return LocationProvider(
      location: _viewController.location,
      child: LocaleProvider(
        locale: widget.locale,
        child: Callbacks(
          callbacks: widget.callbacks,
          child: Interaction(
            notifier: _interaction,
            child: Components(
              components: components,
              child: EventsControllerProvider(
                eventsController: widget.eventsController,
                child: KalenderControllerProvider(
                  notifier: widget.kalenderController,
                  child: SelectionScope(
                    controller: widget.kalenderController,
                    child: ViewControllerProvider(
                      viewController: _viewController,
                      child: Builder(
                        builder: (context) {
                          final widths = parts?.gutterWidths(context);
                          return GutterWidths(
                            weekNumber: widths?.weekNumber,
                            timeline: widths?.timeline,
                            child: CustomMultiChildLayout(
                              delegate: KalenderLayoutDelegate(headerId, bodyId),
                              children: [
                                if (bodyId != null) LayoutId(id: bodyId, child: body!),
                                if (headerId != null) LayoutId(id: headerId, child: header!),
                              ],
                            ),
                          );
                        },
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
