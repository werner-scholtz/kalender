## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 35.1%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 40.1%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 14.4%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 6.6%

**Performance Improvements:**
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 22.4%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 11.9%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 25.9%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 21.1%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 27.6%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 18.0%
- 🟢 **one_event_per_day-month-navigation**: Frame build time improved by 11.4%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 11.5%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 13.1%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 15.6%
- 🟢 **ten_events_per_day-week-navigation**: Frame build time improved by 14.8%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.10ms | 2.83ms | -0.73ms (-25.9%) | 🟢 |
| Worst Frame Build Time Millis | 4.98ms | 7.23ms | -2.25ms (-31.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.28ms | 4.71ms | -1.43ms (-30.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.35ms | 4.90ms | -0.56ms (-11.4%) | 🟢 |
| Worst Frame Build Time Millis | 13.26ms | 17.42ms | -4.16ms (-23.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.54ms | 5.97ms | -1.43ms (-24.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.64ms | +0.04ms (+6.6%) | 🟠 |
| Worst Frame Build Time Millis | 4.06ms | 3.32ms | +0.74ms (+22.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.26ms | 5.51ms | -1.26ms (-22.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.40ms | +0.16ms (+40.1%) | 🔴 |
| Worst Frame Build Time Millis | 2.81ms | 2.01ms | +0.80ms (+39.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.70ms | 4.74ms | -0.05ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.42ms | 10.25ms | -2.83ms (-27.6%) | 🟢 |
| Worst Frame Build Time Millis | 20.36ms | 28.51ms | -8.15ms (-28.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.00ms | 6.19ms | -2.19ms (-35.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.37ms | 7.33ms | -0.96ms (-13.1%) | 🟢 |
| Worst Frame Build Time Millis | 11.55ms | 14.31ms | -2.76ms (-19.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.01ms | 6.97ms | -1.96ms (-28.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.92ms | 2.34ms | -0.42ms (-18.0%) | 🟢 |
| Worst Frame Build Time Millis | 22.20ms | 30.54ms | -8.35ms (-27.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.88ms | 6.70ms | -1.82ms (-27.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.75 | -1 (-71.4%) | 🟢 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.65ms | -0.03ms (-5.0%) | 🟢 |
| Worst Frame Build Time Millis | 1.60ms | 1.69ms | -0.09ms (-5.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.22ms | 3.88ms | -0.66ms (-17.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.48ms | 2.50ms | -0.02ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 8.19ms | 9.27ms | -1.08ms (-11.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.39ms | 4.20ms | -0.81ms (-19.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.66ms | +0.00ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 2.57ms | 3.33ms | -0.76ms (-22.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.55ms | 4.62ms | -1.08ms (-23.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.25 | -1 (-80.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.41ms | +0.06ms (+14.4%) | 🔴 |
| Worst Frame Build Time Millis | 2.34ms | 1.96ms | +0.38ms (+19.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 4.04ms | -0.09ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.75ms | 1.87ms | -0.11ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.60ms | 4.43ms | -0.83ms (-18.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.49ms | 5.67ms | -1.17ms (-20.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.90ms | 6.67ms | -0.77ms (-11.5%) | 🟢 |
| Worst Frame Build Time Millis | 19.85ms | 23.18ms | -3.33ms (-14.4%) | 🟢 |
| Missed Frame Build Budget Count | 2.75 | 5.25 | -2 (-47.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.72ms | 9.37ms | -2.65ms (-28.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |
| Old Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.75ms | 15.14ms | -3.39ms (-22.4%) | 🟢 |
| Worst Frame Build Time Millis | 37.06ms | 53.06ms | -15.99ms (-30.1%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 3.75 | -0 (-6.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.72ms | 9.15ms | -2.43ms (-26.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.21ms | -0.01ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 7.44ms | 9.38ms | -1.94ms (-20.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.73ms | 8.83ms | -3.10ms (-35.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 7.75 | -8 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.86ms | 0.64ms | +0.22ms (+35.1%) | 🔴 |
| Worst Frame Build Time Millis | 4.50ms | 3.18ms | +1.33ms (+41.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.05ms | 6.18ms | -1.13ms (-18.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.41ms | 5.23ms | -0.82ms (-15.6%) | 🟢 |
| Worst Frame Build Time Millis | 18.52ms | 23.34ms | -4.82ms (-20.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.75 | 3.5 | -2 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.87ms | 6.73ms | -1.87ms (-27.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 20.54ms | 21.58ms | -1.03ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 36.78ms | 45.62ms | -8.84ms (-19.4%) | 🟢 |
| Missed Frame Build Budget Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.31ms | 7.94ms | -2.63ms (-33.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.06ms | 1.21ms | -0.14ms (-11.9%) | 🟢 |
| Worst Frame Build Time Millis | 13.35ms | 16.30ms | -2.95ms (-18.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.00ms | 7.33ms | -2.34ms (-31.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 5.5 | -5 (-95.5%) | 🟢 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.16ms | 1.15ms | +0.02ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 6.02ms | 7.01ms | -1.00ms (-14.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.61ms | 6.87ms | -2.26ms (-32.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.60ms | 7.74ms | -1.15ms (-14.8%) | 🟢 |
| Worst Frame Build Time Millis | 22.78ms | 27.53ms | -4.74ms (-17.2%) | 🟢 |
| Missed Frame Build Budget Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.14ms | 9.94ms | -2.80ms (-28.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.21ms | -0.00ms (-0.3%) | 🟡 |
| Worst Frame Build Time Millis | 7.78ms | 4.80ms | +2.99ms (+62.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.05ms | 11.40ms | -3.34ms (-29.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.25 | 17.0 | -14 (-80.9%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.98ms | 1.04ms | -0.06ms (-5.5%) | 🟢 |
| Worst Frame Build Time Millis | 5.48ms | 5.58ms | -0.10ms (-1.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.42ms | 12.22ms | -2.81ms (-23.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.25 | 3.5 | -1 (-35.7%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.99ms | 3.79ms | -0.80ms (-21.1%) | 🟢 |
| Worst Frame Build Time Millis | 6.14ms | 10.20ms | -4.06ms (-39.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.45ms | 11.55ms | -4.10ms (-35.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.75 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>
