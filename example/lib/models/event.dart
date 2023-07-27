import 'package:flutter/material.dart';

class Event extends ChangeNotifier {
  Event({
    required String title,
    String? description,
    Color? color,
  }) {
    _title = title;
    _description = description;
    _tileColor = color;
  }

  /// The title of the [Event].
  late String _title;
  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  /// The description of the [Event].
  String? _description;
  String? get description => _description;
  set description(String? value) {
    _description = value;
    notifyListeners();
  }

  /// The color of the [Event] tile.
  Color? _tileColor;
  Color? get color => _tileColor;
  set color(Color? value) {
    _tileColor = value;
    notifyListeners();
  }

  Event copyWith({
    String? title,
    String? description,
    Color? color,
  }) {
    return Event(
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  @override
  operator ==(Object other) {
    return other is Event &&
        title == other.title &&
        description == other.description &&
        color == other.color;
  }

  @override
  int get hashCode => Object.hash(title, description, color);
}
