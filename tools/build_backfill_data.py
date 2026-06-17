#!/usr/bin/env python3
"""Assemble per-commit backfill results into a github-action-benchmark data.js.

Reads the JSON files produced by `tools/backfill_benchmarks.sh` and emits a
`window.BENCHMARK_DATA` seed (the format github-action-benchmark stores in
`gh-pages/dev/bench/data.js`), with separate entries for the micro and frame
suites, each tagged with the historical commit's id and date so the dashboard
trend lines up with real history.

The entry names MUST match the `name:` values used by the
`benchmark-action/github-action-benchmark` steps in the normal workflow, so that
subsequent runs append to these series rather than creating new ones.
"""

import argparse
import glob
import json
import os
from datetime import datetime

MICRO_NAME = "Kalender Micro-benchmarks"
FRAME_NAME = "Kalender Frame Profiling"


def iso_to_ms(timestamp):
    """Convert an ISO-8601 timestamp to epoch milliseconds."""
    return int(datetime.fromisoformat(timestamp.replace("Z", "+00:00")).timestamp() * 1000)


def commit_obj(record, repo_url):
    """Build the github-action-benchmark `commit` object for a record."""
    name = record.get("author") or "unknown"
    person = {"name": name, "username": name}
    return {
        "author": person,
        "committer": person,
        "id": record["sha"],
        "message": record.get("message") or "",
        "timestamp": record["timestamp"],
        "url": f"{repo_url}/commit/{record['sha']}",
    }


def run_entry(record, benches, repo_url):
    """Build a single dashboard run entry for one commit + suite."""
    return {
        "commit": commit_obj(record, repo_url),
        "date": iso_to_ms(record["timestamp"]),
        "tool": "customSmallerIsBetter",
        "benches": benches,
    }


def main():
    parser = argparse.ArgumentParser(description="Assemble backfill data.js")
    parser.add_argument("--input-dir", default="backfill_results")
    parser.add_argument("--output", default="dev/bench/data.js")
    parser.add_argument("--repo-url", default="https://github.com/werner-scholtz/kalender")
    args = parser.parse_args()

    records = []
    for path in sorted(glob.glob(os.path.join(args.input_dir, "*.json"))):
        try:
            records.append(json.load(open(path, encoding="utf-8")))
        except (OSError, json.JSONDecodeError) as error:
            print(f"skip {path}: {error}")

    records = [r for r in records if r.get("sha") and r.get("timestamp")]
    records.sort(key=lambda r: r["timestamp"])

    micro_runs = [run_entry(r, r["micro"], args.repo_url) for r in records if r.get("micro")]
    frame_runs = [run_entry(r, r["frame"], args.repo_url) for r in records if r.get("frame")]

    entries = {}
    if micro_runs:
        entries[MICRO_NAME] = micro_runs
    if frame_runs:
        entries[FRAME_NAME] = frame_runs

    data = {
        "lastUpdate": max((iso_to_ms(r["timestamp"]) for r in records), default=0),
        "repoUrl": args.repo_url,
        "entries": entries,
    }

    os.makedirs(os.path.dirname(args.output) or ".", exist_ok=True)
    with open(args.output, "w", encoding="utf-8") as handle:
        handle.write("window.BENCHMARK_DATA = ")
        json.dump(data, handle, indent=2)
        handle.write(";\n")

    print(f"Wrote {args.output}: {len(micro_runs)} micro runs, {len(frame_runs)} frame runs")


if __name__ == "__main__":
    main()
