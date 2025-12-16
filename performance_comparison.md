## 📋 Summary

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 14.4%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 16.7%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 15.8%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 16.7%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 11.0%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 12.1%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 18.7%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 10.7%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 28.4%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 18.8%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 10.2%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 26.6%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 20.7%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 32.5%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.38ms | 2.53ms | -0.16ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 5.66ms | 6.13ms | -0.47ms (-7.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.27ms | 3.90ms | +0.37ms (+9.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.53ms | 4.73ms | -0.20ms (-4.2%) | 🟡 |
| Worst Frame Build Time Millis | 14.21ms | 14.42ms | -0.21ms (-1.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.37ms | 5.11ms | +0.26ms (+5.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.75ms | -0.14ms (-18.8%) | 🟢 |
| Worst Frame Build Time Millis | 4.28ms | 4.28ms | +0.01ms (+0.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.43ms | 5.11ms | +0.32ms (+6.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.43ms | 0.51ms | -0.07ms (-14.4%) | 🟢 |
| Worst Frame Build Time Millis | 1.97ms | 2.60ms | -0.63ms (-24.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.36ms | 4.66ms | -0.30ms (-6.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.89ms | 9.76ms | +0.13ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 28.52ms | 27.82ms | +0.71ms (+2.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.09ms | 4.06ms | +1.02ms (+25.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.26ms | 6.78ms | -0.52ms (-7.7%) | 🟢 |
| Worst Frame Build Time Millis | 12.99ms | 13.45ms | -0.46ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.72ms | 5.39ms | +0.33ms (+6.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.03ms | 2.41ms | -0.38ms (-15.8%) | 🟢 |
| Worst Frame Build Time Millis | 23.97ms | 35.02ms | -11.05ms (-31.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.75 | 1.5 | +0 (+16.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.73ms | 6.10ms | +0.63ms (+10.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 1.25 | +3 (+260.0%) | 🔴 |
| New Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.65ms | 0.73ms | -0.07ms (-10.2%) | 🟢 |
| Worst Frame Build Time Millis | 1.70ms | 1.91ms | -0.21ms (-11.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.06ms | 14.16ms | -0.10ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.48ms | 2.70ms | -0.23ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 8.01ms | 11.02ms | -3.02ms (-27.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.32ms | 3.89ms | +0.43ms (+11.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.74ms | -0.14ms (-18.7%) | 🟢 |
| Worst Frame Build Time Millis | 5.29ms | 4.30ms | +0.99ms (+23.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.61ms | 5.17ms | +0.44ms (+8.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.5 | 0.75 | +4 (+500.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.64ms | -0.17ms (-26.6%) | 🟢 |
| Worst Frame Build Time Millis | 1.87ms | 3.54ms | -1.67ms (-47.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.90ms | 4.46ms | -0.57ms (-12.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.61ms | 2.03ms | -0.42ms (-20.7%) | 🟢 |
| Worst Frame Build Time Millis | 2.21ms | 5.93ms | -3.72ms (-62.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.86ms | 5.41ms | +1.45ms (+26.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.29ms | 6.45ms | -0.17ms (-2.6%) | 🟡 |
| Worst Frame Build Time Millis | 25.33ms | 22.54ms | +2.79ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 4.75 | 6.75 | -2 (-29.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.24ms | 6.61ms | +0.62ms (+9.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.64ms | 10.91ms | -0.28ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 33.92ms | 34.45ms | -0.52ms (-1.5%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.25 | -0 (-7.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.89ms | 6.77ms | +1.12ms (+16.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.69ms | -0.48ms (-28.4%) | 🟢 |
| Worst Frame Build Time Millis | 13.11ms | 9.92ms | +3.19ms (+32.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.20ms | 8.40ms | -1.20ms (-14.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.0 | 9.75 | -6 (-59.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 1.12ms | -0.09ms (-8.2%) | 🟢 |
| Worst Frame Build Time Millis | 7.37ms | 6.85ms | +0.51ms (+7.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.83ms | 10.14ms | -2.31ms (-22.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.0 | 7.5 | -4 (-60.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.78ms | 6.31ms | -0.53ms (-8.5%) | 🟢 |
| Worst Frame Build Time Millis | 32.92ms | 36.03ms | -3.11ms (-8.6%) | 🟢 |
| Missed Frame Build Budget Count | 3.25 | 4.25 | -1 (-23.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.45ms | 5.30ms | +0.15ms (+2.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.32ms | 24.26ms | -2.94ms (-12.1%) | 🟢 |
| Worst Frame Build Time Millis | 48.53ms | 44.12ms | +4.41ms (+10.0%) | 🟠 |
| Missed Frame Build Budget Count | 9.25 | 10.0 | -1 (-7.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.21ms | 5.38ms | +0.83ms (+15.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.5 | 16.5 | +3 (+18.2%) | 🔴 |
| Old Gen Gc Count | 11.0 | 10.0 | +1 (+10.0%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.90ms | 1.00ms | -0.11ms (-10.7%) | 🟢 |
| Worst Frame Build Time Millis | 16.31ms | 15.76ms | +0.55ms (+3.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.22ms | 8.81ms | -1.59ms (-18.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 11.0 | 13.0 | -2 (-15.4%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 7.0 | -2 (-21.4%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.15ms | 1.38ms | -0.23ms (-16.7%) | 🟢 |
| Worst Frame Build Time Millis | 6.36ms | 7.09ms | -0.73ms (-10.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.95ms | 5.52ms | +0.42ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.86ms | 7.06ms | -0.20ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 29.76ms | 29.04ms | +0.72ms (+2.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 2.25 | -1 (-44.4%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.19ms | 7.78ms | +0.41ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.5 | -1 (-15.4%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.04ms | 1.25ms | -0.21ms (-16.7%) | 🟢 |
| Worst Frame Build Time Millis | 6.65ms | 7.90ms | -1.25ms (-15.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.50ms | 7.94ms | +1.55ms (+19.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 9.0 | 2.5 | +6 (+260.0%) | 🔴 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 1.17ms | -0.38ms (-32.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.90ms | 4.89ms | -1.99ms (-40.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.40ms | 8.06ms | +0.34ms (+4.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.47ms | 1.65ms | -0.18ms (-11.0%) | 🟢 |
| Worst Frame Build Time Millis | 2.05ms | 4.47ms | -2.42ms (-54.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.12ms | 8.32ms | -0.20ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

</details>

