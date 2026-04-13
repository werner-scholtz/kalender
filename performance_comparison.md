## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 33.8%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 18.9%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 21.8%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 11.3%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 11.2%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 10.1%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 8.6%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 13.8%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 7.7%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 6.5%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 14.3%

**Performance Improvements:**
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 15.1%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.81ms | 2.47ms | +0.34ms (+13.8%) | 🔴 |
| Worst Frame Build Time Millis | 7.00ms | 5.95ms | +1.06ms (+17.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.06ms | 3.76ms | +0.30ms (+7.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.55ms | 4.99ms | +0.56ms (+11.3%) | 🔴 |
| Worst Frame Build Time Millis | 18.06ms | 15.14ms | +2.92ms (+19.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 0.25 | +1 (+400.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.60ms | 5.72ms | -0.12ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.69ms | +0.06ms (+8.6%) | 🟠 |
| Worst Frame Build Time Millis | 3.12ms | 2.69ms | +0.42ms (+15.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.00ms | 5.41ms | -0.41ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.45ms | 0.46ms | -0.01ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 1.98ms | 1.76ms | +0.22ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.58ms | 5.89ms | -1.31ms (-22.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.27ms | 9.33ms | +0.94ms (+10.1%) | 🔴 |
| Worst Frame Build Time Millis | 28.21ms | 25.98ms | +2.23ms (+8.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.04ms | 4.98ms | +0.05ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.58ms | 7.60ms | -0.03ms (-0.3%) | 🟡 |
| Worst Frame Build Time Millis | 14.67ms | 13.99ms | +0.68ms (+4.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.55ms | 6.56ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.22ms | 2.62ms | -0.39ms (-15.1%) | 🟢 |
| Worst Frame Build Time Millis | 25.53ms | 26.52ms | -0.98ms (-3.7%) | 🟡 |
| Missed Frame Build Budget Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.62ms | 6.26ms | +0.36ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.25 | +1 (+500.0%) | 🔴 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.71ms | +0.00ms (+0.3%) | 🟠 |
| Worst Frame Build Time Millis | 1.88ms | 1.86ms | +0.02ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.90ms | 4.03ms | -0.13ms (-3.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.86ms | 2.83ms | +0.03ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 9.71ms | 10.93ms | -1.23ms (-11.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.15ms | 4.13ms | +0.02ms (+0.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 1.5 | +2 (+100.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.74ms | 0.77ms | -0.03ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 3.15ms | 5.37ms | -2.21ms (-41.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.37ms | 4.88ms | -0.51ms (-10.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.51ms | +0.17ms (+33.8%) | 🔴 |
| Worst Frame Build Time Millis | 5.14ms | 3.09ms | +2.05ms (+66.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.65ms | 5.74ms | -1.09ms (-19.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.11ms | 2.08ms | +0.03ms (+1.6%) | 🟠 |
| Worst Frame Build Time Millis | 4.78ms | 4.76ms | +0.02ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.51ms | 5.52ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.30ms | 7.23ms | +0.07ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 27.51ms | 23.24ms | +4.28ms (+18.4%) | 🔴 |
| Missed Frame Build Budget Count | 6.75 | 6.25 | +0 (+8.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 8.99ms | 9.12ms | -0.13ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.77ms | 13.80ms | +1.97ms (+14.3%) | 🔴 |
| Worst Frame Build Time Millis | 51.29ms | 40.84ms | +10.44ms (+25.6%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.07ms | 9.14ms | -0.07ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.48ms | 1.43ms | +0.06ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 9.10ms | 8.65ms | +0.45ms (+5.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.66ms | 8.75ms | -0.09ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 3.75 | 4.75 | -1 (-21.1%) | 🟢 |
| New Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 0.73ms | +0.08ms (+11.2%) | 🔴 |
| Worst Frame Build Time Millis | 3.75ms | 3.90ms | -0.15ms (-3.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.05ms | 5.85ms | +0.20ms (+3.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.73ms | 5.52ms | +0.21ms (+3.8%) | 🟠 |
| Worst Frame Build Time Millis | 22.27ms | 22.40ms | -0.13ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 4.0 | 3.75 | +0 (+6.7%) | 🟠 |
| Average Frame Rasterizer Time Millis | 6.50ms | 6.49ms | +0.01ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.32ms | 23.49ms | +1.82ms (+7.7%) | 🟠 |
| Worst Frame Build Time Millis | 42.74ms | 43.37ms | -0.62ms (-1.4%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.31ms | 7.34ms | -0.03ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.18ms | 1.20ms | -0.02ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 22.59ms | 15.13ms | +7.46ms (+49.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.39ms | 6.82ms | -0.42ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 3.25 | -2 (-46.2%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.45ms | 1.37ms | +0.09ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 9.73ms | 6.85ms | +2.87ms (+41.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.08ms | 6.81ms | -0.72ms (-10.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.00ms | 7.88ms | +0.12ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 29.27ms | 31.23ms | -1.97ms (-6.3%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.45ms | 9.26ms | +0.19ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.30ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 5.22ms | 5.42ms | -0.20ms (-3.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.87ms | 11.44ms | -0.57ms (-5.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 19.25 | 23.0 | -4 (-16.3%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.13ms | 0.93ms | +0.20ms (+21.8%) | 🔴 |
| Worst Frame Build Time Millis | 5.64ms | 4.35ms | +1.29ms (+29.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.77ms | 13.07ms | -1.30ms (-9.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.75 | 6.0 | -3 (-54.2%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.98ms | 3.35ms | +0.63ms (+18.9%) | 🔴 |
| Worst Frame Build Time Millis | 7.11ms | 7.29ms | -0.18ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.42ms | 10.38ms | +0.04ms (+0.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
