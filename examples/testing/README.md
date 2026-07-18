# testing

A performance harness for `kalender`, not a normal app. It drives the calendar
through loading, navigation, scrolling, rescheduling, and resizing across the
week, month, and schedule views at 10 and 50 events per day, and records the
frame-build times.

## Run it

From this directory, on a device with a display (Linux desktop shown here):

```sh
flutter drive \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/performance_profiling_test.dart \
  --profile \
  -d linux
```

## Knobs and output

- `KALENDER_PERF_RUNS` (default 5) sets how many times each scenario runs. Fewer
  runs trade precision for speed:

  ```sh
  KALENDER_PERF_RUNS=3 flutter drive ...
  ```

- Results are written to `build/frame_results.json` (per scenario, view, and
  workload: average, p90, and p99 build time, plus missed frames).

The CI workflow `performance_profiling.yml` runs this same harness on pushes to
`main` that can move the numbers and publishes the results to the dashboard.
