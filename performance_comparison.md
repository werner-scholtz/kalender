## Summary

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 7.6%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 14.5%

**Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 11.4%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 10.9%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 10.2%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 10.6%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 17.8%
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 11.1%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 10.6%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 26.0%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 15.6%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 11.4%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 14.6%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 17.9%
- 🟢 **ten_events_per_day-week-navigation**: Frame build time improved by 18.2%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.02ms | 2.73ms | -0.71ms (-26.0%) | 🟢 |
| Worst Frame Build Time Millis | 4.69ms | 6.93ms | -2.23ms (-32.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.32ms | 4.02ms | -0.70ms (-17.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.56ms | 5.03ms | -0.47ms (-9.3%) | 🟢 |
| Worst Frame Build Time Millis | 13.86ms | 16.40ms | -2.54ms (-15.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.45ms | 5.55ms | -1.09ms (-19.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.66ms | 0.72ms | -0.06ms (-8.1%) | 🟢 |
| Worst Frame Build Time Millis | 2.80ms | 3.15ms | -0.34ms (-10.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.19ms | 5.25ms | -1.06ms (-20.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 1.75 | -0 (-28.6%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.48ms | +0.07ms (+14.5%) | 🔴 |
| Worst Frame Build Time Millis | 2.33ms | 2.23ms | +0.11ms (+4.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.89ms | 4.76ms | +0.13ms (+2.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.16ms | 9.93ms | -1.77ms (-17.8%) | 🟢 |
| Worst Frame Build Time Millis | 22.66ms | 27.17ms | -4.51ms (-16.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.27ms | 4.96ms | -0.69ms (-13.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.63ms | 7.39ms | -0.75ms (-10.2%) | 🟢 |
| Worst Frame Build Time Millis | 12.21ms | 14.58ms | -2.37ms (-16.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.07ms | 6.69ms | -1.62ms (-24.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.24ms | 2.30ms | -0.06ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 22.48ms | 26.68ms | -4.19ms (-15.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.20ms | 6.65ms | -1.45ms (-21.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 3.5 | 4.5 | -1 (-22.2%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.69ms | -0.06ms (-8.9%) | 🟢 |
| Worst Frame Build Time Millis | 1.61ms | 1.82ms | -0.22ms (-11.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.12ms | 3.66ms | -0.54ms (-14.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.57ms | 2.85ms | -0.28ms (-9.7%) | 🟢 |
| Worst Frame Build Time Millis | 10.05ms | 10.17ms | -0.12ms (-1.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.31ms | 4.08ms | -0.78ms (-19.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.72ms | -0.02ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 3.45ms | 5.02ms | -1.57ms (-31.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.60ms | 4.27ms | -0.67ms (-15.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.55ms | -0.06ms (-10.9%) | 🟢 |
| Worst Frame Build Time Millis | 2.98ms | 2.91ms | +0.07ms (+2.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.36ms | 4.45ms | -1.09ms (-24.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.81ms | 1.86ms | -0.05ms (-2.6%) | 🟡 |
| Worst Frame Build Time Millis | 3.66ms | 3.63ms | +0.03ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.57ms | 5.18ms | -0.60ms (-11.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.59ms | 7.44ms | -0.85ms (-11.4%) | 🟢 |
| Worst Frame Build Time Millis | 20.93ms | 29.12ms | -8.19ms (-28.1%) | 🟢 |
| Missed Frame Build Budget Count | 4.25 | 5.25 | -1 (-19.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.91ms | 9.09ms | -2.18ms (-24.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.33ms | 13.88ms | -1.55ms (-11.1%) | 🟢 |
| Worst Frame Build Time Millis | 35.94ms | 39.13ms | -3.19ms (-8.2%) | 🟢 |
| Missed Frame Build Budget Count | 3.25 | 3.75 | -0 (-13.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.81ms | 9.61ms | -2.81ms (-29.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.49ms | -0.27ms (-17.9%) | 🟢 |
| Worst Frame Build Time Millis | 7.60ms | 9.70ms | -2.10ms (-21.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.95ms | 8.99ms | -3.04ms (-33.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 5.5 | -6 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.5 | 8.0 | -2 (-18.8%) | 🟢 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.72ms | +0.05ms (+7.6%) | 🟠 |
| Worst Frame Build Time Millis | 4.16ms | 3.42ms | +0.74ms (+21.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.54ms | 6.48ms | -1.94ms (-30.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.73ms | 5.54ms | -0.81ms (-14.6%) | 🟢 |
| Worst Frame Build Time Millis | 19.33ms | 23.13ms | -3.79ms (-16.4%) | 🟢 |
| Missed Frame Build Budget Count | 2.25 | 4.5 | -2 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.93ms | 6.49ms | -1.56ms (-24.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 20.44ms | 24.20ms | -3.77ms (-15.6%) | 🟢 |
| Worst Frame Build Time Millis | 36.78ms | 44.65ms | -7.87ms (-17.6%) | 🟢 |
| Missed Frame Build Budget Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.51ms | 7.09ms | -1.58ms (-22.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.10ms | 1.07ms | +0.03ms (+3.2%) | 🟠 |
| Worst Frame Build Time Millis | 14.89ms | 17.11ms | -2.22ms (-13.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.08ms | 6.55ms | -1.48ms (-22.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.75 | -1 (-71.4%) | 🟢 |
| New Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.40ms | -0.03ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 10.11ms | 7.31ms | +2.80ms (+38.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.25ms | 6.15ms | -0.89ms (-14.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.76ms | 8.26ms | -1.50ms (-18.2%) | 🟢 |
| Worst Frame Build Time Millis | 25.67ms | 28.31ms | -2.64ms (-9.3%) | 🟢 |
| Missed Frame Build Budget Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.30ms | 9.49ms | -2.19ms (-23.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.34ms | -0.14ms (-10.6%) | 🟢 |
| Worst Frame Build Time Millis | 4.65ms | 7.38ms | -2.73ms (-37.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.60ms | 11.17ms | -2.57ms (-23.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 17.0 | -16 (-91.2%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 1.03ms | -0.12ms (-11.4%) | 🟢 |
| Worst Frame Build Time Millis | 4.43ms | 5.67ms | -1.25ms (-22.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.66ms | 12.32ms | -3.65ms (-29.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.25 | 2.75 | -0 (-18.2%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.89ms | 3.23ms | -0.34ms (-10.6%) | 🟢 |
| Worst Frame Build Time Millis | 5.98ms | 6.09ms | -0.11ms (-1.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.70ms | 11.06ms | -3.36ms (-30.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

</details>
