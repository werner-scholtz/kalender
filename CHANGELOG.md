## 0.7.2

- fix: Calendar event at 00:00 not visible (zero duration) [#159](https://github.com/werner-scholtz/kalender/issues/158)
- fix: Export the necessary classes to allow for custom a `GenerateMultiDayLayoutFrame`. [#162](https://github.com/werner-scholtz/kalender/issues/162)

## 0.7.1

- fix: Calendar event at 00:00 not visible [#159](https://github.com/werner-scholtz/kalender/issues/158)
  * Note: This makes minor changes to the abstract class EventLayoutDelegate.
- fix: Long event causes all following events to intend. [#142](https://github.com/werner-scholtz/kalender/issues/142)

## 0.7.0

### Features
- Ability to limit the number of events in MultiDayHeader.  [#141](https://github.com/werner-scholtz/kalender/pull/141) / [#147](https://github.com/werner-scholtz/kalender/issues/147)
    - `MultiDayHeaderConfiguration` Changes:
        - Added `maximumNumberOfVerticalEvents`
        - Added `generateMultiDayLayoutFrame`
    - Added `overlayBuilders` to `MultiDayHeaderComponents` for customizing the overlay.
- MonthBody limits the number of events displayed based on size constraints. [#141](https://github.com/werner-scholtz/kalender/pull/141) / [#147](https://github.com/werner-scholtz/kalender/issues/147)
    - Added `overlayBuilders` to `MonthBodyComponents` for customizing the overlay.
- Added a new callback `OnEventTappedWithDetail`. [#141](https://github.com/werner-scholtz/kalender/pull/141) / [#148](https://github.com/werner-scholtz/kalender/issues/148)

### Migrations
- Deprecated [MultiDayEventLayoutStrategy](https://github.com/werner-scholtz/kalender/blob/dc009aa40b80d1ee04a1b950f449389b3130f644/lib/src/layout_delegates/multi_day_event_layout_delegate.dart#L8) this should be migrated to use the new `GenerateMultiDayLayoutFrame`

### Improvements
- The `defaultMultiDayGenerateFrame` improves on the `defaultMultiDayLayoutStrategy` by allowing events to fill empty spaces.

### Fixes
- Week view not showing correct range when first day of week is something other than monday. [#150](https://github.com/werner-scholtz/kalender/issues/150)
- Events not snapping to closest. [#155](https://github.com/werner-scholtz/kalender/issues/155)

## 0.6.7

- fix: Rescheduling event triggering an assert. [#144](https://github.com/werner-scholtz/kalender/issues/144)
- fix: TimeIndicator rendering on incorrect day. [#143](https://github.com/werner-scholtz/kalender/issues/143) 

## 0.6.6

- fix: MultiDayHeaderWidget layout regressions.
- Added widget tests for MultiDayHeaderWidget.

## 0.6.5

- fix: SingleDayView RenderFlex overflow.

## 0.6.4

- fix: MonthGrid not taking number of rows into consideration. [#131](https://github.com/werner-scholtz/kalender/issues/131)

## 0.6.3

- fix: Event snapping not always working.

## 0.6.2

- fix: Calendar sometimes displays wrong initial date. [314ff4e](https://github.com/werner-scholtz/kalender/commit/314ff4e3a649f9d6dc97442a13207de7c382dd39)

## 0.6.1

- Changed `VerticalTileResizeHandlePositioner` to never use more than 1/4 of the height of the event tile on desktop.

## 0.6.0
* Package will use Semantic versioning from 0.6.0 onwards.

### Breaking changes
- The `EventsController` is now an abstract class, use `DefaultEventsController<T>` instead.
- The `ViewConfiguration` no longer contains the configuration for `interaction` and `snapping`.
    These are now separate classes that are passed directly to the `Body`/`Header`.

### What's new
- There is a new callback `onTapped` in `CalendarCallbacks`.
    * This is now called when the user taps on an empty space a calendar (Multiday body).
- There is a new callback `onMultiDayTapped` in `CalendarCallbacks`.
    * This is called when the user taps on an empty space in the calendar (Multiday Header / Month body).
- MultiDayBodyConfiguration added `horizontalPadding` this padding is located between events and the edge of day.
- There is now a `CalendarInteraction` and `CalendarSnapping` class that can be passed to the `CalendarBody` / `CalendarHeader` as a ValueNotifier.
    This allows the calendar view to change these behaviors without rebuilding the entire view.
- `CalendarSnapping` now has a `eventSnapStrategy` that can be used to define custom snapping behavior when creating new events. [#119](https://github.com/werner-scholtz/kalender/issues/119)

### Fixes
- Month day header export [PR #115](https://github.com/werner-scholtz/kalender/pull/115)
- Month grid export [PR #112](https://github.com/werner-scholtz/kalender/pull/112)
- Month not display all dates [PR #129](https://github.com/werner-scholtz/kalender/pull/129)

### Boring stuff
- Lots of new unit tests that run in multiple timezones to ensure there are no regressions.
- Example directory layout has changed.


## 0.5.0

### Breaking changes:
Version 0.5.0 has quite a few Breaking changes, there is no easy way to migrate to this version. Here are a few important things that have changed.

- The [CalendarView](https://github.com/werner-scholtz/kalender/blob/main/lib/src/calendar_view.dart) now takes a `header` [CalendarHeader](https://github.com/werner-scholtz/kalender/blob/main/lib/src/calendar_header.dart) and `body` [CalendarBody](https://github.com/werner-scholtz/kalender/blob/main/lib/src/calendar_body.dart) widgets. You can wrap these widgets in other widgets to style them as seen [here](https://github.com/werner-scholtz/kalender/blob/9a053c9daac51985bbbb336393d5013ef3977bd0/example/lib/main.dart#L112)

- Event tiles now make use of the [Draggable](https://api.flutter.dev/flutter/widgets/Draggable-class.html) widget provided by flutter.
Take a look at the [TileComponents](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/components/tile_components.dart) for more details on how tiles work now. This opens some interesting possibilities for displaying multiple calendars.

- The [CalendarCallbacks](https://github.com/werner-scholtz/kalender/blob/main/lib/src/models/calendar_callbacks.dart) (previously `CalendarEventHandlers`) have been changed so more information is given when an interaction occurs.

- The schedule view has been removed, but will be reimplemented in the future.

### What's new

- Auto scroll/paging (https://github.com/werner-scholtz/kalender/issues/75 && https://github.com/werner-scholtz/kalender/issues/64)
- Calender can now accept Draggable's (https://github.com/werner-scholtz/kalender/issues/48)
- More information for the TileBuilder (https://github.com/werner-scholtz/kalender/issues/83)

## pre-0.5.0
- https://github.com/werner-scholtz/kalender/blob/main-0.4.2/CHANGELOG.md