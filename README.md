This Flutter package offers a Calendar Widget featuring a Day, MultiDay and Month views. Moreover, it empowers you to tailor the visual and behavioral aspects of the calendar.

## Note
- Consider v0.5.0 a new package as it has undergone major changes.
- This is a WIP package so there will be some breaking changes until version 1.0.0.

## Web Example

Try it out [here](https://werner-scholtz.github.io/kalender/)

## Features

* **Views:** Day, Multi-day and Month.
* **Reschedule:** Drag and Drop events. 
* **Resize:** Resize events on desktop, see this for mobile.
* **Interaction:** Decide how you want to handle interaction with the calendar. [find out more]()
* **Appearance:** Customize the default components or provide custom builders. [find out more]()
* **Event layout:** Use a provided layout delegate or create a custom one. [find out more]()

...

## Planned Features

* **Views:** Schedule and FreeScroll.
* **Directionality:** Right to Left directionality.
* **Repeating Events:** Repeating events that only have to be added once.
* **Event layout:** More examples of how to leverage this to achieve different things.

...

## Basic Usage

```dart
final eventsController = EventsController();
final calendarController = CalendarController();
final tileComponents = TileComponents(
  tileBuilder: (event) => Container(color: Colors.green),
);

@override
void initState() {
  super.initState();

  /// Add [CalendarEvent]s to the [EventsController].
  eventsController.addEvents([...]);
}

Widget build(BuildContext context) {  
  return CalendarView(
    eventsController: eventsController,
    calendarController: calendarController,
    viewConfiguration: MultiDayViewConfiguration.singleDay(),
    callbacks: CalendarCallbacks(
      onEventTapped: (event, renderBox) => controller.selectEvent(event),
      onEventCreate: (event) => event.copyWith(data: "Some data"),
      onEventCreated: (event) => eventsController.addEvent(event),
    ),
    header: CalendarHeader(
      multiDayTileComponents: tileComponents,
    ),
    body: CalendarBody(
      multiDayTileComponents: tileComponents,
      monthTileComponents: tileComponents,
    ),
  );
}
```


## Customizing the look

There are a few ways to customize the look of the calendar:
- [Tile Components](#tile-components)

General Components:
- [Multi-day Components](#month-components)
- [Month Components](#tile-components)

### Tile Components

The `TileComponents` object is used to customize the look of the tiles displayed in the calendar.
The `CalendarBody` and `CalendarHeader` have a `TileComponents` object that can be customized.

```dart
TileComponents(
  // The default builder for stationary event tiles.
  tileBuilder: (event) => Container(),

  // The builder for the stationary event tile. (When it is being dragged)
  tileWhenDraggingBuilder: (event) => Container(),

  // The builder for the feedback tile, follows the cursor/finger. (When it is being dragged)
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

#### Month Components

```dart
CalendarView(
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
  ),
);
```

#### Multi-day Components

```dart
CalendarView(
  components: CalendarComponents(
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
    return event.copyWith(data: data);
  }
  
  // Called when a new event has been created.
  onEventCreated: (event) {
    // Add the event to the eventsController.
    eventsController.addEvent(event);
  },

  // Called before a event is changed.
  onEventChange: (event) {}

  // Called when a event has been changed (rescheduled / resized)
  onEventChanged: (event, updatedEvent) {
    // Do something with the updated event.
    // ex. Update it in your database/long term storage.
  },

  // Called when a page is changed.
  //
  // Alternatively you can listen to the [CalendarController.visibleDateTimeRange] for updates.
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

#### Header
```dart
CalendarHeader(
  multiDayHeaderConfiguration: MultiDayHeaderConfiguration(
    // Whether to show event tiles, useful if you want to display the header but not the tiles.
    showTiles: true,
    // The height of the tiles.
    tileHeight: 24,
    // Allow events to be resized.
    allowResizing: true,
    // Allow events to be rescheduled.
    allowRescheduling: true,
    // Allow events to be created.
    allowEventCreation: true,
    // The layout strategy used to layout events.
    eventLayoutStrategy: defaultMultiDayLayoutStrategy,
    // The configuration for the page navigation.
    pageTriggerConfiguration: PageTriggerConfiguration(),
    // The configuration for the scroll navigation.
    scrollTriggerConfiguration: ScrollTriggerConfiguration(),
  ),
);
```

#### Body
```dart
CalendarBody(
  multiDayBodyConfiguration: MultiDayBodyConfiguration(
    // Whether to show events that are longer than 1 day.
    showMultiDayEvents: true,
    // Allow events to be resized.
    allowResizing: true,
    // Allow events to be rescheduled.
    allowRescheduling: true,
    // Allow events to be created.
    allowEventCreation: true,
    // The gesture used to create new events.
    createEventGesture: CreateEventGesture.tap,
    // The snap interval ex. 15 events will snap to every 15 minute interval.
    snapIntervalMinutes: 15,
    // Whether to snap to the time indicator.
    snapToTimeIndicator: true,
    // Whether to snap to other events.
    snapToOtherEvents: true,
    // The range in which events will be snapped, 
    // ex. 15 minutes: A event will snap to other events that are within 15 minutes from it.
    snapRange: Duration(minutes: 5),
    // The duration of events created by the `createEventGesture`
    newEventDuration: Duration(minutes: 30),
    // The configuration for the page navigation.
    pageTriggerConfiguration: PageTriggerConfiguration(),
    // The configuration for the scroll navigation.
    scrollTriggerConfiguration: ScrollTriggerConfiguration(),
    // The layout strategy used by the body to layout events.
    eventLayoutStrategy: overlapLayoutStrategy,
    // The physics used by the scrollable body.
    scrollPhysics: BouncingScrollPhysics(),
    // The physics used by the page view.
    pageScrollPhysics: BouncingScrollPhysics(),
  ),
  // The MonthBody makes use the MultiDayHeaderConfiguration
  monthBodyConfiguration: MultiDayHeaderConfiguration(
    // Whether to show event tiles, useful if you want to display the header but not the tiles.
    showTiles: true,
    // The height of the tiles.
    tileHeight: 24,
    // Allow events to be resized.
    allowResizing: true,
    // Allow events to be rescheduled.
    allowRescheduling: true,
    // Allow events to be created.
    allowEventCreation: true,
    // The layout strategy used to layout events.
    eventLayoutStrategy: defaultMultiDayLayoutStrategy,
    // The configuration for the page navigation.
    pageTriggerConfiguration: PageTriggerConfiguration(),
    // The configuration for the scroll navigation.
    scrollTriggerConfiguration: ScrollTriggerConfiguration(),
  ), 
);
```


