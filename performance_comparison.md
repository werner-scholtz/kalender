## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 45.1%
- 🔴 **one_event_per_day-month-navigation**: Frame build time increased by 17.6%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 31.5%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 50.4%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 17.7%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 9.3%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 8.5%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 5.3%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 6.3%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 7.7%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 12.2%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 11.6%

**Performance Improvements:**
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 25.8%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 14.6%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 21.6%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.88ms | 2.67ms | +0.21ms (+7.7%) | 🟠 |
| Worst Frame Build Time Millis | 7.10ms | 6.53ms | +0.57ms (+8.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.78ms | 4.89ms | -0.11ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.74ms | 4.88ms | +0.86ms (+17.6%) | 🔴 |
| Worst Frame Build Time Millis | 18.98ms | 14.63ms | +4.36ms (+29.8%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 0.25 | +1 (+500.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.61ms | 6.80ms | -1.19ms (-17.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.70ms | +0.02ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 2.99ms | 4.15ms | -1.15ms (-27.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.10ms | 5.93ms | -0.83ms (-14.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.25 | -1 (-44.4%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.5 | -2 (-33.3%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.63ms | -0.14ms (-21.6%) | 🟢 |
| Worst Frame Build Time Millis | 2.44ms | 2.86ms | -0.42ms (-14.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.86ms | 7.11ms | -2.25ms (-31.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.5 | -1 (-83.3%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.01ms | 9.32ms | +4.70ms (+50.4%) | 🔴 |
| Worst Frame Build Time Millis | 40.03ms | 25.93ms | +14.10ms (+54.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.81ms | 5.82ms | -0.00ms (-0.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.38ms | 7.49ms | -0.11ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 13.95ms | 13.43ms | +0.52ms (+3.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.47ms | 6.97ms | -0.50ms (-7.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.08ms | 1.96ms | +0.12ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 24.30ms | 22.74ms | +1.56ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.86ms | 6.52ms | +0.34ms (+5.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.83ms | -0.12ms (-14.6%) | 🟢 |
| Worst Frame Build Time Millis | 1.88ms | 2.21ms | -0.33ms (-14.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.17ms | 4.79ms | -0.62ms (-13.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.82ms | 2.88ms | -0.06ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 9.47ms | 12.56ms | -3.09ms (-24.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.00ms | 4.68ms | +0.31ms (+6.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.73ms | +0.02ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 3.81ms | 3.40ms | +0.41ms (+11.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.33ms | 4.88ms | -0.55ms (-11.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.0 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.54ms | 0.73ms | -0.19ms (-25.8%) | 🟢 |
| Worst Frame Build Time Millis | 3.42ms | 3.04ms | +0.38ms (+12.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.34ms | 5.73ms | -1.39ms (-24.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.09ms | 1.98ms | +0.10ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 4.30ms | 4.85ms | -0.55ms (-11.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.53ms | 5.97ms | -0.44ms (-7.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.18ms | 7.27ms | -0.09ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 26.63ms | 26.81ms | -0.18ms (-0.7%) | 🟡 |
| Missed Frame Build Budget Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.09ms | 9.68ms | -0.59ms (-6.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.94ms | 13.32ms | +1.62ms (+12.2%) | 🔴 |
| Worst Frame Build Time Millis | 45.82ms | 38.77ms | +7.05ms (+18.2%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 3.25 | +1 (+23.1%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.58ms | 9.86ms | -0.28ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.56ms | 1.33ms | +0.24ms (+17.7%) | 🔴 |
| Worst Frame Build Time Millis | 10.44ms | 9.02ms | +1.42ms (+15.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.04ms | 9.68ms | -0.64ms (-6.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 7.25 | 12.5 | -5 (-42.0%) | 🟢 |
| New Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.17ms | 0.89ms | +0.28ms (+31.5%) | 🔴 |
| Worst Frame Build Time Millis | 5.11ms | 4.60ms | +0.51ms (+11.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.24ms | 8.09ms | +0.15ms (+1.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.75 | 1.5 | +0 (+16.7%) | 🔴 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.85ms | 5.24ms | +0.61ms (+11.6%) | 🔴 |
| Worst Frame Build Time Millis | 28.52ms | 21.23ms | +7.30ms (+34.4%) | 🔴 |
| Missed Frame Build Budget Count | 4.25 | 3.5 | +1 (+21.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.86ms | 6.75ms | +0.10ms (+1.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.0 | +0 (+3.6%) | 🟠 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 26.51ms | 24.43ms | +2.08ms (+8.5%) | 🟠 |
| Worst Frame Build Time Millis | 43.75ms | 43.20ms | +0.55ms (+1.3%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 8.25 | +1 (+9.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 7.52ms | 8.24ms | -0.72ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.5 | -0 (-3.4%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.17ms | 1.19ms | -0.02ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 15.03ms | 14.63ms | +0.41ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.86ms | 6.60ms | +0.27ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.25 | 0.75 | +2 (+333.3%) | 🔴 |
| New Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.28ms | +0.12ms (+9.3%) | 🟠 |
| Worst Frame Build Time Millis | 7.37ms | 6.80ms | +0.57ms (+8.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.06ms | 7.00ms | -0.94ms (-13.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.90ms | 8.07ms | -0.17ms (-2.2%) | 🟡 |
| Worst Frame Build Time Millis | 28.39ms | 29.93ms | -1.54ms (-5.1%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 2.75 | +0 (+9.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.67ms | 10.28ms | -0.61ms (-6.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.24ms | +0.05ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 5.98ms | 5.09ms | +0.89ms (+17.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.06ms | 10.72ms | +0.34ms (+3.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 19.75 | 14.0 | +6 (+41.1%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.09ms | 0.75ms | +0.34ms (+45.1%) | 🔴 |
| Worst Frame Build Time Millis | 4.41ms | 3.92ms | +0.50ms (+12.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 13.88ms | 10.87ms | +3.01ms (+27.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.5 | 3.25 | +3 (+100.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.39ms | 3.56ms | -0.17ms (-4.9%) | 🟡 |
| Worst Frame Build Time Millis | 7.15ms | 7.47ms | -0.32ms (-4.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.50ms | 11.15ms | -0.65ms (-5.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
