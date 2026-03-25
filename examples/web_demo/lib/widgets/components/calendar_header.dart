import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/locations.dart';
import 'package:web_demo/utils.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxW = constraints.maxWidth;
        final usePopups = maxW < 700;
        final isCompact = maxW < 400;

        final dateButton = HeaderDateButton(controller: controller, compact: maxW < 500);

        final showNavigationButtons = maxW > 300;
        late final previousButton = IconButton(
          icon: const Icon(Icons.chevron_left, size: 20),
          onPressed: () => controller.animateToPreviousPage(),
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(120),
            minimumSize: const Size(36, 36),
            padding: EdgeInsets.zero,
          ),
          tooltip: 'Previous',
        );

        late final nextButton = IconButton(
          icon: const Icon(Icons.chevron_right, size: 20),
          onPressed: () => controller.animateToNextPage(),
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(120),
            minimumSize: const Size(36, 36),
            padding: EdgeInsets.zero,
          ),
          tooltip: 'Next',
        );

        final todayButton = isCompact
            ? IconButton(
                icon: const Icon(Icons.today, size: 18),
                onPressed: () => controller.animateToDate(DateTime.now()),
                tooltip: 'Today',
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(120),
                  minimumSize: const Size(36, 36),
                  padding: EdgeInsets.zero,
                ),
              )
            : FilledButton.tonalIcon(
                icon: const Icon(Icons.today, size: 18),
                label: const Text('Today'),
                onPressed: () => controller.animateToDate(DateTime.now()),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              );

        Widget view;
        if (usePopups) {
          view = PopupMenuButton<ViewConfiguration>(
            tooltip: 'View type',
            icon: Icon(Icons.view_week_outlined, size: 18, color: colorScheme.primary),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(120),
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
            ),
            onSelected: (value) => context.configuration.viewConfiguration = value,
            itemBuilder: (_) => viewConfigurations
                .map((e) => PopupMenuItem(
                      value: e,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            e == viewConfiguration ? Icons.check_circle : Icons.circle_outlined,
                            size: 16,
                            color: e == viewConfiguration ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            e.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: e == viewConfiguration ? FontWeight.w600 : FontWeight.w400,
                                  color: e == viewConfiguration ? colorScheme.primary : null,
                                ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          );
        } else {
          view = PopupMenuButton<ViewConfiguration>(
            tooltip: 'View type',
            onSelected: (value) => context.configuration.viewConfiguration = value,
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => viewConfigurations
                .map((e) => PopupMenuItem(
                      value: e,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            e == viewConfiguration ? Icons.check_circle : Icons.circle_outlined,
                            size: 16,
                            color: e == viewConfiguration ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            e.name,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: e == viewConfiguration ? FontWeight.w600 : FontWeight.w400,
                                  color: e == viewConfiguration ? colorScheme.primary : null,
                                ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(120),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.view_week_outlined, size: 16, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    viewConfiguration.name,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 18, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          );
        }

        Widget location;
        if (usePopups) {
          location = PopupMenuButton<Location?>(
            tooltip: 'Timezone',
            icon: Icon(Icons.public, size: 18, color: colorScheme.primary),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest.withAlpha(120),
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
            ),
            onSelected: (value) => context.location.value = value,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      context.location.value == null ? Icons.check_circle : Icons.circle_outlined,
                      size: 16,
                      color: context.location.value == null ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateTime.now().timeZoneName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: context.location.value == null ? FontWeight.w600 : FontWeight.w400,
                            color: context.location.value == null ? colorScheme.primary : null,
                          ),
                    ),
                  ],
                ),
              ),
              ...supportedLocations.map(
                (loc) {
                  final isSelected = context.location.value?.name == loc;
                  return PopupMenuItem<Location>(
                    value: getLocation(loc),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          size: 16,
                          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          loc,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? colorScheme.primary : null,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        } else {
          final currentLabel = context.location.value?.name.split('/').last ?? DateTime.now().timeZoneName;
          location = PopupMenuButton<Location?>(
            tooltip: 'Timezone',
            onSelected: (value) => context.location.value = value,
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      context.location.value == null ? Icons.check_circle : Icons.circle_outlined,
                      size: 16,
                      color: context.location.value == null ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      DateTime.now().timeZoneName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: context.location.value == null ? FontWeight.w600 : FontWeight.w400,
                            color: context.location.value == null ? colorScheme.primary : null,
                          ),
                    ),
                  ],
                ),
              ),
              ...supportedLocations.map(
                (loc) {
                  final isSelected = context.location.value?.name == loc;
                  return PopupMenuItem<Location>(
                    value: getLocation(loc),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          size: 16,
                          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          loc,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? colorScheme.primary : null,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(120),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.public, size: 16, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    currentLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 18, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          );
        }

        Widget? configToggle;
        if (onToggleConfig != null) {
          configToggle = IconButton(
            icon: AnimatedRotation(
              turns: configVisible ? 0 : 0.5,
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.tune, size: 18),
            ),
            onPressed: onToggleConfig,
            tooltip: configVisible ? 'Hide configuration' : 'Show configuration',
            style: IconButton.styleFrom(
              backgroundColor: configVisible
                  ? colorScheme.primaryContainer.withAlpha(120)
                  : colorScheme.surfaceContainerHighest.withAlpha(120),
              minimumSize: const Size(36, 36),
              padding: EdgeInsets.zero,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Row(
            spacing: 4.0,
            children: [
              dateButton,
              if (showNavigationButtons) ...[
                previousButton,
                nextButton,
              ],
              todayButton,
              const Spacer(),
              location,
              view,
              if (configToggle != null) configToggle,
            ],
          ),
        );
      },
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
            padding: compact
                ? const EdgeInsets.symmetric(horizontal: 10)
                : const EdgeInsets.symmetric(horizontal: 16),
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
