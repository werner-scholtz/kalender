// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

/// An [OverlayPortalController] whose [show] and [hide] go through [KalenderController.openDayOverlay].
///
/// Without [openDayOverlay] it behaves as a plain [OverlayPortalController].
class DayOverlayController extends OverlayPortalController {
  DayOverlayController(this.date);

  /// The day this controller opens.
  FloatingDateTime date;

  /// The notifier that [show] and [hide] write to.
  ValueNotifier<FloatingDateTime?>? openDayOverlay;

  @override
  void show() {
    final notifier = openDayOverlay;
    if (notifier == null || notifier.value == date) return super.show();
    notifier.value = date;
  }

  @override
  void hide() {
    final notifier = openDayOverlay;
    if (notifier == null) return super.hide();
    if (notifier.value == date) notifier.value = null;
  }

  void _open() => super.show();

  void _close() => super.hide();
}

/// Keeps a [DayOverlayController] in step with [KalenderController.openDayOverlay].
mixin DayOverlayState<T extends StatefulWidget> on State<T> {
  /// The day of the overlay.
  FloatingDateTime get overlayDate;

  /// Whether the overlay opens and closes through the calendar controller.
  bool get followsKalenderController => true;

  late final portalController = DayOverlayController(overlayDate);

  KalenderController? _kalenderController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = followsKalenderController
        ? context.dependOnInheritedWidgetOfExactType<KalenderControllerProvider>()?.notifier
        : null;
    if (controller == _kalenderController) return;

    _kalenderController?.openDayOverlay.removeListener(_sync);
    _kalenderController = controller;
    controller?.openDayOverlay.addListener(_sync);
    portalController.openDayOverlay = controller?.openDayOverlay;
    if (controller != null) _afterFrame(_sync);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = portalController.date;
    if (previous == overlayDate) return;

    portalController.date = overlayDate;
    if (portalController.isShowing) _closeAfterFrame(previous);
  }

  @override
  void dispose() {
    final controller = _kalenderController;
    controller?.openDayOverlay.removeListener(_sync);
    if (controller?.openDayOverlay.value == portalController.date) _closeAfterFrame(portalController.date);
    super.dispose();
  }

  void _sync() {
    final open = _kalenderController?.openDayOverlay.value == portalController.date;
    if (open == portalController.isShowing) return;
    open ? portalController._open() : portalController._close();
  }

  /// Runs [callback] once the frame is done. The portal cannot open or close while the tree is built.
  void _afterFrame(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  /// Closes the overlay of [date] once the frame is done.
  void _closeAfterFrame(FloatingDateTime date) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = _kalenderController;
      if (controller != null && controller.openDayOverlay.value == date) return controller.hideDayOverlay();
      if (mounted && portalController.isShowing) portalController._close();
    });
  }
}

/// Marks the output of an [OverlayBuilders.multiDayOverlayPortalBuilder].
///
/// A [MultiDayOverlayPortal] below it keeps its own overlay, since the day already has a [DayOverlayAnchor].
class CustomOverlayPortalScope extends InheritedWidget {
  const CustomOverlayPortalScope({super.key, required super.child});

  /// Whether [context] is below a [CustomOverlayPortalScope].
  static bool isIn(BuildContext context) => context.getInheritedWidgetOfExactType<CustomOverlayPortalScope>() != null;

  @override
  bool updateShouldNotify(CustomOverlayPortalScope oldWidget) => false;
}

/// The overlay of a day without a built-in "+N more" button, opened through [KalenderController.showDayOverlay].
class DayOverlayAnchor extends StatefulWidget {
  const DayOverlayAnchor({
    super.key,
    required this.date,
    required this.events,
    required this.tileHeight,
    required this.getMultiDayEventLayoutRenderBox,
    required this.overlayTileBuilder,
    required this.overlayBuilders,
  });

  /// The day of the overlay.
  final FloatingDateTime date;

  /// The events of the day, read when the overlay is built.
  final ValueGetter<List<KalenderEvent>> events;

  /// The height of a tile.
  final double tileHeight;

  /// Returns the [RenderBox] of the `MultiDayEventLayoutWidget`.
  final RenderBoxCallback getMultiDayEventLayoutRenderBox;

  /// The builder for the overlay event tiles.
  final MultiDayOverlayEventTileBuilder overlayTileBuilder;

  /// The builders for the overlay.
  final OverlayBuilders? overlayBuilders;

  @override
  State<DayOverlayAnchor> createState() => _DayOverlayAnchorState();
}

class _DayOverlayAnchorState extends State<DayOverlayAnchor> with DayOverlayState<DayOverlayAnchor> {
  @override
  FloatingDateTime get overlayDate => widget.date;

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: portalController,
      overlayChildBuilder: (overlayContext) => buildDayOverlay(
        overlayContext,
        date: widget.date,
        events: widget.events(),
        tileHeight: widget.tileHeight,
        portalController: portalController,
        overlayTileBuilder: widget.overlayTileBuilder,
        getMultiDayEventLayoutRenderBox: widget.getMultiDayEventLayoutRenderBox,
        getOverlayPortalRenderBox: () => context.findRenderObject() as RenderBox,
        overlayBuilders: widget.overlayBuilders,
      ),
      child: const SizedBox.shrink(),
    );
  }
}

/// Builds the overlay card from [OverlayBuilders.multiDayOverlayBuilder], or the default [MultiDayOverlay].
Widget buildDayOverlay(
  BuildContext context, {
  required FloatingDateTime date,
  required List<KalenderEvent> events,
  required double tileHeight,
  required OverlayPortalController portalController,
  required MultiDayOverlayEventTileBuilder overlayTileBuilder,
  required RenderBoxCallback getMultiDayEventLayoutRenderBox,
  required RenderBoxCallback getOverlayPortalRenderBox,
  required OverlayBuilders? overlayBuilders,
}) {
  return overlayBuilders?.multiDayOverlayBuilder?.call(
        context,
        date: date,
        events: events,
        tileHeight: tileHeight,
        portalController: portalController,
        overlayTileBuilder: overlayTileBuilder,
        getMultiDayEventLayoutRenderBox: getMultiDayEventLayoutRenderBox,
        getOverlayPortalRenderBox: getOverlayPortalRenderBox,
      ) ??
      MultiDayOverlay(
        key: MultiDayOverlay.getKey(date),
        date: date,
        events: events,
        tileHeight: tileHeight,
        portalController: portalController,
        overlayTileBuilder: overlayTileBuilder,
        getMultiDayEventLayoutRenderBox: getMultiDayEventLayoutRenderBox,
        getOverlayPortalRenderBox: getOverlayPortalRenderBox,
      );
}
