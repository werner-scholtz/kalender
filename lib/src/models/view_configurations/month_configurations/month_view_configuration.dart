import 'package:kalender/src/enumerations.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';

/// This is the base class for all [MonthViewConfiguration]s.
abstract class MonthViewConfiguration extends ViewConfiguration {
  MonthViewConfiguration({
    bool showHeader = true,
    required Duration verticalStepDuration,
    required Duration horizontalStepDuration,
    required int firstDayOfWeek,
    required bool enableResizing,
    required double multiDayTileHeight,
    required bool createMultiDayEvents,
    required bool enableRescheduling,
    CreateEventTrigger? createEventTrigger,
  }) {
    _verticalStepDuration = verticalStepDuration;
    _horizontalStepDuration = horizontalStepDuration;
    _firstDayOfWeek = firstDayOfWeek;
    _enableResizing = enableResizing;
    _multiDayTileHeight = multiDayTileHeight;
    _createMultiDayEvents = createMultiDayEvents;
    _enableRescheduling = enableRescheduling;
    _createEventTrigger = createEventTrigger ?? CreateEventTrigger.tap;
    _showHeader = showHeader;
  }

  /// The duration of one vertical step.
  late Duration _verticalStepDuration;
  Duration get verticalStepDuration => _verticalStepDuration;
  set verticalStepDuration(Duration value) {
    _verticalStepDuration = value;
    notifyListeners();
  }

  /// The duration of one horizontal step.
  late Duration _horizontalStepDuration;
  Duration get horizontalStepDuration => _horizontalStepDuration;
  set horizontalStepDuration(Duration value) {
    _horizontalStepDuration = value;
    notifyListeners();
  }

  /// The first day of the week.
  late int _firstDayOfWeek;
  int get firstDayOfWeek => _firstDayOfWeek;
  set firstDayOfWeek(int value) {
    _firstDayOfWeek = value;
    notifyListeners();
  }

  /// Whether the events can be resized.
  late bool _enableResizing;
  bool get enableResizing => _enableResizing;
  set enableResizing(bool value) {
    _enableResizing = value;
    notifyListeners();
  }

  /// Enable rescheduling.
  late bool _enableRescheduling;
  bool get enableRescheduling => _enableRescheduling;
  set enableRescheduling(bool value) {
    _enableRescheduling = value;
    notifyListeners();
  }

  /// The height of the multiDay tiles.
  late double _multiDayTileHeight;
  double get multiDayTileHeight => _multiDayTileHeight;
  set multiDayTileHeight(double value) {
    _multiDayTileHeight = value;
    notifyListeners();
  }

  /// Whether new multiDayEvents can be created.
  late bool _createMultiDayEvents;
  bool get createMultiDayEvents => _createMultiDayEvents;
  set createMultiDayEvents(bool value) {
    _createMultiDayEvents = value;
    notifyListeners();
  }

  /// Whether to show the view header or not.
  late bool _showHeader;
  bool get showHeader => _showHeader;
  set showHeader(bool value) {
    _showHeader = value;
    notifyListeners();
  }

  /// Gesture type for creating events.
  late CreateEventTrigger _createEventTrigger;
  CreateEventTrigger get createEventTrigger => _createEventTrigger;
}
