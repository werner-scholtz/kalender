Reworking the package:


Structure:

The ability to have multiple calendars using the same events.

EventsController:
|
|__ CalendarController
|           |
|           |____ Calendar Widget
|               
|
|__ CalendarController
|           |
|           |____ Calendar Widget



Calendar Widget:
(Based loosely on the Scaffold Widget)


// The calendar's background etc is all created by the user.
Calendar(
  // Have the callbacks here.
  onEventChanged: ...,
  onEventTapped: ...,
  onDateTapped: ...,
  onPageChanged: ...,

  // Define the view configuration here. 
  viewConfiguration: ...

  // Build the header here.
  headerBuilder: (context, controller) {
    // Styling the header would be entirely up to the user.
    // Provide a good example.

    // This header widget would need to be correct or automatically build the correct one.
    return CalendarHeader(
      eventTileBuilder: ...
    );
  }

  // Build the body here.

  bodyBuilder (context, controller) {
    // (A) The body would be automatically selected based on the viewConfiguration ?
    // (B) Give the user control over what to display and throw an error if the body does not match the configuration ?
    return CalendarBody(
      eventTileBuilder: ...
    );
  }
)