## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 16.9%
- 🔴 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 15.5%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 18.1%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 27.1%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 50.5%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 16.0%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 62.0%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 7.6%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 5.9%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 11.1%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 8.5%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 14.4%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 12.7%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 11.6%
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 9.9%

**Performance Improvements:**
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 16.8%
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 11.8%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.75ms | 3.11ms | -0.37ms (-11.8%) | 🟢 |
| Worst Frame Build Time Millis | 6.54ms | 7.85ms | -1.31ms (-16.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.91ms | 4.74ms | +0.17ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.27ms | 5.13ms | +0.14ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 17.45ms | 16.33ms | +1.12ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.03ms | 5.55ms | +0.48ms (+8.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 6.0 | 3.5 | +2 (+71.4%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.83ms | 0.71ms | +0.12ms (+16.9%) | 🔴 |
| Worst Frame Build Time Millis | 4.25ms | 2.88ms | +1.37ms (+47.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.50ms | 5.32ms | +0.18ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 2.25 | -1 (-33.3%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 3.5 | +2 (+42.9%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 0.56ms | +0.35ms (+62.0%) | 🔴 |
| Worst Frame Build Time Millis | 2.48ms | 1.91ms | +0.57ms (+30.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.99ms | 4.88ms | +1.11ms (+22.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 0.5 | +2 (+500.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.50ms | 12.62ms | -2.12ms (-16.8%) | 🟢 |
| Worst Frame Build Time Millis | 29.54ms | 35.82ms | -6.28ms (-17.5%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.42ms | 4.98ms | +0.45ms (+9.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.89ms | 7.66ms | +0.23ms (+3.1%) | 🟠 |
| Worst Frame Build Time Millis | 14.49ms | 17.21ms | -2.72ms (-15.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.88ms | 6.58ms | +0.30ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 4.5 | +2 (+33.3%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.39ms | 2.26ms | +0.13ms (+5.9%) | 🟠 |
| Worst Frame Build Time Millis | 23.59ms | 27.93ms | -4.34ms (-15.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.25 | 1.5 | -0 (-16.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.67ms | 6.68ms | -0.01ms (-0.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.5 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.64ms | +0.00ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 1.61ms | 1.69ms | -0.08ms (-4.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.90ms | 4.21ms | -0.31ms (-7.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.06ms | 2.78ms | +0.28ms (+9.9%) | 🟠 |
| Worst Frame Build Time Millis | 10.28ms | 9.49ms | +0.79ms (+8.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.32ms | 4.96ms | -0.63ms (-12.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 0.72ms | +0.19ms (+27.1%) | 🔴 |
| Worst Frame Build Time Millis | 5.11ms | 2.61ms | +2.50ms (+95.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.82ms | 5.18ms | -0.36ms (-6.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.93ms | 0.62ms | +0.31ms (+50.5%) | 🔴 |
| Worst Frame Build Time Millis | 3.56ms | 2.21ms | +1.35ms (+61.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.66ms | 4.56ms | +1.10ms (+24.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.17ms | 2.37ms | -0.20ms (-8.5%) | 🟢 |
| Worst Frame Build Time Millis | 5.30ms | 5.73ms | -0.43ms (-7.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.73ms | 5.46ms | +0.27ms (+4.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.35ms | 6.36ms | +0.99ms (+15.5%) | 🔴 |
| Worst Frame Build Time Millis | 28.52ms | 22.35ms | +6.17ms (+27.6%) | 🔴 |
| Missed Frame Build Budget Count | 6.25 | 5.5 | +1 (+13.6%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.39ms | 8.78ms | +0.61ms (+6.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.89ms | 13.58ms | +0.30ms (+2.2%) | 🟠 |
| Worst Frame Build Time Millis | 38.69ms | 40.78ms | -2.09ms (-5.1%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.39ms | 9.48ms | -0.10ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.57ms | 1.41ms | +0.16ms (+11.6%) | 🔴 |
| Worst Frame Build Time Millis | 11.21ms | 7.59ms | +3.63ms (+47.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.85ms | 8.42ms | +0.42ms (+5.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 9.75 | 1.75 | +8 (+457.1%) | 🔴 |
| New Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.17ms | +0.17ms (+14.4%) | 🔴 |
| Worst Frame Build Time Millis | 6.23ms | 7.15ms | -0.92ms (-12.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.60ms | 6.38ms | +0.22ms (+3.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.03ms | 5.60ms | +0.43ms (+7.6%) | 🟠 |
| Worst Frame Build Time Millis | 27.20ms | 26.27ms | +0.93ms (+3.5%) | 🟠 |
| Missed Frame Build Budget Count | 4.5 | 3.75 | +1 (+20.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.83ms | 6.68ms | +0.15ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.5 | -2 (-23.1%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.64ms | 23.15ms | +0.48ms (+2.1%) | 🟠 |
| Worst Frame Build Time Millis | 51.14ms | 44.55ms | +6.58ms (+14.8%) | 🔴 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.70ms | 7.62ms | +0.07ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.0 | +0 (+3.6%) | 🟠 |
| Old Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.11ms | +0.20ms (+18.1%) | 🔴 |
| Worst Frame Build Time Millis | 21.54ms | 13.35ms | +8.18ms (+61.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.87ms | 6.81ms | +0.06ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 3.75 | -3 (-73.3%) | 🟢 |
| New Gen Gc Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.18ms | +0.10ms (+8.5%) | 🟠 |
| Worst Frame Build Time Millis | 6.96ms | 6.15ms | +0.81ms (+13.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.90ms | 6.07ms | +0.83ms (+13.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.50ms | 7.54ms | +0.96ms (+12.7%) | 🔴 |
| Worst Frame Build Time Millis | 26.93ms | 27.49ms | -0.56ms (-2.0%) | 🟡 |
| Missed Frame Build Budget Count | 2.75 | 3.0 | -0 (-8.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 10.35ms | 9.39ms | +0.96ms (+10.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.51ms | 1.31ms | +0.21ms (+16.0%) | 🔴 |
| Worst Frame Build Time Millis | 7.14ms | 4.81ms | +2.33ms (+48.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.30ms | 12.10ms | -0.80ms (-6.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 18.5 | 24.75 | -6 (-25.3%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.40ms | +0.01ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 6.07ms | 4.40ms | +1.67ms (+37.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.83ms | 14.36ms | -2.52ms (-17.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.75 | 4.5 | -2 (-38.9%) | 🟢 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.79ms | 3.41ms | +0.38ms (+11.1%) | 🔴 |
| Worst Frame Build Time Millis | 7.28ms | 6.68ms | +0.60ms (+8.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.30ms | 10.51ms | -0.21ms (-2.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

</details>
