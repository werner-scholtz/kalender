## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 22.8%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 31.1%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 40.4%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 25.7%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 7.6%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 14.6%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 10.6%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 13.5%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 5.6%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 10.5%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 9.5%

**Performance Improvements:**
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 16.3%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 18.0%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 16.8%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 28.2%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.83ms | 2.02ms | +0.82ms (+40.4%) | 🔴 |
| Worst Frame Build Time Millis | 7.23ms | 4.69ms | +2.54ms (+54.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.71ms | 3.32ms | +1.39ms (+41.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.90ms | 4.56ms | +0.34ms (+7.6%) | 🟠 |
| Worst Frame Build Time Millis | 17.42ms | 13.86ms | +3.56ms (+25.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.97ms | 4.45ms | +1.52ms (+34.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.66ms | -0.02ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 3.32ms | 2.80ms | +0.52ms (+18.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.51ms | 4.19ms | +1.32ms (+31.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.0 | 1.25 | +1 (+60.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.40ms | 0.55ms | -0.16ms (-28.2%) | 🟢 |
| Worst Frame Build Time Millis | 2.01ms | 2.33ms | -0.32ms (-13.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.74ms | 4.89ms | -0.15ms (-3.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.25ms | 8.16ms | +2.10ms (+25.7%) | 🔴 |
| Worst Frame Build Time Millis | 28.51ms | 22.66ms | +5.85ms (+25.8%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.19ms | 4.27ms | +1.92ms (+44.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.33ms | 6.63ms | +0.70ms (+10.5%) | 🔴 |
| Worst Frame Build Time Millis | 14.31ms | 12.21ms | +2.10ms (+17.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.97ms | 5.07ms | +1.91ms (+37.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.34ms | 2.24ms | +0.11ms (+4.8%) | 🟠 |
| Worst Frame Build Time Millis | 30.54ms | 22.48ms | +8.06ms (+35.8%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.70ms | 5.20ms | +1.50ms (+28.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.75 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 5.5 | 3.5 | +2 (+57.1%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.65ms | 0.63ms | +0.02ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 1.69ms | 1.61ms | +0.09ms (+5.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.88ms | 3.12ms | +0.75ms (+24.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.50ms | 2.57ms | -0.07ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 9.27ms | 10.05ms | -0.78ms (-7.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.20ms | 3.31ms | +0.89ms (+27.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.66ms | 0.70ms | -0.04ms (-5.7%) | 🟢 |
| Worst Frame Build Time Millis | 3.33ms | 3.45ms | -0.12ms (-3.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.62ms | 3.60ms | +1.02ms (+28.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.25 | +1 (+400.0%) | 🔴 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.41ms | 0.49ms | -0.08ms (-16.8%) | 🟢 |
| Worst Frame Build Time Millis | 1.96ms | 2.98ms | -1.02ms (-34.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.04ms | 3.36ms | +0.68ms (+20.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.87ms | 1.81ms | +0.05ms (+2.9%) | 🟠 |
| Worst Frame Build Time Millis | 4.43ms | 3.66ms | +0.77ms (+21.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.67ms | 4.57ms | +1.09ms (+23.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 3.5 | -2 (-57.1%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.67ms | 6.59ms | +0.08ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 23.18ms | 20.93ms | +2.25ms (+10.7%) | 🔴 |
| Missed Frame Build Budget Count | 5.25 | 4.25 | +1 (+23.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.37ms | 6.91ms | +2.46ms (+35.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.14ms | 12.33ms | +2.81ms (+22.8%) | 🔴 |
| Worst Frame Build Time Millis | 53.06ms | 35.94ms | +17.12ms (+47.6%) | 🔴 |
| Missed Frame Build Budget Count | 3.75 | 3.25 | +0 (+15.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.15ms | 6.81ms | +2.34ms (+34.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.22ms | -0.01ms (-1.0%) | 🟡 |
| Worst Frame Build Time Millis | 9.38ms | 7.60ms | +1.77ms (+23.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.83ms | 5.95ms | +2.88ms (+48.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 7.75 | 0.0 | +8 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.77ms | -0.14ms (-18.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.18ms | 4.16ms | -0.98ms (-23.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.18ms | 4.54ms | +1.64ms (+36.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.23ms | 4.73ms | +0.50ms (+10.6%) | 🔴 |
| Worst Frame Build Time Millis | 23.34ms | 19.33ms | +4.00ms (+20.7%) | 🔴 |
| Missed Frame Build Budget Count | 3.5 | 2.25 | +1 (+55.6%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.73ms | 4.93ms | +1.80ms (+36.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.58ms | 20.44ms | +1.14ms (+5.6%) | 🟠 |
| Worst Frame Build Time Millis | 45.62ms | 36.78ms | +8.84ms (+24.0%) | 🔴 |
| Missed Frame Build Budget Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Average Frame Rasterizer Time Millis | 7.94ms | 5.51ms | +2.44ms (+44.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.10ms | +0.10ms (+9.5%) | 🟠 |
| Worst Frame Build Time Millis | 16.30ms | 14.89ms | +1.41ms (+9.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.33ms | 5.08ms | +2.26ms (+44.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.5 | 0.5 | +5 (+1000.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.15ms | 1.37ms | -0.22ms (-16.3%) | 🟢 |
| Worst Frame Build Time Millis | 7.01ms | 10.11ms | -3.10ms (-30.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.87ms | 5.25ms | +1.61ms (+30.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.74ms | 6.76ms | +0.99ms (+14.6%) | 🔴 |
| Worst Frame Build Time Millis | 27.53ms | 25.67ms | +1.86ms (+7.2%) | 🟠 |
| Missed Frame Build Budget Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.94ms | 7.30ms | +2.63ms (+36.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.20ms | +0.01ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 4.80ms | 4.65ms | +0.15ms (+3.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.40ms | 8.60ms | +2.80ms (+32.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 17.0 | 1.5 | +16 (+1033.3%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.04ms | 0.91ms | +0.12ms (+13.5%) | 🔴 |
| Worst Frame Build Time Millis | 5.58ms | 4.43ms | +1.15ms (+26.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.22ms | 8.66ms | +3.56ms (+41.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 2.25 | +1 (+55.6%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.79ms | 2.89ms | +0.90ms (+31.1%) | 🔴 |
| Worst Frame Build Time Millis | 10.20ms | 5.98ms | +4.22ms (+70.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.55ms | 7.70ms | +3.85ms (+49.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.75 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>
