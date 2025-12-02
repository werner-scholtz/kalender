## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 20.0%
- 🔴 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 20.2%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 23.8%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 15.2%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 5.5%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 11.7%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 7.0%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 12.1%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 11.3%
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 10.8%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 6.0%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 12.8%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 6.5%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 10.5%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 31.2%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.51ms | 2.42ms | +0.09ms (+3.7%) | 🟠 |
| Worst Frame Build Time Millis | 6.10ms | 5.86ms | +0.25ms (+4.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.17ms | 2.35ms | +1.81ms (+77.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.87ms | 4.32ms | +0.55ms (+12.8%) | 🔴 |
| Worst Frame Build Time Millis | 15.28ms | 12.90ms | +2.38ms (+18.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.98ms | 3.36ms | +1.62ms (+48.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.61ms | +0.01ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 3.90ms | 4.25ms | -0.35ms (-8.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.71ms | 3.63ms | +1.08ms (+29.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 4.0 | -4 (-93.8%) | 🟢 |
| New Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.47ms | +0.00ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.14ms | 2.13ms | +0.01ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.79ms | 2.45ms | +1.34ms (+54.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.63ms | 9.64ms | -1.01ms (-10.5%) | 🟢 |
| Worst Frame Build Time Millis | 24.49ms | 27.74ms | -3.25ms (-11.7%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 2.85ms | +1.10ms (+38.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.54ms | 6.94ms | -0.40ms (-5.8%) | 🟢 |
| Worst Frame Build Time Millis | 13.30ms | 16.00ms | -2.70ms (-16.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.14ms | 3.10ms | +2.04ms (+65.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.27ms | 1.97ms | +0.30ms (+15.2%) | 🔴 |
| Worst Frame Build Time Millis | 28.90ms | 29.27ms | -0.37ms (-1.3%) | 🟡 |
| Missed Frame Build Budget Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.47ms | 3.74ms | +2.72ms (+72.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| New Gen Gc Count | 7.0 | 9.0 | -2 (-22.2%) | 🟢 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.68ms | +0.05ms (+7.0%) | 🟠 |
| Worst Frame Build Time Millis | 1.89ms | 1.73ms | +0.16ms (+9.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.24ms | 9.51ms | +4.73ms (+49.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.67ms | 2.53ms | +0.14ms (+5.5%) | 🟠 |
| Worst Frame Build Time Millis | 9.33ms | 8.39ms | +0.93ms (+11.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.02ms | 2.73ms | +1.29ms (+47.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.52ms | 0.46ms | +0.06ms (+12.1%) | 🔴 |
| Worst Frame Build Time Millis | 3.15ms | 2.20ms | +0.95ms (+43.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.67ms | 2.64ms | +2.03ms (+76.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.75 | 0.25 | +2 (+1000.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.46ms | +0.05ms (+10.8%) | 🔴 |
| Worst Frame Build Time Millis | 2.10ms | 1.79ms | +0.31ms (+17.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.48ms | 2.17ms | +1.31ms (+60.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.75ms | 1.68ms | +0.08ms (+4.6%) | 🟠 |
| Worst Frame Build Time Millis | 4.34ms | 3.49ms | +0.84ms (+24.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.81ms | 5.36ms | +0.45ms (+8.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.56ms | 5.87ms | +0.69ms (+11.7%) | 🔴 |
| Worst Frame Build Time Millis | 23.27ms | 21.43ms | +1.83ms (+8.6%) | 🟠 |
| Missed Frame Build Budget Count | 6.5 | 4.25 | +2 (+52.9%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.88ms | 4.46ms | +2.42ms (+54.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.0 | +0 (+5.0%) | 🟠 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.68ms | 10.97ms | +0.71ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 35.44ms | 33.09ms | +2.35ms (+7.1%) | 🟠 |
| Missed Frame Build Budget Count | 3.75 | 3.5 | +0 (+7.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 7.28ms | 5.07ms | +2.22ms (+43.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 8.0 | +2 (+18.8%) | 🔴 |
| Old Gen Gc Count | 7.5 | 6.0 | +2 (+25.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.44ms | 1.16ms | +0.28ms (+23.8%) | 🔴 |
| Worst Frame Build Time Millis | 11.50ms | 7.68ms | +3.82ms (+49.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.20ms | 3.96ms | +4.24ms (+106.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 13.25 | 0.0 | +13 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 3.0 | 0.0 | +3 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.08ms | 1.05ms | +0.03ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 6.95ms | 5.61ms | +1.34ms (+23.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.17ms | 8.08ms | -1.90ms (-23.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 4.5 | -4 (-77.8%) | 🟢 |
| New Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.16ms | 5.53ms | +0.62ms (+11.3%) | 🔴 |
| Worst Frame Build Time Millis | 31.17ms | 27.13ms | +4.05ms (+14.9%) | 🔴 |
| Missed Frame Build Budget Count | 4.5 | 4.25 | +0 (+5.9%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.30ms | 3.14ms | +2.17ms (+69.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 12.0 | +2 (+16.7%) | 🔴 |
| Old Gen Gc Count | 7.5 | 5.5 | +2 (+36.4%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.65ms | 21.37ms | +1.28ms (+6.0%) | 🟠 |
| Worst Frame Build Time Millis | 44.09ms | 40.94ms | +3.15ms (+7.7%) | 🟠 |
| Missed Frame Build Budget Count | 10.0 | 10.5 | -0 (-4.8%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.88ms | 3.02ms | +2.86ms (+94.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.0 | 18.0 | -2 (-11.1%) | 🟢 |
| Old Gen Gc Count | 9.5 | 11.0 | -2 (-13.6%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.88ms | 0.95ms | -0.07ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 16.37ms | 20.62ms | -4.25ms (-20.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.02ms | 3.12ms | +3.90ms (+124.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 8.5 | 0.5 | +8 (+1600.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 6.0 | +2 (+33.3%) | 🔴 |
| Old Gen Gc Count | 7.0 | 5.5 | +2 (+27.3%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.43ms | 1.19ms | +0.24ms (+20.2%) | 🔴 |
| Worst Frame Build Time Millis | 9.03ms | 5.73ms | +3.30ms (+57.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.58ms | 3.78ms | +1.80ms (+47.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.12ms | 7.45ms | -0.32ms (-4.3%) | 🟡 |
| Worst Frame Build Time Millis | 30.83ms | 28.83ms | +2.00ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 2.25 | 2.0 | +0 (+12.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.87ms | 5.82ms | +2.05ms (+35.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.98ms | 0.81ms | +0.16ms (+20.0%) | 🔴 |
| Worst Frame Build Time Millis | 6.49ms | 4.79ms | +1.69ms (+35.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.11ms | 4.68ms | +3.43ms (+73.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.0 | 1.0 | +5 (+500.0%) | 🔴 |
| New Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.92ms | 1.33ms | -0.42ms (-31.2%) | 🟢 |
| Worst Frame Build Time Millis | 3.73ms | 9.89ms | -6.16ms (-62.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.64ms | 8.18ms | -0.54ms (-6.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 3.5 | -2 (-71.4%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.49ms | -0.12ms (-8.3%) | 🟢 |
| Worst Frame Build Time Millis | 2.90ms | 3.27ms | -0.37ms (-11.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.33ms | 5.72ms | +1.61ms (+28.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

</details>

