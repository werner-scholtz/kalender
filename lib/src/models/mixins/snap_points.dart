import 'package:kalender/kalender.dart';

/// A mixin that adds snap points to a class.
mixin SnapPoints {
  /// A list of possible [DateTime] snap points that the event can snap to.
  final List<DateTime> _snapPoints = [];
  List<DateTime> get snapPoints => _snapPoints.toList();

  /// Get the closest snap point to the [dateTime] within a [snapRange].
  DateTime? findSnapPoint(DateTime dateTime, Duration snapRange) {
    assert(dateTime.isUtc, 'The DateTime must be in UTC.');

    // Check that the snap points are not empty.
    if (_snapPoints.isEmpty) return null;

    // Find the index of the closest snap point to the dateTime.
    final closest = _snapPoints.reduce(
      (a, b) => (a.difference(dateTime).abs() < b.difference(dateTime).abs()) ? a : b,
    );

    // If the closest snap point is not within the snap range, return null.
    if (closest.difference(dateTime).abs() > snapRange) return null;
    return closest;
  }

  /// Update the snap points from the [events].
  void addEventSnapPoints(Set<CalendarEvent> events) {
    // Add the start and end of each event to the snap points.
    for (final event in events) {
      _snapPoints.addAll([event.internalStart, event.internalEnd]);
    }
  }

  /// Add a [DateTime] snap point.
  void addSnapPoint(DateTime dateTime) {
    assert(dateTime.isUtc, 'The DateTime must be in UTC.');
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
