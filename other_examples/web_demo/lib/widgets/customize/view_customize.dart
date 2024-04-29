import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class ViewConfigurationCustomize extends StatelessWidget {
  const ViewConfigurationCustomize({
    super.key,
    required this.currentConfiguration,
  });

  final ViewConfiguration currentConfiguration;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: currentConfiguration,
      builder: (context, child) {
        return ExpansionTile(
          title: const Text('View Configuration'),
          initiallyExpanded: true,
          children: [
            if (currentConfiguration is MultiDayViewConfiguration)
              ...multiDayConfig(
                  currentConfiguration as MultiDayViewConfiguration),
            if (currentConfiguration is MonthConfiguration)
              ...monthConfig(currentConfiguration as MonthConfiguration)
          ],
        );
      },
    );
  }

  List<Widget> multiDayConfig(MultiDayViewConfiguration config) {
    return [
      SwitchListTile(
        title: const Text('Enable Rescheduling'),
        value: config.enableRescheduling,
        onChanged: (value) {
          config.enableRescheduling = value;
        },
      ),
      SwitchListTile(
        title: const Text('Enable Resizing'),
        value: config.enableResizing,
        onChanged: (value) {
          config.enableResizing = value;
        },
      ),
      SwitchListTile(
        title: const Text('Enable Snapping'),
        value: config.eventSnapping,
        onChanged: (value) {
          config.eventSnapping = value;
        },
      ),
      SwitchListTile(
        title: const Text('Show Day Header'),
        value: config.showDayHeader,
        onChanged: (value) {
          config.showDayHeader = value;
        },
      ),
      SwitchListTile(
        title: const Text('Show Multi Day Header'),
        value: config.showMultiDayHeader,
        onChanged: (value) {
          config.showMultiDayHeader = value;
        },
      ),
      SwitchListTile(
        title: const Text('Show Week Number'),
        value: config.showWeekNumber,
        onChanged: (value) {
          config.showWeekNumber = value;
        },
      ),
      DropDownBasic(
        label: 'MultiDay tile height',
        items: const [24.0, 48.0],
        initialValue: config.multiDayTileHeight,
        onChanged: (value) {
          config.multiDayTileHeight = value;
        },
      ),
      DropDownBasic(
        label: 'Day separator left offset',
        items: const [8.0, 48.0],
        initialValue: config.daySeparatorLeftOffset,
        onChanged: (value) {
          config.daySeparatorLeftOffset = value;
        },
      ),
      DropDownBasic(
        label: 'Timeline width',
        items: const [56.0, 104.0],
        initialValue: config.timelineWidth,
        onChanged: (value) {
          config.timelineWidth = value;
        },
      ),
      if (config is CustomMultiDayConfiguration)
        DropDownBasic(
          label: 'Number of days',
          items: const [1, 2, 3, 4, 5, 6, 7, 8],
          initialValue: config.numberOfDays,
          onChanged: (value) {
            config.numberOfDays = value;
          },
        ),
      if (config is WeekConfiguration)
        FirstDayOfWeek(
          value: config.firstDayOfWeek,
          onChanged: (value) {
            config.firstDayOfWeek = value;
          },
        ),
      TimeDropDown(
        label: 'Vertical step duration',
        items: const [
          Duration(minutes: 1),
          Duration(minutes: 10),
          Duration(minutes: 15),
        ],
        initialValue: config.verticalStepDuration,
        onChanged: (value) {
          config.verticalStepDuration = value;
        },
      ),
      TimeDropDown(
        label: 'Vertical snap duration range',
        items: const [
          Duration(minutes: 5),
          Duration(minutes: 10),
          Duration(minutes: 15),
        ],
        initialValue: config.verticalSnapRange,
        onChanged: (value) {
          config.verticalSnapRange = value;
        },
      ),
      DropDownBasic(
        label: 'Start hour',
        items: List.generate(5, (index) => index),
        initialValue: config.startHour,
        onChanged: (value) {
          config.startHour = value;
        },
      ),
      DropDownBasic(
        label: 'End hour',
        items: List.generate(5, (index) => 24 - index),
        initialValue: config.endHour,
        onChanged: (value) {
          config.endHour = value;
        },
      ),
    ];
  }

  List<Widget> monthConfig(MonthConfiguration config) {
    return [
      SwitchListTile(
        title: const Text('Show Header'),
        value: config.showHeader,
        onChanged: (value) {
          config.showHeader = value;
        },
      ),
      SwitchListTile(
        title: const Text('Enable Rescheduling'),
        value: config.enableRescheduling,
        onChanged: (value) {
          config.enableRescheduling = value;
        },
      ),
      SwitchListTile(
        title: const Text('Enable Resizing'),
        value: config.enableResizing,
        onChanged: (value) {
          config.enableResizing = value;
        },
      ),
      DropDownBasic(
        label: 'MultiDay tile height',
        items: const [24.0, 48.0],
        initialValue: config.multiDayTileHeight,
        onChanged: (value) {
          config.multiDayTileHeight = value;
        },
      ),
      FirstDayOfWeek(
        value: config.firstDayOfWeek,
        onChanged: (value) {
          config.firstDayOfWeek = value;
        },
      ),
    ];
  }
}

class DropDownBasic<T> extends StatelessWidget {
  const DropDownBasic({
    super.key,
    required this.label,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final List<T> items;
  final T initialValue;
  final void Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: DropdownMenu<T>(
        label: Text(label),
        initialSelection: initialValue,
        dropdownMenuEntries: items
            .map(
              (e) => DropdownMenuEntry<T>(
                value: e,
                label: e.toString(),
              ),
            )
            .toList(),
        expandedInsets: EdgeInsets.zero,
        onSelected: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class TimeDropDown extends StatelessWidget {
  const TimeDropDown({
    super.key,
    required this.label,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  final String label;
  final List<Duration> items;
  final Duration initialValue;
  final void Function(Duration) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: DropdownMenu<Duration>(
        label: Text(label),
        initialSelection: initialValue,
        dropdownMenuEntries: items
            .map(
              (e) => DropdownMenuEntry<Duration>(
                value: e,
                label: '${e.inMinutes} minutes',
              ),
            )
            .toList(),
        expandedInsets: EdgeInsets.zero,
        onSelected: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}

class FirstDayOfWeek extends StatelessWidget {
  const FirstDayOfWeek({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final void Function(int value) onChanged;

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return DropdownMenu<int>(
      label: const Text('First day of week'),
      expandedInsets: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      initialSelection: 1,
      onSelected: (value) {
        if (value == null) return;
        onChanged(value);
      },
      dropdownMenuEntries: daysOfWeek.indexed
          .map(
            (entry) => DropdownMenuEntry<int>(
              value: entry.$1 + 1,
              label: entry.$2,
            ),
          )
          .toList(),
    );
  }
}
