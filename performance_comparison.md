## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 26.5%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 17.5%
- 🟢 **one_event_per_day-week-navigation**: Frame build time improved by 16.3%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 41.2%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 10.3%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 11.4%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 17.6%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 11.1%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 13.8%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 11.7%
- 🟢 **one_event_per_day-month-navigation**: Frame build time improved by 19.2%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.24ms | 7.21ms | -2.97ms (-41.2%) | 🟢 |
| Worst Frame Build Time Millis | 8.34ms | 14.28ms | -5.95ms (-41.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 2.31ms | 2.60ms | -0.29ms (-11.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.63ms | 5.73ms | -1.10ms (-19.2%) | 🟢 |
| Worst Frame Build Time Millis | 16.51ms | 21.40ms | -4.88ms (-22.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 1.5 | -1 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.78ms | 4.43ms | -0.66ms (-14.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.81ms | +0.01ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 6.31ms | 5.00ms | +1.31ms (+26.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.28ms | 3.29ms | +0.99ms (+30.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.75 | -2 (-54.5%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.69ms | -0.12ms (-17.6%) | 🟢 |
| Worst Frame Build Time Millis | 3.68ms | 4.64ms | -0.96ms (-20.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.75ms | 2.93ms | +1.82ms (+62.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.99ms | 8.12ms | -0.13ms (-1.6%) | 🟡 |
| Worst Frame Build Time Millis | 22.84ms | 22.94ms | -0.09ms (-0.4%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.16ms | 2.90ms | +0.27ms (+9.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.92ms | 6.71ms | -0.78ms (-11.7%) | 🟢 |
| Worst Frame Build Time Millis | 10.83ms | 12.46ms | -1.62ms (-13.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.28ms | 3.83ms | -0.55ms (-14.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.84ms | 1.98ms | -0.13ms (-6.8%) | 🟢 |
| Worst Frame Build Time Millis | 23.91ms | 27.28ms | -3.38ms (-12.4%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.92ms | 3.81ms | +1.10ms (+28.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.75 | 0.5 | +2 (+450.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.49ms | -0.26ms (-17.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.33ms | 2.86ms | -0.53ms (-18.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.90ms | 2.15ms | -0.25ms (-11.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.61ms | 3.12ms | -0.51ms (-16.3%) | 🟢 |
| Worst Frame Build Time Millis | 9.52ms | 11.78ms | -2.26ms (-19.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.12ms | 3.49ms | -0.37ms (-10.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.54ms | 0.56ms | -0.02ms (-3.8%) | 🟡 |
| Worst Frame Build Time Millis | 2.64ms | 2.79ms | -0.15ms (-5.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.34ms | 2.90ms | +0.43ms (+15.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.48ms | +0.01ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 1.80ms | 1.58ms | +0.22ms (+13.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.72ms | 1.92ms | +0.80ms (+41.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.83ms | 0.94ms | -0.10ms (-11.1%) | 🟢 |
| Worst Frame Build Time Millis | 1.23ms | 1.81ms | -0.57ms (-31.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.35ms | 3.54ms | -0.18ms (-5.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.00ms | 11.15ms | -1.14ms (-10.3%) | 🟢 |
| Worst Frame Build Time Millis | 28.91ms | 31.49ms | -2.58ms (-8.2%) | 🟢 |
| Missed Frame Build Budget Count | 7.75 | 8.0 | -0 (-3.1%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.09ms | 5.81ms | -0.72ms (-12.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.0 | +0 (+5.0%) | 🟠 |
| Old Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.60ms | 13.66ms | -1.07ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 47.03ms | 46.25ms | +0.78ms (+1.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.03ms | 5.84ms | -0.81ms (-13.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.64ms | 1.74ms | -0.10ms (-5.8%) | 🟢 |
| Worst Frame Build Time Millis | 12.99ms | 14.61ms | -1.61ms (-11.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.73ms | 4.75ms | +1.98ms (+41.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.73ms | 1.75ms | -0.02ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 17.70ms | 13.97ms | +3.73ms (+26.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.05ms | 5.92ms | +2.14ms (+36.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.16ms | 5.71ms | -0.55ms (-9.6%) | 🟢 |
| Worst Frame Build Time Millis | 29.43ms | 33.82ms | -4.39ms (-13.0%) | 🟢 |
| Missed Frame Build Budget Count | 2.5 | 4.25 | -2 (-41.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.10ms | 3.68ms | -0.58ms (-15.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 19.40ms | 22.50ms | -3.09ms (-13.8%) | 🟢 |
| Worst Frame Build Time Millis | 40.93ms | 46.59ms | -5.66ms (-12.2%) | 🟢 |
| Missed Frame Build Budget Count | 8.25 | 11.0 | -3 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.24ms | 3.84ms | -0.60ms (-15.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 17.5 | 19.0 | -2 (-7.9%) | 🟢 |
| Old Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.85ms | 0.92ms | -0.08ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 12.45ms | 14.36ms | -1.91ms (-13.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.37ms | 4.44ms | +0.93ms (+20.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.25 | 2.5 | -0 (-10.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.25ms | 2.54ms | -0.29ms (-11.4%) | 🟢 |
| Worst Frame Build Time Millis | 8.60ms | 10.18ms | -1.59ms (-15.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.41ms | 3.90ms | -0.49ms (-12.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.75ms | 9.43ms | -0.69ms (-7.3%) | 🟢 |
| Worst Frame Build Time Millis | 42.63ms | 43.65ms | -1.02ms (-2.3%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.27ms | 5.89ms | -0.62ms (-10.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 1.09ms | +0.02ms (+1.6%) | 🟠 |
| Worst Frame Build Time Millis | 7.32ms | 7.43ms | -0.12ms (-1.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.68ms | 5.80ms | +1.89ms (+32.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.25 | 8.75 | -2 (-28.6%) | 🟢 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.26ms | 1.00ms | +0.26ms (+26.5%) | 🔴 |
| Worst Frame Build Time Millis | 6.56ms | 3.72ms | +2.84ms (+76.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.34ms | 4.84ms | +4.50ms (+92.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.0 | 0.25 | +5 (+1900.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.89ms | 0.87ms | +0.02ms (+1.8%) | 🟠 |
| Worst Frame Build Time Millis | 1.56ms | 1.58ms | -0.02ms (-1.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.89ms | 5.52ms | +1.37ms (+24.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

</details>

