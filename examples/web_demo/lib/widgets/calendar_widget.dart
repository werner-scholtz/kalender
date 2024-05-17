import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/widgets/resize_handle.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarController controller;
  final EventsController eventsController;
  final ViewConfiguration viewConfiguration;
  final List<ViewConfiguration> viewConfigurations;
  final void Function(ViewConfiguration value) onSelected;
  final CalendarCallbacks callbacks;

  const CalendarWidget({
    super.key,
    required this.controller,
    required this.eventsController,
    required this.viewConfiguration,
    required this.viewConfigurations,
    required this.onSelected,
    required this.callbacks,
  });

  @override
  Widget build(BuildContext context) {
    final tileComponents = TileComponents(
      tileBuilder: (event) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      dropTargetTile: (event) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      feedbackTileBuilder: (event, dropTargetWidgetSize) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: dropTargetWidgetSize.width * 0.8,
          height: dropTargetWidgetSize.height,
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(150),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      tileWhenDraggingBuilder: (event) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      dragAnchorStrategy: (draggable, context, position) {
        final renderObject = context.findRenderObject()! as RenderBox;
        return Offset(
          20,
          renderObject.size.height / 2,
        );
      },
      verticalResizeHandle: const VerticalResizeHandle(),
      horizontalResizeHandle: const HorizontalResizeHandle(),
    );

    final calendarHeader = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
    );

    final multiDayHeader = MultiDayHeader(
      eventsController: eventsController,
      calendarController: controller,
      tileComponents: tileComponents,
    );

    final header = Material(
      color: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 2,
      child: Column(
        children: [
          calendarHeader,
          multiDayHeader,
        ],
      ),
    );

    final multiDayBody = MultiDayBody(
      heightPerMinute: ValueNotifier(0.5),
      tileComponents: tileComponents,
    );

    return CalendarView(
      calendarController: controller,
      eventsController: eventsController,
      viewConfiguration: viewConfiguration,
      header: header,
      body: multiDayBody,
      callbacks: callbacks,
    );
  }
}
