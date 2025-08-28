## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 10.9%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 22.9%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 11.3%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 10.4%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.20ms | 4.05ms | +0.15ms (+3.8%) | 🟠 |
| Worst Frame Build Time Millis | 8.29ms | 7.96ms | +0.33ms (+4.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.50ms | 2.50ms | -0.00ms (-0.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.92ms | 5.03ms | -0.11ms (-2.2%) | 🟡 |
| Worst Frame Build Time Millis | 19.09ms | 20.80ms | -1.72ms (-8.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.85ms | 4.01ms | -0.16ms (-4.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.69ms | -0.06ms (-9.2%) | 🟢 |
| Worst Frame Build Time Millis | 3.77ms | 3.69ms | +0.08ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.34ms | 2.76ms | +0.57ms (+20.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.25 | +1 (+400.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.55ms | -0.04ms (-6.6%) | 🟢 |
| Worst Frame Build Time Millis | 3.31ms | 3.43ms | -0.12ms (-3.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.64ms | 3.08ms | -0.44ms (-14.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.38ms | 9.36ms | +1.02ms (+10.9%) | 🔴 |
| Worst Frame Build Time Millis | 29.94ms | 26.64ms | +3.30ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.39ms | 2.65ms | -0.26ms (-9.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.15ms | 7.09ms | +0.06ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 16.85ms | 17.38ms | -0.53ms (-3.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.43ms | 3.40ms | +0.02ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.92ms | 1.99ms | -0.06ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 25.43ms | 26.48ms | -1.05ms (-4.0%) | 🟡 |
| Missed Frame Build Budget Count | 1.75 | 1.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.21ms | 2.93ms | +0.29ms (+9.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.23ms | -0.01ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 2.31ms | 2.32ms | -0.00ms (-0.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.27ms | 2.36ms | -0.09ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.05ms | 3.00ms | +0.06ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 10.67ms | 9.75ms | +0.92ms (+9.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.40ms | 3.60ms | -0.20ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.66ms | -0.02ms (-3.0%) | 🟡 |
| Worst Frame Build Time Millis | 3.09ms | 3.33ms | -0.24ms (-7.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.63ms | 3.29ms | +0.34ms (+10.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.75 | 1.25 | +0 (+40.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.65ms | 0.64ms | +0.01ms (+1.7%) | 🟠 |
| Worst Frame Build Time Millis | 2.85ms | 2.31ms | +0.54ms (+23.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.16ms | 3.17ms | +1.99ms (+62.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.0 | 0.0 | +3 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.94ms | 2.00ms | -0.06ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 4.33ms | 5.74ms | -1.41ms (-24.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.23ms | 4.03ms | +1.21ms (+30.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.47ms | 9.80ms | -0.33ms (-3.3%) | 🟡 |
| Worst Frame Build Time Millis | 28.29ms | 28.00ms | +0.29ms (+1.0%) | 🟠 |
| Missed Frame Build Budget Count | 7.25 | 7.5 | -0 (-3.3%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.73ms | 5.22ms | -0.50ms (-9.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.76ms | 10.84ms | -0.08ms (-0.8%) | 🟡 |
| Worst Frame Build Time Millis | 40.94ms | 40.58ms | +0.36ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 2.75 | 2.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.05ms | 5.01ms | +0.04ms (+0.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.46ms | -0.12ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 12.53ms | 12.79ms | -0.26ms (-2.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.12ms | 4.62ms | -0.50ms (-10.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.64ms | 1.83ms | -0.19ms (-10.4%) | 🟢 |
| Worst Frame Build Time Millis | 13.03ms | 16.87ms | -3.84ms (-22.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.54ms | 8.67ms | -1.13ms (-13.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 1.0 | +3 (+275.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.75ms | 5.91ms | -0.16ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 29.86ms | 27.53ms | +2.32ms (+8.4%) | 🟠 |
| Missed Frame Build Budget Count | 4.5 | 4.75 | -0 (-5.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.10ms | 3.12ms | -0.02ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.36ms | 22.73ms | -1.37ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 41.28ms | 41.83ms | -0.55ms (-1.3%) | 🟡 |
| Missed Frame Build Budget Count | 10.75 | 11.0 | -0 (-2.3%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.08ms | 3.25ms | -0.17ms (-5.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.99ms | 1.05ms | -0.06ms (-5.5%) | 🟢 |
| Worst Frame Build Time Millis | 22.11ms | 22.71ms | -0.60ms (-2.6%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.80ms | 4.28ms | -0.47ms (-11.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.32ms | 2.30ms | +0.02ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 8.85ms | 8.70ms | +0.15ms (+1.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 3.81ms | +0.14ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.88ms | 8.89ms | -0.01ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 41.08ms | 40.79ms | +0.28ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.59ms | 5.54ms | +0.05ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.07ms | 1.20ms | -0.14ms (-11.3%) | 🟢 |
| Worst Frame Build Time Millis | 5.51ms | 7.68ms | -2.17ms (-28.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.12ms | 6.22ms | -0.10ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 5.0 | 7.75 | -3 (-35.5%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.13ms | 1.46ms | -0.33ms (-22.9%) | 🟢 |
| Worst Frame Build Time Millis | 4.43ms | 6.67ms | -2.23ms (-33.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.48ms | 7.80ms | +1.69ms (+21.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.0 | 3.5 | +2 (+42.9%) | 🔴 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.77ms | 1.78ms | -0.00ms (-0.2%) | 🟡 |
| Worst Frame Build Time Millis | 3.80ms | 4.97ms | -1.17ms (-23.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.81ms | 6.25ms | -0.44ms (-7.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

