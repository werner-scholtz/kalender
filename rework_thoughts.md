Reworking the package:


Structure:

The ability to have multiple calendars using the same EventsController,
- Feature that would be nice is being able to drag events between calendar widgets :S
  For this to work moving some responsibility from the EventsController to the CalendarController will be necessary.


EventsController
|
|__ CalendarController
|           |
|           |________ ViewController (MultiDay, Month, Schedule)
|                           |
|                           |________ CalendarWidget (CalendarProvider)
|                                           |
|                                           |________ Header
|                                           |
|                                           |
|                                           |________ Body
|




Calendar Widget:
(Based loosely on the Scaffold Widget)

```
// The calendar's background etc is all created by the user.
Calendar(
  // This can be shared across multiple calendars.
  eventsController: 
  // This is specific to this calendar.
  calendarController:

  // Define the view configuration here. 
  viewConfiguration: ...

  // Have the callbacks here.
  onEventChanged: ...,
  onEventTapped: ...,
  onDateTapped: ...,
  onPageChanged: ...,

  // Build the header here.
  headerBuilder: (context, controller) {
    // Styling the header would be entirely up to the user. (Provide a good example)

    // Have some pre-built headers:
    // SingleDayHeader
    // MultiDayHeader
    // MonthHeader
    // YearHeader (Might add)
    // ScheduleHeader is not applicable.
    //
    // Might be nice to have a Header.adaptable() which can switch between the given headers based on the viewConfiguration.


    // It would be possible to return anything here so doing something custom like this is possible.
    // return Column(
    //   children: [
    //     Text("hallo"),
    //     CalendarHeader(),
    //   ],
    // );


    // This header widget would need to be correct or automatically build the correct one.
    return CalendarHeader(
      eventTileBuilder: ...
    );
  }

  // Build the body here. (Funny name :D)
  bodyBuilder (context, controller) {

    // We have a few different bodies:
    // - MultiDay
    // - Month
    // - Schedule
    // - Year (Might add)
    // 
    // Might be nice to have a Body.adaptable() which can switch between the given bodies based on the viewConfiguration.

    return CalendarBody(
      eventTileBuilder: ...
    );
  }
);
```

Taking a closer look at some of the headers:
It would be nice to have a abstract class 

