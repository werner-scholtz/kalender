## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 49.5%
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 60.0%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 25.5%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 13.1%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 11.5%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 11.3%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 11.7%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 5.7%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.13ms | 0.13ms | +0.00ms (+0.0%) | 🟡 |
| Worst Frame Build Time Millis | 0.13ms | 0.13ms | +0.00ms (+0.0%) | 🟡 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.74ms | 2.04ms | -0.30ms (-14.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.41ms | 5.20ms | +0.20ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 23.09ms | 20.98ms | +2.11ms (+10.0%) | 🔴 |
| Missed Frame Build Budget Count | 2 | 2 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.99ms | 5.59ms | +0.40ms (+7.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1 | 1 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4 | 4 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4 | 4 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.86ms | 0.85ms | +0.01ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 4.35ms | 4.72ms | -0.38ms (-7.9%) | 🟢 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.80ms | 2.68ms | +0.12ms (+4.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1 | 1 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.67ms | +0.09ms (+13.1%) | 🔴 |
| Worst Frame Build Time Millis | 3.77ms | 3.50ms | +0.27ms (+7.7%) | 🟠 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.54ms | 2.46ms | +0.08ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.10ms | 0.12ms | -0.01ms (-9.6%) | 🟢 |
| Worst Frame Build Time Millis | 0.10ms | 0.12ms | -0.01ms (-9.6%) | 🟢 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.35ms | 1.76ms | -0.41ms (-23.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.83ms | 5.77ms | +0.06ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 10.93ms | 10.53ms | +0.40ms (+3.8%) | 🟠 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.21ms | 3.18ms | +0.03ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6 | 6 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.11ms | +0.12ms (+11.3%) | 🔴 |
| Worst Frame Build Time Millis | 23.48ms | 22.34ms | +1.14ms (+5.1%) | 🟠 |
| Missed Frame Build Budget Count | 1 | 1 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.69ms | 2.60ms | +1.09ms (+41.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4 | 4 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.16ms | 0.10ms | +0.06ms (+60.0%) | 🔴 |
| Worst Frame Build Time Millis | 0.16ms | 0.10ms | +0.06ms (+60.0%) | 🔴 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.19ms | 1.73ms | +0.47ms (+26.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.71ms | 2.64ms | +0.07ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 8.89ms | 9.26ms | -0.37ms (-4.0%) | 🟡 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.09ms | 5.00ms | +0.08ms (+1.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1 | 1 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6 | 6 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.56ms | +0.00ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 1.70ms | 1.85ms | -0.15ms (-8.1%) | 🟢 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.80ms | 2.42ms | +0.38ms (+15.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1 | 1 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.52ms | 0.56ms | -0.03ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 1.40ms | 1.58ms | -0.18ms (-11.6%) | 🟢 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.87ms | 1.92ms | -0.05ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.95ms | 0.64ms | +0.32ms (+49.5%) | 🔴 |
| Worst Frame Build Time Millis | 2.45ms | 0.95ms | +1.50ms (+158.0%) | 🔴 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.39ms | 3.85ms | +2.54ms (+66.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1 | 1 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.38ms | 15.15ms | +0.22ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 25.14ms | 24.26ms | +0.88ms (+3.6%) | 🟠 |
| Missed Frame Build Budget Count | 5 | 5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.00ms | 4.87ms | +0.13ms (+2.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12 | 12 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6 | 6 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.22ms | 10.97ms | +0.25ms (+2.3%) | 🟠 |
| Worst Frame Build Time Millis | 38.90ms | 37.62ms | +1.28ms (+3.4%) | 🟠 |
| Missed Frame Build Budget Count | 3 | 2 | +1 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.88ms | 4.31ms | +0.57ms (+13.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10 | 10 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4 | 4 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.40ms | 2.27ms | +0.13ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 13.41ms | 13.78ms | -0.38ms (-2.7%) | 🟡 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.67ms | 4.64ms | +2.03ms (+43.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4 | 4 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.99ms | 1.91ms | +0.08ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 11.87ms | 12.07ms | -0.20ms (-1.7%) | 🟡 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.71ms | 3.64ms | +2.08ms (+57.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.88ms | 6.99ms | -0.11ms (-1.6%) | 🟡 |
| Worst Frame Build Time Millis | 30.15ms | 30.32ms | -0.18ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 1 | 1 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.29ms | 3.40ms | -0.11ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12 | 12 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6 | 6 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 17.88ms | 17.85ms | +0.03ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 39.87ms | 37.36ms | +2.51ms (+6.7%) | 🟠 |
| Missed Frame Build Budget Count | 9 | 8 | +1 (+12.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 2.75ms | 2.91ms | -0.15ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16 | 16 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 14 | 14 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.72ms | +0.03ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 11.11ms | 11.09ms | +0.02ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.59ms | 2.69ms | +0.90ms (+33.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4 | 4 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.59ms | 3.61ms | -0.01ms (-0.4%) | 🟡 |
| Worst Frame Build Time Millis | 5.30ms | 5.25ms | +0.05ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.77ms | 5.94ms | -0.17ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1 | 1 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4 | 4 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.53ms | 8.99ms | -0.45ms (-5.1%) | 🟢 |
| Worst Frame Build Time Millis | 45.81ms | 49.45ms | -3.64ms (-7.4%) | 🟢 |
| Missed Frame Build Budget Count | 3 | 3 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.07ms | 5.21ms | -0.15ms (-2.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12 | 12 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8 | 8 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 0.98ms | +0.25ms (+25.5%) | 🔴 |
| Worst Frame Build Time Millis | 4.29ms | 4.37ms | -0.08ms (-1.9%) | 🟡 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.23ms | 4.23ms | +2.00ms (+47.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.08ms | 0.97ms | +0.11ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 3.08ms | 3.07ms | +0.01ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.92ms | 4.38ms | +1.54ms (+35.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0 | 0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 0.70ms | +0.08ms (+11.7%) | 🔴 |
| Worst Frame Build Time Millis | 1.02ms | 1.05ms | -0.02ms (-2.4%) | 🟡 |
| Missed Frame Build Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.23ms | 4.64ms | +2.58ms (+55.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6 | 6 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2 | 2 | +0 (+0.0%) | 🟡 |

</details>

