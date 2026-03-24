## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 42.6%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 32.2%
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 24.6%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 26.0%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 15.5%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 41.5%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 22.0%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 25.5%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 5.6%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 6.8%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 5.5%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.1%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 8.6%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 13.5%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 6.5%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 13.7%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 8.5%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 21.2%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.16ms | 2.52ms | +0.64ms (+25.5%) | 🔴 |
| Worst Frame Build Time Millis | 7.68ms | 6.18ms | +1.51ms (+24.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.97ms | 3.66ms | +1.30ms (+35.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.54ms | 5.25ms | +0.29ms (+5.6%) | 🟠 |
| Worst Frame Build Time Millis | 18.16ms | 18.56ms | -0.40ms (-2.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.90ms | 5.43ms | +0.47ms (+8.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 4.5 | +0 (+11.1%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.80ms | -0.00ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 3.17ms | 3.51ms | -0.34ms (-9.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.89ms | 4.98ms | -0.09ms (-1.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.25 | -1 (-80.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.56ms | +0.24ms (+42.6%) | 🔴 |
| Worst Frame Build Time Millis | 2.69ms | 2.01ms | +0.69ms (+34.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.51ms | 3.95ms | +1.55ms (+39.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.17ms | 9.96ms | +3.21ms (+32.2%) | 🔴 |
| Worst Frame Build Time Millis | 37.46ms | 28.18ms | +9.28ms (+32.9%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.02ms | 4.52ms | +1.50ms (+33.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.76ms | 7.75ms | +0.01ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 14.72ms | 15.71ms | -0.98ms (-6.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.77ms | 6.48ms | +0.29ms (+4.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.28ms | 2.51ms | -0.23ms (-9.1%) | 🟢 |
| Worst Frame Build Time Millis | 28.85ms | 28.69ms | +0.16ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 1.75 | -0 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.30ms | 5.90ms | +0.40ms (+6.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.84ms | 0.67ms | +0.17ms (+24.6%) | 🔴 |
| Worst Frame Build Time Millis | 2.20ms | 1.75ms | +0.45ms (+25.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.71ms | 3.66ms | +1.04ms (+28.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.34ms | 3.20ms | +0.13ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 10.27ms | 11.75ms | -1.48ms (-12.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.66ms | 4.13ms | +0.53ms (+12.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.87ms | 0.75ms | +0.12ms (+15.5%) | 🔴 |
| Worst Frame Build Time Millis | 4.75ms | 3.94ms | +0.81ms (+20.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.47ms | 4.17ms | +0.31ms (+7.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 0.65ms | +0.17ms (+26.0%) | 🔴 |
| Worst Frame Build Time Millis | 3.39ms | 2.33ms | +1.07ms (+45.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.48ms | 4.20ms | +0.28ms (+6.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.33ms | 1.91ms | +0.42ms (+22.0%) | 🔴 |
| Worst Frame Build Time Millis | 4.27ms | 3.68ms | +0.59ms (+16.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.99ms | 5.20ms | +0.80ms (+15.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.76ms | 7.14ms | +0.62ms (+8.6%) | 🟠 |
| Worst Frame Build Time Millis | 25.14ms | 25.91ms | -0.77ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 6.75 | 6.25 | +0 (+8.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 8.76ms | 8.64ms | +0.13ms (+1.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.52ms | 13.64ms | +0.88ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 41.48ms | 37.96ms | +3.52ms (+9.3%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.90ms | 9.00ms | -0.09ms (-1.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.58ms | 1.49ms | +0.08ms (+5.5%) | 🟠 |
| Worst Frame Build Time Millis | 8.47ms | 7.92ms | +0.55ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.62ms | 7.69ms | -0.07ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 2.0 | -2 (-100.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.81ms | -0.38ms (-21.2%) | 🟢 |
| Worst Frame Build Time Millis | 6.34ms | 7.38ms | -1.04ms (-14.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.04ms | 8.51ms | -2.47ms (-29.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 2.0 | -2 (-87.5%) | 🟢 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.99ms | 5.69ms | +0.29ms (+5.1%) | 🟠 |
| Worst Frame Build Time Millis | 28.82ms | 26.26ms | +2.56ms (+9.8%) | 🟠 |
| Missed Frame Build Budget Count | 4.5 | 3.75 | +1 (+20.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.83ms | 6.20ms | +0.63ms (+10.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.40ms | 23.46ms | +0.94ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 47.43ms | 46.22ms | +1.22ms (+2.6%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.47ms | 7.32ms | +0.16ms (+2.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 15.0 | 14.0 | +1 (+7.1%) | 🟠 |
| Old Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.57ms | 1.38ms | +0.19ms (+13.7%) | 🔴 |
| Worst Frame Build Time Millis | 17.53ms | 20.04ms | -2.51ms (-12.5%) | 🟢 |
| Missed Frame Build Budget Count | 1.5 | 0.75 | +1 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.60ms | 6.64ms | -0.04ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.5 | 2.75 | -2 (-81.8%) | 🟢 |
| New Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.21ms | +0.16ms (+13.5%) | 🔴 |
| Worst Frame Build Time Millis | 7.02ms | 6.79ms | +0.23ms (+3.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.10ms | 6.37ms | +0.73ms (+11.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.32ms | 7.67ms | +0.66ms (+8.5%) | 🟠 |
| Worst Frame Build Time Millis | 29.91ms | 26.50ms | +3.40ms (+12.8%) | 🔴 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.68ms | 8.84ms | +0.84ms (+9.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 7.5 | +0 (+6.7%) | 🟠 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.39ms | 1.30ms | +0.09ms (+6.8%) | 🟠 |
| Worst Frame Build Time Millis | 6.31ms | 4.75ms | +1.56ms (+32.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.70ms | 9.95ms | +0.74ms (+7.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 20.5 | 10.75 | +10 (+90.7%) | 🔴 |
| New Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.58ms | 1.11ms | +0.46ms (+41.5%) | 🔴 |
| Worst Frame Build Time Millis | 8.38ms | 3.79ms | +4.59ms (+121.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.54ms | 9.93ms | +0.60ms (+6.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.0 | 2.25 | -0 (-11.1%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.98ms | 4.24ms | -0.26ms (-6.1%) | 🟢 |
| Worst Frame Build Time Millis | 6.22ms | 10.43ms | -4.21ms (-40.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.41ms | 10.16ms | +0.25ms (+2.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |
| Old Gen Gc Count | 2.0 | 1.75 | +0 (+14.3%) | 🔴 |

</details>

