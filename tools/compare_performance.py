#!/usr/bin/env python3
"""Performance comparison and branch dashboard generator.

This script compares current performance data with baseline data, writes a
markdown comparison report, and can optionally maintain a rolling run history,
generate an SVG trend chart, and write a README for the performance-results
branch.
"""

import argparse
import json
import math
import sys
from datetime import datetime, timezone
from pathlib import Path

KEY_METRICS = [
    'average_frame_build_time_millis',
    'worst_frame_build_time_millis',
    'missed_frame_build_budget_count',
    'average_frame_rasterizer_time_millis',
    'missed_frame_rasterizer_budget_count',
    'new_gen_gc_count',
    'old_gen_gc_count',
]


def load_json(file_path):
    """Load JSON data from file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as file_handle:
            return json.load(file_handle)
    except FileNotFoundError:
        print(f'Warning: File {file_path} not found')
        return None
    except json.JSONDecodeError as error:
        print(f'Error: Invalid JSON in {file_path}: {error}')
        return None


def save_text(file_path, content):
    """Write text content to a file."""
    output_path = Path(file_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(content, encoding='utf-8')


def save_json(file_path, data):
    """Write JSON data to a file."""
    output_path = Path(file_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(f'{json.dumps(data, indent=2)}\n', encoding='utf-8')


def format_metric_name(metric):
    """Convert snake_case metric names to readable format."""
    return metric.replace('_', ' ').title()


def get_status_icon(change_pct, metric_name):
    """Get status icon based on performance change percentage."""
    # For timing metrics and frame-budget misses, lower values are better.
    if 'time' in metric_name or 'missed' in metric_name or 'gc_count' in metric_name:
        if change_pct <= -5:
            return '🟢'
        if change_pct <= 0:
            return '🟡'
        if change_pct <= 10:
            return '🟠'
        return '🔴'

    # For throughput-style counters, higher might be better.
    if change_pct >= 5:
        return '🟢'
    if change_pct >= 0:
        return '🟡'
    return '🔴'


def compare_scenarios(current, baseline):
    """Compare performance scenarios between current and baseline data."""
    if not baseline:
        return '## Performance Report\n\nNo baseline data available for comparison.\n'

    all_scenarios = set(current.keys()) | set(baseline.keys())

    critical_issues = []
    improvements = []
    minor_regressions = []

    for scenario in all_scenarios:
        if scenario not in current or scenario not in baseline:
            continue

        current_data = current[scenario]
        baseline_data = baseline[scenario]

        if (
            'average_frame_build_time_millis' in current_data
            and 'average_frame_build_time_millis' in baseline_data
        ):
            current_val = current_data['average_frame_build_time_millis']
            baseline_val = baseline_data['average_frame_build_time_millis']
            change_pct = ((current_val - baseline_val) / baseline_val * 100) if baseline_val != 0 else 0

            if change_pct > 15:
                critical_issues.append(
                    f'🔴 **{scenario}**: Frame build time increased by {change_pct:.1f}%',
                )
            elif change_pct > 5:
                minor_regressions.append(
                    f'🟠 **{scenario}**: Frame build time increased by {change_pct:.1f}%',
                )
            elif change_pct < -10:
                improvements.append(
                    f'🟢 **{scenario}**: Frame build time improved by {abs(change_pct):.1f}%',
                )

    report = '## Summary\n\n'

    if critical_issues:
        report += '**Critical Performance Issues:**\n'
        report += ''.join(f'- {issue}\n' for issue in critical_issues)
        report += '\n'

    if minor_regressions:
        report += '**Minor Performance Regressions:**\n'
        report += ''.join(f'- {regression}\n' for regression in minor_regressions)
        report += '\n'

    if improvements:
        report += '**Performance Improvements:**\n'
        report += ''.join(f'- {improvement}\n' for improvement in improvements)
        report += '\n'

    if not critical_issues and not minor_regressions and not improvements:
        report += 'No significant performance changes detected.\n\n'

    total_scenarios = len(all_scenarios)
    compared_scenarios = len([scenario for scenario in all_scenarios if scenario in current and scenario in baseline])
    new_scenarios = len([scenario for scenario in all_scenarios if scenario in current and scenario not in baseline])
    missing_scenarios = len([scenario for scenario in all_scenarios if scenario not in current and scenario in baseline])

    report += '**Analysis Overview:**\n'
    report += f'- Total scenarios: {total_scenarios}\n'
    report += f'- Compared with baseline: {compared_scenarios}\n'
    if new_scenarios > 0:
        report += f'- New scenarios: {new_scenarios}\n'
    if missing_scenarios > 0:
        report += f'- Missing scenarios: {missing_scenarios}\n'
    report += '\n'

    report += '<details>\n'
    report += '<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>\n\n'

    for scenario in sorted(all_scenarios):
        report += f'#### {scenario}\n\n'

        if scenario not in current:
            report += '**Missing in current run**\n\n'
            continue
        if scenario not in baseline:
            report += '**New scenario (no baseline)**\n\n'
            current_data = current[scenario]
            report += '| Metric | Current Value |\n'
            report += '|--------|--------------|\n'
            for metric in KEY_METRICS:
                if metric not in current_data:
                    continue

                current_value = current_data[metric]
                metric_display = format_metric_name(metric)
                if 'time' in metric:
                    report += f'| {metric_display} | {current_value:.2f}ms |\n'
                else:
                    report += f'| {metric_display} | {current_value} |\n'
            report += '\n'
            continue

        current_data = current[scenario]
        baseline_data = baseline[scenario]

        report += '| Metric | Current | Baseline | Change | Status |\n'
        report += '|--------|---------|----------|--------|--------|\n'

        for metric in KEY_METRICS:
            if metric not in current_data or metric not in baseline_data:
                continue

            current_val = current_data[metric]
            baseline_val = baseline_data[metric]

            if not isinstance(current_val, (int, float)) or not isinstance(baseline_val, (int, float)):
                continue

            change = current_val - baseline_val
            change_pct = (change / baseline_val * 100) if baseline_val != 0 else 0
            status = get_status_icon(change_pct, metric)
            metric_display = format_metric_name(metric)

            if 'time' in metric:
                report += (
                    f'| {metric_display} | {current_val:.2f}ms | {baseline_val:.2f}ms | '
                    f'{change:+.2f}ms ({change_pct:+.1f}%) | {status} |\n'
                )
            else:
                report += (
                    f'| {metric_display} | {current_val} | {baseline_val} | '
                    f'{change:+.0f} ({change_pct:+.1f}%) | {status} |\n'
                )

        report += '\n'

    report += '</details>\n'
    return report


def safe_mean(values):
    """Return arithmetic mean of numeric values or None."""
    numeric_values = [value for value in values if isinstance(value, (int, float))]
    if not numeric_values:
        return None
    return sum(numeric_values) / len(numeric_values)


def summarize_current(current):
    """Create aggregate summary stats from current scenario data."""
    scenarios = list(current.values())

    avg_build = safe_mean(
        [scenario.get('average_frame_build_time_millis') for scenario in scenarios],
    )
    avg_rasterizer = safe_mean(
        [scenario.get('average_frame_rasterizer_time_millis') for scenario in scenarios],
    )

    missed_build_total = sum(
        scenario.get('missed_frame_build_budget_count', 0)
        for scenario in scenarios
        if isinstance(scenario.get('missed_frame_build_budget_count', 0), (int, float))
    )
    missed_rasterizer_total = sum(
        scenario.get('missed_frame_rasterizer_budget_count', 0)
        for scenario in scenarios
        if isinstance(scenario.get('missed_frame_rasterizer_budget_count', 0), (int, float))
    )

    return {
        'scenario_count': len(scenarios),
        'avg_build_time_ms': avg_build,
        'avg_rasterizer_time_ms': avg_rasterizer,
        'missed_build_budget_total': int(missed_build_total),
        'missed_rasterizer_budget_total': int(missed_rasterizer_total),
    }


def upsert_history(history_data, run_entry, history_limit):
    """Insert or update current run in history, then keep only latest N runs."""
    runs = history_data.get('runs', [])
    run_key = (str(run_entry.get('run_number') or ''), str(run_entry.get('commit_sha') or ''))

    replaced = False
    for index, existing in enumerate(runs):
        existing_key = (str(existing.get('run_number') or ''), str(existing.get('commit_sha') or ''))
        if existing_key == run_key and run_key != ('', ''):
            runs[index] = run_entry
            replaced = True
            break

    if not replaced:
        runs.append(run_entry)

    runs = sorted(runs, key=lambda item: item.get('timestamp', ''))
    if history_limit > 0:
        runs = runs[-history_limit:]

    return {'runs': runs}


def format_run_label(run_entry):
    """Create compact run label for chart/readme display."""
    run_number = run_entry.get('run_number')
    commit_sha = str(run_entry.get('commit_sha') or '')
    short_sha = commit_sha[:7] if commit_sha else ''
    if run_number and short_sha:
        return f'#{run_number} ({short_sha})'
    if run_number:
        return f'#{run_number}'
    if short_sha:
        return short_sha
    return 'run'


def svg_escape(text):
    """Escape text for SVG output."""
    return (
        str(text)
        .replace('&', '&amp;')
        .replace('<', '&lt;')
        .replace('>', '&gt;')
        .replace('"', '&quot;')
        .replace("'", '&#39;')
    )


def build_polyline(points):
    """Return SVG polyline points string."""
    return ' '.join(f'{x:.1f},{y:.1f}' for x, y in points)


def generate_svg_chart(history_data, output_path):
    """Generate an SVG chart for average build/rasterizer trends."""
    runs = history_data.get('runs', [])
    width = 960
    height = 420
    margin_left = 70
    margin_right = 30
    margin_top = 50
    margin_bottom = 80

    plot_width = width - margin_left - margin_right
    plot_height = height - margin_top - margin_bottom

    if not runs:
        svg = (
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
            f'viewBox="0 0 {width} {height}">'
            '<rect width="100%" height="100%" fill="#ffffff" />'
            '<text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" '
            'font-family="Arial, sans-serif" font-size="18" fill="#4b5563">'
            'No performance history available yet'
            '</text></svg>'
        )
        save_text(output_path, svg)
        return

    build_values = [run.get('avg_build_time_ms') for run in runs]
    raster_values = [run.get('avg_rasterizer_time_ms') for run in runs]
    all_values = [value for value in build_values + raster_values if isinstance(value, (int, float))]

    min_value = min(all_values) if all_values else 0
    max_value = max(all_values) if all_values else 1

    if math.isclose(min_value, max_value):
        min_value = min_value * 0.8 if min_value > 0 else 0
        max_value = max_value * 1.2 if max_value > 0 else 1

    padding = (max_value - min_value) * 0.12
    y_min = max(0, min_value - padding)
    y_max = max_value + padding

    def x_for_index(index):
        if len(runs) == 1:
            return margin_left + (plot_width / 2)
        return margin_left + (index / (len(runs) - 1)) * plot_width

    def y_for_value(value):
        if not isinstance(value, (int, float)):
            return None
        if math.isclose(y_max, y_min):
            return margin_top + (plot_height / 2)
        ratio = (value - y_min) / (y_max - y_min)
        return margin_top + plot_height - ratio * plot_height

    build_points = []
    raster_points = []
    for index, run in enumerate(runs):
        x_pos = x_for_index(index)
        build_y = y_for_value(run.get('avg_build_time_ms'))
        raster_y = y_for_value(run.get('avg_rasterizer_time_ms'))
        if build_y is not None:
            build_points.append((x_pos, build_y))
        if raster_y is not None:
            raster_points.append((x_pos, raster_y))

    y_ticks = 5
    svg_parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="#ffffff" />',
        (
            '<text x="70" y="28" font-family="Arial, sans-serif" font-size="20" '
            'font-weight="600" fill="#111827">Kalender Performance Trend (Last 20 Runs)</text>'
        ),
    ]

    for tick in range(y_ticks + 1):
        value = y_min + ((y_max - y_min) * tick / y_ticks)
        y_pos = margin_top + plot_height - (plot_height * tick / y_ticks)
        svg_parts.append(
            f'<line x1="{margin_left}" y1="{y_pos:.1f}" x2="{width - margin_right}" y2="{y_pos:.1f}" '
            'stroke="#e5e7eb" stroke-width="1" />',
        )
        svg_parts.append(
            f'<text x="{margin_left - 10}" y="{y_pos + 4:.1f}" text-anchor="end" '
            'font-family="Arial, sans-serif" font-size="11" fill="#6b7280">'
            f'{value:.2f}ms</text>',
        )

    svg_parts.append(
        f'<line x1="{margin_left}" y1="{margin_top + plot_height}" x2="{width - margin_right}" '
        f'y2="{margin_top + plot_height}" stroke="#9ca3af" stroke-width="1.5" />',
    )
    svg_parts.append(
        f'<line x1="{margin_left}" y1="{margin_top}" x2="{margin_left}" y2="{margin_top + plot_height}" '
        'stroke="#9ca3af" stroke-width="1.5" />',
    )

    if build_points:
        svg_parts.append(
            f'<polyline points="{build_polyline(build_points)}" fill="none" stroke="#2563eb" '
            'stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />',
        )
        for x_pos, y_pos in build_points:
            svg_parts.append(
                f'<circle cx="{x_pos:.1f}" cy="{y_pos:.1f}" r="2.8" fill="#2563eb" />',
            )

    if raster_points:
        svg_parts.append(
            f'<polyline points="{build_polyline(raster_points)}" fill="none" stroke="#f59e0b" '
            'stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />',
        )
        for x_pos, y_pos in raster_points:
            svg_parts.append(
                f'<circle cx="{x_pos:.1f}" cy="{y_pos:.1f}" r="2.8" fill="#f59e0b" />',
            )

    label_step = max(1, len(runs) // 6)
    for index, run in enumerate(runs):
        x_pos = x_for_index(index)
        if index % label_step != 0 and index != len(runs) - 1:
            continue
        label = svg_escape(format_run_label(run))
        svg_parts.append(
            f'<text x="{x_pos:.1f}" y="{margin_top + plot_height + 20}" text-anchor="middle" '
            'font-family="Arial, sans-serif" font-size="10" fill="#6b7280">'
            f'{label}</text>',
        )

    legend_y = height - 32
    svg_parts.append(
        f'<line x1="{margin_left}" y1="{legend_y}" x2="{margin_left + 24}" y2="{legend_y}" '
        'stroke="#2563eb" stroke-width="3" />',
    )
    svg_parts.append(
        f'<text x="{margin_left + 32}" y="{legend_y + 4}" font-family="Arial, sans-serif" '
        'font-size="12" fill="#1f2937">Avg build time (ms)</text>',
    )
    svg_parts.append(
        f'<line x1="{margin_left + 210}" y1="{legend_y}" x2="{margin_left + 234}" y2="{legend_y}" '
        'stroke="#f59e0b" stroke-width="3" />',
    )
    svg_parts.append(
        f'<text x="{margin_left + 242}" y="{legend_y + 4}" font-family="Arial, sans-serif" '
        'font-size="12" fill="#1f2937">Avg rasterizer time (ms)</text>',
    )

    svg_parts.append('</svg>')
    save_text(output_path, ''.join(svg_parts))


def render_readme(history_data, comparison_path, chart_path):
    """Render branch README with latest performance highlights and trend chart."""
    runs = history_data.get('runs', [])
    latest = runs[-1] if runs else None

    lines = [
        '# Performance Results',
        '',
        'This branch stores generated performance artifacts from the Kalender profiling workflow.',
        '',
        '## Trend Chart (Last 20 Runs)',
        '',
        f'![Performance trend]({Path(chart_path).name})',
        '',
    ]

    if latest:
        lines.extend(
            [
                '## Latest Run Summary',
                '',
                '| Metric | Value |',
                '|--------|-------|',
                f"| Run | {format_run_label(latest)} |",
                f"| Timestamp (UTC) | {latest.get('timestamp', 'n/a')} |",
                (
                    '| Average frame build time | '
                    f"{(latest.get('avg_build_time_ms') if latest.get('avg_build_time_ms') is not None else 'n/a')} ms |"
                ),
                (
                    '| Average frame rasterizer time | '
                    f"{(latest.get('avg_rasterizer_time_ms') if latest.get('avg_rasterizer_time_ms') is not None else 'n/a')} ms |"
                ),
                f"| Missed build budget (total) | {latest.get('missed_build_budget_total', 'n/a')} |",
                f"| Missed rasterizer budget (total) | {latest.get('missed_rasterizer_budget_total', 'n/a')} |",
                f"| Scenario count | {latest.get('scenario_count', 'n/a')} |",
                '',
            ],
        )

    lines.extend(
        [
            '## Latest Comparison Report',
            '',
            f'- See [{Path(comparison_path).name}]({Path(comparison_path).name}) for detailed metric-by-metric deltas.',
            '',
            '## Recent Runs',
            '',
            '| Run | Timestamp (UTC) | Avg Build (ms) | Avg Rasterizer (ms) | Missed Build | Missed Rasterizer |',
            '|-----|------------------|----------------|---------------------|--------------|-------------------|',
        ],
    )

    for run in reversed(runs[-20:]):
        build_value = run.get('avg_build_time_ms')
        rasterizer_value = run.get('avg_rasterizer_time_ms')
        lines.append(
            '| '
            f"{format_run_label(run)} | {run.get('timestamp', 'n/a')} | "
            f"{(f'{build_value:.2f}' if isinstance(build_value, (int, float)) else 'n/a')} | "
            f"{(f'{rasterizer_value:.2f}' if isinstance(rasterizer_value, (int, float)) else 'n/a')} | "
            f"{run.get('missed_build_budget_total', 'n/a')} | "
            f"{run.get('missed_rasterizer_budget_total', 'n/a')} |",
        )

    lines.append('')
    return '\n'.join(lines)


def main():
    """Run comparison and optional dashboard artifact generation."""
    parser = argparse.ArgumentParser(description='Compare Flutter performance metrics')
    parser.add_argument(
        '--current',
        '-c',
        default='performance_summary.json',
        help='Path to current performance summary JSON file',
    )
    parser.add_argument(
        '--baseline',
        '-b',
        default='baseline_performance.json',
        help='Path to baseline performance summary JSON file',
    )
    parser.add_argument(
        '--output',
        '-o',
        default='performance_report.md',
        help='Output file for the performance report',
    )
    parser.add_argument(
        '--history-file',
        help='Optional path to performance history JSON file to update',
    )
    parser.add_argument(
        '--chart-output',
        help='Optional path to generated SVG trend chart',
    )
    parser.add_argument(
        '--readme-output',
        help='Optional path to generated README markdown',
    )
    parser.add_argument(
        '--history-limit',
        type=int,
        default=20,
        help='Maximum number of history runs to keep (default: 20)',
    )
    parser.add_argument(
        '--run-number',
        help='Workflow run number for history metadata',
    )
    parser.add_argument(
        '--commit-sha',
        help='Commit SHA for history metadata',
    )
    parser.add_argument(
        '--timestamp',
        help='Override UTC timestamp for history metadata (ISO-8601)',
    )
    parser.add_argument('--verbose', '-v', action='store_true', help='Enable verbose output')

    args = parser.parse_args()

    if args.verbose:
        print(f'Loading current data from: {args.current}')
        print(f'Loading baseline data from: {args.baseline}')
        print(f'Output will be written to: {args.output}')

    current = load_json(args.current)
    baseline = load_json(args.baseline)

    if not current:
        print('No current performance data found')
        save_text(args.output, '## Performance Report\n\nNo performance data was generated in this run.\n')
        return 1

    report = compare_scenarios(current, baseline)
    save_text(args.output, report)
    print(f'Performance report generated successfully: {args.output}')

    if baseline:
        print(f'Compared {len(current)} scenarios with baseline data')
        if args.verbose:
            print('Scenarios analyzed:')
            for scenario in sorted(current.keys()):
                print(f'  - {scenario}')
    else:
        print('No baseline data available for comparison')

    should_generate_dashboard = any([args.history_file, args.chart_output, args.readme_output])
    if not should_generate_dashboard:
        return 0

    if not args.history_file or not args.chart_output or not args.readme_output:
        print(
            'Error: --history-file, --chart-output, and --readme-output are all required '
            'when generating dashboard artifacts.',
        )
        return 1

    history_data = load_json(args.history_file) or {'runs': []}

    timestamp = args.timestamp or datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    summary = summarize_current(current)
    run_entry = {
        'timestamp': timestamp,
        'run_number': args.run_number,
        'commit_sha': args.commit_sha,
        **summary,
    }
    updated_history = upsert_history(history_data, run_entry, args.history_limit)
    save_json(args.history_file, updated_history)

    generate_svg_chart(updated_history, args.chart_output)
    readme_content = render_readme(updated_history, args.output, args.chart_output)
    save_text(args.readme_output, readme_content)

    if args.verbose:
        print(f'Updated history: {args.history_file}')
        print(f'Generated chart: {args.chart_output}')
        print(f'Generated README: {args.readme_output}')

    return 0


if __name__ == '__main__':
    sys.exit(main())