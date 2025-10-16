## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 16.0%
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 24.1%
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 16.1%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 11.5%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.7%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 7.6%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 24.7%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 29.3%
- 🟢 **one_event_per_day-month-navigation**: Frame build time improved by 10.3%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 18.8%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 11.0%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 13.6%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.75ms | 3.98ms | -0.24ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 7.31ms | 7.81ms | -0.50ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.37ms | 2.19ms | +0.18ms (+8.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.54ms | 5.06ms | -0.52ms (-10.3%) | 🟢 |
| Worst Frame Build Time Millis | 17.88ms | 19.97ms | -2.10ms (-10.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.06ms | 3.98ms | +0.08ms (+1.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.66ms | +0.16ms (+24.1%) | 🔴 |
| Worst Frame Build Time Millis | 8.76ms | 5.80ms | +2.96ms (+51.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.22ms | 5.80ms | +1.42ms (+24.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 12.25 | 1.0 | +11 (+1125.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.63ms | +0.05ms (+7.6%) | 🟠 |
| Worst Frame Build Time Millis | 4.54ms | 3.96ms | +0.58ms (+14.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.44ms | 5.89ms | +4.55ms (+77.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.16ms | 10.48ms | -0.31ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 29.29ms | 30.06ms | -0.77ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.34ms | 3.47ms | -0.13ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.40ms | 7.19ms | -0.79ms (-11.0%) | 🟢 |
| Worst Frame Build Time Millis | 11.67ms | 17.07ms | -5.40ms (-31.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.57ms | 3.43ms | +0.14ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 6.0 | +2 (+33.3%) | 🔴 |
| Old Gen Gc Count | 4.0 | 2.0 | +2 (+100.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.12ms | 2.17ms | -0.04ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 26.39ms | 25.57ms | +0.82ms (+3.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.22ms | 4.63ms | +1.59ms (+34.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 7.5 | 0.0 | +8 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 10.0 | -2 (-20.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.07ms | 1.31ms | -0.25ms (-18.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.00ms | 2.50ms | -0.50ms (-19.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.20ms | 2.56ms | -0.36ms (-13.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.81ms | 2.98ms | -0.17ms (-5.7%) | 🟢 |
| Worst Frame Build Time Millis | 10.99ms | 9.96ms | +1.02ms (+10.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.47ms | 3.43ms | +0.04ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.74ms | -0.10ms (-13.6%) | 🟢 |
| Worst Frame Build Time Millis | 5.41ms | 3.13ms | +2.28ms (+72.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.73ms | 5.17ms | -0.44ms (-8.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 0.75 | +1 (+166.7%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.74ms | 0.76ms | -0.03ms (-3.4%) | 🟡 |
| Worst Frame Build Time Millis | 3.20ms | 3.33ms | -0.13ms (-4.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.07ms | 6.26ms | +2.81ms (+44.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.25 | 1.0 | +3 (+325.0%) | 🔴 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.80ms | 2.39ms | -0.59ms (-24.7%) | 🟢 |
| Worst Frame Build Time Millis | 4.44ms | 7.80ms | -3.36ms (-43.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.16ms | 5.55ms | -0.39ms (-7.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.96ms | 9.83ms | +1.13ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 48.88ms | 27.44ms | +21.45ms (+78.2%) | 🔴 |
| Missed Frame Build Budget Count | 6.25 | 7.75 | -2 (-19.4%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.79ms | 4.93ms | +0.87ms (+17.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.5 | 10.0 | +2 (+15.0%) | 🔴 |
| Old Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.22ms | 10.52ms | +1.70ms (+16.1%) | 🔴 |
| Worst Frame Build Time Millis | 54.53ms | 39.31ms | +15.22ms (+38.7%) | 🔴 |
| Missed Frame Build Budget Count | 3.25 | 2.75 | +0 (+18.2%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.84ms | 5.06ms | +0.77ms (+15.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.52ms | 1.31ms | +0.21ms (+16.0%) | 🔴 |
| Worst Frame Build Time Millis | 14.82ms | 13.85ms | +0.97ms (+7.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.38ms | 6.74ms | +1.65ms (+24.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 8.5 | 0.0 | +8 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 4.0 | +2 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.57ms | 1.54ms | +0.03ms (+2.3%) | 🟠 |
| Worst Frame Build Time Millis | 11.82ms | 12.98ms | -1.16ms (-8.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 11.90ms | 7.86ms | +4.04ms (+51.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.0 | 0.5 | +4 (+700.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.86ms | 5.54ms | +0.32ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 31.99ms | 25.88ms | +6.11ms (+23.6%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.48ms | 3.21ms | +0.27ms (+8.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 12.0 | +2 (+16.7%) | 🔴 |
| Old Gen Gc Count | 7.5 | 5.5 | +2 (+36.4%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 20.82ms | 21.42ms | -0.60ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 46.44ms | 40.73ms | +5.71ms (+14.0%) | 🔴 |
| Missed Frame Build Budget Count | 8.75 | 10.25 | -2 (-14.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.54ms | 2.92ms | +0.63ms (+21.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 21.5 | 18.0 | +4 (+19.4%) | 🔴 |
| Old Gen Gc Count | 10.5 | 9.0 | +2 (+16.7%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 1.06ms | -0.02ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 20.09ms | 22.48ms | -2.39ms (-10.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 1.0 | -0 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.61ms | 5.89ms | +0.73ms (+12.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 8.25 | 2.5 | +6 (+230.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.29ms | 2.33ms | -0.03ms (-1.5%) | 🟡 |
| Worst Frame Build Time Millis | 10.02ms | 8.44ms | +1.58ms (+18.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.46ms | 3.95ms | +0.51ms (+12.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 2.0 | +2 (+100.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.05ms | 9.15ms | -0.09ms (-1.0%) | 🟡 |
| Worst Frame Build Time Millis | 40.49ms | 39.70ms | +0.79ms (+2.0%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.18ms | 5.73ms | +0.45ms (+7.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 8.0 | -2 (-25.0%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.27ms | 1.32ms | -0.05ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 5.52ms | 5.89ms | -0.38ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.85ms | 7.90ms | +3.95ms (+49.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 12.75 | 2.75 | +10 (+363.6%) | 🔴 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 1.57ms | -0.46ms (-29.3%) | 🟢 |
| Worst Frame Build Time Millis | 4.53ms | 6.78ms | -2.24ms (-33.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.74ms | 10.49ms | +0.26ms (+2.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 6.0 | -6 (-91.7%) | 🟢 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.75ms | 1.71ms | +0.05ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 4.68ms | 4.30ms | +0.38ms (+9.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.65ms | 6.25ms | +0.40ms (+6.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>

