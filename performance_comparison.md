## Summary

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 8.7%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 5.5%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 7.1%

**Performance Improvements:**
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 13.9%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 16.3%
- 🟢 **one_event_per_day-week-navigation**: Frame build time improved by 11.6%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 23.0%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 10.5%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 22.5%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 14.4%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 12.1%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.95ms | 2.72ms | +0.24ms (+8.7%) | 🟠 |
| Worst Frame Build Time Millis | 7.53ms | 6.65ms | +0.88ms (+13.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.80ms | 4.02ms | +0.78ms (+19.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.77ms | 4.97ms | -0.20ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 16.70ms | 15.06ms | +1.64ms (+10.9%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.11ms | 6.01ms | +0.10ms (+1.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.71ms | -0.04ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.16ms | 2.74ms | +0.42ms (+15.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.75ms | 5.02ms | +0.74ms (+14.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.75 | +1 (+100.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.38ms | 0.49ms | -0.11ms (-23.0%) | 🟢 |
| Worst Frame Build Time Millis | 1.72ms | 2.72ms | -1.00ms (-36.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.97ms | 4.84ms | +0.13ms (+2.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.22ms | 10.64ms | +0.58ms (+5.5%) | 🟠 |
| Worst Frame Build Time Millis | 31.85ms | 30.17ms | +1.68ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.50ms | 5.02ms | +0.48ms (+9.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.65ms | 7.42ms | +0.22ms (+3.0%) | 🟠 |
| Worst Frame Build Time Millis | 16.21ms | 14.74ms | +1.47ms (+10.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.94ms | 6.67ms | +0.27ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.06ms | 2.39ms | -0.33ms (-13.9%) | 🟢 |
| Worst Frame Build Time Millis | 23.27ms | 31.97ms | -8.70ms (-27.2%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.94ms | 6.46ms | +0.48ms (+7.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.5 | 0.75 | +2 (+233.3%) | 🔴 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.72ms | -0.12ms (-16.3%) | 🟢 |
| Worst Frame Build Time Millis | 1.54ms | 1.91ms | -0.37ms (-19.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.85ms | 3.77ms | +0.08ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.58ms | 2.92ms | -0.34ms (-11.6%) | 🟢 |
| Worst Frame Build Time Millis | 8.93ms | 10.24ms | -1.31ms (-12.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.31ms | 4.21ms | +0.10ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.72ms | -0.03ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 4.29ms | 2.90ms | +1.39ms (+48.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.71ms | 4.58ms | +0.13ms (+2.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.5 | +1 (+150.0%) | 🔴 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.47ms | +0.00ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 2.36ms | 2.14ms | +0.22ms (+10.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.70ms | 4.19ms | +0.52ms (+12.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.35ms | 2.19ms | +0.16ms (+7.1%) | 🟠 |
| Worst Frame Build Time Millis | 5.77ms | 5.06ms | +0.71ms (+14.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.75ms | 5.66ms | +0.09ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.93ms | 7.07ms | -0.13ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 23.84ms | 23.33ms | +0.51ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 4.75 | 6.0 | -1 (-20.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.49ms | 8.98ms | +0.51ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.39ms | 14.89ms | -0.50ms (-3.4%) | 🟡 |
| Worst Frame Build Time Millis | 45.04ms | 50.20ms | -5.16ms (-10.3%) | 🟢 |
| Missed Frame Build Budget Count | 3.25 | 4.0 | -1 (-18.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.34ms | 9.07ms | +0.27ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.37ms | -0.09ms (-6.6%) | 🟢 |
| Worst Frame Build Time Millis | 9.15ms | 8.39ms | +0.75ms (+9.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.07ms | 8.31ms | +0.76ms (+9.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 12.25 | 7.5 | +5 (+63.3%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.90ms | -0.20ms (-22.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.22ms | 5.31ms | -2.10ms (-39.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.32ms | 7.29ms | +0.02ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 1.25 | +0 (+20.0%) | 🔴 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.5 | -2 (-60.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.61ms | 5.55ms | +0.06ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 26.94ms | 22.28ms | +4.65ms (+20.9%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.81ms | 6.27ms | +0.53ms (+8.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.46ms | 23.59ms | -2.13ms (-9.0%) | 🟢 |
| Worst Frame Build Time Millis | 41.88ms | 44.94ms | -3.07ms (-6.8%) | 🟢 |
| Missed Frame Build Budget Count | 8.75 | 9.0 | -0 (-2.8%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.91ms | 7.57ms | +0.35ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.16ms | 1.14ms | +0.02ms (+1.8%) | 🟠 |
| Worst Frame Build Time Millis | 14.55ms | 18.01ms | -3.45ms (-19.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.36ms | 6.20ms | +0.16ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.25 | -1 (-60.0%) | 🟢 |
| New Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.40ms | -0.17ms (-12.1%) | 🟢 |
| Worst Frame Build Time Millis | 6.91ms | 7.06ms | -0.15ms (-2.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.86ms | 6.62ms | +0.23ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.87ms | 7.95ms | -0.07ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 29.49ms | 30.21ms | -0.72ms (-2.4%) | 🟡 |
| Missed Frame Build Budget Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 10.20ms | 9.38ms | +0.82ms (+8.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.35ms | -0.14ms (-10.5%) | 🟢 |
| Worst Frame Build Time Millis | 6.56ms | 5.44ms | +1.13ms (+20.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.07ms | 11.31ms | -0.23ms (-2.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 20.0 | 19.0 | +1 (+5.3%) | 🟠 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.93ms | 1.09ms | -0.16ms (-14.4%) | 🟢 |
| Worst Frame Build Time Millis | 5.01ms | 5.34ms | -0.33ms (-6.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.99ms | 13.53ms | -1.54ms (-11.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 4.75 | -1 (-21.1%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.34ms | 3.28ms | +0.06ms (+1.8%) | 🟠 |
| Worst Frame Build Time Millis | 7.02ms | 6.41ms | +0.61ms (+9.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.44ms | 10.36ms | +0.09ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

</details>
