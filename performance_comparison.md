## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 33.5%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 15.7%
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 136.0%
- 🔴 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 15.4%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 21.1%
- 🔴 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 18.0%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 39.4%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 20.3%
- 🔴 **one_event_per_day-month-navigation**: Frame build time increased by 16.7%
- 🔴 **one_event_per_day-week-navigation**: Frame build time increased by 17.9%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 20.4%
- 🔴 **ten_events_per_day-schedule-navigation**: Frame build time increased by 16.7%
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 24.9%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 19.9%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 15.5%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 11.5%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 11.4%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 12.8%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 10.1%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 7.8%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 10.2%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 12.7%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.79ms | 2.48ms | +0.32ms (+12.7%) | 🔴 |
| Worst Frame Build Time Millis | 6.73ms | 6.13ms | +0.60ms (+9.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.08ms | 4.97ms | -0.89ms (-17.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.60ms | 4.80ms | +0.80ms (+16.7%) | 🔴 |
| Worst Frame Build Time Millis | 18.74ms | 17.00ms | +1.74ms (+10.2%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 1.25 | +0 (+20.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.53ms | 5.48ms | +0.06ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 0.65ms | +0.16ms (+24.9%) | 🔴 |
| Worst Frame Build Time Millis | 3.65ms | 2.68ms | +0.97ms (+36.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.19ms | 5.41ms | -0.22ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.75 | +0 (+66.7%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.5 | -1 (-22.2%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.49ms | +0.10ms (+20.4%) | 🔴 |
| Worst Frame Build Time Millis | 2.12ms | 1.76ms | +0.36ms (+20.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.17ms | 4.54ms | -0.37ms (-8.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.28ms | 10.62ms | +1.67ms (+15.7%) | 🔴 |
| Worst Frame Build Time Millis | 34.70ms | 30.49ms | +4.22ms (+13.8%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.65ms | 5.48ms | +0.17ms (+3.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.76ms | 7.04ms | +0.72ms (+10.2%) | 🔴 |
| Worst Frame Build Time Millis | 15.40ms | 13.46ms | +1.95ms (+14.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.50ms | 6.73ms | -0.23ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.83ms | 2.03ms | +0.80ms (+39.4%) | 🔴 |
| Worst Frame Build Time Millis | 30.58ms | 28.55ms | +2.03ms (+7.1%) | 🟠 |
| Missed Frame Build Budget Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.09ms | 6.61ms | +0.49ms (+7.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.75 | 2.5 | +1 (+50.0%) | 🔴 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.38ms | 0.58ms | +0.80ms (+136.0%) | 🔴 |
| Worst Frame Build Time Millis | 3.80ms | 1.50ms | +2.31ms (+154.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.84ms | 3.87ms | +0.97ms (+25.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.10ms | 2.63ms | +0.47ms (+17.9%) | 🔴 |
| Worst Frame Build Time Millis | 10.44ms | 8.71ms | +1.73ms (+19.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.14ms | 4.22ms | -0.08ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 4.5 | +2 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.84ms | 0.69ms | +0.15ms (+21.1%) | 🔴 |
| Worst Frame Build Time Millis | 4.63ms | 3.58ms | +1.05ms (+29.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.58ms | 4.50ms | +0.08ms (+1.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.57ms | +0.19ms (+33.5%) | 🔴 |
| Worst Frame Build Time Millis | 3.48ms | 1.84ms | +1.64ms (+89.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.21ms | 4.43ms | -0.23ms (-5.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.98ms | 2.06ms | -0.08ms (-3.7%) | 🟡 |
| Worst Frame Build Time Millis | 3.67ms | 4.97ms | -1.31ms (-26.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.48ms | 5.70ms | -0.23ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.03ms | 6.52ms | +0.51ms (+7.8%) | 🟠 |
| Worst Frame Build Time Millis | 22.52ms | 24.59ms | -2.07ms (-8.4%) | 🟢 |
| Missed Frame Build Budget Count | 6.5 | 4.25 | +2 (+52.9%) | 🔴 |
| Average Frame Rasterizer Time Millis | 8.41ms | 8.85ms | -0.44ms (-5.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.00ms | 13.30ms | +1.71ms (+12.8%) | 🔴 |
| Worst Frame Build Time Millis | 47.80ms | 40.35ms | +7.45ms (+18.5%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 3.75 | +0 (+6.7%) | 🟠 |
| Average Frame Rasterizer Time Millis | 9.38ms | 9.23ms | +0.15ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.55ms | 1.29ms | +0.26ms (+20.3%) | 🔴 |
| Worst Frame Build Time Millis | 9.12ms | 7.55ms | +1.57ms (+20.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.93ms | 8.32ms | -0.40ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 6.5 | 7.25 | -1 (-10.3%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.5 | -2 (-60.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.19ms | +0.14ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 6.79ms | 5.42ms | +1.38ms (+25.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.00ms | 7.08ms | -1.08ms (-15.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.87ms | 5.09ms | +0.79ms (+15.4%) | 🔴 |
| Worst Frame Build Time Millis | 25.10ms | 23.13ms | +1.97ms (+8.5%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 2.75 | +1 (+45.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.37ms | 6.62ms | -0.25ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.54ms | 21.03ms | +3.51ms (+16.7%) | 🔴 |
| Worst Frame Build Time Millis | 46.14ms | 39.92ms | +6.22ms (+15.6%) | 🔴 |
| Missed Frame Build Budget Count | 9.0 | 8.75 | +0 (+2.9%) | 🟠 |
| Average Frame Rasterizer Time Millis | 7.13ms | 7.38ms | -0.25ms (-3.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 15.0 | -1 (-6.7%) | 🟢 |
| Old Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.54ms | 1.33ms | +0.21ms (+15.5%) | 🔴 |
| Worst Frame Build Time Millis | 21.46ms | 16.63ms | +4.83ms (+29.0%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.59ms | 6.96ms | -0.36ms (-5.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.09ms | +0.20ms (+18.0%) | 🔴 |
| Worst Frame Build Time Millis | 6.81ms | 6.00ms | +0.80ms (+13.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.49ms | 6.71ms | -0.22ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.21ms | 7.37ms | +0.84ms (+11.4%) | 🔴 |
| Worst Frame Build Time Millis | 30.27ms | 27.49ms | +2.78ms (+10.1%) | 🔴 |
| Missed Frame Build Budget Count | 3.5 | 1.75 | +2 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.10ms | 9.49ms | -0.39ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.22ms | +0.24ms (+19.9%) | 🔴 |
| Worst Frame Build Time Millis | 6.61ms | 6.45ms | +0.16ms (+2.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.90ms | 10.29ms | +0.61ms (+5.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 23.0 | 13.0 | +10 (+76.9%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.44ms | 1.31ms | +0.13ms (+10.1%) | 🔴 |
| Worst Frame Build Time Millis | 5.48ms | 4.31ms | +1.17ms (+27.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.49ms | 12.84ms | -1.35ms (-10.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 3.25 | +0 (+15.4%) | 🔴 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.22ms | 4.21ms | +0.01ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 8.26ms | 8.62ms | -0.36ms (-4.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.35ms | 10.27ms | +0.08ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

</details>

