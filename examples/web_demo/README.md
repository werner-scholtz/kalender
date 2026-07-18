# Web demo

The showcase app for `kalender`, deployed to the browser and adapting to touch
devices. It is the source behind the [live demo](https://werner-scholtz.github.io/kalender/).

## What it shows

- All view types with a runtime configuration panel (interaction, snapping,
  visibility toggles) driven by `DemoConfiguration`.
- Theme, locale, and text-direction switching, plus localized strings for several
  languages.
- A desktop split view with two independent calendars over one shared event store,
  and a single-calendar mobile layout.
- Timezone-aware events, with the timezone package bootstrapped through conditional
  imports for browser, IO, and stub targets.

## Run and build

From this directory:

```sh
flutter run -d chrome
flutter build web --release --wasm --base-href /kalender/
```

The `web_demo.yml` workflow builds and deploys this app to GitHub Pages on pushes
to `main` whose commit message contains `web demo`.

## Layout

- `lib/main.dart` — bootstrap, app-wide theme/locale/direction, the shared events controller.
- `lib/widgets/calendar/` — the `CalendarView` composition and demo tile/overlay chrome.
- `lib/widgets/toolbar/` and `lib/widgets/configuration/` — the app controls and runtime editors.
- `lib/l10n/` — the ARB translation files.

See `AGENTS.md` for the fuller architecture notes.
