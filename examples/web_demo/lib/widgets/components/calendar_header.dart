import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/locations.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/chip_dropdown.dart';

class NavigationHeader extends StatelessWidget {
  final CalendarController controller;
  final List<ViewConfiguration> viewConfigurations;
  final ViewConfiguration viewConfiguration;
  final VoidCallback? onToggleConfig;
  final bool configVisible;
  const NavigationHeader({
    super.key,
    required this.controller,
    required this.viewConfigurations,
    required this.viewConfiguration,
    this.onToggleConfig,
    this.configVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final useChips = maxW >= 700;
        final isCompact = maxW < 400;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Row(
            spacing: 4.0,
            children: [
              HeaderDateButton(controller: controller, compact: maxW < 500),
              if (maxW > 300) ...[
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 20),
                  onPressed: () => controller.animateToPreviousPage(),
                  tooltip: context.l10n.previous,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 20),
                  onPressed: () => controller.animateToNextPage(),
                  tooltip: context.l10n.next,
                ),
              ],
              _todayButton(context, isCompact: isCompact),
              const Spacer(),
              _locationMenu(context, cs: cs, useChips: useChips),
              _viewMenu(context, cs: cs, useChips: useChips),
              if (onToggleConfig != null) _configToggle(context, cs: cs),
            ],
          ),
        );
      },
    );
  }

  Widget _todayButton(BuildContext context, {required bool isCompact}) {
    if (isCompact) {
      return IconButton(
        icon: const Icon(Icons.today, size: 18),
        onPressed: () => controller.animateToDate(DateTime.now()),
        tooltip: context.l10n.today,
      );
    }
    return FilledButton.tonalIcon(
      icon: const Icon(Icons.today, size: 18),
      label: Text(context.l10n.today),
      onPressed: () => controller.animateToDate(DateTime.now()),
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _viewMenu(BuildContext context, {required ColorScheme cs, required bool useChips}) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    List<PopupMenuEntry<ViewConfiguration>> items(BuildContext _) => [
          for (final e in viewConfigurations)
            ChipDropdown.checkMenuItem(
                value: e, label: e.name, selected: e == viewConfiguration, colorScheme: cs, textStyle: textStyle),
        ];
    if (useChips) {
      return ChipDropdown<ViewConfiguration>(
        tooltip: context.l10n.viewType,
        icon: Icons.view_week_outlined,
        label: viewConfiguration.name,
        onSelected: (value) => context.configuration.viewConfiguration = value,
        itemBuilder: items,
      );
    }
    return PopupMenuButton<ViewConfiguration>(
      tooltip: context.l10n.viewType,
      onSelected: (value) => context.configuration.viewConfiguration = value,
      icon: Icon(Icons.view_week_outlined, size: 18, color: cs.primary),
      itemBuilder: items,
    );
  }

  Widget _locationMenu(
    BuildContext context, {
    required ColorScheme cs,
    required bool useChips,
  }) {
    final selected = context.location.value;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    List<PopupMenuEntry<Location?>> items(BuildContext _) => [
          ChipDropdown.checkMenuItem(
            value: null,
            label: DateTime.now().timeZoneName,
            selected: selected == null,
            colorScheme: cs,
            textStyle: textStyle,
          ),
          for (final loc in supportedLocations)
            ChipDropdown.checkMenuItem<Location?>(
              value: getLocation(loc),
              label: loc,
              selected: selected?.name == loc,
              colorScheme: cs,
              textStyle: textStyle,
            ),
        ];
    if (useChips) {
      return ChipDropdown<Location?>(
        tooltip: context.l10n.timezone,
        icon: Icons.public,
        label: selected?.name.split('/').last ?? DateTime.now().timeZoneName,
        onSelected: (value) => context.location.value = value,
        itemBuilder: items,
      );
    }
    return PopupMenuButton<Location?>(
      tooltip: context.l10n.timezone,
      onSelected: (value) => context.location.value = value,
      icon: Icon(Icons.public, size: 18, color: cs.primary),
      itemBuilder: items,
    );
  }

  Widget _configToggle(BuildContext context, {required ColorScheme cs}) {
    return IconButton(
      icon: AnimatedRotation(
        turns: configVisible ? 0 : 0.5,
        duration: const Duration(milliseconds: 250),
        child: const Icon(Icons.tune, size: 18),
      ),
      onPressed: onToggleConfig,
      tooltip: configVisible ? context.l10n.hideConfiguration : context.l10n.showConfiguration,
      style: IconButton.styleFrom(
        backgroundColor: configVisible ? cs.primaryContainer.withAlpha(120) : cs.surfaceContainerHighest.withAlpha(120),
        minimumSize: const Size(36, 36),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class HeaderDateButton extends StatelessWidget {
  final CalendarController controller;
  final bool compact;
  const HeaderDateButton({super.key, required this.controller, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.visibleDateTimeRange,
      builder: (context, value, child) {
        if (value == null) return const SizedBox.shrink();
        final String month;
        final int year;

        if (controller.viewController is MonthViewController) {
          final secondWeek = value.start.copyWith(day: value.start.day + 7);
          year = secondWeek.year;
          month = secondWeek.monthNameLocalized(context.localeTag);
        } else {
          year = value.start.year;
          month = value.start.monthNameLocalized(context.localeTag);
        }

        return FilledButton.tonal(
          onPressed: () async {
            final displayRange = controller.viewController?.viewConfiguration.dateTimeRange;
            if (displayRange == null) return;
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: displayRange.start,
              lastDate: displayRange.end,
            );
            if (selectedDate != null) controller.animateToDate(selectedDate);
          },
          style: FilledButton.styleFrom(
            minimumSize: compact ? const Size(0, 36) : const Size(140, 42),
            padding: compact ? const EdgeInsets.symmetric(horizontal: 10) : const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: compact
              ? Text(
                  '${month.substring(0, min(3, month.length))} $year',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month, size: 18, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      '$month $year',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
