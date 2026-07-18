# riverpod / kalender

Using [kalender](https://pub.dev/packages/kalender) with [riverpod](https://riverpod.dev/).

- The events controller and calendar controller are shared through plain `Provider`s.
- The selected view configuration lives in a `Notifier`, so switching views from the
  dropdown updates the calendar through the provider.

Run it from this directory:

```sh
flutter run
```
