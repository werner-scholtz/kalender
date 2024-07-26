import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/resize_handle.dart';
import 'package:web_demo/widgets/trigger.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarController<Event> controller;
  final EventsController<Event> eventsController;
  final ViewConfiguration viewConfiguration;
  final List<ViewConfiguration> viewConfigurations;
  final void Function(ViewConfiguration value) onSelected;
  final CalendarCallbacks<Event> callbacks;
  final MultiDayBodyConfiguration bodyConfiguration;
  final MultiDayHeaderConfiguration headerConfiguration;
  final bool showHeader;

  const CalendarWidget({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.viewConfigurations,
    required this.onSelected,
    required this.callbacks,
    required this.bodyConfiguration,
    required this.headerConfiguration,
    required this.showHeader,
  });

  @override
  Widget build(BuildContext context) {
    final tileComponents = TileComponents<Event>(
      tileBuilder: (event) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      dropTargetTile: _dropTargetTile,
      feedbackTileBuilder: _feedbackTileBuilder,
      tileWhenDraggingBuilder: _tileWhenDraggingBuilder,
      dragAnchorStrategy: dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );

    final multiDayTileComponents = TileComponents<Event>(
      tileBuilder: (event) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0.5),
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      dropTargetTile: _dropTargetTile,
      feedbackTileBuilder: _feedbackTileBuilder,
      tileWhenDraggingBuilder: _tileWhenDraggingBuilder,
      dragAnchorStrategy: dragAnchorStrategy,
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );

    const monthBodyComponents = MonthBodyComponents(
      leftPageTriggerWidget: TriggerWidget(),
      rightPageTriggerWidget: TriggerWidget(),
    );
    const multiDayBodyComponents = MultiDayBodyComponents(
      leftPageTriggerWidget: TriggerWidget(),
      rightPageTriggerWidget: TriggerWidget(),
    );
    const multiDayHeaderComponents = MultiDayHeaderComponents(
      leftPageTriggerWidget: TriggerWidget(),
      rightPageTriggerWidget: TriggerWidget(),
    );

    final calendarDateTime = ValueListenableBuilder(
      valueListenable: controller.visibleDateTimeRange,
      builder: (context, value, child) {
        final year = value.start.year;
        final month = value.start.monthNameEnglish;

        return FilledButton.tonal(
          onPressed: () {},
          style: FilledButton.styleFrom(
            minimumSize: const Size(50, 48),
          ),
          child: Text('$month $year'),
        );
      },
    );

    final navigationHeader = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          calendarDateTime,
          IconButton.filledTonal(
            onPressed: () async {
              await controller.animateToPreviousPage();
            },
            icon: const Icon(Icons.navigate_before),
          ),
          IconButton.filledTonal(
            onPressed: () {
              controller.animateToNextPage();
            },
            icon: const Icon(Icons.navigate_next),
          ),
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
                  dropdownMenuEntries: viewConfigurations
                      .map((e) => DropdownMenuEntry(value: e, label: e.name))
                      .toList(),
                  initialSelection: viewConfiguration,
                  onSelected: (value) {
                    if (value == null) return;
                    onSelected(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final calendarHeader = CalendarHeader<Event>(
      multiDayTileComponents: multiDayTileComponents,
      multiDayHeaderConfiguration: headerConfiguration,
      multiDayHeaderComponents: multiDayHeaderComponents,
    );

    final header = Material(
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 2,
      child: Column(
        children: [
          navigationHeader,
          if (showHeader) calendarHeader,
        ],
      ),
    );

    final calendarBody = CalendarBody<Event>(
      multiDayTileComponents: tileComponents,
      monthTileComponents: tileComponents,
      monthBodyComponents: monthBodyComponents,
      multiDayBodyComponents: multiDayBodyComponents,
      multiDayBodyConfiguration: bodyConfiguration,
      monthBodyConfiguration: headerConfiguration,
    );

    return CalendarView<Event>(
      calendarController: controller,
      eventsController: eventsController,
      viewConfiguration: viewConfiguration,
      header: header,
      body: calendarBody,
      callbacks: callbacks,
    );
  }

  Widget _feedbackTileBuilder(CalendarEvent event, Size dropTargetWidgetSize) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: dropTargetWidgetSize.width * 0.8,
      height: dropTargetWidgetSize.height,
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(150),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _tileWhenDraggingBuilder(CalendarEvent event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _dropTargetTile(CalendarEvent event) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Offset dragAnchorStrategy(
    Draggable draggable,
    BuildContext context,
    Offset position,
  ) {
    final renderObject = context.findRenderObject()! as RenderBox;
    return Offset(
      20,
      renderObject.size.height / 2,
    );
  }
}
