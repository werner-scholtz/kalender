window.BENCHMARK_DATA = {
  "lastUpdate": 1783519890152,
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
          "id": "adecc1bdfe7e1234ef1a5fc468a6202a347d545d",
          "message": "Merge pull request #288 from werner-scholtz/252-month-body-event-padding\n\nfeat: expose eventPadding on MonthBodyConfiguration (#252)",
          "timestamp": "2026-07-08T15:49:40+02:00",
          "tree_id": "d3558cade2abcbb520e97922766839aec11185b3",
          "url": "https://github.com/werner-scholtz/kalender/commit/adecc1bdfe7e1234ef1a5fc468a6202a347d545d"
        },
        "date": 1783519885193,
        "tool": "customSmallerIsBetter",
        "benches": [
          {
            "name": "dates x200 / 7d",
            "value": 172.14827490518917,
            "unit": "us"
          },
          {
            "name": "dates x200 / 30d",
            "value": 695.3855,
            "unit": "us"
          },
          {
            "name": "dates x200 / 90d",
            "value": 2059.895,
            "unit": "us"
          },
          {
            "name": "dates x200 / 365d",
            "value": 7966.303370786517,
            "unit": "us"
          },
          {
            "name": "multiDayFrame / 100ev x 30d",
            "value": 4282.096,
            "unit": "us"
          },
          {
            "name": "multiDayFrame / 300ev x 30d",
            "value": 17109.34745762712,
            "unit": "us"
          },
          {
            "name": "findLongestChain / 60ev",
            "value": 252.95809523809524,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 1d",
            "value": 110.65140697186057,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 7d",
            "value": 785.2899176147508,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 30d",
            "value": 3351.9100449775115,
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
          "id": "adecc1bdfe7e1234ef1a5fc468a6202a347d545d",
          "message": "Merge pull request #288 from werner-scholtz/252-month-body-event-padding\n\nfeat: expose eventPadding on MonthBodyConfiguration (#252)",
          "timestamp": "2026-07-08T15:49:40+02:00",
          "tree_id": "d3558cade2abcbb520e97922766839aec11185b3",
          "url": "https://github.com/werner-scholtz/kalender/commit/adecc1bdfe7e1234ef1a5fc468a6202a347d545d"
        },
        "date": 1783519889873,
        "tool": "customSmallerIsBetter",
        "benches": [
          {
            "name": "ten_events_per_day-week-loadingEvents / avg_build_ms",
            "value": 1.5463,
            "range": "± 0.11",
            "unit": "ms",
            "extra": "p90_build=4.75ms p99_build=8.53ms missed_build=0 avg_raster_sw=6.66ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-navigation / avg_build_ms",
            "value": 9.2244,
            "range": "± 0.71",
            "unit": "ms",
            "extra": "p90_build=25.49ms p99_build=34.29ms missed_build=3 avg_raster_sw=10.61ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-scrolling / avg_build_ms",
            "value": 1.9318095238095236,
            "range": "± 0.22",
            "unit": "ms",
            "extra": "p90_build=2.56ms p99_build=3.75ms missed_build=0 avg_raster_sw=11.62ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-rescheduling / avg_build_ms",
            "value": 1.1639680851063827,
            "range": "± 0.27",
            "unit": "ms",
            "extra": "p90_build=2.72ms p99_build=4.08ms missed_build=0 avg_raster_sw=11.60ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-resizing / avg_build_ms",
            "value": 0.6660454545454546,
            "range": "± 0.06",
            "unit": "ms",
            "extra": "p90_build=2.12ms p99_build=3.23ms missed_build=0 avg_raster_sw=11.79ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-loadingEvents / avg_build_ms",
            "value": 8.991599999999998,
            "range": "± 1.30",
            "unit": "ms",
            "extra": "p90_build=25.48ms p99_build=31.91ms missed_build=8 avg_raster_sw=10.22ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-navigation / avg_build_ms",
            "value": 17.989600000000003,
            "range": "± 3.37",
            "unit": "ms",
            "extra": "p90_build=39.92ms p99_build=49.11ms missed_build=4 avg_raster_sw=9.80ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-rescheduling / avg_build_ms",
            "value": 1.6668599999999996,
            "range": "± 0.24",
            "unit": "ms",
            "extra": "p90_build=4.47ms p99_build=9.48ms missed_build=0 avg_raster_sw=9.99ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-resizing / avg_build_ms",
            "value": 0.7808095238095237,
            "range": "± 0.14",
            "unit": "ms",
            "extra": "p90_build=0.38ms p99_build=6.52ms missed_build=0 avg_raster_sw=7.35ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-loadingEvents / avg_build_ms",
            "value": 6.4385714285714295,
            "range": "± 1.27",
            "unit": "ms",
            "extra": "p90_build=20.43ms p99_build=28.98ms missed_build=5 avg_raster_sw=7.15ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-navigation / avg_build_ms",
            "value": 28.62908333333333,
            "range": "± 2.60",
            "unit": "ms",
            "extra": "p90_build=43.95ms p99_build=56.34ms missed_build=9 avg_raster_sw=8.39ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-rescheduling / avg_build_ms",
            "value": 1.3291290322580642,
            "range": "± 0.23",
            "unit": "ms",
            "extra": "p90_build=3.54ms p99_build=17.80ms missed_build=2 avg_raster_sw=7.22ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-loadingEvents / avg_build_ms",
            "value": 16.66363636363636,
            "range": "± 2.24",
            "unit": "ms",
            "extra": "p90_build=54.02ms p99_build=66.25ms missed_build=7 avg_raster_sw=17.55ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-navigation / avg_build_ms",
            "value": 51.501,
            "range": "± 15.23",
            "unit": "ms",
            "extra": "p90_build=102.56ms p99_build=102.56ms missed_build=1 avg_raster_sw=32.41ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-scrolling / avg_build_ms",
            "value": 1.2223333333333333,
            "range": "± 0.25",
            "unit": "ms",
            "extra": "p90_build=1.56ms p99_build=1.97ms missed_build=0 avg_raster_sw=6.01ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-rescheduling / avg_build_ms",
            "value": 0.12935514018691596,
            "range": "± 0.00",
            "unit": "ms",
            "extra": "p90_build=0.15ms p99_build=0.20ms missed_build=0 avg_raster_sw=5.35ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-resizing / avg_build_ms",
            "value": 0.13133333333333336,
            "range": "± 0.01",
            "unit": "ms",
            "extra": "p90_build=0.15ms p99_build=0.18ms missed_build=0 avg_raster_sw=6.13ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-loadingEvents / avg_build_ms",
            "value": 13.739731707317075,
            "range": "± 1.44",
            "unit": "ms",
            "extra": "p90_build=35.20ms p99_build=69.83ms missed_build=14 avg_raster_sw=10.04ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-navigation / avg_build_ms",
            "value": 23.7812,
            "range": "± 2.79",
            "unit": "ms",
            "extra": "p90_build=52.69ms p99_build=84.25ms missed_build=4 avg_raster_sw=9.68ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-rescheduling / avg_build_ms",
            "value": 2.551244897959184,
            "range": "± 0.17",
            "unit": "ms",
            "extra": "p90_build=7.77ms p99_build=9.96ms missed_build=1 avg_raster_sw=9.57ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-resizing / avg_build_ms",
            "value": 1.2684285714285715,
            "range": "± 0.46",
            "unit": "ms",
            "extra": "p90_build=2.64ms p99_build=12.34ms missed_build=0 avg_raster_sw=7.41ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-loadingEvents / avg_build_ms",
            "value": 5.041168831168833,
            "range": "± 0.47",
            "unit": "ms",
            "extra": "p90_build=14.16ms p99_build=17.10ms missed_build=4 avg_raster_sw=8.32ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-navigation / avg_build_ms",
            "value": 28.335,
            "range": "± 2.08",
            "unit": "ms",
            "extra": "p90_build=49.13ms p99_build=52.37ms missed_build=10 avg_raster_sw=8.73ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-rescheduling / avg_build_ms",
            "value": 1.1600000000000001,
            "range": "± 0.16",
            "unit": "ms",
            "extra": "p90_build=2.60ms p99_build=15.70ms missed_build=1 avg_raster_sw=7.75ms (runs=5)"
          }
        ]
      }
    ]
  }
}