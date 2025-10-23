import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/widgets/calendar_widget.dart';
import 'package:web_demo/widgets/configuration/editor_widgets.dart';
import 'package:web_demo/providers.dart';

class CalendarViewConfiguration extends StatelessWidget {
  final ViewConfiguration viewConfiguration;
  const CalendarViewConfiguration({super.key, required this.viewConfiguration});

  @override
  Widget build(BuildContext context) {
    switch (viewConfiguration.runtimeType) {
      case const (MultiDayViewConfiguration):
        final config = viewConfiguration as MultiDayViewConfiguration;
        return MultiDayViewConfigurationWidget(viewConfiguration: config);
      case const (MonthViewConfiguration):
        final config = viewConfiguration as MonthViewConfiguration;
        return MonthViewConfigurationWidget(viewConfiguration: config);
      case const (ScheduleViewConfiguration):
        final config = viewConfiguration as ScheduleViewConfiguration;
        return ScheduleViewConfigurationWidget(viewConfiguration: config);
      default:
        return const Text("Unknown");
    }
  }
}

class MultiDayViewConfigurationWidget extends StatelessWidget {
  final MultiDayViewConfiguration viewConfiguration;
  const MultiDayViewConfigurationWidget({super.key, required this.viewConfiguration});

  bool get showFirstDay {
    return viewConfiguration.type == MultiDayViewType.week || viewConfiguration.type == MultiDayViewType.singleDay;
  }

  bool get showNumberOfDays {
    return viewConfiguration.type == MultiDayViewType.custom || viewConfiguration.type == MultiDayViewType.freeScroll;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(context.l10n.viewConfigurationTitle(viewConfiguration.name)),
      initiallyExpanded: true,
      children: [
        if (showFirstDay)
          FirstDayOfWeekEditor(
            firstDayOfWeek: viewConfiguration.firstDayOfWeek,
            onChanged: (value) => CalendarWidget.setViewConfiguration(
              context,
              viewConfiguration.copyWith(firstDayOfWeek: value),
            ),
          ),
        if (showNumberOfDays)
          DropDownEditor<int>(
            label: context.l10n.numberOfDays,
            value: viewConfiguration.numberOfDays,
            items: List.generate(7, (index) => index + 1),
            onChanged: (value) => CalendarWidget.setViewConfiguration(
              context,
              viewConfiguration.copyWith(numberOfDays: value),
            ),
            itemToString: (value) => value.toString(),
          ),
        Row(
          children: [
            Flexible(
              child: DropDownEditor<TimeOfDay>(
                label: context.l10n.startTime,
                value: viewConfiguration.timeOfDayRange.start,
                items: List.generate(
                  viewConfiguration.timeOfDayRange.end.hour,
                  (index) => TimeOfDay(hour: index, minute: 0),
                ),
                onChanged: (value) => CalendarWidget.setViewConfiguration(
                  context,
                  viewConfiguration.copyWith(initialTimeOfDay: value),
                ),
                itemToString: (value) => '${value.hour}:${value.minute < 10 ? '00' : value.minute}',
              ),
            ),
            Flexible(
              child: DropDownEditor<TimeOfDay>(
                label: context.l10n.endTime,
                value: viewConfiguration.timeOfDayRange.end,
                items: List.generate(
                  24 - viewConfiguration.timeOfDayRange.start.hour,
                  (index) {
                    var value = index + viewConfiguration.timeOfDayRange.start.hour + 1;
                    var minute = 0;
                    if (value > 23) {
                      value = 23;
                      minute = 59;
                    }
                    return TimeOfDay(hour: value, minute: minute);
                  },
                ),
                onChanged: (value) => CalendarWidget.setViewConfiguration(
                  context,
                  viewConfiguration.copyWith(initialTimeOfDay: value),
                ),
                itemToString: (value) => '${value.hour}:${value.minute < 10 ? '00' : value.minute}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MonthViewConfigurationWidget extends StatelessWidget {
  final MonthViewConfiguration viewConfiguration;
  const MonthViewConfigurationWidget({super.key, required this.viewConfiguration});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(context.l10n.viewConfigurationTitle(viewConfiguration.name)),
      initiallyExpanded: true,
      children: [
        FirstDayOfWeekEditor(
          firstDayOfWeek: viewConfiguration.firstDayOfWeek,
          onChanged: (value) => CalendarWidget.setViewConfiguration(
            context,
            viewConfiguration.copyWith(firstDayOfWeek: value),
          ),
        ),
      ],
    );
  }
}

class ScheduleViewConfigurationWidget extends StatelessWidget {
  final ScheduleViewConfiguration viewConfiguration;
  const ScheduleViewConfigurationWidget({super.key, required this.viewConfiguration});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(context.l10n.viewConfigurationTitle(viewConfiguration.name)),
      initiallyExpanded: true,
      children: [
        Text(context.l10n.noViewConfigurationOptions),
      ],
    );
  }
}
