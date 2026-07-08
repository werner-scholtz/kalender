window.BENCHMARK_DATA = {
  "lastUpdate": 1783520991006,
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
      },
      {
        "commit": {
          "author": {
            "email": "werner.scholtz@kdab.com",
            "name": "werner.scholtz",
            "username": "werner-scholtz"
          },
          "committer": {
            "email": "werner.scholtz@kdab.com",
            "name": "werner.scholtz",
            "username": "werner-scholtz"
          },
          "distinct": true,
          "id": "4114a65c7c777433489fa1ee3067500309c0e1f4",
          "message": "chore: release v0.19.0\n\nBump version to 0.19.0. Tag v0.19.0 to trigger the pub.dev publish.\n\nCo-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>",
          "timestamp": "2026-07-08T15:55:05+02:00",
          "tree_id": "fed0c802aa15d285ebd6b506b5cba268822e7256",
          "url": "https://github.com/werner-scholtz/kalender/commit/4114a65c7c777433489fa1ee3067500309c0e1f4"
        },
        "date": 1783520985743,
        "tool": "customSmallerIsBetter",
        "benches": [
          {
            "name": "dates x200 / 7d",
            "value": 180.28120205757602,
            "unit": "us"
          },
          {
            "name": "dates x200 / 30d",
            "value": 709.54625,
            "unit": "us"
          },
          {
            "name": "dates x200 / 90d",
            "value": 2093.684,
            "unit": "us"
          },
          {
            "name": "dates x200 / 365d",
            "value": 8190.308,
            "unit": "us"
          },
          {
            "name": "multiDayFrame / 100ev x 30d",
            "value": 4312.18,
            "unit": "us"
          },
          {
            "name": "multiDayFrame / 300ev x 30d",
            "value": 17106.610169491527,
            "unit": "us"
          },
          {
            "name": "findLongestChain / 60ev",
            "value": 257.16501901140686,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 1d",
            "value": 113.77289836888332,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 7d",
            "value": 788.66675,
            "unit": "us"
          },
          {
            "name": "eventsFromRange / query 30d",
            "value": 3342.569715142429,
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
      },
      {
        "commit": {
          "author": {
            "email": "werner.scholtz@kdab.com",
            "name": "werner.scholtz",
            "username": "werner-scholtz"
          },
          "committer": {
            "email": "werner.scholtz@kdab.com",
            "name": "werner.scholtz",
            "username": "werner-scholtz"
          },
          "distinct": true,
          "id": "4114a65c7c777433489fa1ee3067500309c0e1f4",
          "message": "chore: release v0.19.0\n\nBump version to 0.19.0. Tag v0.19.0 to trigger the pub.dev publish.\n\nCo-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>",
          "timestamp": "2026-07-08T15:55:05+02:00",
          "tree_id": "fed0c802aa15d285ebd6b506b5cba268822e7256",
          "url": "https://github.com/werner-scholtz/kalender/commit/4114a65c7c777433489fa1ee3067500309c0e1f4"
        },
        "date": 1783520990768,
        "tool": "customSmallerIsBetter",
        "benches": [
          {
            "name": "ten_events_per_day-week-loadingEvents / avg_build_ms",
            "value": 1.6666666666666667,
            "range": "± 0.14",
            "unit": "ms",
            "extra": "p90_build=4.54ms p99_build=8.21ms missed_build=0 avg_raster_sw=6.71ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-navigation / avg_build_ms",
            "value": 9.618133333333333,
            "range": "± 0.49",
            "unit": "ms",
            "extra": "p90_build=27.70ms p99_build=35.77ms missed_build=4 avg_raster_sw=10.88ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-scrolling / avg_build_ms",
            "value": 2.0879999999999996,
            "range": "± 0.11",
            "unit": "ms",
            "extra": "p90_build=2.52ms p99_build=6.66ms missed_build=0 avg_raster_sw=11.45ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-rescheduling / avg_build_ms",
            "value": 1.1467894736842104,
            "range": "± 0.18",
            "unit": "ms",
            "extra": "p90_build=2.41ms p99_build=4.18ms missed_build=0 avg_raster_sw=12.44ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-week-resizing / avg_build_ms",
            "value": 0.6729,
            "range": "± 0.02",
            "unit": "ms",
            "extra": "p90_build=2.24ms p99_build=3.28ms missed_build=0 avg_raster_sw=11.71ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-loadingEvents / avg_build_ms",
            "value": 8.939280000000004,
            "range": "± 0.82",
            "unit": "ms",
            "extra": "p90_build=24.32ms p99_build=29.80ms missed_build=7 avg_raster_sw=10.04ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-navigation / avg_build_ms",
            "value": 16.665799999999997,
            "range": "± 1.68",
            "unit": "ms",
            "extra": "p90_build=38.44ms p99_build=46.51ms missed_build=4 avg_raster_sw=10.42ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-rescheduling / avg_build_ms",
            "value": 1.4707920792079214,
            "range": "± 0.05",
            "unit": "ms",
            "extra": "p90_build=4.26ms p99_build=8.05ms missed_build=0 avg_raster_sw=9.54ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-month-resizing / avg_build_ms",
            "value": 0.6378,
            "range": "± 0.28",
            "unit": "ms",
            "extra": "p90_build=0.36ms p99_build=6.04ms missed_build=0 avg_raster_sw=9.23ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-loadingEvents / avg_build_ms",
            "value": 6.7360357142857135,
            "range": "± 0.39",
            "unit": "ms",
            "extra": "p90_build=21.07ms p99_build=26.99ms missed_build=6 avg_raster_sw=6.78ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-navigation / avg_build_ms",
            "value": 26.64741666666667,
            "range": "± 3.06",
            "unit": "ms",
            "extra": "p90_build=40.27ms p99_build=55.97ms missed_build=9 avg_raster_sw=7.55ms (runs=5)"
          },
          {
            "name": "ten_events_per_day-schedule-rescheduling / avg_build_ms",
            "value": 1.2293229166666666,
            "range": "± 0.25",
            "unit": "ms",
            "extra": "p90_build=2.51ms p99_build=12.96ms missed_build=1 avg_raster_sw=7.67ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-loadingEvents / avg_build_ms",
            "value": 16.26931818181818,
            "range": "± 2.09",
            "unit": "ms",
            "extra": "p90_build=51.68ms p99_build=71.44ms missed_build=7 avg_raster_sw=17.91ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-navigation / avg_build_ms",
            "value": 52.2435,
            "range": "± 15.25",
            "unit": "ms",
            "extra": "p90_build=104.22ms p99_build=104.22ms missed_build=1 avg_raster_sw=24.50ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-scrolling / avg_build_ms",
            "value": 1.3418095238095238,
            "range": "± 0.21",
            "unit": "ms",
            "extra": "p90_build=1.55ms p99_build=4.13ms missed_build=0 avg_raster_sw=5.93ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-rescheduling / avg_build_ms",
            "value": 0.1313981481481482,
            "range": "± 0",
            "unit": "ms",
            "extra": "p90_build=0.14ms p99_build=0.18ms missed_build=0 avg_raster_sw=5.43ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-week-resizing / avg_build_ms",
            "value": 0.13518181818181818,
            "range": "± 0.01",
            "unit": "ms",
            "extra": "p90_build=0.15ms p99_build=0.17ms missed_build=0 avg_raster_sw=5.98ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-loadingEvents / avg_build_ms",
            "value": 13.819024390243904,
            "range": "± 1.05",
            "unit": "ms",
            "extra": "p90_build=35.16ms p99_build=68.86ms missed_build=14 avg_raster_sw=9.79ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-navigation / avg_build_ms",
            "value": 22.785400000000003,
            "range": "± 0.34",
            "unit": "ms",
            "extra": "p90_build=54.98ms p99_build=86.22ms missed_build=4 avg_raster_sw=9.88ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-rescheduling / avg_build_ms",
            "value": 2.744639175257732,
            "range": "± 0.13",
            "unit": "ms",
            "extra": "p90_build=8.06ms p99_build=13.48ms missed_build=1 avg_raster_sw=10.05ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-month-resizing / avg_build_ms",
            "value": 1.1279565217391303,
            "range": "± 0.34",
            "unit": "ms",
            "extra": "p90_build=2.42ms p99_build=10.92ms missed_build=0 avg_raster_sw=7.43ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-loadingEvents / avg_build_ms",
            "value": 4.905402597402596,
            "range": "± 0.12",
            "unit": "ms",
            "extra": "p90_build=14.33ms p99_build=17.01ms missed_build=5 avg_raster_sw=8.42ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-navigation / avg_build_ms",
            "value": 26.42861538461538,
            "range": "± 1.49",
            "unit": "ms",
            "extra": "p90_build=49.76ms p99_build=52.82ms missed_build=10 avg_raster_sw=8.20ms (runs=5)"
          },
          {
            "name": "fifty_events_per_day-schedule-rescheduling / avg_build_ms",
            "value": 1.2441616161616165,
            "range": "± 0.06",
            "unit": "ms",
            "extra": "p90_build=2.52ms p99_build=15.41ms missed_build=1 avg_raster_sw=8.27ms (runs=5)"
          }
        ]
      }
    ]
  }
}