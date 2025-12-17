## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 6.2%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 5.3%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 9.5%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.92ms | 2.83ms | +0.09ms (+3.3%) | 🟠 |
| Worst Frame Build Time Millis | 7.17ms | 6.75ms | +0.42ms (+6.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.73ms | 3.79ms | -0.07ms (-1.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.49ms | 5.28ms | +0.21ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 20.68ms | 20.22ms | +0.45ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.10ms | 5.01ms | +0.08ms (+1.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.67ms | -0.05ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.60ms | 5.55ms | -1.95ms (-35.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.64ms | 5.61ms | -0.97ms (-17.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.47ms | +0.02ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 2.22ms | 2.10ms | +0.12ms (+5.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.45ms | 4.75ms | +0.71ms (+14.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.38ms | 8.99ms | +0.40ms (+4.4%) | 🟠 |
| Worst Frame Build Time Millis | 26.82ms | 25.61ms | +1.20ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.89ms | 3.64ms | +0.25ms (+6.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.95ms | 6.54ms | +0.41ms (+6.2%) | 🟠 |
| Worst Frame Build Time Millis | 14.30ms | 13.25ms | +1.06ms (+8.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.45ms | 5.03ms | +0.41ms (+8.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.75 | -0 (-4.3%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.27ms | 2.19ms | +0.08ms (+3.8%) | 🟠 |
| Worst Frame Build Time Millis | 27.10ms | 33.80ms | -6.70ms (-19.8%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.52ms | 7.11ms | -0.59ms (-8.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 4.25 | -0 (-11.8%) | 🟢 |
| New Gen Gc Count | 8.25 | 8.0 | +0 (+3.1%) | 🟠 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.77ms | +0.03ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 2.07ms | 2.02ms | +0.05ms (+2.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.63ms | 14.28ms | +0.35ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.89ms | 2.82ms | +0.07ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 9.52ms | 9.44ms | +0.08ms (+0.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.97ms | 3.87ms | +0.10ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.61ms | -0.01ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 2.29ms | 2.75ms | -0.46ms (-16.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.13ms | 4.73ms | -0.59ms (-12.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.50ms | -0.01ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 1.77ms | 1.89ms | -0.12ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.53ms | 3.91ms | -0.38ms (-9.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.08ms | 1.90ms | +0.18ms (+9.5%) | 🟠 |
| Worst Frame Build Time Millis | 5.28ms | 3.89ms | +1.39ms (+35.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.23ms | 6.57ms | +0.66ms (+10.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.43ms | 8.42ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 36.36ms | 33.99ms | +2.36ms (+7.0%) | 🟠 |
| Missed Frame Build Budget Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.12ms | 7.11ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.44ms | 15.04ms | +0.40ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 49.90ms | 47.18ms | +2.71ms (+5.7%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.97ms | 7.04ms | -0.08ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.41ms | 1.45ms | -0.04ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 14.14ms | 14.55ms | -0.41ms (-2.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.02ms | 9.01ms | -1.99ms (-22.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 9.0 | -5 (-58.3%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.31ms | -0.02ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 10.03ms | 8.77ms | +1.26ms (+14.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.97ms | 11.97ms | -5.00ms (-41.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 4.5 | -3 (-66.7%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.92ms | 6.03ms | -0.11ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 33.61ms | 34.85ms | -1.24ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.34ms | 5.27ms | +0.07ms (+1.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 20.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.94ms | 23.24ms | -0.29ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 40.61ms | 50.26ms | -9.65ms (-19.2%) | 🟢 |
| Missed Frame Build Budget Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.62ms | 5.32ms | +0.30ms (+5.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.0 | 16.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.95ms | 0.94ms | +0.00ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 20.93ms | 21.58ms | -0.65ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.00ms | 6.93ms | -0.93ms (-13.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 5.25 | 5.0 | +0 (+5.0%) | 🟠 |
| New Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.44ms | 1.46ms | -0.02ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 7.11ms | 7.35ms | -0.23ms (-3.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.69ms | 5.63ms | +0.06ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.47ms | 8.38ms | +0.09ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 34.70ms | 34.39ms | +0.31ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.65ms | 7.49ms | +0.16ms (+2.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.25ms | -0.03ms (-2.6%) | 🟡 |
| Worst Frame Build Time Millis | 9.38ms | 8.62ms | +0.76ms (+8.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.14ms | 10.96ms | -0.82ms (-7.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 16.5 | 15.5 | +1 (+6.5%) | 🟠 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.89ms | 0.91ms | -0.02ms (-2.3%) | 🟡 |
| Worst Frame Build Time Millis | 4.58ms | 4.47ms | +0.12ms (+2.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.82ms | 8.50ms | -1.67ms (-19.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.71ms | 1.63ms | +0.08ms (+4.7%) | 🟠 |
| Worst Frame Build Time Millis | 3.78ms | 2.41ms | +1.36ms (+56.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.50ms | 9.22ms | -0.72ms (-7.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

</details>

