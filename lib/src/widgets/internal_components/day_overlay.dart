// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';

/// An [OverlayPortalController] that opens and closes the overlay of [date] through [openDayOverlay].
class DayOverlayController extends OverlayPortalController {
  DayOverlayController({required this.openDayOverlay, required this.date});

  /// The notifier the calendar's overlays follow.
  final ValueNotifier<FloatingDateTime?> openDayOverlay;

  /// The day this controller opens.
  final FloatingDateTime date;

  @override
  bool get isShowing => openDayOverlay.value == date;

  @override
  void show() => openDayOverlay.value = date;

  @override
  void hide() {
    if (isShowing) openDayOverlay.value = null;
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
