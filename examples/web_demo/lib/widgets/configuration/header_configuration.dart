import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/calendar_configuration.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/configuration/editor_widgets.dart';

class MultiDayHeaderConfigurationWidget extends StatelessWidget {
  final CalendarConfiguration calendarConfiguration;

  const MultiDayHeaderConfigurationWidget({
    super.key,
    required this.calendarConfiguration,
  });

  MultiDayHeaderConfiguration<Event> get configuration => calendarConfiguration.multiDayHeaderConfiguration;
  ValueNotifier<CalendarInteraction> get interaction => calendarConfiguration.interactionHeader;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Header Configuration"),
      initiallyExpanded: true,
      children: [
        SwitchListTile.adaptive(
          value: calendarConfiguration.showHeader,
          onChanged: (value) => calendarConfiguration.showHeader = value,
          title: const Text("Show Header"),
          subtitle: Text("Show header for ${calendarConfiguration.viewConfiguration.name} view"),
        ),
        SwitchListTile.adaptive(
          value: configuration.showTiles,
          onChanged: (value) => calendarConfiguration.multiDayHeaderConfiguration = configuration.copyWith(
            showTiles: value,
          ),
          title: const Text("Show Tiles"),
        ),
        DropDownEditor<double>(
          label: "Tile Height",
          value: configuration.tileHeight,
          items: const [24.0, 32.0, 40.0, 48.0],
          onChanged: (value) => calendarConfiguration.multiDayHeaderConfiguration = configuration.copyWith(
            tileHeight: value,
          ),
          itemToString: (value) => value.toString(),
        ),
        DropDownEditor<int>(
          label: "Max number of vertical events",
          value: configuration.maximumNumberOfVerticalEvents ?? 0,
          items: const [0, 1, 2, 3, 4, 5],
          onChanged: (value) {
            calendarConfiguration.multiDayHeaderConfiguration = value == 0
                ? MultiDayHeaderConfiguration<Event>(
                    showTiles: configuration.showTiles,
                    tileHeight: configuration.tileHeight,
                  )
                : configuration.copyWith(maximumNumberOfVerticalEvents: value);
          },
          itemToString: (value) => value != 0 ? value.toString() : "Unlimited",
        ),
        DropDownEditor<EdgeInsets>(
          label: "Event Padding (LRTB)",
          value: configuration.eventPadding,
          items: const [
            EdgeInsets.only(left: 0, right: 4, top: 0, bottom: 2),
            EdgeInsets.only(left: 0, right: 8, top: 0, bottom: 2),
            EdgeInsets.only(left: 0, right: 12, top: 0, bottom: 2),
            EdgeInsets.only(left: 4, right: 0, top: 0, bottom: 2),
            EdgeInsets.only(left: 8, right: 0, top: 0, bottom: 2),
            EdgeInsets.only(left: 12, right: 0, top: 0, bottom: 2),
          ],
          onChanged: (value) => calendarConfiguration.multiDayHeaderConfiguration = configuration.copyWith(
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
