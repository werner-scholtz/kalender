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

  // Specify some callbacks.
  final callbacks = CalendarCallbacks(
    onEventTapped: (event, renderBox) => controller.selectEvent(event),
    onEventCreate: (event) => event.copyWith(data: "Some data"),
    onEventCreated: (event) => eventsController.addEvent(event),
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
The `CalendarBody` and `CalendarHeader` have a `TileComponents` object that can be customized.

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

  // A widget that allows you to customize where the resize handles are placed vertically.
  // Your widget should extend the `ResizeHandlePositionerWidget`
  verticalHandlePositioner: (startResizeHandle, endResizeHandle, showStart, showEnd) => ResizeHandlePositionerWidget() , 

  // The vertical resize handle.
  verticalResizeHandle: Container(),

  // A widget that allows you to customize where the resize handles are placed horizontally.
  // Your widget should extend the `ResizeHandlePositionerWidget`
  horizontalHandlePositioner: (startResizeHandle, endResizeHandle, showStart, showEnd) => ResizeHandlePositionerWidget() ,

  // The horizontal resize handle.
  horizontalResizeHandle: Container(),
)
```

### General Components

The CalendarView takes a components object.

- For every type of `ViewConfiguration` there are `Header` and `Body` components which can be customized.

By default the calendar uses default components which can be customized with `ComponentStyles`, you have the option to override these components by supplying a builder to the `Components` object.


```dart
CalendarView(
  eventsController: eventsController,
  calendarController: calendarController,
  viewConfiguration: viewConfiguration,
  components: CalendarComponents(
    monthComponents: MonthComponents(
      headerComponents: MonthHeaderComponents(
        // Custom day header builder.
        weekDayHeaderBuilder: (date, style) => SizedBox(),
      ),
      bodyComponents: MonthBodyComponents(
        // Custom grid builder.
        monthGridBuilder: (style) => SizedBox(),
        
        // Custom left trigger. (Must constrain the width)
        leftTriggerBuilder: (pageWidth) => SizedBox(),
        
        // Custom right trigger. (Must constrain the width)
        rightTriggerBuilder: (pageWidth) => SizedBox(),
      ),
    ),
    multiDayComponents: MultiDayComponents(
      headerComponents: MultiDayHeaderComponents(
        // Custom Day Header builder.
        dayHeaderBuilder: (date, style) => CustomWidget(),

        // Custom Week Number builder.
        weekNumberBuilder: (visibleDateTimeRange, style) => CustomWidget(),

        // Custom left trigger. (Must constrain the width)
        leftTriggerBuilder: (pageWidth) => SizedBox(width: pageWidth / 20),

        // Custom right trigger. (Must constrain the width)
        rightTriggerBuilder: (pageWidth) => SizedBox(width: pageWidth / 20),
      ),
      bodyComponents: MultiDayBodyComponents(
        // Custom Hour Line builder.
        hourLines: (heightPerMinute, timeOfDayRange, style) => CustomWidget(),

        // Custom time line builder.
        timeline: (heightPerMinute, timeOfDayRange, style) => CustomWidget(),

        // Custom day separator builder.
        daySeparator: (style) => CustomWidget(),

        // Custom event indicator builder.
        timeIndicator: (timeOfDayRange, heightPerMinute, timelineWidth, style) => CustomWidget(),

        // Left trigger. (Must constrain the width)
        leftTriggerBuilder: (pageHeight) => SizedBox(width: pageHeight / 20),

        // Right trigger. (Must constrain the width)
        rightTriggerBuilder: (pageHeight) => SizedBox(width: pageHeight / 20),

        // Top trigger. (Must constrain the height)
        topTriggerBuilder: (viewPortHeight) => SizedBox(height: viewPortHeight / 20),

        // Bottom trigger. (Must constrain the height)
        bottomTriggerBuilder: (viewPortHeight) => SizedBox(height: viewPortHeight / 20),
      ),
    ),
  ),
);
```

## Customizing the behavior


### Callbacks

The calendar has a few useful callback functions:

```dart
CalendarCallbacks(
  // Called when an event is tapped.
  onEventTapped: (event, renderBox) {},

  // Called when an event is about to be created.
  onEventCreate: (event) {
    // This allows you to modify the event before it is created.
    event.copyWith(data: data);
  }
  
  // Called when a new event is created.
  onEventCreated: (event) {
    // Add the event to the eventsController.
    eventsController.addEvent(event);
  },

  // Called when a event has been changed (rescheduling / resizing)
  onEventChanged: (event, updatedEvent) {
    // Do something with the updated event.
    // ex. Update it in your database/long term storage.
  },

  // Called when a page is changed.
  onPageChanged: (visibleDateTimeRange) {},
)
```


### Header and Body

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
    monthBodyConfiguration: MultiDayHeaderConfiguration(), // The MonthBody makes use the MultiDayHeaderConfiguration
  );
  ```


