import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:linked_pageview/linked_pageview.dart';

class MultiDayViewController extends ViewController {
  MultiDayViewController({
    required this.viewConfiguration,
    required super.visibleDateTimeRange,
    required this.visibleEvents,
    InternalDateTime? initialDate,
    super.location,
  }) {
    final pageIndexCalculator = viewConfiguration.pageIndexCalculator;
    final now = InternalDateTime.fromDateTime(location == null ? DateTime.now() : TZDateTime.now(location!));
    initialPage = pageIndexCalculator.indexFromDate(initialDate ?? now, location);
    final type = viewConfiguration.type;
    final viewPortFraction = type == MultiDayViewType.freeScroll ? 1 / viewConfiguration.numberOfDays : 1.0;

    pageController = _controllerGroup.create(viewportFraction: viewPortFraction, initialPage: initialPage);
    headerController = _controllerGroup.create(viewportFraction: viewPortFraction, initialPage: initialPage);

    numberOfPages = pageIndexCalculator.numberOfPages(location);
    heightPerMinute = ValueNotifier<double>(viewConfiguration.initialHeightPerMinute);

    final range = pageIndexCalculator.dateTimeRangeFromIndex(initialPage, location);

    if (type == MultiDayViewType.freeScroll) {
      visibleDateTimeRange.value = InternalDateTimeRange(
        start: range.start,
        end: range.start.addDays(viewConfiguration.numberOfDays),
      );
    } else {
      visibleDateTimeRange.value = range;
    }

    // Calculate the scroll offset so that the initialTimeOfDay is aligned with the top.
    final initialTimeOfDay = viewConfiguration.initialTimeOfDay.toDateTime(now);
    final dayStart = viewConfiguration.timeOfDayRange.start.toDateTime(now);
    final timeDifference = initialTimeOfDay.difference(dayStart);
    final initialScrollOffset = timeDifference.inMinutes * (heightPerMinute.value);
    scrollController = ScrollController(initialScrollOffset: initialScrollOffset);

    visibleEvents.value = {};

    pageController.addListener(_offsetListener);
  }

  @override
  final MultiDayViewConfiguration viewConfiguration;

  /// The initial page of the view.
  late final int initialPage;

  /// The number of pages in the view.
  late final int numberOfPages;

  /// The linked page controller group used to link the header and body controllers.
  final _controllerGroup = LinkedPageControllerGroup();

  /// The page controller used by the view.
  late final LinkedPageController pageController;

  /// The page controller used by the header. (Linked to [pageController])
  late final LinkedPageController headerController;

  /// The scroll controller used by the view.
  late ScrollController scrollController;

  /// The height per minute of the view.
  late ValueNotifier<double> heightPerMinute;

  /// The page offset of the view.
  /// This is a value notifier that updates when the page is scrolled.
  ValueNotifier<double> pageOffset = ValueNotifier<double>(0.0);

  @override
  final ValueNotifier<Set<CalendarEvent>> visibleEvents;

  void _offsetListener() =>
      pageOffset.value = pageController.position.pixels / pageController.position.viewportDimension;

  @override
  Future<void> animateToDate(
    DateTime date, {
    Duration? duration,
    Curve? curve,
  }) async {
    // Calculate the pageNumber of the date.
    final pageNumber = viewConfiguration.pageIndexCalculator.indexFromDate(date, location);

    // Animate to that page.
    return pageController.animateToPage(
      pageNumber,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToDateTime(
    DateTime date, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
  }) async {
    // Animate to the date.
    await animateToDate(date, duration: pageDuration, curve: pageCurve);

    final internalDate = InternalDateTime.fromDateTime(date.forLocation(location: location));
    final startOfDay = viewConfiguration.timeOfDayRange.start.toDateTime(internalDate);
    final timeDifference = internalDate.difference(startOfDay);
    final timeOffset = timeDifference.inMinutes * (heightPerMinute.value);

    // Animate to the offset of the time.
    return scrollController.animateTo(
      timeOffset,
      duration: scrollDuration ?? const Duration(milliseconds: 300),
      curve: scrollCurve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToEvent(
    CalendarEvent event, {
    Duration? pageDuration,
    Curve? pageCurve,
    Duration? scrollDuration,
    Curve? scrollCurve,
    bool centerEvent = true,
  }) async {
    final DateTime date;
    final eventCenter = event.internalStart(location: location).add(Duration(minutes: event.duration.inMinutes ~/ 2));
    final halfViewPortHeight = scrollController.position.viewportDimension ~/ 2;
    final duration = Duration(minutes: halfViewPortHeight ~/ heightPerMinute.value);
    final target = InternalDateTime.fromDateTime(eventCenter.subtract(duration));

    // It is important to check if the target is in the same day as the event start.
    // If it is, we can use the local time of the target, otherwise we use the event start.
    // This prevents the view from moving to the previous day if the event starts at midnight.
    if (target.isSameDay(event.internalStart(location: location))) {
      date = target.asLocal;
    } else {
      date = event.start;
    }

    return animateToDateTime(
      date,
      pageDuration: pageDuration,
      pageCurve: pageCurve,
      scrollDuration: scrollDuration,
      scrollCurve: scrollCurve,
    );
  }

  @override
  Future<void> animateToNextPage({Duration? duration, Curve? curve}) {
    return pageController.nextPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> animateToPreviousPage({Duration? duration, Curve? curve}) {
    return pageController.previousPage(
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void jumpToDate(DateTime date) {
    final pageNumber = viewConfiguration.pageIndexCalculator.indexFromDate(date, location);
    jumpToPage(pageNumber);
  }

  @override
  void jumpToPage(int page) => pageController.jumpToPage(page);

  @override
  String toString() {
    return '${runtimeType.toString()} (${viewConfiguration.runtimeType})';
  }

  @override
  void dispose() {
    pageController.dispose();
    headerController.dispose();
    pageController.removeListener(_offsetListener);
    _controllerGroup.dispose();
    scrollController.dispose();
  }
}
