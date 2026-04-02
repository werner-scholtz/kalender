## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 62.7%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 21.5%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 44.7%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 11.4%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 12.8%

**Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 17.6%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 18.9%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 15.2%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 14.4%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.79ms | 2.47ms | +0.32ms (+12.8%) | 🔴 |
| Worst Frame Build Time Millis | 6.88ms | 5.87ms | +1.01ms (+17.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.94ms | 4.60ms | -0.66ms (-14.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.83ms | 5.21ms | -0.38ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 15.98ms | 15.94ms | +0.04ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.70ms | 5.66ms | +0.04ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.71ms | -0.00ms (-0.3%) | 🟡 |
| Worst Frame Build Time Millis | 3.10ms | 2.72ms | +0.39ms (+14.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.97ms | 4.84ms | +0.13ms (+2.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 2.0 | +2 (+100.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.55ms | +0.25ms (+44.7%) | 🔴 |
| Worst Frame Build Time Millis | 3.40ms | 1.99ms | +1.41ms (+70.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.66ms | 4.19ms | +1.48ms (+35.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.88ms | 9.76ms | +1.12ms (+11.4%) | 🔴 |
| Worst Frame Build Time Millis | 30.73ms | 27.51ms | +3.22ms (+11.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.13ms | 4.71ms | +0.42ms (+8.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.28ms | 7.70ms | -0.42ms (-5.4%) | 🟢 |
| Worst Frame Build Time Millis | 14.97ms | 17.05ms | -2.09ms (-12.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.53ms | 6.58ms | -0.05ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.04ms | 2.52ms | -0.48ms (-18.9%) | 🟢 |
| Worst Frame Build Time Millis | 27.00ms | 30.47ms | -3.47ms (-11.4%) | 🟢 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.39ms | 7.04ms | -0.66ms (-9.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.65ms | -0.01ms (-1.4%) | 🟡 |
| Worst Frame Build Time Millis | 1.70ms | 1.69ms | +0.01ms (+0.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.59ms | 3.75ms | -0.15ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.69ms | 2.97ms | -0.28ms (-9.5%) | 🟢 |
| Worst Frame Build Time Millis | 9.13ms | 11.80ms | -2.67ms (-22.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.75ms | 4.26ms | +0.49ms (+11.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.76ms | -0.05ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.64ms | 3.70ms | -0.05ms (-1.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.24ms | 4.59ms | -0.36ms (-7.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.63ms | -0.09ms (-15.2%) | 🟢 |
| Worst Frame Build Time Millis | 1.96ms | 2.69ms | -0.73ms (-27.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.76ms | 4.13ms | -0.37ms (-8.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.94ms | 2.08ms | -0.14ms (-6.8%) | 🟢 |
| Worst Frame Build Time Millis | 3.67ms | 4.43ms | -0.76ms (-17.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.06ms | 5.63ms | -0.57ms (-10.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.60ms | 7.13ms | -0.53ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 24.24ms | 24.89ms | -0.65ms (-2.6%) | 🟡 |
| Missed Frame Build Budget Count | 5.0 | 6.25 | -1 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.92ms | 9.35ms | -0.44ms (-4.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.25ms | 14.28ms | -1.03ms (-7.2%) | 🟢 |
| Worst Frame Build Time Millis | 40.07ms | 40.48ms | -0.41ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.57ms | 8.97ms | +0.60ms (+6.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.48ms | 1.53ms | -0.06ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 10.05ms | 8.48ms | +1.57ms (+18.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.70ms | 9.09ms | -0.39ms (-4.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.5 | 5.0 | -2 (-50.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.91ms | 1.17ms | +0.74ms (+62.7%) | 🔴 |
| Worst Frame Build Time Millis | 7.18ms | 5.79ms | +1.39ms (+23.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.94ms | 6.25ms | +1.69ms (+27.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 3.5 | 1.5 | +2 (+133.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.34ms | 5.83ms | -0.49ms (-8.5%) | 🟢 |
| Worst Frame Build Time Millis | 25.95ms | 26.44ms | -0.49ms (-1.8%) | 🟡 |
| Missed Frame Build Budget Count | 2.5 | 4.25 | -2 (-41.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.62ms | 6.69ms | -0.07ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 15.0 | 14.0 | +1 (+7.1%) | 🟠 |
| Old Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.94ms | 23.53ms | -0.59ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 44.81ms | 44.15ms | +0.66ms (+1.5%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.62ms | 7.69ms | -0.07ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.26ms | 1.04ms | +0.22ms (+21.5%) | 🔴 |
| Worst Frame Build Time Millis | 18.77ms | 13.44ms | +5.32ms (+39.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.04ms | 6.84ms | -0.80ms (-11.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 2.75 | -2 (-81.8%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.17ms | 1.26ms | -0.09ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 6.02ms | 6.69ms | -0.66ms (-9.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.88ms | 6.66ms | -0.78ms (-11.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.64ms | 8.00ms | -0.36ms (-4.5%) | 🟡 |
| Worst Frame Build Time Millis | 27.05ms | 29.69ms | -2.63ms (-8.9%) | 🟢 |
| Missed Frame Build Budget Count | 2.75 | 3.0 | -0 (-8.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.39ms | 9.60ms | -0.21ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.34ms | -0.01ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 5.47ms | 6.20ms | -0.73ms (-11.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.24ms | 11.33ms | -0.09ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 14.5 | 21.75 | -7 (-33.3%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.62ms | -0.28ms (-17.6%) | 🟢 |
| Worst Frame Build Time Millis | 7.12ms | 6.62ms | +0.50ms (+7.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.50ms | 13.94ms | -1.44ms (-10.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 5.25 | -2 (-28.6%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.19ms | 3.73ms | -0.54ms (-14.4%) | 🟢 |
| Worst Frame Build Time Millis | 6.19ms | 7.27ms | -1.07ms (-14.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.68ms | 10.48ms | +0.20ms (+1.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>
