import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/month_week_number_layout_delegate.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/drag_targets/horizontal_drag_target.dart';
import 'package:kalender/src/widgets/draggable/multi_day_draggable.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:kalender/src/widgets/internal_components/month_week_number_gutter.dart';
import 'package:kalender/src/widgets/internal_components/week_day_headers.dart';

/// This widget is used to display a month body.
///
/// The month body's content:
///   - Static content [MonthGrid].
///   - Dynamic content such as the [PageView] which renders [MultiDayEventWidget], [HorizontalDragTarget], [MultiDayDraggable].
class MonthBody extends StatelessWidget {
  /// The [MultiDayBodyConfiguration] that will be used by the [MonthBody].
  final HorizontalConfiguration? configuration;

  /// Creates a new [MonthBody].
  const MonthBody({super.key, this.configuration});

  @override
  Widget build(BuildContext context) {
    final calendarController = context.calendarController;

    assert(
      calendarController.viewController is MonthViewController,
      'The KalenderController\'s $ViewController needs to be a $MonthViewController',
    );

    if (this.configuration != null && this.configuration is! MonthBodyConfiguration) {
      debugPrint('Warning: The configuration provided to the $MonthBody is not a $MonthBodyConfiguration.');
    }

    final viewController = calendarController.viewController as MonthViewController;
    final viewConfiguration = viewController.viewConfiguration;
    final showWeekNumbers = viewConfiguration.showWeekNumbers;
    final configuration = this.configuration ?? const MonthBodyConfiguration();
    final pageNavigation = viewConfiguration.pageIndexCalculator;
    final components = context.components;
    final monthComponents = components.monthComponents;
    final monthGridStyle = KalenderTheme.of(context).monthGridStyle ?? const MonthGridStyle();
    final dividerSide = BorderSide(
      // Never null: KalenderThemeData.defaults always sets it, which a test pins.
      color: monthGridStyle.color!,
      width: monthGridStyle.thickness ?? 0,
    );

    return PageView.builder(
      controller: viewController.pageController,
      itemCount: pageNavigation.numberOfPages(context.location),
      onPageChanged: (index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index, context.location);
        final controller = context.calendarController;
        controller.internalDateTimeRange.value = visibleRange;
        context.callbacks?.onPageChanged?.call(controller.visibleDateTimeRange.value!);
      },
      itemBuilder: (context, index) {
        final visibleRange = pageNavigation.dateTimeRangeFromIndex(index, context.location);
        final numberOfRows = pageNavigation.numberOfRowsForRange(visibleRange);
        final grid = monthComponents.bodyComponents.buildMonthGrid(context, numberOfRows);

        // The date range of each week row, shared by the content and background.
        final weekRanges = List.generate(numberOfRows, (row) {
          final start = visibleRange.start.add(Duration(days: row * DateTime.daysPerWeek));
          return InternalDateTimeRange(start: start, end: start.add(const Duration(days: DateTime.daysPerWeek)));
        });

        final content = Column(
          children: [
            for (final weekRange in weekRanges)
              Expanded(
                child: MonthWeek(
                  key: ValueKey('MonthWeek-${weekRange.start.toIso8601String()}'),
                  internalRange: weekRange,
                  configuration: configuration,
                  viewController: viewController,
                ),
              ),
          ],
        );

        // Only build the per-day background when a custom cell builder is set, so
        // the default month view does no extra per-cell work. It is painted below
        // the grid (see the layout delegate) so cell backgrounds do not cover the
        // grid lines.
        final hasCellBuilder = monthComponents.bodyComponents.monthDayCellBuilder != null;
        final background = hasCellBuilder
            ? _MonthDayCellBackground(
                weekRanges: weekRanges,
                focusMonthStart: pageNavigation.monthStartFromIndex(index, context.location),
              )
            : null;

        return CustomMultiChildLayout(
          delegate: MonthWeekNumberBodyLayoutDelegate(
            gutterId: showWeekNumbers ? 0 : null,
            backgroundId: background != null ? 3 : null,
            gridId: 1,
            contentId: 2,
            textDirection: Directionality.of(context),
          ),
          children: [
            if (showWeekNumbers)
              LayoutId(
                id: 0,
                child: MonthWeekNumberGutter(
                  visibleRange: visibleRange,
                  numberOfRows: numberOfRows,
                  weekNumberBuilder: monthComponents.bodyComponents.buildWeekNumber,
                  dividerSide: dividerSide,
                ),
              ),
            if (background != null) LayoutId(id: 3, child: background),
            LayoutId(id: 1, child: grid),
            LayoutId(id: 2, child: content),
          ],
        );
      },
    );
  }
}

/// A single week in the month view.
///
/// It contains the [WeekDayHeaders], the [MultiDayEventWidget], the [HorizontalDragTarget] and the [MultiDayDraggable].
class MonthWeek extends StatelessWidget {
  final InternalDateTimeRange internalRange;
  final HorizontalConfiguration configuration;
  final ViewController viewController;
  const MonthWeek({
    super.key,
    required this.internalRange,
    required this.configuration,
    required this.viewController,
  });

  @override
  Widget build(BuildContext context) {
    final components = context.components;
    final monthComponents = components.monthComponents;

    return Stack(
      children: [
        Positioned.fill(
          child: MultiDayDraggable(
            key: ValueKey('MultiDayDraggable-${internalRange.start.toIso8601String()}'),
            internalRange: internalRange,
          ),
        ),
        Positioned.fill(
          child: Column(
            children: [
              WeekDayHeaders(
                dates: internalRange.dates(),
                dayHeaderBuilder: (context, date) => context.components.monthComponents.bodyComponents
                    .buildMonthDayHeader(context, date.forLocation(location: context.location)),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Subtract 1 to account for the extra widget at the bottom.
                    // Clamp to 0 so a very small row height never produces a negative value,
                    // which would cause spurious overflow buttons.
                    final maxNumberOfVerticalEvents = ((constraints.maxHeight / configuration.tileHeight).floor() - 1)
                        .clamp(0, double.maxFinite)
                        .toInt();

                    return MultiDayEventWidget(
                      eventsController: context.eventsController,
                      internalDateTimeRange: internalRange,
                      configuration: configuration,
                      maxNumberOfVerticalEvents: maxNumberOfVerticalEvents,
                      multiDayCache: viewController.multiDayCache,
                      overlayBuilders: monthComponents.bodyComponents.overlayBuilders ?? components.overlayBuilders,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: HorizontalDragTarget(
            visibleDateTimeRange: internalRange,
            configuration: configuration,
            leftPageTrigger: components.monthComponents.bodyComponents.leftTriggerBuilder,
            rightPageTrigger: components.monthComponents.bodyComponents.rightTriggerBuilder,
          ),
        ),
      ],
    );
  }
}

/// A non-interactive background layer that renders one [MonthDayCell] per day.
///
/// Built only when a custom [MonthBodyComponents.monthDayCellBuilder] is set, and
/// painted below the grid and the day content so cell styling sits behind them.
class _MonthDayCellBackground extends StatelessWidget {
  final List<InternalDateTimeRange> weekRanges;
  final InternalDateTime focusMonthStart;

  const _MonthDayCellBackground({required this.weekRanges, required this.focusMonthStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final weekRange in weekRanges)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final date in weekRange.dates())
                  Expanded(
                    child: Builder(
                      builder: (context) => context.components.monthComponents.bodyComponents.buildMonthDayCell(
                        context,
                        MonthDayCellDetails(
                          date: date.forLocation(location: context.location),
                          isToday: context.isToday(date),
                          isInFocusedMonth: date.month == focusMonthStart.month && date.year == focusMonthStart.year,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
