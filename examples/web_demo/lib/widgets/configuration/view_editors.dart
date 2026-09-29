// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/widgets/configuration/editor_widgets.dart';
import 'package:web_demo/utils.dart';

class ViewConfigurationEditor extends StatelessWidget {
  final ViewConfiguration viewConfiguration;
  const ViewConfigurationEditor({super.key, required this.viewConfiguration});

  @override
  Widget build(BuildContext context) {
    switch (viewConfiguration.runtimeType) {
      case const (MultiDayViewConfiguration):
        final config = viewConfiguration as MultiDayViewConfiguration;
        return MultiDayViewEditor(viewConfiguration: config);
      case const (MonthViewConfiguration):
        final config = viewConfiguration as MonthViewConfiguration;
        return MonthViewEditor(viewConfiguration: config);
      case const (ScheduleViewConfiguration):
        final config = viewConfiguration as ScheduleViewConfiguration;
        return ScheduleViewEditor(viewConfiguration: config);
      default:
        return const Text("Unknown");
    }
  }
}

class MultiDayViewEditor extends StatelessWidget {
  final MultiDayViewConfiguration viewConfiguration;
  const MultiDayViewEditor({super.key, required this.viewConfiguration});

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
            onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
              firstDayOfWeek: value,
            ),
          ),
        if (showNumberOfDays)
          DropDownEditor<int>(
            label: context.l10n.numberOfDays,
            value: viewConfiguration.numberOfDays,
            items: List.generate(7, (index) => index + 1),
            onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
              numberOfDays: value,
            ),
            itemToString: (value) => value.toString(),
          ),
        MultiDayRuleEditor(
          multiDayRule: viewConfiguration.multiDayRule,
          onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
            multiDayRule: value,
          ),
        ),
        Row(
          children: [
            Flexible(
              child: DropDownEditor<KalenderTime>(
                label: context.l10n.startTime,
                value: viewConfiguration.timeOfDayRange.start,
                items: List.generate(
                  viewConfiguration.timeOfDayRange.end.hour,
                  (index) => KalenderTime(hour: index, minute: 0),
                ),
                onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
                  initialTimeOfDay: value,
                ),
                itemToString: (value) => '${value.hour}:${value.minute < 10 ? '00' : value.minute}',
              ),
            ),
            Flexible(
              child: DropDownEditor<KalenderTime>(
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
                    return KalenderTime(hour: value, minute: minute);
                  },
                ),
                onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
                  initialTimeOfDay: value,
                ),
                itemToString: (value) => '${value.hour}:${value.minute < 10 ? '00' : value.minute}',
              ),
            ),
          ],
        ),
        DropDownEditor<DateTransition>(
          label: context.l10n.dateOnViewChange,
          value: viewConfiguration.dateTransition,
          items: DateTransition.values,
          onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
            dateTransition: value,
          ),
          itemToString: (value) => _dateTransitionName(context, value),
        ),
        DropDownEditor<ScrollTransition>(
          label: context.l10n.scrollOnViewChange,
          value: viewConfiguration.scrollTransition,
          items: ScrollTransition.values,
          onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
            scrollTransition: value,
          ),
          itemToString: (value) => _scrollTransitionName(context, value),
        ),
        DropDownEditor<ZoomTransition>(
          label: context.l10n.zoomOnViewChange,
          value: viewConfiguration.zoomTransition,
          items: ZoomTransition.values,
          onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
            zoomTransition: value,
          ),
          itemToString: (value) => _zoomTransitionName(context, value),
        ),
      ],
    );
  }
}

class MonthViewEditor extends StatelessWidget {
  final MonthViewConfiguration viewConfiguration;
  const MonthViewEditor({super.key, required this.viewConfiguration});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(context.l10n.viewConfigurationTitle(viewConfiguration.name)),
      initiallyExpanded: true,
      children: [
        FirstDayOfWeekEditor(
          firstDayOfWeek: viewConfiguration.firstDayOfWeek,
          onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
            firstDayOfWeek: value,
          ),
        ),
        SwitchListTile.adaptive(
          value: viewConfiguration.showWeekNumbers,
          onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
            showWeekNumbers: value,
          ),
          title: Text(context.l10n.showWeekNumbers),
        ),
        DropDownEditor<DateTransition>(
          label: context.l10n.dateOnViewChange,
          value: viewConfiguration.dateTransition,
          items: DateTransition.values,
          onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
            dateTransition: value,
          ),
          itemToString: (value) => _dateTransitionName(context, value),
        ),
        MultiDayRuleEditor(
          multiDayRule: viewConfiguration.multiDayRule,
          onChanged: (value) => context.controller.viewConfiguration = viewConfiguration.copyWith(
            multiDayRule: value,
          ),
        ),
      ],
    );
  }
}

class ScheduleViewEditor extends StatelessWidget {
  final ScheduleViewConfiguration viewConfiguration;
  const ScheduleViewEditor({super.key, required this.viewConfiguration});

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

String _dateTransitionName(BuildContext context, DateTransition value) => switch (value) {
      DateTransition.carryFocus => context.l10n.transitionCarryFocus,
      DateTransition.restorePerView => context.l10n.transitionRestorePerView,
    };

String _scrollTransitionName(BuildContext context, ScrollTransition value) => switch (value) {
      ScrollTransition.preserve => context.l10n.transitionPreserve,
      ScrollTransition.reset => context.l10n.transitionReset,
      ScrollTransition.restorePerView => context.l10n.transitionRestorePerView,
    };

String _zoomTransitionName(BuildContext context, ZoomTransition value) => switch (value) {
      ZoomTransition.preserve => context.l10n.transitionPreserve,
      ZoomTransition.reset => context.l10n.transitionReset,
      ZoomTransition.restorePerView => context.l10n.transitionRestorePerView,
    };
