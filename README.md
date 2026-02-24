<p align="center">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/banner.png?raw=true" width="100%" style="border-radius:6px; margin-top:8px; margin-bottom:8px;" />
</p>

# Kalender
This Flutter package offers a Calendar Widget featuring a Day, MultiDay, Month and Schedule views. Moreover, it empowers you to tailor the visual and behavioral aspects of the calendar. Check out the demo [here](https://werner-scholtz.github.io/kalender/)
This package is still in development so changes to the API will most likely occur until version 1.0.0

## Features

* **Views:** Day, Multi-day, Month and Schedule. [find out more](#views)
* **Reschedule:** Drag and Drop events. 
* **Resize:** Resize events on desktop and mobile.
* **Controllers:** Manage your calendar with these controllers. [find out more](#controllers)
* **Behavior:** Choose how you want to handle interaction with the calendar. [find out more](#behavior)
* **Appearance:** Customize the default components or provide custom builders. [find out more](#general-components)
* **Event layout:** Use a provided layout strategy or create a custom one. [find out more](#event-layout)
* **Locale:** Provide a locale for the desired language. [find out more](#locale)
* **Location:** Provide a location from the [timezone](https://pub.dev/packages/timezone) package [find out more](#location)

## Roadmap

### Features
* **Views:** FreeScroll calender view.

## Preview

### MultiDayView
Displays one or more days with time on the vertical axis, ideal for detailed scheduling.

<div style="padding:8px; display:inline-block; text-align:center;">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_day_light.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_day_dark.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_day_light.png?raw=true" width="9%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_day_dark.png?raw=true" width="9%" style="border-radius:6px;" />
</div>

<div style="padding:8px; display:inline-block; text-align:center;">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_week_light.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_week_dark.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_week_light.png?raw=true" width="9%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_week_dark.png?raw=true" width="9%" style="border-radius:6px;" />
</div>

### MonthView
Shows an entire month at a glance, with days arranged horizontally.

<div style="border-radius:8px; padding:8px; display:inline-block; text-align:center;">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_month_light.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_month_dark.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_month_light.png?raw=true" width="9%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_month_dark.png?raw=true" width="9%" style="border-radius:6px;" />
</div>


### ScheduleView
Presents events in a continuous, scrollable list, focusing on upcoming or grouped events rather than a grid.

<div style="padding:8px; display:inline-block; text-align:center;">
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_schedule_light.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/desktop_schedule_dark.png?raw=true" width="37%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_schedule_light.png?raw=true" width="9%" style="border-radius:6px; margin-right:8px;" />
  <img src="https://github.com/werner-scholtz/kalender/blob/main/readme_assets/mobile_schedule_dark.png?raw=true" width="9%" style="border-radius:6px;" />
</div>

## Basic Usage

A minimal example to get you started:

```dart
final eventsController = DefaultEventsController();
final calendarController = CalendarController();

/// Add a [CalendarEvent] to the [DefaultEventsController].
void addEvents() {
  final now = DateTime.now();
  eventsController.addEvent(CalendarEvent(
    dateTimeRange: DateTimeRange(start: now, end: now.add(const Duration(hours: 1))),
  ));
}

Widget build(BuildContext context) {  
  return CalendarView(
    eventsController: eventsController,
    calendarController: calendarController,
    // The calender widget will automatically display the correct header & body widgets based on the viewConfiguration.
    viewConfiguration: MultiDayViewConfiguration.singleDay(),
    callbacks: CalendarCallbacks(
      onEventTapped: (event, renderBox) => controller.selectEvent(event),
      onEventCreate: (event) => event,
      onEventCreated: (event) => eventsController.addEvent(event),
    ),
    header: CalendarHeader(),
    body: CalendarBody(),
  );
}
```


TODO: Add an example of how to extend the CalendarEvent class.

TODO: Add an example of how to add custom tile builders with the new approach.

TODO: Add a note about overriding the on event create with a constructor for the custom class.

## Views

The Kalender package supports three main calendar views (by default), each tailored for different scheduling needs. You can switch between these views by providing the appropriate `ViewConfiguration` to the `CalendarView` widget.

When the `CalenderView` switches between different `ViewConfiguration`s it uses the `initialDateSelectionStrategy` function defined in the view configuration object, to determine which day(s) should be visible.

All `ViewConfigurations` take a display range which specifies the range the calendar can display, they can also take a date time which is used to determine the initial visible range of the calendar view.

### MultiDay View
Displays one or more days with time on the vertical axis, ideal for detailed scheduling (e.g., day, week, or custom ranges).

**Constructors:**
- `MultiDayViewConfiguration.singleDay()` – single day view.
- `MultiDayViewConfiguration.week()` – full week view.
- `MultiDayViewConfiguration.workWeek()` – Monday to Friday.
- `MultiDayViewConfiguration.custom(days: n)` – custom number of days.

### Month View
Shows an entire month at a glance, with days arranged horizontally and weeks vertically.

**Constructors:**
- `MonthViewConfiguration.singleMonth()`

### Schedule View
Presents events in a continuous, scrollable list, focusing on upcoming or grouped events rather than a grid.

**Constructors:**
- `ScheduleViewConfiguration.continuous()` – single, continuous list of events.
- `ScheduleViewConfiguration.paginated()` – paginated by month.

## Controllers

The two controllers EventsController and CalendarController do what their names imply.

### EventsController

The [EventsController](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/events_controller.dart#L8) manages and exposes events to calendar widgets. Usually there will only be one of these per app.
It has a few functions to manipulate events:
- `addEvent` Add a new event.
- `addEvents` Add multiple new events.
- `removeEvent` Remove a event.
- `removeEvents` Removes a list of events.
- `removeWhere` Remove events where they match a test case.
- `updateEvent` Updates an event.
- `byId` Returns an event with the given id if it exists.
- `clearEvents` Clear all the stored events.
- `eventsFromDateTimeRange` Returns events that occur during the given dateTimeRange.

### CalendarController

The [CalendarController](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/calendar_controller.dart#L15) allows you to manage a single calendar widget. 

It exposes details about what the widget is displaying.

- `visibleDateTimeRange`: A `ValueNotifier` containing the `DateTimeRange` that is currently visible.
- `visibleEvents`: A `ValueNotifier` that contains the `CalendarEvent`s that are currently visible. 
- `selectedEvent`: A `ValueNotifier` that contains the selected `CalendarEvent`.

> The `selectedEvent` is the event that currently has focus within the calendar widget. This results in the [TileComponents.dropTargetTile](https://github.com/werner-scholtz/kalender/blob/4506024937ae4e0d500bf169d297cb3f20604e92/lib/src/models/components/tile_components.dart#L27) being rendered on top of the selected event's widget, on mobile if a event is selected it wil render the resize handles as well.

This controller has a few functions for navigating the calendar widget:

- `jumpToPage`: Jump to a specific page.
- `jumpToDate`: Jump to a specific date.
- `animateToNextPage`: Animate to the next page.
- `animateToPreviousPage`: Animate to the previous page.
- `animateToDate`: Animate to the given date.
- `animateToDateTime`: Animate to the given date time.
- `animateToEvent` Animate to the given event.

> The `CalendarController` uses a [ViewController](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/view_controller.dart#L8) internally, which provides navigation and state management for a specific calendar view type (MultiDay, Month, or Schedule).  
>
> There are specialized implementations of `ViewController` for each view:
> - [MultiDayViewController](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/view_controller.dart#L70)
> - [MonthViewController](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/view_controller.dart#L243)
> - [ScheduleViewController](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/controllers/view_controller.dart#L349)
>
> Each of these controllers works with a corresponding [ViewConfiguration](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/models/view_configurations/view_configuration.dart#L11) (such as `MultiDayViewConfiguration`, `MonthViewConfiguration`, or `ScheduleViewConfiguration`) to handle view-specific logic and behaviors.


## Behavior

### Callbacks

The calendar has a few useful callback functions, which can change how interactions with the calendar widget is handled.

<details>
  <summary>CalendarCallbacks details</summary>

  ```dart
  CalendarCallbacks(
    // Called when an event is tapped.
    onEventTapped: (event, renderBox) {},

    // Called when an event is to be created.
    onEventCreate: (event) {
      // This allows you to modify the event before it is created.
      return event.copyWith(data: data);
    }

    // Called when an event is to be created.
    onEventCreateWithDetail: (event, detail) {
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
    onPageChanged: (visibleDateTimeRange) {},

    // Called when a calendar view is tapped.
    onTapped: (date) {},
    onTappedWithDetail: (detail) {
      // Details contains an exact DateTime or DateTimeRange depending on the view that was tapped.
      // Along with a renderBox of the gesture detector and local offset of the tap.
    },

    // Called when a calendar view is long pressed.
    onLongPressed: (date) {},
    onLongPressedWithDetail: (detail) {
      // Details contains an exact DateTime or DateTimeRange depending on the view that was long pressed.
      // Along with a renderBox of the gesture detector and local offset of the longPress.
    },

    // The callback for when a drag target is evaluating whether to accept a draggable, on a vertical view. (Day/Week)
    // See [VerticalDragTarget.onWillAcceptWithDetails] for default behavior.
    onWillAcceptWithDetailsVertical: (details, controller, configuration) {
      return true;
    }
    // The callback for when a drag target is evaluating whether to accept a draggable, on a horizontal view. (Month/Day Header)
    // See [HorizontalDragTarget.onWillAcceptWithDetails] for default behavior.
    onWillAcceptWithDetailsHorizontal: (details, controller, configuration) {
      return true;
    }
  )
  ```
  </summary>
</details>

### Event Tile Utilities

The package provides utility mixins to help you build interactive custom event tiles with common functionality like position-to-time conversion and finding nearby events.

For single-day or multi-day view event tiles, use the `DayEventTileUtils` mixin:
<details>
  <summary>DayEventTileUtils</summary>

  ```dart
  class CustomDayEventTile extends StatelessWidget with DayEventTileUtils<MyEventData> {
    @override
    final CalendarEvent<MyEventData> event;
    
    @override
    final DateTimeRange tileRange;
    
    const CustomDayEventTile({
      super.key,
      required this.event,
      required this.tileRange,
    });

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTapUp: (details) {
          // Get the exact time that was tapped within the event
          final tappedTime = dateTimeFromPosition(context, details.localPosition);
          print('Tapped at: $tappedTime');

          // Find events that occur around the same time
          final nearby = nearbyEvents(
            context,
            before: const Duration(minutes: 15),
            after: const Duration(minutes: 15),
          );

          print('Found ${nearby.length} nearby events');
        },
        child: Container(
          decoration: BoxDecoration(
            color: event.data?.color ?? Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Text(
            event.data?.title ?? 'Event',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
  ```
  </summary>
</details>
 
For event tiles that span multiple days (like in month view), use the `MultiDayEventTileUtils` mixin:

<details>
  <summary>MultiDayEventTileUtils</summary>

  ```dart
  class CustomMultiDayEventTile extends StatelessWidget with MultiDayEventTileUtils<MyEventData> {
    @override
    final CalendarEvent<MyEventData> event;
    
    @override
    final DateTimeRange tileRange;
    
    const CustomMultiDayEventTile({
      super.key,
      required this.event,
      required this.tileRange,
    });

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTapUp: (details) {
          // Get the specific date that was tapped within the multi-day event
          final tappedDate = dateFromPosition(context, details.localPosition);
          print('Tapped on date: ${tappedDate.toString()}');
          
          // Find other events on the same date range
          final overlappingEvents = nearbyEvents(context);
          print('Found ${overlappingEvents.length} overlapping events');
        },
        child: Container(
          decoration: BoxDecoration(
            color: event.data?.color ?? Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            event.data?.title ?? 'Multi-day Event',
            style: const TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }
  ```
  </summary>
</details>




### Header and Body

The `CalendarHeader` and `CalendarBody` both take configuration object's for the different `ViewConfigurations`.
Some behaviors that can be customized:
- Page/Scroll navigation when rescheduling events.
- Page/Scroll physics.
- Event layout strategy.

The `CalendarHeader` and `CalendarBody` also take a `CalendarInteraction` ValueNotifier, which allows you to change how the user is allowed to interact with the calendar.
- allowResizing
- allowRescheduling
- allowEventCreation
- createEventGesture

The `CalendarBody` takes a `CalendarSnapping` ValueNotifier that allows you to customize how snapping works for Day/Multiday views.
- snapIntervalMinutes
- snapToTimeIndicator
- snapToOtherEvents
- snapRange
- eventSnapStrategy


Examples:
<details>
  <summary>MultiDayHeaderConfiguration</summary>

  ```dart
  CalendarHeader(
    multiDayHeaderConfiguration: MultiDayHeaderConfiguration(
      // Whether to show event tiles, useful if you want to display the header but not the tiles.
      showTiles: true,
      // The height of the tiles.
      tileHeight: 24,
      // Multi day event layout.
      generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator,
      // Maximum number of vertical events.
      maximumNumberOfVerticalEvents: null,
      // The padding used around events.
      eventPadding: EdgeInserts.zero,
      // The configuration for triggering page navigation.
      pageTriggerConfiguration: PageTriggerConfiguration(),
      // The configuration for triggering scroll navigation.
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
    ),
    interaction: ValueNotifier(
      CalendarInteraction(
        // Allow events to be resized.
        allowResizing: true,
        // Allow events to be rescheduled.
        allowRescheduling: true,
        // Allow events to be created.
        allowEventCreation: true,
      ),
    ),
  );
  ```

  </summary>
</details>

<details>
  <summary>MultiDayBodyConfiguration</summary>

  ```dart
  CalendarBody(
    multiDayBodyConfiguration: MultiDayBodyConfiguration(
      // Whether to show events that are longer than 1 day.
      showMultiDayEvents: true,
      // The padding between events and the edge of the day.
      horizontalPadding: EdgeInsets.only(left: 0, right: 4),
      // The minimum height of a tile.
      minimumTileHeight: 24.0,
      // The configuration for triggering page navigation.
      pageTriggerConfiguration: PageTriggerConfiguration(),
      // The configuration for triggering scroll navigation.
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
      // The layout strategy used by the body to layout events.
      eventLayoutStrategy: overlapLayoutStrategy,
      // The physics used by the scrollable body.
      scrollPhysics: BouncingScrollPhysics(),
      // The physics used by the page view.
      pageScrollPhysics: BouncingScrollPhysics(),
    ),
    interaction: ValueNotifier(
      CalendarInteraction(
        // Allow events to be resized.
        allowResizing: true,
        // Allow events to be rescheduled.
        allowRescheduling: true,
        // Allow events to be created.
        allowEventCreation: true,
      ),
    ),
    snapping: ValueNotifier(
      CalendarSnapping(
        snapIntervalMinutes: 15,
        // Whether to snap to the time indicator.
        snapToTimeIndicator: true,
        // Whether to snap to other events.
        snapToOtherEvents: true,
        // The range in which events will be snapped,
        // ex. 15 minutes: A event will snap to other events that are within 15 minutes from it.
        snapRange: Duration(minutes: 5),
        // The strategy used to snap events to specific intervals.
        eventSnapStrategy: defaultSnapStrategy,
      ),
    ),
  );
  ```

  </summary>
</details>

<details>
  <summary>MonthBodyConfiguration</summary>

  ```dart
  CalendarBody(
    monthBodyConfiguration: MonthBodyConfiguration(
      // Whether to show event tiles, useful if you want to display the header but not the tiles.
      showTiles: true,
      // The height of the tiles.
      tileHeight: 24,
      // Multi day frame generator.
      generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator,
      // The padding used around events.
      eventPadding: EdgeInserts.zero,
      // The layout strategy used to layout events.
      eventLayoutStrategy: defaultMultiDayLayoutStrategy,
      // The configuration for triggering page navigation.
      pageTriggerConfiguration: PageTriggerConfiguration(),
      // The configuration for triggering scroll navigation.
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
    ),
    interaction: ValueNotifier(
      CalendarInteraction(
        // Allow events to be resized.
        allowResizing: true,
        // Allow events to be rescheduled.
        allowRescheduling: true,
        // Allow events to be created.
        allowEventCreation: true,
      ),
    ),
  );
  ```
  </summary>
</details>

<details>
  <summary>ScheduleViewConfiguration</summary>

  ```dart
  CalendarBody(
    scheduleBodyConfiguration: ScheduleBodyConfiguration(
      // Behavior of empty days in the schedule body.
      emptyDay: EmptyDayBehavior.hide,
      // The configuration for triggering page navigation.
      pageTriggerConfiguration: PageTriggerConfiguration(),
      // The configuration for triggering scroll navigation.
      scrollTriggerConfiguration: ScrollTriggerConfiguration(),
      // The physics used by the scrollable body.
      scrollPhysics: BouncingScrollPhysics(),
      // The physics used by the page view. (for paginated views)
      pageScrollPhysics: BouncingScrollPhysics(),
    ),
    interaction: ValueNotifier(
      CalendarInteraction(
        // Allow events to be resized.
        allowResizing: true,
        // Allow events to be rescheduled.
        allowRescheduling: true,
        // Allow events to be created.
        allowEventCreation: true,
      ),
    ),
  );
  ```
  </summary>
</details>

### Zoom Example

It is possible to zoom the calendar in/out.
The [`demo`](https://github.com/werner-scholtz/kalender/tree/main/examples/demo) example shows how this can be accomplished with the [CalendarZoomDetector](https://github.com/werner-scholtz/kalender/blob/main/examples/demo/lib/widgets/zoom.dart)


## Customizing the look

There are a few ways to customize the look of the calendar:
- [Tile Components](#tile-components) allows you change the look of events rendered in the calendar.
- [Schedule Tile Components]() 

General Components:
- [Multi-day Components](#custom-components) allows you to change the look of the day and multi-day views.
- [Month Components](#custom-components) allows you to change the look of the month view.
- [Schedule Components](#custom-components)

### Tile Components

The `TileComponents` object is used to customize the look of the tiles displayed in the calendar.
The `CalendarBody` and `CalendarHeader` have a `TileComponents` object that can be customized.

<details>
  <summary>TileComponents details</summary>

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
  </summary>
</details>

<details>
  <summary>ScheduleTileComponents details</summary>

  ```dart
  ScheduleTileComponents(
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

    // The builder for empty items.
    emptyItemBuilder: (tileRange) => Container(),

    // The builder for month items.
    monthItemBuilder: (monthRange) => Container(),
  )
  ```
  </summary>
</details>


### General Components

The CalendarView takes a components object.

> For every type of `ViewConfiguration` there are `Header` and `Body` components which can be customized.

By default the calendar uses default components which can be customized with `ComponentStyles`, you have the option to override these components by supplying a builder to the `Components` object.

#### Default Component Styles

> You can style the default components by passing the CalendarView `CalendarComponents` object that contains a [`MonthComponentStyles`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/month_styles.dart) and/or [`MultiDayComponentStyles`](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/multi_day_styles.dart) and/or
[`ScheduleComponents`](https://github.com/werner-scholtz/kalender/blob/d5f973c176e97118792c919dda58699b24af19f7/lib/src/models/components/schedule_components.dart#L5)
#### Custom Components

<details>
  <summary>MonthComponents</summary>

  ```dart
  CalendarView(
    components: CalendarComponents(
      monthComponents: MonthComponents(
        headerComponents: MonthHeaderComponents(
          // Custom day header builder.
          weekDayHeaderBuilder: (date, style) => SizedBox(),
        ),
        bodyComponents: MonthBodyComponents(
          // Custom day header for month cells.
          monthDayHeaderBuilder(date, style) => SizedBox(),

          // Custom grid builder.
          monthGridBuilder: (style) => SizedBox(),

          // Custom left trigger. (Must constrain the width)
          leftTriggerBuilder: (pageWidth) => SizedBox(),

          // Custom right trigger. (Must constrain the width)
          rightTriggerBuilder: (pageWidth) => SizedBox(),

          // Custom overlay builders.
          overlayBuilders: OverlayBuilders(
            // multiDayOverlayBuilder: , 
            // multiDayOverlayPortalBuilder: , 
            multiDayPortalOverlayButtonBuilder:(portalController, numberOfHiddenRows, style) => SizedBox(),
          ),
        ),
      ),
    ),
  );
  ```

  </summary>
</details>


<details>
  <summary>MultiDayComponents</summary>

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

          // Custom overlay builders.
          overlayBuilders: OverlayBuilders(
            // multiDayOverlayBuilder: , 
            // multiDayOverlayPortalBuilder: , 
            multiDayPortalOverlayButtonBuilder:(portalController, numberOfHiddenRows, style) => SizedBox(),
          ),
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
  </summary>
</details>

<details>
  <summary>ScheduleComponents</summary>

  ```dart
  CalendarView(
    components: CalendarComponents(
      scheduleComponents: ScheduleComponents(
        // Custom leading date builder.
        dayHeaderBuilder: (date, style) => Container(),
        // Custom tile highlight builder.
        scheduleTileHighlightBuilder: (date, dateTimeRange, style, child) => Container(child: child),
      ),
    ),
  );
  ```

  </summary>
</details>

### Locale
The CalenderView has a locale property, if it is unspecified a default locale will be used, this locale will only translate day / month names in the package.

#### Setup 
1. You will need to add the [intl package](https://pub.dev/packages/intl)
2. Make sure you run the `initializeDateFormatting()` function from the intl package in your `main()`.
```dart
void main() async {
  await initializeDateFormatting();
  runApp(const MyApp());
}
```

#### Specify the language for dates and times.
To specify the language you want to use:

```dart
CalendarView(
  locale: 'af_ZA',
)
```

#### Overlay button language.
Currently you will have to override the MultiDayPortalOverlayButtonStyle to completely translate the calender:

```dart
CalendarView(
  components: CalendarComponents(
    overlayStyles: OverlayStyles(
      multiDayPortalOverlayButtonStyle: MultiDayPortalOverlayButtonStyle(
        // Usually displays '$numberOfHiddenRows more' ex `1 more`,
        stringBuilder: (numberOfHiddenRows) => "My Custom Button Text ($numberOfHiddenRows)", 
      )
    )
  ),
);
```

### Location
The `CalendarView` has a `location` property that accepts a `Location` object from the [timezone](https://pub.dev/packages/timezone) package. If unspecified, the default system location is used. Changing the location of the calendar will adjust the start/end times of events to match the specified timezone.

#### Setup 

See [timezone](https://pub.dev/packages/timezone) setup instructions for different platforms, the [web demo](https://github.com/werner-scholtz/kalender/tree/main/examples/web_demo) provides and example of how to set this up.

#### Using Location

To set a specific timezone for your calendar:

```dart
import 'package:timezone/timezone.dart' as tz;

CalendarView(
  location: tz.getLocation('America/New_York'),
  eventsController: eventsController,
  calendarController: calendarController,
  viewConfiguration: viewConfiguration,
  // ... other properties
)
```

#### EventsController with Locations

The [`DefaultEventsController`](lib/src/models/controllers/view_controllers/events_controller/default_events_controller.dart) can be initialized with multiple locations for efficient event querying across timezones. (Recommended you do this if possible).

```dart
final eventsController = DefaultEventsController<Event>(
  locations: [
    tz.getLocation('America/New_York'),
    tz.getLocation('Europe/London'),
    tz.getLocation('Asia/Tokyo'),
  ],
);
```

#### Important Notes

- All events are stored internally in UTC and converted to the specified location when displayed
- Changing the location will automatically update the visible date/time ranges
- Available location identifiers can be found in the [IANA Time Zone Database](https://www.iana.org/time-zones)

### Event layout

#### Vertical layout
The packages makes use of [CustomMultiChildLayout](https://api.flutter.dev/flutter/widgets/CustomMultiChildLayout-class.html) to layout event tiles.
The `CustomMultiChildLayout` uses a [MultiChildLayoutDelegate](https://api.flutter.dev/flutter/rendering/MultiChildLayoutDelegate-class.html) to determine the positions of tiles.

The package provides some default layoutStrategies, [overlapLayoutStrategy](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/layout_delegates/event_layout_delegate.dart#L26) and [sideBySideLayoutStrategy](https://github.com/werner-scholtz/kalender/blob/d79a8ea7fa1474a9085cb835e25a89ed9b7872a5/lib/src/layout_delegates/event_layout_delegate.dart#L41) for day/multi-day views.
You can create your own layoutStrategy, using the two provided strategies as a reference might be useful.

#### Horizontal layout

For horizontal event layouts (such as in the month view or multiday header), the package arranges event tiles in rows, where each row represents events and each column represents a day. Events that span multiple days are displayed as a single tile stretching across the relevant columns.

The layout is managed using a custom [MultiChildLayoutDelegate](https://api.flutter.dev/flutter/rendering/MultiChildLayoutDelegate-class.html), which relies on a **layout frame** (`MultiDayLayoutFrame`) to determine the position and size of each event tile. The layout frame is generated by a strategy function (such as `defaultMultiDayFrameGenerator`) and contains all the metadata needed for rendering:  
- The row and column assignments for each event  
- The total number of rows required  
- A mapping of columns (dates) to the number of rows  
- The list of events to display

The layout frame ensures that:
- Overlapping events are placed on separate rows.
- Multi-day events are visually continuous across the days they span.
- The number of rows adapts to the number of overlapping or multi-day events.

By default, the package provides a layout strategy that:
- Assigns each event to the first available row where it does not overlap with other events.
- Calculates the width of each event tile based on the number of days it spans.
- Updates the layout frame to reflect the current visible date range and event set.

The event order is handled by the strategy function. `defaultMultiDayFrameGenerator` sorts events by their duration and start date by default. To adjust the order, you can provide your own `eventComparator` function to `defaultMultiDayFrameGenerator`:

```dart
CalendarBody(
  monthBodyConfiguration: MultiDayHeaderConfiguration(
    generateMultiDayLayoutFrame: 
    ({required events,
      required textDirection,
      required visibleDateTimeRange}) =>
    defaultMultiDayFrameGenerator(
        eventComparator: (a, b) =>
            a.end.compareTo(b.end),
        visibleDateTimeRange: visibleDateTimeRange,
        events: events,
        textDirection: textDirection
    ),
  ),
)
```
