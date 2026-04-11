## Summary

**Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 48.2%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 87.3%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 17.3%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 27.6%

**Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 10.1%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 10.9%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 5.8%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 9.5%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.5%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 10.2%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 8.7%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 8.4%

**Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 30.5%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 22.6%

**Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.82ms | 2.88ms | -0.06ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 6.87ms | 7.10ms | -0.23ms (-3.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.74ms | 4.78ms | -0.04ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.60ms | 5.74ms | -0.14ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 17.69ms | 18.98ms | -1.29ms (-6.8%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.33ms | 5.61ms | +0.72ms (+12.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 0.72ms | +0.07ms (+9.5%) | 🟠 |
| Worst Frame Build Time Millis | 4.54ms | 2.99ms | +1.54ms (+51.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.59ms | 5.10ms | +1.49ms (+29.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.25 | 1.25 | +2 (+160.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.92ms | 0.49ms | +0.43ms (+87.3%) | 🔴 |
| Worst Frame Build Time Millis | 3.45ms | 2.44ms | +1.01ms (+41.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.90ms | 4.86ms | +2.04ms (+41.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.85ms | 14.01ms | -3.16ms (-22.6%) | 🟢 |
| Worst Frame Build Time Millis | 30.22ms | 40.03ms | -9.80ms (-24.5%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.20ms | 5.81ms | +0.38ms (+6.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.18ms | 7.38ms | +0.81ms (+10.9%) | 🔴 |
| Worst Frame Build Time Millis | 14.67ms | 13.95ms | +0.72ms (+5.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.84ms | 6.47ms | +0.37ms (+5.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.08ms | 2.08ms | +1.00ms (+48.2%) | 🔴 |
| Worst Frame Build Time Millis | 26.55ms | 24.30ms | +2.26ms (+9.3%) | 🟠 |
| Missed Frame Build Budget Count | 2.25 | 1.5 | +1 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.17ms | 6.86ms | +0.32ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 2.5 | -2 (-60.0%) | 🟢 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.71ms | +0.00ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 1.86ms | 1.88ms | -0.03ms (-1.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.86ms | 4.17ms | -0.30ms (-7.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.95ms | 2.82ms | +0.12ms (+4.4%) | 🟠 |
| Worst Frame Build Time Millis | 10.09ms | 9.47ms | +0.61ms (+6.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.33ms | 5.00ms | -0.66ms (-13.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.75ms | +0.08ms (+10.2%) | 🔴 |
| Worst Frame Build Time Millis | 3.81ms | 3.81ms | -0.00ms (-0.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.72ms | 4.33ms | +0.38ms (+8.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.54ms | -0.04ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 2.19ms | 3.42ms | -1.23ms (-35.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.06ms | 4.34ms | -0.28ms (-6.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.45ms | 2.09ms | +0.36ms (+17.3%) | 🔴 |
| Worst Frame Build Time Millis | 5.61ms | 4.30ms | +1.31ms (+30.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.57ms | 5.53ms | +0.04ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.43ms | 7.18ms | +0.25ms (+3.5%) | 🟠 |
| Worst Frame Build Time Millis | 24.90ms | 26.63ms | -1.73ms (-6.5%) | 🟢 |
| Missed Frame Build Budget Count | 6.75 | 6.5 | +0 (+3.8%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.34ms | 9.09ms | +0.25ms (+2.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.5 | 10.0 | -2 (-15.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 16.20ms | 14.94ms | +1.26ms (+8.4%) | 🟠 |
| Worst Frame Build Time Millis | 59.76ms | 45.82ms | +13.94ms (+30.4%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.42ms | 9.58ms | -0.16ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.51ms | 1.56ms | -0.05ms (-3.1%) | 🟡 |
| Worst Frame Build Time Millis | 11.74ms | 10.44ms | +1.30ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.85ms | 9.04ms | -0.19ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 9.25 | 7.25 | +2 (+27.6%) | 🔴 |
| New Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 1.17ms | -0.36ms (-30.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.92ms | 5.11ms | -1.19ms (-23.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.85ms | 8.24ms | -2.38ms (-28.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.75 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.17ms | 5.85ms | +0.32ms (+5.5%) | 🟠 |
| Worst Frame Build Time Millis | 28.11ms | 28.52ms | -0.42ms (-1.5%) | 🟡 |
| Missed Frame Build Budget Count | 4.0 | 4.25 | -0 (-5.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.27ms | 6.86ms | +0.41ms (+6.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.5 | -0 (-3.4%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.68ms | 26.51ms | -0.82ms (-3.1%) | 🟡 |
| Worst Frame Build Time Millis | 52.15ms | 43.75ms | +8.40ms (+19.2%) | 🔴 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.60ms | 7.52ms | +0.08ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.5 | 7.5 | +1 (+13.3%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.13ms | 1.17ms | -0.04ms (-3.3%) | 🟡 |
| Worst Frame Build Time Millis | 13.95ms | 15.03ms | -1.08ms (-7.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.84ms | 6.86ms | -0.03ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.5 | 3.25 | -2 (-53.8%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.47ms | 1.40ms | +0.07ms (+4.9%) | 🟠 |
| Worst Frame Build Time Millis | 8.80ms | 7.37ms | +1.44ms (+19.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.18ms | 6.06ms | +1.12ms (+18.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.58ms | 7.90ms | +0.68ms (+8.7%) | 🟠 |
| Worst Frame Build Time Millis | 30.11ms | 28.39ms | +1.71ms (+6.0%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.92ms | 9.67ms | +0.25ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.29ms | +0.13ms (+10.1%) | 🔴 |
| Worst Frame Build Time Millis | 6.90ms | 5.98ms | +0.92ms (+15.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.95ms | 11.06ms | +0.89ms (+8.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 28.0 | 19.75 | +8 (+41.8%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.15ms | 1.09ms | +0.06ms (+5.8%) | 🟠 |
| Worst Frame Build Time Millis | 4.29ms | 4.41ms | -0.13ms (-2.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 13.63ms | 13.88ms | -0.24ms (-1.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 5.25 | 6.5 | -1 (-19.2%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.33ms | 3.39ms | +0.94ms (+27.6%) | 🔴 |
| Worst Frame Build Time Millis | 10.94ms | 7.15ms | +3.79ms (+53.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.87ms | 10.50ms | +0.37ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

</details>
