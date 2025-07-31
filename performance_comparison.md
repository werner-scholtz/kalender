## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 6.5%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 10.3%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 11.9%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 15.9%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 12.6%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 12.6%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 12.3%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 16.7%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.11ms | 4.23ms | -0.12ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 8.09ms | 8.32ms | -0.23ms (-2.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.50ms | 1.88ms | +0.62ms (+32.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.11ms | 4.80ms | +0.31ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 19.58ms | 16.66ms | +2.91ms (+17.5%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 0.5 | +1 (+150.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.60ms | 3.77ms | -0.17ms (-4.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.82ms | -0.06ms (-7.3%) | 🟢 |
| Worst Frame Build Time Millis | 5.32ms | 4.27ms | +1.05ms (+24.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.22ms | 3.79ms | -0.58ms (-15.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 3.0 | -2 (-50.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.57ms | +0.02ms (+3.0%) | 🟠 |
| Worst Frame Build Time Millis | 3.74ms | 4.59ms | -0.85ms (-18.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.02ms | 3.84ms | +1.18ms (+30.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.14ms | 7.90ms | +0.23ms (+3.0%) | 🟠 |
| Worst Frame Build Time Millis | 23.09ms | 22.59ms | +0.50ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.21ms | 2.71ms | +0.51ms (+18.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.03ms | 5.97ms | +0.06ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 11.20ms | 10.80ms | +0.40ms (+3.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.21ms | 3.29ms | -0.08ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.85ms | 2.07ms | -0.21ms (-10.3%) | 🟢 |
| Worst Frame Build Time Millis | 26.84ms | 29.17ms | -2.33ms (-8.0%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.68ms | 4.17ms | -0.49ms (-11.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.17ms | 1.21ms | -0.04ms (-3.4%) | 🟡 |
| Worst Frame Build Time Millis | 2.23ms | 2.28ms | -0.05ms (-2.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.84ms | 2.01ms | -0.17ms (-8.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.55ms | 2.72ms | -0.17ms (-6.3%) | 🟢 |
| Worst Frame Build Time Millis | 8.96ms | 10.98ms | -2.02ms (-18.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.15ms | 3.23ms | -0.08ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.52ms | 0.57ms | -0.05ms (-8.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.13ms | 2.97ms | +0.15ms (+5.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.31ms | 2.93ms | -0.62ms (-21.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.45ms | 0.49ms | -0.05ms (-9.2%) | 🟢 |
| Worst Frame Build Time Millis | 1.50ms | 1.75ms | -0.25ms (-14.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.87ms | 2.01ms | -0.14ms (-7.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.78ms | 0.93ms | -0.16ms (-16.7%) | 🟢 |
| Worst Frame Build Time Millis | 1.68ms | 1.41ms | +0.28ms (+19.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.04ms | 4.07ms | -1.03ms (-25.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.08ms | 11.44ms | -1.37ms (-11.9%) | 🟢 |
| Worst Frame Build Time Millis | 27.53ms | 31.85ms | -4.32ms (-13.6%) | 🟢 |
| Missed Frame Build Budget Count | 8.0 | 8.25 | -0 (-3.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.06ms | 5.40ms | -0.34ms (-6.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.19ms | 12.19ms | +0.01ms (+0.0%) | 🟠 |
| Worst Frame Build Time Millis | 45.65ms | 43.22ms | +2.43ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.25 | -0 (-7.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.33ms | 5.35ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.67ms | 1.79ms | -0.12ms (-6.6%) | 🟢 |
| Worst Frame Build Time Millis | 13.50ms | 14.26ms | -0.75ms (-5.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.07ms | 6.21ms | -0.14ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.47ms | 1.55ms | -0.08ms (-4.9%) | 🟡 |
| Worst Frame Build Time Millis | 13.11ms | 13.86ms | -0.76ms (-5.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.26ms | 6.77ms | -0.51ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.33ms | 5.47ms | -0.14ms (-2.6%) | 🟡 |
| Worst Frame Build Time Millis | 28.94ms | 27.58ms | +1.36ms (+4.9%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.04ms | 3.24ms | -0.20ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.5 | -0 (-4.8%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 19.48ms | 19.31ms | +0.17ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 41.40ms | 42.19ms | -0.79ms (-1.9%) | 🟡 |
| Missed Frame Build Budget Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.28ms | 3.10ms | +0.18ms (+5.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 19.0 | -1 (-5.3%) | 🟢 |
| Old Gen Gc Count | 11.0 | 12.0 | -1 (-8.3%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.95ms | -0.15ms (-15.9%) | 🟢 |
| Worst Frame Build Time Millis | 13.00ms | 15.92ms | -2.92ms (-18.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.46ms | 5.70ms | -1.24ms (-21.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 5.0 | -2 (-40.0%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.23ms | 2.35ms | -0.12ms (-5.1%) | 🟢 |
| Worst Frame Build Time Millis | 7.96ms | 8.83ms | -0.87ms (-9.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.27ms | 3.48ms | -0.21ms (-6.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.62ms | 8.89ms | -0.27ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 43.67ms | 44.41ms | -0.74ms (-1.7%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.20ms | 5.38ms | -0.18ms (-3.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.12ms | 1.28ms | -0.16ms (-12.6%) | 🟢 |
| Worst Frame Build Time Millis | 6.84ms | 7.90ms | -1.06ms (-13.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.76ms | 7.22ms | -0.46ms (-6.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 3.0 | -2 (-66.7%) | 🟢 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 1.05ms | -0.13ms (-12.6%) | 🟢 |
| Worst Frame Build Time Millis | 3.80ms | 4.63ms | -0.83ms (-17.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.94ms | 5.75ms | +0.19ms (+3.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.83ms | 0.95ms | -0.12ms (-12.3%) | 🟢 |
| Worst Frame Build Time Millis | 1.25ms | 2.11ms | -0.86ms (-40.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.92ms | 6.22ms | -0.30ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>

