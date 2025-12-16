## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 13.4%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 8.5%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 5.7%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 8.4%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 15.3%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.53ms | 2.61ms | -0.07ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 6.13ms | 6.41ms | -0.28ms (-4.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.90ms | 3.69ms | +0.21ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.73ms | 4.89ms | -0.16ms (-3.3%) | 🟡 |
| Worst Frame Build Time Millis | 14.42ms | 14.88ms | -0.46ms (-3.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.11ms | 5.14ms | -0.02ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.80ms | -0.05ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 4.28ms | 5.24ms | -0.96ms (-18.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.11ms | 5.68ms | -0.58ms (-10.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.56ms | -0.05ms (-9.3%) | 🟢 |
| Worst Frame Build Time Millis | 2.60ms | 3.72ms | -1.12ms (-30.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.66ms | 5.10ms | -0.44ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.76ms | 10.35ms | -0.59ms (-5.7%) | 🟢 |
| Worst Frame Build Time Millis | 27.82ms | 29.61ms | -1.80ms (-6.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.06ms | 4.48ms | -0.41ms (-9.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.78ms | 6.70ms | +0.08ms (+1.1%) | 🟠 |
| Worst Frame Build Time Millis | 13.45ms | 14.48ms | -1.03ms (-7.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.39ms | 5.33ms | +0.06ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.41ms | 2.33ms | +0.08ms (+3.5%) | 🟠 |
| Worst Frame Build Time Millis | 35.02ms | 28.37ms | +6.65ms (+23.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.10ms | 6.28ms | -0.18ms (-2.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.25 | 1.5 | -0 (-16.7%) | 🟢 |
| New Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.70ms | +0.02ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 1.91ms | 1.85ms | +0.06ms (+3.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.16ms | 14.73ms | -0.57ms (-3.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.70ms | 2.59ms | +0.11ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 11.02ms | 8.81ms | +2.22ms (+25.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.89ms | 3.87ms | +0.03ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.74ms | 0.68ms | +0.06ms (+8.4%) | 🟠 |
| Worst Frame Build Time Millis | 4.30ms | 4.57ms | -0.27ms (-5.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.17ms | 5.59ms | -0.42ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 4.25 | -4 (-82.4%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.61ms | +0.03ms (+4.9%) | 🟠 |
| Worst Frame Build Time Millis | 3.54ms | 3.56ms | -0.02ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.46ms | 4.52ms | -0.06ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.03ms | 2.12ms | -0.09ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 5.93ms | 6.06ms | -0.13ms (-2.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.41ms | 5.54ms | -0.13ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.45ms | 6.60ms | -0.14ms (-2.2%) | 🟡 |
| Worst Frame Build Time Millis | 22.54ms | 23.91ms | -1.38ms (-5.8%) | 🟢 |
| Missed Frame Build Budget Count | 6.75 | 6.5 | +0 (+3.8%) | 🟠 |
| Average Frame Rasterizer Time Millis | 6.61ms | 6.63ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 6.5 | +0 (+7.7%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.91ms | 10.62ms | +0.29ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 34.45ms | 31.87ms | +2.57ms (+8.1%) | 🟠 |
| Missed Frame Build Budget Count | 3.25 | 3.0 | +0 (+8.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 6.77ms | 6.86ms | -0.09ms (-1.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.69ms | 1.63ms | +0.06ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 9.92ms | 10.01ms | -0.09ms (-0.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.40ms | 7.78ms | +0.63ms (+8.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 9.75 | 0.75 | +9 (+1200.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.0 | +2 (+150.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.12ms | 1.32ms | -0.20ms (-15.3%) | 🟢 |
| Worst Frame Build Time Millis | 6.85ms | 11.03ms | -4.17ms (-37.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.14ms | 9.35ms | +0.79ms (+8.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 7.5 | 3.5 | +4 (+114.3%) | 🔴 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.31ms | 5.81ms | +0.49ms (+8.5%) | 🟠 |
| Worst Frame Build Time Millis | 36.03ms | 29.31ms | +6.71ms (+22.9%) | 🔴 |
| Missed Frame Build Budget Count | 4.25 | 4.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.30ms | 5.07ms | +0.23ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.26ms | 21.40ms | +2.86ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 44.12ms | 41.11ms | +3.01ms (+7.3%) | 🟠 |
| Missed Frame Build Budget Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.38ms | 5.34ms | +0.03ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.5 | 17.0 | -0 (-2.9%) | 🟡 |
| Old Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.00ms | 0.96ms | +0.04ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 15.76ms | 18.65ms | -2.89ms (-15.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.81ms | 8.15ms | +0.65ms (+8.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 13.0 | 4.75 | +8 (+173.7%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.38ms | 1.33ms | +0.06ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 7.09ms | 6.77ms | +0.32ms (+4.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.52ms | 5.53ms | -0.01ms (-0.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.06ms | 7.08ms | -0.02ms (-0.2%) | 🟡 |
| Worst Frame Build Time Millis | 29.04ms | 29.28ms | -0.24ms (-0.8%) | 🟡 |
| Missed Frame Build Budget Count | 2.25 | 2.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.78ms | 7.69ms | +0.09ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 6.5 | 5.5 | +1 (+18.2%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 1.30ms | -0.06ms (-4.2%) | 🟡 |
| Worst Frame Build Time Millis | 7.90ms | 7.68ms | +0.23ms (+3.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.94ms | 8.64ms | -0.70ms (-8.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.17ms | 1.12ms | +0.05ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 4.89ms | 6.28ms | -1.39ms (-22.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.06ms | 7.89ms | +0.17ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.65ms | 1.56ms | +0.09ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 4.47ms | 2.79ms | +1.68ms (+60.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.32ms | 8.80ms | -0.48ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>

