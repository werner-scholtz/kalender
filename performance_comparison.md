## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 23.8%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 17.0%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 19.8%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 6.7%
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 7.1%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 6.3%

**Performance Improvements:**
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 11.9%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 18.1%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 16.1%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.47ms | 2.80ms | -0.33ms (-11.9%) | 🟢 |
| Worst Frame Build Time Millis | 5.87ms | 6.93ms | -1.06ms (-15.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.60ms | 4.25ms | +0.35ms (+8.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.21ms | 5.06ms | +0.15ms (+2.9%) | 🟠 |
| Worst Frame Build Time Millis | 15.94ms | 16.52ms | -0.58ms (-3.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.66ms | 5.67ms | -0.00ms (-0.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.70ms | +0.01ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 2.72ms | 2.67ms | +0.05ms (+1.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.84ms | 4.98ms | -0.14ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.68ms | -0.12ms (-18.1%) | 🟢 |
| Worst Frame Build Time Millis | 1.99ms | 2.56ms | -0.57ms (-22.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.19ms | 6.17ms | -1.98ms (-32.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.76ms | 9.53ms | +0.24ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 27.51ms | 26.84ms | +0.67ms (+2.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.71ms | 4.66ms | +0.05ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.70ms | 7.64ms | +0.06ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 17.05ms | 15.74ms | +1.31ms (+8.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.58ms | 6.63ms | -0.05ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.52ms | 2.10ms | +0.42ms (+19.8%) | 🔴 |
| Worst Frame Build Time Millis | 30.47ms | 24.98ms | +5.48ms (+22.0%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 1.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.04ms | 6.40ms | +0.64ms (+10.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 2.0 | -1 (-37.5%) | 🟢 |
| New Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |
| Old Gen Gc Count | 4.5 | 3.5 | +1 (+28.6%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.65ms | 0.66ms | -0.01ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 1.69ms | 1.74ms | -0.05ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.75ms | 3.63ms | +0.12ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.97ms | 2.77ms | +0.20ms (+7.1%) | 🟠 |
| Worst Frame Build Time Millis | 11.80ms | 9.23ms | +2.57ms (+27.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.26ms | 4.10ms | +0.15ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.73ms | +0.03ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 3.70ms | 4.29ms | -0.60ms (-14.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.59ms | 4.33ms | +0.26ms (+6.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.75 | +0 (+66.7%) | 🔴 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.61ms | +0.01ms (+2.1%) | 🟠 |
| Worst Frame Build Time Millis | 2.69ms | 2.44ms | +0.25ms (+10.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.13ms | 4.22ms | -0.09ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.08ms | 2.23ms | -0.16ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 4.43ms | 5.18ms | -0.75ms (-14.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.63ms | 5.59ms | +0.04ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.13ms | 6.70ms | +0.42ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 24.89ms | 25.29ms | -0.39ms (-1.6%) | 🟡 |
| Missed Frame Build Budget Count | 6.25 | 4.5 | +2 (+38.9%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.35ms | 9.13ms | +0.22ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.28ms | 14.04ms | +0.24ms (+1.7%) | 🟠 |
| Worst Frame Build Time Millis | 40.48ms | 41.28ms | -0.80ms (-1.9%) | 🟡 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.97ms | 9.44ms | -0.47ms (-5.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.53ms | 1.31ms | +0.22ms (+17.0%) | 🔴 |
| Worst Frame Build Time Millis | 8.48ms | 8.25ms | +0.23ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.09ms | 7.99ms | +1.11ms (+13.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.0 | 5.75 | -1 (-13.0%) | 🟢 |
| New Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.17ms | 1.40ms | -0.23ms (-16.1%) | 🟢 |
| Worst Frame Build Time Millis | 5.79ms | 8.39ms | -2.59ms (-30.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.25ms | 6.74ms | -0.49ms (-7.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.83ms | 5.57ms | +0.26ms (+4.7%) | 🟠 |
| Worst Frame Build Time Millis | 26.44ms | 25.57ms | +0.87ms (+3.4%) | 🟠 |
| Missed Frame Build Budget Count | 4.25 | 3.5 | +1 (+21.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.69ms | 6.56ms | +0.13ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.53ms | 22.65ms | +0.88ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 44.15ms | 44.12ms | +0.04ms (+0.1%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.69ms | 7.28ms | +0.41ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.5 | 8.0 | +2 (+18.8%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.04ms | 0.97ms | +0.06ms (+6.7%) | 🟠 |
| Worst Frame Build Time Millis | 13.44ms | 12.83ms | +0.61ms (+4.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.84ms | 6.18ms | +0.67ms (+10.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.75 | 1.5 | +1 (+83.3%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.26ms | 1.21ms | +0.05ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 6.69ms | 6.38ms | +0.31ms (+4.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.66ms | 6.62ms | +0.03ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.00ms | 7.70ms | +0.30ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 29.69ms | 29.00ms | +0.69ms (+2.4%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.60ms | 9.26ms | +0.34ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.29ms | +0.05ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 6.20ms | 5.56ms | +0.64ms (+11.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.33ms | 10.59ms | +0.73ms (+6.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 21.75 | 15.5 | +6 (+40.3%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.62ms | 1.30ms | +0.31ms (+23.8%) | 🔴 |
| Worst Frame Build Time Millis | 6.62ms | 4.89ms | +1.72ms (+35.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 13.94ms | 12.99ms | +0.95ms (+7.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 5.25 | 4.5 | +1 (+16.7%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.73ms | 3.56ms | +0.17ms (+4.7%) | 🟠 |
| Worst Frame Build Time Millis | 7.27ms | 7.85ms | -0.59ms (-7.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.48ms | 10.45ms | +0.03ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
