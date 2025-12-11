## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 24.1%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 15.5%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 7.1%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 10.7%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 11.9%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.61ms | 2.63ms | -0.03ms (-1.0%) | 🟡 |
| Worst Frame Build Time Millis | 6.41ms | 6.41ms | +0.00ms (+0.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.69ms | 3.66ms | +0.02ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.89ms | 4.76ms | +0.13ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 14.88ms | 14.42ms | +0.46ms (+3.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.14ms | 4.94ms | +0.19ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.75ms | +0.05ms (+7.1%) | 🟠 |
| Worst Frame Build Time Millis | 5.24ms | 4.84ms | +0.40ms (+8.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.68ms | 6.42ms | -0.73ms (-11.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 3.25 | -3 (-92.3%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.50ms | +0.05ms (+10.7%) | 🔴 |
| Worst Frame Build Time Millis | 3.72ms | 2.30ms | +1.42ms (+62.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.10ms | 5.69ms | -0.58ms (-10.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.35ms | 8.34ms | +2.01ms (+24.1%) | 🔴 |
| Worst Frame Build Time Millis | 29.61ms | 23.79ms | +5.82ms (+24.5%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.48ms | 4.30ms | +0.18ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.70ms | 6.76ms | -0.06ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 14.48ms | 14.15ms | +0.33ms (+2.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.33ms | 5.32ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.33ms | 2.44ms | -0.11ms (-4.7%) | 🟡 |
| Worst Frame Build Time Millis | 28.37ms | 34.61ms | -6.24ms (-18.0%) | 🟢 |
| Missed Frame Build Budget Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.28ms | 7.16ms | -0.88ms (-12.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 3.5 | -2 (-57.1%) | 🟢 |
| New Gen Gc Count | 8.0 | 6.5 | +2 (+23.1%) | 🔴 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.70ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 1.85ms | 1.85ms | -0.01ms (-0.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.73ms | 14.03ms | +0.70ms (+5.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.59ms | 2.63ms | -0.04ms (-1.6%) | 🟡 |
| Worst Frame Build Time Millis | 8.81ms | 8.76ms | +0.05ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.87ms | 3.98ms | -0.11ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.68ms | +0.00ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 4.57ms | 3.23ms | +1.33ms (+41.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.59ms | 5.83ms | -0.24ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 4.25 | 0.25 | +4 (+1600.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.59ms | +0.01ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 3.56ms | 2.47ms | +1.09ms (+44.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.52ms | 5.25ms | -0.73ms (-13.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.12ms | 1.83ms | +0.28ms (+15.5%) | 🔴 |
| Worst Frame Build Time Millis | 6.06ms | 4.30ms | +1.76ms (+40.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.54ms | 6.07ms | -0.52ms (-8.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.60ms | 6.51ms | +0.08ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 23.91ms | 24.66ms | -0.74ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 6.5 | 6.25 | +0 (+4.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 6.63ms | 6.56ms | +0.07ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.62ms | 11.39ms | -0.77ms (-6.7%) | 🟢 |
| Worst Frame Build Time Millis | 31.87ms | 37.20ms | -5.33ms (-14.3%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.25 | -0 (-7.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.86ms | 6.87ms | -0.01ms (-0.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.63ms | 1.71ms | -0.08ms (-4.4%) | 🟡 |
| Worst Frame Build Time Millis | 10.01ms | 11.60ms | -1.59ms (-13.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.78ms | 9.39ms | -1.62ms (-17.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.75 | 10.0 | -9 (-92.5%) | 🟢 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 1.0 | 3.0 | -2 (-66.7%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.32ms | 1.18ms | +0.14ms (+11.9%) | 🔴 |
| Worst Frame Build Time Millis | 11.03ms | 7.43ms | +3.60ms (+48.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.35ms | 7.34ms | +2.01ms (+27.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 0.0 | +4 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.81ms | 6.35ms | -0.53ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 29.31ms | 32.71ms | -3.39ms (-10.4%) | 🟢 |
| Missed Frame Build Budget Count | 4.25 | 4.5 | -0 (-5.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.07ms | 5.25ms | -0.18ms (-3.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.40ms | 23.14ms | -1.74ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 41.11ms | 43.30ms | -2.19ms (-5.1%) | 🟢 |
| Missed Frame Build Budget Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.34ms | 5.86ms | -0.52ms (-8.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 17.0 | 16.0 | +1 (+6.2%) | 🟠 |
| Old Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.96ms | 0.97ms | -0.01ms (-0.7%) | 🟡 |
| Worst Frame Build Time Millis | 18.65ms | 17.82ms | +0.83ms (+4.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.15ms | 9.42ms | -1.27ms (-13.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.75 | 15.75 | -11 (-69.8%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.41ms | -0.08ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 6.77ms | 6.89ms | -0.12ms (-1.8%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.53ms | 5.55ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.08ms | 6.99ms | +0.09ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 29.28ms | 30.18ms | -0.89ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 2.25 | 1.5 | +1 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.69ms | 7.75ms | -0.06ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.30ms | 1.24ms | +0.06ms (+4.5%) | 🟠 |
| Worst Frame Build Time Millis | 7.68ms | 6.38ms | +1.30ms (+20.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.64ms | 9.75ms | -1.11ms (-11.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.5 | 9.0 | -6 (-72.2%) | 🟢 |
| New Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.12ms | 1.19ms | -0.06ms (-5.4%) | 🟢 |
| Worst Frame Build Time Millis | 6.28ms | 6.76ms | -0.48ms (-7.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.89ms | 9.27ms | -1.39ms (-14.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.56ms | 1.66ms | -0.09ms (-5.6%) | 🟢 |
| Worst Frame Build Time Millis | 2.79ms | 3.78ms | -0.99ms (-26.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.80ms | 8.67ms | +0.14ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

</details>

