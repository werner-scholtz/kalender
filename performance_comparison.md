## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 8.6%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 13.5%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 10.7%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 11.4%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 16.4%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 11.8%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.04ms | 4.20ms | -0.16ms (-3.8%) | 🟡 |
| Worst Frame Build Time Millis | 7.94ms | 8.29ms | -0.34ms (-4.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.25ms | 2.50ms | -0.25ms (-9.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.51ms | 4.92ms | -0.41ms (-8.4%) | 🟢 |
| Worst Frame Build Time Millis | 17.75ms | 19.09ms | -1.33ms (-7.0%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.81ms | 3.85ms | -0.05ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.63ms | +0.05ms (+8.6%) | 🟠 |
| Worst Frame Build Time Millis | 4.61ms | 3.77ms | +0.83ms (+22.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.82ms | 3.34ms | +1.49ms (+44.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.0 | 1.25 | +5 (+380.0%) | 🔴 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.51ms | -0.01ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 3.15ms | 3.31ms | -0.16ms (-4.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.17ms | 2.64ms | +0.53ms (+20.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.68ms | 10.38ms | -1.71ms (-16.4%) | 🟢 |
| Worst Frame Build Time Millis | 24.79ms | 29.94ms | -5.15ms (-17.2%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.80ms | 2.39ms | +0.41ms (+17.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.61ms | 7.15ms | -0.55ms (-7.7%) | 🟢 |
| Worst Frame Build Time Millis | 12.95ms | 16.85ms | -3.90ms (-23.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.30ms | 3.43ms | -0.12ms (-3.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.18ms | 1.92ms | +0.26ms (+13.5%) | 🔴 |
| Worst Frame Build Time Millis | 29.33ms | 25.43ms | +3.89ms (+15.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.75 | -1 (-42.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.36ms | 3.21ms | +2.14ms (+66.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.0 | 0.0 | +6 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.22ms | +0.00ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 2.32ms | 2.31ms | +0.01ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.09ms | 2.27ms | -0.18ms (-8.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.99ms | 3.05ms | -0.06ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 9.98ms | 10.67ms | -0.69ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.41ms | 3.40ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.64ms | -0.02ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 3.78ms | 3.09ms | +0.69ms (+22.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.94ms | 3.63ms | +0.30ms (+8.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.25 | 1.75 | +2 (+85.7%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.65ms | -0.05ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 2.09ms | 2.85ms | -0.77ms (-26.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.84ms | 5.16ms | -0.32ms (-6.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.87ms | 1.94ms | -0.07ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 3.92ms | 4.33ms | -0.41ms (-9.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.61ms | 5.23ms | -0.63ms (-12.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.66ms | 9.47ms | +0.19ms (+2.0%) | 🟠 |
| Worst Frame Build Time Millis | 28.76ms | 28.29ms | +0.48ms (+1.7%) | 🟠 |
| Missed Frame Build Budget Count | 7.0 | 7.25 | -0 (-3.4%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.00ms | 4.73ms | +0.28ms (+5.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 6.5 | +1 (+15.4%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.22ms | 10.76ms | -0.54ms (-5.0%) | 🟢 |
| Worst Frame Build Time Millis | 42.67ms | 40.94ms | +1.73ms (+4.2%) | 🟠 |
| Missed Frame Build Budget Count | 2.0 | 2.75 | -1 (-27.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.75ms | 5.05ms | -0.30ms (-6.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.48ms | 1.34ms | +0.14ms (+10.7%) | 🔴 |
| Worst Frame Build Time Millis | 18.38ms | 12.53ms | +5.84ms (+46.6%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.33ms | 4.12ms | +2.21ms (+53.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.63ms | 1.64ms | -0.01ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 12.56ms | 13.03ms | -0.48ms (-3.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.58ms | 7.54ms | +2.04ms (+27.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 3.75 | -2 (-60.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.55ms | 5.75ms | -0.19ms (-3.3%) | 🟡 |
| Worst Frame Build Time Millis | 27.81ms | 29.86ms | -2.05ms (-6.9%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 2.99ms | 3.10ms | -0.12ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.55ms | 21.36ms | +0.19ms (+0.9%) | 🟠 |
| Worst Frame Build Time Millis | 42.46ms | 41.28ms | +1.18ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 10.25 | 10.75 | -0 (-4.7%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.96ms | 3.08ms | -0.12ms (-3.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.99ms | 0.99ms | -0.00ms (-0.4%) | 🟡 |
| Worst Frame Build Time Millis | 20.75ms | 22.11ms | -1.36ms (-6.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.12ms | 3.80ms | +2.32ms (+60.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.41ms | 2.32ms | +0.10ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 8.94ms | 8.85ms | +0.09ms (+1.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.99ms | 3.95ms | +0.04ms (+1.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.89ms | 8.88ms | +0.01ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 44.43ms | 41.08ms | +3.36ms (+8.2%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.30ms | 5.59ms | -0.29ms (-5.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 1.07ms | +0.12ms (+11.4%) | 🔴 |
| Worst Frame Build Time Millis | 5.18ms | 5.51ms | -0.33ms (-6.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.41ms | 6.12ms | +2.29ms (+37.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.75 | 5.0 | -2 (-45.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.99ms | 1.13ms | -0.13ms (-11.8%) | 🟢 |
| Worst Frame Build Time Millis | 3.94ms | 4.43ms | -0.50ms (-11.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.76ms | 9.48ms | -2.72ms (-28.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 5.0 | -5 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.66ms | 1.77ms | -0.11ms (-6.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.98ms | 3.80ms | +0.19ms (+4.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.03ms | 5.81ms | +0.22ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

