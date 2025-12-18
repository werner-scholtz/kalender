## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-schedule-navigation**: Frame build time increased by 25.9%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 24.7%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 28.5%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 19.4%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 24.8%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 25.9%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 29.2%
- 🔴 **one_event_per_day-week-navigation**: Frame build time increased by 16.6%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 21.6%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 24.6%
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 26.0%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 8.8%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 12.1%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 11.9%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 7.7%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 11.2%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 14.4%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 8.3%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 6.2%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 10.5%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 5.9%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 8.4%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 13.4%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.21ms | 2.86ms | +0.35ms (+12.1%) | 🔴 |
| Worst Frame Build Time Millis | 7.48ms | 7.02ms | +0.46ms (+6.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.50ms | 3.68ms | +0.82ms (+22.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.61ms | 5.28ms | +0.33ms (+6.2%) | 🟠 |
| Worst Frame Build Time Millis | 19.99ms | 19.92ms | +0.07ms (+0.3%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.53ms | 5.05ms | +0.49ms (+9.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.90ms | 0.72ms | +0.19ms (+26.0%) | 🔴 |
| Worst Frame Build Time Millis | 5.66ms | 5.72ms | -0.06ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.13ms | 5.84ms | +0.29ms (+5.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.25 | 0.75 | +4 (+466.7%) | 🔴 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.66ms | 0.55ms | +0.11ms (+19.4%) | 🔴 |
| Worst Frame Build Time Millis | 2.88ms | 3.25ms | -0.36ms (-11.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.83ms | 5.95ms | +1.88ms (+31.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.29ms | 9.50ms | +0.80ms (+8.4%) | 🟠 |
| Worst Frame Build Time Millis | 29.30ms | 27.08ms | +2.21ms (+8.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.71ms | 3.91ms | +0.81ms (+20.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.30ms | 6.70ms | +0.59ms (+8.8%) | 🟠 |
| Worst Frame Build Time Millis | 14.46ms | 13.98ms | +0.48ms (+3.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.60ms | 5.31ms | +0.28ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.25 | 6.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.75ms | 2.13ms | +0.62ms (+29.2%) | 🔴 |
| Worst Frame Build Time Millis | 30.34ms | 28.19ms | +2.15ms (+7.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 8.95ms | 6.84ms | +2.11ms (+30.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 12.25 | 3.5 | +9 (+250.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.87ms | 0.76ms | +0.11ms (+14.4%) | 🔴 |
| Worst Frame Build Time Millis | 2.28ms | 1.99ms | +0.29ms (+14.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 16.54ms | 14.48ms | +2.06ms (+14.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.39ms | 2.91ms | +0.48ms (+16.6%) | 🔴 |
| Worst Frame Build Time Millis | 13.53ms | 9.59ms | +3.94ms (+41.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.52ms | 3.94ms | +0.58ms (+14.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 3.0 | -2 (-83.3%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.83ms | 0.69ms | +0.15ms (+21.6%) | 🔴 |
| Worst Frame Build Time Millis | 5.22ms | 3.55ms | +1.67ms (+47.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.28ms | 5.57ms | +0.71ms (+12.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.25 | 2.25 | +4 (+177.8%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.59ms | +0.15ms (+24.8%) | 🔴 |
| Worst Frame Build Time Millis | 4.21ms | 2.85ms | +1.37ms (+47.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.01ms | 4.07ms | +0.94ms (+23.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.13ms | 1.88ms | +0.25ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 4.50ms | 5.39ms | -0.90ms (-16.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.22ms | 5.79ms | +0.43ms (+7.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.30ms | 8.36ms | +0.93ms (+11.2%) | 🔴 |
| Worst Frame Build Time Millis | 36.68ms | 36.01ms | +0.67ms (+1.8%) | 🟠 |
| Missed Frame Build Budget Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.84ms | 6.90ms | +0.93ms (+13.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 13.5 | 12.0 | +2 (+12.5%) | 🔴 |
| Old Gen Gc Count | 9.0 | 7.5 | +2 (+20.0%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 16.44ms | 15.18ms | +1.26ms (+8.3%) | 🟠 |
| Worst Frame Build Time Millis | 49.68ms | 48.20ms | +1.48ms (+3.1%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.72ms | 6.96ms | +0.77ms (+11.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.99ms | 1.55ms | +0.44ms (+28.5%) | 🔴 |
| Worst Frame Build Time Millis | 14.69ms | 12.93ms | +1.76ms (+13.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.84ms | 10.42ms | -0.58ms (-5.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 13.25 | 2.5 | +11 (+430.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.42ms | -0.12ms (-8.1%) | 🟢 |
| Worst Frame Build Time Millis | 8.62ms | 8.81ms | -0.18ms (-2.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.44ms | 12.68ms | -4.24ms (-33.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 6.0 | -4 (-75.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.62ms | 6.15ms | +0.47ms (+7.7%) | 🟠 |
| Worst Frame Build Time Millis | 36.77ms | 39.01ms | -2.24ms (-5.7%) | 🟢 |
| Missed Frame Build Budget Count | 5.75 | 2.5 | +3 (+130.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.67ms | 5.31ms | +0.36ms (+6.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 20.0 | -1 (-5.0%) | 🟢 |
| Old Gen Gc Count | 6.5 | 9.5 | -3 (-31.6%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 27.25ms | 21.65ms | +5.60ms (+25.9%) | 🔴 |
| Worst Frame Build Time Millis | 52.06ms | 44.59ms | +7.47ms (+16.8%) | 🔴 |
| Missed Frame Build Budget Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.60ms | 5.45ms | +1.15ms (+21.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.5 | -0 (-2.7%) | 🟡 |
| Old Gen Gc Count | 9.0 | 10.5 | -2 (-14.3%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.04ms | +0.26ms (+24.7%) | 🔴 |
| Worst Frame Build Time Millis | 20.00ms | 20.60ms | -0.60ms (-2.9%) | 🟡 |
| Missed Frame Build Budget Count | 2.25 | 1.25 | +1 (+80.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.07ms | 8.20ms | +0.87ms (+10.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 15.0 | 7.5 | +8 (+100.0%) | 🔴 |
| New Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.65ms | 1.47ms | +0.17ms (+11.9%) | 🔴 |
| Worst Frame Build Time Millis | 8.42ms | 7.18ms | +1.24ms (+17.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.51ms | 5.68ms | +0.83ms (+14.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.02ms | 8.51ms | +0.51ms (+5.9%) | 🟠 |
| Worst Frame Build Time Millis | 37.39ms | 35.86ms | +1.53ms (+4.3%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.28ms | 7.67ms | +0.60ms (+7.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.63ms | 1.31ms | +0.32ms (+24.6%) | 🔴 |
| Worst Frame Build Time Millis | 12.47ms | 10.11ms | +2.35ms (+23.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.32ms | 12.03ms | -0.71ms (-5.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 20.75 | 16.0 | +5 (+29.7%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 0.99ms | +0.26ms (+25.9%) | 🔴 |
| Worst Frame Build Time Millis | 5.33ms | 4.02ms | +1.31ms (+32.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.75ms | 10.46ms | -1.71ms (-16.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.95ms | 1.77ms | +0.19ms (+10.5%) | 🔴 |
| Worst Frame Build Time Millis | 3.31ms | 5.16ms | -1.84ms (-35.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.27ms | 9.08ms | +0.20ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

