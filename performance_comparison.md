## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 34.1%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 17.1%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 9.5%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 8.9%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 14.8%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-navigation**: Frame build time improved by 12.9%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 11.5%
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 27.4%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 12.8%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 40.0%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 28.3%
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 18.0%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 30.6%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.84ms | 3.08ms | -0.24ms (-7.7%) | 🟢 |
| Worst Frame Build Time Millis | 6.71ms | 7.58ms | -0.87ms (-11.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.69ms | 4.16ms | +0.52ms (+12.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.33ms | 5.40ms | -0.07ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 16.46ms | 20.36ms | -3.89ms (-19.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.50ms | 5.37ms | +0.14ms (+2.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.73ms | +0.04ms (+4.8%) | 🟠 |
| Worst Frame Build Time Millis | 3.06ms | 3.05ms | +0.01ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.88ms | 4.68ms | +0.19ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.84ms | -0.26ms (-30.6%) | 🟢 |
| Worst Frame Build Time Millis | 1.96ms | 3.64ms | -1.68ms (-46.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.10ms | 5.47ms | -1.37ms (-25.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.95ms | 8.91ms | +3.03ms (+34.1%) | 🔴 |
| Worst Frame Build Time Millis | 33.98ms | 25.04ms | +8.95ms (+35.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.36ms | 4.37ms | +0.99ms (+22.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.70ms | 7.39ms | +0.31ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 17.84ms | 14.57ms | +3.27ms (+22.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.38ms | 6.46ms | -0.08ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 6.0 | -2 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.21ms | 1.93ms | +0.29ms (+14.8%) | 🔴 |
| Worst Frame Build Time Millis | 25.80ms | 23.97ms | +1.83ms (+7.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.06ms | 5.84ms | +0.23ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.79ms | -0.09ms (-11.5%) | 🟢 |
| Worst Frame Build Time Millis | 1.82ms | 2.09ms | -0.28ms (-13.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.08ms | 4.50ms | -0.43ms (-9.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.01ms | 3.16ms | -0.15ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 9.88ms | 10.80ms | -0.92ms (-8.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.01ms | 4.10ms | -0.09ms (-2.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.74ms | 0.80ms | -0.05ms (-6.7%) | 🟢 |
| Worst Frame Build Time Millis | 3.51ms | 4.19ms | -0.67ms (-16.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.19ms | 4.34ms | -0.15ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.66ms | 0.61ms | +0.06ms (+9.5%) | 🟠 |
| Worst Frame Build Time Millis | 2.98ms | 2.45ms | +0.53ms (+21.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.91ms | 3.87ms | +0.03ms (+0.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.18ms | 2.22ms | -0.04ms (-1.7%) | 🟡 |
| Worst Frame Build Time Millis | 4.35ms | 4.36ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.26ms | 5.29ms | -0.03ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.85ms | 9.56ms | -2.71ms (-28.3%) | 🟢 |
| Worst Frame Build Time Millis | 24.15ms | 34.40ms | -10.25ms (-29.8%) | 🟢 |
| Missed Frame Build Budget Count | 5.75 | 7.75 | -2 (-25.8%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.62ms | 8.78ms | -0.16ms (-1.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 12.0 | -2 (-16.7%) | 🟢 |
| Old Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.66ms | 18.82ms | -5.15ms (-27.4%) | 🟢 |
| Worst Frame Build Time Millis | 37.49ms | 52.92ms | -15.43ms (-29.2%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.71ms | 8.11ms | +0.60ms (+7.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.50ms | -0.08ms (-5.3%) | 🟢 |
| Worst Frame Build Time Millis | 7.91ms | 13.88ms | -5.98ms (-43.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.54ms | 7.67ms | -0.13ms (-1.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 5.75 | 2.0 | +4 (+187.5%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.37ms | -0.18ms (-12.8%) | 🟢 |
| Worst Frame Build Time Millis | 5.84ms | 8.90ms | -3.06ms (-34.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.08ms | 6.58ms | -0.50ms (-7.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.56ms | 5.81ms | -0.25ms (-4.3%) | 🟡 |
| Worst Frame Build Time Millis | 27.37ms | 24.94ms | +2.43ms (+9.8%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.32ms | 6.32ms | +0.01ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 19.0 | -5 (-26.3%) | 🟢 |
| Old Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.42ms | 25.38ms | -1.96ms (-7.7%) | 🟢 |
| Worst Frame Build Time Millis | 47.47ms | 47.53ms | -0.06ms (-0.1%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.10ms | 6.89ms | +0.21ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 15.0 | -1 (-6.7%) | 🟢 |
| Old Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.35ms | 1.24ms | +0.11ms (+8.9%) | 🟠 |
| Worst Frame Build Time Millis | 20.28ms | 18.12ms | +2.16ms (+11.9%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.57ms | 6.31ms | +0.27ms (+4.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.75 | 1.25 | +2 (+120.0%) | 🔴 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.26ms | 1.53ms | -0.28ms (-18.0%) | 🟢 |
| Worst Frame Build Time Millis | 6.35ms | 7.80ms | -1.45ms (-18.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.47ms | 6.81ms | -0.34ms (-4.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.95ms | 9.13ms | -1.18ms (-12.9%) | 🟢 |
| Worst Frame Build Time Millis | 29.58ms | 35.55ms | -5.97ms (-16.8%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.88ms | 8.93ms | -0.05ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.36ms | -0.06ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 5.50ms | 6.55ms | -1.05ms (-16.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.12ms | 10.11ms | +0.01ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 15.25 | 10.75 | +4 (+41.9%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.05ms | 1.75ms | -0.70ms (-40.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.48ms | 6.77ms | -3.29ms (-48.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.56ms | 13.48ms | -3.91ms (-29.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.25 | 4.5 | -1 (-27.8%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.89ms | 3.32ms | +0.57ms (+17.1%) | 🔴 |
| Worst Frame Build Time Millis | 8.69ms | 5.78ms | +2.91ms (+50.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.29ms | 10.35ms | -0.07ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>

