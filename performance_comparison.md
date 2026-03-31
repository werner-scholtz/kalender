## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 9.7%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 7.8%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 11.7%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 11.7%
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 12.3%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 22.3%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 25.9%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 25.9%
- 🟢 **ten_events_per_day-schedule-rescheduling**: Frame build time improved by 23.4%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 13.5%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.79ms | 3.16ms | -0.37ms (-11.7%) | 🟢 |
| Worst Frame Build Time Millis | 6.76ms | 7.68ms | -0.93ms (-12.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.57ms | 4.97ms | -0.40ms (-8.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.31ms | 5.54ms | -0.23ms (-4.2%) | 🟡 |
| Worst Frame Build Time Millis | 18.03ms | 18.16ms | -0.13ms (-0.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.56ms | 5.90ms | -0.34ms (-5.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 0.80ms | +0.02ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 3.68ms | 3.17ms | +0.51ms (+15.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.54ms | 4.89ms | +0.65ms (+13.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.0 | 0.25 | +2 (+700.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.80ms | -0.18ms (-22.3%) | 🟢 |
| Worst Frame Build Time Millis | 2.08ms | 2.69ms | -0.61ms (-22.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.29ms | 5.51ms | -1.22ms (-22.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.94ms | 13.17ms | -1.23ms (-9.3%) | 🟢 |
| Worst Frame Build Time Millis | 32.10ms | 37.46ms | -5.36ms (-14.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.26ms | 6.02ms | -0.76ms (-12.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.37ms | 7.76ms | +0.61ms (+7.8%) | 🟠 |
| Worst Frame Build Time Millis | 17.38ms | 14.72ms | +2.66ms (+18.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.77ms | 6.77ms | -0.00ms (-0.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.50ms | 2.28ms | +0.22ms (+9.7%) | 🟠 |
| Worst Frame Build Time Millis | 27.46ms | 28.85ms | -1.39ms (-4.8%) | 🟡 |
| Missed Frame Build Budget Count | 1.75 | 1.5 | +0 (+16.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.55ms | 6.30ms | +0.24ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.84ms | -0.10ms (-12.3%) | 🟢 |
| Worst Frame Build Time Millis | 1.95ms | 2.20ms | -0.25ms (-11.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 4.71ms | -0.76ms (-16.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.06ms | 3.34ms | -0.28ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 9.91ms | 10.27ms | -0.36ms (-3.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.32ms | 4.66ms | -0.34ms (-7.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.87ms | -0.12ms (-13.5%) | 🟢 |
| Worst Frame Build Time Millis | 5.02ms | 4.75ms | +0.27ms (+5.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.36ms | 4.47ms | -0.11ms (-2.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.81ms | -0.21ms (-25.9%) | 🟢 |
| Worst Frame Build Time Millis | 2.17ms | 3.39ms | -1.22ms (-35.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.04ms | 4.48ms | -0.44ms (-9.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.10ms | 2.33ms | -0.23ms (-9.7%) | 🟢 |
| Worst Frame Build Time Millis | 4.11ms | 4.27ms | -0.16ms (-3.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.98ms | 5.99ms | -0.02ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.67ms | 7.76ms | -0.09ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 29.33ms | 25.14ms | +4.18ms (+16.6%) | 🔴 |
| Missed Frame Build Budget Count | 6.5 | 6.75 | -0 (-3.7%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.81ms | 8.76ms | +0.05ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |
| Old Gen Gc Count | 6.0 | 4.0 | +2 (+50.0%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.46ms | 14.52ms | -0.07ms (-0.5%) | 🟡 |
| Worst Frame Build Time Millis | 43.15ms | 41.48ms | +1.67ms (+4.0%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.20ms | 8.90ms | +0.30ms (+3.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.44ms | 1.58ms | -0.14ms (-8.6%) | 🟢 |
| Worst Frame Build Time Millis | 8.74ms | 8.47ms | +0.27ms (+3.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.13ms | 7.62ms | +0.51ms (+6.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.32ms | 1.42ms | -0.10ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 6.58ms | 6.34ms | +0.25ms (+3.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.29ms | 6.04ms | +0.25ms (+4.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.86ms | 5.99ms | -0.12ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 29.52ms | 28.82ms | +0.69ms (+2.4%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.74ms | 6.83ms | -0.10ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.02ms | 24.40ms | +0.62ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 46.83ms | 47.43ms | -0.60ms (-1.3%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.76ms | 7.47ms | +0.29ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 15.0 | -1 (-6.7%) | 🟢 |
| Old Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.57ms | -0.37ms (-23.4%) | 🟢 |
| Worst Frame Build Time Millis | 17.25ms | 17.53ms | -0.28ms (-1.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.75 | 1.5 | -1 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.57ms | 6.60ms | -0.03ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.29ms | 1.37ms | -0.08ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 6.70ms | 7.02ms | -0.32ms (-4.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.82ms | 7.10ms | -0.28ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.25ms | 8.32ms | -0.07ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 27.94ms | 29.91ms | -1.96ms (-6.6%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.59ms | 9.68ms | -0.09ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.30ms | 1.39ms | -0.09ms (-6.3%) | 🟢 |
| Worst Frame Build Time Millis | 6.44ms | 6.31ms | +0.13ms (+2.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.27ms | 10.70ms | +0.57ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 24.75 | 20.5 | +4 (+20.7%) | 🔴 |
| New Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.76ms | 1.58ms | +0.18ms (+11.7%) | 🔴 |
| Worst Frame Build Time Millis | 9.11ms | 8.38ms | +0.73ms (+8.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 13.54ms | 10.54ms | +3.01ms (+28.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 2.0 | +2 (+125.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.95ms | 3.98ms | -1.03ms (-25.9%) | 🟢 |
| Worst Frame Build Time Millis | 5.51ms | 6.22ms | -0.71ms (-11.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.35ms | 10.41ms | -1.06ms (-10.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

