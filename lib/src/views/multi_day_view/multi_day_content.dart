import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/models/calendar/calendar_view_state.dart';
import 'package:kalender/src/providers/calendar_scope.dart';
import 'package:kalender/src/views/multi_day_view/multi_day_page_content.dart';

class MultiDayContent<T> extends StatelessWidget {
  const MultiDayContent({
    super.key,
    required this.controller,
    required this.viewConfiguration,
  });

  final CalendarController<T> controller;
  final MultiDayViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);
    final state = scope.state as MultiDayViewState;

    return ValueListenableBuilder<double>(
      valueListenable: state.heightPerMinute!,
      builder: (context, heightPerMinute, child) {
        final hourHeight = heightPerMinute * minutesAnHour;
        final pageHeight = hourHeight * hoursADay;

        return ValueListenableBuilder<ScrollPhysics>(
          valueListenable: state.scrollPhysics,
          builder: (context, value, child) {
            return SingleChildScrollView(
              controller: (scope.state as MultiDayViewState).scrollController,
              physics: value,
              child: SizedBox(
                height: pageHeight,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      left: viewConfiguration.hourLineLeftOffset,
                      child: scope.components.hourLineBuilder(
                        hourHeight,
                      ),
                    ),
                    Positioned(
                      width: viewConfiguration.timelineWidth,
                      child: scope.components.timelineBuilder(
                        hourHeight,
                      ),
                    ),
                    Positioned.fill(
                      left: viewConfiguration.timelineWidth,
                      child: PageView.builder(
                        key: Key(viewConfiguration.hashCode.toString()),
                        controller: state.pageController,
                        itemCount: state.numberOfPages,
                        clipBehavior: Clip.none,
                        onPageChanged: (index) {
                          final newVisibleDateTimeRange = viewConfiguration
                              .calculateVisibleDateRangeForIndex(
                            index: index,
                            calendarStart:
                                scope.state.adjustedDateTimeRange.start,
                          );
                          // Update the visible date range.
                          scope.state.visibleDateTimeRange =
                              newVisibleDateTimeRange;

                          // Update the selected date.
                          // controller.selectedDate =
                          //     newVisibleDateTimeRange.start;

                          // Call the onPageChanged function.
                          scope.functions.onPageChanged?.call(
                            newVisibleDateTimeRange,
                          );
                        },
                        itemBuilder: (context, index) {
                          final visibleDateRange = viewConfiguration
                              .calculateVisibleDateRangeForIndex(
                            index: index,
                            calendarStart:
                                scope.state.adjustedDateTimeRange.start,
                          );

                          return MultiDayPageContent<T>(
                            viewConfiguration: viewConfiguration,
                            visibleDateRange: visibleDateRange,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
