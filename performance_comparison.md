## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 21.4%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 14.3%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 6.9%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 14.1%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 11.6%

**Performance Improvements:**
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 23.7%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.38ms | 2.95ms | +0.42ms (+14.3%) | 🔴 |
| Worst Frame Build Time Millis | 8.59ms | 7.53ms | +1.05ms (+14.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.99ms | 4.80ms | +0.19ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.98ms | 4.77ms | +0.21ms (+4.4%) | 🟠 |
| Worst Frame Build Time Millis | 16.29ms | 16.70ms | -0.41ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.91ms | 6.11ms | -0.21ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.66ms | 0.67ms | -0.01ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 2.83ms | 3.16ms | -0.32ms (-10.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.84ms | 5.75ms | +0.09ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.0 | 1.5 | +2 (+100.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.46ms | 0.38ms | +0.08ms (+21.4%) | 🔴 |
| Worst Frame Build Time Millis | 1.95ms | 1.72ms | +0.23ms (+13.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.11ms | 4.97ms | +1.14ms (+23.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.18ms | 11.22ms | -1.04ms (-9.3%) | 🟢 |
| Worst Frame Build Time Millis | 28.78ms | 31.85ms | -3.07ms (-9.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.88ms | 5.50ms | +0.38ms (+6.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.07ms | 7.65ms | -0.58ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 13.29ms | 16.21ms | -2.92ms (-18.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.75ms | 6.94ms | -0.19ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.04ms | 2.06ms | -0.02ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 25.76ms | 23.27ms | +2.48ms (+10.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.52ms | 6.94ms | -0.42ms (-6.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.5 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.60ms | +0.07ms (+11.6%) | 🔴 |
| Worst Frame Build Time Millis | 1.69ms | 1.54ms | +0.15ms (+9.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.00ms | 3.85ms | +0.15ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.55ms | 2.58ms | -0.03ms (-1.1%) | 🟡 |
| Worst Frame Build Time Millis | 9.00ms | 8.93ms | +0.07ms (+0.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.40ms | 4.31ms | +0.09ms (+2.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.69ms | +0.03ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 4.85ms | 4.29ms | +0.56ms (+13.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.86ms | 4.71ms | +0.16ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.25 | -1 (-80.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.47ms | +0.03ms (+6.9%) | 🟠 |
| Worst Frame Build Time Millis | 2.78ms | 2.36ms | +0.42ms (+17.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.63ms | 4.70ms | -0.07ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.79ms | 2.35ms | -0.56ms (-23.7%) | 🟢 |
| Worst Frame Build Time Millis | 3.78ms | 5.77ms | -1.99ms (-34.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.25ms | 5.75ms | -0.50ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.12ms | 6.93ms | +0.19ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 25.83ms | 23.84ms | +1.99ms (+8.4%) | 🟠 |
| Missed Frame Build Budget Count | 6.0 | 4.75 | +1 (+26.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 12.27ms | 9.49ms | +2.78ms (+29.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.38ms | 14.39ms | -1.01ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 40.22ms | 45.04ms | -4.82ms (-10.7%) | 🟢 |
| Missed Frame Build Budget Count | 3.25 | 3.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.47ms | 9.34ms | +0.13ms (+1.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 1.28ms | -0.03ms (-2.2%) | 🟡 |
| Worst Frame Build Time Millis | 7.77ms | 9.15ms | -1.38ms (-15.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.13ms | 9.07ms | +0.06ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 11.0 | 12.25 | -1 (-10.2%) | 🟢 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.70ms | +0.01ms (+1.8%) | 🟠 |
| Worst Frame Build Time Millis | 3.57ms | 3.22ms | +0.36ms (+11.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.46ms | 7.32ms | -0.85ms (-11.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.65ms | 5.61ms | +0.04ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 26.76ms | 26.94ms | -0.18ms (-0.7%) | 🟡 |
| Missed Frame Build Budget Count | 3.75 | 4.0 | -0 (-6.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.01ms | 6.81ms | +0.20ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.86ms | 21.46ms | +0.40ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 43.33ms | 41.88ms | +1.46ms (+3.5%) | 🟠 |
| Missed Frame Build Budget Count | 8.25 | 8.75 | -0 (-5.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.75ms | 7.91ms | -0.16ms (-2.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.12ms | 1.16ms | -0.05ms (-3.9%) | 🟡 |
| Worst Frame Build Time Millis | 14.84ms | 14.55ms | +0.29ms (+2.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.43ms | 6.36ms | +0.07ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.5 | +1 (+150.0%) | 🔴 |
| New Gen Gc Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.23ms | -0.02ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 7.18ms | 6.91ms | +0.27ms (+3.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.04ms | 6.86ms | +0.18ms (+2.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.88ms | 7.87ms | +0.01ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 29.79ms | 29.49ms | +0.30ms (+1.0%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 10.05ms | 10.20ms | -0.15ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.5 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.21ms | +0.03ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 5.42ms | 6.56ms | -1.15ms (-17.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.79ms | 11.07ms | -0.29ms (-2.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 15.0 | 20.0 | -5 (-25.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 0.93ms | -0.02ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 4.59ms | 5.01ms | -0.42ms (-8.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.33ms | 11.99ms | +0.34ms (+2.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.25 | 3.75 | +0 (+13.3%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.81ms | 3.34ms | +0.47ms (+14.1%) | 🔴 |
| Worst Frame Build Time Millis | 8.25ms | 7.02ms | +1.24ms (+17.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.17ms | 10.44ms | +0.73ms (+7.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

</details>
