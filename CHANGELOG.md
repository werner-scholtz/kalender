## 0.3.5
- Added animateToDateTime to CalendarController.

## 0.3.4
- Fixed visibleStartTimeOfDay not taking start and end hours into account.

## 0.3.3
- Split animateToDate into animateToDate and animateToDateTime.
- Added visibleStartTimeOfDay to calendar state.
  This is the current timeOfDay that the viewport's upper edge is displaying.

## 0.3.2
- Fixed some more DST bugs.
- animateToDate now animates to the specified time.

## 0.3.1
* Fixed DST navigation issues.

## 0.3.0
* Fixed DST issues.
* Added export for tile_handle_style.

## 0.2.3
* Fixed incorrect display of events in the MonthView.
* Added intl package to dependencies.
* DayHeaderStyle: now takes a dateFormat String.
* MonthHeaderStyle: now takes a dateFormat String.

#### Breaking Changes:
* ScheduleMonthHeaderStyle now takes a dateFormat String instead.

## 0.2.2
* Fixed issue with EventGroupBasicLayoutDelegate.

## 0.2.1
* Improvements to the MultiDayHeaderPanel.
* Improvements to the EventGroupBasicLayoutDelegate.
* Added CreateEventTrigger.
* Minor bug fixes.

## 0.2.0
* Added initialHeightPerMinute.
* Fixed MultiDayView header shadow issue.
* Added hourLineLeftMargin to control the left margin of the hour line.

## 0.1.9
* Fixed start and end hour issue.

## 0.1.8
* Fixed enable resize option not working.
  
## 0.1.7
* Fixed alignment issues.
* Changes to layout.
* Added options to enable/disable Resizing and Rescheduling.
* ViewConfiguration is now a ChangeNotifier so making changes to it will now update the view.
* Added Custom Start and End Hours to MultiDayViewConfiguration.

#### Breaking Changes:
* onCreateEvent is now split into onCreateEvent and onEventCreated.

## 0.1.6
* Fixed some gesture bugs.
* Added name parameter to pre-defined multi day configurations.
* Fixed time indicator bug.

## 0.1.5
* Added event tileHandleBuilder for mobile.
* Added mobile reschedule / resize docs.
* Changed event tile layout to use integer values.
* Bug fixes.

## 0.1.4
* Fixed selected date.

## 0.1.3
* Updated example.
* Renamed MultiDayEventGroupLayoutController to MultiDayEventsLayoutController.

## 0.1.2
#### Breaking Changes:
* Added schedule view (so CalendarView now requires schedule widget)
* Fixed typo in CalendarEvent (modifyable => modifiable)

## 0.1.1
* Fixed custom layout delegate.

## 0.1.0

#### Breaking Changes:
* Changed the way events are rendered. (See example)
* Removed Single Day view (Is now classified as multi day view with 1 day visible).

## 0.0.8

* Fixed FirstDayOfWeek bugs.
* Tile stack improvements.

## 0.0.7

* Reworked Event Selection and Changing events.

## 0.0.6

* Added onChangeStart callback.
* Added vertical scroll lock and unlock.
* Fixed timeIndicator snap points.

## 0.0.5
* Added verticalStepDuration (Duration of each vertical step while dragging).
* Added custom LayoutControllers.
* Added custom LayoutControllers example.
* Added modifiable parameter to CalendarEvent.
* Bug fixes (Getting stuck while dragging event)

## 0.0.4

* Fixed link to web example.
* Fixed bugs on mobile.
* Removed intl dependency.

## 0.0.3

* Fixed desktop_views.png in README.md

## 0.0.2

* Fixed images in README.md

## 0.0.1

* Initial Release











