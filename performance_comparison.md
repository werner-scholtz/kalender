## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 24.3%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 6.0%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 9.8%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 13.4%

**Performance Improvements:**
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 10.7%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 18.3%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.00ms | 2.94ms | +0.06ms (+2.1%) | 🟠 |
| Worst Frame Build Time Millis | 7.70ms | 7.19ms | +0.51ms (+7.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.03ms | 4.31ms | -0.29ms (-6.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.02ms | 5.38ms | -0.36ms (-6.8%) | 🟢 |
| Worst Frame Build Time Millis | 15.97ms | 16.95ms | -0.98ms (-5.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.49ms | 5.58ms | -0.09ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.71ms | -0.01ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 3.25ms | 3.05ms | +0.20ms (+6.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.17ms | 5.29ms | -0.12ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.43ms | 0.53ms | -0.10ms (-18.3%) | 🟢 |
| Worst Frame Build Time Millis | 1.74ms | 2.18ms | -0.43ms (-19.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.01ms | 6.52ms | -1.52ms (-23.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.0 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.80ms | 10.18ms | -0.38ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 27.56ms | 28.66ms | -1.10ms (-3.9%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.46ms | 4.86ms | -0.40ms (-8.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.43ms | 7.68ms | -0.26ms (-3.3%) | 🟡 |
| Worst Frame Build Time Millis | 15.59ms | 15.59ms | -0.00ms (-0.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.36ms | 6.64ms | -0.28ms (-4.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.38ms | 2.10ms | +0.28ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 29.01ms | 27.82ms | +1.19ms (+4.3%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 1.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.37ms | 6.31ms | +0.06ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 3.0 | 4.5 | -2 (-33.3%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.70ms | -0.03ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 1.78ms | 1.83ms | -0.05ms (-2.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.58ms | 3.71ms | -0.13ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.84ms | 2.87ms | -0.04ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 9.78ms | 9.64ms | +0.14ms (+1.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.06ms | 4.18ms | -0.12ms (-3.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.71ms | +0.01ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 4.62ms | 3.06ms | +1.57ms (+51.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.23ms | 4.31ms | -0.08ms (-2.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.0 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.46ms | +0.02ms (+4.5%) | 🟠 |
| Worst Frame Build Time Millis | 2.35ms | 2.18ms | +0.17ms (+7.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.99ms | 3.87ms | +0.12ms (+3.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.92ms | 2.15ms | -0.23ms (-10.7%) | 🟢 |
| Worst Frame Build Time Millis | 4.36ms | 4.58ms | -0.22ms (-4.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.43ms | 5.48ms | -0.06ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.20ms | 7.35ms | -0.14ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 24.53ms | 25.39ms | -0.86ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 8.80ms | 9.05ms | -0.25ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.62ms | 13.80ms | -0.17ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 38.19ms | 40.76ms | -2.57ms (-6.3%) | 🟢 |
| Missed Frame Build Budget Count | 3.75 | 4.0 | -0 (-6.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.64ms | 9.82ms | -0.18ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.52ms | 1.39ms | +0.14ms (+9.8%) | 🟠 |
| Worst Frame Build Time Millis | 9.70ms | 8.53ms | +1.17ms (+13.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.93ms | 8.48ms | +0.46ms (+5.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.5 | 6.25 | -3 (-44.0%) | 🟢 |
| New Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 1.07ms | +0.04ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 5.91ms | 4.45ms | +1.46ms (+32.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.40ms | 7.42ms | -0.02ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.63ms | 5.61ms | +0.02ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 25.86ms | 24.50ms | +1.37ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.75 | +0 (+6.7%) | 🟠 |
| Average Frame Rasterizer Time Millis | 6.52ms | 6.45ms | +0.06ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.62ms | 23.82ms | -1.19ms (-5.0%) | 🟢 |
| Worst Frame Build Time Millis | 45.19ms | 42.28ms | +2.91ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.78ms | 7.16ms | -0.38ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 7.5 | +2 (+20.0%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.15ms | 1.09ms | +0.07ms (+6.0%) | 🟠 |
| Worst Frame Build Time Millis | 23.02ms | 14.73ms | +8.29ms (+56.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.32ms | 6.35ms | -0.03ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.25 | 1.5 | +1 (+50.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.36ms | +0.01ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 7.69ms | 7.58ms | +0.11ms (+1.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.71ms | 6.65ms | +0.06ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.84ms | 7.75ms | +0.09ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 29.95ms | 28.86ms | +1.09ms (+3.8%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.43ms | 9.05ms | +0.38ms (+4.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.25ms | +0.03ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 5.01ms | 4.91ms | +0.11ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.20ms | 11.42ms | -0.22ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 15.0 | 24.25 | -9 (-38.1%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 0.90ms | +0.22ms (+24.3%) | 🔴 |
| Worst Frame Build Time Millis | 6.20ms | 5.52ms | +0.68ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.87ms | 11.41ms | +0.46ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.25 | 2.5 | +1 (+30.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.32ms | 3.21ms | +0.11ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 6.98ms | 7.92ms | -0.94ms (-11.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.48ms | 10.34ms | -0.87ms (-8.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>
