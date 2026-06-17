#!/usr/bin/env bash
# One-time historical backfill: replay the CURRENT benchmark suites across the
# commits recorded in `performance-results:performance_history.json`.
#
# For each commit it creates a detached git worktree, overlays the current
# benchmark harness onto that commit's library code, runs the micro + frame
# suites, and writes a per-commit result JSON to $OUT_DIR. The overlaid harness
# calls into the historical library; where an old commit's API no longer matches
# (mostly the example app for the frame suite), that suite fails to build and is
# logged + skipped rather than aborting the whole run.
#
# Output JSON per commit:
#   { "sha", "timestamp", "author", "message", "micro": [...]|null, "frame": [...]|null }
#
# Env:
#   OUT_DIR             output dir for per-commit JSON (default: backfill_results)
#   KALENDER_PERF_RUNS  frame profiling repeats per workload (default: 2)
#   LIMIT               only process the most recent N commits (default: all)
set -uo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
OUT_DIR="${OUT_DIR:-$REPO_ROOT/backfill_results}"
WORKTREE_BASE="${WORKTREE_BASE:-$REPO_ROOT/.backfill_wt}"
export KALENDER_PERF_RUNS="${KALENDER_PERF_RUNS:-2}"
HISTORY_REF="performance-results:performance_history.json"

mkdir -p "$OUT_DIR"

# Files overlaid from the current tree onto each historical commit.
OVERLAY_FILES=(
  "benchmark/fixtures.dart"
  "benchmark/micro_benchmark_test.dart"
  "examples/testing/test_driver/perf_driver.dart"
  "examples/testing/integration_test/performance_profiling_test.dart"
  "examples/testing/integration_test/utils.dart"
  "examples/testing/lib/test_configuration.dart"
)

# Read commits (sha + timestamp) from the history file, oldest first.
mapfile -t COMMITS < <(git show "$HISTORY_REF" | python3 -c '
import json, sys
data = json.load(sys.stdin)
runs = sorted(data.get("runs", []), key=lambda r: r.get("timestamp", ""))
for run in runs:
    sha, ts = run.get("commit_sha"), run.get("timestamp")
    if sha and ts:
        print(f"{sha}\t{ts}")
')

if [[ -n "${LIMIT:-}" ]]; then
  COMMITS=("${COMMITS[@]: -$LIMIT}")
fi

echo "Backfilling ${#COMMITS[@]} commits (KALENDER_PERF_RUNS=$KALENDER_PERF_RUNS)"

idx=0
for entry in "${COMMITS[@]}"; do
  idx=$((idx + 1))
  sha="${entry%%$'\t'*}"
  ts="${entry##*$'\t'}"
  wt="$WORKTREE_BASE/$sha"
  out="$OUT_DIR/$(printf '%03d' "$idx")_$sha.json"
  echo "=== [$idx/${#COMMITS[@]}] $sha ($ts) ==="

  if ! git cat-file -e "$sha^{commit}" 2>/dev/null; then
    echo "  ! commit not found locally, skipping"
    continue
  fi

  git worktree add --force --detach "$wt" "$sha" >/dev/null 2>&1 || {
    echo "  ! worktree add failed, skipping"
    continue
  }

  for file in "${OVERLAY_FILES[@]}"; do
    mkdir -p "$wt/$(dirname "$file")"
    cp "$REPO_ROOT/$file" "$wt/$file"
  done

  author="$(git show -s --format='%an' "$sha")"
  subject="$(git show -s --format='%s' "$sha")"
  micro_file=""
  frame_file=""

  # --- micro-benchmarks ---
  if (
    cd "$wt" \
      && flutter pub get >/dev/null 2>&1 \
      && { grep -q 'benchmark_harness' pubspec.yaml || flutter pub add 'dev:benchmark_harness' >/dev/null 2>&1; } \
      && flutter pub get >/dev/null 2>&1 \
      && flutter test benchmark/micro_benchmark_test.dart >/dev/null 2>&1
  ) && [[ -f "$wt/build/micro_results.json" ]]; then
    micro_file="$OUT_DIR/.micro_$idx.json"
    cp "$wt/build/micro_results.json" "$micro_file"
    echo "  micro: ok"
  else
    echo "  micro: FAILED (skipped)"
  fi

  # --- frame profiling ---
  if (
    cd "$wt/examples/testing" \
      && flutter pub get >/dev/null 2>&1 \
      && flutter drive \
        --driver=test_driver/perf_driver.dart \
        --target=integration_test/performance_profiling_test.dart \
        --profile -d linux >/dev/null 2>&1
  ) && [[ -f "$wt/examples/testing/build/frame_results.json" ]]; then
    frame_file="$OUT_DIR/.frame_$idx.json"
    cp "$wt/examples/testing/build/frame_results.json" "$frame_file"
    echo "  frame: ok"
  else
    echo "  frame: FAILED (skipped)"
  fi

  python3 - "$out" "$sha" "$ts" "$author" "$subject" "$micro_file" "$frame_file" <<'PY'
import json, sys
out, sha, ts, author, subject, micro_file, frame_file = sys.argv[1:8]

def load(path):
    if not path:
        return None
    try:
        with open(path, encoding="utf-8") as handle:
            return json.load(handle)
    except Exception:
        return None

record = {
    "sha": sha, "timestamp": ts, "author": author, "message": subject,
    "micro": load(micro_file), "frame": load(frame_file),
}
with open(out, "w", encoding="utf-8") as handle:
    json.dump(record, handle, indent=2)
PY
  echo "  wrote $out"

  rm -f "$micro_file" "$frame_file" 2>/dev/null || true
  git worktree remove --force "$wt" >/dev/null 2>&1 || true
done

git worktree prune >/dev/null 2>&1 || true
echo "Done. Per-commit results in $OUT_DIR"
