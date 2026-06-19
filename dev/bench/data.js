window.BENCHMARK_DATA = {
  "lastUpdate": 1781857734022,
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
    ]
  }
}