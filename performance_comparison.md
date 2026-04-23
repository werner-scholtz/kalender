## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 26.9%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 22.5%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 39.1%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 22.5%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 21.9%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 25.4%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 5.7%
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 5.5%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 8.0%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 8.5%

**Performance Improvements:**
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 12.1%
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 13.9%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.80ms | 3.10ms | +0.70ms (+22.5%) | 🔴 |
| Worst Frame Build Time Millis | 9.76ms | 7.56ms | +2.19ms (+29.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.65ms | 4.64ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.36ms | 5.37ms | -0.02ms (-0.3%) | 🟡 |
| Worst Frame Build Time Millis | 16.05ms | 16.77ms | -0.72ms (-4.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.25 | 1.25 | -1 (-80.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.22ms | 5.72ms | +0.50ms (+8.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 6.0 | 4.0 | +2 (+50.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.76ms | +0.06ms (+8.0%) | 🟠 |
| Worst Frame Build Time Millis | 3.43ms | 2.92ms | +0.51ms (+17.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.67ms | 5.38ms | +0.28ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.75 | +0 (+66.7%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 3.5 | +2 (+42.9%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 0.64ms | +0.14ms (+22.5%) | 🔴 |
| Worst Frame Build Time Millis | 3.69ms | 3.01ms | +0.68ms (+22.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.68ms | 5.18ms | +0.50ms (+9.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.39ms | 12.20ms | +0.18ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 34.79ms | 34.65ms | +0.14ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.14ms | 6.52ms | -0.37ms (-5.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.37ms | 7.71ms | +0.65ms (+8.5%) | 🟠 |
| Worst Frame Build Time Millis | 14.85ms | 15.10ms | -0.25ms (-1.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.78ms | 6.73ms | +0.06ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.59ms | 2.94ms | -0.35ms (-12.1%) | 🟢 |
| Worst Frame Build Time Millis | 27.09ms | 29.80ms | -2.70ms (-9.1%) | 🟢 |
| Missed Frame Build Budget Count | 2.0 | 1.75 | +0 (+14.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.95ms | 6.56ms | +0.40ms (+6.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.25 | 0.25 | +2 (+800.0%) | 🔴 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.72ms | +0.01ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 1.85ms | 1.90ms | -0.06ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.47ms | 3.94ms | +0.53ms (+13.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.15ms | 2.99ms | +0.16ms (+5.5%) | 🟠 |
| Worst Frame Build Time Millis | 11.48ms | 10.48ms | +0.99ms (+9.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.31ms | 4.27ms | +0.04ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.00ms | 0.79ms | +0.21ms (+26.9%) | 🔴 |
| Worst Frame Build Time Millis | 6.34ms | 3.92ms | +2.43ms (+61.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.79ms | 4.55ms | +0.24ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.25 | -1 (-60.0%) | 🟢 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.54ms | +0.21ms (+39.1%) | 🔴 |
| Worst Frame Build Time Millis | 4.27ms | 2.75ms | +1.52ms (+55.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.99ms | 4.76ms | +1.22ms (+25.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.25 | +1 (+400.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.27ms | 2.28ms | -0.01ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 5.73ms | 5.37ms | +0.36ms (+6.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.73ms | 5.50ms | +0.23ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.88ms | 7.45ms | +0.43ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 28.49ms | 24.79ms | +3.70ms (+14.9%) | 🔴 |
| Missed Frame Build Budget Count | 7.0 | 6.75 | +0 (+3.7%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.41ms | 9.18ms | +0.22ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.64ms | 17.00ms | -2.36ms (-13.9%) | 🟢 |
| Worst Frame Build Time Millis | 41.53ms | 58.03ms | -16.49ms (-28.4%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.63ms | 9.33ms | +0.30ms (+3.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.82ms | 1.45ms | +0.37ms (+25.4%) | 🔴 |
| Worst Frame Build Time Millis | 14.45ms | 9.28ms | +5.17ms (+55.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.48ms | 8.51ms | +0.97ms (+11.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 10.75 | 8.0 | +3 (+34.4%) | 🔴 |
| New Gen Gc Count | 7.5 | 6.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.0 | +2 (+150.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 0.97ms | -0.06ms (-6.5%) | 🟢 |
| Worst Frame Build Time Millis | 4.69ms | 7.74ms | -3.05ms (-39.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.96ms | 6.55ms | +0.41ms (+6.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.07ms | 5.87ms | +0.20ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 26.69ms | 23.45ms | +3.24ms (+13.8%) | 🔴 |
| Missed Frame Build Budget Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.97ms | 6.63ms | +0.33ms (+5.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.5 | -0 (-3.4%) | 🟡 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.10ms | 25.61ms | -1.50ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 42.59ms | 46.12ms | -3.53ms (-7.6%) | 🟢 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.41ms | 7.86ms | -0.44ms (-5.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.0 | 14.0 | +2 (+14.3%) | 🔴 |
| Old Gen Gc Count | 8.5 | 10.0 | -2 (-15.0%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.16ms | +0.04ms (+3.2%) | 🟠 |
| Worst Frame Build Time Millis | 17.96ms | 15.73ms | +2.24ms (+14.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.56ms | 6.59ms | -0.02ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.75 | 1.25 | +0 (+40.0%) | 🔴 |
| New Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.45ms | +0.00ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 8.41ms | 7.48ms | +0.93ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.78ms | 6.75ms | +0.04ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.86ms | 8.82ms | +0.04ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 31.21ms | 30.46ms | +0.75ms (+2.5%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 10.01ms | 9.85ms | +0.16ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.43ms | 1.42ms | +0.02ms (+1.1%) | 🟠 |
| Worst Frame Build Time Millis | 7.85ms | 7.47ms | +0.38ms (+5.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.19ms | 11.98ms | -0.79ms (-6.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 19.75 | 28.5 | -9 (-30.7%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.14ms | 1.18ms | -0.04ms (-3.5%) | 🟡 |
| Worst Frame Build Time Millis | 6.45ms | 5.21ms | +1.24ms (+23.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.82ms | 12.77ms | -0.96ms (-7.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 4.75 | -1 (-26.3%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.56ms | 2.92ms | +0.64ms (+21.9%) | 🔴 |
| Worst Frame Build Time Millis | 5.79ms | 4.30ms | +1.49ms (+34.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.29ms | 9.47ms | +1.82ms (+19.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>
