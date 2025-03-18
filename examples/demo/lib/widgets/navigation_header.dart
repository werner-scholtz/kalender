import 'dart:io';

import 'package:demo/data/event.dart';
import 'package:demo/main.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class NavigationHeader extends StatelessWidget {
  final CalendarController<Event> controller;
  final ValueNotifier<ViewConfiguration> view;
  const NavigationHeader({
    required this.controller,
    required this.view,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: controller.visibleDateTimeRangeUtc,
            builder: (context, value, child) {
              final String month;
              final int year;

              if (controller.viewController?.viewConfiguration is MonthViewConfiguration) {
                // Since the visible DateTimeRange returned by the month view does not always start at the beginning of the month,
                // we need to check the second week of the visibleDateTimeRange to determine the month and year.
                final secondWeek = value.start.addDays(7);
                year = secondWeek.year;
                month = secondWeek.monthNameEnglish;
              } else {
                year = value.start.year;
                month = value.start.monthNameEnglish;
              }

              return FilledButton.tonal(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size(150, kMinInteractiveDimension),
                ),
                child: Text('$month $year'),
              );
            },
          ),
          if (!Platform.isAndroid && !Platform.isIOS) ...[
            const SizedBox(width: 4),
            IconButton.filledTonal(
              onPressed: () async {
                await controller.animateToPreviousPage();
              },
              icon: const Icon(Icons.navigate_before),
            ),
          ],
          if (!Platform.isAndroid && !Platform.isIOS) ...[
            const SizedBox(width: 4),
            IconButton.filledTonal(
              onPressed: () {
                controller.animateToNextPage();
              },
              icon: const Icon(Icons.navigate_next),
            ),
          ],
          const SizedBox(width: 4),
          IconButton.filledTonal(
            onPressed: () {
              controller.animateToDate(DateTime.now());
            },
            icon: const Icon(Icons.today),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownMenu(
                  dropdownMenuEntries: App.views(context).map((e) {
                    return DropdownMenuEntry(value: e, label: e.name);
                  }).toList(),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kMinInteractiveDimension),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kMinInteractiveDimension),
                        borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.outline)),
                  ),
                  initialSelection: view.value,
                  onSelected: (value) {
                    if (value == null) return;
                    view.value = value;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
