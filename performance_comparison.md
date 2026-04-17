## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 31.5%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 18.0%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 13.4%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 9.4%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.1%

**Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 15.4%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.72ms | 2.68ms | +0.03ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 6.65ms | 6.62ms | +0.04ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.02ms | 4.12ms | -0.10ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.97ms | 5.04ms | -0.08ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 15.06ms | 17.44ms | -2.38ms (-13.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.01ms | 5.71ms | +0.30ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.70ms | +0.01ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 2.74ms | 2.94ms | -0.20ms (-6.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.02ms | 5.12ms | -0.10ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.50ms | -0.01ms (-2.7%) | 🟡 |
| Worst Frame Build Time Millis | 2.72ms | 2.44ms | +0.28ms (+11.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.84ms | 4.70ms | +0.14ms (+2.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.64ms | 9.02ms | +1.62ms (+18.0%) | 🔴 |
| Worst Frame Build Time Millis | 30.17ms | 25.06ms | +5.11ms (+20.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.02ms | 5.36ms | -0.34ms (-6.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.42ms | 7.49ms | -0.06ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 14.74ms | 14.71ms | +0.03ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.67ms | 6.69ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.39ms | 2.11ms | +0.28ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 31.97ms | 28.18ms | +3.79ms (+13.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.46ms | 6.36ms | +0.10ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.69ms | +0.03ms (+3.8%) | 🟠 |
| Worst Frame Build Time Millis | 1.91ms | 1.85ms | +0.05ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.77ms | 3.75ms | +0.02ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.92ms | 2.91ms | +0.01ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 10.24ms | 10.58ms | -0.34ms (-3.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.21ms | 4.21ms | +0.00ms (+0.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.73ms | -0.02ms (-2.3%) | 🟡 |
| Worst Frame Build Time Millis | 2.90ms | 3.86ms | -0.96ms (-24.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.58ms | 4.42ms | +0.16ms (+3.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.47ms | -0.00ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 2.14ms | 2.19ms | -0.05ms (-2.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.19ms | 4.59ms | -0.40ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.19ms | 2.12ms | +0.07ms (+3.3%) | 🟠 |
| Worst Frame Build Time Millis | 5.06ms | 4.64ms | +0.41ms (+8.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.66ms | 5.61ms | +0.05ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.07ms | 7.05ms | +0.02ms (+0.3%) | 🟠 |
| Worst Frame Build Time Millis | 23.33ms | 23.87ms | -0.54ms (-2.3%) | 🟡 |
| Missed Frame Build Budget Count | 6.0 | 5.75 | +0 (+4.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 8.98ms | 8.84ms | +0.14ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.89ms | 15.39ms | -0.49ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 50.20ms | 54.85ms | -4.65ms (-8.5%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.07ms | 9.04ms | +0.03ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.36ms | +0.01ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 8.39ms | 9.63ms | -1.23ms (-12.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.31ms | 8.27ms | +0.04ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 7.5 | 3.5 | +4 (+114.3%) | 🔴 |
| New Gen Gc Count | 6.5 | 6.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.90ms | 1.06ms | -0.16ms (-15.4%) | 🟢 |
| Worst Frame Build Time Millis | 5.31ms | 7.61ms | -2.29ms (-30.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.29ms | 6.06ms | +1.23ms (+20.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.5 | +1 (+150.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.0 | +2 (+150.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.55ms | 5.28ms | +0.27ms (+5.1%) | 🟠 |
| Worst Frame Build Time Millis | 22.28ms | 20.65ms | +1.64ms (+7.9%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.27ms | 6.34ms | -0.07ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.5 | -0 (-3.4%) | 🟡 |
| Old Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.59ms | 26.05ms | -2.46ms (-9.4%) | 🟢 |
| Worst Frame Build Time Millis | 44.94ms | 44.99ms | -0.05ms (-0.1%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.57ms | 7.84ms | -0.27ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 7.5 | +2 (+20.0%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.14ms | 1.20ms | -0.06ms (-5.1%) | 🟢 |
| Worst Frame Build Time Millis | 18.01ms | 22.50ms | -4.50ms (-20.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.20ms | 6.39ms | -0.19ms (-3.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.75 | +0 (+66.7%) | 🔴 |
| New Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.36ms | +0.04ms (+2.6%) | 🟠 |
| Worst Frame Build Time Millis | 7.06ms | 7.42ms | -0.35ms (-4.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.62ms | 6.73ms | -0.10ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.95ms | 7.98ms | -0.03ms (-0.4%) | 🟡 |
| Worst Frame Build Time Millis | 30.21ms | 28.84ms | +1.37ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.38ms | 9.47ms | -0.09ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.35ms | 1.37ms | -0.02ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 5.44ms | 7.84ms | -2.40ms (-30.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.31ms | 11.47ms | -0.16ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 19.0 | 20.0 | -1 (-5.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.09ms | 0.83ms | +0.26ms (+31.5%) | 🔴 |
| Worst Frame Build Time Millis | 5.34ms | 3.69ms | +1.65ms (+44.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 13.53ms | 10.86ms | +2.68ms (+24.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.75 | 3.25 | +2 (+46.2%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.28ms | 3.00ms | +0.28ms (+9.4%) | 🟠 |
| Worst Frame Build Time Millis | 6.41ms | 5.90ms | +0.50ms (+8.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.36ms | 9.19ms | +1.16ms (+12.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>
