## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 17.0%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 23.4%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 21.4%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 15.8%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 23.4%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 12.0%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 9.3%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 8.8%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 13.2%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 6.5%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 5.7%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 11.3%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.23ms | 3.73ms | +0.49ms (+13.2%) | 🔴 |
| Worst Frame Build Time Millis | 8.32ms | 7.30ms | +1.02ms (+14.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.88ms | 1.96ms | -0.08ms (-3.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.80ms | 4.90ms | -0.10ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 16.66ms | 16.84ms | -0.18ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.77ms | 3.96ms | -0.19ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.77ms | +0.05ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 4.27ms | 4.63ms | -0.36ms (-7.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.79ms | 2.89ms | +0.90ms (+31.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.55ms | +0.02ms (+3.7%) | 🟠 |
| Worst Frame Build Time Millis | 4.59ms | 3.99ms | +0.60ms (+15.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.84ms | 2.63ms | +1.21ms (+45.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.90ms | 7.10ms | +0.80ms (+11.3%) | 🔴 |
| Worst Frame Build Time Millis | 22.59ms | 19.89ms | +2.70ms (+13.6%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.71ms | 3.05ms | -0.34ms (-11.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.97ms | 6.21ms | -0.24ms (-3.8%) | 🟡 |
| Worst Frame Build Time Millis | 10.80ms | 11.19ms | -0.39ms (-3.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.29ms | 3.48ms | -0.19ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.07ms | 1.89ms | +0.18ms (+9.3%) | 🟠 |
| Worst Frame Build Time Millis | 29.17ms | 30.68ms | -1.51ms (-4.9%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.17ms | 2.92ms | +1.26ms (+43.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.19ms | +0.02ms (+1.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.28ms | 2.26ms | +0.02ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.01ms | 2.06ms | -0.05ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.72ms | 2.82ms | -0.10ms (-3.4%) | 🟡 |
| Worst Frame Build Time Millis | 10.98ms | 9.43ms | +1.55ms (+16.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.23ms | 3.24ms | -0.01ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.57ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 2.97ms | 2.19ms | +0.78ms (+35.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.93ms | 2.42ms | +0.51ms (+21.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.51ms | -0.02ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 1.75ms | 1.78ms | -0.04ms (-2.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.01ms | 1.94ms | +0.08ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.93ms | 0.81ms | +0.13ms (+15.8%) | 🔴 |
| Worst Frame Build Time Millis | 1.41ms | 1.07ms | +0.34ms (+32.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.07ms | 4.22ms | -0.15ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.44ms | 10.51ms | +0.93ms (+8.8%) | 🟠 |
| Worst Frame Build Time Millis | 31.85ms | 29.45ms | +2.40ms (+8.1%) | 🟠 |
| Missed Frame Build Budget Count | 8.25 | 7.5 | +1 (+10.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.40ms | 5.19ms | +0.21ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.19ms | 12.42ms | -0.23ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 43.22ms | 41.29ms | +1.92ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.25 | 3.5 | -0 (-7.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.35ms | 5.34ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.79ms | 1.53ms | +0.26ms (+17.0%) | 🔴 |
| Worst Frame Build Time Millis | 14.26ms | 13.89ms | +0.36ms (+2.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.21ms | 4.07ms | +2.14ms (+52.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.55ms | 1.47ms | +0.08ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 13.86ms | 13.67ms | +0.20ms (+1.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.77ms | 3.71ms | +3.07ms (+82.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.47ms | 5.46ms | +0.02ms (+0.3%) | 🟠 |
| Worst Frame Build Time Millis | 27.58ms | 29.75ms | -2.18ms (-7.3%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.24ms | 3.35ms | -0.12ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 19.31ms | 20.88ms | -1.58ms (-7.6%) | 🟢 |
| Worst Frame Build Time Millis | 42.19ms | 42.32ms | -0.12ms (-0.3%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.10ms | 3.53ms | -0.43ms (-12.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 18.0 | +1 (+5.6%) | 🟠 |
| Old Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.95ms | 0.85ms | +0.10ms (+12.0%) | 🔴 |
| Worst Frame Build Time Millis | 15.92ms | 13.41ms | +2.51ms (+18.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.70ms | 3.28ms | +2.42ms (+73.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 3.0 | +2 (+66.7%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.35ms | 2.39ms | -0.04ms (-1.7%) | 🟡 |
| Worst Frame Build Time Millis | 8.83ms | 8.76ms | +0.06ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.48ms | 3.52ms | -0.04ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.89ms | 9.06ms | -0.17ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 44.41ms | 45.56ms | -1.15ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.38ms | 5.61ms | -0.23ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.04ms | +0.24ms (+23.4%) | 🔴 |
| Worst Frame Build Time Millis | 7.90ms | 6.38ms | +1.52ms (+23.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.22ms | 6.32ms | +0.90ms (+14.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.0 | 8.75 | -6 (-65.7%) | 🟢 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.05ms | 0.85ms | +0.20ms (+23.4%) | 🔴 |
| Worst Frame Build Time Millis | 4.63ms | 3.72ms | +0.90ms (+24.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.75ms | 5.63ms | +0.12ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.95ms | 0.78ms | +0.17ms (+21.4%) | 🔴 |
| Worst Frame Build Time Millis | 2.11ms | 1.08ms | +1.02ms (+94.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.22ms | 5.15ms | +1.07ms (+20.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

</details>

