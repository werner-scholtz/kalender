import 'package:example/shortcuts/intents.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// An action that navigates to the previous page.
class PreviousPageAction extends Action<LeftArrowIntent> {
  PreviousPageAction(
    this.controller,
  );

  final CalendarController controller;

  @override
  Object? invoke(covariant LeftArrowIntent intent) {
    controller.animateToPreviousPage();
    return null;
  }
}

/// An action that navigates to the next page.
class NextPageAction extends Action<RightArrowIntent> {
  NextPageAction(
    this.controller,
  );

  final CalendarController controller;

  @override
  Object? invoke(covariant RightArrowIntent intent) {
    controller.animateToNextPage();

    return null;
  }
}

/// An action that zooms in the calendar.
class ZoomInAction extends Action<ZoomInIntent> {
  ZoomInAction(
    this.controller,
  );

  final CalendarController controller;

  @override
  Object? invoke(covariant ZoomInIntent intent) {
    double newHeihtPerMinute = (controller.heightPerMinute?.value ?? 0.7) - 0.1;
    if (newHeihtPerMinute < 0.3) {
      newHeihtPerMinute = 0.3;
    }

    controller.adjustHeightPerMinute(newHeihtPerMinute);
    return null;
  }
}

/// An action that zooms out the calendar.
class ZoomOutAction extends Action<ZoomOutIntent> {
  ZoomOutAction(
    this.controller,
  );

  final CalendarController controller;

  @override
  Object? invoke(covariant ZoomOutIntent intent) {
    double newHeihtPerMinute = (controller.heightPerMinute?.value ?? 0.7) + 0.1;
    if (newHeihtPerMinute > 2.0) {
      newHeihtPerMinute = 2.0;
    }
    controller.adjustHeightPerMinute(newHeihtPerMinute);
    return null;
  }
}
