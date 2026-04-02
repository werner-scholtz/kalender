import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/locations.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final useChips = !isTouch && maxW >= 700;
        final isCompact = maxW < 400;

        // On touch devices buttons are 44px; account for that when deciding
        // which elements to show so the Row never overflows.
        // Minimum widths (approx): date~80 + 2×nav~88 + loc~44 + view~44 + cfg~44 + spacing = ~315
        final showNav = isTouch ? maxW >= 315 : maxW > 300;
        // Drop the location menu on very narrow mobile widths (< ~225px).
        final showLocation = !isTouch || maxW >= 225;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isTouch ? 4 : 2, vertical: isTouch ? 4 : 2),
          child: Row(
            spacing: isTouch ? 2.0 : 4.0,
            children: [
              HeaderDateButton(controller: controller, compact: maxW < 500),
              if (showNav) ...[
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => controller.animateToPreviousPage(),
                  tooltip: context.l10n.previous,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => controller.animateToNextPage(),
                  tooltip: context.l10n.next,
                ),
              ],
              if (!isTouch) TodayButton(controller: controller, compact: isCompact),
              const Spacer(),
              if (showLocation) LocationMenu(useChips: useChips),
              ViewMenu(
                viewConfigurations: viewConfigurations,
                viewConfiguration: viewConfiguration,
                useChips: useChips,
              ),
              if (onToggleConfig != null) ConfigToggle(onPressed: onToggleConfig, configVisible: configVisible),
            ],
          ),
        );
      },
    );
  }
}

class TodayButton extends StatelessWidget {
  final CalendarController controller;
  final bool compact;
  const TodayButton({super.key, required this.controller, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton(
        icon: const Icon(Icons.today),
        onPressed: () => controller.animateToDate(DateTime.now()),
        tooltip: context.l10n.today,
      );
    }
    return FilledButton.tonalIcon(
      icon: const Icon(Icons.today),
      label: Text(context.l10n.today),
      onPressed: () => controller.animateToDate(DateTime.now()),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: context.colorScheme.surfaceContainerHighest.withAlpha(120),
        foregroundColor: context.colorScheme.onSurface,
      ),
    );
  }
}

class ViewMenu extends StatelessWidget {
  final List<ViewConfiguration> viewConfigurations;
  final ViewConfiguration viewConfiguration;
  final bool useChips;
  const ViewMenu({
    super.key,
    required this.viewConfigurations,
    required this.viewConfiguration,
    required this.useChips,
  });

  @override
  Widget build(BuildContext context) {
    List<PopupMenuEntry<ViewConfiguration>> items(BuildContext _) => [
          for (final e in viewConfigurations)
            ChipDropdown.checkMenuItem(
              value: e,
              label: e.name,
              selected: e == viewConfiguration,
              colorScheme: context.colorScheme,
              textStyle: context.textTheme.bodyMedium,
            ),
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
      icon: Icon(Icons.view_week_outlined, color: context.colorScheme.primary),
      itemBuilder: items,
    );
  }
}

class LocationMenu extends StatelessWidget {
  final bool useChips;
  const LocationMenu({super.key, required this.useChips});

  @override
  Widget build(BuildContext context) {
    final selected = context.location.value;
    final isSystemTime = selected == null;

    List<PopupMenuEntry<Location?>> items(BuildContext _) => [
          // Use onTap for the system-time item because PopupMenuButton treats
          // a null value as "dismissed" and never calls onSelected for it.
          PopupMenuItem<Location?>(
            onTap: () => context.location.value = null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSystemTime ? Icons.check_circle : Icons.circle_outlined,
                  size: 16,
                  color: isSystemTime ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Text(
                  DateTime.now().timeZoneName,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSystemTime ? FontWeight.w600 : FontWeight.w400,
                    color: isSystemTime ? context.colorScheme.primary : null,
                  ),
                ),
              ],
            ),
          ),
          for (final loc in supportedLocations)
            ChipDropdown.checkMenuItem<Location?>(
              value: getLocation(loc),
              label: loc,
              selected: selected?.name == loc,
              colorScheme: context.colorScheme,
              textStyle: context.textTheme.bodyMedium,
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
      icon: Icon(Icons.public, color: context.colorScheme.primary),
      itemBuilder: items,
    );
  }
}

class ConfigToggle extends StatelessWidget {
  final bool configVisible;
  final VoidCallback? onPressed;
  const ConfigToggle({
    required this.onPressed,
    required this.configVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedRotation(
        turns: configVisible ? 0 : 0.5,
        duration: const Duration(milliseconds: 250),
        child: const Icon(Icons.tune),
      ),
      onPressed: onPressed,
      tooltip: configVisible ? context.l10n.hideConfiguration : context.l10n.showConfiguration,
      style: IconButton.styleFrom(
        backgroundColor: configVisible
            ? context.colorScheme.surfaceContainerHighest.withAlpha(160)
            : context.colorScheme.surfaceContainerHighest.withAlpha(120),
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

        final button = FilledButton.tonal(
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
            padding: compact ? const EdgeInsets.symmetric(horizontal: 10) : const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: context.colorScheme.surfaceContainerHighest.withAlpha(120),
            foregroundColor: context.colorScheme.onSurface,
          ),
          child: compact
              ? Text(
                  '${month.substring(0, min(3, month.length))} $year',
                  style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month, color: context.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      '$month $year',
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
        );

        if (compact) return button;
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 140),
          child: button,
        );
      },
    );
  }
}
