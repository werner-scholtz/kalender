import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:timezone/timezone.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/widgets/calendar_widget.dart';

class NavigationHeader extends StatelessWidget {
  final CalendarController<Event> controller;
  final List<ViewConfiguration> viewConfigurations;
  final ViewConfiguration viewConfiguration;
  const NavigationHeader({
    super.key,
    required this.controller,
    required this.viewConfigurations,
    required this.viewConfiguration,
  });

  @override
  Widget build(BuildContext context) {
    final locations = supportedLocations..add(DateTime.now().timeZoneName);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          spacing: 4.0,
          children: [
            HeaderDateButton(controller: controller),
            if (constraints.maxWidth > 500) ...[
              IconButton.filledTonal(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => controller.animateToPreviousPage(),
              ),
              IconButton.filledTonal(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => controller.animateToNextPage(),
              ),
            ],
            IconButton.filledTonal(
              icon: const Icon(Icons.today),
              onPressed: () => controller.animateToDate(DateTime.now()),
            ),
            const Spacer(),
            DropdownMenu<String>(
              dropdownMenuEntries: locations.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
              width: min(150.0, constraints.maxWidth - 150.0),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(kMinInteractiveDimension)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kMinInteractiveDimension),
                  borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.outline),
                ),
              ),
              initialSelection: context.location.value?.name ?? DateTime.now().timeZoneName,
              onSelected: (value) {
                if (value == null) return;
                if (value == DateTime.now().timeZoneName) {
                  context.location.value = null;
                  return;
                }
                context.location.value = getLocation(value);
              },
            ),
            DropdownMenu(
              dropdownMenuEntries: viewConfigurations.map((e) => DropdownMenuEntry(value: e, label: e.name)).toList(),
              width: min(150.0, constraints.maxWidth - 150.0),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(kMinInteractiveDimension)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(kMinInteractiveDimension),
                  borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.outline),
                ),
              ),
              initialSelection: viewConfiguration,
              onSelected: (value) {
                if (value == null) return;
                CalendarWidget.setViewConfiguration(context, value);
              },
            ),
          ],
        );
      },
    );
  }
}

class HeaderDateButton extends StatelessWidget {
  final CalendarController<Event> controller;
  const HeaderDateButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.visibleDateTimeRange,
      builder: (context, value, child) {
        final String month;
        final int year;

        if (controller.viewController is MonthViewController) {
          // Since the visible DateTimeRange returned by the month view does not always start at the beginning of the month,
          // we need to check the second week of the visibleDateTimeRange to determine the month and year.
          final secondWeek = value.start.addDays(7);
          year = secondWeek.year;
          month = secondWeek.monthNameLocalized(context.localeTag);
        } else {
          year = value.start.year;
          month = value.start.monthNameLocalized(context.localeTag);
        }

        return FilledButton.tonal(
          onPressed: () async {
            final displayRange = controller.viewController?.viewConfiguration.displayRange;
            if (displayRange == null) return;
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: displayRange.start,
              lastDate: displayRange.end,
            );
            if (selectedDate != null) controller.animateToDate(selectedDate);
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size(150, kMinInteractiveDimension),
          ),
          child: Text('$month $year'),
        );
      },
    );
  }
}
