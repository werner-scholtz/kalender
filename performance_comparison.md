## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 15.1%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 20.7%
- 🔴 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 19.4%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 37.2%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 15.9%
- 🔴 **ten_events_per_day-schedule-navigation**: Frame build time increased by 24.0%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 13.4%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 10.4%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 8.0%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 8.1%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 10.3%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 5.5%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 7.0%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 9.0%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 12.8%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 7.4%

**Performance Improvements:**
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 20.9%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.67ms | 3.38ms | -0.70ms (-20.9%) | 🟢 |
| Worst Frame Build Time Millis | 6.56ms | 8.59ms | -2.03ms (-23.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.18ms | 4.99ms | -0.81ms (-16.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.02ms | 4.98ms | +0.04ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 15.69ms | 16.29ms | -0.60ms (-3.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.68ms | 5.91ms | -0.23ms (-3.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.66ms | +0.07ms (+10.4%) | 🔴 |
| Worst Frame Build Time Millis | 4.10ms | 2.83ms | +1.27ms (+44.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.36ms | 5.84ms | -0.49ms (-8.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.25 | 3.0 | -1 (-25.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.46ms | +0.09ms (+20.7%) | 🔴 |
| Worst Frame Build Time Millis | 2.21ms | 1.95ms | +0.26ms (+13.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.75ms | 6.11ms | -0.36ms (-5.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.65ms | 10.18ms | -0.53ms (-5.2%) | 🟢 |
| Worst Frame Build Time Millis | 26.92ms | 28.78ms | -1.86ms (-6.5%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.74ms | 5.88ms | -1.14ms (-19.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.70ms | 7.07ms | +0.64ms (+9.0%) | 🟠 |
| Worst Frame Build Time Millis | 14.59ms | 13.29ms | +1.30ms (+9.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.50ms | 6.75ms | -0.25ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.02ms | 2.04ms | -0.02ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 27.45ms | 25.76ms | +1.69ms (+6.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.32ms | 6.52ms | -0.21ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.25 | -1 (-60.0%) | 🟢 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.67ms | +0.05ms (+7.4%) | 🟠 |
| Worst Frame Build Time Millis | 1.88ms | 1.69ms | +0.19ms (+11.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.84ms | 4.00ms | -0.16ms (-3.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.89ms | 2.55ms | +0.34ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 10.37ms | 9.00ms | +1.37ms (+15.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.23ms | 4.40ms | -0.17ms (-3.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.72ms | +0.05ms (+7.0%) | 🟠 |
| Worst Frame Build Time Millis | 3.90ms | 4.85ms | -0.95ms (-19.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.55ms | 4.86ms | -0.32ms (-6.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.46ms | 0.50ms | -0.05ms (-9.1%) | 🟢 |
| Worst Frame Build Time Millis | 2.30ms | 2.78ms | -0.48ms (-17.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.94ms | 4.63ms | -0.69ms (-14.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.06ms | 1.79ms | +0.27ms (+15.1%) | 🔴 |
| Worst Frame Build Time Millis | 5.35ms | 3.78ms | +1.57ms (+41.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.64ms | 5.25ms | +0.38ms (+7.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.17ms | 7.12ms | +0.05ms (+0.7%) | 🟠 |
| Worst Frame Build Time Millis | 25.65ms | 25.83ms | -0.19ms (-0.7%) | 🟡 |
| Missed Frame Build Budget Count | 6.25 | 6.0 | +0 (+4.2%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.21ms | 12.27ms | -3.06ms (-24.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.76ms | 13.38ms | +1.38ms (+10.3%) | 🔴 |
| Worst Frame Build Time Millis | 43.13ms | 40.22ms | +2.91ms (+7.2%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.25 | +1 (+23.1%) | 🔴 |
| Average Frame Rasterizer Time Millis | 8.67ms | 9.47ms | -0.80ms (-8.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.35ms | 1.25ms | +0.10ms (+8.0%) | 🟠 |
| Worst Frame Build Time Millis | 8.25ms | 7.77ms | +0.48ms (+6.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.26ms | 9.13ms | -0.87ms (-9.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 11.0 | -8 (-68.2%) | 🟢 |
| New Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.71ms | +0.11ms (+15.9%) | 🔴 |
| Worst Frame Build Time Millis | 4.61ms | 3.57ms | +1.04ms (+29.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.12ms | 6.46ms | -0.34ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.58ms | 5.65ms | -0.07ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 22.95ms | 26.76ms | -3.81ms (-14.3%) | 🟢 |
| Missed Frame Build Budget Count | 3.75 | 3.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.42ms | 7.01ms | -0.59ms (-8.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 6.0 | -2 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 27.11ms | 21.86ms | +5.26ms (+24.0%) | 🔴 |
| Worst Frame Build Time Millis | 46.41ms | 43.33ms | +3.07ms (+7.1%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 8.25 | +1 (+9.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 7.57ms | 7.75ms | -0.18ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 9.0 | -2 (-16.7%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.26ms | 1.12ms | +0.14ms (+12.8%) | 🔴 |
| Worst Frame Build Time Millis | 18.25ms | 14.84ms | +3.41ms (+23.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.92ms | 6.43ms | +0.49ms (+7.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.5 | 1.25 | +2 (+180.0%) | 🔴 |
| New Gen Gc Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.44ms | 1.21ms | +0.23ms (+19.4%) | 🔴 |
| Worst Frame Build Time Millis | 7.93ms | 7.18ms | +0.75ms (+10.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.75ms | 7.04ms | -0.29ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.52ms | 7.88ms | +0.63ms (+8.1%) | 🟠 |
| Worst Frame Build Time Millis | 29.53ms | 29.79ms | -0.25ms (-0.9%) | 🟡 |
| Missed Frame Build Budget Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.82ms | 10.05ms | -0.23ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 4.5 | +2 (+33.3%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.30ms | 1.23ms | +0.07ms (+5.5%) | 🟠 |
| Worst Frame Build Time Millis | 5.68ms | 5.42ms | +0.26ms (+4.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.07ms | 10.79ms | +0.28ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 16.75 | 15.0 | +2 (+11.7%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 0.91ms | +0.34ms (+37.2%) | 🔴 |
| Worst Frame Build Time Millis | 5.72ms | 4.59ms | +1.14ms (+24.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.21ms | 12.33ms | -0.11ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 3.25 | 4.25 | -1 (-23.5%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.49ms | 3.81ms | -0.32ms (-8.5%) | 🟢 |
| Worst Frame Build Time Millis | 7.58ms | 8.25ms | -0.67ms (-8.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.20ms | 11.17ms | -0.97ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
