## 📋 Summary

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 11.4%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 10.6%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 14.5%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 20.0%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 10.6%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 20.2%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 11.5%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 21.0%
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 20.3%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 25.7%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 19.9%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 22.8%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 19.1%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 16.9%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 13.7%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.06ms | 4.54ms | -0.48ms (-10.6%) | 🟢 |
| Worst Frame Build Time Millis | 7.99ms | 8.95ms | -0.96ms (-10.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.17ms | 2.35ms | -0.18ms (-7.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.49ms | 4.90ms | -0.41ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 15.03ms | 17.83ms | -2.80ms (-15.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.65ms | 3.92ms | -0.27ms (-7.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.93ms | -0.21ms (-22.8%) | 🟢 |
| Worst Frame Build Time Millis | 4.46ms | 5.81ms | -1.36ms (-23.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.70ms | 4.46ms | -1.75ms (-39.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.62ms | -0.06ms (-9.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.71ms | 3.93ms | -0.22ms (-5.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.63ms | 4.97ms | -2.34ms (-47.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.31ms | 8.50ms | -0.19ms (-2.3%) | 🟡 |
| Worst Frame Build Time Millis | 23.93ms | 24.11ms | -0.18ms (-0.8%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.08ms | 3.23ms | -0.16ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.81ms | 6.28ms | -0.47ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 10.55ms | 10.99ms | -0.44ms (-4.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.36ms | 3.29ms | +0.08ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.73ms | 2.08ms | -0.35ms (-16.9%) | 🟢 |
| Worst Frame Build Time Millis | 23.78ms | 28.18ms | -4.40ms (-15.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.90ms | 4.16ms | -1.26ms (-30.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.13ms | 1.31ms | -0.18ms (-13.7%) | 🟢 |
| Worst Frame Build Time Millis | 2.15ms | 2.50ms | -0.34ms (-13.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.84ms | 1.99ms | -0.15ms (-7.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.59ms | 2.80ms | -0.21ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 9.22ms | 9.56ms | -0.34ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.19ms | 3.27ms | -0.08ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.62ms | -0.12ms (-20.2%) | 🟢 |
| Worst Frame Build Time Millis | 1.96ms | 3.67ms | -1.71ms (-46.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.22ms | 2.91ms | -0.69ms (-23.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.44ms | 0.55ms | -0.11ms (-20.0%) | 🟢 |
| Worst Frame Build Time Millis | 1.55ms | 1.82ms | -0.27ms (-14.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.84ms | 2.30ms | -0.46ms (-20.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 1.00ms | -0.26ms (-25.7%) | 🟢 |
| Worst Frame Build Time Millis | 1.01ms | 1.37ms | -0.36ms (-26.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.70ms | 4.40ms | -0.69ms (-15.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.97ms | 10.95ms | -0.98ms (-9.0%) | 🟢 |
| Worst Frame Build Time Millis | 26.95ms | 31.47ms | -4.52ms (-14.4%) | 🟢 |
| Missed Frame Build Budget Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.12ms | 5.13ms | -0.01ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 11.0 | -1 (-9.1%) | 🟢 |
| Old Gen Gc Count | 7.0 | 6.5 | +0 (+7.7%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.11ms | 15.20ms | -3.09ms (-20.3%) | 🟢 |
| Worst Frame Build Time Millis | 45.69ms | 63.94ms | -18.25ms (-28.5%) | 🟢 |
| Missed Frame Build Budget Count | 2.5 | 3.25 | -1 (-23.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.08ms | 4.69ms | +0.39ms (+8.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.48ms | 1.83ms | -0.35ms (-19.1%) | 🟢 |
| Worst Frame Build Time Millis | 13.21ms | 13.84ms | -0.63ms (-4.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.05ms | 5.98ms | -1.93ms (-32.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.43ms | 1.67ms | -0.24ms (-14.5%) | 🟢 |
| Worst Frame Build Time Millis | 12.33ms | 13.68ms | -1.35ms (-9.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.80ms | 6.12ms | -2.32ms (-37.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.95ms | 5.41ms | -0.46ms (-8.5%) | 🟢 |
| Worst Frame Build Time Millis | 30.41ms | 28.67ms | +1.74ms (+6.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 3.75 | -2 (-60.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.21ms | 3.27ms | -0.06ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.5 | 10.5 | +1 (+9.5%) | 🟠 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 18.86ms | 21.09ms | -2.23ms (-10.6%) | 🟢 |
| Worst Frame Build Time Millis | 39.86ms | 43.95ms | -4.09ms (-9.3%) | 🟢 |
| Missed Frame Build Budget Count | 8.0 | 10.0 | -2 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.12ms | 3.22ms | -0.10ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.83ms | 0.94ms | -0.11ms (-11.5%) | 🟢 |
| Worst Frame Build Time Millis | 12.89ms | 14.03ms | -1.14ms (-8.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.25ms | 4.82ms | -1.57ms (-32.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.27ms | 2.37ms | -0.10ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 8.55ms | 8.78ms | -0.23ms (-2.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.42ms | 3.47ms | -0.05ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.48ms | 8.91ms | -0.43ms (-4.9%) | 🟡 |
| Worst Frame Build Time Millis | 41.42ms | 42.95ms | -1.53ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.34ms | 5.52ms | -0.18ms (-3.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.96ms | 1.21ms | -0.25ms (-21.0%) | 🟢 |
| Worst Frame Build Time Millis | 4.61ms | 6.71ms | -2.10ms (-31.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.40ms | 6.49ms | -1.09ms (-16.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 0.0 | +4 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.84ms | 1.05ms | -0.21ms (-19.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.24ms | 3.82ms | -0.58ms (-15.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.46ms | 6.15ms | -0.69ms (-11.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.91ms | -0.10ms (-11.4%) | 🟢 |
| Worst Frame Build Time Millis | 1.48ms | 1.37ms | +0.11ms (+8.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.29ms | 5.85ms | -0.56ms (-9.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

</details>

