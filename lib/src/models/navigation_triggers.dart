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
  }) : assert(
          animationDuration <= triggerDelay,
          'The animation duration must be less or equal to the page trigger delay.',
        );

  const PageTriggerConfiguration.defaultConfiguration()
      : triggerDelay = const Duration(milliseconds: 750),
        animationDuration = const Duration(milliseconds: 300),
        animationCurve = Curves.easeInOut;

  /// The widget that is rendered above the top page trigger.
  final Duration triggerDelay;

  /// The duration of the page animation.
  final Duration animationDuration;

  /// The curve of the page animation.
  final Curve animationCurve;

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
    this.triggerHeight,
    this.scrollAmount,
  }) : assert(
          animationDuration <= triggerDelay,
          'The animation duration must be less or equal to the page trigger delay.',
        );

  const ScrollTriggerConfiguration.defaultConfiguration()
      : triggerDelay = const Duration(milliseconds: 750),
        animationDuration = const Duration(milliseconds: 200),
        animationCurve = Curves.easeInOut,
        triggerHeight = null,
        scrollAmount = null;

  /// The delay before the scroll trigger is activated.
  final Duration triggerDelay;

  /// The duration of the scroll animation.
  final Duration animationDuration;

  /// The curve of the scroll animation.
  final Curve animationCurve;

  /// Calculation used to determine the height of the trigger.
  final double Function(double pageHeight)? triggerHeight;

  /// The delta used to scroll the view.
  final double Function(double pageHeight)? scrollAmount;

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
