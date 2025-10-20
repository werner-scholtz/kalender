## 📋 Summary

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 18.6%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 15.6%
- 🟢 **ten_events_per_day-week-navigation**: Frame build time improved by 16.9%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 16.7%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 13.5%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 12.9%
- 🟢 **one_event_per_day-week-navigation**: Frame build time improved by 10.7%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 10.2%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 10.2%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.45ms | 2.90ms | -0.45ms (-15.6%) | 🟢 |
| Worst Frame Build Time Millis | 6.00ms | 6.84ms | -0.84ms (-12.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.44ms | 2.82ms | -0.38ms (-13.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.31ms | 4.66ms | -0.35ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 12.76ms | 13.86ms | -1.10ms (-7.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.26ms | 3.41ms | -0.15ms (-4.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.71ms | -0.05ms (-6.6%) | 🟢 |
| Worst Frame Build Time Millis | 4.50ms | 5.32ms | -0.82ms (-15.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.20ms | 4.12ms | +1.08ms (+26.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.75 | 3.75 | -2 (-53.3%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.49ms | +0.02ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 2.73ms | 2.11ms | +0.62ms (+29.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.22ms | 2.42ms | +2.79ms (+115.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.36ms | 9.74ms | -0.38ms (-3.9%) | 🟡 |
| Worst Frame Build Time Millis | 26.92ms | 27.71ms | -0.80ms (-2.9%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.20ms | 2.57ms | +0.63ms (+24.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.79ms | 7.85ms | -1.06ms (-13.5%) | 🟢 |
| Worst Frame Build Time Millis | 15.14ms | 16.59ms | -1.45ms (-8.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.00ms | 3.39ms | -0.39ms (-11.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 2.75 | 3.5 | -1 (-21.4%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.05ms | 2.24ms | -0.18ms (-8.2%) | 🟢 |
| Worst Frame Build Time Millis | 25.33ms | 30.92ms | -5.59ms (-18.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.5 | 1.25 | +0 (+20.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.55ms | 3.50ms | +1.05ms (+30.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 1.75 | +2 (+100.0%) | 🔴 |
| New Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |
| Old Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.73ms | -0.12ms (-16.7%) | 🟢 |
| Worst Frame Build Time Millis | 1.60ms | 1.89ms | -0.30ms (-15.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.24ms | 9.75ms | -0.51ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.52ms | 2.82ms | -0.30ms (-10.7%) | 🟢 |
| Worst Frame Build Time Millis | 8.24ms | 8.94ms | -0.70ms (-7.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.61ms | 2.89ms | -0.28ms (-9.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.53ms | -0.04ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.47ms | 2.24ms | +0.24ms (+10.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.92ms | 2.52ms | +1.40ms (+55.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.52ms | 0.53ms | -0.01ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 2.09ms | 1.95ms | +0.14ms (+7.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.87ms | 2.42ms | +1.45ms (+60.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.99ms | 2.09ms | -0.10ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 5.51ms | 5.18ms | +0.33ms (+6.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.07ms | 4.66ms | +0.41ms (+8.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.89ms | 6.56ms | -0.67ms (-10.2%) | 🟢 |
| Worst Frame Build Time Millis | 21.03ms | 24.41ms | -3.38ms (-13.8%) | 🟢 |
| Missed Frame Build Budget Count | 4.75 | 5.5 | -1 (-13.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.22ms | 4.68ms | -0.46ms (-9.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.5 | -1 (-9.5%) | 🟢 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.46ms | 11.50ms | -1.05ms (-9.1%) | 🟢 |
| Worst Frame Build Time Millis | 33.89ms | 37.25ms | -3.36ms (-9.0%) | 🟢 |
| Missed Frame Build Budget Count | 3.25 | 4.0 | -1 (-18.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.01ms | 5.02ms | -0.00ms (-0.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 5.5 | +2 (+27.3%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.38ms | 1.32ms | +0.05ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 7.40ms | 8.55ms | -1.15ms (-13.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.71ms | 4.64ms | +2.07ms (+44.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 2.25 | +2 (+100.0%) | 🔴 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.26ms | 1.30ms | -0.04ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 8.08ms | 7.56ms | +0.51ms (+6.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.05ms | 7.64ms | +2.41ms (+31.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.75 | 4.0 | +3 (+68.8%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.44ms | 6.06ms | -0.62ms (-10.2%) | 🟢 |
| Worst Frame Build Time Millis | 26.47ms | 32.76ms | -6.28ms (-19.2%) | 🟢 |
| Missed Frame Build Budget Count | 4.25 | 4.5 | -0 (-5.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 2.86ms | 3.17ms | -0.31ms (-9.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.5 | -0 (-4.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.59ms | 24.79ms | -3.20ms (-12.9%) | 🟢 |
| Worst Frame Build Time Millis | 45.47ms | 49.67ms | -4.20ms (-8.5%) | 🟢 |
| Missed Frame Build Budget Count | 9.25 | 10.75 | -2 (-14.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.07ms | 3.15ms | -0.08ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.01ms | 1.08ms | -0.07ms (-6.7%) | 🟢 |
| Worst Frame Build Time Millis | 20.65ms | 24.61ms | -3.96ms (-16.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.06ms | 3.52ms | +1.55ms (+43.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.12ms | 1.37ms | -0.26ms (-18.6%) | 🟢 |
| Worst Frame Build Time Millis | 5.58ms | 8.84ms | -3.26ms (-36.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.50ms | 4.06ms | -0.56ms (-13.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.16ms | 8.62ms | -1.45ms (-16.9%) | 🟢 |
| Worst Frame Build Time Millis | 28.42ms | 31.84ms | -3.42ms (-10.7%) | 🟢 |
| Missed Frame Build Budget Count | 2.0 | 3.25 | -1 (-38.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.14ms | 5.84ms | -0.70ms (-12.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.99ms | 0.97ms | +0.02ms (+2.1%) | 🟠 |
| Worst Frame Build Time Millis | 5.51ms | 6.55ms | -1.04ms (-15.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.80ms | 5.93ms | +0.87ms (+14.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 8.0 | -6 (-81.2%) | 🟢 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.32ms | 1.31ms | +0.01ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 7.04ms | 6.38ms | +0.66ms (+10.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.96ms | 10.11ms | -1.15ms (-11.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 6.25 | -2 (-40.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.68ms | 1.82ms | -0.14ms (-7.6%) | 🟢 |
| Worst Frame Build Time Millis | 4.06ms | 2.83ms | +1.23ms (+43.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.68ms | 6.39ms | +0.29ms (+4.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

