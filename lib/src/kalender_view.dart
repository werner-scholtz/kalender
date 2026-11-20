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
import 'package:kalender/src/widgets/internal_components/view_switch_area.dart';

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
  /// Styles live on [KalenderThemeData] rather than here. Register one on `ThemeData.extensions`, or wrap a calendar in
  /// a [KalenderTheme] to scope it.
  final KalenderComponents? components;

  /// The header and body shown for each kind of view configuration. See [ViewParts].
  final List<ViewParts> views;

  /// The interaction of every view. A header or body given its own `interaction` uses that instead.
  final KalenderInteraction? interaction;

  /// The locale used for internationalization, for example `const Locale('en', 'US')`.
  ///
  /// If not provided, intl's default locale is used.
  final Locale? locale;

  /// The animation of a switch to a view configuration with another `name`. Null switches without one.
  ///
  /// Changing it between null and a value builds the view again, which resets its scroll position and page.
  final KalenderViewAnimation? switchAnimation;

  const KalenderView({
    super.key,
    required this.eventsController,
    required this.kalenderController,
    this.views = defaultViews,
    this.callbacks,
    this.interaction,
    this.components,
    this.locale,
    this.switchAnimation,
  });

  /// The built-in parts of every view.
  static const defaultViews = <ViewParts>[MultiDayViewParts(), MonthViewParts(), ScheduleViewParts()];

  @override
  State<KalenderView> createState() => KalenderViewState();
}

/// The state of a [KalenderView]. It holds the [ViewController] the view shows.
///
/// {@category Views}
class KalenderViewState extends State<KalenderView> with SingleTickerProviderStateMixin {
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
    setState(() => _show(next, _controller, animate: true));
  }

  /// The view controller [_viewController] replaced, shown until [_animation] ends.
  (ViewController, KalenderController)? _outgoing;

  AnimationController? _animation;

  void _startAnimation(KalenderViewAnimation switchAnimation) {
    final animation = _animation ??= AnimationController(vsync: this)
      ..addStatusListener(_onAnimationStatus)
      ..addListener(_updateColumns);
    animation
      ..duration = switchAnimation.duration
      ..value = 0;
    _updateColumns();
    animation.forward();
  }

  /// Moves the day columns of the outgoing and incoming multi-day views so a date sits in the same place in both.
  void _updateColumns() {
    final outgoing = _outgoing?.$1;
    final animation = _animation;
    final switchAnimation = widget.switchAnimation;
    if (outgoing == null || animation == null || switchAnimation == null) return;
    final morph = ColumnMorph.between(
      outgoing.viewConfiguration,
      outgoing.floatingVisibleRange.value,
      _viewController.viewConfiguration,
      _viewController.floatingVisibleRange.value,
    );
    if (morph == null) return;
    final t = switchAnimation.curve.transform(animation.value);
    (_areas[outgoing] ??= ViewSwitchAreaHolder()).columns.value = morph.outgoingAt(t);
    (_areas[_viewController] ??= ViewSwitchAreaHolder()).columns.value = morph.incomingAt(t);
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status.isCompleted) setState(_endAnimation);
  }

  void _endAnimation() {
    final outgoing = _outgoing;
    if (outgoing == null) return;
    _outgoing = null;
    _areas[_viewController]?.columns.value = ColumnTransform.identity;
    _replaced.add(outgoing);
  }

  /// The view controllers shown before [_viewController], with the controller of each, until a build replaces them.
  final _replaced = <(ViewController, KalenderController)>[];

  /// Shows [next] and releases the view controller shown before once a build has replaced its widgets.
  ///
  /// With [animate], a switch to a configuration with another name keeps the one shown before until [KalenderView.switchAnimation]
  /// ends.
  void _show(ViewController next, KalenderController controller, {bool animate = false}) {
    final old = _viewController;
    if (identical(next, old)) return;
    _viewController = next;
    final switchAnimation = widget.switchAnimation;
    if (animate && switchAnimation != null && old.viewConfiguration.name != next.viewConfiguration.name) {
      _endAnimation();
      _outgoing = (old, controller);
      _startAnimation(switchAnimation);
      return;
    }
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
    if (widget.switchAnimation == null) _finishAnimation();
    final oldController = oldWidget.kalenderController;
    if (_controller == oldController) return;
    _finishAnimation();
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

  /// Ends a running animation at once.
  void _finishAnimation() {
    if (_outgoing == null) return;
    _animation?.stop();
    _endAnimation();
  }

  @override
  void dispose() {
    _animation?.dispose();
    _endAnimation();
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
      'The built-in parts are MultiDayViewParts, MonthViewParts and ScheduleViewParts. A configuration that extends '
      'ViewConfiguration directly needs parts that extend ViewParts.',
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
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) _finishAnimation();
    if (_replaced.isNotEmpty) {
      final replaced = [..._replaced];
      _replaced.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _release(replaced));
    }
    final components = widget.components ?? const KalenderComponents();
    final switchAnimation = widget.switchAnimation;
    final outgoing = _outgoing?.$1;
    final animation = _animation;

    return LocaleProvider(
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
                  child: switchAnimation == null
                      ? _buildView(_viewController)
                      : ClipRect(
                          child: Stack(
                            fit: StackFit.passthrough,
                            children: _animatedViews(switchAnimation, outgoing, animation),
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

  /// The area each view controller's view marks with a [ViewSwitchArea].
  final _areas = Expando<ViewSwitchAreaHolder>();

  /// The views shown with [switchAnimation], the outgoing one while [animation] runs.
  ///
  /// The incoming view's header is shown at once and only the bodies animate. The outgoing view is moved onto and
  /// clipped to the incoming view's body. Between two multi-day views, the incoming body is shown in full and only the
  /// outgoing day columns fade out above it, while [_updateColumns] moves the columns of both.
  List<Widget> _animatedViews(
    KalenderViewAnimation switchAnimation,
    ViewController? outgoing,
    Animation<double>? animation,
  ) {
    final incomingArea = _areas[_viewController] ??= ViewSwitchAreaHolder();
    if (outgoing == null || animation == null) {
      return [_animatedView(switchAnimation, kAlwaysCompleteAnimation, _viewController, incoming: true)];
    }
    final outgoingArea = _areas[outgoing] ??= ViewSwitchAreaHolder();
    final columnsOnly =
        outgoing.viewConfiguration is MultiDayViewConfiguration &&
        _viewController.viewConfiguration is MultiDayViewConfiguration;
    if (!columnsOnly) {
      return [
        _animatedView(
          switchAnimation,
          animation,
          outgoing,
          incoming: false,
          clipTo: incomingArea,
          alignArea: outgoingArea,
          clipToBody: true,
        ),
        _animatedView(switchAnimation, animation, _viewController, incoming: true),
      ];
    }
    return [
      _animatedView(switchAnimation, kAlwaysCompleteAnimation, _viewController, incoming: true),
      _animatedView(
        switchAnimation,
        animation,
        outgoing,
        incoming: false,
        clipTo: incomingArea,
        alignArea: outgoingArea,
        zoom: false,
      ),
    ];
  }

  /// The view of [viewController] with its body in [switchAnimation]. The outgoing view takes no input and has no
  /// semantics.
  ///
  /// Every view has the same widget shape, so a view keeps its state when it turns from incoming to outgoing.
  Widget _animatedView(
    KalenderViewAnimation switchAnimation,
    Animation<double> animation,
    ViewController viewController, {
    required bool incoming,
    ViewSwitchAreaHolder? clipTo,
    ViewSwitchAreaHolder? alignArea,
    bool clipToBody = false,
    bool zoom = true,
  }) {
    return KeyedSubtree(
      key: ObjectKey(viewController),
      child: ClipToViewSwitchArea(
        holder: clipTo,
        align: alignArea,
        body: clipToBody,
        child: IgnorePointer(
          ignoring: !incoming,
          child: ExcludeSemantics(
            excluding: !incoming,
            child: ViewSwitchAreaScope(
              holder: _areas[viewController] ??= ViewSwitchAreaHolder(),
              child: _buildView(
                viewController,
                animateBody: (body) => ViewSwitchArea(
                  kind: ViewSwitchAreaKind.body,
                  child: switchAnimation.build(animation, body, incoming: incoming, zoom: zoom),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The header and body of [viewController], with the body wrapped in [animateBody] when given.
  Widget _buildView(ViewController viewController, {Widget Function(Widget body)? animateBody}) {
    final parts = _partsFor(viewController.viewConfiguration);
    final header = parts?.header ?? parts?.builtInHeader;
    final body = parts?.body ?? parts?.builtInBody;
    final headerId = header == null ? null : KalenderLayoutDelegate.header;
    final bodyId = body == null ? null : KalenderLayoutDelegate.body;

    return LocationProvider(
      location: viewController.location,
      child: ViewControllerProvider(
        viewController: viewController,
        child: Builder(
          builder: (context) {
            final widths = parts?.gutterWidths(context);
            return GutterWidths(
              weekNumber: widths?.weekNumber,
              timeline: widths?.timeline,
              child: CustomMultiChildLayout(
                delegate: KalenderLayoutDelegate(headerId, bodyId),
                children: [
                  if (bodyId != null) LayoutId(id: bodyId, child: animateBody?.call(body!) ?? body!),
                  if (headerId != null) LayoutId(id: headerId, child: header!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
