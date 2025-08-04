## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 7.9%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 5.9%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 6.2%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 5.5%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 5.7%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 9.7%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 11.7%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.32ms | 4.19ms | +0.13ms (+3.2%) | 🟠 |
| Worst Frame Build Time Millis | 8.50ms | 8.25ms | +0.25ms (+3.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.75ms | 2.29ms | +0.46ms (+20.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.85ms | 4.56ms | +0.28ms (+6.2%) | 🟠 |
| Worst Frame Build Time Millis | 17.14ms | 16.47ms | +0.67ms (+4.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.75ms | 3.84ms | -0.08ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.78ms | -0.05ms (-6.3%) | 🟢 |
| Worst Frame Build Time Millis | 4.30ms | 6.03ms | -1.73ms (-28.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.83ms | 3.57ms | -0.74ms (-20.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.57ms | -0.04ms (-6.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.52ms | 3.83ms | -0.31ms (-8.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.62ms | 3.41ms | -0.80ms (-23.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.72ms | 8.08ms | +0.64ms (+7.9%) | 🟠 |
| Worst Frame Build Time Millis | 24.72ms | 23.15ms | +1.58ms (+6.8%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.69ms | 2.77ms | -0.07ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.26ms | 5.93ms | +0.33ms (+5.5%) | 🟠 |
| Worst Frame Build Time Millis | 10.81ms | 10.62ms | +0.18ms (+1.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.36ms | 3.26ms | +0.11ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.80ms | 1.86ms | -0.05ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 25.04ms | 22.69ms | +2.35ms (+10.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.04ms | 3.85ms | -0.81ms (-21.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.22ms | +0.01ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 2.33ms | 2.31ms | +0.02ms (+0.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.85ms | 1.85ms | -0.01ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.65ms | 2.60ms | +0.05ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 9.17ms | 9.06ms | +0.11ms (+1.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.23ms | 3.17ms | +0.06ms (+1.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.52ms | 0.52ms | +0.01ms (+1.6%) | 🟠 |
| Worst Frame Build Time Millis | 2.03ms | 2.92ms | -0.89ms (-30.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.22ms | 2.45ms | -0.22ms (-9.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.46ms | +0.02ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 1.57ms | 1.66ms | -0.09ms (-5.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.96ms | 1.94ms | +0.02ms (+0.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.74ms | +0.02ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 1.02ms | 1.27ms | -0.25ms (-19.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.32ms | 3.12ms | +0.20ms (+6.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.40ms | 10.44ms | -0.04ms (-0.4%) | 🟡 |
| Worst Frame Build Time Millis | 28.60ms | 27.91ms | +0.69ms (+2.5%) | 🟠 |
| Missed Frame Build Budget Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.10ms | 5.31ms | -0.21ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.43ms | 11.33ms | +1.10ms (+9.7%) | 🟠 |
| Worst Frame Build Time Millis | 43.55ms | 39.83ms | +3.72ms (+9.3%) | 🟠 |
| Missed Frame Build Budget Count | 3.25 | 3.0 | +0 (+8.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.51ms | 4.96ms | +0.54ms (+11.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.54ms | 1.64ms | -0.10ms (-5.8%) | 🟢 |
| Worst Frame Build Time Millis | 13.67ms | 13.81ms | -0.14ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.08ms | 5.98ms | -1.90ms (-31.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.45ms | 1.53ms | -0.08ms (-5.2%) | 🟢 |
| Worst Frame Build Time Millis | 12.89ms | 13.34ms | -0.45ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.76ms | 6.17ms | -2.41ms (-39.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.30ms | 5.26ms | +0.03ms (+0.6%) | 🟠 |
| Worst Frame Build Time Millis | 28.07ms | 28.25ms | -0.19ms (-0.7%) | 🟡 |
| Missed Frame Build Budget Count | 2.5 | 2.25 | +0 (+11.1%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.16ms | 3.14ms | +0.03ms (+0.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.0 | +0 (+5.0%) | 🟠 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 19.94ms | 19.05ms | +0.88ms (+4.6%) | 🟠 |
| Worst Frame Build Time Millis | 41.55ms | 41.76ms | -0.22ms (-0.5%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.25 | -0 (-2.7%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.21ms | 3.07ms | +0.13ms (+4.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 12.0 | 11.0 | +1 (+9.1%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.87ms | 0.82ms | +0.05ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 13.31ms | 12.48ms | +0.82ms (+6.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.11ms | 4.45ms | -1.34ms (-30.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.23ms | 2.23ms | +0.00ms (+0.0%) | 🟠 |
| Worst Frame Build Time Millis | 8.28ms | 8.18ms | +0.10ms (+1.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.46ms | 3.31ms | +0.15ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.78ms | 8.37ms | +0.40ms (+4.8%) | 🟠 |
| Worst Frame Build Time Millis | 42.83ms | 42.51ms | +0.32ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.34ms | 5.27ms | +0.07ms (+1.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.02ms | 1.16ms | -0.13ms (-11.7%) | 🟢 |
| Worst Frame Build Time Millis | 6.56ms | 6.99ms | -0.43ms (-6.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.26ms | 6.69ms | -1.43ms (-21.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.25 | +1 (+500.0%) | 🔴 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.88ms | 0.83ms | +0.05ms (+5.9%) | 🟠 |
| Worst Frame Build Time Millis | 4.18ms | 3.11ms | +1.07ms (+34.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.61ms | 5.44ms | -0.82ms (-15.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.84ms | 0.87ms | -0.02ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 1.45ms | 2.06ms | -0.61ms (-29.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.24ms | 6.01ms | -0.77ms (-12.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

</details>

