// import 'package:kalender/kalender.dart';
import 'package:kalender/kalender.dart';

/// A mixin that adds snap points to a class.
mixin SnapPoints {
  /// A list of possible [DateTime] snap points that the event can snap to.
  final List<InternalDateTime> _snapPoints = [];
  List<InternalDateTime> get snapPoints => _snapPoints.toList();

  /// Get the closest snap point to the [dateTime] within a [snapRange].
  InternalDateTime? findSnapPoint(InternalDateTime dateTime, Duration snapRange) {
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
  void addEventSnapPoints(Set<CalendarEvent> events, Location? location) {
    // Add the start and end of each event to the snap points.
    for (final event in events) {
      _snapPoints.addAll([event.internalStart(location: location), event.internalEnd(location: location)]);
    }
  }

  /// Add a [InternalDateTime] snap point.
  void addSnapPoint(InternalDateTime dateTime) {
    _snapPoints.add(dateTime);
  }

  /// Remove a [InternalDateTime] snap point.
  void removeSnapPoint(InternalDateTime dateTime) {
    _snapPoints.remove(dateTime);
  }

  void clearSnapPoints() {
    _snapPoints.clear();
  }
}
