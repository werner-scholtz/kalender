## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 33.9%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 19.0%
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 17.1%
- 🔴 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 26.5%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 20.2%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 17.8%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 20.7%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 27.2%
- 🔴 **one_event_per_day-month-navigation**: Frame build time increased by 16.5%
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 41.4%
- 🔴 **ten_events_per_day-week-navigation**: Frame build time increased by 22.2%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 13.8%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 9.5%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 7.7%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 5.3%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 9.0%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 10.9%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 15.0%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 6.4%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 8.0%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.83ms | 2.38ms | +0.45ms (+19.0%) | 🔴 |
| Worst Frame Build Time Millis | 6.75ms | 5.66ms | +1.10ms (+19.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.79ms | 4.27ms | -0.48ms (-11.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.28ms | 4.53ms | +0.75ms (+16.5%) | 🔴 |
| Worst Frame Build Time Millis | 20.22ms | 14.21ms | +6.01ms (+42.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.01ms | 5.37ms | -0.35ms (-6.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.61ms | +0.06ms (+9.5%) | 🟠 |
| Worst Frame Build Time Millis | 5.55ms | 4.28ms | +1.26ms (+29.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.61ms | 5.43ms | +0.18ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.0 | -1 (-37.5%) | 🟢 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.43ms | +0.03ms (+8.0%) | 🟠 |
| Worst Frame Build Time Millis | 2.10ms | 1.97ms | +0.13ms (+6.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.75ms | 4.36ms | +0.39ms (+9.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.99ms | 9.89ms | -0.90ms (-9.1%) | 🟢 |
| Worst Frame Build Time Millis | 25.61ms | 28.52ms | -2.91ms (-10.2%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.64ms | 5.09ms | -1.45ms (-28.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.54ms | 6.26ms | +0.28ms (+4.6%) | 🟠 |
| Worst Frame Build Time Millis | 13.25ms | 12.99ms | +0.26ms (+2.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.03ms | 5.72ms | -0.69ms (-12.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.75 | 5.0 | +1 (+15.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.19ms | 2.03ms | +0.16ms (+7.7%) | 🟠 |
| Worst Frame Build Time Millis | 33.80ms | 23.97ms | +9.84ms (+41.0%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.75 | -1 (-42.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.11ms | 6.73ms | +0.39ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.25 | 4.5 | -0 (-5.6%) | 🟢 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.65ms | +0.11ms (+17.1%) | 🔴 |
| Worst Frame Build Time Millis | 2.02ms | 1.70ms | +0.33ms (+19.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.28ms | 14.06ms | +0.22ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.82ms | 2.48ms | +0.34ms (+13.8%) | 🔴 |
| Worst Frame Build Time Millis | 9.44ms | 8.01ms | +1.43ms (+17.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.87ms | 4.32ms | -0.45ms (-10.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.60ms | +0.01ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 2.75ms | 5.29ms | -2.54ms (-48.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.73ms | 5.61ms | -0.89ms (-15.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 4.5 | -4 (-94.4%) | 🟢 |
| New Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.47ms | +0.03ms (+6.4%) | 🟠 |
| Worst Frame Build Time Millis | 1.89ms | 1.87ms | +0.02ms (+1.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.91ms | 3.90ms | +0.02ms (+0.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.90ms | 1.61ms | +0.29ms (+17.8%) | 🔴 |
| Worst Frame Build Time Millis | 3.89ms | 2.21ms | +1.68ms (+75.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.57ms | 6.86ms | -0.30ms (-4.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |
| Old Gen Gc Count | 3.0 | 1.0 | +2 (+200.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.42ms | 6.29ms | +2.13ms (+33.9%) | 🔴 |
| Worst Frame Build Time Millis | 33.99ms | 25.33ms | +8.67ms (+34.2%) | 🔴 |
| Missed Frame Build Budget Count | 7.0 | 4.75 | +2 (+47.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.11ms | 7.24ms | -0.13ms (-1.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 11.0 | +1 (+9.1%) | 🟠 |
| Old Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.04ms | 10.64ms | +4.40ms (+41.4%) | 🔴 |
| Worst Frame Build Time Millis | 47.18ms | 33.92ms | +13.26ms (+39.1%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.04ms | 7.89ms | -0.84ms (-10.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.45ms | 1.21ms | +0.24ms (+20.2%) | 🔴 |
| Worst Frame Build Time Millis | 14.55ms | 13.11ms | +1.44ms (+11.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.01ms | 7.20ms | +1.81ms (+25.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 9.0 | 4.0 | +5 (+125.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.03ms | +0.28ms (+27.2%) | 🔴 |
| Worst Frame Build Time Millis | 8.77ms | 7.37ms | +1.40ms (+19.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.97ms | 7.83ms | +4.14ms (+52.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 3.0 | +2 (+50.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.03ms | 5.78ms | +0.25ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 34.85ms | 32.92ms | +1.93ms (+5.9%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.25 | +1 (+23.1%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.27ms | 5.45ms | -0.18ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 14.0 | +6 (+42.9%) | 🔴 |
| Old Gen Gc Count | 8.5 | 7.0 | +2 (+21.4%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.24ms | 21.32ms | +1.92ms (+9.0%) | 🟠 |
| Worst Frame Build Time Millis | 50.26ms | 48.53ms | +1.74ms (+3.6%) | 🟠 |
| Missed Frame Build Budget Count | 10.0 | 9.25 | +1 (+8.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.32ms | 6.21ms | -0.88ms (-14.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.0 | 19.5 | -4 (-17.9%) | 🟢 |
| Old Gen Gc Count | 10.0 | 11.0 | -1 (-9.1%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.94ms | 0.90ms | +0.05ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 21.58ms | 16.31ms | +5.27ms (+32.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.93ms | 7.22ms | -0.29ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 5.0 | 11.0 | -6 (-54.5%) | 🟢 |
| New Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.15ms | +0.31ms (+26.5%) | 🔴 |
| Worst Frame Build Time Millis | 7.35ms | 6.36ms | +0.99ms (+15.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.63ms | 5.95ms | -0.32ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 4.0 | 2.0 | +2 (+100.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.38ms | 6.86ms | +1.52ms (+22.2%) | 🔴 |
| Worst Frame Build Time Millis | 34.39ms | 29.76ms | +4.63ms (+15.6%) | 🔴 |
| Missed Frame Build Budget Count | 3.0 | 1.25 | +2 (+140.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.49ms | 8.19ms | -0.70ms (-8.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 1.04ms | +0.21ms (+20.7%) | 🔴 |
| Worst Frame Build Time Millis | 8.62ms | 6.65ms | +1.97ms (+29.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.96ms | 9.50ms | +1.47ms (+15.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 15.5 | 9.0 | +6 (+72.2%) | 🔴 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 1.0 | +3 (+300.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 0.79ms | +0.12ms (+15.0%) | 🔴 |
| Worst Frame Build Time Millis | 4.47ms | 2.90ms | +1.57ms (+54.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.50ms | 8.40ms | +0.10ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.63ms | 1.47ms | +0.16ms (+10.9%) | 🔴 |
| Worst Frame Build Time Millis | 2.41ms | 2.05ms | +0.37ms (+17.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.22ms | 8.12ms | +1.09ms (+13.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 1.0 | +2 (+200.0%) | 🔴 |

</details>

