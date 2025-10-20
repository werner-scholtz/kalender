## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 47.9%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 13.1%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 11.5%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 5.3%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 9.1%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 9.0%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 6.9%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 6.2%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 7.2%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 7.1%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 17.5%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 16.2%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 24.3%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.60ms | 2.49ms | +0.10ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 6.22ms | 5.94ms | +0.29ms (+4.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.79ms | 2.59ms | +0.20ms (+7.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.57ms | 4.46ms | +0.11ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 13.81ms | 16.39ms | -2.57ms (-15.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.58ms | 3.97ms | -0.39ms (-9.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.67ms | -0.05ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.62ms | 4.05ms | -0.43ms (-10.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.67ms | 2.93ms | +1.73ms (+59.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 8.75 | 0.25 | +8 (+3400.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.60ms | +0.08ms (+13.1%) | 🔴 |
| Worst Frame Build Time Millis | 5.08ms | 3.99ms | +1.09ms (+27.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.42ms | 6.00ms | +1.42ms (+23.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.0 | 2.0 | +2 (+100.0%) | 🔴 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.39ms | 9.31ms | +1.07ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 29.67ms | 26.74ms | +2.93ms (+11.0%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.50ms | 2.90ms | +0.60ms (+20.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.30ms | 6.83ms | +0.47ms (+6.9%) | 🟠 |
| Worst Frame Build Time Millis | 17.61ms | 14.42ms | +3.19ms (+22.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.44ms | 3.35ms | +0.09ms (+2.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.14ms | 1.99ms | +0.14ms (+7.2%) | 🟠 |
| Worst Frame Build Time Millis | 27.03ms | 24.60ms | +2.43ms (+9.9%) | 🟠 |
| Missed Frame Build Budget Count | 1.75 | 1.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.18ms | 3.06ms | +1.12ms (+36.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 0.0 | +4 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.79ms | -0.03ms (-4.3%) | 🟡 |
| Worst Frame Build Time Millis | 1.96ms | 2.06ms | -0.10ms (-4.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.86ms | 3.88ms | +5.98ms (+154.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.77ms | 2.78ms | -0.01ms (-0.3%) | 🟡 |
| Worst Frame Build Time Millis | 8.76ms | 9.01ms | -0.24ms (-2.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.00ms | 3.25ms | -0.25ms (-7.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.63ms | -0.10ms (-16.2%) | 🟢 |
| Worst Frame Build Time Millis | 2.53ms | 2.63ms | -0.10ms (-3.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.70ms | 3.31ms | -0.61ms (-18.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.25 | -1 (-80.0%) | 🟢 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 1.0 | 3.5 | -2 (-71.4%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.54ms | 0.60ms | -0.06ms (-9.9%) | 🟢 |
| Worst Frame Build Time Millis | 2.55ms | 2.15ms | +0.39ms (+18.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.30ms | 2.42ms | +0.88ms (+36.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.01ms | 1.87ms | +0.13ms (+7.1%) | 🟠 |
| Worst Frame Build Time Millis | 4.56ms | 4.47ms | +0.09ms (+2.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.51ms | 3.77ms | +1.73ms (+45.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.52ms | 6.24ms | +0.28ms (+4.5%) | 🟠 |
| Worst Frame Build Time Millis | 27.02ms | 22.93ms | +4.10ms (+17.9%) | 🔴 |
| Missed Frame Build Budget Count | 5.0 | 5.25 | -0 (-4.8%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.73ms | 4.58ms | +0.15ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.5 | -1 (-9.5%) | 🟢 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.44ms | 10.87ms | +0.57ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 34.31ms | 38.17ms | -3.86ms (-10.1%) | 🟢 |
| Missed Frame Build Budget Count | 3.75 | 4.0 | -0 (-6.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.08ms | 5.56ms | -0.48ms (-8.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 6.5 | -1 (-15.4%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 1.66ms | -0.40ms (-24.3%) | 🟢 |
| Worst Frame Build Time Millis | 8.04ms | 11.85ms | -3.81ms (-32.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.13ms | 5.65ms | -1.52ms (-26.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| New Gen Gc Count | 4.5 | 6.0 | -2 (-25.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 3.0 | -2 (-83.3%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.36ms | -0.02ms (-1.6%) | 🟡 |
| Worst Frame Build Time Millis | 8.08ms | 10.68ms | -2.60ms (-24.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.23ms | 5.39ms | +4.84ms (+89.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 7.5 | 0.75 | +7 (+900.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.45ms | 5.91ms | +0.54ms (+9.1%) | 🟠 |
| Worst Frame Build Time Millis | 29.50ms | 26.73ms | +2.77ms (+10.4%) | 🔴 |
| Missed Frame Build Budget Count | 5.25 | 4.25 | +1 (+23.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.26ms | 3.10ms | +0.16ms (+5.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.5 | 13.5 | -1 (-7.4%) | 🟢 |
| Old Gen Gc Count | 5.5 | 7.0 | -2 (-21.4%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.40ms | 23.29ms | +2.11ms (+9.0%) | 🟠 |
| Worst Frame Build Time Millis | 49.44ms | 47.41ms | +2.03ms (+4.3%) | 🟠 |
| Missed Frame Build Budget Count | 10.75 | 10.5 | +0 (+2.4%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.18ms | 3.27ms | -0.10ms (-2.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 19.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.08ms | 1.05ms | +0.03ms (+2.6%) | 🟠 |
| Worst Frame Build Time Millis | 19.90ms | 18.30ms | +1.60ms (+8.7%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.34ms | 5.08ms | -0.74ms (-14.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.30ms | 1.34ms | -0.04ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 7.85ms | 7.19ms | +0.66ms (+9.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.89ms | 3.73ms | +0.16ms (+4.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.99ms | 7.89ms | +0.10ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 29.90ms | 29.95ms | -0.05ms (-0.2%) | 🟡 |
| Missed Frame Build Budget Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.49ms | 5.37ms | +0.12ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.94ms | 1.13ms | -0.20ms (-17.5%) | 🟢 |
| Worst Frame Build Time Millis | 6.31ms | 4.40ms | +1.90ms (+43.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.13ms | 5.27ms | +0.86ms (+16.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 7.0 | 0.0 | +7 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.58ms | 1.07ms | +0.51ms (+47.9%) | 🔴 |
| Worst Frame Build Time Millis | 7.77ms | 4.22ms | +3.54ms (+84.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.56ms | 5.23ms | +5.34ms (+102.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 7.0 | 0.0 | +7 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.79ms | 1.69ms | +0.10ms (+6.2%) | 🟠 |
| Worst Frame Build Time Millis | 3.60ms | 3.05ms | +0.56ms (+18.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.23ms | 6.16ms | +0.07ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

</details>

