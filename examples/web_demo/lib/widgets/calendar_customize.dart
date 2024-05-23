import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/kalender_extensions.dart';

class CalendarCustomize extends StatefulWidget {
  final ViewConfiguration viewConfiguration;
  final void Function(ViewConfiguration value) onChanged;

  final MultiDayBodyConfiguration bodyConfiguration;
  final void Function(MultiDayBodyConfiguration bodyConfiguration)
      onBodyChanged;

  final MultiDayHeaderConfiguration headerConfiguration;
  final void Function(MultiDayHeaderConfiguration headerConfiguration)
      onHeaderChanged;

  final bool showHeader;
  final void Function(bool value) onShowHeaderChanged;

  const CalendarCustomize({
    super.key,
    required this.viewConfiguration,
    required this.onChanged,
    required this.bodyConfiguration,
    required this.onBodyChanged,
    required this.headerConfiguration,
    required this.onHeaderChanged,
    required this.showHeader,
    required this.onShowHeaderChanged,
  });

  @override
  State<CalendarCustomize> createState() => _CalendarCustomizeState();
}

class _CalendarCustomizeState extends State<CalendarCustomize> {
  ViewConfiguration get viewConfiguration => widget.viewConfiguration;
  MultiDayBodyConfiguration get bodyConfiguration => widget.bodyConfiguration;
  MultiDayHeaderConfiguration get headerConfiguration =>
      widget.headerConfiguration;
  SizedBox get spacer => const SizedBox(height: 12.0);

  EdgeInsets get childrenPadding =>
      const EdgeInsets.only(top: 16, bottom: 16, left: 32);

  @override
  Widget build(BuildContext context) {
    if (viewConfiguration is MultiDayViewConfiguration) {
      return _buildMultiDay(
        context,
        viewConfiguration as MultiDayViewConfiguration,
      );
    } else if (viewConfiguration is MonthViewConfiguration) {
      return _buildMonth(
        context,
        viewConfiguration as MonthViewConfiguration,
      );
    }

    return Container();
  }

  Widget _buildMultiDay(
    BuildContext context,
    MultiDayViewConfiguration configuration,
  ) {
    final timeOfDayRange = TimeOfDayRangeEditor(
      initialTimeOfDayRange: configuration.timeOfDayRange,
      onChanged: (value) {
        widget.onChanged(
          configuration.copyWith(timeOfDayRange: value),
        );
      },
    );

    final showFirstDayOfWeek = configuration.type == MultiDayViewType.week;
    final firstDayOfWeek = FirstDayOfWeekEditor(
      initialFirstDayOfWeek: configuration.firstDayOfWeek,
      onChanged: (value) {
        widget.onChanged(
          configuration.copyWith(firstDayOfWeek: value),
        );
      },
    );

    final showNumberOfDays = configuration.type == MultiDayViewType.custom;
    late final numberOfDays = NumberOfDaysEditor(
      initialNumberOfDays: configuration.numberOfDays,
      onChanged: (value) {
        widget.onChanged(
          configuration.copyWith(numberOfDays: value),
        );
      },
    );

    final viewConfigurationTile = ExpansionTile(
      title: const Text('View Configuration'),
      initiallyExpanded: true,
      childrenPadding: childrenPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        timeOfDayRange,
        spacer,
        if (showFirstDayOfWeek) ...[
          firstDayOfWeek,
          spacer,
        ],
        if (showNumberOfDays) numberOfDays,
      ],
    );

    final showMultiDayEvents = SwitchTileEditor(
      title: 'Show Multi-Day Events',
      initialValue: bodyConfiguration.showMultiDayEvents,
      onChanged: (value) {
        widget.onBodyChanged(
          bodyConfiguration.copyWith(showMultiDayEvents: value),
        );
      },
    );

    final allowResizing = SwitchTileEditor(
      title: 'Allow Resizing',
      subtitle: 'Allow resizing of events',
      initialValue: bodyConfiguration.allowResizing,
      onChanged: (value) {
        widget.onBodyChanged(
          bodyConfiguration.copyWith(allowResizing: value),
        );
      },
    );

    final allowRescheduling = SwitchTileEditor(
      title: 'Allow Rescheduling',
      subtitle: 'Allow dragging of events',
      initialValue: bodyConfiguration.allowRescheduling,
      onChanged: (value) {
        widget.onBodyChanged(
          bodyConfiguration.copyWith(allowRescheduling: value),
        );
      },
    );

    final snapToTimeIndicator = SwitchTileEditor(
      title: 'Snap to Time Indicator',
      subtitle: 'Snap events to the time indicator',
      initialValue: bodyConfiguration.snapToTimeIndicator,
      onChanged: (value) {
        widget.onBodyChanged(
          bodyConfiguration.copyWith(snapToTimeIndicator: value),
        );
      },
    );

    final snapToOtherEvents = SwitchTileEditor(
      title: 'Snap to Other Events',
      subtitle: 'Snap events to other events',
      initialValue: bodyConfiguration.snapToOtherEvents,
      onChanged: (value) {
        widget.onBodyChanged(
          bodyConfiguration.copyWith(snapToOtherEvents: value),
        );
      },
    );

    final snapIntervalMinutes = IntEditor(
      title: 'Snap interval',
      suffix: 'minute(s)',
      initialValue: bodyConfiguration.snapIntervalMinutes,
      items: const [1, 5, 10, 15, 30],
      onChanged: (value) {
        widget.onBodyChanged(
          bodyConfiguration.copyWith(snapIntervalMinutes: value),
        );
      },
    );

    final snapRange = IntEditor(
      title: 'Snap Range',
      suffix: 'minute(s)',
      initialValue: bodyConfiguration.snapRange.inMinutes,
      items: const [1, 5, 10, 15, 30],
      onChanged: (value) {
        widget.onBodyChanged(
          bodyConfiguration.copyWith(snapRange: Duration(minutes: value)),
        );
      },
    );

    final newEventDuration = IntEditor(
      title: 'New Event Duration',
      suffix: 'minute(s)',
      initialValue: bodyConfiguration.newEventDuration.inMinutes,
      items: const [15, 30, 60],
      onChanged: (value) {
        widget.onBodyChanged(
          bodyConfiguration.copyWith(
            newEventDuration: Duration(minutes: value),
          ),
        );
      },
    );

    final layoutStrategy = DropdownMenu(
      initialSelection: overlapLayoutStrategy,
      expandedInsets: const EdgeInsets.only(left: 16, right: 32),
      label: const Text('Layout Strategy'),
      dropdownMenuEntries: const [
        DropdownMenuEntry(
          value: overlapLayoutStrategy,
          label: 'Overlap',
        ),
        DropdownMenuEntry(
          value: sideBySideLayoutStrategy,
          label: 'Side by side',
        ),
      ],
      onSelected: (value) {
        if (value == null) return;
        widget.onBodyChanged(
          bodyConfiguration.copyWith(dayEventLayoutStrategy: value),
        );
      },
    );

    final bodyConfigurationTile = ExpansionTile(
      title: const Text('Body Configuration'),
      initiallyExpanded: true,
      childrenPadding: childrenPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        showMultiDayEvents,
        spacer,
        allowResizing,
        spacer,
        allowRescheduling,
        spacer,
        snapToTimeIndicator,
        spacer,
        snapToOtherEvents,
        spacer,
        snapIntervalMinutes,
        spacer,
        snapRange,
        spacer,
        newEventDuration,
        spacer,
        layoutStrategy,
      ],
    );

    final headerTileHeight = IntEditor(
      title: 'Tile Height',
      suffix: '',
      initialValue: 24,
      items: const [24, 48],
      onChanged: (value) {
        widget.onHeaderChanged(
          headerConfiguration.copyWith(tileHeight: value.toDouble()),
        );
      },
    );

    final headerAllowResizing = SwitchTileEditor(
      title: 'Allow Resizing',
      subtitle: 'Allow resizing of events',
      initialValue: headerConfiguration.allowResizing,
      onChanged: (value) {
        widget.onHeaderChanged(
          headerConfiguration.copyWith(allowResizing: value),
        );
      },
    );

    final headerAllowRescheduling = SwitchTileEditor(
      title: 'Allow Rescheduling',
      subtitle: 'Allow dragging of events',
      initialValue: headerConfiguration.allowRescheduling,
      onChanged: (value) {
        widget.onHeaderChanged(
          headerConfiguration.copyWith(allowRescheduling: value),
        );
      },
    );

    final showHeader = SwitchTileEditor(
      title: 'Show header',
      subtitle: 'Show the multi-day header',
      initialValue: widget.showHeader,
      onChanged: (value) {
        widget.onShowHeaderChanged(value);
      },
    );

    final headerConfigurationTile = ExpansionTile(
      title: const Text('Header Configuration'),
      initiallyExpanded: true,
      childrenPadding: childrenPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      children: [
        showHeader,
        spacer,
        headerTileHeight,
        spacer,
        headerAllowResizing,
        spacer,
        headerAllowRescheduling,
      ],
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          children: [
            viewConfigurationTile,
            headerConfigurationTile,
            bodyConfigurationTile,
          ],
        ),
      ),
    );
  }

  Widget _buildMonth(
    BuildContext context,
    MonthViewConfiguration configuration,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [],
      ),
    );
  }
}

class TimeOfDayRangeEditor extends StatelessWidget {
  final TimeOfDayRange initialTimeOfDayRange;
  final void Function(TimeOfDayRange value) onChanged;

  const TimeOfDayRangeEditor({
    super.key,
    required this.initialTimeOfDayRange,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final startOptions = List.generate(
      initialTimeOfDayRange.end.hour,
      (index) => DropdownMenuEntry(
        value: TimeOfDay(hour: index, minute: 0),
        label: '$index:00',
      ),
    );

    final endOptions = List.generate(
      24 - initialTimeOfDayRange.start.hour,
      (index) {
        var value = index + initialTimeOfDayRange.start.hour + 1;
        var minute = 0;
        if (value > 23) {
          value = 23;
          minute = 59;
        }

        final minuteText = minute < 10 ? '00' : '$minute';

        return DropdownMenuEntry(
          value: TimeOfDay(hour: value, minute: minute),
          label: '$value:$minuteText',
        );
      },
    );

    const spacer = SizedBox(height: 8.0);

    return ListBody(
      children: [
        DropdownMenu<TimeOfDay>(
          label: const Text('Start Time'),
          expandedInsets: const EdgeInsets.only(left: 16, right: 32),
          dropdownMenuEntries: startOptions,
          initialSelection: initialTimeOfDayRange.start,
          onSelected: (value) {
            if (value == null) return;
            onChanged(
              TimeOfDayRange(start: value, end: initialTimeOfDayRange.end),
            );
          },
        ),
        spacer,
        DropdownMenu(
          label: const Text('End Time'),
          expandedInsets: const EdgeInsets.only(left: 16, right: 32),
          dropdownMenuEntries: endOptions,
          initialSelection: initialTimeOfDayRange.end,
          onSelected: (value) {
            if (value == null) return;
            onChanged(
              TimeOfDayRange(start: initialTimeOfDayRange.start, end: value),
            );
          },
        ),
      ],
    );
  }
}

class FirstDayOfWeekEditor extends StatelessWidget {
  final int initialFirstDayOfWeek;
  final void Function(int value) onChanged;

  const FirstDayOfWeekEditor({
    super.key,
    required this.initialFirstDayOfWeek,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      label: const Text('First Day of Week'),
      expandedInsets: const EdgeInsets.only(left: 16, right: 32),
      dropdownMenuEntries: [
        DropdownMenuEntry(
          value: 1,
          label: DateTime(2024, 1, 1).dayNameEnglish,
        ),
        DropdownMenuEntry(
          value: 6,
          label: DateTime(2024, 1, 6).dayNameEnglish,
        ),
        DropdownMenuEntry(
          value: 7,
          label: DateTime(2024, 1, 7).dayNameEnglish,
        ),
      ],
      initialSelection: initialFirstDayOfWeek,
      onSelected: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );
  }
}

class NumberOfDaysEditor extends StatelessWidget {
  final int initialNumberOfDays;
  final void Function(int value) onChanged;
  const NumberOfDaysEditor({
    super.key,
    required this.initialNumberOfDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      label: const Text('Number of Days'),
      expandedInsets: const EdgeInsets.only(left: 16, right: 32),
      dropdownMenuEntries: List.generate(
        14,
        (index) => DropdownMenuEntry(
          value: index + 1,
          label: '${index + 1}',
        ),
      ),
      initialSelection: initialNumberOfDays,
      onSelected: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );
  }
}

class SwitchTileEditor extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool initialValue;
  final void Function(bool value) onChanged;

  const SwitchTileEditor({
    super.key,
    required this.title,
    this.subtitle,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: initialValue,
      onChanged: onChanged,
    );
  }
}

class IntEditor extends StatelessWidget {
  final String title;
  final String suffix;
  final int initialValue;
  final List<int> items;
  final void Function(int value) onChanged;
  const IntEditor({
    super.key,
    required this.title,
    required this.suffix,
    required this.initialValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      label: Text(title),
      expandedInsets: const EdgeInsets.only(left: 16, right: 32),
      dropdownMenuEntries: items
          .map(
            (e) => DropdownMenuEntry(
              value: e,
              label: '$e $suffix',
            ),
          )
          .toList(),
      initialSelection: initialValue,
      onSelected: (value) {
        if (value == null) return;
        onChanged(value);
      },
    );
  }
}
