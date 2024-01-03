Reworking the package:

1. Modularize 
 - Find a way to modularize the package so that it is like lego blocks.
 - Most blocks can be used independently or in combination with other blocks.

 CalendarEventsController (Should be able to extend for use with database or other storage)
 - Controller for the calendar events this is used to create, update, delete and view the calendar events.

 CalendarController
 - Controller for the calendar this is used to control the display of the calendar.
 - Can be used to get info about the calendar as well like: Events on screen etc.
 - Can be used to control the calendar like: Go to date, go to next month, go to previous month etc.
 - SubControllers for the calendar views: Month, Week, Day, List etc.





 CalendarView
 - This is the view for the calendar events. It is used to display the calendar events in a calendar view.
 - This will provide the calendar events to all child widgets.
 1. Configurable to show the calendar events in a month, week, day or list view or any combination of these views.



  CalendarView(
    calendarController: CalendarController,
    eventsController: CalendarEventsController,
    view: CalendarViewMonth(
      
    ),
  )

  CalendarViewMonth(
    calendarController: CalendarController,
    eventsController: CalendarEventsController,
  ),

  CalendarViewWeek(
    calendarController: CalendarController,
    vertical ? : bool,
  ),

  CalendarViewList(
    calendarController: CalendarController,
  ),

 