## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 31.1%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 25.5%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 13.4%

**Performance Improvements:**
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 10.4%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 13.4%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 12.7%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 14.8%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 17.9%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 15.8%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 32.6%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 10.8%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.68ms | 2.79ms | -0.10ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 6.33ms | 6.76ms | -0.43ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.30ms | 4.57ms | -0.27ms (-6.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.08ms | 5.31ms | -0.23ms (-4.4%) | 🟡 |
| Worst Frame Build Time Millis | 15.82ms | 18.03ms | -2.22ms (-12.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.84ms | 5.56ms | +0.28ms (+5.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.81ms | -0.10ms (-12.7%) | 🟢 |
| Worst Frame Build Time Millis | 2.76ms | 3.68ms | -0.92ms (-25.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.15ms | 5.54ms | -0.38ms (-7.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.0 | -1 (-37.5%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.78ms | 0.62ms | +0.16ms (+25.5%) | 🔴 |
| Worst Frame Build Time Millis | 2.33ms | 2.08ms | +0.25ms (+12.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.28ms | 4.29ms | +1.99ms (+46.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.80ms | 11.94ms | -2.13ms (-17.9%) | 🟢 |
| Worst Frame Build Time Millis | 27.38ms | 32.10ms | -4.73ms (-14.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.07ms | 5.26ms | -0.19ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.13ms | 8.37ms | -1.24ms (-14.8%) | 🟢 |
| Worst Frame Build Time Millis | 13.61ms | 17.38ms | -3.77ms (-21.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.46ms | 6.77ms | -0.31ms (-4.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.40ms | 2.50ms | -0.10ms (-4.2%) | 🟡 |
| Worst Frame Build Time Millis | 34.70ms | 27.46ms | +7.24ms (+26.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.75 | -1 (-42.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.39ms | 6.55ms | -0.16ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.73ms | -0.10ms (-13.4%) | 🟢 |
| Worst Frame Build Time Millis | 1.69ms | 1.95ms | -0.26ms (-13.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.76ms | 3.95ms | -0.19ms (-4.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.83ms | 3.06ms | -0.22ms (-7.3%) | 🟢 |
| Worst Frame Build Time Millis | 9.28ms | 9.91ms | -0.63ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.23ms | 4.32ms | -0.09ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 3.0 | 1.0 | +2 (+200.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.75ms | -0.06ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 3.12ms | 5.02ms | -1.90ms (-37.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.33ms | 4.36ms | -0.03ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.54ms | 0.60ms | -0.06ms (-10.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.03ms | 2.17ms | -0.15ms (-6.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.82ms | 4.04ms | -0.22ms (-5.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.93ms | 2.10ms | -0.17ms (-8.3%) | 🟢 |
| Worst Frame Build Time Millis | 3.74ms | 4.11ms | -0.37ms (-9.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.68ms | 5.98ms | -0.30ms (-5.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.87ms | 7.67ms | -0.80ms (-10.4%) | 🟢 |
| Worst Frame Build Time Millis | 29.32ms | 29.33ms | -0.01ms (-0.0%) | 🟡 |
| Missed Frame Build Budget Count | 4.5 | 6.5 | -2 (-30.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.24ms | 8.81ms | +0.43ms (+4.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.67ms | 14.46ms | +0.21ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 43.14ms | 43.15ms | -0.01ms (-0.0%) | 🟡 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.88ms | 9.20ms | -0.32ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.44ms | +0.02ms (+1.1%) | 🟠 |
| Worst Frame Build Time Millis | 8.74ms | 8.74ms | -0.00ms (-0.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.43ms | 8.13ms | +0.30ms (+3.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 6.0 | 4.0 | +2 (+50.0%) | 🔴 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.12ms | 1.32ms | -0.21ms (-15.8%) | 🟢 |
| Worst Frame Build Time Millis | 5.50ms | 6.58ms | -1.09ms (-16.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.10ms | 6.29ms | -0.19ms (-3.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.58ms | 5.86ms | -0.28ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 25.78ms | 29.52ms | -3.74ms (-12.7%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.63ms | 6.74ms | -0.10ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.0 | +0 (+3.6%) | 🟠 |
| Old Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.77ms | 25.02ms | -0.26ms (-1.0%) | 🟡 |
| Worst Frame Build Time Millis | 44.93ms | 46.83ms | -1.90ms (-4.0%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.48ms | 7.76ms | -0.29ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 9.5 | -2 (-15.8%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.21ms | +0.16ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 17.44ms | 17.25ms | +0.19ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 0.75 | +1 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.73ms | 6.57ms | +0.16ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| New Gen Gc Count | 6.5 | 8.0 | -2 (-18.8%) | 🟢 |
| Old Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.29ms | -0.08ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 6.41ms | 6.70ms | -0.30ms (-4.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.08ms | 6.82ms | +0.26ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.77ms | 8.25ms | -0.48ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 28.48ms | 27.94ms | +0.54ms (+1.9%) | 🟠 |
| Missed Frame Build Budget Count | 2.25 | 3.0 | -1 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.35ms | 9.59ms | -0.24ms (-2.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.30ms | -0.02ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 4.76ms | 6.44ms | -1.68ms (-26.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.30ms | 11.27ms | +0.03ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 19.75 | 24.75 | -5 (-20.2%) | 🟢 |
| New Gen Gc Count | 8.0 | 6.5 | +2 (+23.1%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 1.76ms | -0.57ms (-32.6%) | 🟢 |
| Worst Frame Build Time Millis | 5.15ms | 9.11ms | -3.97ms (-43.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.75ms | 13.54ms | -2.79ms (-20.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 4.5 | -2 (-55.6%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.87ms | 2.95ms | +0.92ms (+31.1%) | 🔴 |
| Worst Frame Build Time Millis | 7.94ms | 5.51ms | +2.43ms (+44.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.67ms | 9.35ms | +1.33ms (+14.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
