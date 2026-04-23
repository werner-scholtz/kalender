## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 45.8%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 18.1%
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 15.2%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 16.0%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 26.4%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 15.8%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 16.9%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 8.9%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.2%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 10.8%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 7.5%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 7.0%

**Performance Improvements:**
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 16.4%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.10ms | 2.67ms | +0.43ms (+16.0%) | 🔴 |
| Worst Frame Build Time Millis | 7.56ms | 6.56ms | +1.01ms (+15.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.64ms | 4.18ms | +0.46ms (+11.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.37ms | 5.02ms | +0.35ms (+7.0%) | 🟠 |
| Worst Frame Build Time Millis | 16.77ms | 15.69ms | +1.09ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 0.5 | +1 (+150.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.72ms | 5.68ms | +0.04ms (+0.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.73ms | +0.03ms (+4.4%) | 🟠 |
| Worst Frame Build Time Millis | 2.92ms | 4.10ms | -1.18ms (-28.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.38ms | 5.36ms | +0.03ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 2.25 | -2 (-66.7%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.55ms | +0.09ms (+15.8%) | 🔴 |
| Worst Frame Build Time Millis | 3.01ms | 2.21ms | +0.80ms (+36.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.18ms | 5.75ms | -0.57ms (-9.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.20ms | 9.65ms | +2.55ms (+26.4%) | 🔴 |
| Worst Frame Build Time Millis | 34.65ms | 26.92ms | +7.73ms (+28.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.52ms | 4.74ms | +1.78ms (+37.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.71ms | 7.70ms | +0.01ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 15.10ms | 14.59ms | +0.51ms (+3.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.73ms | 6.50ms | +0.23ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.94ms | 2.02ms | +0.92ms (+45.8%) | 🔴 |
| Worst Frame Build Time Millis | 29.80ms | 27.45ms | +2.35ms (+8.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.75 | 1.0 | +1 (+75.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.56ms | 6.32ms | +0.24ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.72ms | -0.00ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 1.90ms | 1.88ms | +0.03ms (+1.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.94ms | 3.84ms | +0.10ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.99ms | 2.89ms | +0.09ms (+3.3%) | 🟠 |
| Worst Frame Build Time Millis | 10.48ms | 10.37ms | +0.12ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.27ms | 4.23ms | +0.05ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 0.77ms | +0.02ms (+2.3%) | 🟠 |
| Worst Frame Build Time Millis | 3.92ms | 3.90ms | +0.02ms (+0.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.55ms | 4.55ms | +0.00ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.25 | +1 (+400.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.54ms | 0.46ms | +0.08ms (+16.9%) | 🔴 |
| Worst Frame Build Time Millis | 2.75ms | 2.30ms | +0.45ms (+19.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.76ms | 3.94ms | +0.82ms (+20.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.28ms | 2.06ms | +0.22ms (+10.8%) | 🔴 |
| Worst Frame Build Time Millis | 5.37ms | 5.35ms | +0.02ms (+0.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.50ms | 5.64ms | -0.13ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.45ms | 7.17ms | +0.28ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 24.79ms | 25.65ms | -0.86ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 6.75 | 6.25 | +0 (+8.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.18ms | 9.21ms | -0.02ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 17.00ms | 14.76ms | +2.25ms (+15.2%) | 🔴 |
| Worst Frame Build Time Millis | 58.03ms | 43.13ms | +14.90ms (+34.5%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.33ms | 8.67ms | +0.66ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.45ms | 1.35ms | +0.10ms (+7.5%) | 🟠 |
| Worst Frame Build Time Millis | 9.28ms | 8.25ms | +1.03ms (+12.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.51ms | 8.26ms | +0.25ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 8.0 | 3.5 | +4 (+128.6%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.97ms | 0.82ms | +0.15ms (+18.1%) | 🔴 |
| Worst Frame Build Time Millis | 7.74ms | 4.61ms | +3.13ms (+67.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.55ms | 6.12ms | +0.43ms (+6.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.87ms | 5.58ms | +0.29ms (+5.2%) | 🟠 |
| Worst Frame Build Time Millis | 23.45ms | 22.95ms | +0.50ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 4.5 | 3.75 | +1 (+20.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.63ms | 6.42ms | +0.21ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.0 | +0 (+3.6%) | 🟠 |
| Old Gen Gc Count | 6.0 | 4.5 | +2 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.61ms | 27.11ms | -1.51ms (-5.6%) | 🟢 |
| Worst Frame Build Time Millis | 46.12ms | 46.41ms | -0.29ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.86ms | 7.57ms | +0.29ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 10.0 | 7.5 | +2 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.16ms | 1.26ms | -0.10ms (-8.0%) | 🟢 |
| Worst Frame Build Time Millis | 15.73ms | 18.25ms | -2.52ms (-13.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.59ms | 6.92ms | -0.33ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.25 | 3.5 | -2 (-64.3%) | 🟢 |
| New Gen Gc Count | 7.0 | 6.5 | +0 (+7.7%) | 🟠 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.45ms | 1.44ms | +0.01ms (+0.6%) | 🟠 |
| Worst Frame Build Time Millis | 7.48ms | 7.93ms | -0.45ms (-5.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.75ms | 6.75ms | -0.01ms (-0.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.82ms | 8.52ms | +0.31ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 30.46ms | 29.53ms | +0.92ms (+3.1%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.85ms | 9.82ms | +0.03ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.30ms | +0.12ms (+8.9%) | 🟠 |
| Worst Frame Build Time Millis | 7.47ms | 5.68ms | +1.79ms (+31.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.98ms | 11.07ms | +0.91ms (+8.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 28.5 | 16.75 | +12 (+70.1%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.18ms | 1.25ms | -0.07ms (-5.7%) | 🟢 |
| Worst Frame Build Time Millis | 5.21ms | 5.72ms | -0.51ms (-9.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.77ms | 12.21ms | +0.56ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.75 | 3.25 | +2 (+46.2%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.92ms | 3.49ms | -0.57ms (-16.4%) | 🟢 |
| Worst Frame Build Time Millis | 4.30ms | 7.58ms | -3.28ms (-43.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.47ms | 10.20ms | -0.73ms (-7.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>
