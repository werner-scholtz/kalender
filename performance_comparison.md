## 📋 Summary

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 13.8%
- 🟢 **ten_events_per_day-week-navigation**: Frame build time improved by 13.2%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 21.9%
- 🟢 **one_event_per_day-schedule-navigation**: Frame build time improved by 12.9%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 14.9%
- 🟢 **ten_events_per_day-schedule-navigation**: Frame build time improved by 11.1%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 25.0%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 15.5%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 14.0%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 10.6%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 15.9%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 21.0%
- 🟢 **one_event_per_day-month-navigation**: Frame build time improved by 15.0%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 18.3%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 12.1%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 14.5%
- 🟢 **one_event_per_day-week-navigation**: Frame build time improved by 14.1%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.80ms | 2.96ms | -0.15ms (-5.2%) | 🟢 |
| Worst Frame Build Time Millis | 7.05ms | 7.27ms | -0.22ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.33ms | 4.25ms | +0.09ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.60ms | 5.41ms | -0.81ms (-15.0%) | 🟢 |
| Worst Frame Build Time Millis | 18.81ms | 21.19ms | -2.39ms (-11.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.02ms | 5.09ms | -0.07ms (-1.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.58ms | +0.01ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 3.12ms | 2.78ms | +0.34ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.55ms | 4.85ms | -0.31ms (-6.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| New Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.42ms | 0.48ms | -0.06ms (-12.1%) | 🟢 |
| Worst Frame Build Time Millis | 1.94ms | 2.28ms | -0.35ms (-15.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 4.88ms | -0.93ms (-19.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.94ms | 9.29ms | -1.34ms (-14.5%) | 🟢 |
| Worst Frame Build Time Millis | 22.73ms | 26.54ms | -3.81ms (-14.4%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.82ms | 3.92ms | +0.90ms (+23.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.82ms | 6.69ms | -0.86ms (-12.9%) | 🟢 |
| Worst Frame Build Time Millis | 12.14ms | 13.76ms | -1.62ms (-11.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.12ms | 5.32ms | -0.19ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.86ms | 2.21ms | -0.35ms (-15.9%) | 🟢 |
| Worst Frame Build Time Millis | 31.09ms | 27.00ms | +4.09ms (+15.1%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.11ms | 7.36ms | -2.25ms (-30.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 7.5 | -7 (-96.7%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.73ms | -0.11ms (-15.5%) | 🟢 |
| Worst Frame Build Time Millis | 1.52ms | 1.88ms | -0.36ms (-19.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 13.14ms | 14.45ms | -1.32ms (-9.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.46ms | 2.86ms | -0.41ms (-14.1%) | 🟢 |
| Worst Frame Build Time Millis | 8.38ms | 9.45ms | -1.07ms (-11.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.91ms | 3.94ms | -0.03ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.54ms | 0.63ms | -0.09ms (-14.9%) | 🟢 |
| Worst Frame Build Time Millis | 2.23ms | 3.56ms | -1.33ms (-37.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.89ms | 5.22ms | -1.33ms (-25.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 2.25 | -2 (-88.9%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.50ms | -0.02ms (-4.6%) | 🟡 |
| Worst Frame Build Time Millis | 1.83ms | 1.89ms | -0.06ms (-3.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.60ms | 3.54ms | +0.06ms (+1.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.80ms | 2.01ms | -0.21ms (-10.6%) | 🟢 |
| Worst Frame Build Time Millis | 3.95ms | 5.76ms | -1.81ms (-31.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.84ms | 6.22ms | -0.39ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.65ms | 8.87ms | -2.21ms (-25.0%) | 🟢 |
| Worst Frame Build Time Millis | 28.32ms | 41.00ms | -12.68ms (-30.9%) | 🟢 |
| Missed Frame Build Budget Count | 5.5 | 7.0 | -2 (-21.4%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.25ms | 7.32ms | -0.07ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 13.5 | -2 (-11.1%) | 🟢 |
| Old Gen Gc Count | 7.5 | 8.5 | -1 (-11.8%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.78ms | 14.80ms | -1.03ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 48.19ms | 45.17ms | +3.02ms (+6.7%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.53ms | 7.18ms | +0.35ms (+4.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.57ms | -0.29ms (-18.3%) | 🟢 |
| Worst Frame Build Time Millis | 10.21ms | 15.53ms | -5.32ms (-34.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.38ms | 9.80ms | -2.42ms (-24.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 5.75 | 13.0 | -7 (-55.8%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 1.52ms | -0.32ms (-21.0%) | 🟢 |
| Worst Frame Build Time Millis | 7.77ms | 11.99ms | -4.22ms (-35.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.07ms | 9.32ms | +0.75ms (+8.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 5.25 | 1.75 | +4 (+200.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.25ms | 6.11ms | -0.86ms (-14.0%) | 🟢 |
| Worst Frame Build Time Millis | 30.80ms | 35.61ms | -4.81ms (-13.5%) | 🟢 |
| Missed Frame Build Budget Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.45ms | 5.34ms | +0.11ms (+2.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 19.0 | +1 (+5.3%) | 🟠 |
| Old Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.35ms | 24.01ms | -2.66ms (-11.1%) | 🟢 |
| Worst Frame Build Time Millis | 43.15ms | 38.98ms | +4.17ms (+10.7%) | 🔴 |
| Missed Frame Build Budget Count | 8.25 | 10.5 | -2 (-21.4%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.04ms | 5.57ms | +0.47ms (+8.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.5 | 16.0 | +4 (+21.9%) | 🔴 |
| Old Gen Gc Count | 10.5 | 9.0 | +2 (+16.7%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.94ms | 0.92ms | +0.02ms (+1.7%) | 🟠 |
| Worst Frame Build Time Millis | 18.66ms | 21.20ms | -2.55ms (-12.0%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.09ms | 6.76ms | -0.67ms (-9.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 5.75 | 9.25 | -4 (-37.8%) | 🟢 |
| New Gen Gc Count | 6.5 | 8.0 | -2 (-18.8%) | 🟢 |
| Old Gen Gc Count | 5.5 | 4.25 | +1 (+29.4%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.42ms | -0.20ms (-13.8%) | 🟢 |
| Worst Frame Build Time Millis | 6.40ms | 6.98ms | -0.58ms (-8.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.78ms | 5.77ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.22ms | 8.32ms | -1.09ms (-13.2%) | 🟢 |
| Worst Frame Build Time Millis | 27.55ms | 34.73ms | -7.19ms (-20.7%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.61ms | 7.58ms | +0.03ms (+0.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |
| Old Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.10ms | 1.22ms | -0.12ms (-9.8%) | 🟢 |
| Worst Frame Build Time Millis | 11.55ms | 9.20ms | +2.35ms (+25.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.35ms | 10.91ms | -1.55ms (-14.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 14.75 | 18.0 | -3 (-18.1%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.91ms | -0.20ms (-21.9%) | 🟢 |
| Worst Frame Build Time Millis | 2.49ms | 4.88ms | -2.40ms (-49.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.60ms | 7.69ms | -1.08ms (-14.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.62ms | 1.79ms | -0.17ms (-9.3%) | 🟢 |
| Worst Frame Build Time Millis | 5.47ms | 4.93ms | +0.54ms (+11.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.73ms | 9.67ms | -0.94ms (-9.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

