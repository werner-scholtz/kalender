import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/calendar_configuration.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/configuration/editor_widgets.dart';
import 'package:web_demo/utils.dart';

class MultiDayBodyConfigurationWidget extends StatelessWidget {
  final CalendarConfiguration calendarConfiguration;
  const MultiDayBodyConfigurationWidget({super.key, required this.calendarConfiguration});

  MultiDayBodyConfiguration get configuration => calendarConfiguration.multiDayBodyConfiguration;
  ValueNotifier<CalendarInteraction> get interaction => calendarConfiguration.interactionBody;
  ValueNotifier<CalendarSnapping> get snapping => calendarConfiguration.snapping;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(context.l10n.bodyConfiguration),
      initiallyExpanded: true,
      children: [
        SwitchListTile.adaptive(
          value: configuration.showMultiDayEvents,
          onChanged: (value) => calendarConfiguration.multiDayBodyConfiguration = configuration.copyWith(
            showMultiDayEvents: value,
          ),
          title: Text(context.l10n.showMultiDayEvents),
        ),
        DropDownEditor<EdgeInsets>(
          label: context.l10n.eventPaddingLR,
          value: configuration.horizontalPadding,
          items: const [
            EdgeInsets.only(left: 0, right: 4, top: 0, bottom: 0),
            EdgeInsets.only(left: 0, right: 8, top: 0, bottom: 0),
            EdgeInsets.only(left: 0, right: 12, top: 0, bottom: 0),
            EdgeInsets.only(left: 4, right: 0, top: 0, bottom: 0),
            EdgeInsets.only(left: 8, right: 0, top: 0, bottom: 0),
            EdgeInsets.only(left: 12, right: 0, top: 0, bottom: 0),
          ],
          onChanged: (value) => calendarConfiguration.multiDayBodyConfiguration = configuration.copyWith(
            horizontalPadding: value,
          ),
          itemToString: (value) => "L: ${value.left.toInt()}, R: ${value.right.toInt()}",
        ),
        DropDownEditor<double?>(
          label: context.l10n.minimumTileHeight,
          value: configuration.minimumTileHeight,
          items: const [-1, 24.0, 32.0, 40.0, 48.0],
          onChanged: (value) => calendarConfiguration.multiDayBodyConfiguration = MultiDayBodyConfiguration(
            minimumTileHeight: value == -1 ? null : value,
            showMultiDayEvents: configuration.showMultiDayEvents,
            horizontalPadding: configuration.horizontalPadding,
          ),
          itemToString: (value) => value == -1 ? context.l10n.none : value.toString(),
        ),
        SnappingEditorWidget(snapping: snapping),
        InteractionEditorWidget(interaction: interaction),
      ],
    );
  }
}

class MonthBodyConfigurationWidget extends StatelessWidget {
  final CalendarConfiguration calendarConfiguration;
  const MonthBodyConfigurationWidget({super.key, required this.calendarConfiguration});

  MultiDayHeaderConfiguration<Event> get configuration => calendarConfiguration.monthBodyConfiguration;
  ValueNotifier<CalendarInteraction> get interaction => calendarConfiguration.interactionBody;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(context.l10n.bodyConfiguration),
      initiallyExpanded: true,
      children: [
        DropDownEditor<double>(
          label: context.l10n.tileHeight,
          value: configuration.tileHeight,
          items: const [24.0, 32.0, 40.0, 48.0],
          onChanged: (value) => calendarConfiguration.monthBodyConfiguration = configuration.copyWith(
            tileHeight: value,
          ),
          itemToString: (value) => value.toString(),
        ),
        DropDownEditor<EdgeInsets>(
          label: context.l10n.eventPaddingLRTB,
          value: configuration.eventPadding,
          items: const [
            EdgeInsets.only(left: 0, right: 4, top: 0, bottom: 2),
            EdgeInsets.only(left: 0, right: 8, top: 0, bottom: 2),
            EdgeInsets.only(left: 0, right: 12, top: 0, bottom: 2),
            EdgeInsets.only(left: 4, right: 0, top: 0, bottom: 2),
            EdgeInsets.only(left: 8, right: 0, top: 0, bottom: 2),
            EdgeInsets.only(left: 12, right: 0, top: 0, bottom: 2),
          ],
          onChanged: (value) => calendarConfiguration.monthBodyConfiguration = configuration.copyWith(
            eventPadding: value,
          ),
          itemToString: (value) =>
              "L: ${value.left.toInt()}, R: ${value.right.toInt()}, T: ${value.top.toInt()}, B: ${value.bottom.toInt()}",
        ),
        InteractionEditorWidget(interaction: interaction),
      ],
    );
  }
}

class ScheduleBodyConfigurationWidget extends StatelessWidget {
  final CalendarConfiguration calendarConfiguration;
  const ScheduleBodyConfigurationWidget({super.key, required this.calendarConfiguration});

  ScheduleBodyConfiguration get configuration => calendarConfiguration.scheduleBodyConfiguration;
  ValueNotifier<CalendarInteraction> get interaction => calendarConfiguration.interactionBody;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(context.l10n.bodyConfiguration),
      initiallyExpanded: true,
      children: [
        DropDownEditor<EmptyDayBehavior>(
          label: context.l10n.emptyDayBehavior,
          value: calendarConfiguration.scheduleBodyConfiguration.emptyDay,
          items: EmptyDayBehavior.values,
          onChanged: (value) => calendarConfiguration.scheduleBodyConfiguration = configuration.copyWith(
            emptyDay: value,
          ),
          itemToString: (value) => value.toString(),
        ),
        InteractionEditorWidget(interaction: interaction),
      ],
    );
  }
}
