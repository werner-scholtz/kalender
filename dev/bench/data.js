window.BENCHMARK_DATA = {
  "lastUpdate": 1781857735577,
  "repoUrl": "https://github.com/werner-scholtz/kalender",
  "entries": {
    "Kalender Micro-benchmarks": [
      {
        "commit": {
          "author": {
            "email": "werner@scholtzonline.net",
            "name": "Werner",
            "username": "049er"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "df83f7c869eb60add69c7121ea0dabf5123820fb",
          "message": "Merge pull request #269 from werner-scholtz/perf/custom-dashboard\n\nfeat(perf): custom benchmark dashboard + package-cleanliness fix",
          "timestamp": "2026-06-19T10:10:52+02:00",
          "tree_id": "b7b0d18c3864aa6c525059f505b58880c7fed7e2",
          "url": "https://github.com/werner-scholtz/kalender/commit/df83f7c869eb60add69c7121ea0dabf5123820fb"
        },
        "date": 1781857731809,
        "tool": "customSmallerIsBetter",
        "benches": [
          {
            "name": "dates x200 / 7d",
            "value": 168.70072205162253,
            "unit": "us"
          },
          {
            "name": "dates x200 / 30d",
            "value": 682.2305,
            "unit": "us"
          },
          {
            "name": "dates x200 / 90d",
            "value": 2043.153,
            "unit": "us"
          },
          {
            "name": "dates x200 / 365d",
            "value": 7848.033707865168,
            "unit": "us"
          },
          {
            "name": "multiDayFrame / 100ev x 30d",
            "value": 4594.773033707866,
            "unit": "us"
          },
          {
            "name": "multiDayFrame / 300ev x 30d",
            "value": 18113.191304347827,
            "unit": "us"
          },
          {
            "name": "findLongestChain / 60ev",
            "value": 250.7517881791944,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 1d",
            "value": 121.8750625,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 7d",
            "value": 846.11025,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 30d",
            "value": 3600.737762237762,
            "unit": "us"
          }
        ]
      }
    ],
    "Kalender Frame Profiling": [
      {
        "commit": {
          "author": {
            "email": "werner@scholtzonline.net",
            "name": "Werner",
            "username": "049er"
          },
          "committer": {
            "email": "noreply@github.com",
            "name": "GitHub",
            "username": "web-flow"
          },
          "distinct": true,
          "id": "df83f7c869eb60add69c7121ea0dabf5123820fb",
          "message": "Merge pull request #269 from werner-scholtz/perf/custom-dashboard\n\nfeat(perf): custom benchmark dashboard + package-cleanliness fix",
          "timestamp": "2026-06-19T10:10:52+02:00",
          "tree_id": "b7b0d18c3864aa6c525059f505b58880c7fed7e2",
          "url": "https://github.com/werner-scholtz/kalender/commit/df83f7c869eb60add69c7121ea0dabf5123820fb"
        },
        "date": 1781857735301,
        "tool": "customSmallerIsBetter",
        "benches": [
          {
            "name": "ten_events_per_day-week-loadingEvents / avg_build_ms",
            "value": 1.8193999999999997,
            "range": "± 0.32",
            "unit": "ms",
            "extra": "p90_build=4.75ms p99_build=14.10ms missed_build=0 avg_raster_sw=6.77ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-navigation / avg_build_ms",
            "value": 9.016733333333331,
            "range": "± 0.63",
            "unit": "ms",
            "extra": "p90_build=26.27ms p99_build=32.01ms missed_build=3 avg_raster_sw=10.81ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-scrolling / avg_build_ms",
            "value": 2.084904761904762,
            "range": "± 0.25",
            "unit": "ms",
            "extra": "p90_build=2.61ms p99_build=3.75ms missed_build=0 avg_raster_sw=12.05ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-rescheduling / avg_build_ms",
            "value": 1.3861204819277113,
            "range": "± 0.30",
            "unit": "ms",
            "extra": "p90_build=2.88ms p99_build=4.83ms missed_build=0 avg_raster_sw=12.51ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-resizing / avg_build_ms",
            "value": 0.795,
            "range": "± 0.28",
            "unit": "ms",
            "extra": "p90_build=2.38ms p99_build=3.30ms missed_build=0 avg_raster_sw=12.83ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-loadingEvents / avg_build_ms",
            "value": 8.67492,
            "range": "± 0.42",
            "unit": "ms",
            "extra": "p90_build=24.91ms p99_build=31.45ms missed_build=7 avg_raster_sw=9.45ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-navigation / avg_build_ms",
            "value": 15.695399999999998,
            "range": "± 0.41",
            "unit": "ms",
            "extra": "p90_build=37.70ms p99_build=44.82ms missed_build=4 avg_raster_sw=10.10ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-rescheduling / avg_build_ms",
            "value": 1.5307403846153844,
            "range": "± 0.11",
            "unit": "ms",
            "extra": "p90_build=4.45ms p99_build=9.46ms missed_build=0 avg_raster_sw=9.64ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-resizing / avg_build_ms",
            "value": 0.5596818181818182,
            "range": "± 0.24",
            "unit": "ms",
            "extra": "p90_build=0.39ms p99_build=4.52ms missed_build=0 avg_raster_sw=9.35ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-loadingEvents / avg_build_ms",
            "value": 7.047999999999999,
            "range": "± 1.01",
            "unit": "ms",
            "extra": "p90_build=22.91ms p99_build=30.78ms missed_build=6 avg_raster_sw=7.56ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-navigation / avg_build_ms",
            "value": 27.277500000000003,
            "range": "± 4.96",
            "unit": "ms",
            "extra": "p90_build=43.23ms p99_build=64.25ms missed_build=9 avg_raster_sw=8.30ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-rescheduling / avg_build_ms",
            "value": 1.1985462184873947,
            "range": "± 0.24",
            "unit": "ms",
            "extra": "p90_build=3.28ms p99_build=14.31ms missed_build=1 avg_raster_sw=7.02ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-loadingEvents / avg_build_ms",
            "value": 15.362272727272726,
            "range": "± 1.91",
            "unit": "ms",
            "extra": "p90_build=49.33ms p99_build=75.96ms missed_build=7 avg_raster_sw=17.54ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-navigation / avg_build_ms",
            "value": 51.428000000000004,
            "range": "± 5.26",
            "unit": "ms",
            "extra": "p90_build=102.58ms p99_build=102.58ms missed_build=1 avg_raster_sw=30.37ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-scrolling / avg_build_ms",
            "value": 1.3476666666666668,
            "range": "± 0.15",
            "unit": "ms",
            "extra": "p90_build=1.80ms p99_build=2.61ms missed_build=0 avg_raster_sw=6.41ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-rescheduling / avg_build_ms",
            "value": 0.14010476190476198,
            "range": "± 0.01",
            "unit": "ms",
            "extra": "p90_build=0.16ms p99_build=0.20ms missed_build=0 avg_raster_sw=5.55ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-resizing / avg_build_ms",
            "value": 0.154,
            "range": "± 0.01",
            "unit": "ms",
            "extra": "p90_build=0.17ms p99_build=0.18ms missed_build=0 avg_raster_sw=5.70ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-loadingEvents / avg_build_ms",
            "value": 14.377536585365855,
            "range": "± 1.53",
            "unit": "ms",
            "extra": "p90_build=35.88ms p99_build=68.85ms missed_build=14 avg_raster_sw=10.19ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-navigation / avg_build_ms",
            "value": 22.194899999999997,
            "range": "± 1.92",
            "unit": "ms",
            "extra": "p90_build=52.72ms p99_build=85.81ms missed_build=4 avg_raster_sw=9.93ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-rescheduling / avg_build_ms",
            "value": 2.7714948453608246,
            "range": "± 0.14",
            "unit": "ms",
            "extra": "p90_build=8.08ms p99_build=11.24ms missed_build=1 avg_raster_sw=9.86ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-resizing / avg_build_ms",
            "value": 1.1686666666666663,
            "range": "± 0.64",
            "unit": "ms",
            "extra": "p90_build=2.82ms p99_build=9.80ms missed_build=0 avg_raster_sw=9.00ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-loadingEvents / avg_build_ms",
            "value": 5.16128947368421,
            "range": "± 0.15",
            "unit": "ms",
            "extra": "p90_build=14.72ms p99_build=18.37ms missed_build=6 avg_raster_sw=9.01ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-navigation / avg_build_ms",
            "value": 26.84869230769231,
            "range": "± 6.06",
            "unit": "ms",
            "extra": "p90_build=51.96ms p99_build=55.80ms missed_build=10 avg_raster_sw=8.47ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-rescheduling / avg_build_ms",
            "value": 1.1254536082474225,
            "range": "± 0.31",
            "unit": "ms",
            "extra": "p90_build=3.20ms p99_build=14.39ms missed_build=1 avg_raster_sw=8.00ms (runs=5)"
          }
        ]
      }
    ]
  }
}