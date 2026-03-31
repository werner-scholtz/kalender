## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 21.8%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 19.9%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 13.9%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 5.4%

**Performance Improvements:**
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 10.1%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 18.2%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 13.6%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 12.9%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.88ms | 2.40ms | +0.48ms (+19.9%) | 🔴 |
| Worst Frame Build Time Millis | 7.15ms | 5.71ms | +1.45ms (+25.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.13ms | 3.95ms | +1.18ms (+29.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.89ms | 4.89ms | -0.00ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 15.64ms | 17.90ms | -2.26ms (-12.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.94ms | 6.09ms | -0.15ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.75ms | -0.07ms (-9.3%) | 🟢 |
| Worst Frame Build Time Millis | 4.25ms | 3.52ms | +0.73ms (+20.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.21ms | 5.04ms | +0.17ms (+3.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.59ms | -0.08ms (-12.9%) | 🟢 |
| Worst Frame Build Time Millis | 1.86ms | 2.18ms | -0.32ms (-14.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.66ms | 4.60ms | +0.06ms (+1.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.58ms | 9.33ms | +0.25ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 26.88ms | 26.44ms | +0.43ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.22ms | 5.10ms | +0.12ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.83ms | 7.73ms | +0.11ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 15.71ms | 16.68ms | -0.97ms (-5.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.00ms | 6.80ms | +0.20ms (+2.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.64ms | 2.16ms | +0.47ms (+21.8%) | 🔴 |
| Worst Frame Build Time Millis | 26.04ms | 28.35ms | -2.31ms (-8.2%) | 🟢 |
| Missed Frame Build Budget Count | 1.25 | 1.5 | -0 (-16.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.90ms | 6.70ms | +0.20ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.5 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.68ms | -0.01ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 1.72ms | 1.79ms | -0.07ms (-3.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.23ms | 3.65ms | +0.57ms (+15.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.63ms | 2.82ms | -0.19ms (-6.8%) | 🟢 |
| Worst Frame Build Time Millis | 8.71ms | 9.42ms | -0.71ms (-7.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.45ms | 4.13ms | +0.32ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.80ms | -0.11ms (-13.6%) | 🟢 |
| Worst Frame Build Time Millis | 3.57ms | 4.65ms | -1.09ms (-23.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.51ms | 4.47ms | +0.05ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.58ms | 0.60ms | -0.02ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 2.34ms | 2.32ms | +0.03ms (+1.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.75ms | 4.11ms | +0.64ms (+15.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.21ms | 2.12ms | +0.09ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 4.99ms | 5.52ms | -0.54ms (-9.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.69ms | 5.46ms | +0.24ms (+4.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.35ms | 6.81ms | -0.47ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 21.15ms | 26.67ms | -5.52ms (-20.7%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.75 | -1 (-15.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 9.01ms | 9.11ms | -0.10ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.57ms | 13.82ms | +0.75ms (+5.4%) | 🟠 |
| Worst Frame Build Time Millis | 49.89ms | 37.52ms | +12.37ms (+33.0%) | 🔴 |
| Missed Frame Build Budget Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.40ms | 8.84ms | +0.56ms (+6.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 8.0 | +2 (+18.8%) | 🔴 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.24ms | 1.36ms | -0.11ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 7.83ms | 7.61ms | +0.23ms (+3.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.50ms | 8.21ms | +1.29ms (+15.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.0 | 2.0 | +4 (+200.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.24ms | 1.36ms | -0.12ms (-9.0%) | 🟢 |
| Worst Frame Build Time Millis | 6.65ms | 7.38ms | -0.73ms (-9.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.66ms | 6.81ms | +0.85ms (+12.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.24ms | 5.73ms | -0.49ms (-8.6%) | 🟢 |
| Worst Frame Build Time Millis | 23.50ms | 23.16ms | +0.33ms (+1.4%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 3.75 | -0 (-6.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.60ms | 6.75ms | -0.15ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.27ms | 23.65ms | -2.38ms (-10.1%) | 🟢 |
| Worst Frame Build Time Millis | 46.96ms | 45.67ms | +1.29ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 8.75 | 9.0 | -0 (-2.8%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.50ms | 7.65ms | -0.15ms (-2.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.08ms | 1.14ms | -0.06ms (-5.1%) | 🟢 |
| Worst Frame Build Time Millis | 13.56ms | 17.34ms | -3.78ms (-21.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.53ms | 6.18ms | +0.35ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.75 | 1.5 | +0 (+16.7%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.16ms | 1.26ms | -0.10ms (-8.0%) | 🟢 |
| Worst Frame Build Time Millis | 5.79ms | 6.81ms | -1.02ms (-14.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.15ms | 6.81ms | +0.34ms (+4.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.79ms | 8.00ms | -0.21ms (-2.6%) | 🟡 |
| Worst Frame Build Time Millis | 29.36ms | 30.67ms | -1.31ms (-4.3%) | 🟡 |
| Missed Frame Build Budget Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 10.17ms | 9.65ms | +0.52ms (+5.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.34ms | -0.12ms (-9.0%) | 🟢 |
| Worst Frame Build Time Millis | 5.60ms | 5.29ms | +0.31ms (+5.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.17ms | 10.90ms | +0.27ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 13.5 | 15.75 | -2 (-14.3%) | 🟢 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 1.35ms | -0.25ms (-18.2%) | 🟢 |
| Worst Frame Build Time Millis | 5.95ms | 6.44ms | -0.49ms (-7.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.51ms | 12.27ms | -0.75ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 3.75 | -2 (-46.7%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.77ms | 3.31ms | +0.46ms (+13.9%) | 🔴 |
| Worst Frame Build Time Millis | 8.97ms | 6.59ms | +2.39ms (+36.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.78ms | 10.91ms | -0.12ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>
