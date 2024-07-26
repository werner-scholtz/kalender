import 'package:flutter/material.dart';

/// The configuration for the page triggers.
///
/// The page triggers are used to navigate between pages when the user is dragging a event.
class PageTriggerConfiguration {
  PageTriggerConfiguration({
    this.triggerDelay = const Duration(milliseconds: 750),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    double Function(double pageWidth)? triggerWidth,
  }) {
    assert(
      animationDuration <= triggerDelay,
      'The animation duration must be less or equal to the page trigger delay.',
    );
  }

  /// The widget that is rendered above the top page trigger.
  Duration triggerDelay;

  /// The duration of the page animation.
  Duration animationDuration;

  /// The curve of the page animation.
  Curve animationCurve;

  /// Creates a copy of this [PageTriggerConfiguration] but with the given fields replaced with the new values.
  PageTriggerConfiguration copyWith({
    Duration? triggerDelay,
    Duration? animationDuration,
    Curve? animationCurve,
    double Function(double pageWidth)? triggerWidth,
  }) {
    return PageTriggerConfiguration(
      triggerDelay: triggerDelay ?? this.triggerDelay,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PageTriggerConfiguration &&
        other.triggerDelay == triggerDelay &&
        other.animationDuration == animationDuration &&
        other.animationCurve == animationCurve;
  }

  @override
  int get hashCode {
    return Object.hash(
      triggerDelay,
      animationDuration,
      animationCurve,
    );
  }
}

/// The configuration for the scroll triggers.
///
/// The scroll triggers are used to scroll the view when the user is dragging an event.
class ScrollTriggerConfiguration {
  ScrollTriggerConfiguration({
    this.triggerDelay = const Duration(milliseconds: 750),
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    double Function(double pageWidth)? triggerHeight,
    double Function(double pageHeight)? scrollAmount,
  }) {
    assert(
      animationDuration <= triggerDelay,
      'The animation duration must be less or equal to the page trigger delay.',
    );
    this.triggerHeight = triggerHeight ?? (pageHeight) => pageHeight / 20;
    this.scrollAmount = scrollAmount ?? (pageHeight) => pageHeight / 2.5;
  }

  /// The delay before the scroll trigger is activated.
  Duration triggerDelay;

  /// The duration of the scroll animation.
  Duration animationDuration;

  /// The curve of the scroll animation.
  Curve animationCurve;

  /// Calculation used to determine the height of the trigger.
  late double Function(double pageHeight) triggerHeight;

  /// The delta used to scroll the view.
  late double Function(double pageHeight) scrollAmount;

  /// Creates a copy of this [ScrollTriggerConfiguration] but with the given fields replaced with the new values.
  ScrollTriggerConfiguration copyWith({
    Duration? triggerDelay,
    Duration? animationDuration,
    Curve? animationCurve,
    double Function(double pageHeight)? triggerHeight,
  }) {
    return ScrollTriggerConfiguration(
      triggerDelay: triggerDelay ?? this.triggerDelay,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      triggerHeight: triggerHeight ?? this.triggerHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScrollTriggerConfiguration &&
        other.triggerDelay == triggerDelay &&
        other.animationDuration == animationDuration &&
        other.animationCurve == animationCurve &&
        other.triggerHeight == triggerHeight;
  }

  @override
  int get hashCode {
    return Object.hash(
      triggerDelay,
      animationDuration,
      animationCurve,
      triggerHeight,
    );
  }
}
