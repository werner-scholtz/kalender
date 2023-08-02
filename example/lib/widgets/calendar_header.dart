import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.calendarController,
    required this.viewConfigurations,
    required this.currentConfiguration,
    required this.onViewConfigurationChanged,
    required this.dateTimeRange,
  });

  final CalendarController calendarController;
  final List<ViewConfiguration> viewConfigurations;
  final ViewConfiguration currentConfiguration;
  final DateTimeRange dateTimeRange;
  final void Function(ViewConfiguration) onViewConfigurationChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton.filledTonal(
                onPressed: () {
                  calendarController.animateToPreviousPage();
                },
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  calendarController.animateToNextPage();
                },
                icon: const Icon(Icons.chevron_right),
              ),
              DropdownMenu<ViewConfiguration>(
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
            ],
          ),
        ),
      ],
    );
  }
}
