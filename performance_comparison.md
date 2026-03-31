## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 22.1%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 15.0%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 9.9%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 6.5%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 14.1%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 8.4%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 11.8%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 5.2%

**Performance Improvements:**
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 24.2%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 16.9%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 10.7%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 14.5%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.40ms | 2.68ms | -0.29ms (-10.7%) | 🟢 |
| Worst Frame Build Time Millis | 5.71ms | 6.33ms | -0.62ms (-9.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 4.30ms | -0.35ms (-8.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.89ms | 5.08ms | -0.19ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 17.90ms | 15.82ms | +2.09ms (+13.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.09ms | 5.84ms | +0.25ms (+4.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.71ms | +0.04ms (+5.2%) | 🟠 |
| Worst Frame Build Time Millis | 3.52ms | 2.76ms | +0.76ms (+27.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.04ms | 5.15ms | -0.11ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.25 | -1 (-80.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.78ms | -0.19ms (-24.2%) | 🟢 |
| Worst Frame Build Time Millis | 2.18ms | 2.33ms | -0.16ms (-6.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.60ms | 6.28ms | -1.68ms (-26.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.33ms | 9.80ms | -0.47ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 26.44ms | 27.38ms | -0.93ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.10ms | 5.07ms | +0.03ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.73ms | 7.13ms | +0.60ms (+8.4%) | 🟠 |
| Worst Frame Build Time Millis | 16.68ms | 13.61ms | +3.06ms (+22.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.80ms | 6.46ms | +0.34ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.16ms | 2.40ms | -0.23ms (-9.7%) | 🟢 |
| Worst Frame Build Time Millis | 28.35ms | 34.70ms | -6.35ms (-18.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.70ms | 6.39ms | +0.31ms (+4.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.5 | 0.75 | +2 (+233.3%) | 🔴 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 5.0 | 2.5 | +2 (+100.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.64ms | +0.04ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 1.79ms | 1.69ms | +0.10ms (+5.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.65ms | 3.76ms | -0.10ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.82ms | 2.83ms | -0.02ms (-0.7%) | 🟡 |
| Worst Frame Build Time Millis | 9.42ms | 9.28ms | +0.14ms (+1.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.13ms | 4.23ms | -0.10ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.69ms | +0.10ms (+15.0%) | 🔴 |
| Worst Frame Build Time Millis | 4.65ms | 3.12ms | +1.54ms (+49.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.47ms | 4.33ms | +0.14ms (+3.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.54ms | +0.06ms (+11.8%) | 🔴 |
| Worst Frame Build Time Millis | 2.32ms | 2.03ms | +0.29ms (+14.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.11ms | 3.82ms | +0.29ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.12ms | 1.93ms | +0.19ms (+9.9%) | 🟠 |
| Worst Frame Build Time Millis | 5.52ms | 3.74ms | +1.79ms (+47.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.46ms | 5.68ms | -0.22ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.81ms | 6.87ms | -0.05ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 26.67ms | 29.32ms | -2.65ms (-9.0%) | 🟢 |
| Missed Frame Build Budget Count | 4.75 | 4.5 | +0 (+5.6%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.11ms | 9.24ms | -0.13ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.82ms | 14.67ms | -0.84ms (-5.7%) | 🟢 |
| Worst Frame Build Time Millis | 37.52ms | 43.14ms | -5.62ms (-13.0%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.84ms | 8.88ms | -0.05ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.36ms | 1.46ms | -0.10ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 7.61ms | 8.74ms | -1.13ms (-12.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.21ms | 8.43ms | -0.22ms (-2.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.0 | 6.0 | -4 (-66.7%) | 🟢 |
| New Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |
| Old Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.36ms | 1.12ms | +0.25ms (+22.1%) | 🔴 |
| Worst Frame Build Time Millis | 7.38ms | 5.50ms | +1.89ms (+34.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.81ms | 6.10ms | +0.71ms (+11.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 2.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.73ms | 5.58ms | +0.15ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 23.16ms | 25.78ms | -2.62ms (-10.1%) | 🟢 |
| Missed Frame Build Budget Count | 3.75 | 3.5 | +0 (+7.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 6.75ms | 6.63ms | +0.11ms (+1.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.5 | -0 (-3.4%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.65ms | 24.77ms | -1.12ms (-4.5%) | 🟡 |
| Worst Frame Build Time Millis | 45.67ms | 44.93ms | +0.74ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.65ms | 7.48ms | +0.17ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.5 | 8.0 | +2 (+18.8%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.14ms | 1.37ms | -0.23ms (-16.9%) | 🟢 |
| Worst Frame Build Time Millis | 17.34ms | 17.44ms | -0.10ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.25 | 1.5 | -1 (-83.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.18ms | 6.73ms | -0.55ms (-8.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 4.5 | -2 (-55.6%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.26ms | 1.21ms | +0.04ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 6.81ms | 6.41ms | +0.41ms (+6.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.81ms | 7.08ms | -0.26ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.00ms | 7.77ms | +0.23ms (+3.0%) | 🟠 |
| Worst Frame Build Time Millis | 30.67ms | 28.48ms | +2.19ms (+7.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 2.25 | +1 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.65ms | 9.35ms | +0.30ms (+3.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.28ms | +0.06ms (+4.7%) | 🟠 |
| Worst Frame Build Time Millis | 5.29ms | 4.76ms | +0.53ms (+11.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.90ms | 11.30ms | -0.39ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 15.75 | 19.75 | -4 (-20.3%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.35ms | 1.19ms | +0.17ms (+14.1%) | 🔴 |
| Worst Frame Build Time Millis | 6.44ms | 5.15ms | +1.30ms (+25.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.27ms | 10.75ms | +1.52ms (+14.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.75 | 2.0 | +2 (+87.5%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.31ms | 3.87ms | -0.56ms (-14.5%) | 🟢 |
| Worst Frame Build Time Millis | 6.59ms | 7.94ms | -1.35ms (-17.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.91ms | 10.67ms | +0.23ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>
