## 📋 Summary

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 27.4%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 15.3%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 26.8%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 19.5%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 12.6%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 31.2%
- 🟢 **ten_events_per_day-month-navigation**: Frame build time improved by 11.4%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 12.3%
- 🟢 **one_event_per_day-month-navigation**: Frame build time improved by 10.1%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 17.4%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 10.1%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 27.2%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.10ms | 4.41ms | -0.30ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 8.07ms | 8.64ms | -0.57ms (-6.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.71ms | 1.96ms | +0.76ms (+38.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.81ms | 5.35ms | -0.54ms (-10.1%) | 🟢 |
| Worst Frame Build Time Millis | 18.81ms | 19.00ms | -0.19ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.91ms | 4.18ms | -0.27ms (-6.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.88ms | -0.24ms (-27.2%) | 🟢 |
| Worst Frame Build Time Millis | 5.17ms | 7.37ms | -2.19ms (-29.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.70ms | 3.60ms | -0.91ms (-25.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.67ms | -0.18ms (-26.8%) | 🟢 |
| Worst Frame Build Time Millis | 3.19ms | 5.60ms | -2.41ms (-43.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.60ms | 3.68ms | -1.08ms (-29.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.16ms | 13.31ms | -4.16ms (-31.2%) | 🟢 |
| Worst Frame Build Time Millis | 26.20ms | 38.77ms | -12.57ms (-32.4%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.67ms | 2.83ms | -0.16ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.01ms | 6.91ms | +0.10ms (+1.4%) | 🟠 |
| Worst Frame Build Time Millis | 15.73ms | 13.78ms | +1.95ms (+14.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.50ms | 3.58ms | -0.09ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.99ms | 1.94ms | +0.05ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 28.56ms | 24.34ms | +4.23ms (+17.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.15ms | 3.58ms | -0.43ms (-12.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.33ms | -0.03ms (-2.6%) | 🟡 |
| Worst Frame Build Time Millis | 2.43ms | 2.51ms | -0.07ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.18ms | 2.70ms | -0.52ms (-19.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.99ms | 3.29ms | -0.29ms (-9.0%) | 🟢 |
| Worst Frame Build Time Millis | 9.84ms | 11.73ms | -1.88ms (-16.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.51ms | 3.87ms | -0.36ms (-9.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.71ms | -0.04ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.51ms | 4.07ms | -0.57ms (-13.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.15ms | 3.55ms | -0.41ms (-11.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.71ms | -0.12ms (-17.4%) | 🟢 |
| Worst Frame Build Time Millis | 2.01ms | 3.60ms | -1.59ms (-44.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.71ms | 4.30ms | -0.59ms (-13.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.69ms | 2.10ms | -0.41ms (-19.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.96ms | 4.33ms | -1.37ms (-31.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.73ms | 4.38ms | -0.66ms (-15.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.87ms | 10.98ms | -1.11ms (-10.1%) | 🟢 |
| Worst Frame Build Time Millis | 29.35ms | 31.82ms | -2.47ms (-7.8%) | 🟢 |
| Missed Frame Build Budget Count | 7.25 | 8.0 | -1 (-9.4%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.01ms | 5.24ms | -0.23ms (-4.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.0 | +0 (+5.0%) | 🟠 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.68ms | 13.19ms | -1.50ms (-11.4%) | 🟢 |
| Worst Frame Build Time Millis | 53.08ms | 43.81ms | +9.27ms (+21.2%) | 🔴 |
| Missed Frame Build Budget Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.71ms | 5.24ms | -0.53ms (-10.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |
| Old Gen Gc Count | 4.5 | 6.0 | -2 (-25.0%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.95ms | -0.53ms (-27.4%) | 🟢 |
| Worst Frame Build Time Millis | 13.71ms | 15.71ms | -2.00ms (-12.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.09ms | 6.56ms | -2.47ms (-37.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 5.25 | -5 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 3.5 | -2 (-57.1%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.71ms | 2.02ms | -0.31ms (-15.3%) | 🟢 |
| Worst Frame Build Time Millis | 14.84ms | 18.44ms | -3.59ms (-19.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.67ms | 6.69ms | -0.02ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.85ms | 5.74ms | +0.11ms (+2.0%) | 🟠 |
| Worst Frame Build Time Millis | 27.39ms | 27.39ms | -0.00ms (-0.0%) | 🟡 |
| Missed Frame Build Budget Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.20ms | 3.64ms | -0.44ms (-12.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 13.0 | 14.0 | -1 (-7.1%) | 🟢 |
| Old Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.07ms | 21.41ms | +0.66ms (+3.1%) | 🟠 |
| Worst Frame Build Time Millis | 46.35ms | 42.61ms | +3.75ms (+8.8%) | 🟠 |
| Missed Frame Build Budget Count | 10.25 | 10.5 | -0 (-2.4%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.04ms | 3.34ms | -0.30ms (-8.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 20.0 | -1 (-5.0%) | 🟢 |
| Old Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.96ms | 1.10ms | -0.13ms (-12.3%) | 🟢 |
| Worst Frame Build Time Millis | 18.12ms | 23.07ms | -4.95ms (-21.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.37ms | 5.25ms | -1.87ms (-35.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.27ms | 2.31ms | -0.04ms (-1.8%) | 🟡 |
| Worst Frame Build Time Millis | 9.29ms | 8.95ms | +0.35ms (+3.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.83ms | 3.92ms | -0.08ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.61ms | 9.21ms | -0.60ms (-6.6%) | 🟢 |
| Worst Frame Build Time Millis | 37.42ms | 38.38ms | -0.96ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.48ms | 5.87ms | -0.39ms (-6.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 10.0 | +2 (+20.0%) | 🔴 |
| Old Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 1.17ms | -0.15ms (-12.6%) | 🟢 |
| Worst Frame Build Time Millis | 5.96ms | 6.22ms | -0.26ms (-4.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.94ms | 5.91ms | +0.03ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 6.25 | 3.5 | +3 (+78.6%) | 🔴 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.15ms | 1.24ms | -0.09ms (-7.3%) | 🟢 |
| Worst Frame Build Time Millis | 5.63ms | 5.96ms | -0.33ms (-5.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.27ms | 7.83ms | -1.56ms (-19.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 3.5 | -3 (-92.9%) | 🟢 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.58ms | 1.71ms | -0.13ms (-7.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.62ms | 3.24ms | -0.62ms (-19.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.96ms | 6.16ms | -0.21ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

</details>

