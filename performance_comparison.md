## 📋 Summary

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 24.5%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 18.6%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 11.9%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 14.0%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.42ms | 2.58ms | -0.16ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 5.86ms | 6.12ms | -0.27ms (-4.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.35ms | 2.44ms | -0.09ms (-3.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.32ms | 4.45ms | -0.13ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 12.90ms | 13.47ms | -0.56ms (-4.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.36ms | 3.53ms | -0.17ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.63ms | -0.02ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 4.25ms | 5.18ms | -0.93ms (-17.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.63ms | 2.96ms | +0.67ms (+22.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.0 | 0.25 | +4 (+1500.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.47ms | 0.57ms | -0.11ms (-18.6%) | 🟢 |
| Worst Frame Build Time Millis | 2.13ms | 3.44ms | -1.31ms (-38.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.45ms | 4.49ms | -2.04ms (-45.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.64ms | 10.38ms | -0.74ms (-7.2%) | 🟢 |
| Worst Frame Build Time Millis | 27.74ms | 29.91ms | -2.18ms (-7.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.85ms | 3.04ms | -0.20ms (-6.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.94ms | 7.26ms | -0.32ms (-4.3%) | 🟡 |
| Worst Frame Build Time Millis | 16.00ms | 16.88ms | -0.88ms (-5.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 0.75 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.10ms | 3.26ms | -0.16ms (-4.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.97ms | 2.01ms | -0.04ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 29.27ms | 27.55ms | +1.72ms (+6.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.74ms | 4.08ms | -0.33ms (-8.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 4.5 | -1 (-22.2%) | 🟢 |
| New Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.70ms | -0.02ms (-2.6%) | 🟡 |
| Worst Frame Build Time Millis | 1.73ms | 1.81ms | -0.07ms (-4.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.51ms | 10.15ms | -0.64ms (-6.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.53ms | 2.64ms | -0.11ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 8.39ms | 8.62ms | -0.23ms (-2.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.73ms | 2.87ms | -0.14ms (-4.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.46ms | 0.49ms | -0.03ms (-5.1%) | 🟢 |
| Worst Frame Build Time Millis | 2.20ms | 2.16ms | +0.04ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.64ms | 2.32ms | +0.33ms (+14.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.46ms | 0.47ms | -0.02ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 1.79ms | 1.83ms | -0.04ms (-2.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.17ms | 2.21ms | -0.04ms (-1.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.68ms | 1.77ms | -0.09ms (-5.1%) | 🟢 |
| Worst Frame Build Time Millis | 3.49ms | 4.38ms | -0.89ms (-20.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.36ms | 4.10ms | +1.26ms (+30.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.87ms | 6.38ms | -0.51ms (-8.0%) | 🟢 |
| Worst Frame Build Time Millis | 21.43ms | 24.90ms | -3.46ms (-13.9%) | 🟢 |
| Missed Frame Build Budget Count | 4.25 | 4.5 | -0 (-5.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.46ms | 4.72ms | -0.26ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.97ms | 11.28ms | -0.31ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 33.09ms | 35.56ms | -2.48ms (-7.0%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.07ms | 4.95ms | +0.12ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.16ms | 1.20ms | -0.04ms (-3.4%) | 🟡 |
| Worst Frame Build Time Millis | 7.68ms | 7.64ms | +0.03ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.96ms | 4.01ms | -0.04ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.05ms | 1.38ms | -0.34ms (-24.5%) | 🟢 |
| Worst Frame Build Time Millis | 5.61ms | 9.63ms | -4.01ms (-41.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.08ms | 7.22ms | +0.85ms (+11.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 3.5 | +1 (+28.6%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.53ms | 5.71ms | -0.18ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 27.13ms | 27.82ms | -0.70ms (-2.5%) | 🟡 |
| Missed Frame Build Budget Count | 4.25 | 4.5 | -0 (-5.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.14ms | 3.27ms | -0.13ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.37ms | 21.28ms | +0.08ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 40.94ms | 39.50ms | +1.44ms (+3.6%) | 🟠 |
| Missed Frame Build Budget Count | 10.5 | 10.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.02ms | 3.23ms | -0.21ms (-6.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 20.0 | -2 (-10.0%) | 🟢 |
| Old Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.95ms | 0.99ms | -0.03ms (-3.5%) | 🟡 |
| Worst Frame Build Time Millis | 20.62ms | 20.83ms | -0.21ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.12ms | 3.60ms | -0.47ms (-13.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 1.19ms | -0.01ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 5.73ms | 6.07ms | -0.34ms (-5.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.78ms | 3.77ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.45ms | 7.60ms | -0.16ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 28.83ms | 30.10ms | -1.27ms (-4.2%) | 🟡 |
| Missed Frame Build Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.82ms | 5.68ms | +0.14ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 0.92ms | -0.11ms (-11.9%) | 🟢 |
| Worst Frame Build Time Millis | 4.79ms | 6.53ms | -1.73ms (-26.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.68ms | 5.83ms | -1.15ms (-19.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.0 | 4.75 | -4 (-78.9%) | 🟢 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.42ms | -0.08ms (-5.8%) | 🟢 |
| Worst Frame Build Time Millis | 9.89ms | 6.44ms | +3.46ms (+53.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.18ms | 12.35ms | -4.17ms (-33.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 9.5 | -6 (-63.2%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.49ms | 1.73ms | -0.24ms (-14.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.27ms | 3.49ms | -0.22ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.72ms | 5.63ms | +0.09ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

