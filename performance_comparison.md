## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 16.1%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-week-loadingEvents**: Frame build time improved by 10.1%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 10.2%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.08ms | 4.10ms | -0.02ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 8.03ms | 8.07ms | -0.04ms (-0.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.42ms | 2.71ms | -0.30ms (-11.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.64ms | 4.81ms | -0.17ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 18.06ms | 18.81ms | -0.75ms (-4.0%) | 🟡 |
| Missed Frame Build Budget Count | 1.25 | 1.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.82ms | 3.91ms | -0.09ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.60ms | 0.64ms | -0.05ms (-7.2%) | 🟢 |
| Worst Frame Build Time Millis | 4.01ms | 5.17ms | -1.16ms (-22.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.05ms | 2.70ms | +0.35ms (+13.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.25 | +1 (+400.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.49ms | +0.02ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 3.18ms | 3.19ms | -0.01ms (-0.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.86ms | 2.60ms | +1.27ms (+48.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.55ms | 9.16ms | -0.61ms (-6.6%) | 🟢 |
| Worst Frame Build Time Millis | 24.47ms | 26.20ms | -1.73ms (-6.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.64ms | 2.67ms | -0.03ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.49ms | 7.01ms | -0.52ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 14.02ms | 15.73ms | -1.71ms (-10.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.23ms | 3.50ms | -0.27ms (-7.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.97ms | 1.99ms | -0.02ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 28.63ms | 28.56ms | +0.07ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 1.5 | -0 (-16.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.48ms | 3.15ms | +1.33ms (+42.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.0 | 1.0 | +4 (+400.0%) | 🔴 |
| New Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.16ms | 1.29ms | -0.13ms (-10.1%) | 🟢 |
| Worst Frame Build Time Millis | 2.18ms | 2.43ms | -0.25ms (-10.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.19ms | 2.18ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.96ms | 2.99ms | -0.04ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 10.30ms | 9.84ms | +0.46ms (+4.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.47ms | 3.51ms | -0.04ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.67ms | -0.06ms (-9.0%) | 🟢 |
| Worst Frame Build Time Millis | 3.24ms | 3.51ms | -0.27ms (-7.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.89ms | 3.15ms | +0.74ms (+23.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.25 | 0.75 | +2 (+333.3%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.59ms | -0.00ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 2.34ms | 2.01ms | +0.34ms (+16.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.40ms | 3.71ms | -1.31ms (-35.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.96ms | 1.69ms | +0.27ms (+16.1%) | 🔴 |
| Worst Frame Build Time Millis | 4.46ms | 2.96ms | +1.50ms (+50.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.43ms | 3.73ms | +1.71ms (+45.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.68ms | 9.87ms | -0.19ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 27.72ms | 29.35ms | -1.64ms (-5.6%) | 🟢 |
| Missed Frame Build Budget Count | 7.25 | 7.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.97ms | 5.01ms | -0.03ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.5 | -0 (-4.8%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.73ms | 11.68ms | -0.95ms (-8.2%) | 🟢 |
| Worst Frame Build Time Millis | 38.96ms | 53.08ms | -14.13ms (-26.6%) | 🟢 |
| Missed Frame Build Budget Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.11ms | 4.71ms | +0.41ms (+8.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |
| Old Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.27ms | 1.42ms | -0.14ms (-10.2%) | 🟢 |
| Worst Frame Build Time Millis | 11.79ms | 13.71ms | -1.93ms (-14.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 4.09ms | -0.13ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.59ms | 1.71ms | -0.12ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 15.40ms | 14.84ms | +0.56ms (+3.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.45ms | 6.67ms | +1.78ms (+26.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 1.5 | +2 (+133.3%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.50ms | 5.85ms | -0.35ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 25.62ms | 27.39ms | -1.77ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 4.25 | 4.5 | -0 (-5.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.06ms | 3.20ms | -0.13ms (-4.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 13.0 | -1 (-7.7%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.5 | -1 (-15.4%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.19ms | 22.07ms | -0.88ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 41.62ms | 46.35ms | -4.73ms (-10.2%) | 🟢 |
| Missed Frame Build Budget Count | 10.25 | 10.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.06ms | 3.04ms | +0.02ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 19.0 | -1 (-5.3%) | 🟢 |
| Old Gen Gc Count | 9.0 | 10.0 | -1 (-10.0%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.94ms | 0.96ms | -0.02ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 20.22ms | 18.12ms | +2.10ms (+11.6%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.49ms | 3.37ms | +0.12ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.18ms | 2.27ms | -0.09ms (-3.9%) | 🟡 |
| Worst Frame Build Time Millis | 8.20ms | 9.29ms | -1.10ms (-11.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.77ms | 3.83ms | -0.07ms (-1.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.54ms | 8.61ms | -0.07ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 39.55ms | 37.42ms | +2.13ms (+5.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.57ms | 5.48ms | +0.09ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.01ms | 1.03ms | -0.02ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 6.33ms | 5.96ms | +0.37ms (+6.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.20ms | 5.94ms | -0.74ms (-12.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 6.25 | -4 (-72.0%) | 🟢 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.18ms | 1.15ms | +0.03ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 6.05ms | 5.63ms | +0.42ms (+7.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.12ms | 6.27ms | +1.84ms (+29.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.0 | 0.25 | +5 (+1900.0%) | 🔴 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.63ms | 1.58ms | +0.05ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 3.33ms | 2.62ms | +0.71ms (+27.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.72ms | 5.96ms | -0.24ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>

