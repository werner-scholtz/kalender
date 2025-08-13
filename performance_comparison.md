## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 95.7%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 128.7%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 71.6%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 8.2%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 8.5%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 6.2%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 11.7%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 10.8%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 14.8%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.12ms | 4.24ms | -0.12ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 8.10ms | 8.34ms | -0.24ms (-2.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.23ms | 2.31ms | -0.08ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.72ms | 4.63ms | +0.09ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 17.53ms | 16.51ms | +1.02ms (+6.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.75ms | 3.78ms | -0.03ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.94ms | 0.82ms | +0.12ms (+14.8%) | 🔴 |
| Worst Frame Build Time Millis | 7.20ms | 6.31ms | +0.89ms (+14.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.79ms | 4.28ms | +0.51ms (+11.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.25 | 1.25 | +2 (+160.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.75 | 2.5 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.57ms | +0.05ms (+8.5%) | 🟠 |
| Worst Frame Build Time Millis | 3.74ms | 3.68ms | +0.06ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.84ms | 4.75ms | -0.91ms (-19.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.17ms | 7.99ms | +0.18ms (+2.3%) | 🟠 |
| Worst Frame Build Time Millis | 23.48ms | 22.84ms | +0.64ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.60ms | 3.16ms | -0.56ms (-17.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.00ms | 5.92ms | +0.08ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 10.72ms | 10.83ms | -0.11ms (-1.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.21ms | 3.28ms | -0.07ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.91ms | 1.84ms | +0.06ms (+3.5%) | 🟠 |
| Worst Frame Build Time Millis | 24.41ms | 23.91ms | +0.51ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.95ms | 4.92ms | +0.03ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 2.75 | -2 (-81.8%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.23ms | -0.02ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 2.30ms | 2.33ms | -0.03ms (-1.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.15ms | 1.90ms | +0.25ms (+12.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.83ms | 2.61ms | +0.22ms (+8.2%) | 🟠 |
| Worst Frame Build Time Millis | 9.32ms | 9.52ms | -0.20ms (-2.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.56ms | 3.12ms | +0.44ms (+14.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.54ms | +0.06ms (+10.8%) | 🔴 |
| Worst Frame Build Time Millis | 2.43ms | 2.64ms | -0.21ms (-8.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.05ms | 3.34ms | -0.29ms (-8.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.84ms | 0.49ms | +0.35ms (+71.6%) | 🔴 |
| Worst Frame Build Time Millis | 4.72ms | 1.80ms | +2.92ms (+162.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.39ms | 2.72ms | +2.67ms (+98.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.91ms | 0.83ms | +1.07ms (+128.7%) | 🔴 |
| Worst Frame Build Time Millis | 4.82ms | 1.23ms | +3.59ms (+291.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.21ms | 3.35ms | +1.86ms (+55.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 2.5 | +4 (+140.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.37ms | 10.00ms | +0.37ms (+3.7%) | 🟠 |
| Worst Frame Build Time Millis | 28.17ms | 28.91ms | -0.74ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 8.5 | 7.75 | +1 (+9.7%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.22ms | 5.09ms | +0.13ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 10.5 | +2 (+14.3%) | 🔴 |
| Old Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.67ms | 12.60ms | -0.93ms (-7.3%) | 🟢 |
| Worst Frame Build Time Millis | 42.13ms | 47.03ms | -4.90ms (-10.4%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.15ms | 5.03ms | +0.12ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.72ms | 1.64ms | +0.07ms (+4.5%) | 🟠 |
| Worst Frame Build Time Millis | 13.28ms | 12.99ms | +0.28ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.04ms | 6.73ms | +0.31ms (+4.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.76ms | 1.73ms | +0.03ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 15.11ms | 17.70ms | -2.60ms (-14.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.61ms | 8.05ms | +0.56ms (+7.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.07ms | 5.16ms | -0.09ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 27.26ms | 29.43ms | -2.17ms (-7.4%) | 🟢 |
| Missed Frame Build Budget Count | 2.25 | 2.5 | -0 (-10.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.13ms | 3.10ms | +0.03ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 19.49ms | 19.40ms | +0.08ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 41.54ms | 40.93ms | +0.62ms (+1.5%) | 🟠 |
| Missed Frame Build Budget Count | 8.75 | 8.25 | +0 (+6.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.38ms | 3.24ms | +0.14ms (+4.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.5 | 17.5 | +1 (+5.7%) | 🟠 |
| Old Gen Gc Count | 10.5 | 12.0 | -2 (-12.5%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.87ms | 0.85ms | +0.02ms (+2.9%) | 🟠 |
| Worst Frame Build Time Millis | 13.40ms | 12.45ms | +0.95ms (+7.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.27ms | 5.37ms | -0.10ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.25 | 2.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.20ms | 2.25ms | -0.05ms (-2.2%) | 🟡 |
| Worst Frame Build Time Millis | 8.38ms | 8.60ms | -0.22ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.75ms | 3.41ms | +0.34ms (+9.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.39ms | 8.75ms | -0.36ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 37.40ms | 42.63ms | -5.23ms (-12.3%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.60ms | 5.27ms | +0.34ms (+6.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.18ms | 1.11ms | +0.07ms (+6.2%) | 🟠 |
| Worst Frame Build Time Millis | 6.10ms | 7.32ms | -1.22ms (-16.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.32ms | 7.68ms | +0.63ms (+8.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.75 | 6.25 | -2 (-24.0%) | 🟢 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.41ms | 1.26ms | +0.15ms (+11.7%) | 🔴 |
| Worst Frame Build Time Millis | 8.19ms | 6.56ms | +1.62ms (+24.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.20ms | 9.34ms | +0.85ms (+9.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 5.75 | 5.0 | +1 (+15.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.73ms | 0.89ms | +0.85ms (+95.7%) | 🔴 |
| Worst Frame Build Time Millis | 4.61ms | 1.56ms | +3.05ms (+194.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.77ms | 6.89ms | -0.12ms (-1.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 6.5 | +2 (+23.1%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

</details>

