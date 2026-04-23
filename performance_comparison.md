## Summary

**Performance Improvements:**
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 10.7%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 23.9%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 20.2%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 37.5%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 36.5%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 17.4%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 17.3%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 18.5%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.10ms | 3.80ms | -0.70ms (-18.5%) | 🟢 |
| Worst Frame Build Time Millis | 7.87ms | 9.76ms | -1.89ms (-19.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.50ms | 4.65ms | -0.15ms (-3.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.13ms | 5.36ms | -0.22ms (-4.2%) | 🟡 |
| Worst Frame Build Time Millis | 19.22ms | 16.05ms | +3.17ms (+19.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.99ms | 6.22ms | -0.23ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.82ms | -0.05ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.40ms | 3.43ms | -0.03ms (-0.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.97ms | 5.67ms | +0.30ms (+5.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.25 | 1.25 | +1 (+80.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.79ms | -0.29ms (-37.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.20ms | 3.69ms | -1.49ms (-40.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.73ms | 5.68ms | -0.95ms (-16.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.73ms | 12.39ms | -0.66ms (-5.3%) | 🟢 |
| Worst Frame Build Time Millis | 33.00ms | 34.79ms | -1.79ms (-5.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.07ms | 6.14ms | -0.07ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.73ms | 8.37ms | -0.64ms (-7.6%) | 🟢 |
| Worst Frame Build Time Millis | 15.04ms | 14.85ms | +0.19ms (+1.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.85ms | 6.78ms | +0.06ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.14ms | 2.59ms | -0.45ms (-17.3%) | 🟢 |
| Worst Frame Build Time Millis | 26.63ms | 27.09ms | -0.46ms (-1.7%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.86ms | 6.95ms | -0.09ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.0 | 2.25 | -0 (-11.1%) | 🟢 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 4.0 | +2 (+50.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.73ms | -0.02ms (-3.1%) | 🟡 |
| Worst Frame Build Time Millis | 1.86ms | 1.85ms | +0.01ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.82ms | 4.47ms | -0.65ms (-14.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.93ms | 3.15ms | -0.22ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 10.11ms | 11.48ms | -1.37ms (-11.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.22ms | 4.31ms | -0.09ms (-2.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 1.00ms | -0.20ms (-20.2%) | 🟢 |
| Worst Frame Build Time Millis | 4.01ms | 6.34ms | -2.33ms (-36.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.85ms | 4.79ms | +0.05ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.25 | 0.5 | +2 (+350.0%) | 🔴 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.75ms | -0.27ms (-36.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.17ms | 4.27ms | -2.10ms (-49.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 5.99ms | -2.04ms (-34.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.25 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.03ms | 2.27ms | -0.24ms (-10.7%) | 🟢 |
| Worst Frame Build Time Millis | 5.20ms | 5.73ms | -0.53ms (-9.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.30ms | 5.73ms | -0.43ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.62ms | 7.88ms | -0.25ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 25.93ms | 28.49ms | -2.55ms (-9.0%) | 🟢 |
| Missed Frame Build Budget Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.18ms | 9.41ms | -0.22ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.13ms | 14.64ms | +0.49ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 47.30ms | 41.53ms | +5.77ms (+13.9%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.47ms | 9.63ms | -0.17ms (-1.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.39ms | 1.82ms | -0.44ms (-23.9%) | 🟢 |
| Worst Frame Build Time Millis | 8.70ms | 14.45ms | -5.75ms (-39.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.55ms | 9.48ms | -0.93ms (-9.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 6.5 | 10.75 | -4 (-39.5%) | 🟢 |
| New Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.5 | -2 (-60.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.91ms | -0.16ms (-17.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.40ms | 4.69ms | -1.30ms (-27.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.02ms | 6.96ms | -0.94ms (-13.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.01ms | 6.07ms | -0.06ms (-1.0%) | 🟡 |
| Worst Frame Build Time Millis | 27.82ms | 26.69ms | +1.14ms (+4.3%) | 🟠 |
| Missed Frame Build Budget Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.82ms | 6.97ms | -0.15ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.0 | +0 (+3.6%) | 🟠 |
| Old Gen Gc Count | 6.5 | 5.5 | +1 (+18.2%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.01ms | 24.10ms | +0.90ms (+3.7%) | 🟠 |
| Worst Frame Build Time Millis | 42.49ms | 42.59ms | -0.10ms (-0.2%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.77ms | 7.41ms | +0.35ms (+4.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 16.0 | -2 (-12.5%) | 🟢 |
| Old Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.15ms | 1.20ms | -0.05ms (-4.3%) | 🟡 |
| Worst Frame Build Time Millis | 15.31ms | 17.96ms | -2.66ms (-14.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.69ms | 6.56ms | +0.13ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 1.75 | -0 (-14.3%) | 🟢 |
| New Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.39ms | 1.46ms | -0.06ms (-4.5%) | 🟡 |
| Worst Frame Build Time Millis | 6.95ms | 8.41ms | -1.46ms (-17.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.84ms | 6.78ms | +0.06ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.34ms | 8.86ms | -0.52ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 30.44ms | 31.21ms | -0.77ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.41ms | 10.01ms | -0.60ms (-6.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.49ms | 1.43ms | +0.06ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 5.34ms | 7.85ms | -2.51ms (-32.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 12.17ms | 11.19ms | +0.98ms (+8.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 25.25 | 19.75 | +6 (+27.8%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.09ms | 1.14ms | -0.04ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 5.25ms | 6.45ms | -1.20ms (-18.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.94ms | 11.82ms | +1.12ms (+9.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.75 | 3.5 | +1 (+35.7%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.61ms | 3.56ms | +0.05ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 6.96ms | 5.79ms | +1.18ms (+20.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.31ms | 11.29ms | -0.98ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>
