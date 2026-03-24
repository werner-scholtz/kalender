## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 35.9%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 11.1%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 18.9%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 10.1%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 22.9%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 11.6%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 15.8%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 51.3%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.52ms | 2.79ms | -0.28ms (-9.9%) | 🟢 |
| Worst Frame Build Time Millis | 6.18ms | 6.73ms | -0.55ms (-8.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.66ms | 4.08ms | -0.42ms (-10.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.25ms | 5.60ms | -0.35ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 18.56ms | 18.74ms | -0.18ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 1.25 | 1.5 | -0 (-16.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.43ms | 5.53ms | -0.11ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.81ms | -0.02ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 3.51ms | 3.65ms | -0.14ms (-3.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.98ms | 5.19ms | -0.21ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.60ms | -0.04ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 2.01ms | 2.12ms | -0.11ms (-5.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 4.17ms | -0.22ms (-5.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.96ms | 12.28ms | -2.32ms (-18.9%) | 🟢 |
| Worst Frame Build Time Millis | 28.18ms | 34.70ms | -6.52ms (-18.8%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.52ms | 5.65ms | -1.13ms (-20.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.75ms | 7.76ms | -0.01ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 15.71ms | 15.40ms | +0.30ms (+2.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.48ms | 6.50ms | -0.02ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.51ms | 2.83ms | -0.33ms (-11.6%) | 🟢 |
| Worst Frame Build Time Millis | 28.69ms | 30.58ms | -1.90ms (-6.2%) | 🟢 |
| Missed Frame Build Budget Count | 1.75 | 2.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.90ms | 7.09ms | -1.19ms (-16.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 3.75 | -4 (-100.0%) | 🟢 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 1.38ms | -0.71ms (-51.3%) | 🟢 |
| Worst Frame Build Time Millis | 1.75ms | 3.80ms | -2.05ms (-53.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.66ms | 4.84ms | -1.18ms (-24.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.20ms | 3.10ms | +0.11ms (+3.5%) | 🟠 |
| Worst Frame Build Time Millis | 11.75ms | 10.44ms | +1.32ms (+12.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.13ms | 4.14ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.84ms | -0.08ms (-10.1%) | 🟢 |
| Worst Frame Build Time Millis | 3.94ms | 4.63ms | -0.69ms (-15.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.17ms | 4.58ms | -0.41ms (-9.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.65ms | 0.77ms | -0.12ms (-15.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.33ms | 3.48ms | -1.15ms (-33.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.20ms | 4.21ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.91ms | 1.98ms | -0.08ms (-3.8%) | 🟡 |
| Worst Frame Build Time Millis | 3.68ms | 3.67ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.20ms | 5.48ms | -0.28ms (-5.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |
| Old Gen Gc Count | 3.0 | 1.5 | +2 (+100.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.14ms | 7.03ms | +0.12ms (+1.6%) | 🟠 |
| Worst Frame Build Time Millis | 25.91ms | 22.52ms | +3.40ms (+15.1%) | 🔴 |
| Missed Frame Build Budget Count | 6.25 | 6.5 | -0 (-3.8%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.64ms | 8.41ms | +0.23ms (+2.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.64ms | 15.00ms | -1.36ms (-9.1%) | 🟢 |
| Worst Frame Build Time Millis | 37.96ms | 47.80ms | -9.84ms (-20.6%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.00ms | 9.38ms | -0.38ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.49ms | 1.55ms | -0.06ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 7.92ms | 9.12ms | -1.20ms (-13.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.69ms | 7.93ms | -0.24ms (-3.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 3.0 | 6.5 | -4 (-53.8%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.81ms | 1.33ms | +0.48ms (+35.9%) | 🔴 |
| Worst Frame Build Time Millis | 7.38ms | 6.79ms | +0.59ms (+8.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.51ms | 6.00ms | +2.51ms (+41.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| New Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.69ms | 5.87ms | -0.18ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 26.26ms | 25.10ms | +1.16ms (+4.6%) | 🟠 |
| Missed Frame Build Budget Count | 3.75 | 4.0 | -0 (-6.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.20ms | 6.37ms | -0.17ms (-2.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.46ms | 24.54ms | -1.08ms (-4.4%) | 🟡 |
| Worst Frame Build Time Millis | 46.22ms | 46.14ms | +0.07ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.32ms | 7.13ms | +0.18ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.38ms | 1.54ms | -0.15ms (-9.9%) | 🟢 |
| Worst Frame Build Time Millis | 20.04ms | 21.46ms | -1.42ms (-6.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 1.5 | -1 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.64ms | 6.59ms | +0.04ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.75 | 2.0 | +1 (+37.5%) | 🔴 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.29ms | -0.08ms (-6.1%) | 🟢 |
| Worst Frame Build Time Millis | 6.79ms | 6.81ms | -0.02ms (-0.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.37ms | 6.49ms | -0.12ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.67ms | 8.21ms | -0.54ms (-6.6%) | 🟢 |
| Worst Frame Build Time Millis | 26.50ms | 30.27ms | -3.77ms (-12.5%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 8.84ms | 9.10ms | -0.25ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.30ms | 1.46ms | -0.16ms (-11.1%) | 🟢 |
| Worst Frame Build Time Millis | 4.75ms | 6.61ms | -1.86ms (-28.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.95ms | 10.90ms | -0.95ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 10.75 | 23.0 | -12 (-53.3%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 1.44ms | -0.33ms (-22.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.79ms | 5.48ms | -1.69ms (-30.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.93ms | 11.49ms | -1.55ms (-13.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.25 | 3.75 | -2 (-40.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.24ms | 4.22ms | +0.02ms (+0.6%) | 🟠 |
| Worst Frame Build Time Millis | 10.43ms | 8.26ms | +2.17ms (+26.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.16ms | 10.35ms | -0.19ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 1.75 | 2.0 | -0 (-12.5%) | 🟢 |

</details>

