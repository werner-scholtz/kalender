import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/utils.dart';

class DropDownEditor<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;
  final String Function(T) itemToString;

  const DropDownEditor({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemToString,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: DropdownMenu(
        key: Key(context.localeTag),
        menuHeight: 250,
        expandedInsets: const EdgeInsets.symmetric(horizontal: 8),
        label: Text(label),
        dropdownMenuEntries: items.map((e) => DropdownMenuEntry<T>(value: e, label: itemToString(e))).toList(),
        initialSelection: value,
        onSelected: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class FirstDayOfWeekEditor extends StatelessWidget {
  final int firstDayOfWeek;
  final ValueChanged<int> onChanged;
  const FirstDayOfWeekEditor({super.key, required this.firstDayOfWeek, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropDownEditor<int>(
      key: Key(context.localeTag),
      label: context.l10n.firstDayOfWeek,
      value: firstDayOfWeek,
      items: const [1, 2, 3, 4, 5, 6, 7],
      onChanged: (value) => onChanged(value),
      itemToString: (value) => DateTime(2024, 1, value).dayNameLocalized(context.localeTag),
    );
  }
}

class InteractionEditorWidget extends StatelessWidget {
  final ValueNotifier<CalendarInteraction> interaction;
  const InteractionEditorWidget({super.key, required this.interaction});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: interaction,
      builder: (context, value, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile.adaptive(
            value: value.allowResizing,
            onChanged: (value) => interaction.value = interaction.value.copyWith(allowResizing: value),
            title: Text(context.l10n.allowResizing),
          ),
          SwitchListTile.adaptive(
            value: value.allowRescheduling,
            onChanged: (value) => interaction.value = interaction.value.copyWith(allowRescheduling: value),
            title: Text(context.l10n.allowRescheduling),
          ),
          SwitchListTile.adaptive(
            value: value.allowEventCreation,
            onChanged: (value) => interaction.value = interaction.value.copyWith(allowEventCreation: value),
            title: Text(context.l10n.allowEventCreation),
          ),
        ],
      ),
    );
  }
}

class SnappingEditorWidget extends StatelessWidget {
  final ValueNotifier<CalendarSnapping> snapping;
  const SnappingEditorWidget({super.key, required this.snapping});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: snapping,
      builder: (context, value, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile.adaptive(
            value: value.snapToOtherEvents,
            onChanged: (value) => snapping.value = snapping.value.copyWith(snapToOtherEvents: value),
            title: Text(context.l10n.snapToOtherEvents),
          ),
          SwitchListTile.adaptive(
            value: value.snapToTimeIndicator,
            onChanged: (value) => snapping.value = snapping.value.copyWith(snapToTimeIndicator: value),
            title: Text(context.l10n.snapToTimeIndicator),
          ),
          DropDownEditor<int>(
            label: context.l10n.snapInterval,
            value: value.snapIntervalMinutes,
            items: const [1, 5, 10, 30],
            onChanged: (value) => snapping.value = snapping.value.copyWith(snapIntervalMinutes: value),
            itemToString: (value) => context.l10n.minutesLabel(value),
          ),
          DropDownEditor<int>(
            key: Key(context.localeTag),
            label: context.l10n.snapRange,
            value: value.snapRange.inMinutes,
            items: const [1, 5, 10, 15, 30],
            onChanged: (value) => snapping.value = snapping.value.copyWith(snapRange: Duration(minutes: value)),
            itemToString: (value) => context.l10n.minutesLabel(value),
          ),
        ],
      ),
    );
  }
}
