// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/kalender_layout_delegate.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

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

  /// The header and body shown for each kind of view configuration.
  ///
  /// The first parts that accept the controller's configuration are shown, a named one before an unnamed one. See
  /// [ViewParts].
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

  /// Keeps the header and body in place when the parts change the widgets that wrap them.
  final _layoutKey = GlobalKey();

  /// The configuration types and names already reported as matching several parts.
  final _reportedDuplicates = <(Type, String)>{};

  @override
  void initState() {
    super.initState();
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
      debugPrint(
        'KalenderView: ${candidates.length} ViewParts accept the ${configuration.runtimeType} named '
        '"${configuration.name}", so the first is shown. Give each parts a name matching its configuration\'s name '
        'to pick one.',
      );
    }
    return candidates.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: ViewControllerProvider(
                    viewController: _viewController,
                    child: Builder(
                      builder: (context) {
                        final layout = CustomMultiChildLayout(
                          key: _layoutKey,
                          delegate: KalenderLayoutDelegate(headerId, bodyId),
                          children: [
                            if (bodyId != null) LayoutId(id: bodyId, child: body!),
                            if (headerId != null) LayoutId(id: headerId, child: header!),
                          ],
                        );
                        return parts?.wrap(context, layout) ?? layout;
                      },
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
