## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 17.2%

**Performance Improvements:**
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 21.9%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 12.4%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 24.7%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 15.8%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 22.5%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 26.8%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 29.7%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 11.5%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 11.3%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.50ms | 3.21ms | -0.70ms (-21.9%) | 🟢 |
| Worst Frame Build Time Millis | 6.15ms | 8.08ms | -1.93ms (-23.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.90ms | 5.03ms | -1.14ms (-22.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.22ms | 5.67ms | -0.45ms (-8.0%) | 🟢 |
| Worst Frame Build Time Millis | 16.27ms | 18.10ms | -1.83ms (-10.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.96ms | 5.95ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.78ms | 0.77ms | +0.01ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 6.09ms | 3.96ms | +2.13ms (+53.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.30ms | 6.12ms | -0.82ms (-13.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 2.0 | -1 (-62.5%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.48ms | +0.08ms (+17.2%) | 🔴 |
| Worst Frame Build Time Millis | 2.91ms | 1.99ms | +0.92ms (+46.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.16ms | 5.69ms | +0.47ms (+8.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.55ms | 12.69ms | -3.14ms (-24.7%) | 🟢 |
| Worst Frame Build Time Millis | 26.83ms | 35.80ms | -8.96ms (-25.0%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.63ms | 6.51ms | -0.87ms (-13.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.57ms | 8.13ms | -0.56ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 13.95ms | 15.23ms | -1.28ms (-8.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.59ms | 6.81ms | -0.22ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.07ms | 2.95ms | -0.88ms (-29.7%) | 🟢 |
| Worst Frame Build Time Millis | 29.69ms | 37.91ms | -8.22ms (-21.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.57ms | 6.60ms | -0.03ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 8.5 | +2 (+17.6%) | 🔴 |
| Old Gen Gc Count | 3.5 | 4.5 | -1 (-22.2%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.80ms | -0.07ms (-9.1%) | 🟢 |
| Worst Frame Build Time Millis | 1.91ms | 2.12ms | -0.21ms (-9.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.78ms | 4.15ms | -0.37ms (-9.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.82ms | 3.03ms | -0.22ms (-7.1%) | 🟢 |
| Worst Frame Build Time Millis | 9.75ms | 10.01ms | -0.25ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.17ms | 4.47ms | -0.29ms (-6.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.74ms | 0.82ms | -0.08ms (-9.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.05ms | 4.25ms | -1.20ms (-28.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.42ms | 5.03ms | -0.60ms (-12.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.0 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.48ms | +0.00ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.28ms | 2.11ms | +0.17ms (+7.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.36ms | 4.22ms | +0.14ms (+3.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.92ms | 2.17ms | -0.25ms (-11.3%) | 🟢 |
| Worst Frame Build Time Millis | 4.57ms | 4.05ms | +0.52ms (+12.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.11ms | 5.52ms | -0.41ms (-7.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.45ms | 8.09ms | -0.64ms (-7.9%) | 🟢 |
| Worst Frame Build Time Millis | 24.62ms | 26.82ms | -2.19ms (-8.2%) | 🟢 |
| Missed Frame Build Budget Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.20ms | 9.63ms | -0.44ms (-4.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.76ms | 15.33ms | +0.43ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 53.58ms | 46.72ms | +6.86ms (+14.7%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.68ms | 10.14ms | -1.46ms (-14.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.38ms | 1.64ms | -0.26ms (-15.8%) | 🟢 |
| Worst Frame Build Time Millis | 8.60ms | 9.96ms | -1.36ms (-13.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.31ms | 9.23ms | -0.92ms (-10.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.25 | 8.75 | -4 (-51.4%) | 🟢 |
| New Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 2.5 | -2 (-100.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 1.11ms | -0.30ms (-26.8%) | 🟢 |
| Worst Frame Build Time Millis | 5.82ms | 5.54ms | +0.27ms (+4.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.16ms | 8.26ms | -2.10ms (-25.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.75 | -2 (-85.7%) | 🟢 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.55ms | 6.27ms | -0.72ms (-11.5%) | 🟢 |
| Worst Frame Build Time Millis | 21.51ms | 26.79ms | -5.28ms (-19.7%) | 🟢 |
| Missed Frame Build Budget Count | 4.25 | 5.75 | -2 (-26.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.40ms | 6.78ms | -0.38ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.0 | +0 (+3.6%) | 🟠 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 26.70ms | 27.74ms | -1.04ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 43.27ms | 52.88ms | -9.62ms (-18.2%) | 🟢 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.52ms | 7.86ms | -0.34ms (-4.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 9.5 | -2 (-15.8%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.16ms | 1.32ms | -0.16ms (-12.4%) | 🟢 |
| Worst Frame Build Time Millis | 15.70ms | 17.96ms | -2.26ms (-12.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.65ms | 6.54ms | +0.11ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.5 | 1.0 | +2 (+150.0%) | 🔴 |
| New Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.44ms | 1.52ms | -0.08ms (-5.2%) | 🟢 |
| Worst Frame Build Time Millis | 7.88ms | 8.65ms | -0.77ms (-8.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.96ms | 6.96ms | +0.00ms (+0.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.11ms | 8.45ms | -0.34ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 29.58ms | 31.13ms | -1.55ms (-5.0%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.33ms | 9.80ms | -0.47ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.45ms | -0.11ms (-7.6%) | 🟢 |
| Worst Frame Build Time Millis | 4.96ms | 7.98ms | -3.02ms (-37.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.43ms | 11.90ms | -0.47ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 17.75 | 26.5 | -9 (-33.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.02ms | 1.09ms | -0.06ms (-5.8%) | 🟢 |
| Worst Frame Build Time Millis | 4.02ms | 6.09ms | -2.08ms (-34.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.21ms | 12.29ms | -0.08ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.5 | 5.25 | -3 (-52.4%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.94ms | 3.79ms | -0.85ms (-22.5%) | 🟢 |
| Worst Frame Build Time Millis | 5.69ms | 6.98ms | -1.28ms (-18.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.14ms | 10.64ms | -0.50ms (-4.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>
