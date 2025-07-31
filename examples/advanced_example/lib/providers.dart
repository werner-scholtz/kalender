import 'package:flutter/material.dart';

class HeightPerMinute extends InheritedNotifier<ValueNotifier<double>> {
  const HeightPerMinute({super.key, required super.notifier, required super.child});

  /// Gets the [HeightPerMinute] of type [T] from the context.
  static double of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<HeightPerMinute>();
    assert(result != null, 'No HeightPerMinuteProvider found.');
    return result!.notifier!.value;
  }

  static set(BuildContext context, double value) {
    final result = context.dependOnInheritedWidgetOfExactType<HeightPerMinute>();
    assert(result != null, 'No HeightPerMinuteProvider found.');
    result!.notifier!.value = value;
  }

  static ValueNotifier<double> notifierOf(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<HeightPerMinute>();
    assert(result != null, 'No HeightPerMinuteProvider found.');
    return result!.notifier!;
  }
}

extension ContextExtensions on BuildContext {
  /// Gets the [HeightPerMinute] from the context.
  double get heightPerMinute => HeightPerMinute.of(this);

  /// Sets the [HeightPerMinute] in the context.
  set heightPerMinute(double value) => HeightPerMinute.set(this, value);

  /// Gets the [HeightPerMinute] notifier from the context.
  ValueNotifier<double> get heightPerMinuteNotifier => HeightPerMinute.notifierOf(this);
}
