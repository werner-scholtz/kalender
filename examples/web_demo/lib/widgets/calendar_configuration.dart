import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/calendar_configuration.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/widgets/configuration/body_configurations.dart';
import 'package:web_demo/widgets/configuration/header_configuration.dart';
import 'package:web_demo/widgets/configuration/view_configuration.dart';

class CalendarConfigurationWidget extends StatelessWidget {
  final CalendarConfiguration configuration;
  final VoidCallback? onDismiss;
  const CalendarConfigurationWidget({super.key, required this.configuration, this.onDismiss});

  static const borderRadius = BorderRadius.all(Radius.circular(12));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
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
                      Expanded(
                        child: Text(
                          context.l10n.configuration,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                        ),
                      ),
                      if (onDismiss != null)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: onDismiss,
                          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                          style: IconButton.styleFrom(
                            minimumSize: const Size(28, 28),
                            padding: EdgeInsets.zero,
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
    );
  }
}
