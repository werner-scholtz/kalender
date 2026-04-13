## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 23.6%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 28.8%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 5.3%

**Performance Improvements:**
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 11.9%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 29.5%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 27.1%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 23.9%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 21.6%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 10.5%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.63ms | 2.82ms | +0.81ms (+28.8%) | 🔴 |
| Worst Frame Build Time Millis | 8.92ms | 6.87ms | +2.05ms (+29.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.40ms | 4.74ms | -0.33ms (-7.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.25ms | 5.60ms | -0.35ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 16.12ms | 17.69ms | -1.58ms (-8.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 1.0 | -1 (-75.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.93ms | 6.33ms | -0.40ms (-6.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.79ms | -0.08ms (-10.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.82ms | 4.54ms | -1.72ms (-37.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.35ms | 6.59ms | -1.24ms (-18.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 3.25 | -2 (-46.2%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.65ms | 0.92ms | -0.27ms (-29.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.30ms | 3.45ms | -0.15ms (-4.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.98ms | 6.90ms | -0.92ms (-13.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.0 | -0 (-25.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.01ms | 10.85ms | -0.84ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 27.90ms | 30.22ms | -2.32ms (-7.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.01ms | 6.20ms | -1.18ms (-19.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.86ms | 8.18ms | -0.32ms (-3.9%) | 🟡 |
| Worst Frame Build Time Millis | 14.58ms | 14.67ms | -0.09ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.69ms | 6.84ms | -0.15ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.24ms | 3.08ms | -0.83ms (-27.1%) | 🟢 |
| Worst Frame Build Time Millis | 36.24ms | 26.55ms | +9.69ms (+36.5%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 2.25 | -1 (-55.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.49ms | 7.17ms | -0.69ms (-9.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 1.0 | +1 (+75.0%) | 🔴 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.71ms | +0.04ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 1.98ms | 1.86ms | +0.13ms (+6.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.42ms | 3.86ms | +0.55ms (+14.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.94ms | 2.95ms | -0.01ms (-0.4%) | 🟡 |
| Worst Frame Build Time Millis | 10.11ms | 10.09ms | +0.03ms (+0.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.30ms | 4.33ms | -0.03ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.82ms | -0.10ms (-11.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.11ms | 3.81ms | -0.70ms (-18.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.32ms | 4.72ms | -0.40ms (-8.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.50ms | -0.03ms (-6.7%) | 🟢 |
| Worst Frame Build Time Millis | 2.23ms | 2.19ms | +0.04ms (+1.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.96ms | 4.06ms | -0.10ms (-2.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.92ms | 2.45ms | -0.53ms (-21.6%) | 🟢 |
| Worst Frame Build Time Millis | 3.38ms | 5.61ms | -2.22ms (-39.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.32ms | 5.57ms | -0.24ms (-4.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.37ms | 7.43ms | -0.06ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 25.08ms | 24.90ms | +0.18ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 7.0 | 6.75 | +0 (+3.7%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.26ms | 9.34ms | -0.08ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 16.34ms | 16.20ms | +0.14ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 54.97ms | 59.76ms | -4.79ms (-8.0%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.29ms | 9.42ms | -0.13ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.51ms | -0.10ms (-6.4%) | 🟢 |
| Worst Frame Build Time Millis | 12.23ms | 11.74ms | +0.50ms (+4.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.45ms | 8.85ms | -0.40ms (-4.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 5.0 | 9.25 | -4 (-45.9%) | 🟢 |
| New Gen Gc Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.00ms | 0.81ms | +0.19ms (+23.6%) | 🔴 |
| Worst Frame Build Time Millis | 4.05ms | 3.92ms | +0.13ms (+3.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.49ms | 5.85ms | +0.64ms (+10.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.97ms | 6.17ms | -0.20ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 24.43ms | 28.11ms | -3.68ms (-13.1%) | 🟢 |
| Missed Frame Build Budget Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.61ms | 7.27ms | -0.65ms (-9.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.87ms | 25.68ms | +0.19ms (+0.7%) | 🟠 |
| Worst Frame Build Time Millis | 47.84ms | 52.15ms | -4.31ms (-8.3%) | 🟢 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.58ms | 7.60ms | -0.03ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.14ms | 1.13ms | +0.01ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 15.85ms | 13.95ms | +1.90ms (+13.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.97ms | 6.84ms | +0.13ms (+1.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.75 | 1.5 | +3 (+216.7%) | 🔴 |
| New Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.47ms | -0.05ms (-3.3%) | 🟡 |
| Worst Frame Build Time Millis | 7.09ms | 8.80ms | -1.71ms (-19.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.80ms | 7.18ms | -0.38ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.61ms | 8.58ms | +0.02ms (+0.3%) | 🟠 |
| Worst Frame Build Time Millis | 29.79ms | 30.11ms | -0.31ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.86ms | 9.92ms | -0.06ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.32ms | 1.42ms | -0.10ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 5.73ms | 6.90ms | -1.17ms (-16.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.74ms | 11.95ms | -1.21ms (-10.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 16.5 | 28.0 | -12 (-41.1%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.18ms | 1.15ms | +0.03ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 6.81ms | 4.29ms | +2.52ms (+58.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.63ms | 13.63ms | -1.00ms (-7.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 5.25 | -2 (-28.6%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.29ms | 4.33ms | -1.03ms (-23.9%) | 🟢 |
| Worst Frame Build Time Millis | 7.56ms | 10.94ms | -3.38ms (-30.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.45ms | 10.87ms | -0.42ms (-3.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

</details>
