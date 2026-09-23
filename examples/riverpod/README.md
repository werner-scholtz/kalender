# riverpod / kalender

Using [kalender](https://pub.dev/packages/kalender) with [riverpod](https://riverpod.dev/).

- The events controller and calendar controller are shared through plain `Provider`s.
- The selected view configuration lives on the calendar controller, so the dropdown
  switches views by setting `viewConfiguration` on it.

Run it from this directory:

```sh
flutter run
```
