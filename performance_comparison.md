## Summary

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 10.3%

**Performance Improvements:**
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 14.9%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 14.3%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 19.7%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 17.5%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 17.9%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 16.4%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 13.2%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.80ms | 3.27ms | -0.47ms (-14.3%) | 🟢 |
| Worst Frame Build Time Millis | 6.93ms | 8.27ms | -1.34ms (-16.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.25ms | 4.41ms | -0.15ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.06ms | 5.14ms | -0.08ms (-1.6%) | 🟡 |
| Worst Frame Build Time Millis | 16.52ms | 18.67ms | -2.15ms (-11.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.67ms | 6.00ms | -0.33ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.77ms | -0.07ms (-8.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.67ms | 3.04ms | -0.37ms (-12.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.98ms | 5.32ms | -0.34ms (-6.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.80ms | -0.12ms (-14.9%) | 🟢 |
| Worst Frame Build Time Millis | 2.56ms | 3.00ms | -0.44ms (-14.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.17ms | 5.73ms | +0.44ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.53ms | 11.86ms | -2.34ms (-19.7%) | 🟢 |
| Worst Frame Build Time Millis | 26.84ms | 33.59ms | -6.76ms (-20.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.66ms | 5.42ms | -0.76ms (-14.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.64ms | 7.85ms | -0.22ms (-2.7%) | 🟡 |
| Worst Frame Build Time Millis | 15.74ms | 15.21ms | +0.53ms (+3.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.63ms | 6.93ms | -0.30ms (-4.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.10ms | 2.04ms | +0.07ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 24.98ms | 23.90ms | +1.08ms (+4.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.40ms | 6.80ms | -0.40ms (-5.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| New Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |
| Old Gen Gc Count | 3.5 | 4.5 | -1 (-22.2%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.66ms | 0.72ms | -0.06ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 1.74ms | 1.88ms | -0.14ms (-7.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.63ms | 4.14ms | -0.52ms (-12.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.77ms | 2.95ms | -0.17ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 9.23ms | 9.95ms | -0.72ms (-7.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.10ms | 4.32ms | -0.22ms (-5.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.80ms | -0.07ms (-8.7%) | 🟢 |
| Worst Frame Build Time Millis | 4.29ms | 4.37ms | -0.08ms (-1.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.33ms | 4.68ms | -0.35ms (-7.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.0 | -0 (-25.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.61ms | +0.00ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 2.44ms | 2.15ms | +0.29ms (+13.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.22ms | 4.38ms | -0.17ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.23ms | 2.17ms | +0.06ms (+2.9%) | 🟠 |
| Worst Frame Build Time Millis | 5.18ms | 5.16ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.59ms | 5.48ms | +0.11ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.70ms | 7.05ms | -0.34ms (-4.9%) | 🟡 |
| Worst Frame Build Time Millis | 25.29ms | 26.05ms | -0.76ms (-2.9%) | 🟡 |
| Missed Frame Build Budget Count | 4.5 | 5.75 | -1 (-21.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.13ms | 9.35ms | -0.22ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.04ms | 14.87ms | -0.83ms (-5.6%) | 🟢 |
| Worst Frame Build Time Millis | 41.28ms | 43.63ms | -2.35ms (-5.4%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.44ms | 9.10ms | +0.35ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.57ms | -0.26ms (-16.4%) | 🟢 |
| Worst Frame Build Time Millis | 8.25ms | 9.38ms | -1.13ms (-12.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.99ms | 8.95ms | -0.97ms (-10.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 5.75 | 6.25 | -0 (-8.0%) | 🟢 |
| New Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.27ms | +0.13ms (+10.3%) | 🔴 |
| Worst Frame Build Time Millis | 8.39ms | 7.57ms | +0.82ms (+10.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.74ms | 6.77ms | -0.02ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.5 | -1 (-83.3%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.0 | +2 (+150.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.57ms | 5.90ms | -0.33ms (-5.6%) | 🟢 |
| Worst Frame Build Time Millis | 25.57ms | 27.75ms | -2.18ms (-7.9%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.56ms | 6.95ms | -0.39ms (-5.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.65ms | 23.84ms | -1.19ms (-5.0%) | 🟡 |
| Worst Frame Build Time Millis | 44.12ms | 44.67ms | -0.55ms (-1.2%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.28ms | 7.96ms | -0.68ms (-8.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.97ms | 1.18ms | -0.21ms (-17.9%) | 🟢 |
| Worst Frame Build Time Millis | 12.83ms | 18.29ms | -5.46ms (-29.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.18ms | 6.83ms | -0.66ms (-9.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.25 | -0 (-4.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.33ms | -0.12ms (-9.2%) | 🟢 |
| Worst Frame Build Time Millis | 6.38ms | 7.49ms | -1.11ms (-14.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.62ms | 7.05ms | -0.43ms (-6.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.70ms | 8.20ms | -0.51ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 29.00ms | 30.84ms | -1.84ms (-6.0%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.26ms | 9.87ms | -0.61ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.35ms | -0.07ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 5.56ms | 5.86ms | -0.30ms (-5.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.59ms | 11.41ms | -0.82ms (-7.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 15.5 | 23.75 | -8 (-34.7%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.30ms | 1.50ms | -0.20ms (-13.2%) | 🟢 |
| Worst Frame Build Time Millis | 4.89ms | 5.50ms | -0.61ms (-11.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.99ms | 14.76ms | -1.77ms (-12.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.5 | 6.25 | -2 (-28.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.56ms | 4.32ms | -0.75ms (-17.5%) | 🟢 |
| Worst Frame Build Time Millis | 7.85ms | 7.15ms | +0.70ms (+9.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.45ms | 11.03ms | -0.58ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
