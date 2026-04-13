## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 31.4%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 15.1%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 15.9%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 26.8%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 15.5%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 6.6%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 9.7%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 10.2%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 10.2%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 6.0%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 7.2%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 13.1%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 13.1%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 8.1%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 7.9%

**Performance Improvements:**
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 11.7%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 25.6%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.21ms | 3.63ms | -0.43ms (-11.7%) | 🟢 |
| Worst Frame Build Time Millis | 8.08ms | 8.92ms | -0.85ms (-9.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.03ms | 4.40ms | +0.63ms (+14.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.67ms | 5.25ms | +0.41ms (+7.9%) | 🟠 |
| Worst Frame Build Time Millis | 18.10ms | 16.12ms | +1.98ms (+12.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 0.25 | +1 (+500.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.95ms | 5.93ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.71ms | +0.06ms (+8.1%) | 🟠 |
| Worst Frame Build Time Millis | 3.96ms | 2.82ms | +1.14ms (+40.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.12ms | 5.35ms | +0.78ms (+14.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.0 | 1.75 | +0 (+14.3%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.65ms | -0.17ms (-25.6%) | 🟢 |
| Worst Frame Build Time Millis | 1.99ms | 3.30ms | -1.31ms (-39.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.69ms | 5.98ms | -0.29ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.69ms | 10.01ms | +2.69ms (+26.8%) | 🔴 |
| Worst Frame Build Time Millis | 35.80ms | 27.90ms | +7.90ms (+28.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.51ms | 5.01ms | +1.50ms (+29.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.13ms | 7.86ms | +0.27ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 15.23ms | 14.58ms | +0.65ms (+4.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.81ms | 6.69ms | +0.12ms (+1.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.95ms | 2.24ms | +0.70ms (+31.4%) | 🔴 |
| Worst Frame Build Time Millis | 37.91ms | 36.24ms | +1.67ms (+4.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.60ms | 6.49ms | +0.11ms (+1.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.75 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.5 | 10.0 | -2 (-15.0%) | 🟢 |
| Old Gen Gc Count | 4.5 | 3.5 | +1 (+28.6%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.75ms | +0.05ms (+6.0%) | 🟠 |
| Worst Frame Build Time Millis | 2.12ms | 1.98ms | +0.13ms (+6.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.15ms | 4.42ms | -0.26ms (-6.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.03ms | 2.94ms | +0.09ms (+3.2%) | 🟠 |
| Worst Frame Build Time Millis | 10.01ms | 10.11ms | -0.11ms (-1.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.47ms | 4.30ms | +0.16ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.72ms | +0.10ms (+13.1%) | 🔴 |
| Worst Frame Build Time Millis | 4.25ms | 3.11ms | +1.14ms (+36.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.03ms | 4.32ms | +0.71ms (+16.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.75 | +0 (+33.3%) | 🔴 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.47ms | +0.01ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 2.11ms | 2.23ms | -0.12ms (-5.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.22ms | 3.96ms | +0.26ms (+6.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.17ms | 1.92ms | +0.25ms (+13.1%) | 🔴 |
| Worst Frame Build Time Millis | 4.05ms | 3.38ms | +0.67ms (+19.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.52ms | 5.32ms | +0.20ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.09ms | 7.37ms | +0.72ms (+9.7%) | 🟠 |
| Worst Frame Build Time Millis | 26.82ms | 25.08ms | +1.73ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.63ms | 9.26ms | +0.38ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.33ms | 16.34ms | -1.01ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 46.72ms | 54.97ms | -8.26ms (-15.0%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.14ms | 9.29ms | +0.85ms (+9.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.64ms | 1.42ms | +0.22ms (+15.5%) | 🔴 |
| Worst Frame Build Time Millis | 9.96ms | 12.23ms | -2.27ms (-18.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.23ms | 8.45ms | +0.79ms (+9.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 8.75 | 5.0 | +4 (+75.0%) | 🔴 |
| New Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 1.00ms | +0.10ms (+10.2%) | 🔴 |
| Worst Frame Build Time Millis | 5.54ms | 4.05ms | +1.49ms (+36.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.26ms | 6.49ms | +1.77ms (+27.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.75 | 0.25 | +2 (+600.0%) | 🔴 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.27ms | 5.97ms | +0.30ms (+5.0%) | 🟠 |
| Worst Frame Build Time Millis | 26.79ms | 24.43ms | +2.36ms (+9.7%) | 🟠 |
| Missed Frame Build Budget Count | 5.75 | 4.5 | +1 (+27.8%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.78ms | 6.61ms | +0.17ms (+2.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 27.74ms | 25.87ms | +1.87ms (+7.2%) | 🟠 |
| Worst Frame Build Time Millis | 52.88ms | 47.84ms | +5.04ms (+10.5%) | 🔴 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.86ms | 7.58ms | +0.28ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.32ms | 1.14ms | +0.18ms (+15.9%) | 🔴 |
| Worst Frame Build Time Millis | 17.96ms | 15.85ms | +2.11ms (+13.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.54ms | 6.97ms | -0.43ms (-6.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 4.75 | -4 (-78.9%) | 🟢 |
| New Gen Gc Count | 7.0 | 6.5 | +0 (+7.7%) | 🟠 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.52ms | 1.42ms | +0.09ms (+6.6%) | 🟠 |
| Worst Frame Build Time Millis | 8.65ms | 7.09ms | +1.55ms (+21.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.96ms | 6.80ms | +0.16ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.45ms | 8.61ms | -0.16ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 31.13ms | 29.79ms | +1.34ms (+4.5%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.80ms | 9.86ms | -0.06ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.45ms | 1.32ms | +0.13ms (+10.2%) | 🔴 |
| Worst Frame Build Time Millis | 7.98ms | 5.73ms | +2.25ms (+39.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.90ms | 10.74ms | +1.16ms (+10.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 26.5 | 16.5 | +10 (+60.6%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.09ms | 1.18ms | -0.09ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 6.09ms | 6.81ms | -0.72ms (-10.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.29ms | 12.63ms | -0.34ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 5.25 | 3.75 | +2 (+40.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.79ms | 3.29ms | +0.50ms (+15.1%) | 🔴 |
| Worst Frame Build Time Millis | 6.98ms | 7.56ms | -0.58ms (-7.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.64ms | 10.45ms | +0.19ms (+1.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>
