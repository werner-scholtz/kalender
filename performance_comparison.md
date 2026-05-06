## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 25.9%
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 15.1%
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 50.7%
- 🔴 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 41.5%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 26.9%
- 🔴 **one_event_per_day-week-navigation**: Frame build time increased by 28.3%
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 36.4%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 16.1%
- 🔴 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 26.5%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 34.6%
- 🔴 **ten_events_per_day-week-navigation**: Frame build time increased by 30.1%
- 🔴 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 35.1%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 23.2%
- 🔴 **ten_events_per_day-schedule-navigation**: Frame build time increased by 30.4%
- 🔴 **one_event_per_day-schedule-navigation**: Frame build time increased by 22.4%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 25.9%
- 🔴 **one_event_per_day-month-navigation**: Frame build time increased by 32.4%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 35.7%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 55.3%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 13.4%

**Performance Improvements:**
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 16.2%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.64ms | 2.10ms | +0.54ms (+25.9%) | 🔴 |
| Worst Frame Build Time Millis | 6.39ms | 4.98ms | +1.41ms (+28.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.16ms | 3.28ms | +0.88ms (+26.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.75ms | 4.35ms | +1.41ms (+32.4%) | 🔴 |
| Worst Frame Build Time Millis | 19.71ms | 13.26ms | +6.45ms (+48.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.80ms | 4.54ms | +1.26ms (+27.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 0.69ms | +0.10ms (+15.1%) | 🔴 |
| Worst Frame Build Time Millis | 3.64ms | 4.06ms | -0.42ms (-10.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.30ms | 4.26ms | +1.04ms (+24.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.75 | 1.0 | +1 (+75.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.56ms | -0.09ms (-16.2%) | 🟢 |
| Worst Frame Build Time Millis | 1.84ms | 2.81ms | -0.97ms (-34.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.96ms | 4.70ms | +0.26ms (+5.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.53ms | 7.42ms | +4.10ms (+55.3%) | 🔴 |
| Worst Frame Build Time Millis | 31.57ms | 20.36ms | +11.20ms (+55.0%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.34ms | 4.00ms | +1.35ms (+33.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.80ms | 6.37ms | +1.43ms (+22.4%) | 🔴 |
| Worst Frame Build Time Millis | 14.38ms | 11.55ms | +2.83ms (+24.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.53ms | 5.01ms | +1.51ms (+30.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.44ms | 1.92ms | +0.52ms (+26.9%) | 🔴 |
| Worst Frame Build Time Millis | 30.50ms | 22.20ms | +8.30ms (+37.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.48ms | 4.88ms | +1.60ms (+32.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.93ms | 0.62ms | +0.31ms (+50.7%) | 🔴 |
| Worst Frame Build Time Millis | 2.50ms | 1.60ms | +0.90ms (+55.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.66ms | 3.22ms | +1.44ms (+44.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.19ms | 2.48ms | +0.70ms (+28.3%) | 🔴 |
| Worst Frame Build Time Millis | 11.06ms | 8.19ms | +2.87ms (+35.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.35ms | 3.39ms | +0.96ms (+28.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.67ms | +0.16ms (+23.2%) | 🔴 |
| Worst Frame Build Time Millis | 4.40ms | 2.57ms | +1.83ms (+71.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.57ms | 3.55ms | +1.02ms (+28.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.47ms | +0.01ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 2.12ms | 2.34ms | -0.22ms (-9.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.96ms | 3.95ms | +0.01ms (+0.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.38ms | 1.75ms | +0.63ms (+35.7%) | 🔴 |
| Worst Frame Build Time Millis | 4.85ms | 3.60ms | +1.26ms (+35.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.92ms | 4.49ms | +1.42ms (+31.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.46ms | 5.90ms | +1.56ms (+26.5%) | 🔴 |
| Worst Frame Build Time Millis | 23.76ms | 19.85ms | +3.91ms (+19.7%) | 🔴 |
| Missed Frame Build Budget Count | 6.75 | 2.75 | +4 (+145.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 11.47ms | 6.72ms | +4.75ms (+70.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |
| Old Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 16.03ms | 11.75ms | +4.28ms (+36.4%) | 🔴 |
| Worst Frame Build Time Millis | 51.40ms | 37.06ms | +14.33ms (+38.7%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.36ms | 6.72ms | +2.64ms (+39.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.62ms | 1.20ms | +0.42ms (+34.6%) | 🔴 |
| Worst Frame Build Time Millis | 8.79ms | 7.44ms | +1.35ms (+18.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.60ms | 5.73ms | +2.87ms (+50.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.5 | 0.0 | +6 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 6.0 | +2 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.87ms | 0.86ms | +0.01ms (+1.7%) | 🟠 |
| Worst Frame Build Time Millis | 3.97ms | 4.50ms | -0.54ms (-11.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.85ms | 5.05ms | +1.80ms (+35.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.24ms | 4.41ms | +1.83ms (+41.5%) | 🔴 |
| Worst Frame Build Time Millis | 33.71ms | 18.52ms | +15.18ms (+82.0%) | 🔴 |
| Missed Frame Build Budget Count | 4.75 | 1.75 | +3 (+171.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.59ms | 4.87ms | +1.72ms (+35.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 15.0 | 14.0 | +1 (+7.1%) | 🟠 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 26.79ms | 20.54ms | +6.25ms (+30.4%) | 🔴 |
| Worst Frame Build Time Millis | 49.84ms | 36.78ms | +13.06ms (+35.5%) | 🔴 |
| Missed Frame Build Budget Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.77ms | 5.31ms | +2.46ms (+46.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.0 | +0 (+3.6%) | 🟠 |
| Old Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.06ms | +0.14ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 21.33ms | 13.35ms | +7.98ms (+59.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.24ms | 5.00ms | +1.24ms (+24.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.25 | +1 (+400.0%) | 🔴 |
| New Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.57ms | 1.16ms | +0.41ms (+35.1%) | 🔴 |
| Worst Frame Build Time Millis | 9.96ms | 6.02ms | +3.95ms (+65.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.83ms | 4.61ms | +2.22ms (+48.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.58ms | 6.60ms | +1.99ms (+30.1%) | 🔴 |
| Worst Frame Build Time Millis | 30.02ms | 22.78ms | +7.23ms (+31.7%) | 🔴 |
| Missed Frame Build Budget Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.70ms | 7.14ms | +2.57ms (+36.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.20ms | +0.19ms (+16.1%) | 🔴 |
| Worst Frame Build Time Millis | 8.14ms | 7.78ms | +0.36ms (+4.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.02ms | 8.05ms | +2.97ms (+36.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 18.25 | 3.25 | +15 (+461.5%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.97ms | 0.98ms | -0.01ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 6.05ms | 5.48ms | +0.57ms (+10.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.10ms | 9.42ms | +1.69ms (+17.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 2.25 | +1 (+55.6%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.77ms | 2.99ms | +0.78ms (+25.9%) | 🔴 |
| Worst Frame Build Time Millis | 8.29ms | 6.14ms | +2.15ms (+35.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.32ms | 7.45ms | +2.87ms (+38.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>
