## 📋 Summary

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 14.4%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 13.7%
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 10.2%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 24.0%
- 🟢 **one_event_per_day-week-navigation**: Frame build time improved by 15.7%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 18.4%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 12.3%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 17.9%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 16.0%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 11.1%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 17.5%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 23.8%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 17.4%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 10.3%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 14.5%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 19.2%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 22.6%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.95ms | 3.21ms | -0.25ms (-7.9%) | 🟢 |
| Worst Frame Build Time Millis | 7.07ms | 7.48ms | -0.40ms (-5.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.60ms | 4.50ms | -0.90ms (-19.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.48ms | 5.61ms | -0.13ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 20.21ms | 19.99ms | +0.22ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.07ms | 5.53ms | -0.46ms (-8.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.74ms | 0.90ms | -0.17ms (-18.4%) | 🟢 |
| Worst Frame Build Time Millis | 5.05ms | 5.66ms | -0.61ms (-10.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.21ms | 6.13ms | +0.08ms (+1.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 4.25 | -4 (-94.1%) | 🟢 |
| New Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.66ms | -0.16ms (-23.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.28ms | 2.88ms | -0.60ms (-20.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.84ms | 7.83ms | -2.99ms (-38.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.03ms | 10.29ms | -1.27ms (-12.3%) | 🟢 |
| Worst Frame Build Time Millis | 25.65ms | 29.30ms | -3.65ms (-12.5%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.05ms | 4.71ms | -0.67ms (-14.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.86ms | 7.30ms | -0.44ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 13.98ms | 14.46ms | -0.48ms (-3.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.26ms | 5.60ms | -0.33ms (-5.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.25 | +1 (+14.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.27ms | 2.75ms | -0.48ms (-17.4%) | 🟢 |
| Worst Frame Build Time Millis | 30.14ms | 30.34ms | -0.20ms (-0.7%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.85ms | 8.95ms | -1.10ms (-12.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 12.25 | -12 (-95.9%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.74ms | 0.87ms | -0.13ms (-14.4%) | 🟢 |
| Worst Frame Build Time Millis | 1.95ms | 2.28ms | -0.33ms (-14.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.18ms | 16.54ms | -2.36ms (-14.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.86ms | 3.39ms | -0.53ms (-15.7%) | 🟢 |
| Worst Frame Build Time Millis | 9.59ms | 13.53ms | -3.95ms (-29.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.89ms | 4.52ms | -0.63ms (-13.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.83ms | -0.13ms (-16.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.22ms | 5.22ms | -2.00ms (-38.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.09ms | 6.28ms | -1.19ms (-19.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 6.25 | -6 (-96.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.73ms | -0.10ms (-13.7%) | 🟢 |
| Worst Frame Build Time Millis | 3.44ms | 4.21ms | -0.78ms (-18.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.32ms | 5.01ms | -0.69ms (-13.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.11ms | 2.13ms | -0.02ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 7.11ms | 4.50ms | +2.61ms (+58.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.46ms | 6.22ms | +0.24ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.34ms | 9.30ms | -0.96ms (-10.3%) | 🟢 |
| Worst Frame Build Time Millis | 36.06ms | 36.68ms | -0.62ms (-1.7%) | 🟡 |
| Missed Frame Build Budget Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.90ms | 7.84ms | -0.93ms (-11.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 13.5 | -2 (-11.1%) | 🟢 |
| Old Gen Gc Count | 7.5 | 9.0 | -2 (-16.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.77ms | 16.44ms | -1.67ms (-10.2%) | 🟢 |
| Worst Frame Build Time Millis | 47.18ms | 49.68ms | -2.50ms (-5.0%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.09ms | 7.72ms | -0.63ms (-8.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.63ms | 1.99ms | -0.36ms (-17.9%) | 🟢 |
| Worst Frame Build Time Millis | 13.26ms | 14.69ms | -1.43ms (-9.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.14ms | 9.84ms | +0.30ms (+3.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 6.5 | 13.25 | -7 (-50.9%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.31ms | -0.02ms (-1.6%) | 🟡 |
| Worst Frame Build Time Millis | 8.23ms | 8.62ms | -0.40ms (-4.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.29ms | 8.44ms | +2.85ms (+33.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 1.5 | +3 (+200.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.01ms | 6.62ms | -0.61ms (-9.2%) | 🟢 |
| Worst Frame Build Time Millis | 33.49ms | 36.77ms | -3.28ms (-8.9%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 5.75 | -2 (-39.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.36ms | 5.67ms | -0.31ms (-5.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 19.0 | +1 (+5.3%) | 🟠 |
| Old Gen Gc Count | 9.5 | 6.5 | +3 (+46.2%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.31ms | 27.25ms | -3.94ms (-14.5%) | 🟢 |
| Worst Frame Build Time Millis | 45.98ms | 52.06ms | -6.09ms (-11.7%) | 🟢 |
| Missed Frame Build Budget Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.29ms | 6.60ms | -1.31ms (-19.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.0 | 18.0 | -2 (-11.1%) | 🟢 |
| Old Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.98ms | 1.29ms | -0.31ms (-24.0%) | 🟢 |
| Worst Frame Build Time Millis | 21.28ms | 20.00ms | +1.28ms (+6.4%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 2.25 | -1 (-55.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.22ms | 9.07ms | -0.85ms (-9.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 6.25 | 15.0 | -9 (-58.3%) | 🟢 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.65ms | -0.18ms (-11.1%) | 🟢 |
| Worst Frame Build Time Millis | 7.20ms | 8.42ms | -1.22ms (-14.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.71ms | 6.51ms | -0.80ms (-12.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.75ms | 9.02ms | -0.27ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 34.53ms | 37.39ms | -2.86ms (-7.6%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.70ms | 8.28ms | -0.58ms (-7.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.5 | -2 (-15.8%) | 🟢 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.63ms | -0.31ms (-19.2%) | 🟢 |
| Worst Frame Build Time Millis | 8.85ms | 12.47ms | -3.61ms (-29.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 11.22ms | 11.32ms | -0.10ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 15.5 | 20.75 | -5 (-25.3%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 1.25ms | -0.22ms (-17.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.99ms | 5.33ms | -1.33ms (-25.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.94ms | 8.75ms | +1.19ms (+13.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.51ms | 1.95ms | -0.44ms (-22.6%) | 🟢 |
| Worst Frame Build Time Millis | 2.19ms | 3.31ms | -1.13ms (-34.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.55ms | 9.27ms | -0.72ms (-7.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 9.5 | -2 (-15.8%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

