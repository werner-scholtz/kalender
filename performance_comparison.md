## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 41.2%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 15.1%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 59.2%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 8.2%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 7.9%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 5.8%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 13.0%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 14.9%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 7.3%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 10.5%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 5.3%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 7.0%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.98ms | 4.10ms | -0.12ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 7.81ms | 8.06ms | -0.25ms (-3.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.19ms | 2.63ms | -0.44ms (-16.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.06ms | 4.79ms | +0.28ms (+5.8%) | 🟠 |
| Worst Frame Build Time Millis | 19.97ms | 18.75ms | +1.23ms (+6.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.98ms | 3.96ms | +0.02ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.66ms | 0.70ms | -0.04ms (-5.2%) | 🟢 |
| Worst Frame Build Time Millis | 5.80ms | 7.40ms | -1.61ms (-21.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.80ms | 2.87ms | +2.93ms (+102.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.59ms | +0.04ms (+7.0%) | 🟠 |
| Worst Frame Build Time Millis | 3.96ms | 4.33ms | -0.37ms (-8.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.89ms | 2.62ms | +3.27ms (+124.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.48ms | 9.12ms | +1.36ms (+14.9%) | 🔴 |
| Worst Frame Build Time Millis | 30.06ms | 26.16ms | +3.89ms (+14.9%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.47ms | 2.86ms | +0.61ms (+21.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.19ms | 6.83ms | +0.36ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 17.07ms | 14.28ms | +2.79ms (+19.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.43ms | 3.38ms | +0.05ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.17ms | 1.96ms | +0.21ms (+10.5%) | 🔴 |
| Worst Frame Build Time Millis | 25.57ms | 28.18ms | -2.61ms (-9.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.25 | 1.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.63ms | 3.06ms | +1.57ms (+51.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 8.5 | +2 (+17.6%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.25ms | +0.06ms (+4.9%) | 🟠 |
| Worst Frame Build Time Millis | 2.50ms | 2.38ms | +0.12ms (+4.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.56ms | 2.05ms | +0.51ms (+25.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.98ms | 2.93ms | +0.04ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 9.96ms | 9.71ms | +0.25ms (+2.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.43ms | 3.47ms | -0.04ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.74ms | 0.68ms | +0.06ms (+8.2%) | 🟠 |
| Worst Frame Build Time Millis | 3.13ms | 5.76ms | -2.64ms (-45.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.17ms | 2.88ms | +2.29ms (+79.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.68ms | +0.09ms (+13.0%) | 🔴 |
| Worst Frame Build Time Millis | 3.33ms | 2.49ms | +0.84ms (+33.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.26ms | 3.95ms | +2.31ms (+58.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.39ms | 1.69ms | +0.70ms (+41.2%) | 🔴 |
| Worst Frame Build Time Millis | 7.80ms | 3.82ms | +3.98ms (+104.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.55ms | 3.88ms | +1.67ms (+42.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.83ms | 10.12ms | -0.29ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 27.44ms | 28.38ms | -0.94ms (-3.3%) | 🟡 |
| Missed Frame Build Budget Count | 7.75 | 7.5 | +0 (+3.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 4.93ms | 4.97ms | -0.04ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 11.0 | -1 (-9.1%) | 🟢 |
| Old Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.52ms | 10.77ms | -0.25ms (-2.3%) | 🟡 |
| Worst Frame Build Time Millis | 39.31ms | 40.45ms | -1.14ms (-2.8%) | 🟡 |
| Missed Frame Build Budget Count | 2.75 | 2.5 | +0 (+10.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.06ms | 5.31ms | -0.25ms (-4.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.41ms | -0.10ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 13.85ms | 14.64ms | -0.79ms (-5.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.74ms | 4.24ms | +2.49ms (+58.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.54ms | 1.48ms | +0.05ms (+3.5%) | 🟠 |
| Worst Frame Build Time Millis | 12.98ms | 11.70ms | +1.28ms (+10.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.86ms | 5.35ms | +2.51ms (+47.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.54ms | 5.77ms | -0.23ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 25.88ms | 29.34ms | -3.45ms (-11.8%) | 🟢 |
| Missed Frame Build Budget Count | 4.5 | 3.5 | +1 (+28.6%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.21ms | 3.26ms | -0.05ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 13.5 | -2 (-11.1%) | 🟢 |
| Old Gen Gc Count | 5.5 | 7.0 | -2 (-21.4%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.42ms | 23.32ms | -1.90ms (-8.2%) | 🟢 |
| Worst Frame Build Time Millis | 40.73ms | 43.36ms | -2.63ms (-6.1%) | 🟢 |
| Missed Frame Build Budget Count | 10.25 | 11.0 | -1 (-6.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 2.92ms | 3.27ms | -0.36ms (-10.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 17.5 | +0 (+2.9%) | 🟠 |
| Old Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.06ms | 0.98ms | +0.08ms (+7.9%) | 🟠 |
| Worst Frame Build Time Millis | 22.48ms | 19.27ms | +3.21ms (+16.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.75 | +0 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.89ms | 3.88ms | +2.01ms (+51.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.33ms | 2.34ms | -0.01ms (-0.5%) | 🟡 |
| Worst Frame Build Time Millis | 8.44ms | 8.68ms | -0.23ms (-2.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 3.98ms | -0.03ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.15ms | 8.53ms | +0.62ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 39.70ms | 38.82ms | +0.87ms (+2.3%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.73ms | 5.24ms | +0.49ms (+9.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 6.5 | +2 (+23.1%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.32ms | 1.15ms | +0.17ms (+15.1%) | 🔴 |
| Worst Frame Build Time Millis | 5.89ms | 6.14ms | -0.25ms (-4.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.90ms | 6.31ms | +1.60ms (+25.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.75 | 9.0 | -6 (-69.4%) | 🟢 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.57ms | 0.98ms | +0.58ms (+59.2%) | 🔴 |
| Worst Frame Build Time Millis | 6.78ms | 5.94ms | +0.84ms (+14.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.49ms | 5.00ms | +5.49ms (+109.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.0 | 0.0 | +6 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.71ms | 1.67ms | +0.03ms (+2.0%) | 🟠 |
| Worst Frame Build Time Millis | 4.30ms | 2.88ms | +1.42ms (+49.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.25ms | 5.96ms | +0.29ms (+4.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

