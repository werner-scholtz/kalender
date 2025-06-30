import 'package:flutter/material.dart';

class LocaleProvider extends InheritedWidget {
  /// The locale used for internationalization.
  final dynamic locale;

  // TODO: timezone support allow people to provide a timezone.

  const LocaleProvider({
    super.key,
    required this.locale,
    required super.child,
  });

  static dynamic of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
    assert(result != null, 'No LocaleProvider found in context.');
    return result?.locale;
  }

  @override
  bool updateShouldNotify(covariant LocaleProvider oldWidget) {
    return locale != oldWidget.locale;
  }
}
