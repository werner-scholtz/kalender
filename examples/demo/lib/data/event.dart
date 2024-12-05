import 'dart:ui';

class Event {
  const Event({required this.title, this.description, this.color});

  /// The title of the [Event].
  final String title;

  /// The description of the [Event].
  final String? description;

  /// The color of the [Event].
  final Color? color;

  Event copyWith({String? title, String? description, Color? color}) {
    return Event(
      title: title ?? this.title,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }
}
