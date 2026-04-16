## Summary

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 10.3%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 14.6%

**Performance Improvements:**
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 22.0%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 12.5%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 18.2%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 17.9%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 17.7%
- 🟢 **one_event_per_day-month-navigation**: Frame build time improved by 11.0%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 14.6%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 25.6%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 27.5%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.68ms | 2.89ms | -0.20ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 6.62ms | 6.88ms | -0.26ms (-3.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.12ms | 4.49ms | -0.37ms (-8.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.04ms | 5.67ms | -0.62ms (-11.0%) | 🟢 |
| Worst Frame Build Time Millis | 17.44ms | 18.23ms | -0.78ms (-4.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.71ms | 5.81ms | -0.10ms (-1.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.85ms | -0.15ms (-17.7%) | 🟢 |
| Worst Frame Build Time Millis | 2.94ms | 5.25ms | -2.31ms (-44.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.12ms | 5.40ms | -0.28ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.70ms | -0.19ms (-27.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.44ms | 3.31ms | -0.87ms (-26.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.70ms | 5.59ms | -0.89ms (-15.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.02ms | 12.12ms | -3.10ms (-25.6%) | 🟢 |
| Worst Frame Build Time Millis | 25.06ms | 34.39ms | -9.33ms (-27.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.36ms | 5.81ms | -0.45ms (-7.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.49ms | 8.10ms | -0.61ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 14.71ms | 14.54ms | +0.17ms (+1.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.69ms | 6.78ms | -0.10ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.11ms | 2.09ms | +0.02ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 28.18ms | 23.37ms | +4.82ms (+20.6%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.36ms | 6.32ms | +0.05ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.68ms | +0.01ms (+1.1%) | 🟠 |
| Worst Frame Build Time Millis | 1.85ms | 1.74ms | +0.11ms (+6.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.75ms | 3.83ms | -0.08ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.91ms | 2.98ms | -0.07ms (-2.3%) | 🟡 |
| Worst Frame Build Time Millis | 10.58ms | 10.14ms | +0.44ms (+4.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.21ms | 4.21ms | +0.00ms (+0.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.78ms | -0.04ms (-5.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.86ms | 3.08ms | +0.78ms (+25.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.42ms | 4.44ms | -0.02ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.51ms | -0.04ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.19ms | 2.26ms | -0.07ms (-3.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.59ms | 4.12ms | +0.46ms (+11.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.12ms | 2.29ms | -0.16ms (-7.1%) | 🟢 |
| Worst Frame Build Time Millis | 4.64ms | 5.24ms | -0.60ms (-11.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.61ms | 5.65ms | -0.03ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.05ms | 7.53ms | -0.49ms (-6.5%) | 🟢 |
| Worst Frame Build Time Millis | 23.87ms | 27.75ms | -3.88ms (-14.0%) | 🟢 |
| Missed Frame Build Budget Count | 5.75 | 6.75 | -1 (-14.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.84ms | 9.48ms | -0.64ms (-6.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 10.0 | -2 (-15.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.39ms | 14.81ms | +0.57ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 54.85ms | 45.22ms | +9.63ms (+21.3%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.04ms | 8.99ms | +0.05ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.36ms | 1.65ms | -0.30ms (-17.9%) | 🟢 |
| Worst Frame Build Time Millis | 9.63ms | 9.54ms | +0.09ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.27ms | 9.08ms | -0.81ms (-8.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 8.75 | -5 (-60.0%) | 🟢 |
| New Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.06ms | 0.96ms | +0.10ms (+10.3%) | 🔴 |
| Worst Frame Build Time Millis | 7.61ms | 4.43ms | +3.18ms (+71.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.06ms | 6.59ms | -0.53ms (-8.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.28ms | 6.04ms | -0.75ms (-12.5%) | 🟢 |
| Worst Frame Build Time Millis | 20.65ms | 23.96ms | -3.32ms (-13.8%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 4.75 | -2 (-36.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.34ms | 6.91ms | -0.57ms (-8.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 6.0 | -2 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 26.05ms | 22.73ms | +3.32ms (+14.6%) | 🔴 |
| Worst Frame Build Time Millis | 44.99ms | 44.74ms | +0.25ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.84ms | 7.90ms | -0.06ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 9.5 | -2 (-21.1%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.41ms | -0.21ms (-14.6%) | 🟢 |
| Worst Frame Build Time Millis | 22.50ms | 20.80ms | +1.70ms (+8.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 1.0 | -0 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.39ms | 7.51ms | -1.11ms (-14.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 4.25 | -4 (-82.4%) | 🟢 |
| New Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 5.0 | -2 (-40.0%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.36ms | 1.43ms | -0.07ms (-4.9%) | 🟡 |
| Worst Frame Build Time Millis | 7.42ms | 7.48ms | -0.06ms (-0.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.73ms | 6.82ms | -0.09ms (-1.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.98ms | 8.65ms | -0.67ms (-7.7%) | 🟢 |
| Worst Frame Build Time Millis | 28.84ms | 30.07ms | -1.23ms (-4.1%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.47ms | 10.09ms | -0.62ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.39ms | -0.02ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 7.84ms | 5.46ms | +2.38ms (+43.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.47ms | 10.65ms | +0.82ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 20.0 | 16.0 | +4 (+25.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.83ms | 1.01ms | -0.18ms (-18.2%) | 🟢 |
| Worst Frame Build Time Millis | 3.69ms | 4.01ms | -0.32ms (-8.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.86ms | 10.88ms | -0.03ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 3.25 | 1.75 | +2 (+85.7%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.00ms | 3.85ms | -0.85ms (-22.0%) | 🟢 |
| Worst Frame Build Time Millis | 5.90ms | 8.73ms | -2.83ms (-32.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.19ms | 11.68ms | -2.49ms (-21.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>
