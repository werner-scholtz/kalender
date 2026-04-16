## Summary

**Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 18.2%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 18.0%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 54.4%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 19.8%

**Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 14.5%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.3%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 5.3%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 8.1%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 6.4%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 6.8%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 11.4%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 8.2%

**Performance Improvements:**
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 10.2%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 25.6%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 10.6%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.89ms | 2.81ms | +0.08ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 6.88ms | 7.00ms | -0.13ms (-1.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.49ms | 4.06ms | +0.42ms (+10.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.67ms | 5.55ms | +0.11ms (+2.0%) | 🟠 |
| Worst Frame Build Time Millis | 18.23ms | 18.06ms | +0.17ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.81ms | 5.60ms | +0.21ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.85ms | 0.75ms | +0.11ms (+14.5%) | 🔴 |
| Worst Frame Build Time Millis | 5.25ms | 3.12ms | +2.13ms (+68.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.40ms | 5.00ms | +0.40ms (+8.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 3.0 | +2 (+50.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.45ms | +0.25ms (+54.4%) | 🔴 |
| Worst Frame Build Time Millis | 3.31ms | 1.98ms | +1.33ms (+67.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.59ms | 4.58ms | +1.00ms (+21.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.12ms | 10.27ms | +1.85ms (+18.0%) | 🔴 |
| Worst Frame Build Time Millis | 34.39ms | 28.21ms | +6.18ms (+21.9%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.81ms | 5.04ms | +0.77ms (+15.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.10ms | 7.58ms | +0.52ms (+6.8%) | 🟠 |
| Worst Frame Build Time Millis | 14.54ms | 14.67ms | -0.13ms (-0.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.78ms | 6.55ms | +0.23ms (+3.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.09ms | 2.22ms | -0.13ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 23.37ms | 25.53ms | -2.17ms (-8.5%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.32ms | 6.62ms | -0.31ms (-4.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.5 | -1 (-83.3%) | 🟢 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.71ms | -0.03ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 1.74ms | 1.88ms | -0.14ms (-7.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.83ms | 3.90ms | -0.06ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.98ms | 2.86ms | +0.12ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 10.14ms | 9.71ms | +0.44ms (+4.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.21ms | 4.15ms | +0.06ms (+1.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.78ms | 0.74ms | +0.04ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 3.08ms | 3.15ms | -0.07ms (-2.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.44ms | 4.37ms | +0.07ms (+1.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.68ms | -0.18ms (-25.6%) | 🟢 |
| Worst Frame Build Time Millis | 2.26ms | 5.14ms | -2.89ms (-56.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.12ms | 4.65ms | -0.53ms (-11.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.29ms | 2.11ms | +0.17ms (+8.2%) | 🟠 |
| Worst Frame Build Time Millis | 5.24ms | 4.78ms | +0.47ms (+9.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.65ms | 5.51ms | +0.13ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.53ms | 7.30ms | +0.23ms (+3.2%) | 🟠 |
| Worst Frame Build Time Millis | 27.75ms | 27.51ms | +0.24ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 6.75 | 6.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.48ms | 8.99ms | +0.49ms (+5.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.81ms | 15.77ms | -0.96ms (-6.1%) | 🟢 |
| Worst Frame Build Time Millis | 45.22ms | 51.29ms | -6.07ms (-11.8%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.99ms | 9.07ms | -0.09ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.65ms | 1.48ms | +0.17ms (+11.4%) | 🔴 |
| Worst Frame Build Time Millis | 9.54ms | 9.10ms | +0.43ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.08ms | 8.66ms | +0.42ms (+4.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 8.75 | 3.75 | +5 (+133.3%) | 🔴 |
| New Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.96ms | 0.81ms | +0.15ms (+18.2%) | 🔴 |
| Worst Frame Build Time Millis | 4.43ms | 3.75ms | +0.68ms (+18.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.59ms | 6.05ms | +0.55ms (+9.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.75 | +0 (+33.3%) | 🔴 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.04ms | 5.73ms | +0.30ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 23.96ms | 22.27ms | +1.70ms (+7.6%) | 🟠 |
| Missed Frame Build Budget Count | 4.75 | 4.0 | +1 (+18.8%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.91ms | 6.50ms | +0.42ms (+6.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.5 | 14.0 | +0 (+3.6%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.73ms | 25.32ms | -2.59ms (-10.2%) | 🟢 |
| Worst Frame Build Time Millis | 44.74ms | 42.74ms | +2.00ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.90ms | 7.31ms | +0.59ms (+8.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.5 | 8.0 | +2 (+18.8%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.41ms | 1.18ms | +0.23ms (+19.8%) | 🔴 |
| Worst Frame Build Time Millis | 20.80ms | 22.59ms | -1.79ms (-7.9%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.51ms | 6.39ms | +1.11ms (+17.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.25 | 1.75 | +2 (+142.9%) | 🔴 |
| New Gen Gc Count | 7.5 | 6.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 5.0 | 2.5 | +2 (+100.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.43ms | 1.45ms | -0.02ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 7.48ms | 9.73ms | -2.25ms (-23.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.82ms | 6.08ms | +0.73ms (+12.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.65ms | 8.00ms | +0.65ms (+8.1%) | 🟠 |
| Worst Frame Build Time Millis | 30.07ms | 29.27ms | +0.80ms (+2.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 10.09ms | 9.45ms | +0.64ms (+6.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.39ms | 1.31ms | +0.08ms (+6.4%) | 🟠 |
| Worst Frame Build Time Millis | 5.46ms | 5.22ms | +0.24ms (+4.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.65ms | 10.87ms | -0.22ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 16.0 | 19.25 | -3 (-16.9%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.01ms | 1.13ms | -0.12ms (-10.6%) | 🟢 |
| Worst Frame Build Time Millis | 4.01ms | 5.64ms | -1.63ms (-28.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.88ms | 11.77ms | -0.89ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 2.75 | -1 (-36.4%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.85ms | 3.98ms | -0.13ms (-3.4%) | 🟡 |
| Worst Frame Build Time Millis | 8.73ms | 7.11ms | +1.62ms (+22.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.68ms | 10.42ms | +1.26ms (+12.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.0 | 0.25 | +2 (+700.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>
