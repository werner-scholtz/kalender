## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 18.4%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 43.9%

**Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 40.6%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 13.5%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 12.1%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 12.3%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 16.5%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 27.1%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 18.4%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 14.3%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 10.1%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 13.5%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.67ms | 2.89ms | -0.22ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 6.53ms | 6.86ms | -0.33ms (-4.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.89ms | 4.77ms | +0.12ms (+2.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.88ms | 5.27ms | -0.39ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 14.63ms | 15.49ms | -0.87ms (-5.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.80ms | 6.16ms | +0.64ms (+10.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.84ms | -0.14ms (-16.5%) | 🟢 |
| Worst Frame Build Time Millis | 4.15ms | 5.15ms | -1.00ms (-19.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.93ms | 5.66ms | +0.27ms (+4.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.25 | 2.0 | +0 (+12.5%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.64ms | -0.01ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 2.86ms | 3.57ms | -0.71ms (-20.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.11ms | 6.16ms | +0.95ms (+15.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.75 | +1 (+100.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.32ms | 10.77ms | -1.45ms (-13.5%) | 🟢 |
| Worst Frame Build Time Millis | 25.93ms | 30.34ms | -4.41ms (-14.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.82ms | 5.39ms | +0.43ms (+7.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.49ms | 8.33ms | -0.84ms (-10.1%) | 🟢 |
| Worst Frame Build Time Millis | 13.43ms | 16.09ms | -2.66ms (-16.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.97ms | 7.12ms | -0.15ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.96ms | 2.68ms | -0.73ms (-27.1%) | 🟢 |
| Worst Frame Build Time Millis | 22.74ms | 33.04ms | -10.30ms (-31.2%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.52ms | 6.73ms | -0.21ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.83ms | 0.70ms | +0.13ms (+18.4%) | 🔴 |
| Worst Frame Build Time Millis | 2.21ms | 1.81ms | +0.40ms (+22.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.79ms | 3.84ms | +0.95ms (+24.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.88ms | 2.92ms | -0.04ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 12.56ms | 10.06ms | +2.50ms (+24.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.68ms | 4.23ms | +0.45ms (+10.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.80ms | -0.07ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.40ms | 3.51ms | -0.11ms (-3.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.88ms | 4.47ms | +0.41ms (+9.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.51ms | +0.22ms (+43.9%) | 🔴 |
| Worst Frame Build Time Millis | 3.04ms | 2.14ms | +0.90ms (+42.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.73ms | 4.21ms | +1.52ms (+36.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.98ms | 2.13ms | -0.14ms (-6.7%) | 🟢 |
| Worst Frame Build Time Millis | 4.85ms | 4.13ms | +0.72ms (+17.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.97ms | 5.79ms | +0.18ms (+3.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.27ms | 7.58ms | -0.30ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 26.81ms | 26.22ms | +0.59ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 6.0 | 6.75 | -1 (-11.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.68ms | 9.40ms | +0.28ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.32ms | 14.79ms | -1.47ms (-9.9%) | 🟢 |
| Worst Frame Build Time Millis | 38.77ms | 43.78ms | -5.01ms (-11.4%) | 🟢 |
| Missed Frame Build Budget Count | 3.25 | 4.0 | -1 (-18.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.86ms | 9.58ms | +0.28ms (+2.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.63ms | -0.30ms (-18.4%) | 🟢 |
| Worst Frame Build Time Millis | 9.02ms | 12.13ms | -3.11ms (-25.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.68ms | 9.03ms | +0.65ms (+7.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 12.5 | 8.75 | +4 (+42.9%) | 🔴 |
| New Gen Gc Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.89ms | 1.01ms | -0.12ms (-12.1%) | 🟢 |
| Worst Frame Build Time Millis | 4.60ms | 4.75ms | -0.14ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.09ms | 7.07ms | +1.02ms (+14.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 1.75 | -0 (-14.3%) | 🟢 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.24ms | 5.97ms | -0.73ms (-12.3%) | 🟢 |
| Worst Frame Build Time Millis | 21.23ms | 30.08ms | -8.86ms (-29.4%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 4.5 | -1 (-22.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.75ms | 7.27ms | -0.52ms (-7.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.43ms | 24.65ms | -0.22ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 43.20ms | 52.32ms | -9.12ms (-17.4%) | 🟢 |
| Missed Frame Build Budget Count | 8.25 | 9.0 | -1 (-8.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.24ms | 7.53ms | +0.71ms (+9.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 8.5 | -1 (-11.8%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 1.28ms | -0.09ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 14.63ms | 15.74ms | -1.12ms (-7.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.60ms | 6.67ms | -0.08ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 4.0 | 2.0 | +2 (+100.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.50ms | -0.22ms (-14.3%) | 🟢 |
| Worst Frame Build Time Millis | 6.80ms | 9.45ms | -2.65ms (-28.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.00ms | 6.27ms | +0.73ms (+11.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.07ms | 8.72ms | -0.64ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 29.93ms | 29.62ms | +0.31ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 2.75 | 3.25 | -0 (-15.4%) | 🟢 |
| Average Frame Rasterizer Time Millis | 10.28ms | 10.44ms | -0.16ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.24ms | 1.43ms | -0.19ms (-13.5%) | 🟢 |
| Worst Frame Build Time Millis | 5.09ms | 5.97ms | -0.88ms (-14.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.72ms | 11.72ms | -0.99ms (-8.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 14.0 | 25.5 | -12 (-45.1%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 1.26ms | -0.51ms (-40.6%) | 🟢 |
| Worst Frame Build Time Millis | 3.92ms | 6.77ms | -2.86ms (-42.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.87ms | 11.50ms | -0.63ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.25 | 3.5 | -0 (-7.1%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.56ms | 3.44ms | +0.12ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 7.47ms | 7.52ms | -0.05ms (-0.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.15ms | 9.75ms | +1.41ms (+14.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

</details>
