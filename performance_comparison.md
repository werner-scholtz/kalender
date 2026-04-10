## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 22.6%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 24.0%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 22.1%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 21.4%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 5.3%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 5.2%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 8.2%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 11.6%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 8.6%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 6.1%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 11.1%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 11.5%

**Performance Improvements:**
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 22.4%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 12.1%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.89ms | 3.29ms | -0.40ms (-12.1%) | 🟢 |
| Worst Frame Build Time Millis | 6.86ms | 8.26ms | -1.40ms (-17.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.77ms | 4.72ms | +0.05ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.27ms | 5.60ms | -0.32ms (-5.8%) | 🟢 |
| Worst Frame Build Time Millis | 15.49ms | 17.79ms | -2.29ms (-12.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.16ms | 5.83ms | +0.33ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.84ms | 0.76ms | +0.09ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 5.15ms | 4.04ms | +1.11ms (+27.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.66ms | 5.47ms | +0.19ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.52ms | +0.12ms (+24.0%) | 🔴 |
| Worst Frame Build Time Millis | 3.57ms | 2.16ms | +1.40ms (+64.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.16ms | 4.91ms | +1.25ms (+25.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.77ms | 11.87ms | -1.10ms (-9.3%) | 🟢 |
| Worst Frame Build Time Millis | 30.34ms | 33.66ms | -3.32ms (-9.9%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.39ms | 5.82ms | -0.43ms (-7.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.33ms | 8.51ms | -0.18ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 16.09ms | 18.00ms | -1.90ms (-10.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.12ms | 6.91ms | +0.21ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.68ms | 2.21ms | +0.47ms (+21.4%) | 🔴 |
| Worst Frame Build Time Millis | 33.04ms | 23.86ms | +9.18ms (+38.5%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 1.75 | -0 (-28.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.73ms | 6.71ms | +0.02ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 3.0 | 5.5 | -2 (-45.5%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.72ms | -0.01ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 1.81ms | 1.85ms | -0.04ms (-2.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.84ms | 3.83ms | +0.02ms (+0.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.92ms | 2.95ms | -0.03ms (-1.1%) | 🟡 |
| Worst Frame Build Time Millis | 10.06ms | 11.15ms | -1.09ms (-9.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.23ms | 4.23ms | -0.00ms (-0.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.85ms | -0.06ms (-6.8%) | 🟢 |
| Worst Frame Build Time Millis | 3.51ms | 4.16ms | -0.65ms (-15.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.47ms | 4.52ms | -0.05ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.48ms | +0.03ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 2.14ms | 2.50ms | -0.36ms (-14.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.21ms | 3.93ms | +0.28ms (+7.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.13ms | 2.07ms | +0.06ms (+2.9%) | 🟠 |
| Worst Frame Build Time Millis | 4.13ms | 4.89ms | -0.76ms (-15.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.79ms | 5.93ms | -0.14ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.58ms | 7.14ms | +0.44ms (+6.1%) | 🟠 |
| Worst Frame Build Time Millis | 26.22ms | 23.88ms | +2.34ms (+9.8%) | 🟠 |
| Missed Frame Build Budget Count | 6.75 | 6.5 | +0 (+3.8%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.40ms | 8.91ms | +0.49ms (+5.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 6.0 | 4.5 | +2 (+33.3%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.79ms | 16.39ms | -1.60ms (-9.8%) | 🟢 |
| Worst Frame Build Time Millis | 43.78ms | 59.01ms | -15.23ms (-25.8%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.58ms | 9.17ms | +0.41ms (+4.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 10.0 | -2 (-15.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.63ms | 1.46ms | +0.16ms (+11.1%) | 🔴 |
| Worst Frame Build Time Millis | 12.13ms | 9.30ms | +2.83ms (+30.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.03ms | 8.53ms | +0.49ms (+5.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 8.75 | 4.0 | +5 (+118.8%) | 🔴 |
| New Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.01ms | 0.91ms | +0.11ms (+11.6%) | 🔴 |
| Worst Frame Build Time Millis | 4.75ms | 5.14ms | -0.39ms (-7.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.07ms | 6.07ms | +1.00ms (+16.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.75 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.97ms | 5.52ms | +0.45ms (+8.2%) | 🟠 |
| Worst Frame Build Time Millis | 30.08ms | 22.02ms | +8.07ms (+36.6%) | 🔴 |
| Missed Frame Build Budget Count | 4.5 | 3.25 | +1 (+38.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.27ms | 6.69ms | +0.58ms (+8.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.65ms | 22.71ms | +1.94ms (+8.6%) | 🟠 |
| Worst Frame Build Time Millis | 52.32ms | 49.77ms | +2.55ms (+5.1%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.53ms | 7.31ms | +0.22ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 15.5 | -1 (-6.5%) | 🟢 |
| Old Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.04ms | +0.24ms (+22.6%) | 🔴 |
| Worst Frame Build Time Millis | 15.74ms | 13.58ms | +2.16ms (+15.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.67ms | 6.67ms | -0.00ms (-0.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.5 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.50ms | 1.43ms | +0.07ms (+5.2%) | 🟠 |
| Worst Frame Build Time Millis | 9.45ms | 7.13ms | +2.32ms (+32.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.27ms | 6.96ms | -0.69ms (-9.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.72ms | 8.59ms | +0.13ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 29.62ms | 30.74ms | -1.12ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 3.25 | 4.0 | -1 (-18.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 10.44ms | 9.77ms | +0.67ms (+6.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.75 | +1 (+100.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.43ms | 1.38ms | +0.05ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 5.97ms | 6.91ms | -0.94ms (-13.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.72ms | 11.77ms | -0.05ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 25.5 | 27.75 | -2 (-8.1%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.26ms | 1.03ms | +0.23ms (+22.1%) | 🔴 |
| Worst Frame Build Time Millis | 6.77ms | 5.73ms | +1.04ms (+18.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.50ms | 11.58ms | -0.08ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 3.5 | 3.25 | +0 (+7.7%) | 🟠 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.44ms | 4.43ms | -0.99ms (-22.4%) | 🟢 |
| Worst Frame Build Time Millis | 7.52ms | 9.39ms | -1.86ms (-19.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.75ms | 10.50ms | -0.75ms (-7.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

</details>
