## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 16.0%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 15.2%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 19.6%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 23.6%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 5.8%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 9.8%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 5.3%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 9.2%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 9.5%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 8.4%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 7.4%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 7.3%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 9.0%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 7.9%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 7.9%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 11.5%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 14.8%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.05ms | 4.08ms | -0.03ms (-0.7%) | 🟡 |
| Worst Frame Build Time Millis | 7.96ms | 8.03ms | -0.08ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.50ms | 2.42ms | +0.09ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.03ms | 4.64ms | +0.39ms (+8.4%) | 🟠 |
| Worst Frame Build Time Millis | 20.80ms | 18.06ms | +2.74ms (+15.2%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.01ms | 3.82ms | +0.20ms (+5.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.60ms | +0.10ms (+16.0%) | 🔴 |
| Worst Frame Build Time Millis | 3.69ms | 4.01ms | -0.32ms (-8.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.76ms | 3.05ms | -0.29ms (-9.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.25 | -1 (-80.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.51ms | +0.04ms (+7.9%) | 🟠 |
| Worst Frame Build Time Millis | 3.43ms | 3.18ms | +0.25ms (+7.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.08ms | 3.86ms | -0.78ms (-20.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.36ms | 8.55ms | +0.81ms (+9.5%) | 🟠 |
| Worst Frame Build Time Millis | 26.64ms | 24.47ms | +2.17ms (+8.9%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.65ms | 2.64ms | +0.00ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.09ms | 6.49ms | +0.60ms (+9.2%) | 🟠 |
| Worst Frame Build Time Millis | 17.38ms | 14.02ms | +3.36ms (+24.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.40ms | 3.23ms | +0.17ms (+5.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.99ms | 1.97ms | +0.02ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 26.48ms | 28.63ms | -2.15ms (-7.5%) | 🟢 |
| Missed Frame Build Budget Count | 1.75 | 1.25 | +0 (+40.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 2.93ms | 4.48ms | -1.55ms (-34.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 5.0 | -5 (-100.0%) | 🟢 |
| New Gen Gc Count | 9.5 | 8.5 | +1 (+11.8%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.16ms | +0.07ms (+5.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.32ms | 2.18ms | +0.13ms (+6.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.36ms | 2.19ms | +0.17ms (+7.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.00ms | 2.96ms | +0.04ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 9.75ms | 10.30ms | -0.55ms (-5.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.60ms | 3.47ms | +0.13ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.66ms | 0.61ms | +0.05ms (+7.9%) | 🟠 |
| Worst Frame Build Time Millis | 3.33ms | 3.24ms | +0.09ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.29ms | 3.89ms | -0.59ms (-15.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 3.25 | -2 (-61.5%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.59ms | +0.06ms (+9.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.31ms | 2.34ms | -0.03ms (-1.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.17ms | 2.40ms | +0.77ms (+32.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.00ms | 1.96ms | +0.04ms (+2.3%) | 🟠 |
| Worst Frame Build Time Millis | 5.74ms | 4.46ms | +1.27ms (+28.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.03ms | 5.43ms | -1.41ms (-25.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.80ms | 9.68ms | +0.12ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 28.00ms | 27.72ms | +0.28ms (+1.0%) | 🟠 |
| Missed Frame Build Budget Count | 7.5 | 7.25 | +0 (+3.4%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.22ms | 4.97ms | +0.25ms (+5.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.84ms | 10.73ms | +0.11ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 40.58ms | 38.96ms | +1.63ms (+4.2%) | 🟠 |
| Missed Frame Build Budget Count | 2.75 | 2.5 | +0 (+10.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.01ms | 5.11ms | -0.11ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.27ms | +0.19ms (+14.8%) | 🔴 |
| Worst Frame Build Time Millis | 12.79ms | 11.79ms | +1.01ms (+8.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.62ms | 3.95ms | +0.66ms (+16.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.83ms | 1.59ms | +0.24ms (+15.2%) | 🔴 |
| Worst Frame Build Time Millis | 16.87ms | 15.40ms | +1.47ms (+9.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.67ms | 8.45ms | +0.22ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 3.5 | -2 (-71.4%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.91ms | 5.50ms | +0.41ms (+7.4%) | 🟠 |
| Worst Frame Build Time Millis | 27.53ms | 25.62ms | +1.91ms (+7.4%) | 🟠 |
| Missed Frame Build Budget Count | 4.75 | 4.25 | +0 (+11.8%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.12ms | 3.06ms | +0.06ms (+1.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.73ms | 21.19ms | +1.54ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 41.83ms | 41.62ms | +0.21ms (+0.5%) | 🟠 |
| Missed Frame Build Budget Count | 11.0 | 10.25 | +1 (+7.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.25ms | 3.06ms | +0.19ms (+6.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.05ms | 0.94ms | +0.11ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 22.71ms | 20.22ms | +2.48ms (+12.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.28ms | 3.49ms | +0.79ms (+22.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.30ms | 2.18ms | +0.11ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 8.70ms | 8.20ms | +0.51ms (+6.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.81ms | 3.77ms | +0.04ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.89ms | 8.54ms | +0.35ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 40.79ms | 39.55ms | +1.24ms (+3.1%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.54ms | 5.57ms | -0.03ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.01ms | +0.20ms (+19.6%) | 🔴 |
| Worst Frame Build Time Millis | 7.68ms | 6.33ms | +1.35ms (+21.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.22ms | 5.20ms | +1.02ms (+19.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 7.75 | 1.75 | +6 (+342.9%) | 🔴 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.18ms | +0.28ms (+23.6%) | 🔴 |
| Worst Frame Build Time Millis | 6.67ms | 6.05ms | +0.61ms (+10.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.80ms | 8.12ms | -0.32ms (-3.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 3.5 | 5.0 | -2 (-30.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.78ms | 1.63ms | +0.15ms (+9.0%) | 🟠 |
| Worst Frame Build Time Millis | 4.97ms | 3.33ms | +1.63ms (+49.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.25ms | 5.72ms | +0.53ms (+9.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

