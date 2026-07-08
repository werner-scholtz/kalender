window.BENCHMARK_DATA = {
  "lastUpdate": 1783519888322,
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
    ]
  }
}