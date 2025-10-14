## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 14.6%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 9.1%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 6.6%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 9.5%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 10.0%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 5.4%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 6.6%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.88ms | 4.04ms | -0.16ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 7.62ms | 7.93ms | -0.31ms (-3.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.36ms | 2.69ms | -0.33ms (-12.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.66ms | 4.27ms | +0.39ms (+9.1%) | 🟠 |
| Worst Frame Build Time Millis | 18.24ms | 17.30ms | +0.94ms (+5.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 0.75 | +0 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.82ms | 3.63ms | +0.19ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.65ms | 0.62ms | +0.03ms (+4.9%) | 🟠 |
| Worst Frame Build Time Millis | 6.07ms | 4.45ms | +1.62ms (+36.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.57ms | 4.11ms | -1.53ms (-37.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 3.75 | -4 (-93.3%) | 🟢 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.51ms | +0.01ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 3.59ms | 3.31ms | +0.29ms (+8.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.58ms | 2.95ms | -0.38ms (-12.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.90ms | 8.67ms | +0.24ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 25.36ms | 24.64ms | +0.72ms (+2.9%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.85ms | 3.23ms | -0.38ms (-11.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.98ms | 6.38ms | +0.61ms (+9.5%) | 🟠 |
| Worst Frame Build Time Millis | 16.47ms | 12.88ms | +3.59ms (+27.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.23ms | 3.24ms | -0.01ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.25 | -0 (-11.1%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.95ms | 2.01ms | -0.06ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 28.35ms | 29.36ms | -1.02ms (-3.5%) | 🟡 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.11ms | 5.23ms | -2.12ms (-40.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 6.0 | -6 (-91.7%) | 🟢 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.24ms | 1.23ms | +0.01ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 2.33ms | 2.32ms | +0.01ms (+0.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.41ms | 2.22ms | +0.19ms (+8.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.91ms | 2.87ms | +0.04ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 9.76ms | 10.09ms | -0.33ms (-3.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.39ms | 3.33ms | +0.06ms (+1.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.57ms | +0.03ms (+4.5%) | 🟠 |
| Worst Frame Build Time Millis | 2.34ms | 2.57ms | -0.23ms (-8.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.97ms | 3.84ms | -0.88ms (-22.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.56ms | +0.03ms (+5.4%) | 🟠 |
| Worst Frame Build Time Millis | 2.45ms | 2.20ms | +0.25ms (+11.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.61ms | 2.82ms | +0.78ms (+27.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.74ms | 1.77ms | -0.04ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 2.99ms | 3.94ms | -0.95ms (-24.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.35ms | 4.40ms | -1.04ms (-23.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.56ms | 9.59ms | -0.03ms (-0.3%) | 🟡 |
| Worst Frame Build Time Millis | 27.51ms | 26.49ms | +1.02ms (+3.8%) | 🟠 |
| Missed Frame Build Budget Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.92ms | 5.05ms | -0.13ms (-2.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.27ms | 9.87ms | +0.40ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 38.31ms | 42.28ms | -3.97ms (-9.4%) | 🟢 |
| Missed Frame Build Budget Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.82ms | 4.75ms | +0.06ms (+1.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 10.0 | -2 (-20.0%) | 🟢 |
| Old Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.40ms | +0.01ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 14.41ms | 18.07ms | -3.66ms (-20.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.04ms | 6.12ms | -2.08ms (-34.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.60ms | 1.40ms | +0.20ms (+14.6%) | 🔴 |
| Worst Frame Build Time Millis | 14.16ms | 12.36ms | +1.80ms (+14.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.23ms | 8.27ms | -3.03ms (-36.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.52ms | 5.30ms | +0.22ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 27.03ms | 25.75ms | +1.28ms (+5.0%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.28ms | 3.14ms | +0.15ms (+4.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 12.0 | +2 (+16.7%) | 🔴 |
| Old Gen Gc Count | 7.5 | 5.5 | +2 (+36.4%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 20.71ms | 21.65ms | -0.94ms (-4.3%) | 🟡 |
| Worst Frame Build Time Millis | 43.57ms | 41.07ms | +2.50ms (+6.1%) | 🟠 |
| Missed Frame Build Budget Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Average Frame Rasterizer Time Millis | 2.99ms | 3.03ms | -0.04ms (-1.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.96ms | 0.90ms | +0.06ms (+6.6%) | 🟠 |
| Worst Frame Build Time Millis | 19.05ms | 16.95ms | +2.10ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.34ms | 5.75ms | -2.41ms (-42.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 3.5 | -4 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Old Gen Gc Count | 6.0 | 4.5 | +2 (+33.3%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.20ms | 2.07ms | +0.14ms (+6.6%) | 🟠 |
| Worst Frame Build Time Millis | 8.28ms | 7.68ms | +0.60ms (+7.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.76ms | 3.63ms | +0.13ms (+3.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.63ms | 7.85ms | +0.78ms (+10.0%) | 🟠 |
| Worst Frame Build Time Millis | 38.50ms | 35.13ms | +3.38ms (+9.6%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.70ms | 5.08ms | +0.63ms (+12.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.04ms | 1.07ms | -0.03ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 6.53ms | 8.66ms | -2.13ms (-24.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.70ms | 7.24ms | -1.54ms (-21.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 5.0 | -3 (-60.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.12ms | 1.22ms | -0.10ms (-8.5%) | 🟢 |
| Worst Frame Build Time Millis | 4.71ms | 5.89ms | -1.18ms (-20.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.44ms | 8.88ms | -1.44ms (-16.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.63ms | 1.64ms | -0.02ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 3.38ms | 3.78ms | -0.40ms (-10.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.17ms | 6.67ms | -0.50ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

