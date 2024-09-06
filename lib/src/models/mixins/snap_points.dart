import 'package:kalender/kalender.dart';

/// A mixin that adds snap points to a class.
mixin SnapPoints {
  /// A list of possible [DateTime] snap points that the event can snap to.
  final List<DateTime> _snapPoints = [];

  /// Get the closest snap point to the [dateTime] within a [snapRange].
  DateTime? findSnapPoint(DateTime dateTime, Duration snapRange) {
    // Find the index of the snap point that is within a duration of snapRange of the start.
    final index = _snapPoints.indexWhere(
      (point) => point.difference(dateTime).abs() <= snapRange,
    );

    // If the index is not -1 and the snap point is before the end, snap to the snap point.
    if (index != -1) return _snapPoints[index];
    return null;
  }

  /// Update the snap points from the [events].
  void addEventSnapPoints(Set<CalendarEvent> events) {
    // Add the start and end of each event to the snap points.
    for (final event in events) {
      _snapPoints.addAll([event.start, event.end]);
    }
  }

  /// Add a [DateTime] snap point.
  void addSnapPoint(DateTime dateTime) {
    _snapPoints.add(dateTime);
  }

  /// Remove a [DateTime] snap point.
  void removeSnapPoint(DateTime dateTime) {
    _snapPoints.remove(dateTime);
  }

  void clearSnapPoints() {
    _snapPoints.clear();
  }
}
