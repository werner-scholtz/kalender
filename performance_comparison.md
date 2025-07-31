## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 6.9%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 5.2%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 8.0%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 6.7%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 12.2%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 9.1%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 5.2%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 6.9%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 6.7%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 10.8%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.38ms | 4.11ms | +0.28ms (+6.7%) | 🟠 |
| Worst Frame Build Time Millis | 8.63ms | 8.09ms | +0.54ms (+6.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.21ms | 2.50ms | -0.29ms (-11.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.81ms | 5.11ms | -0.30ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 16.70ms | 19.58ms | -2.88ms (-14.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.74ms | 3.60ms | +0.14ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.76ms | +0.06ms (+8.0%) | 🟠 |
| Worst Frame Build Time Millis | 5.44ms | 5.32ms | +0.13ms (+2.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.08ms | 3.22ms | -0.13ms (-4.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 1.5 | +2 (+100.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.59ms | -0.03ms (-5.7%) | 🟢 |
| Worst Frame Build Time Millis | 3.62ms | 3.74ms | -0.12ms (-3.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.97ms | 5.02ms | -2.05ms (-40.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.26ms | 8.14ms | +0.12ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 23.57ms | 23.09ms | +0.48ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.86ms | 3.21ms | -0.35ms (-10.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.05ms | 6.03ms | +0.02ms (+0.3%) | 🟠 |
| Worst Frame Build Time Millis | 10.79ms | 11.20ms | -0.40ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.32ms | 3.21ms | +0.11ms (+3.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.85ms | 1.85ms | -0.00ms (-0.0%) | 🟡 |
| Worst Frame Build Time Millis | 25.24ms | 26.84ms | -1.60ms (-6.0%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.34ms | 3.68ms | -0.34ms (-9.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.17ms | +0.06ms (+5.2%) | 🟠 |
| Worst Frame Build Time Millis | 2.34ms | 2.23ms | +0.12ms (+5.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.04ms | 1.84ms | +0.20ms (+11.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.73ms | 2.55ms | +0.18ms (+6.9%) | 🟠 |
| Worst Frame Build Time Millis | 9.57ms | 8.96ms | +0.61ms (+6.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.25ms | 3.15ms | +0.09ms (+2.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.52ms | +0.04ms (+6.9%) | 🟠 |
| Worst Frame Build Time Millis | 2.82ms | 3.13ms | -0.30ms (-9.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.38ms | 2.31ms | +0.06ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.45ms | +0.05ms (+12.2%) | 🔴 |
| Worst Frame Build Time Millis | 1.58ms | 1.50ms | +0.08ms (+5.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.14ms | 1.87ms | +0.27ms (+14.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.78ms | +0.03ms (+3.2%) | 🟠 |
| Worst Frame Build Time Millis | 1.08ms | 1.68ms | -0.60ms (-35.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.79ms | 3.04ms | -0.25ms (-8.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.99ms | 10.08ms | +0.92ms (+9.1%) | 🟠 |
| Worst Frame Build Time Millis | 29.90ms | 27.53ms | +2.37ms (+8.6%) | 🟠 |
| Missed Frame Build Budget Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.36ms | 5.06ms | +0.30ms (+6.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.0 | +0 (+5.0%) | 🟠 |
| Old Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.32ms | 12.19ms | +0.13ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 46.94ms | 45.65ms | +1.29ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.17ms | 5.33ms | -0.16ms (-3.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.66ms | 1.67ms | -0.01ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 14.07ms | 13.50ms | +0.57ms (+4.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.56ms | 6.07ms | -1.51ms (-24.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.47ms | -0.02ms (-1.1%) | 🟡 |
| Worst Frame Build Time Millis | 12.69ms | 13.11ms | -0.42ms (-3.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.88ms | 6.26ms | -1.38ms (-22.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.14ms | 5.33ms | -0.19ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 28.74ms | 28.94ms | -0.20ms (-0.7%) | 🟡 |
| Missed Frame Build Budget Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.25ms | 3.04ms | +0.22ms (+7.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 10.0 | +1 (+10.0%) | 🟠 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 19.96ms | 19.48ms | +0.48ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 41.31ms | 41.40ms | -0.09ms (-0.2%) | 🟡 |
| Missed Frame Build Budget Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.27ms | 3.28ms | -0.01ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 12.0 | 11.0 | +1 (+9.1%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.89ms | 0.80ms | +0.09ms (+10.8%) | 🔴 |
| Worst Frame Build Time Millis | 13.39ms | 13.00ms | +0.40ms (+3.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.15ms | 4.46ms | -0.31ms (-7.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.34ms | 2.23ms | +0.11ms (+4.9%) | 🟠 |
| Worst Frame Build Time Millis | 8.30ms | 7.96ms | +0.34ms (+4.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.64ms | 3.27ms | +0.37ms (+11.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.88ms | 8.62ms | +0.26ms (+3.1%) | 🟠 |
| Worst Frame Build Time Millis | 42.86ms | 43.67ms | -0.81ms (-1.8%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.54ms | 5.20ms | +0.34ms (+6.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 10.0 | -2 (-20.0%) | 🟢 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.15ms | 1.12ms | +0.03ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 5.78ms | 6.84ms | -1.07ms (-15.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.72ms | 6.76ms | -1.04ms (-15.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.96ms | 0.91ms | +0.05ms (+5.2%) | 🟠 |
| Worst Frame Build Time Millis | 3.95ms | 3.80ms | +0.15ms (+4.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.75ms | 5.94ms | -1.19ms (-20.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.89ms | 0.83ms | +0.06ms (+6.7%) | 🟠 |
| Worst Frame Build Time Millis | 1.10ms | 1.25ms | -0.15ms (-11.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.69ms | 5.92ms | -0.23ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

</details>

