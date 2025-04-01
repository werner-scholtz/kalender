import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/multi_day_overlay_event_tile.dart';

class MultiDayOverlayPortalWidget<T extends Object?> extends StatefulWidget {
  final EventsController<T> eventsController;
  final CalendarController<T> controller;
  final CalendarCallbacks<T>? callbacks;
  final ValueNotifier<CalendarInteraction> interaction;

  final DateTime date;
  final List<CalendarEvent<T>> events;
  final double tileHeight;
  final TileComponents<T> tileComponents;
  final RenderBox Function() getMultiDayEventLayoutRenderBox;

  const MultiDayOverlayPortalWidget({
    required this.eventsController,
    required this.controller,
    required this.callbacks,
    required this.interaction,
    required this.date,
    required this.events,
    required this.tileHeight,
    required this.tileComponents,
    required this.getMultiDayEventLayoutRenderBox,
    super.key,
  });

  @override
  State<MultiDayOverlayPortalWidget<T>> createState() => _MultiDayOverlayPortalWidgetState<T>();
}

class _MultiDayOverlayPortalWidgetState<T extends Object?> extends State<MultiDayOverlayPortalWidget<T>> {
  final _portalController = OverlayPortalController();

  @override
  void didUpdateWidget(covariant MultiDayOverlayPortalWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.date != widget.date || !oldWidget.events.equals(widget.events)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portalController,
      overlayChildBuilder: (overlayContext) {
        // Define a constant width for the overlay.
        const width = 300.0;
        const headerHeight = 80.0;

        // Get the size of the multi day events layout.
        final multiDayEventsLayoutRenderBox = widget.getMultiDayEventLayoutRenderBox();

        // Get the position of the portal.
        final portalRenderBox = context.findRenderObject() as RenderBox;
        final portalWidth = portalRenderBox.size.width;
        final portalPosition = portalRenderBox.localToGlobal(Offset.zero);

        // Calculate the left and top position of the overlay.
        final top = portalPosition.dy - multiDayEventsLayoutRenderBox.size.height - headerHeight;
        final left = portalPosition.dx - (width / 2) + portalWidth / 2;

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _portalController.hide,
              ),
            ),
            Positioned(
              top: top,
              left: left,
              width: width,
              child: Card(
                child: Column(
                  spacing: 8,
                  children: [
                    SizedBox(
                      height: headerHeight,
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(widget.date.dayNameEnglish),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: IconButton.filledTonal(onPressed: () {}, icon: Text(widget.date.day.toString())),
                            ),
                            Align(
                              // TODO: directionality ?
                              alignment: Alignment.topRight,
                              child: IconButton.filledTonal(
                                onPressed: _portalController.hide,
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListBody(
                        children: [
                          for (final event in widget.events)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: SizedBox(
                                height: widget.tileHeight,
                                child: MultiDayOverlayEventTile(
                                  controller: widget.controller,
                                  eventsController: widget.eventsController,
                                  callbacks: widget.callbacks,
                                  tileComponents: widget.tileComponents,
                                  event: event,
                                  dateTimeRange: widget.date.dayRange,
                                  interaction: widget.interaction,
                                  dismissOverlay: _portalController.hide,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      child: InkWell(
        onTap: _portalController.show,
        child: const Text('...'),
      ),
    );
  }
}
