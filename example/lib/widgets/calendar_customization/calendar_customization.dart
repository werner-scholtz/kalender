import 'package:example/layout_controllers/day_layout_controller.dart';
import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_customization/day_configuration.dart';
import 'package:example/widgets/calendar_customization/month_configuration.dart';
import 'package:example/widgets/calendar_customization/multi_day_configuration.dart';
import 'package:example/widgets/calendar_customization/theme_tile.dart';
import 'package:example/widgets/calendar_customization/week_configuration.dart';
import 'package:example/widgets/calendar_customization/work_week_configuration.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarCustomization extends StatefulWidget {
  const CalendarCustomization({
    super.key,
    required this.components,
    required this.layoutControllers,
    required this.style,
    required this.onComponentChange,
    required this.onLayoutControllerChange,
    required this.onStyleChange,
    required this.currentConfiguration,
    required this.onConfigurationChange,
  });

  final CalendarComponents components;
  final CalendarLayoutControllers<Event> layoutControllers;
  final CalendarStyle style;
  final ViewConfiguration currentConfiguration;

  final void Function(CalendarComponents components) onComponentChange;
  final void Function(CalendarLayoutControllers<Event> layoutControllers)
      onLayoutControllerChange;
  final void Function(CalendarStyle style) onStyleChange;
  final void Function(ViewConfiguration configuration) onConfigurationChange;

  @override
  State<CalendarCustomization> createState() => _CalendarCustomizationState();
}

class _CalendarCustomizationState extends State<CalendarCustomization> {
  final Color highlightColor = Colors.red;

  bool customLayoutController = false;

  bool highlightCalendarHeader = false;
  bool highlightDaySeperator = false;
  bool highlighthourLine = false;
  bool highlightDayHeader = false;

  bool highlightTimeIndicator = false;
  bool highlightTimeline = false;
  bool highlightWeekNumber = false;
  bool highlightMonthGrid = false;
  bool highlightMonthCellHeaders = false;
  bool highlightMonthHeader = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ThemeTile(),
        if (widget.currentConfiguration is SingleDayViewConfiguration ||
            widget.currentConfiguration is MultiDayViewConfiguration)
          CheckboxListTile.adaptive(
            title: const Text('Custom Layout Controller'),
            value: customLayoutController,
            onChanged: (value) {
              if (value == null) return;
              customLayoutController = value;
              widget.onLayoutControllerChange(
                widget.layoutControllers.copyWith(
                  dayTileLayoutController:
                      value ? _dayTileLayoutController : null,
                ),
              );
            },
          ),
        ExpansionTile(
          title: const Text('Highlight Components'),
          initiallyExpanded: true,
          children: [
            CheckboxListTile.adaptive(
              title: const Text('Calendar Header'),
              value: highlightCalendarHeader,
              onChanged: (value) {
                if (value == null) return;
                highlightCalendarHeader = value;
                widget.onStyleChange(
                  widget.style.copyWith(
                    calendarHeaderBackgroundStyle:
                        CalendarHeaderBackgroundStyle(
                      headerElevation: 5,
                      headerBackgroundColor:
                          value ? highlightColor.withAlpha(100) : null,
                    ),
                  ),
                );
              },
            ),
            if (widget.currentConfiguration is SingleDayViewConfiguration ||
                widget.currentConfiguration is MultiDayViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Day Seperator'),
                value: highlightDaySeperator,
                onChanged: (value) {
                  if (value == null) return;
                  highlightDaySeperator = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                      daySeperatorStyle: DaySeperatorStyle(
                        color: value ? highlightColor : null,
                      ),
                    ),
                  );
                },
              ),
            if (widget.currentConfiguration is SingleDayViewConfiguration ||
                widget.currentConfiguration is MultiDayViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Hour Lines'),
                value: highlighthourLine,
                onChanged: (value) {
                  if (value == null) return;
                  highlighthourLine = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                      hourLineStyle: HourLineStyle(
                        color: value ? highlightColor : null,
                      ),
                    ),
                  );
                },
              ),
            if (widget.currentConfiguration is SingleDayViewConfiguration ||
                widget.currentConfiguration is MultiDayViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Day Header'),
                value: highlightDayHeader,
                onChanged: (value) {
                  if (value == null) return;
                  highlightDayHeader = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                      dayHeaderStyle: DayHeaderStyle(
                        backgroundColor:
                            value ? highlightColor.withAlpha(100) : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
            if (widget.currentConfiguration is SingleDayViewConfiguration ||
                widget.currentConfiguration is MultiDayViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Time Indicator'),
                value: highlightTimeIndicator,
                onChanged: (value) {
                  if (value == null) return;
                  highlightTimeIndicator = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                      timeIndicatorStyle: TimeIndicatorStyle(
                        color: value ? Colors.greenAccent : null,
                      ),
                    ),
                  );
                },
              ),
            if (widget.currentConfiguration is SingleDayViewConfiguration ||
                widget.currentConfiguration is MultiDayViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Timeline'),
                value: highlightTimeline,
                onChanged: (value) {
                  if (value == null) return;
                  highlightTimeline = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                        timelineStyle: TimelineStyle(
                      textStyle: highlightTimeline
                          ? TextStyle(
                              color: highlightColor,
                            )
                          : null,
                    )),
                  );
                },
              ),
            if (widget.currentConfiguration is SingleDayViewConfiguration ||
                widget.currentConfiguration is MultiDayViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Week Number'),
                value: highlightWeekNumber,
                onChanged: (value) {
                  if (value == null) return;
                  highlightWeekNumber = value;
                  widget.onStyleChange(widget.style.copyWith(
                    weekNumberStyle: WeekNumberStyle(
                      visualDensity: value ? VisualDensity.comfortable : null,
                      textStyle: TextStyle(
                        color: value ? highlightColor : null,
                      ),
                    ),
                  ));
                },
              ),
            if (widget.currentConfiguration is MonthViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Month Header'),
                value: highlightMonthHeader,
                onChanged: (value) {
                  if (value == null) return;
                  highlightMonthHeader = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                      monthHeaderStyle: MonthHeaderStyle(
                        textStyle: TextStyle(
                          color: value ? highlightColor : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            if (widget.currentConfiguration is MonthViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Month Cell Header'),
                value: highlightMonthCellHeaders,
                onChanged: (value) {
                  if (value == null) return;
                  highlightMonthCellHeaders = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                      monthCellHeaderStyle: MonthCellHeaderStyle(
                        backgroundColor:
                            value ? highlightColor.withAlpha(100) : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  );
                },
              ),
            if (widget.currentConfiguration is MonthViewConfiguration)
              CheckboxListTile.adaptive(
                title: const Text('Month Grid'),
                value: highlightMonthGrid,
                onChanged: (value) {
                  if (value == null) return;
                  highlightMonthGrid = value;
                  widget.onStyleChange(
                    widget.style.copyWith(
                      monthGridStyle: MonthGridStyle(
                        color: value ? highlightColor : null,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
        const Divider(),
        ExpansionTile(
          initiallyExpanded: true,
          title: const Text('View Configuration'),
          children: [
            if (widget.currentConfiguration is DayConfiguration)
              DayConfiguarionEditor(
                config: widget.currentConfiguration as DayConfiguration,
                onConfigChanged: (newConfig) => widget.onConfigurationChange(
                  newConfig,
                ),
              ),
            if (widget.currentConfiguration is WeekConfiguration)
              WeekConfiguarionEditor(
                config: widget.currentConfiguration as WeekConfiguration,
                onConfigChanged: (newConfig) => widget.onConfigurationChange(
                  newConfig,
                ),
              ),
            if (widget.currentConfiguration is WorkWeekConfiguration)
              WorkWeekConfiguarionEditor(
                config: widget.currentConfiguration as WorkWeekConfiguration,
                onConfigChanged: (newConfig) => widget.onConfigurationChange(
                  newConfig,
                ),
              ),
            if (widget.currentConfiguration is MultiDayConfiguration)
              MultiDayConfiguarionEditor(
                config: widget.currentConfiguration as MultiDayConfiguration,
                onConfigChanged: (newConfig) => widget.onConfigurationChange(
                  newConfig,
                ),
              ),
            if (widget.currentConfiguration is MonthConfiguration)
              MonthConfiguarionEditor(
                config: widget.currentConfiguration as MonthConfiguration,
                onConfigChanged: (newConfig) => widget.onConfigurationChange(
                  newConfig,
                ),
              ),
          ],
        )
      ],
    );
  }

  DayTileLayoutController<Event> _dayTileLayoutController({
    required DateTimeRange visibleDateRange,
    required List<DateTime> visibleDates,
    required double heightPerMinute,
    required double dayWidth,
    required Duration verticalDurationStep,
  }) {
    return ExampleDayTileLayoutController<Event>(
      visibleDateRange: visibleDateRange,
      visibleDates: visibleDates,
      heightPerMinute: heightPerMinute,
      dayWidth: dayWidth,
      verticalDurationStep: verticalDurationStep,
    );
  }
}
