window.BENCHMARK_DATA = {
  "lastUpdate": 1781701021742,
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
    ]
  }
}