// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:kalender/kalender.dart';

mixin SnapPoints {
  /// A list of possible [DateTime] snap points that the event can snap to.
  final List<FloatingDateTime> _snapPoints = [];
  List<FloatingDateTime> get snapPoints => _snapPoints.toList();

  /// Get the closest snap point to the [dateTime] within a [snapRange].
  FloatingDateTime? findSnapPoint(FloatingDateTime dateTime, Duration snapRange) {
    if (_snapPoints.isEmpty) return null;

    final closest = _snapPoints.reduce((a, b) => (a.difference(dateTime).abs() < b.difference(dateTime).abs()) ? a : b);

    if (closest.difference(dateTime).abs() > snapRange) return null;
    return closest;
  }

  /// Update the snap points from the [events].
  void addEventSnapPoints(Set<KalenderEvent> events, Location? location) {
    for (final event in events) {
      _snapPoints.addAll([event.floatingStart(location: location), event.floatingEnd(location: location)]);
    }
  }

  /// Add a [FloatingDateTime] snap point.
  void addSnapPoint(FloatingDateTime dateTime) {
    _snapPoints.add(dateTime);
  }

  /// Remove a [FloatingDateTime] snap point.
  void removeSnapPoint(FloatingDateTime dateTime) {
    _snapPoints.remove(dateTime);
  }

  void clearSnapPoints() {
    _snapPoints.clear();
  }
}
