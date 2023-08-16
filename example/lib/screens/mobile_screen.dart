import 'package:example/models/event.dart';
import 'package:example/widgets/calendar_header_mobile.dart';
import 'package:example/widgets/calendar_tiles/tiles_export.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({
    super.key,
    required this.eventsController,
    required this.viewConfigurations,
  });

  final CalendarEventsController<Event> eventsController;
  final List<ViewConfiguration> viewConfigurations;

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  late CalendarEventsController<Event> eventsController;
  late CalendarController<Event> calendarController;
  late CalendarComponents components;
  late CalendarEventHandlers<Event> eventHandlers;

  /// The list of view configurations that can be used.
  late List<ViewConfiguration> viewConfigurations = widget.viewConfigurations;

  /// The current view configuration.
  late ViewConfiguration currentConfiguration = viewConfigurations.first;

  /// The selected event.
  CalendarEvent<Event>? selectedEvent;

  @override
  void initState() {
    super.initState();
    eventsController = widget.eventsController;
    calendarController = CalendarController<Event>();
  }

  @override
  void didUpdateWidget(covariant MobileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.eventsController != oldWidget.eventsController) {
      eventsController = widget.eventsController;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalendarView<Event>(
          controller: calendarController,
          eventsController: eventsController,
          viewConfiguration: currentConfiguration,
          tileBuilder: _tileBuilder,
          multiDayTileBuilder: _multiDayTileBuilder,
          monthTileBuilder: _monthEventTileBuilder,
          components: CalendarComponents(
            calendarHeaderBuilder: _calendarHeader,
          ),
          eventHandlers: CalendarEventHandlers<Event>(
            onEventChanged: onEventChanged,
            onEventTapped: onEventTapped,
            onCreateEvent: onCreateEvent,
            onDateTapped: onDateTapped,
          ),
        ),
      ),
      bottomSheet: selectedEvent != null
          ? SizedBox(
              height: 100,
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    selectedEvent?.eventData?.title.toString() ?? 'New Event',
                  ),
                ],
              ),
            )
          : null,
    );
  }

  mainBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SizedBox(
          height: 300.0,
          child: Center(
            child: Text("Demo Text"),
          ),
        );
      },
    );
  }

  /// This function is called when a new event is created.
  Future<CalendarEvent<Event>?> onCreateEvent(newEvent) async {
    newEvent.eventData = Event(
      title: 'New Event',
      color: Colors.blue,
    );

    setState(() {
      selectedEvent = newEvent;
    });

    // return the new event. (if the user cancels the dialog, null is returned)
    return newEvent;
  }

  /// This function is called when an event is tapped.
  Future<void> onEventTapped(event) async {
    setState(() {
      if (selectedEvent == event) {
        selectedEvent = null;
      } else {
        selectedEvent = event;
      }
    });
  }

  /// This function is called when an event is changed.
  Future<void> onEventChanged(
    DateTimeRange initialDateTimeRange,
    CalendarEvent<Event> event,
  ) async {
    setState(() {
      selectedEvent = event;
    });
  }

  /// This function is called when a date is tapped.
  void onDateTapped(date) {
    // If the current view is not the single day view, change the view to the single day view.
    if (currentConfiguration is! SingleDayViewConfiguration) {
      setState(() {
        // Set the selected date to the tapped date.
        calendarController.selectedDate = date;
        currentConfiguration = viewConfigurations.first;
      });
    }
  }

  Widget _calendarHeader(dateTimeRange) {
    return CalendarHeaderMobile(
      calendarController: calendarController,
      viewConfigurations: viewConfigurations,
      currentConfiguration: currentConfiguration,
      onViewConfigurationChanged: (viewConfiguration) {
        setState(() {
          currentConfiguration = viewConfiguration;
        });
      },
      dateTimeRange: dateTimeRange,
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<Event> event,
    MultiDayTileConfiguration tileConfiguration,
  ) {
    return MultiDayEventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }

  Widget _tileBuilder(
    CalendarEvent<Event> event,
    TileConfiguration tileConfiguration,
  ) {
    return EventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      drawOutline: tileConfiguration.drawOutline,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }

  Widget _monthEventTileBuilder(
    CalendarEvent<Event> event,
    MonthTileConfiguration tileConfiguration,
  ) {
    return MonthEventTile(
      event: event,
      tileType: tileConfiguration.tileType,
      date: tileConfiguration.date,
      continuesBefore: tileConfiguration.continuesBefore,
      continuesAfter: tileConfiguration.continuesAfter,
    );
  }
}
