window.BENCHMARK_DATA = {
  "lastUpdate": 1781701023465,
  "repoUrl": "https://github.com/werner-scholtz/kalender",
  "entries": {
    "Kalender Micro-benchmarks": [
      {
        "commit": {
          "author": {
            "email": "121276491+werner-scholtz@users.noreply.github.com",
            "name": "Werner",
            "username": "werner-scholtz"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "02fdf4318cfeadcb93096e4c5c9ed5ef1f61ce48",
          "message": "Merge pull request #268 from werner-scholtz/perf/standard-benchmark-pipeline\n\nperf: rebuild benchmarking on github-action-benchmark + micro-benchmarks",
          "timestamp": "2026-06-17T14:38:33+02:00",
          "tree_id": "58d594a412355a3af4805257963a1828fee86258",
          "url": "https://github.com/werner-scholtz/kalender/commit/02fdf4318cfeadcb93096e4c5c9ed5ef1f61ce48"
        },
        "date": 1781701019511,
        "tool": "customSmallerIsBetter",
        "benches": [
          {
            "name": "dates x200 / 7d",
            "value": 175.35006468305303,
            "unit": "us"
          },
          {
            "name": "dates x200 / 30d",
            "value": 703.029,
            "unit": "us"
          },
          {
            "name": "dates x200 / 90d",
            "value": 2093.282,
            "unit": "us"
          },
          {
            "name": "dates x200 / 365d",
            "value": 8031.588,
            "unit": "us"
          },
          {
            "name": "multiDayFrame / 100ev x 30d",
            "value": 4030.0262237762236,
            "unit": "us"
          },
          {
            "name": "multiDayFrame / 300ev x 30d",
            "value": 16107.264,
            "unit": "us"
          },
          {
            "name": "findLongestChain / 60ev",
            "value": 250.1510951614899,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 1d",
            "value": 106.03411751588806,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 7d",
            "value": 743.9005,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 30d",
            "value": 3180.6226666666666,
            "unit": "us"
          }
        ]
      }
    ],
    "Kalender Frame Profiling": [
      {
        "commit": {
          "author": {
            "email": "121276491+werner-scholtz@users.noreply.github.com",
            "name": "Werner",
            "username": "werner-scholtz"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "02fdf4318cfeadcb93096e4c5c9ed5ef1f61ce48",
          "message": "Merge pull request #268 from werner-scholtz/perf/standard-benchmark-pipeline\n\nperf: rebuild benchmarking on github-action-benchmark + micro-benchmarks",
          "timestamp": "2026-06-17T14:38:33+02:00",
          "tree_id": "58d594a412355a3af4805257963a1828fee86258",
          "url": "https://github.com/werner-scholtz/kalender/commit/02fdf4318cfeadcb93096e4c5c9ed5ef1f61ce48"
        },
        "date": 1781701023208,
        "tool": "customSmallerIsBetter",
        "benches": [
          {
            "name": "ten_events_per_day-week-loadingEvents / avg_build_ms",
            "value": 1.6417666666666666,
            "range": "± 0.21",
            "unit": "ms",
            "extra": "p90_build=4.70ms p99_build=9.15ms missed_build=0 avg_raster_sw=6.75ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-navigation / avg_build_ms",
            "value": 9.444733333333334,
            "range": "± 1.17",
            "unit": "ms",
            "extra": "p90_build=26.27ms p99_build=35.84ms missed_build=4 avg_raster_sw=10.28ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-scrolling / avg_build_ms",
            "value": 1.890904761904762,
            "range": "± 0.41",
            "unit": "ms",
            "extra": "p90_build=2.41ms p99_build=2.88ms missed_build=0 avg_raster_sw=12.06ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-rescheduling / avg_build_ms",
            "value": 1.2016161616161616,
            "range": "± 0.16",
            "unit": "ms",
            "extra": "p90_build=2.71ms p99_build=5.46ms missed_build=0 avg_raster_sw=12.19ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-resizing / avg_build_ms",
            "value": 0.6917727272727274,
            "range": "± 0.10",
            "unit": "ms",
            "extra": "p90_build=2.22ms p99_build=2.89ms missed_build=0 avg_raster_sw=10.38ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-loadingEvents / avg_build_ms",
            "value": 8.45884,
            "range": "± 0.73",
            "unit": "ms",
            "extra": "p90_build=24.50ms p99_build=28.67ms missed_build=8 avg_raster_sw=9.79ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-navigation / avg_build_ms",
            "value": 17.8284,
            "range": "± 2.41",
            "unit": "ms",
            "extra": "p90_build=40.14ms p99_build=54.84ms missed_build=4 avg_raster_sw=9.35ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-rescheduling / avg_build_ms",
            "value": 1.422656862745098,
            "range": "± 0.15",
            "unit": "ms",
            "extra": "p90_build=4.29ms p99_build=8.59ms missed_build=0 avg_raster_sw=9.90ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-resizing / avg_build_ms",
            "value": 0.6862631578947369,
            "range": "± 0.17",
            "unit": "ms",
            "extra": "p90_build=0.38ms p99_build=6.06ms missed_build=0 avg_raster_sw=9.70ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-loadingEvents / avg_build_ms",
            "value": 7.2289642857142855,
            "range": "± 1.15",
            "unit": "ms",
            "extra": "p90_build=21.68ms p99_build=31.15ms missed_build=6 avg_raster_sw=7.31ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-navigation / avg_build_ms",
            "value": 28.06833333333333,
            "range": "± 2.48",
            "unit": "ms",
            "extra": "p90_build=43.90ms p99_build=53.33ms missed_build=9 avg_raster_sw=8.50ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-rescheduling / avg_build_ms",
            "value": 1.3231844660194174,
            "range": "± 0.50",
            "unit": "ms",
            "extra": "p90_build=5.41ms p99_build=13.74ms missed_build=1 avg_raster_sw=8.23ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-loadingEvents / avg_build_ms",
            "value": 15.86618181818182,
            "range": "± 1.26",
            "unit": "ms",
            "extra": "p90_build=51.30ms p99_build=74.06ms missed_build=7 avg_raster_sw=18.14ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-navigation / avg_build_ms",
            "value": 52.6055,
            "range": "± 19.05",
            "unit": "ms",
            "extra": "p90_build=104.88ms p99_build=104.88ms missed_build=1 avg_raster_sw=27.18ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-scrolling / avg_build_ms",
            "value": 1.401190476190476,
            "range": "± 0.05",
            "unit": "ms",
            "extra": "p90_build=1.70ms p99_build=2.06ms missed_build=0 avg_raster_sw=6.11ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-rescheduling / avg_build_ms",
            "value": 0.13502752293577983,
            "range": "± 0.01",
            "unit": "ms",
            "extra": "p90_build=0.14ms p99_build=0.18ms missed_build=0 avg_raster_sw=5.27ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-resizing / avg_build_ms",
            "value": 0.13679166666666664,
            "range": "± 0.01",
            "unit": "ms",
            "extra": "p90_build=0.15ms p99_build=0.18ms missed_build=0 avg_raster_sw=5.95ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-loadingEvents / avg_build_ms",
            "value": 14.355268292682926,
            "range": "± 1.36",
            "unit": "ms",
            "extra": "p90_build=34.65ms p99_build=67.99ms missed_build=14 avg_raster_sw=9.77ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-navigation / avg_build_ms",
            "value": 22.081,
            "range": "± 2.08",
            "unit": "ms",
            "extra": "p90_build=53.16ms p99_build=84.80ms missed_build=4 avg_raster_sw=9.72ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-rescheduling / avg_build_ms",
            "value": 2.502598039215686,
            "range": "± 0.20",
            "unit": "ms",
            "extra": "p90_build=7.83ms p99_build=11.51ms missed_build=1 avg_raster_sw=9.59ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-resizing / avg_build_ms",
            "value": 1.099217391304348,
            "range": "± 0.25",
            "unit": "ms",
            "extra": "p90_build=2.77ms p99_build=9.81ms missed_build=0 avg_raster_sw=7.13ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-loadingEvents / avg_build_ms",
            "value": 4.886756410256411,
            "range": "± 0.45",
            "unit": "ms",
            "extra": "p90_build=13.82ms p99_build=16.72ms missed_build=4 avg_raster_sw=8.20ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-navigation / avg_build_ms",
            "value": 26.324692307692303,
            "range": "± 1.46",
            "unit": "ms",
            "extra": "p90_build=41.89ms p99_build=44.14ms missed_build=10 avg_raster_sw=8.44ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-rescheduling / avg_build_ms",
            "value": 1.3279010989010986,
            "range": "± 0.35",
            "unit": "ms",
            "extra": "p90_build=1.35ms p99_build=18.89ms missed_build=2 avg_raster_sw=7.44ms (runs=5)"
          }
        ]
      }
    ]
  }
}