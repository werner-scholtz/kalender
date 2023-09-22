import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.calendarController,
    required this.viewConfigurations,
    required this.currentConfiguration,
    required this.onViewConfigurationChanged,
    required this.visibleDateTimeRange,
  });

  final CalendarController calendarController;
  final List<ViewConfiguration> viewConfigurations;
  final ViewConfiguration currentConfiguration;
  final DateTimeRange visibleDateTimeRange;
  final void Function(ViewConfiguration) onViewConfigurationChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FilledButton.tonal(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(250, 48)),
            ),
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: visibleDateTimeRange.start,
                firstDate: DateTime(1970),
                lastDate: DateTime(2040),
              );
              if (selectedDate == null) return;

              calendarController.animateToDate(
                selectedDate,
                duration: const Duration(microseconds: 300),
                curve: Curves.ease,
              );
            },
            child: Text(
              '${calendarController.visibleMonth!.year} - ${months[calendarController.visibleMonth!.month - 1]}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: IconButton.filledTonal(
              onPressed: () {
                calendarController.animateToPreviousPage();
              },
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Previous Page',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: IconButton.filledTonal(
              onPressed: () {
                calendarController.animateToNextPage();
              },
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Next Page',
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownMenu<ViewConfiguration>(
                    width: 150,
                    initialSelection: currentConfiguration,
                    dropdownMenuEntries: viewConfigurations
                        .map(
                          (e) => DropdownMenuEntry<ViewConfiguration>(
                            value: e,
                            label: e.name,
                          ),
                        )
                        .toList(),
                    enableSearch: false,
                    onSelected: (ViewConfiguration? value) {
                      if (value == null) return;
                      onViewConfigurationChanged(value);
                    },
                    inputDecorationTheme: const InputDecorationTheme(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(gapPadding: 16),
                      constraints: BoxConstraints(maxHeight: 42, minHeight: 38),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

const Map<int, String> months = {
  0: 'January',
  1: 'February',
  2: 'March',
  3: 'April',
  4: 'Mei',
  5: 'June',
  6: 'July',
  7: 'August',
  8: 'September',
  9: 'October',
  10: 'November',
  11: 'December',
};
