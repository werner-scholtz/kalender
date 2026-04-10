## Summary

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 5.8%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 8.2%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 7.1%

**Performance Improvements:**
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 17.3%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 22.4%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 12.3%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 11.7%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 36.2%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 51.1%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 41.9%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 15.3%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 20.7%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 16.6%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 14.3%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.94ms | 2.75ms | +0.19ms (+7.1%) | 🟠 |
| Worst Frame Build Time Millis | 7.19ms | 6.54ms | +0.65ms (+10.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.31ms | 4.91ms | -0.60ms (-12.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.38ms | 5.27ms | +0.11ms (+2.1%) | 🟠 |
| Worst Frame Build Time Millis | 16.95ms | 17.45ms | -0.50ms (-2.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.58ms | 6.03ms | -0.45ms (-7.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.83ms | -0.12ms (-14.3%) | 🟢 |
| Worst Frame Build Time Millis | 3.05ms | 4.25ms | -1.19ms (-28.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.29ms | 5.50ms | -0.21ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.5 | -1 (-83.3%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 5.0 | -2 (-30.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.91ms | -0.38ms (-41.9%) | 🟢 |
| Worst Frame Build Time Millis | 2.18ms | 2.48ms | -0.31ms (-12.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.52ms | 5.99ms | +0.54ms (+9.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 3.0 | -2 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.18ms | 10.50ms | -0.32ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 28.66ms | 29.54ms | -0.88ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.86ms | 5.42ms | -0.57ms (-10.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.68ms | 7.89ms | -0.21ms (-2.7%) | 🟡 |
| Worst Frame Build Time Millis | 15.59ms | 14.49ms | +1.10ms (+7.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.64ms | 6.88ms | -0.24ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.10ms | 2.39ms | -0.29ms (-12.3%) | 🟢 |
| Worst Frame Build Time Millis | 27.82ms | 23.59ms | +4.24ms (+18.0%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.31ms | 6.67ms | -0.36ms (-5.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.64ms | +0.05ms (+8.2%) | 🟠 |
| Worst Frame Build Time Millis | 1.83ms | 1.61ms | +0.22ms (+13.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.71ms | 3.90ms | -0.19ms (-4.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.87ms | 3.06ms | -0.19ms (-6.1%) | 🟢 |
| Worst Frame Build Time Millis | 9.64ms | 10.28ms | -0.64ms (-6.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.18ms | 4.32ms | -0.14ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.91ms | -0.20ms (-22.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.06ms | 5.11ms | -2.05ms (-40.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.31ms | 4.82ms | -0.51ms (-10.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.75 | +0 (+33.3%) | 🔴 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.46ms | 0.93ms | -0.48ms (-51.1%) | 🟢 |
| Worst Frame Build Time Millis | 2.18ms | 3.56ms | -1.38ms (-38.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.87ms | 5.66ms | -1.78ms (-31.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.15ms | 2.17ms | -0.02ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 4.58ms | 5.30ms | -0.72ms (-13.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.48ms | 5.73ms | -0.25ms (-4.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.35ms | 7.35ms | -0.00ms (-0.0%) | 🟡 |
| Worst Frame Build Time Millis | 25.39ms | 28.52ms | -3.13ms (-11.0%) | 🟢 |
| Missed Frame Build Budget Count | 6.0 | 6.25 | -0 (-4.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.05ms | 9.39ms | -0.34ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.80ms | 13.89ms | -0.09ms (-0.7%) | 🟡 |
| Worst Frame Build Time Millis | 40.76ms | 38.69ms | +2.07ms (+5.3%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.82ms | 9.39ms | +0.44ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.39ms | 1.57ms | -0.18ms (-11.7%) | 🟢 |
| Worst Frame Build Time Millis | 8.53ms | 11.21ms | -2.68ms (-23.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.48ms | 8.85ms | -0.37ms (-4.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 6.25 | 9.75 | -4 (-35.9%) | 🟢 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.07ms | 1.34ms | -0.28ms (-20.7%) | 🟢 |
| Worst Frame Build Time Millis | 4.45ms | 6.23ms | -1.78ms (-28.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.42ms | 6.60ms | +0.82ms (+12.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.61ms | 6.03ms | -0.42ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 24.50ms | 27.20ms | -2.70ms (-9.9%) | 🟢 |
| Missed Frame Build Budget Count | 3.75 | 4.5 | -1 (-16.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.45ms | 6.83ms | -0.38ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.82ms | 23.64ms | +0.18ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 42.28ms | 51.14ms | -8.86ms (-17.3%) | 🟢 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.16ms | 7.70ms | -0.54ms (-7.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.5 | -0 (-3.4%) | 🟡 |
| Old Gen Gc Count | 7.5 | 8.5 | -1 (-11.8%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.09ms | 1.31ms | -0.22ms (-16.6%) | 🟢 |
| Worst Frame Build Time Millis | 14.73ms | 21.54ms | -6.81ms (-31.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.35ms | 6.87ms | -0.52ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| New Gen Gc Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.36ms | 1.28ms | +0.07ms (+5.8%) | 🟠 |
| Worst Frame Build Time Millis | 7.58ms | 6.96ms | +0.62ms (+8.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.65ms | 6.90ms | -0.25ms (-3.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.75ms | 8.50ms | -0.75ms (-8.8%) | 🟢 |
| Worst Frame Build Time Millis | 28.86ms | 26.93ms | +1.93ms (+7.2%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 2.75 | +0 (+9.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.05ms | 10.35ms | -1.31ms (-12.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 1.51ms | -0.26ms (-17.3%) | 🟢 |
| Worst Frame Build Time Millis | 4.91ms | 7.14ms | -2.23ms (-31.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.42ms | 11.30ms | +0.12ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 24.25 | 18.5 | +6 (+31.1%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.90ms | 1.40ms | -0.51ms (-36.2%) | 🟢 |
| Worst Frame Build Time Millis | 5.52ms | 6.07ms | -0.56ms (-9.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.41ms | 11.83ms | -0.43ms (-3.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.5 | 2.75 | -0 (-9.1%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.21ms | 3.79ms | -0.58ms (-15.3%) | 🟢 |
| Worst Frame Build Time Millis | 7.92ms | 7.28ms | +0.64ms (+8.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.34ms | 10.30ms | +0.05ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>
