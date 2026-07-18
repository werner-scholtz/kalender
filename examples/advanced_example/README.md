# Advanced example

Shows three techniques that are each reusable on their own:

- **Custom event layout.** `CustomSideBySideLayoutDelegate` (`lib/layout_strategy.dart`) splits each day column into a lane per person, wired in through `MultiDayBodyConfiguration.eventLayoutStrategy`.
- **Zoom.** `ZoomDetector` (`lib/zoom.dart`) changes the height-per-minute on desktop (ctrl + scroll / trackpad pinch) and mobile (two-finger pinch), keeping the scroll position under the pointer.
- **Tap-location-aware creation.** `Event.fromDetail` builds a new event from the tap detail, so a created event is pre-assigned to the person whose lane was tapped.

Run it from this directory:

```sh
flutter run
```
