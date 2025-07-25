#!/usr/bin/env python3
"""
Performance comparison script for Flutter Kalender project.
This script compares current performance data with baseline data and generates a markdown report.
"""

import json
import sys
import os
import argparse

def load_json(file_path):
    """Load JSON data from file."""
    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Warning: File {file_path} not found")
        return None
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in {file_path}: {e}")
        return None

def format_metric_name(metric):
    """Convert snake_case metric names to readable format."""
    return metric.replace('_', ' ').title()

def get_status_icon(change_pct, metric_name):
    """Get status icon based on performance change percentage."""
    # For timing metrics, lower is better
    if 'time' in metric_name or 'missed' in metric_name or 'gc_count' in metric_name:
        if change_pct <= -5:
            return "🟢"  # Significant improvement
        elif change_pct <= 0:
            return "🟡"  # Minor improvement or no change
        elif change_pct <= 10:
            return "🟠"  # Minor regression
        else:
            return "🔴"  # Significant regression
    else:
        # For count metrics like frame_count, higher might be better
        if change_pct >= 5:
            return "🟢"
        elif change_pct >= 0:
            return "🟡"
        else:
            return "🔴"

def compare_scenarios(current, baseline):
    """Compare performance scenarios between current and baseline data."""
    if not baseline:
        return "## 📊 Performance Report\n\n❌ No baseline data available for comparison.\n"
    
    # Get all scenarios from both current and baseline
    all_scenarios = set(current.keys()) | set(baseline.keys())
    
    # First, analyze all scenarios to gather summary data
    critical_issues = []
    improvements = []
    minor_regressions = []
    
    for scenario in all_scenarios:
        if scenario in current and scenario in baseline:
            current_data = current[scenario]
            baseline_data = baseline[scenario]
            
            # Check for critical performance regressions
            if 'average_frame_build_time_millis' in current_data and 'average_frame_build_time_millis' in baseline_data:
                current_val = current_data['average_frame_build_time_millis']
                baseline_val = baseline_data['average_frame_build_time_millis']
                change_pct = ((current_val - baseline_val) / baseline_val * 100) if baseline_val != 0 else 0
                
                if change_pct > 15:
                    critical_issues.append(f"🔴 **{scenario}**: Frame build time increased by {change_pct:.1f}%")
                elif change_pct > 5:
                    minor_regressions.append(f"🟠 **{scenario}**: Frame build time increased by {change_pct:.1f}%")
                elif change_pct < -10:
                    improvements.append(f"🟢 **{scenario}**: Frame build time improved by {abs(change_pct):.1f}%")
    
    # Start building the report with summary at the top
    report = "## 📊 Performance Report\n\n"
    
    # Summary section at the top
    report += "### 📋 Summary\n\n"
    
    if critical_issues:
        report += "**⚠️ Critical Performance Issues:**\n"
        for issue in critical_issues:
            report += f"- {issue}\n"
        report += "\n"
    
    if minor_regressions:
        report += "**🟠 Minor Performance Regressions:**\n"
        for regression in minor_regressions:
            report += f"- {regression}\n"
        report += "\n"
    
    if improvements:
        report += "**✅ Performance Improvements:**\n"
        for improvement in improvements:
            report += f"- {improvement}\n"
        report += "\n"
    
    if not critical_issues and not minor_regressions and not improvements:
        report += "✅ No significant performance changes detected.\n\n"
    
    # Add overall stats
    total_scenarios = len(all_scenarios)
    compared_scenarios = len([s for s in all_scenarios if s in current and s in baseline])
    new_scenarios = len([s for s in all_scenarios if s in current and s not in baseline])
    missing_scenarios = len([s for s in all_scenarios if s not in current and s in baseline])
    
    report += f"**📊 Analysis Overview:**\n"
    report += f"- Total scenarios: {total_scenarios}\n"
    report += f"- Compared with baseline: {compared_scenarios}\n"
    if new_scenarios > 0:
        report += f"- New scenarios: {new_scenarios}\n"
    if missing_scenarios > 0:
        report += f"- Missing scenarios: {missing_scenarios}\n"
    report += "\n"
    
    # Detailed results in collapsible section
    report += "<details>\n"
    report += "<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>\n\n"
    
    for scenario in sorted(all_scenarios):
        report += f"#### {scenario}\n\n"
        
        if scenario not in current:
            report += "❌ **Missing in current run**\n\n"
            continue
        elif scenario not in baseline:
            report += "🆕 **New scenario (no baseline)**\n\n"
            # Show current metrics for new scenarios
            current_data = current[scenario]
            report += "| Metric | Current Value |\n"
            report += "|--------|--------------|\n"
            key_metrics = [
                'average_frame_build_time_millis',
                'worst_frame_build_time_millis', 
                'missed_frame_build_budget_count',
                'average_frame_rasterizer_time_millis',
                'missed_frame_rasterizer_budget_count',
                'new_gen_gc_count',
                'old_gen_gc_count'
            ]
            for metric in key_metrics:
                if metric in current_data:
                    val = current_data[metric]
                    metric_display = format_metric_name(metric)
                    if 'time' in metric:
                        report += f"| {metric_display} | {val:.2f}ms |\n"
                    else:
                        report += f"| {metric_display} | {val} |\n"
            report += "\n"
            continue
        
        current_data = current[scenario]
        baseline_data = baseline[scenario]
        
        # Create comparison table for this scenario
        report += "| Metric | Current | Baseline | Change | Status |\n"
        report += "|--------|---------|----------|--------|--------|\n"
        
        # Key metrics to highlight
        key_metrics = [
            'average_frame_build_time_millis',
            'worst_frame_build_time_millis', 
            'missed_frame_build_budget_count',
            'average_frame_rasterizer_time_millis',
            'missed_frame_rasterizer_budget_count',
            'new_gen_gc_count',
            'old_gen_gc_count'
        ]
        
        # Process key metrics first
        for metric in key_metrics:
            if metric in current_data and metric in baseline_data:
                current_val = current_data[metric]
                baseline_val = baseline_data[metric]
                
                if isinstance(current_val, (int, float)) and isinstance(baseline_val, (int, float)):
                    change = current_val - baseline_val
                    change_pct = (change / baseline_val * 100) if baseline_val != 0 else 0
                    
                    status = get_status_icon(change_pct, metric)
                    metric_display = format_metric_name(metric)
                    
                    if 'time' in metric:
                        report += f"| {metric_display} | {current_val:.2f}ms | {baseline_val:.2f}ms | {change:+.2f}ms ({change_pct:+.1f}%) | {status} |\n"
                    else:
                        report += f"| {metric_display} | {current_val} | {baseline_val} | {change:+.0f} ({change_pct:+.1f}%) | {status} |\n"
        
        report += "\n"
    
    report += "</details>\n\n"
    
    return report
def main():
    """Main function to run the performance comparison."""
    parser = argparse.ArgumentParser(description='Compare Flutter performance metrics')
    parser.add_argument('--current', '-c', default='performance_summary.json',
                       help='Path to current performance summary JSON file')
    parser.add_argument('--baseline', '-b', default='baseline_performance.json',
                       help='Path to baseline performance summary JSON file')
    parser.add_argument('--output', '-o', default='performance_report.md',
                       help='Output file for the performance report')
    parser.add_argument('--verbose', '-v', action='store_true',
                       help='Enable verbose output')
    
    args = parser.parse_args()
    
    if args.verbose:
        print(f"Loading current data from: {args.current}")
        print(f"Loading baseline data from: {args.baseline}")
        print(f"Output will be written to: {args.output}")
    
    # Load and compare data
    current = load_json(args.current)
    baseline = load_json(args.baseline)
    
    if current:
        report = compare_scenarios(current, baseline)
        
        # Write report to file
        try:
            with open(args.output, 'w') as f:
                f.write(report)
            print(f"✅ Performance report generated successfully: {args.output}")
        except IOError as e:
            print(f"❌ Error writing report to {args.output}: {e}")
            return 1
        
        # Print summary to console
        if baseline:
            print(f"📊 Compared {len(current)} scenarios with baseline data")
            if args.verbose:
                print("Scenarios analyzed:")
                for scenario in sorted(current.keys()):
                    print(f"  - {scenario}")
        else:
            print("⚠️  No baseline data available for comparison")
            
    else:
        print("❌ No current performance data found")
        try:
            with open(args.output, 'w') as f:
                f.write("## 📊 Performance Report\n\n❌ No performance data was generated in this run.\n")
        except IOError as e:
            print(f"❌ Error writing error report: {e}")
            return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())