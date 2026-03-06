## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 17.8%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 20.5%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 24.8%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 33.6%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 16.3%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 32.6%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 11.8%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 14.6%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 13.6%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 31.2%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 12.4%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 13.3%
- 🟢 **one_event_per_day-week-navigation**: Frame build time improved by 16.2%
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 11.3%
- 🟢 **ten_events_per_day-week-navigation**: Frame build time improved by 13.2%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 10.5%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 26.5%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 25.1%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 12.4%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 20.2%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 16.1%
- 🟢 **one_event_per_day-month-navigation**: Frame build time improved by 13.3%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.48ms | 3.29ms | -0.82ms (-24.8%) | 🟢 |
| Worst Frame Build Time Millis | 6.13ms | 8.22ms | -2.10ms (-25.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.97ms | 4.27ms | +0.70ms (+16.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.80ms | 5.53ms | -0.74ms (-13.3%) | 🟢 |
| Worst Frame Build Time Millis | 17.00ms | 20.28ms | -3.28ms (-16.2%) | 🟢 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.48ms | 5.64ms | -0.17ms (-3.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.65ms | 0.82ms | -0.17ms (-20.2%) | 🟢 |
| Worst Frame Build Time Millis | 2.68ms | 3.15ms | -0.47ms (-15.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.41ms | 5.20ms | +0.21ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.5 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 3.5 | +1 (+28.6%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.75ms | -0.25ms (-33.6%) | 🟢 |
| Worst Frame Build Time Millis | 1.76ms | 2.53ms | -0.77ms (-30.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.54ms | 5.01ms | -0.47ms (-9.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.62ms | 12.12ms | -1.51ms (-12.4%) | 🟢 |
| Worst Frame Build Time Millis | 30.49ms | 33.60ms | -3.12ms (-9.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.48ms | 5.36ms | +0.12ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.04ms | 7.87ms | -0.83ms (-10.5%) | 🟢 |
| Worst Frame Build Time Millis | 13.46ms | 14.60ms | -1.14ms (-7.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.73ms | 6.83ms | -0.10ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.03ms | 2.77ms | -0.73ms (-26.5%) | 🟢 |
| Worst Frame Build Time Millis | 28.55ms | 28.79ms | -0.23ms (-0.8%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.61ms | 6.28ms | +0.33ms (+5.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |
| Old Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.58ms | 0.85ms | -0.26ms (-31.2%) | 🟢 |
| Worst Frame Build Time Millis | 1.50ms | 2.20ms | -0.70ms (-31.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.87ms | 4.32ms | -0.45ms (-10.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.63ms | 3.13ms | -0.51ms (-16.2%) | 🟢 |
| Worst Frame Build Time Millis | 8.71ms | 10.11ms | -1.40ms (-13.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.22ms | 4.20ms | +0.02ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.87ms | -0.18ms (-20.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.58ms | 4.16ms | -0.58ms (-13.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.50ms | 4.53ms | -0.03ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.77ms | -0.19ms (-25.1%) | 🟢 |
| Worst Frame Build Time Millis | 1.84ms | 2.97ms | -1.14ms (-38.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.43ms | 4.39ms | +0.05ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.06ms | 2.16ms | -0.10ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 4.97ms | 4.75ms | +0.22ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.70ms | 5.87ms | -0.17ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.52ms | 7.44ms | -0.92ms (-12.4%) | 🟢 |
| Worst Frame Build Time Millis | 24.59ms | 23.84ms | +0.74ms (+3.1%) | 🟠 |
| Missed Frame Build Budget Count | 4.25 | 6.75 | -2 (-37.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.85ms | 8.68ms | +0.17ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.30ms | 14.98ms | -1.69ms (-11.3%) | 🟢 |
| Worst Frame Build Time Millis | 40.35ms | 47.05ms | -6.70ms (-14.2%) | 🟢 |
| Missed Frame Build Budget Count | 3.75 | 4.0 | -0 (-6.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.23ms | 9.37ms | -0.15ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.54ms | -0.25ms (-16.3%) | 🟢 |
| Worst Frame Build Time Millis | 7.55ms | 8.45ms | -0.90ms (-10.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.32ms | 7.84ms | +0.48ms (+6.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 7.25 | 4.0 | +3 (+81.2%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 1.77ms | -0.58ms (-32.6%) | 🟢 |
| Worst Frame Build Time Millis | 5.42ms | 7.18ms | -1.76ms (-24.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.08ms | 7.61ms | -0.53ms (-7.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.09ms | 5.87ms | -0.78ms (-13.3%) | 🟢 |
| Worst Frame Build Time Millis | 23.13ms | 26.38ms | -3.25ms (-12.3%) | 🟢 |
| Missed Frame Build Budget Count | 2.75 | 4.25 | -2 (-35.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.62ms | 6.55ms | +0.07ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 4.5 | +2 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.03ms | 25.08ms | -4.05ms (-16.1%) | 🟢 |
| Worst Frame Build Time Millis | 39.92ms | 47.52ms | -7.60ms (-16.0%) | 🟢 |
| Missed Frame Build Budget Count | 8.75 | 9.0 | -0 (-2.8%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.38ms | 7.53ms | -0.15ms (-2.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 15.0 | 14.0 | +1 (+7.1%) | 🟠 |
| Old Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.54ms | -0.21ms (-13.6%) | 🟢 |
| Worst Frame Build Time Millis | 16.63ms | 21.98ms | -5.35ms (-24.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.96ms | 7.13ms | -0.17ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.09ms | 1.28ms | -0.19ms (-14.6%) | 🟢 |
| Worst Frame Build Time Millis | 6.00ms | 6.87ms | -0.87ms (-12.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.71ms | 6.52ms | +0.19ms (+2.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.37ms | 8.49ms | -1.12ms (-13.2%) | 🟢 |
| Worst Frame Build Time Millis | 27.49ms | 28.09ms | -0.59ms (-2.1%) | 🟡 |
| Missed Frame Build Budget Count | 1.75 | 3.0 | -1 (-41.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.49ms | 9.21ms | +0.28ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.38ms | -0.16ms (-11.8%) | 🟢 |
| Worst Frame Build Time Millis | 6.45ms | 5.42ms | +1.03ms (+19.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.29ms | 10.96ms | -0.66ms (-6.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 13.0 | 21.25 | -8 (-38.8%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.39ms | -0.08ms (-5.4%) | 🟢 |
| Worst Frame Build Time Millis | 4.31ms | 7.65ms | -3.34ms (-43.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.84ms | 10.73ms | +2.11ms (+19.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.25 | 3.5 | -0 (-7.1%) | 🟢 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.21ms | 3.57ms | +0.64ms (+17.8%) | 🔴 |
| Worst Frame Build Time Millis | 8.62ms | 9.56ms | -0.94ms (-9.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.27ms | 10.03ms | +0.24ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

</details>

