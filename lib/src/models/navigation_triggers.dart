import 'package:flutter/material.dart';

/// The configuration for the page triggers.
///
/// The page triggers are used to navigate between pages when the user is dragging a event.
class PageTriggerConfiguration {
  PageTriggerConfiguration({
    this.leftTriggerWidget,
    this.rightTriggerWidget,
    this.triggerDelay = const Duration(milliseconds: 750),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    double Function(double pageWidth)? triggerWidth,
  }) {
    assert(
      animationDuration <= triggerDelay,
      'The animation duration must be less or equal to the page trigger delay.',
    );
    this.triggerWidth = triggerWidth ?? (pageWidth) => pageWidth / 20;
  }

  /// The widget that is rendered above the left page trigger.
  Widget? leftTriggerWidget;

  // The widget that is rendered above the right page trigger.
  Widget? rightTriggerWidget;

  /// The widget that is rendered above the top page trigger.
  Duration triggerDelay;

  /// The duration of the page animation.
  Duration animationDuration;

  /// The curve of the page animation.
  Curve animationCurve;

  /// Calculation used to determine the width of the trigger.
  late double Function(double pageWidth) triggerWidth;
}

/// The configuration for the scroll triggers.
///
/// The scroll triggers are used to scroll the view when the user is dragging an event.
class ScrollTriggerConfiguration {
  ScrollTriggerConfiguration({
    this.topTriggerWidget,
    this.bottomTriggerWidget,
    this.triggerDelay = const Duration(milliseconds: 750),
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    double Function(double pageWidth)? triggerHeight,
  }) {
    assert(
      animationDuration <= triggerDelay,
      'The animation duration must be less or equal to the page trigger delay.',
    );
    this.triggerHeight = triggerHeight ?? (pageHeight) => pageHeight / 20;
  }

  /// The widget that is rendered above the top scroll trigger.
  Widget? topTriggerWidget;

  // The widget that is rendered above the bottom scroll trigger.
  Widget? bottomTriggerWidget;

  /// The delay before the scroll trigger is activated.
  Duration triggerDelay;

  /// The duration of the scroll animation.
  Duration animationDuration;

  /// The curve of the scroll animation.
  Curve animationCurve;

  /// Calculation used to determine the height of the trigger.
  late double Function(double pageHeight) triggerHeight;
}
