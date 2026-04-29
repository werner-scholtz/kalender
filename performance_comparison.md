## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 16.8%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 7.3%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 7.5%

**Performance Improvements:**
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 11.9%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 10.4%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 10.4%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 15.4%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.73ms | 3.10ms | -0.37ms (-11.9%) | 🟢 |
| Worst Frame Build Time Millis | 6.93ms | 7.87ms | -0.94ms (-11.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.02ms | 4.50ms | -0.49ms (-10.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.03ms | 5.13ms | -0.11ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 16.40ms | 19.22ms | -2.83ms (-14.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.55ms | 5.99ms | -0.44ms (-7.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.77ms | -0.05ms (-6.6%) | 🟢 |
| Worst Frame Build Time Millis | 3.15ms | 3.40ms | -0.26ms (-7.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.25ms | 5.97ms | -0.72ms (-12.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 2.25 | -0 (-22.2%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.49ms | -0.01ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 2.23ms | 2.20ms | +0.02ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.76ms | 4.73ms | +0.03ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.93ms | 11.73ms | -1.80ms (-15.4%) | 🟢 |
| Worst Frame Build Time Millis | 27.17ms | 33.00ms | -5.83ms (-17.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.96ms | 6.07ms | -1.11ms (-18.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.39ms | 7.73ms | -0.34ms (-4.4%) | 🟡 |
| Worst Frame Build Time Millis | 14.58ms | 15.04ms | -0.46ms (-3.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.69ms | 6.85ms | -0.16ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.30ms | 2.14ms | +0.16ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 26.68ms | 26.63ms | +0.04ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.65ms | 6.86ms | -0.20ms (-3.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 10.0 | -2 (-15.0%) | 🟢 |
| Old Gen Gc Count | 4.5 | 6.0 | -2 (-25.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.71ms | -0.02ms (-3.1%) | 🟡 |
| Worst Frame Build Time Millis | 1.82ms | 1.86ms | -0.04ms (-1.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.66ms | 3.82ms | -0.16ms (-4.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.85ms | 2.93ms | -0.08ms (-2.7%) | 🟡 |
| Worst Frame Build Time Millis | 10.17ms | 10.11ms | +0.05ms (+0.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.08ms | 4.22ms | -0.14ms (-3.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.80ms | -0.08ms (-9.5%) | 🟢 |
| Worst Frame Build Time Millis | 5.02ms | 4.01ms | +1.01ms (+25.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.27ms | 4.85ms | -0.58ms (-11.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 2.25 | -2 (-66.7%) | 🟢 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.47ms | +0.08ms (+16.8%) | 🔴 |
| Worst Frame Build Time Millis | 2.91ms | 2.17ms | +0.74ms (+34.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.45ms | 3.95ms | +0.51ms (+12.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.86ms | 2.03ms | -0.17ms (-8.2%) | 🟢 |
| Worst Frame Build Time Millis | 3.63ms | 5.20ms | -1.57ms (-30.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.18ms | 5.30ms | -0.12ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.44ms | 7.62ms | -0.18ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 29.12ms | 25.93ms | +3.18ms (+12.3%) | 🔴 |
| Missed Frame Build Budget Count | 5.25 | 6.0 | -1 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.09ms | 9.18ms | -0.09ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.88ms | 15.13ms | -1.26ms (-8.3%) | 🟢 |
| Worst Frame Build Time Millis | 39.13ms | 47.30ms | -8.17ms (-17.3%) | 🟢 |
| Missed Frame Build Budget Count | 3.75 | 4.0 | -0 (-6.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.61ms | 9.47ms | +0.15ms (+1.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.49ms | 1.39ms | +0.10ms (+7.5%) | 🟠 |
| Worst Frame Build Time Millis | 9.70ms | 8.70ms | +1.00ms (+11.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.99ms | 8.55ms | +0.43ms (+5.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 5.5 | 6.5 | -1 (-15.4%) | 🟢 |
| New Gen Gc Count | 8.0 | 6.0 | +2 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.75ms | -0.03ms (-3.9%) | 🟡 |
| Worst Frame Build Time Millis | 3.42ms | 3.40ms | +0.03ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.48ms | 6.02ms | +0.46ms (+7.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.54ms | 6.01ms | -0.47ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 23.13ms | 27.82ms | -4.70ms (-16.9%) | 🟢 |
| Missed Frame Build Budget Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.49ms | 6.82ms | -0.32ms (-4.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.5 | -0 (-3.4%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.20ms | 25.01ms | -0.80ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 44.65ms | 42.49ms | +2.16ms (+5.1%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.09ms | 7.77ms | -0.68ms (-8.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.07ms | 1.15ms | -0.08ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 17.11ms | 15.31ms | +1.80ms (+11.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.55ms | 6.69ms | -0.14ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.75 | 1.5 | +0 (+16.7%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.39ms | +0.01ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 7.31ms | 6.95ms | +0.36ms (+5.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.15ms | 6.84ms | -0.70ms (-10.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.26ms | 8.34ms | -0.09ms (-1.0%) | 🟡 |
| Worst Frame Build Time Millis | 28.31ms | 30.44ms | -2.13ms (-7.0%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.49ms | 9.41ms | +0.09ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.49ms | -0.16ms (-10.4%) | 🟢 |
| Worst Frame Build Time Millis | 7.38ms | 5.34ms | +2.04ms (+38.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.17ms | 12.17ms | -1.00ms (-8.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 17.0 | 25.25 | -8 (-32.7%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 1.09ms | -0.06ms (-5.7%) | 🟢 |
| Worst Frame Build Time Millis | 5.67ms | 5.25ms | +0.42ms (+8.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.32ms | 12.94ms | -0.62ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.75 | 4.75 | -2 (-42.1%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.23ms | 3.61ms | -0.38ms (-10.4%) | 🟢 |
| Worst Frame Build Time Millis | 6.09ms | 6.96ms | -0.87ms (-12.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.06ms | 10.31ms | +0.75ms (+7.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

</details>
