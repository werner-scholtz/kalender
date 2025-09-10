## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 13.6%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 10.1%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 16.4%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 17.6%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 12.5%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 15.0%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.03ms | 4.04ms | -0.01ms (-0.2%) | 🟡 |
| Worst Frame Build Time Millis | 7.94ms | 7.94ms | -0.00ms (-0.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.65ms | 2.25ms | +0.40ms (+17.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.35ms | 4.51ms | -0.16ms (-3.5%) | 🟡 |
| Worst Frame Build Time Millis | 16.12ms | 17.75ms | -1.64ms (-9.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.82ms | 3.81ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.68ms | -0.07ms (-10.1%) | 🟢 |
| Worst Frame Build Time Millis | 4.56ms | 4.61ms | -0.05ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.73ms | 4.82ms | -1.09ms (-22.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.25 | 6.0 | -3 (-45.8%) | 🟢 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.50ms | -0.02ms (-4.5%) | 🟡 |
| Worst Frame Build Time Millis | 3.03ms | 3.15ms | -0.12ms (-3.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.41ms | 3.17ms | -0.76ms (-24.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.91ms | 8.68ms | +0.23ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 25.30ms | 24.79ms | +0.51ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.93ms | 2.80ms | +0.13ms (+4.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.48ms | 6.61ms | -0.13ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 12.85ms | 12.95ms | -0.11ms (-0.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.34ms | 3.30ms | +0.03ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.00ms | 2.18ms | -0.18ms (-8.2%) | 🟢 |
| Worst Frame Build Time Millis | 27.97ms | 29.33ms | -1.36ms (-4.6%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.58ms | 5.36ms | -0.78ms (-14.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.5 | 6.0 | -2 (-25.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.22ms | -0.02ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 2.30ms | 2.32ms | -0.02ms (-0.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.98ms | 2.09ms | -0.10ms (-5.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.81ms | 2.99ms | -0.18ms (-6.1%) | 🟢 |
| Worst Frame Build Time Millis | 9.62ms | 9.98ms | -0.36ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.36ms | 3.41ms | -0.05ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.62ms | -0.03ms (-4.4%) | 🟡 |
| Worst Frame Build Time Millis | 4.56ms | 3.78ms | +0.78ms (+20.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.46ms | 3.94ms | -0.47ms (-12.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.25 | 3.25 | +1 (+30.8%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.61ms | -0.05ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 1.94ms | 2.09ms | -0.15ms (-7.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.57ms | 4.84ms | -1.27ms (-26.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 2.5 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.57ms | 1.87ms | -0.31ms (-16.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.65ms | 3.92ms | -0.26ms (-6.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.46ms | 4.61ms | -0.14ms (-3.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.44ms | 9.66ms | -0.22ms (-2.3%) | 🟡 |
| Worst Frame Build Time Millis | 26.14ms | 28.76ms | -2.63ms (-9.1%) | 🟢 |
| Missed Frame Build Budget Count | 7.75 | 7.0 | +1 (+10.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.69ms | 5.00ms | -0.31ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.85ms | 10.22ms | -0.36ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 42.09ms | 42.67ms | -0.58ms (-1.4%) | 🟡 |
| Missed Frame Build Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.76ms | 4.75ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.48ms | -0.14ms (-9.4%) | 🟢 |
| Worst Frame Build Time Millis | 19.75ms | 18.38ms | +1.37ms (+7.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.33ms | 6.33ms | -2.00ms (-31.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.39ms | 1.63ms | -0.25ms (-15.0%) | 🟢 |
| Worst Frame Build Time Millis | 13.77ms | 12.56ms | +1.22ms (+9.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.28ms | 9.58ms | -4.31ms (-44.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.53ms | 5.55ms | -0.03ms (-0.5%) | 🟡 |
| Worst Frame Build Time Millis | 28.00ms | 27.81ms | +0.20ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 4.25 | 4.0 | +0 (+6.2%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.09ms | 2.99ms | +0.11ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 20.88ms | 21.55ms | -0.67ms (-3.1%) | 🟡 |
| Worst Frame Build Time Millis | 46.66ms | 42.46ms | +4.20ms (+9.9%) | 🟠 |
| Missed Frame Build Budget Count | 10.25 | 10.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.11ms | 2.96ms | +0.15ms (+5.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 18.0 | +1 (+5.6%) | 🟠 |
| Old Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 0.99ms | -0.08ms (-8.3%) | 🟢 |
| Worst Frame Build Time Millis | 17.60ms | 20.75ms | -3.15ms (-15.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.58ms | 6.12ms | -1.54ms (-25.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.11ms | 2.41ms | -0.30ms (-12.5%) | 🟢 |
| Worst Frame Build Time Millis | 7.83ms | 8.94ms | -1.12ms (-12.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.63ms | 3.99ms | -0.36ms (-9.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 1.5 | 3.0 | -2 (-50.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.53ms | 8.89ms | -0.36ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 37.60ms | 44.43ms | -6.83ms (-15.4%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.72ms | 5.30ms | +0.41ms (+7.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.98ms | 1.19ms | -0.21ms (-17.6%) | 🟢 |
| Worst Frame Build Time Millis | 6.28ms | 5.18ms | +1.10ms (+21.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.54ms | 8.41ms | -1.87ms (-22.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 2.75 | +1 (+27.3%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.13ms | 0.99ms | +0.14ms (+13.6%) | 🔴 |
| Worst Frame Build Time Millis | 5.71ms | 3.94ms | +1.78ms (+45.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.46ms | 6.76ms | -0.30ms (-4.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.70ms | 1.66ms | +0.04ms (+2.2%) | 🟠 |
| Worst Frame Build Time Millis | 4.93ms | 3.98ms | +0.94ms (+23.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.55ms | 6.03ms | -0.48ms (-8.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

