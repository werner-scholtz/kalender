## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 16.7%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 22.3%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 16.0%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 6.3%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 5.2%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.0%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 6.9%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 11.8%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 10.4%

**Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 38.5%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 30.3%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 12.1%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.11ms | 2.79ms | +0.33ms (+11.8%) | 🔴 |
| Worst Frame Build Time Millis | 7.85ms | 6.88ms | +0.97ms (+14.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.74ms | 3.94ms | +0.80ms (+20.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.13ms | 4.83ms | +0.31ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 16.33ms | 15.98ms | +0.35ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.55ms | 5.70ms | -0.15ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.71ms | -0.00ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 2.88ms | 3.10ms | -0.22ms (-7.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.32ms | 4.97ms | +0.34ms (+6.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.25 | 0.75 | +2 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.80ms | -0.24ms (-30.3%) | 🟢 |
| Worst Frame Build Time Millis | 1.91ms | 3.40ms | -1.49ms (-43.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.88ms | 5.66ms | -0.78ms (-13.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.62ms | 10.88ms | +1.74ms (+16.0%) | 🔴 |
| Worst Frame Build Time Millis | 35.82ms | 30.73ms | +5.09ms (+16.6%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.98ms | 5.13ms | -0.15ms (-3.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.66ms | 7.28ms | +0.38ms (+5.2%) | 🟠 |
| Worst Frame Build Time Millis | 17.21ms | 14.97ms | +2.24ms (+15.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.58ms | 6.53ms | +0.05ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.26ms | 2.04ms | +0.21ms (+10.4%) | 🔴 |
| Worst Frame Build Time Millis | 27.93ms | 27.00ms | +0.93ms (+3.4%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 1.25 | +0 (+20.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.68ms | 6.39ms | +0.29ms (+4.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 1.25 | +0 (+20.0%) | 🔴 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.64ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 1.69ms | 1.70ms | -0.01ms (-0.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.21ms | 3.59ms | +0.62ms (+17.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.78ms | 2.69ms | +0.09ms (+3.5%) | 🟠 |
| Worst Frame Build Time Millis | 9.49ms | 9.13ms | +0.36ms (+3.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.96ms | 4.75ms | +0.21ms (+4.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.71ms | +0.01ms (+1.7%) | 🟠 |
| Worst Frame Build Time Millis | 2.61ms | 3.64ms | -1.03ms (-28.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.18ms | 4.24ms | +0.95ms (+22.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.53ms | +0.09ms (+16.7%) | 🔴 |
| Worst Frame Build Time Millis | 2.21ms | 1.96ms | +0.25ms (+12.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.56ms | 3.76ms | +0.80ms (+21.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.37ms | 1.94ms | +0.43ms (+22.3%) | 🔴 |
| Worst Frame Build Time Millis | 5.73ms | 3.67ms | +2.06ms (+56.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.46ms | 5.06ms | +0.40ms (+7.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.36ms | 6.60ms | -0.24ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 22.35ms | 24.24ms | -1.89ms (-7.8%) | 🟢 |
| Missed Frame Build Budget Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 8.78ms | 8.92ms | -0.14ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.58ms | 13.25ms | +0.34ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 40.78ms | 40.07ms | +0.72ms (+1.8%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.48ms | 9.57ms | -0.09ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.41ms | 1.48ms | -0.07ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 7.59ms | 10.05ms | -2.46ms (-24.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.42ms | 8.70ms | -0.28ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.75 | 2.5 | -1 (-30.0%) | 🟢 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.17ms | 1.91ms | -0.73ms (-38.5%) | 🟢 |
| Worst Frame Build Time Millis | 7.15ms | 7.18ms | -0.03ms (-0.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.38ms | 7.94ms | -1.56ms (-19.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 3.5 | -4 (-100.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.60ms | 5.34ms | +0.27ms (+5.0%) | 🟠 |
| Worst Frame Build Time Millis | 26.27ms | 25.95ms | +0.32ms (+1.2%) | 🟠 |
| Missed Frame Build Budget Count | 3.75 | 2.5 | +1 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.68ms | 6.62ms | +0.06ms (+0.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 15.0 | -1 (-6.7%) | 🟢 |
| Old Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.15ms | 22.94ms | +0.21ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 44.55ms | 44.81ms | -0.26ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.62ms | 7.62ms | -0.00ms (-0.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 1.26ms | -0.15ms (-12.1%) | 🟢 |
| Worst Frame Build Time Millis | 13.35ms | 18.77ms | -5.41ms (-28.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.81ms | 6.04ms | +0.77ms (+12.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.75 | 0.5 | +3 (+650.0%) | 🔴 |
| New Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Old Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.18ms | 1.17ms | +0.01ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 6.15ms | 6.02ms | +0.13ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.07ms | 5.88ms | +0.19ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.54ms | 7.64ms | -0.11ms (-1.4%) | 🟡 |
| Worst Frame Build Time Millis | 27.49ms | 27.05ms | +0.43ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 2.75 | +0 (+9.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.39ms | 9.39ms | +0.00ms (+0.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.33ms | -0.02ms (-1.7%) | 🟡 |
| Worst Frame Build Time Millis | 4.81ms | 5.47ms | -0.67ms (-12.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.10ms | 11.24ms | +0.86ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 24.75 | 14.5 | +10 (+70.7%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.33ms | +0.07ms (+5.0%) | 🟠 |
| Worst Frame Build Time Millis | 4.40ms | 7.12ms | -2.71ms (-38.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.36ms | 12.50ms | +1.86ms (+14.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 3.75 | +1 (+20.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.41ms | 3.19ms | +0.22ms (+6.9%) | 🟠 |
| Worst Frame Build Time Millis | 6.68ms | 6.19ms | +0.49ms (+7.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.51ms | 10.68ms | -0.17ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

</details>
