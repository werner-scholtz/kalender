import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/calendar_configuration.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/configuration/body_configurations.dart';
import 'package:web_demo/widgets/configuration/header_configuration.dart';
import 'package:web_demo/widgets/configuration/view_configuration.dart';

class CalendarConfigurationWidget extends StatelessWidget {
  final CalendarConfiguration configuration;
  const CalendarConfigurationWidget({super.key, required this.configuration});

  static const borderRadius = BorderRadius.all(Radius.circular(12));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(
        expansionTileTheme: ExpansionTileThemeData(
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          collapsedShape: const RoundedRectangleBorder(borderRadius: borderRadius),
          backgroundColor: colorScheme.surfaceContainerHigh.withAlpha(120),
          collapsedBackgroundColor: colorScheme.surfaceContainer.withAlpha(100),
          iconColor: colorScheme.primary,
          collapsedIconColor: colorScheme.onSurfaceVariant,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surfaceContainerLow,
          border: const OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        listTileTheme: const ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: borderRadius,
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
        ),
        child: ListenableBuilder(
          listenable: configuration,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.tune, size: 20, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.configuration,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                  CalendarViewConfiguration(viewConfiguration: configuration.viewConfiguration),
                  if (configuration.viewConfiguration is MultiDayViewConfiguration) ...[
                    MultiDayHeaderConfigurationWidget(calendarConfiguration: configuration),
                    MultiDayBodyConfigurationWidget(calendarConfiguration: configuration),
                  ] else if (configuration.viewConfiguration is MonthViewConfiguration) ...[
                    MonthBodyConfigurationWidget(calendarConfiguration: configuration),
                  ] else if (configuration.viewConfiguration is ScheduleViewConfiguration) ...[
                    ScheduleBodyConfigurationWidget(calendarConfiguration: configuration),
                  ] else
                    const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
