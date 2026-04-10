## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 20.3%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 20.5%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 18.8%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 21.1%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 33.6%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 7.7%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 7.7%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 8.0%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 6.6%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 11.5%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 9.6%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 9.5%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 14.6%

**Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 18.2%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.29ms | 3.00ms | +0.28ms (+9.5%) | 🟠 |
| Worst Frame Build Time Millis | 8.26ms | 7.70ms | +0.57ms (+7.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.72ms | 4.03ms | +0.69ms (+17.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.60ms | 5.02ms | +0.58ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 17.79ms | 15.97ms | +1.81ms (+11.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.83ms | 5.49ms | +0.34ms (+6.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.70ms | +0.06ms (+8.0%) | 🟠 |
| Worst Frame Build Time Millis | 4.04ms | 3.25ms | +0.78ms (+24.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.47ms | 5.17ms | +0.30ms (+5.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.0 | 0.75 | +1 (+166.7%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 3.5 | +2 (+42.9%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.52ms | 0.43ms | +0.09ms (+20.5%) | 🔴 |
| Worst Frame Build Time Millis | 2.16ms | 1.74ms | +0.42ms (+24.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.91ms | 5.01ms | -0.10ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.87ms | 9.80ms | +2.07ms (+21.1%) | 🔴 |
| Worst Frame Build Time Millis | 33.66ms | 27.56ms | +6.11ms (+22.2%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.82ms | 4.46ms | +1.36ms (+30.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.51ms | 7.43ms | +1.08ms (+14.6%) | 🔴 |
| Worst Frame Build Time Millis | 18.00ms | 15.59ms | +2.41ms (+15.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.91ms | 6.36ms | +0.55ms (+8.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.21ms | 2.38ms | -0.17ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 23.86ms | 29.01ms | -5.15ms (-17.8%) | 🟢 |
| Missed Frame Build Budget Count | 1.75 | 1.25 | +0 (+40.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.71ms | 6.37ms | +0.34ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.0 | 0.25 | +2 (+700.0%) | 🔴 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 5.5 | 3.0 | +2 (+83.3%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.67ms | +0.04ms (+6.6%) | 🟠 |
| Worst Frame Build Time Millis | 1.85ms | 1.78ms | +0.07ms (+4.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.83ms | 3.58ms | +0.25ms (+6.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.95ms | 2.84ms | +0.11ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 11.15ms | 9.78ms | +1.37ms (+14.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.23ms | 4.06ms | +0.17ms (+4.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.85ms | 0.72ms | +0.13ms (+18.8%) | 🔴 |
| Worst Frame Build Time Millis | 4.16ms | 4.62ms | -0.46ms (-10.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.52ms | 4.23ms | +0.30ms (+7.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.48ms | +0.00ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.50ms | 2.35ms | +0.15ms (+6.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.93ms | 3.99ms | -0.06ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.07ms | 1.92ms | +0.15ms (+7.7%) | 🟠 |
| Worst Frame Build Time Millis | 4.89ms | 4.36ms | +0.53ms (+12.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.93ms | 5.43ms | +0.50ms (+9.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.14ms | 7.20ms | -0.06ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 23.88ms | 24.53ms | -0.65ms (-2.6%) | 🟡 |
| Missed Frame Build Budget Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.91ms | 8.80ms | +0.11ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 16.39ms | 13.62ms | +2.77ms (+20.3%) | 🔴 |
| Worst Frame Build Time Millis | 59.01ms | 38.19ms | +20.81ms (+54.5%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 3.75 | +0 (+6.7%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.17ms | 9.64ms | -0.47ms (-4.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.52ms | -0.06ms (-3.9%) | 🟡 |
| Worst Frame Build Time Millis | 9.30ms | 9.70ms | -0.40ms (-4.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.53ms | 8.93ms | -0.40ms (-4.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| New Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 1.11ms | -0.20ms (-18.2%) | 🟢 |
| Worst Frame Build Time Millis | 5.14ms | 5.91ms | -0.77ms (-13.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.07ms | 7.40ms | -1.33ms (-18.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.52ms | 5.63ms | -0.11ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 22.02ms | 25.86ms | -3.85ms (-14.9%) | 🟢 |
| Missed Frame Build Budget Count | 3.25 | 4.0 | -1 (-18.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.69ms | 6.52ms | +0.17ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.71ms | 22.62ms | +0.08ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 49.77ms | 45.19ms | +4.58ms (+10.1%) | 🔴 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.31ms | 6.78ms | +0.54ms (+7.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 15.5 | 14.0 | +2 (+10.7%) | 🔴 |
| Old Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.04ms | 1.15ms | -0.11ms (-9.9%) | 🟢 |
| Worst Frame Build Time Millis | 13.58ms | 23.02ms | -9.43ms (-41.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.67ms | 6.32ms | +0.36ms (+5.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.5 | 2.25 | +0 (+11.1%) | 🔴 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.43ms | 1.37ms | +0.06ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 7.13ms | 7.69ms | -0.56ms (-7.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.96ms | 6.71ms | +0.24ms (+3.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.59ms | 7.84ms | +0.75ms (+9.6%) | 🟠 |
| Worst Frame Build Time Millis | 30.74ms | 29.95ms | +0.79ms (+2.7%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.77ms | 9.43ms | +0.34ms (+3.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.38ms | 1.28ms | +0.10ms (+7.7%) | 🟠 |
| Worst Frame Build Time Millis | 6.91ms | 5.01ms | +1.90ms (+37.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.77ms | 11.20ms | +0.57ms (+5.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 27.75 | 15.0 | +13 (+85.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 1.11ms | -0.08ms (-7.2%) | 🟢 |
| Worst Frame Build Time Millis | 5.73ms | 6.20ms | -0.47ms (-7.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.58ms | 11.87ms | -0.29ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 3.25 | 3.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.43ms | 3.32ms | +1.11ms (+33.6%) | 🔴 |
| Worst Frame Build Time Millis | 9.39ms | 6.98ms | +2.41ms (+34.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.50ms | 9.48ms | +1.02ms (+10.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>
