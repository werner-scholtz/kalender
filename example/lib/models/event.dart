import 'package:flutter/material.dart';

class Event {
  Event({
    required this.title,
    this.description,
    this.color,
  });

  /// The title of the [Event].
  late String title;

  /// The description of the [Event].
  String? description;

  /// The color of the [Event] tile.
  Color? color;

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
