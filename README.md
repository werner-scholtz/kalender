<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A Flutter package allows you to use a Calendar Widget that has built-in Day, MultiDay, and Month views. 
It also allows you to customize the appearance of the calendar widget.

## Web Example
Try it out [here](https://049er.github.io/kalender/#/)

## Features

<!--TODO: List what your package can do. Maybe include images, gifs, or videos.-->

* Calendar Views - There are 3 calendar views available, Day, MultiDay, and Month.

  <img src="./readme_assets/desktop_views.png" width="100%" height="100%"/>
  (desktop)


  <img src="./readme_assets/mobile_views.png" width="90%" height="90%"/>

  (mobile)

*  Reschedule - Drag and Drop events to your liking.
    <img src="./readme_assets/drag_and_drop.gif" width="75%" height="75%"/>

* Resize - Resize events by dragging the edges of an event.
    <img src="./readme_assets/resize.gif" width="75%" height="75%"/>


* Custom Object - CaledarEvent's can store any object and can be accessed in the builder functions.
    ```dart 
    CalendarEvent<CustomObject>(
      eventData: CustomObject(),
    )
    ```

* Flexible View's - Each of the Calendar View's takes a ViewConfiguration, this has some parameters you can change, OR you can create your own by extending one of the the classes.
```dart
  class YourConfiguration extends SingleDayViewConfiguration {}
  class YourConfiguration extends MultiDayViewConfiguration {}
  class YourConfiguration extends MonthViewConfiguration {}
```
  

* Appearance - 

* Custom Builders - 


## Installation

1. Add this to your package's pubspec.yaml file:
    
    ```
   $ flutter pub add kalender
    ```
2. Import it:   
    
    ```dart
   import 'package:kalender/kalender.dart';
    ```

## Usage

1. Create a custom class to store your data. 
    ```dart
    class Event {
      final String title;
      final Color color;
    
      Event(this.title, this.description);
    }
    ```

2. Create a EventsController
    ```dart
    final eventsController = EventsController<Event>();
    ```
    Add events to the controller
    ```dart
    eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange()
        eventData: Event(  
            title: 'Event 1',
            color: Colors.blue,
        ),
      ),
    );
    ```

3. Create a CalendarController
    ```dart
    final calendarController = CalendarController();
    ```

4. Create tile builders
   ```dart
   Widget _tileBuilder(event, tileConfiguration) => Widget()
   Widget _multiDayTileBuilder(event, tileConfiguration) => Widget()
   Widget _monthEventTileBuilder(event, tileConfiguration) => Widget()
   ```

5. Create a CalendarView
    ```dart
    CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      tileBuilder: _tileBuilder(),
      multiDayTileBuilder: _multiDayTileBuilder(),
      monthTileBuilder: _monthEventTileBuilder(),
    )       
    ```
    


## Additional information


<!-- TODO: Add more info -->