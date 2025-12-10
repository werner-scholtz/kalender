## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 34.3%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 20.2%
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 21.5%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 39.3%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 20.6%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 20.3%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 8.6%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 5.3%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 9.1%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 11.9%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 8.5%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 10.0%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 12.8%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.63ms | 2.35ms | +0.28ms (+11.9%) | 🔴 |
| Worst Frame Build Time Millis | 6.41ms | 5.60ms | +0.81ms (+14.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.66ms | 3.74ms | -0.08ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.76ms | 4.74ms | +0.03ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 14.42ms | 14.54ms | -0.11ms (-0.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.94ms | 4.94ms | +0.00ms (+0.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.61ms | +0.13ms (+21.5%) | 🔴 |
| Worst Frame Build Time Millis | 4.84ms | 3.26ms | +1.58ms (+48.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.42ms | 4.58ms | +1.84ms (+40.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.25 | 1.0 | +2 (+225.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.46ms | +0.05ms (+10.0%) | 🟠 |
| Worst Frame Build Time Millis | 2.30ms | 2.14ms | +0.15ms (+7.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.69ms | 3.86ms | +1.82ms (+47.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.34ms | 9.11ms | -0.77ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 23.79ms | 25.94ms | -2.15ms (-8.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.30ms | 4.54ms | -0.24ms (-5.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.76ms | 6.45ms | +0.31ms (+4.7%) | 🟠 |
| Worst Frame Build Time Millis | 14.15ms | 12.85ms | +1.30ms (+10.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.32ms | 5.22ms | +0.10ms (+1.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.44ms | 2.03ms | +0.42ms (+20.6%) | 🔴 |
| Worst Frame Build Time Millis | 34.61ms | 27.12ms | +7.49ms (+27.6%) | 🔴 |
| Missed Frame Build Budget Count | 2.0 | 1.75 | +0 (+14.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.16ms | 5.61ms | +1.55ms (+27.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 1.25 | +2 (+180.0%) | 🔴 |
| New Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.73ms | -0.02ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 1.85ms | 1.90ms | -0.04ms (-2.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.03ms | 14.16ms | -0.13ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.63ms | 2.64ms | -0.00ms (-0.2%) | 🟡 |
| Worst Frame Build Time Millis | 8.76ms | 8.80ms | -0.04ms (-0.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.98ms | 3.91ms | +0.06ms (+1.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.63ms | +0.05ms (+8.5%) | 🟠 |
| Worst Frame Build Time Millis | 3.23ms | 4.73ms | -1.49ms (-31.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.83ms | 4.97ms | +0.86ms (+17.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.49ms | +0.10ms (+20.2%) | 🔴 |
| Worst Frame Build Time Millis | 2.47ms | 1.92ms | +0.56ms (+29.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.25ms | 3.50ms | +1.75ms (+49.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.83ms | 1.69ms | +0.15ms (+8.6%) | 🟠 |
| Worst Frame Build Time Millis | 4.30ms | 4.12ms | +0.18ms (+4.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.07ms | 5.72ms | +0.35ms (+6.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.51ms | 6.58ms | -0.07ms (-1.1%) | 🟡 |
| Worst Frame Build Time Millis | 24.66ms | 24.43ms | +0.23ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 6.25 | 6.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.56ms | 6.73ms | -0.17ms (-2.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 6.5 | +0 (+7.7%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.39ms | 10.93ms | +0.46ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 37.20ms | 32.17ms | +5.03ms (+15.6%) | 🔴 |
| Missed Frame Build Budget Count | 3.25 | 3.5 | -0 (-7.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.87ms | 7.12ms | -0.25ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.71ms | 1.23ms | +0.48ms (+39.3%) | 🔴 |
| Worst Frame Build Time Millis | 11.60ms | 8.25ms | +3.35ms (+40.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.39ms | 7.11ms | +2.28ms (+32.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 10.0 | 0.0 | +10 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 4.0 | +2 (+50.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 0.0 | +3 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.18ms | 1.36ms | -0.17ms (-12.8%) | 🟢 |
| Worst Frame Build Time Millis | 7.43ms | 10.18ms | -2.75ms (-27.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.34ms | 12.64ms | -5.30ms (-41.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 7.5 | -8 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.35ms | 5.82ms | +0.53ms (+9.1%) | 🟠 |
| Worst Frame Build Time Millis | 32.71ms | 30.33ms | +2.37ms (+7.8%) | 🟠 |
| Missed Frame Build Budget Count | 4.5 | 4.75 | -0 (-5.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.25ms | 5.16ms | +0.08ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.14ms | 23.56ms | -0.42ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 43.30ms | 47.11ms | -3.82ms (-8.1%) | 🟢 |
| Missed Frame Build Budget Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.86ms | 5.33ms | +0.53ms (+9.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.0 | 16.5 | -0 (-3.0%) | 🟡 |
| Old Gen Gc Count | 9.5 | 10.5 | -1 (-9.5%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.97ms | 0.94ms | +0.04ms (+3.8%) | 🟠 |
| Worst Frame Build Time Millis | 17.82ms | 20.42ms | -2.60ms (-12.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 9.42ms | 7.09ms | +2.33ms (+32.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 15.75 | 8.5 | +7 (+85.3%) | 🔴 |
| New Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |
| Old Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.41ms | 1.34ms | +0.07ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 6.89ms | 6.74ms | +0.14ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.55ms | 5.56ms | -0.02ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.99ms | 7.12ms | -0.13ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 30.18ms | 28.86ms | +1.32ms (+4.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.75ms | 7.65ms | +0.11ms (+1.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.24ms | 1.03ms | +0.21ms (+20.3%) | 🔴 |
| Worst Frame Build Time Millis | 6.38ms | 5.69ms | +0.69ms (+12.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.75ms | 9.44ms | +0.31ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 9.0 | 6.5 | +2 (+38.5%) | 🔴 |
| New Gen Gc Count | 6.0 | 4.0 | +2 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 0.88ms | +0.30ms (+34.3%) | 🔴 |
| Worst Frame Build Time Millis | 6.76ms | 3.62ms | +3.13ms (+86.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.27ms | 9.27ms | +0.01ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.66ms | 1.66ms | -0.00ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 3.78ms | 3.29ms | +0.49ms (+14.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.67ms | 9.05ms | -0.38ms (-4.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>

