## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 15.9%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 20.5%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 17.9%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 6.3%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 10.4%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 11.4%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 6.5%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 7.4%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 7.3%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 6.2%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 8.8%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 7.6%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 21.4%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.61ms | 2.45ms | +0.16ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 6.21ms | 6.00ms | +0.20ms (+3.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.69ms | 2.44ms | +0.25ms (+10.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.70ms | 4.31ms | +0.38ms (+8.8%) | 🟠 |
| Worst Frame Build Time Millis | 15.74ms | 12.76ms | +2.98ms (+23.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.43ms | 3.26ms | +0.18ms (+5.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.67ms | +0.03ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 3.49ms | 4.50ms | -1.00ms (-22.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.41ms | 5.20ms | +0.21ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 6.0 | 1.75 | +4 (+242.9%) | 🔴 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.51ms | -0.03ms (-5.6%) | 🟢 |
| Worst Frame Build Time Millis | 1.94ms | 2.73ms | -0.80ms (-29.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.60ms | 5.22ms | -1.62ms (-31.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.43ms | 9.36ms | +0.06ms (+0.7%) | 🟠 |
| Worst Frame Build Time Millis | 26.83ms | 26.92ms | -0.08ms (-0.3%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.77ms | 3.20ms | -0.43ms (-13.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.29ms | 6.79ms | +0.50ms (+7.4%) | 🟠 |
| Worst Frame Build Time Millis | 17.56ms | 15.14ms | +2.42ms (+16.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.42ms | 3.00ms | +0.43ms (+14.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.75 | +0 (+9.1%) | 🟠 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.12ms | 2.05ms | +0.06ms (+3.1%) | 🟠 |
| Worst Frame Build Time Millis | 28.03ms | 25.33ms | +2.70ms (+10.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.03ms | 4.55ms | +0.48ms (+10.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |
| New Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.61ms | +0.10ms (+15.9%) | 🔴 |
| Worst Frame Build Time Millis | 1.87ms | 1.60ms | +0.27ms (+16.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.19ms | 9.24ms | +0.95ms (+10.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.59ms | 2.52ms | +0.07ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 8.46ms | 8.24ms | +0.21ms (+2.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.76ms | 2.61ms | +0.15ms (+5.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.49ms | +0.06ms (+11.4%) | 🔴 |
| Worst Frame Build Time Millis | 2.56ms | 2.47ms | +0.08ms (+3.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.27ms | 3.92ms | -0.65ms (-16.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.52ms | +0.11ms (+20.5%) | 🔴 |
| Worst Frame Build Time Millis | 2.80ms | 2.09ms | +0.71ms (+33.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.39ms | 3.87ms | +0.52ms (+13.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.07ms | 1.99ms | +0.08ms (+3.9%) | 🟠 |
| Worst Frame Build Time Millis | 4.10ms | 5.51ms | -1.41ms (-25.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.63ms | 5.07ms | -0.43ms (-8.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.07ms | 5.89ms | +0.18ms (+3.0%) | 🟠 |
| Worst Frame Build Time Millis | 22.87ms | 21.03ms | +1.84ms (+8.8%) | 🟠 |
| Missed Frame Build Budget Count | 5.75 | 4.75 | +1 (+21.1%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.54ms | 4.22ms | +0.31ms (+7.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |
| Old Gen Gc Count | 5.5 | 7.0 | -2 (-21.4%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.11ms | 10.46ms | +0.65ms (+6.2%) | 🟠 |
| Worst Frame Build Time Millis | 35.47ms | 33.89ms | +1.58ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.25 | -0 (-7.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.85ms | 5.01ms | -0.16ms (-3.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.5 | 8.5 | -1 (-11.8%) | 🟢 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.52ms | 1.38ms | +0.14ms (+10.4%) | 🔴 |
| Worst Frame Build Time Millis | 10.12ms | 7.40ms | +2.73ms (+36.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.47ms | 6.71ms | +1.76ms (+26.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 8.5 | 4.5 | +4 (+88.9%) | 🔴 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.49ms | 1.26ms | +0.23ms (+17.9%) | 🔴 |
| Worst Frame Build Time Millis | 8.97ms | 8.08ms | +0.89ms (+11.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 11.83ms | 10.05ms | +1.79ms (+17.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 9.0 | 6.75 | +2 (+33.3%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.84ms | 5.44ms | +0.40ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 29.29ms | 26.47ms | +2.81ms (+10.6%) | 🔴 |
| Missed Frame Build Budget Count | 4.75 | 4.25 | +0 (+11.8%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.12ms | 2.86ms | +0.27ms (+9.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 20.57ms | 21.59ms | -1.02ms (-4.7%) | 🟡 |
| Worst Frame Build Time Millis | 43.67ms | 45.47ms | -1.80ms (-4.0%) | 🟡 |
| Missed Frame Build Budget Count | 10.5 | 9.25 | +1 (+13.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.05ms | 3.07ms | -0.02ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 18.0 | +2 (+11.1%) | 🔴 |
| Old Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.02ms | 1.01ms | +0.01ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 22.01ms | 20.65ms | +1.36ms (+6.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.96ms | 5.06ms | +0.90ms (+17.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 1.12ms | +0.07ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 6.30ms | 5.58ms | +0.72ms (+12.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.83ms | 3.50ms | +0.33ms (+9.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.70ms | 7.16ms | +0.54ms (+7.6%) | 🟠 |
| Worst Frame Build Time Millis | 27.16ms | 28.42ms | -1.26ms (-4.4%) | 🟡 |
| Missed Frame Build Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.53ms | 5.14ms | +0.39ms (+7.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 6.5 | 5.0 | +2 (+30.0%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.02ms | 0.99ms | +0.03ms (+3.1%) | 🟠 |
| Worst Frame Build Time Millis | 4.14ms | 5.51ms | -1.37ms (-24.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.15ms | 6.80ms | +2.35ms (+34.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.5 | -1 (-50.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 1.32ms | -0.28ms (-21.4%) | 🟢 |
| Worst Frame Build Time Millis | 4.54ms | 7.04ms | -2.50ms (-35.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.14ms | 8.96ms | +0.18ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 3.75 | -3 (-73.3%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.75ms | 1.68ms | +0.08ms (+4.5%) | 🟠 |
| Worst Frame Build Time Millis | 3.11ms | 4.06ms | -0.95ms (-23.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.31ms | 6.68ms | -0.37ms (-5.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>

