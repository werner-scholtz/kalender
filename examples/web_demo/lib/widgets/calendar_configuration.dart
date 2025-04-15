import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/calendar_configuration.dart';
import 'package:web_demo/widgets/configuration/body_configurations.dart';
import 'package:web_demo/widgets/configuration/header_configuration.dart';
import 'package:web_demo/widgets/configuration/view_configuration.dart';

class CalendarConfigurationWidget extends StatelessWidget {
  final CalendarConfiguration configuration;
  const CalendarConfigurationWidget({super.key, required this.configuration});

  static const borderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        expansionTileTheme: ExpansionTileThemeData(
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          collapsedShape: const RoundedRectangleBorder(borderRadius: borderRadius),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          collapsedBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: borderRadius),
        ),
        listTileTheme: const ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.all(2),
        child: ListenableBuilder(
          listenable: configuration,
          builder: (context, child) {
            return SingleChildScrollView(
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarViewConfiguration(viewConfiguration: configuration.viewConfiguration),
                  if (configuration.viewConfiguration is MultiDayViewConfiguration) ...[
                    MultiDayHeaderConfigurationWidget(calendarConfiguration: configuration),
                    MultiDayBodyConfigurationWidget(calendarConfiguration: configuration),
                  ] else if (configuration.viewConfiguration is MonthViewConfiguration) ...[
                    MonthBodyConfigurationWidget(calendarConfiguration: configuration),
                  ] else
                    const SizedBox.shrink()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

