This Flutter package offers a Calendar Widget featuring integrated Day, MultiDay view ... TODO: finish this

## Note
- This is a WIP package so there will be some breaking changes until version 1.0.0.

## Web Example

Try it out [here](https://werner-scholtz.github.io/kalender/)

## Features

...


## Basic Usage

```dart
/// Create [EventsController]
final eventsController = EventsController<Event>();

/// Create [CalendarController]
final calendarController = CalendarController<Event>();

/// Create a [ViewConfiguration]
/// 
/// Options:
/// - [MultiDayViewConfiguration.singleDay]
/// - [MultiDayViewConfiguration.week]
/// - [MultiDayViewConfiguration.workWeek]
/// - [MultiDayViewConfiguration.custom]
final viewConfiguration = MultiDayViewConfiguration.singleDay();

@override
void initState() {
  super.initState();

  /// Add events to the [EventsController]
  eventsController.addEvents([...]);
}

Widget build(BuildContext context) {
  
  // Create your tile components.
  final tileComponents = TileComponents<Event>(
    tileBuilder: (event) => Container(color: Colors.green),
  );

  return CalendarView(
    eventsController: eventsController,
    calendarController: calendarController,
    viewConfiguration: viewConfiguration,
    header: CalendarHeader<Event>(),
    body: CalendarBody<Event>(),
  );
}
```


## Callbacks

The calendar has a few useful callback functions:

```dart
CalendarCallbacks(
  // Called when an event is tapped.
  onEventTapped: (event, renderBox) {},

  // Called when a new event is created.
  onEventCreated: (event) {},

  // Called when a event has been changed (rescheduling / resizing)
  onEventChanged: (event, updatedEvent) async {},

  // Called when a page is changed.
  onPageChanged: (visibleDateTimeRange) {},
)
```


## Customizing the look

The Calendar is split into two major parts the Header and the Body.

Both of these parts have their own `Components` and `ComponentStyles` for every type of `ViewConfiguration`, along with a `TileComponents` for the views that can display tiles.

By default the calendar uses default components which can be customized with `ComponentStyles`, you have the option to override these components by supplying a builder to the `Components` object.

1. Header
  ```dart
  CalendarHeader(
    multiDayTileComponents: TileComponents(),
    multiDayHeaderComponents: MultiDayHeaderComponents(),
    multiDayHeaderComponentStyles: MultiDayHeaderComponentStyles(),
  );
  ```


2. Body
  ```dart
  CalendarBody(
    multiDayTileComponents: TileComponents(),
    multiDayBodyComponents: MultiDayBodyComponents(),
    multiDayBodyComponentStyles: MultiDayBodyComponentStyles(),
  );
  ```

### Tile Components

```dart
TileComponents(
  tileBuilder: (event) => Container(),
  dropTargetTile: (event) => Container(),
  tileWhenDraggingBuilder: (event) => Container(),
  feedbackTileBuilder: (event, dropTargetWidgetSize) => Container(),
  dragAnchorStrategy: childDragAnchorStrategy,
  verticalResizeHandle: Container(),
  horizontalResizeHandle: Container(),
)
```

### Header Components
TODO: Add documentation

### Body Components
TODO: Add documentation

## Customizing the behavior

The `CalendarHeader` and `CalendarBody` both take configuration object's for the different `ViewConfigurations`.

Some behaviors that can be customized:
- Allow the user to create events.
- Allow the user to resize events.
- Allow the user to reschedule events.
- The trigger to create a new event.
- Event snapping.
- Page/Scroll navigation when rescheduling events.
- Page/Scroll physics.
- Event layout strategy.

1. Header
  ```dart
  CalendarHeader(
    multiDayHeaderConfiguration: MultiDayHeaderConfiguration(),
  );
  ```

2. Body
  ```dart
  CalendarBody(
    multiDayBodyConfiguration: MultiDayBodyConfiguration(),
  );
  ```





