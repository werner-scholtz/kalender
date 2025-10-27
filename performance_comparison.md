## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 52.3%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 11.5%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 9.1%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 11.5%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 19.3%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 17.0%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 14.2%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 24.0%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 20.5%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.56ms | 2.61ms | -0.05ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 6.19ms | 6.21ms | -0.02ms (-0.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.58ms | 2.69ms | -0.11ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.57ms | 4.70ms | -0.12ms (-2.7%) | 🟡 |
| Worst Frame Build Time Millis | 13.30ms | 15.74ms | -2.44ms (-15.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.55ms | 3.43ms | +0.11ms (+3.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.69ms | -0.05ms (-7.3%) | 🟢 |
| Worst Frame Build Time Millis | 5.12ms | 3.49ms | +1.63ms (+46.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.44ms | 5.41ms | -1.97ms (-36.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.25 | 6.0 | -3 (-45.8%) | 🟢 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.52ms | 0.48ms | +0.04ms (+9.1%) | 🟠 |
| Worst Frame Build Time Millis | 2.80ms | 1.94ms | +0.87ms (+44.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.66ms | 3.60ms | +0.06ms (+1.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.49ms | 9.43ms | +0.06ms (+0.7%) | 🟠 |
| Worst Frame Build Time Millis | 27.28ms | 26.83ms | +0.44ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.76ms | 2.77ms | -0.01ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.82ms | 7.29ms | -0.47ms (-6.4%) | 🟢 |
| Worst Frame Build Time Millis | 15.69ms | 17.56ms | -1.87ms (-10.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.33ms | 3.42ms | -0.09ms (-2.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.04ms | 2.12ms | -0.08ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 27.80ms | 28.03ms | -0.23ms (-0.8%) | 🟡 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.36ms | 5.03ms | -0.66ms (-13.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| New Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.71ms | +0.01ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 1.87ms | 1.87ms | +0.00ms (+0.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.50ms | 10.19ms | -0.69ms (-6.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.63ms | 2.59ms | +0.04ms (+1.6%) | 🟠 |
| Worst Frame Build Time Millis | 8.48ms | 8.46ms | +0.02ms (+0.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.83ms | 2.76ms | +0.07ms (+2.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.55ms | -0.08ms (-14.2%) | 🟢 |
| Worst Frame Build Time Millis | 2.15ms | 2.56ms | -0.41ms (-16.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.51ms | 3.27ms | -0.76ms (-23.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.62ms | -0.13ms (-20.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.10ms | 2.80ms | -0.69ms (-24.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.23ms | 4.39ms | -2.15ms (-49.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.88ms | 2.07ms | -0.18ms (-8.9%) | 🟢 |
| Worst Frame Build Time Millis | 5.50ms | 4.10ms | +1.40ms (+34.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.78ms | 4.63ms | +0.15ms (+3.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.18ms | 6.07ms | +0.11ms (+1.7%) | 🟠 |
| Worst Frame Build Time Millis | 23.20ms | 22.87ms | +0.33ms (+1.4%) | 🟠 |
| Missed Frame Build Budget Count | 4.75 | 5.75 | -1 (-17.4%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.66ms | 4.54ms | +0.12ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 7.5 | 5.5 | +2 (+36.4%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.63ms | 11.11ms | -0.48ms (-4.3%) | 🟡 |
| Worst Frame Build Time Millis | 31.08ms | 35.47ms | -4.39ms (-12.4%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.89ms | 4.85ms | +0.04ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 5.0 | 7.0 | -2 (-28.6%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.16ms | 1.52ms | -0.37ms (-24.0%) | 🟢 |
| Worst Frame Build Time Millis | 8.08ms | 10.12ms | -2.04ms (-20.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.88ms | 8.47ms | -4.59ms (-54.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 8.5 | -8 (-100.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |
| Old Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.49ms | -0.29ms (-19.3%) | 🟢 |
| Worst Frame Build Time Millis | 7.11ms | 8.97ms | -1.85ms (-20.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.86ms | 11.83ms | -3.97ms (-33.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 5.0 | 9.0 | -4 (-44.4%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.71ms | 5.84ms | -0.14ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 30.71ms | 29.29ms | +1.42ms (+4.9%) | 🟠 |
| Missed Frame Build Budget Count | 4.75 | 4.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.16ms | 3.12ms | +0.04ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.93ms | 20.57ms | +2.36ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 46.27ms | 43.67ms | +2.60ms (+6.0%) | 🟠 |
| Missed Frame Build Budget Count | 11.0 | 10.5 | +0 (+4.8%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.25ms | 3.05ms | +0.20ms (+6.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 20.0 | -2 (-10.0%) | 🟢 |
| Old Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.97ms | 1.02ms | -0.05ms (-4.6%) | 🟡 |
| Worst Frame Build Time Millis | 21.54ms | 22.01ms | -0.47ms (-2.1%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.59ms | 5.96ms | -2.37ms (-39.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.5 | -1 (-83.3%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.19ms | +0.02ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 5.99ms | 6.30ms | -0.31ms (-4.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.82ms | 3.83ms | -0.02ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.52ms | 7.70ms | -0.18ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 28.01ms | 27.16ms | +0.86ms (+3.2%) | 🟠 |
| Missed Frame Build Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.88ms | 5.53ms | +0.35ms (+6.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 5.0 | 6.5 | -2 (-23.1%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.84ms | 1.02ms | -0.17ms (-17.0%) | 🟢 |
| Worst Frame Build Time Millis | 4.93ms | 4.14ms | +0.78ms (+18.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.83ms | 9.15ms | -3.32ms (-36.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 0.75 | +3 (+400.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 4.0 | +2 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.58ms | 1.03ms | +0.54ms (+52.3%) | 🔴 |
| Worst Frame Build Time Millis | 6.56ms | 4.54ms | +2.02ms (+44.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.71ms | 9.14ms | +2.57ms (+28.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 8.5 | 1.0 | +8 (+750.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.55ms | 1.75ms | -0.20ms (-11.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.31ms | 3.11ms | +0.20ms (+6.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.69ms | 6.31ms | -0.62ms (-9.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>

