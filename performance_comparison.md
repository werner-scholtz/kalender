## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 15.5%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 11.9%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 6.3%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 6.1%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 9.6%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 9.1%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 9.4%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 10.1%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.58ms | 2.56ms | +0.02ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 6.12ms | 6.19ms | -0.06ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.44ms | 2.58ms | -0.13ms (-5.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.45ms | 4.57ms | -0.13ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 13.47ms | 13.30ms | +0.17ms (+1.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.53ms | 3.55ms | -0.02ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.64ms | -0.01ms (-1.7%) | 🟡 |
| Worst Frame Build Time Millis | 5.18ms | 5.12ms | +0.06ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.96ms | 3.44ms | -0.48ms (-13.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 3.25 | -3 (-92.3%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.52ms | +0.05ms (+9.6%) | 🟠 |
| Worst Frame Build Time Millis | 3.44ms | 2.80ms | +0.64ms (+22.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.49ms | 3.66ms | +0.82ms (+22.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.38ms | 9.49ms | +0.89ms (+9.4%) | 🟠 |
| Worst Frame Build Time Millis | 29.91ms | 27.28ms | +2.64ms (+9.7%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.04ms | 2.76ms | +0.28ms (+10.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.26ms | 6.82ms | +0.43ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 16.88ms | 15.69ms | +1.19ms (+7.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.26ms | 3.33ms | -0.07ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.01ms | 2.04ms | -0.03ms (-1.4%) | 🟡 |
| Worst Frame Build Time Millis | 27.55ms | 27.80ms | -0.25ms (-0.9%) | 🟡 |
| Missed Frame Build Budget Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.08ms | 4.36ms | -0.29ms (-6.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| New Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.72ms | -0.03ms (-3.5%) | 🟡 |
| Worst Frame Build Time Millis | 1.81ms | 1.87ms | -0.06ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.15ms | 9.50ms | +0.65ms (+6.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.64ms | 2.63ms | +0.01ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 8.62ms | 8.48ms | +0.14ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.87ms | 2.83ms | +0.03ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.47ms | +0.02ms (+3.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.16ms | 2.15ms | +0.01ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.32ms | 2.51ms | -0.19ms (-7.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.50ms | -0.02ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 1.83ms | 2.10ms | -0.27ms (-12.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.21ms | 2.23ms | -0.02ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.77ms | 1.88ms | -0.12ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 4.38ms | 5.50ms | -1.12ms (-20.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.10ms | 4.78ms | -0.68ms (-14.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.38ms | 6.18ms | +0.21ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 24.90ms | 23.20ms | +1.70ms (+7.3%) | 🟠 |
| Missed Frame Build Budget Count | 4.5 | 4.75 | -0 (-5.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.72ms | 4.66ms | +0.06ms (+1.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.28ms | 10.63ms | +0.65ms (+6.1%) | 🟠 |
| Worst Frame Build Time Millis | 35.56ms | 31.08ms | +4.48ms (+14.4%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.95ms | 4.89ms | +0.06ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.16ms | +0.05ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 7.64ms | 8.08ms | -0.43ms (-5.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.01ms | 3.88ms | +0.13ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.38ms | 1.20ms | +0.19ms (+15.5%) | 🔴 |
| Worst Frame Build Time Millis | 9.63ms | 7.11ms | +2.51ms (+35.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.22ms | 7.86ms | -0.64ms (-8.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 5.0 | -2 (-30.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.71ms | 5.71ms | +0.01ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 27.82ms | 30.71ms | -2.89ms (-9.4%) | 🟢 |
| Missed Frame Build Budget Count | 4.5 | 4.75 | -0 (-5.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.27ms | 3.16ms | +0.10ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.28ms | 22.93ms | -1.65ms (-7.2%) | 🟢 |
| Worst Frame Build Time Millis | 39.50ms | 46.27ms | -6.76ms (-14.6%) | 🟢 |
| Missed Frame Build Budget Count | 10.5 | 11.0 | -0 (-4.5%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.23ms | 3.25ms | -0.02ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 18.0 | +2 (+11.1%) | 🔴 |
| Old Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.99ms | 0.97ms | +0.01ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 20.83ms | 21.54ms | -0.71ms (-3.3%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.60ms | 3.59ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 1.21ms | -0.02ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 6.07ms | 5.99ms | +0.08ms (+1.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.77ms | 3.82ms | -0.05ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.60ms | 7.52ms | +0.08ms (+1.1%) | 🟠 |
| Worst Frame Build Time Millis | 30.10ms | 28.01ms | +2.08ms (+7.4%) | 🟠 |
| Missed Frame Build Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.68ms | 5.88ms | -0.20ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.92ms | 0.84ms | +0.08ms (+9.1%) | 🟠 |
| Worst Frame Build Time Millis | 6.53ms | 4.93ms | +1.60ms (+32.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.83ms | 5.83ms | +0.00ms (+0.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.75 | 3.75 | +1 (+26.7%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.58ms | -0.16ms (-10.1%) | 🟢 |
| Worst Frame Build Time Millis | 6.44ms | 6.56ms | -0.13ms (-2.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.35ms | 11.71ms | +0.64ms (+5.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.73ms | 1.55ms | +0.18ms (+11.9%) | 🔴 |
| Worst Frame Build Time Millis | 3.49ms | 3.31ms | +0.19ms (+5.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.63ms | 5.69ms | -0.06ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

