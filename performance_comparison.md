## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 35.8%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 23.9%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 55.0%
- 🔴 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 15.1%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 16.2%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 26.1%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 5.2%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 11.1%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 9.6%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 13.7%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 12.5%
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 12.3%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 13.7%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 5.3%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 14.5%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 7.4%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 12.1%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 11.2%

**Performance Improvements:**
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 22.8%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.27ms | 2.88ms | +0.40ms (+13.7%) | 🔴 |
| Worst Frame Build Time Millis | 8.27ms | 7.15ms | +1.11ms (+15.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.41ms | 5.13ms | -0.72ms (-14.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.14ms | 4.89ms | +0.26ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 18.67ms | 15.64ms | +3.03ms (+19.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.00ms | 5.94ms | +0.06ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.68ms | +0.09ms (+13.7%) | 🔴 |
| Worst Frame Build Time Millis | 3.04ms | 4.25ms | -1.21ms (-28.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.32ms | 5.21ms | +0.11ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.51ms | +0.28ms (+55.0%) | 🔴 |
| Worst Frame Build Time Millis | 3.00ms | 1.86ms | +1.14ms (+61.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.73ms | 4.66ms | +1.07ms (+22.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.86ms | 9.58ms | +2.29ms (+23.9%) | 🔴 |
| Worst Frame Build Time Millis | 33.59ms | 26.88ms | +6.72ms (+25.0%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.42ms | 5.22ms | +0.19ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.85ms | 7.83ms | +0.02ms (+0.3%) | 🟠 |
| Worst Frame Build Time Millis | 15.21ms | 15.71ms | -0.50ms (-3.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.93ms | 7.00ms | -0.07ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.04ms | 2.64ms | -0.60ms (-22.8%) | 🟢 |
| Worst Frame Build Time Millis | 23.90ms | 26.04ms | -2.13ms (-8.2%) | 🟢 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.80ms | 6.90ms | -0.10ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.5 | 1.25 | +1 (+100.0%) | 🔴 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.67ms | +0.05ms (+7.4%) | 🟠 |
| Worst Frame Build Time Millis | 1.88ms | 1.72ms | +0.16ms (+9.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.14ms | 4.23ms | -0.08ms (-2.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.95ms | 2.63ms | +0.32ms (+12.3%) | 🔴 |
| Worst Frame Build Time Millis | 9.95ms | 8.71ms | +1.25ms (+14.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.32ms | 4.45ms | -0.12ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.69ms | +0.11ms (+16.2%) | 🔴 |
| Worst Frame Build Time Millis | 4.37ms | 3.57ms | +0.81ms (+22.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.68ms | 4.51ms | +0.16ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.75 | +0 (+33.3%) | 🔴 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.58ms | +0.03ms (+4.7%) | 🟠 |
| Worst Frame Build Time Millis | 2.15ms | 2.34ms | -0.19ms (-8.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.38ms | 4.75ms | -0.36ms (-7.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.17ms | 2.21ms | -0.04ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 5.16ms | 4.99ms | +0.18ms (+3.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.48ms | 5.69ms | -0.22ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.05ms | 6.35ms | +0.70ms (+11.1%) | 🔴 |
| Worst Frame Build Time Millis | 26.05ms | 21.15ms | +4.90ms (+23.2%) | 🔴 |
| Missed Frame Build Budget Count | 5.75 | 4.0 | +2 (+43.8%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.35ms | 9.01ms | +0.35ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.87ms | 14.57ms | +0.30ms (+2.1%) | 🟠 |
| Worst Frame Build Time Millis | 43.63ms | 49.89ms | -6.26ms (-12.6%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.10ms | 9.40ms | -0.31ms (-3.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.5 | -2 (-15.8%) | 🟢 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.57ms | 1.24ms | +0.32ms (+26.1%) | 🔴 |
| Worst Frame Build Time Millis | 9.38ms | 7.83ms | +1.55ms (+19.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.95ms | 9.50ms | -0.54ms (-5.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 6.25 | 6.0 | +0 (+4.2%) | 🟠 |
| New Gen Gc Count | 7.5 | 6.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.27ms | 1.24ms | +0.03ms (+2.3%) | 🟠 |
| Worst Frame Build Time Millis | 7.57ms | 6.65ms | +0.92ms (+13.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.77ms | 7.66ms | -0.89ms (-11.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.75 | +1 (+100.0%) | 🔴 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.90ms | 5.24ms | +0.66ms (+12.5%) | 🔴 |
| Worst Frame Build Time Millis | 27.75ms | 23.50ms | +4.26ms (+18.1%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.95ms | 6.60ms | +0.35ms (+5.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.84ms | 21.27ms | +2.57ms (+12.1%) | 🔴 |
| Worst Frame Build Time Millis | 44.67ms | 46.96ms | -2.29ms (-4.9%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 8.75 | +0 (+2.9%) | 🟠 |
| Average Frame Rasterizer Time Millis | 7.96ms | 7.50ms | +0.46ms (+6.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.18ms | 1.08ms | +0.10ms (+9.6%) | 🟠 |
| Worst Frame Build Time Millis | 18.29ms | 13.56ms | +4.73ms (+34.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.83ms | 6.53ms | +0.30ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.5 | 1.75 | +1 (+42.9%) | 🔴 |
| New Gen Gc Count | 6.25 | 6.0 | +0 (+4.2%) | 🟠 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.16ms | +0.18ms (+15.1%) | 🔴 |
| Worst Frame Build Time Millis | 7.49ms | 5.79ms | +1.69ms (+29.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.05ms | 7.15ms | -0.10ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.20ms | 7.79ms | +0.41ms (+5.2%) | 🟠 |
| Worst Frame Build Time Millis | 30.84ms | 29.36ms | +1.48ms (+5.0%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.87ms | 10.17ms | -0.30ms (-2.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.35ms | 1.22ms | +0.14ms (+11.2%) | 🔴 |
| Worst Frame Build Time Millis | 5.86ms | 5.60ms | +0.26ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.41ms | 11.17ms | +0.24ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 23.75 | 13.5 | +10 (+75.9%) | 🔴 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.50ms | 1.11ms | +0.40ms (+35.8%) | 🔴 |
| Worst Frame Build Time Millis | 5.50ms | 5.95ms | -0.45ms (-7.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.76ms | 11.51ms | +3.25ms (+28.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.25 | 2.0 | +4 (+212.5%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.32ms | 3.77ms | +0.55ms (+14.5%) | 🔴 |
| Worst Frame Build Time Millis | 7.15ms | 8.97ms | -1.83ms (-20.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.03ms | 10.78ms | +0.25ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
