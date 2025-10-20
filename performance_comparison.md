## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 11.9%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 6.7%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 8.9%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 13.4%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 18.2%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 17.9%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 43.1%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 41.7%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 33.4%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 11.3%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 10.5%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 25.6%
- 🟢 **ten_events_per_day-week-navigation**: Frame build time improved by 12.9%
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 11.0%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.49ms | 3.75ms | -1.25ms (-33.4%) | 🟢 |
| Worst Frame Build Time Millis | 5.94ms | 7.31ms | -1.37ms (-18.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.59ms | 2.37ms | +0.22ms (+9.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.46ms | 4.54ms | -0.08ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 16.39ms | 17.88ms | -1.49ms (-8.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.97ms | 4.06ms | -0.09ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 4.5 | -2 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.82ms | -0.15ms (-18.2%) | 🟢 |
| Worst Frame Build Time Millis | 4.05ms | 8.76ms | -4.70ms (-53.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.93ms | 7.22ms | -4.29ms (-59.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 12.25 | -12 (-98.0%) | 🟢 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.68ms | -0.08ms (-11.3%) | 🟢 |
| Worst Frame Build Time Millis | 3.99ms | 4.54ms | -0.55ms (-12.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.00ms | 10.44ms | -4.44ms (-42.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.31ms | 10.16ms | -0.85ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 26.74ms | 29.29ms | -2.55ms (-8.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.90ms | 3.34ms | -0.44ms (-13.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.83ms | 6.40ms | +0.43ms (+6.7%) | 🟠 |
| Worst Frame Build Time Millis | 14.42ms | 11.67ms | +2.75ms (+23.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.35ms | 3.57ms | -0.22ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 8.0 | -2 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.99ms | 2.12ms | -0.13ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 24.60ms | 26.39ms | -1.79ms (-6.8%) | 🟢 |
| Missed Frame Build Budget Count | 1.75 | 1.0 | +1 (+75.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.06ms | 6.22ms | -3.16ms (-50.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 7.5 | -8 (-100.0%) | 🟢 |
| New Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 1.07ms | -0.27ms (-25.6%) | 🟢 |
| Worst Frame Build Time Millis | 2.06ms | 2.00ms | +0.06ms (+2.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.88ms | 2.20ms | +1.68ms (+76.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.78ms | 2.81ms | -0.03ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 9.01ms | 10.99ms | -1.98ms (-18.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.25ms | 3.47ms | -0.21ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.64ms | -0.01ms (-1.1%) | 🟡 |
| Worst Frame Build Time Millis | 2.63ms | 5.41ms | -2.78ms (-51.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.31ms | 4.73ms | -1.42ms (-30.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.0 | -1 (-37.5%) | 🟢 |
| New Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.74ms | -0.13ms (-17.9%) | 🟢 |
| Worst Frame Build Time Millis | 2.15ms | 3.20ms | -1.05ms (-32.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.42ms | 9.07ms | -6.65ms (-73.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 4.25 | -4 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.87ms | 1.80ms | +0.07ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 4.47ms | 4.44ms | +0.03ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.77ms | 5.16ms | -1.39ms (-26.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.24ms | 10.96ms | -4.73ms (-43.1%) | 🟢 |
| Worst Frame Build Time Millis | 22.93ms | 48.88ms | -25.96ms (-53.1%) | 🟢 |
| Missed Frame Build Budget Count | 5.25 | 6.25 | -1 (-16.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.58ms | 5.79ms | -1.21ms (-20.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 11.5 | -1 (-8.7%) | 🟢 |
| Old Gen Gc Count | 7.5 | 6.0 | +2 (+25.0%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.87ms | 12.22ms | -1.35ms (-11.0%) | 🟢 |
| Worst Frame Build Time Millis | 38.17ms | 54.53ms | -16.36ms (-30.0%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 3.25 | +1 (+23.1%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.56ms | 5.84ms | -0.28ms (-4.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |
| Old Gen Gc Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.66ms | 1.52ms | +0.14ms (+8.9%) | 🟠 |
| Worst Frame Build Time Millis | 11.85ms | 14.82ms | -2.97ms (-20.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.65ms | 8.38ms | -2.74ms (-32.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 8.5 | -7 (-85.3%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.36ms | 1.57ms | -0.21ms (-13.4%) | 🟢 |
| Worst Frame Build Time Millis | 10.68ms | 11.82ms | -1.14ms (-9.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.39ms | 11.90ms | -6.51ms (-54.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 4.0 | -3 (-81.2%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.91ms | 5.86ms | +0.05ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 26.73ms | 31.99ms | -5.26ms (-16.5%) | 🟢 |
| Missed Frame Build Budget Count | 4.25 | 4.0 | +0 (+6.2%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.10ms | 3.48ms | -0.38ms (-11.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 13.5 | 14.0 | -0 (-3.6%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.29ms | 20.82ms | +2.48ms (+11.9%) | 🔴 |
| Worst Frame Build Time Millis | 47.41ms | 46.44ms | +0.97ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 10.5 | 8.75 | +2 (+20.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.27ms | 3.54ms | -0.27ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 21.5 | -2 (-11.6%) | 🟢 |
| Old Gen Gc Count | 11.0 | 10.5 | +0 (+4.8%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.05ms | 1.03ms | +0.02ms (+1.6%) | 🟠 |
| Worst Frame Build Time Millis | 18.30ms | 20.09ms | -1.79ms (-8.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.08ms | 6.61ms | -1.53ms (-23.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.0 | 8.25 | -4 (-51.5%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 2.29ms | -0.96ms (-41.7%) | 🟢 |
| Worst Frame Build Time Millis | 7.19ms | 10.02ms | -2.83ms (-28.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.73ms | 4.46ms | -0.72ms (-16.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.89ms | 9.05ms | -1.17ms (-12.9%) | 🟢 |
| Worst Frame Build Time Millis | 29.95ms | 40.49ms | -10.54ms (-26.0%) | 🟢 |
| Missed Frame Build Budget Count | 1.5 | 3.0 | -2 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.37ms | 6.18ms | -0.81ms (-13.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 12.0 | -4 (-29.2%) | 🟢 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.13ms | 1.27ms | -0.13ms (-10.5%) | 🟢 |
| Worst Frame Build Time Millis | 4.40ms | 5.52ms | -1.11ms (-20.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.27ms | 11.85ms | -6.58ms (-55.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 12.75 | -13 (-100.0%) | 🟢 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.07ms | 1.11ms | -0.04ms (-3.5%) | 🟡 |
| Worst Frame Build Time Millis | 4.22ms | 4.53ms | -0.31ms (-6.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.23ms | 10.74ms | -5.52ms (-51.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.69ms | 1.75ms | -0.06ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 3.05ms | 4.68ms | -1.64ms (-35.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.16ms | 6.65ms | -0.49ms (-7.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

</details>

