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
final eventsController = EventsController();

/// Create [CalendarController]
final calendarController = CalendarController();

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
  // Create your TileComponents.
  final tileComponents = TileComponents(
    tileBuilder: (event) => Container(color: Colors.green),
  );

  // Create the header Widget.
  final header = CalendarHeader(
    multiDayTileComponents: tileComponents,
  );

  // Create the body Widget.
  final body = CalendarBody(
    multiDayTileComponents: tileComponents,
    monthTileComponents: tileComponents,
  );

  return CalendarView(
    eventsController: eventsController,
    calendarController: calendarController,
    viewConfiguration: viewConfiguration,
    header: header,
    body: body,
  );
}
```


## Customizing the look

There are a few ways to customize the look of the calendar:
- [Tile Components](#tile-components)
- General Components
  - [Header Components](#header-components)
  - [Body Components](#body-components)

### Tile Components

The `TileComponents` object is used to customize the look of the tiles displayed in the calendar.

```dart
TileComponents(
  // The default builder for stationary event tiles.
  tileBuilder: (event) => Container(),

  // The builder for the stationary event tile. (When it is being dragged)
  tileWhenDraggingBuilder: (event) => Container(),

  // The builder for the feedback tile. (When it is being dragged)
  feedbackTileBuilder: (event, dropTargetWidgetSize) => Container(),

  // The builder for the drop target event tile.
  dropTargetTile: (event) => Container(),

  // The dragAnchorStrategy used by the [feedbackTileBuilder].
  dragAnchorStrategy: childDragAnchorStrategy,

  // The vertical resize handle.
  verticalResizeHandle: Container(),

  // The horizontal resize handle.
  horizontalResizeHandle: Container(),
)
```

### General Components

The general components are split into `Header` and `Body` components.  

Both of these parts have their own `Components` and `ComponentStyles` for every type of `ViewConfiguration`, along with a `TileComponents` for the views that can display tiles.

By default the calendar uses default components which can be customized with `ComponentStyles`, you have the option to override these components by supplying a builder to the `Components` object.


#### Header Components

```dart
CalendarHeader(
  multiDayTileComponents: TileComponents(),
  multiDayHeaderComponents: MultiDayHeaderComponents(),
  multiDayHeaderComponentStyles: MultiDayHeaderComponentStyles(),
);
```  

### Body Components

```dart
CalendarBody(
  multiDayTileComponents: TileComponents(),
  multiDayBodyComponents: MultiDayBodyComponents(),
  multiDayBodyComponentStyles: MultiDayBodyComponentStyles(),
);
```  

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