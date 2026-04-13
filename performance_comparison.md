## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 26.3%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 8.0%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 14.0%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 6.1%

**Performance Improvements:**
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 12.4%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 12.0%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 11.5%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 18.2%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.47ms | 2.50ms | -0.03ms (-1.4%) | 🟡 |
| Worst Frame Build Time Millis | 5.95ms | 6.15ms | -0.20ms (-3.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.76ms | 3.90ms | -0.14ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.99ms | 5.22ms | -0.23ms (-4.3%) | 🟡 |
| Worst Frame Build Time Millis | 15.14ms | 16.27ms | -1.13ms (-6.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 1.0 | -1 (-75.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.72ms | 5.96ms | -0.24ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.78ms | -0.09ms (-11.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.69ms | 6.09ms | -3.39ms (-55.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.41ms | 5.30ms | +0.11ms (+2.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.46ms | 0.57ms | -0.10ms (-18.2%) | 🟢 |
| Worst Frame Build Time Millis | 1.76ms | 2.91ms | -1.15ms (-39.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.89ms | 6.16ms | -0.27ms (-4.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.33ms | 9.55ms | -0.23ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 25.98ms | 26.83ms | -0.85ms (-3.2%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.98ms | 5.63ms | -0.65ms (-11.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.60ms | 7.57ms | +0.03ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 13.99ms | 13.95ms | +0.04ms (+0.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.56ms | 6.59ms | -0.03ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.62ms | 2.07ms | +0.55ms (+26.3%) | 🔴 |
| Worst Frame Build Time Millis | 26.52ms | 29.69ms | -3.17ms (-10.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.26ms | 6.57ms | -0.31ms (-4.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.0 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 10.0 | -2 (-20.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.72ms | -0.01ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 1.86ms | 1.91ms | -0.05ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.03ms | 3.78ms | +0.25ms (+6.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.83ms | 2.82ms | +0.01ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 10.93ms | 9.75ms | +1.18ms (+12.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.13ms | 4.17ms | -0.05ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 4.0 | -2 (-62.5%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.74ms | +0.02ms (+3.2%) | 🟠 |
| Worst Frame Build Time Millis | 5.37ms | 3.05ms | +2.32ms (+75.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.88ms | 4.42ms | +0.46ms (+10.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.48ms | +0.03ms (+6.1%) | 🟠 |
| Worst Frame Build Time Millis | 3.09ms | 2.28ms | +0.81ms (+35.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.74ms | 4.36ms | +1.38ms (+31.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.08ms | 1.92ms | +0.15ms (+8.0%) | 🟠 |
| Worst Frame Build Time Millis | 4.76ms | 4.57ms | +0.19ms (+4.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.52ms | 5.11ms | +0.41ms (+8.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.23ms | 7.45ms | -0.22ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 23.24ms | 24.62ms | -1.39ms (-5.6%) | 🟢 |
| Missed Frame Build Budget Count | 6.25 | 6.5 | -0 (-3.8%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.12ms | 9.20ms | -0.08ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.80ms | 15.76ms | -1.96ms (-12.4%) | 🟢 |
| Worst Frame Build Time Millis | 40.84ms | 53.58ms | -12.73ms (-23.8%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.14ms | 8.68ms | +0.46ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.43ms | 1.38ms | +0.05ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 8.65ms | 8.60ms | +0.05ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.75ms | 8.31ms | +0.44ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.75 | 4.25 | +0 (+11.8%) | 🔴 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.81ms | -0.08ms (-9.7%) | 🟢 |
| Worst Frame Build Time Millis | 3.90ms | 5.82ms | -1.92ms (-32.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.85ms | 6.16ms | -0.32ms (-5.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.52ms | 5.55ms | -0.03ms (-0.5%) | 🟡 |
| Worst Frame Build Time Millis | 22.40ms | 21.51ms | +0.89ms (+4.1%) | 🟠 |
| Missed Frame Build Budget Count | 3.75 | 4.25 | -0 (-11.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.49ms | 6.40ms | +0.09ms (+1.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.5 | -0 (-3.4%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.49ms | 26.70ms | -3.21ms (-12.0%) | 🟢 |
| Worst Frame Build Time Millis | 43.37ms | 43.27ms | +0.10ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.34ms | 7.52ms | -0.18ms (-2.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.16ms | +0.04ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 15.13ms | 15.70ms | -0.57ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.82ms | 6.65ms | +0.17ms (+2.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.25 | 2.5 | +1 (+30.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.44ms | -0.07ms (-5.0%) | 🟢 |
| Worst Frame Build Time Millis | 6.85ms | 7.88ms | -1.02ms (-13.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.81ms | 6.96ms | -0.15ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.88ms | 8.11ms | -0.23ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 31.23ms | 29.58ms | +1.65ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.26ms | 9.33ms | -0.06ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.30ms | 1.34ms | -0.04ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 5.42ms | 4.96ms | +0.46ms (+9.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.44ms | 11.43ms | +0.02ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 23.0 | 17.75 | +5 (+29.6%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.93ms | 1.02ms | -0.09ms (-9.0%) | 🟢 |
| Worst Frame Build Time Millis | 4.35ms | 4.02ms | +0.33ms (+8.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 13.07ms | 12.21ms | +0.87ms (+7.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 6.0 | 2.5 | +4 (+140.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.35ms | 2.94ms | +0.41ms (+14.0%) | 🔴 |
| Worst Frame Build Time Millis | 7.29ms | 5.69ms | +1.60ms (+28.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.38ms | 10.14ms | +0.24ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
