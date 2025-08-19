## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 7.6%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 37.1%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 17.8%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 31.5%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 28.2%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 13.6%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 12.7%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 19.5%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 25.2%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 14.8%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 14.1%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 19.3%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.10ms | 4.48ms | -0.38ms (-8.5%) | 🟢 |
| Worst Frame Build Time Millis | 8.09ms | 8.84ms | -0.75ms (-8.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.61ms | 2.47ms | +0.14ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.49ms | 5.25ms | +0.24ms (+4.6%) | 🟠 |
| Worst Frame Build Time Millis | 21.00ms | 20.85ms | +0.16ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.68ms | 3.98ms | -0.30ms (-7.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.91ms | -0.17ms (-19.3%) | 🟢 |
| Worst Frame Build Time Millis | 4.93ms | 4.65ms | +0.28ms (+6.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.04ms | 5.21ms | -2.17ms (-41.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Old Gen Gc Count | 3.5 | 1.0 | +2 (+250.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.71ms | -0.14ms (-19.5%) | 🟢 |
| Worst Frame Build Time Millis | 4.04ms | 4.86ms | -0.82ms (-17.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.39ms | 6.68ms | -4.29ms (-64.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.41ms | 8.81ms | -0.41ms (-4.6%) | 🟡 |
| Worst Frame Build Time Millis | 23.95ms | 25.12ms | -1.17ms (-4.7%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.94ms | 2.66ms | +0.28ms (+10.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.91ms | 7.02ms | -0.11ms (-1.6%) | 🟡 |
| Worst Frame Build Time Millis | 16.23ms | 16.78ms | -0.55ms (-3.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.23ms | 3.31ms | -0.08ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.84ms | 2.14ms | -0.30ms (-14.1%) | 🟢 |
| Worst Frame Build Time Millis | 25.20ms | 24.35ms | +0.85ms (+3.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.88ms | 4.62ms | -0.74ms (-16.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.0 | 0.0 | +3 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 1.24ms | -0.05ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 2.26ms | 2.33ms | -0.08ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.22ms | 2.25ms | -0.04ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.97ms | 3.09ms | -0.12ms (-3.8%) | 🟡 |
| Worst Frame Build Time Millis | 9.84ms | 10.12ms | -0.28ms (-2.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.45ms | 3.65ms | -0.20ms (-5.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.78ms | -0.25ms (-31.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.71ms | 3.56ms | -0.85ms (-23.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.53ms | 5.46ms | -2.93ms (-53.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.25 | -1 (-80.0%) | 🟢 |
| New Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.80ms | -0.22ms (-28.2%) | 🟢 |
| Worst Frame Build Time Millis | 2.81ms | 4.47ms | -1.66ms (-37.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.25ms | 5.57ms | -3.31ms (-59.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.77ms | 2.08ms | -0.31ms (-14.8%) | 🟢 |
| Worst Frame Build Time Millis | 4.13ms | 4.57ms | -0.44ms (-9.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.39ms | 5.83ms | -1.44ms (-24.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.15ms | 9.93ms | +0.22ms (+2.2%) | 🟠 |
| Worst Frame Build Time Millis | 27.07ms | 29.03ms | -1.96ms (-6.8%) | 🟢 |
| Missed Frame Build Budget Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.14ms | 4.87ms | +0.27ms (+5.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 11.0 | -1 (-9.1%) | 🟢 |
| Old Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.84ms | 12.80ms | -0.97ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 43.19ms | 42.84ms | +0.35ms (+0.8%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.00ms | 5.17ms | -0.18ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.60ms | 1.95ms | -0.35ms (-17.8%) | 🟢 |
| Worst Frame Build Time Millis | 13.61ms | 13.90ms | -0.29ms (-2.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.82ms | 8.14ms | -2.31ms (-28.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 6.25 | 3.0 | +3 (+108.3%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.98ms | 2.11ms | -0.13ms (-6.3%) | 🟢 |
| Worst Frame Build Time Millis | 20.25ms | 18.38ms | +1.88ms (+10.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 1.5 | -1 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.28ms | 8.08ms | -2.80ms (-34.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.60ms | 5.71ms | -0.12ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 28.08ms | 28.95ms | -0.87ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 4.25 | 4.0 | +0 (+6.2%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.27ms | 3.40ms | -0.13ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.29ms | 21.69ms | -0.40ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 42.00ms | 43.92ms | -1.92ms (-4.4%) | 🟡 |
| Missed Frame Build Budget Count | 10.5 | 10.25 | +0 (+2.4%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.32ms | 3.25ms | +0.08ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 17.5 | 20.0 | -2 (-12.5%) | 🟢 |
| Old Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.90ms | 1.04ms | -0.13ms (-12.7%) | 🟢 |
| Worst Frame Build Time Millis | 18.30ms | 21.33ms | -3.04ms (-14.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 1.0 | -0 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.42ms | 6.28ms | -2.85ms (-45.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 1.5 | +0 (+16.7%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.48ms | 2.31ms | +0.18ms (+7.6%) | 🟠 |
| Worst Frame Build Time Millis | 9.94ms | 8.57ms | +1.38ms (+16.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.97ms | 3.89ms | +0.08ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.63ms | 9.17ms | -0.54ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 35.56ms | 40.77ms | -5.21ms (-12.8%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.55ms | 5.69ms | -0.14ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.01ms | 1.35ms | -0.34ms (-25.2%) | 🟢 |
| Worst Frame Build Time Millis | 4.88ms | 6.91ms | -2.03ms (-29.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.68ms | 7.89ms | -2.21ms (-28.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 7.0 | 4.0 | +3 (+75.0%) | 🔴 |
| New Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.89ms | 1.41ms | -0.52ms (-37.1%) | 🟢 |
| Worst Frame Build Time Millis | 3.95ms | 10.02ms | -6.07ms (-60.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.58ms | 8.89ms | -4.30ms (-48.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 3.0 | -3 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.51ms | 1.75ms | -0.24ms (-13.6%) | 🟢 |
| Worst Frame Build Time Millis | 2.90ms | 3.91ms | -1.02ms (-26.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.93ms | 6.00ms | -0.07ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

</details>

