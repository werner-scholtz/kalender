## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 23.5%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 48.6%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 26.3%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 16.3%
- 🔴 **one_event_per_day-schedule-navigation**: Frame build time increased by 26.9%
- 🔴 **one_event_per_day-month-navigation**: Frame build time increased by 17.5%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 99.0%
- 🔴 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 25.2%
- 🔴 **ten_events_per_day-schedule-navigation**: Frame build time increased by 18.9%
- 🔴 **ten_events_per_day-week-navigation**: Frame build time increased by 26.4%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 104.5%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 31.5%
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 27.9%
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 24.8%
- 🔴 **one_event_per_day-week-navigation**: Frame build time increased by 28.6%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 22.9%
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 36.6%
- 🔴 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 43.7%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 146.6%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 12.2%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 9.9%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 10.7%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 14.0%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.08ms | 2.80ms | +0.28ms (+9.9%) | 🟠 |
| Worst Frame Build Time Millis | 7.58ms | 7.05ms | +0.52ms (+7.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.16ms | 4.33ms | -0.17ms (-3.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.40ms | 4.60ms | +0.81ms (+17.5%) | 🔴 |
| Worst Frame Build Time Millis | 20.36ms | 18.81ms | +1.55ms (+8.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.37ms | 5.02ms | +0.34ms (+6.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.59ms | +0.15ms (+24.8%) | 🔴 |
| Worst Frame Build Time Millis | 3.05ms | 3.12ms | -0.08ms (-2.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.68ms | 4.55ms | +0.14ms (+3.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 2.0 | -2 (-87.5%) | 🟢 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.84ms | 0.42ms | +0.42ms (+99.0%) | 🔴 |
| Worst Frame Build Time Millis | 3.64ms | 1.94ms | +1.71ms (+88.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.47ms | 3.95ms | +1.52ms (+38.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.91ms | 7.94ms | +0.97ms (+12.2%) | 🔴 |
| Worst Frame Build Time Millis | 25.04ms | 22.73ms | +2.31ms (+10.1%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.37ms | 4.82ms | -0.45ms (-9.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.39ms | 5.82ms | +1.56ms (+26.9%) | 🔴 |
| Worst Frame Build Time Millis | 14.57ms | 12.14ms | +2.43ms (+20.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.46ms | 5.12ms | +1.33ms (+26.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.93ms | 1.86ms | +0.07ms (+3.8%) | 🟠 |
| Worst Frame Build Time Millis | 23.97ms | 31.09ms | -7.12ms (-22.9%) | 🟢 |
| Missed Frame Build Budget Count | 1.25 | 1.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.84ms | 5.11ms | +0.73ms (+14.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 6.0 | -2 (-33.3%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 0.62ms | +0.17ms (+27.9%) | 🔴 |
| Worst Frame Build Time Millis | 2.09ms | 1.52ms | +0.58ms (+38.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.50ms | 13.14ms | -8.63ms (-65.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.16ms | 2.46ms | +0.70ms (+28.6%) | 🔴 |
| Worst Frame Build Time Millis | 10.80ms | 8.38ms | +2.41ms (+28.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.10ms | 3.91ms | +0.19ms (+4.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.0 | +2 (+37.5%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.54ms | +0.26ms (+48.6%) | 🔴 |
| Worst Frame Build Time Millis | 4.19ms | 2.23ms | +1.95ms (+87.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.34ms | 3.89ms | +0.45ms (+11.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 5.5 | 2.0 | +4 (+175.0%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.48ms | +0.13ms (+26.3%) | 🔴 |
| Worst Frame Build Time Millis | 2.45ms | 1.83ms | +0.61ms (+33.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.87ms | 3.60ms | +0.28ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.22ms | 1.80ms | +0.42ms (+23.5%) | 🔴 |
| Worst Frame Build Time Millis | 4.36ms | 3.95ms | +0.41ms (+10.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.29ms | 5.84ms | -0.54ms (-9.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.56ms | 6.65ms | +2.91ms (+43.7%) | 🔴 |
| Worst Frame Build Time Millis | 34.40ms | 28.32ms | +6.08ms (+21.5%) | 🔴 |
| Missed Frame Build Budget Count | 7.75 | 5.5 | +2 (+40.9%) | 🔴 |
| Average Frame Rasterizer Time Millis | 8.78ms | 7.25ms | +1.53ms (+21.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 18.82ms | 13.78ms | +5.04ms (+36.6%) | 🔴 |
| Worst Frame Build Time Millis | 52.92ms | 48.19ms | +4.74ms (+9.8%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.11ms | 7.53ms | +0.57ms (+7.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.50ms | 1.29ms | +0.21ms (+16.3%) | 🔴 |
| Worst Frame Build Time Millis | 13.88ms | 10.21ms | +3.67ms (+35.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.67ms | 7.38ms | +0.30ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.0 | 5.75 | -4 (-65.2%) | 🟢 |
| New Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.20ms | +0.17ms (+14.0%) | 🔴 |
| Worst Frame Build Time Millis | 8.90ms | 7.77ms | +1.13ms (+14.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.58ms | 10.07ms | -3.49ms (-34.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.5 | 5.25 | -4 (-71.4%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 3.0 | -2 (-66.7%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.81ms | 5.25ms | +0.56ms (+10.7%) | 🔴 |
| Worst Frame Build Time Millis | 24.94ms | 30.80ms | -5.86ms (-19.0%) | 🟢 |
| Missed Frame Build Budget Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.32ms | 5.45ms | +0.87ms (+15.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 20.0 | -1 (-5.0%) | 🟢 |
| Old Gen Gc Count | 7.5 | 9.0 | -2 (-16.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.38ms | 21.35ms | +4.03ms (+18.9%) | 🔴 |
| Worst Frame Build Time Millis | 47.53ms | 43.15ms | +4.38ms (+10.1%) | 🔴 |
| Missed Frame Build Budget Count | 9.0 | 8.25 | +1 (+9.1%) | 🟠 |
| Average Frame Rasterizer Time Millis | 6.89ms | 6.04ms | +0.85ms (+14.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 15.0 | 19.5 | -4 (-23.1%) | 🟢 |
| Old Gen Gc Count | 9.5 | 10.5 | -1 (-9.5%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.24ms | 0.94ms | +0.30ms (+31.5%) | 🔴 |
| Worst Frame Build Time Millis | 18.12ms | 18.66ms | -0.54ms (-2.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.31ms | 6.09ms | +0.22ms (+3.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 5.75 | -4 (-78.3%) | 🟢 |
| New Gen Gc Count | 8.0 | 6.5 | +2 (+23.1%) | 🔴 |
| Old Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.53ms | 1.22ms | +0.31ms (+25.2%) | 🔴 |
| Worst Frame Build Time Millis | 7.80ms | 6.40ms | +1.40ms (+21.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.81ms | 5.78ms | +1.02ms (+17.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.13ms | 7.22ms | +1.91ms (+26.4%) | 🔴 |
| Worst Frame Build Time Millis | 35.55ms | 27.55ms | +8.00ms (+29.0%) | 🔴 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.93ms | 7.61ms | +1.32ms (+17.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.36ms | 1.10ms | +0.25ms (+22.9%) | 🔴 |
| Worst Frame Build Time Millis | 6.55ms | 11.55ms | -5.00ms (-43.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.11ms | 9.35ms | +0.76ms (+8.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 10.75 | 14.75 | -4 (-27.1%) | 🟢 |
| New Gen Gc Count | 8.0 | 6.0 | +2 (+33.3%) | 🔴 |
| Old Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.75ms | 0.71ms | +1.04ms (+146.6%) | 🔴 |
| Worst Frame Build Time Millis | 6.77ms | 2.49ms | +4.28ms (+172.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 13.48ms | 6.60ms | +6.87ms (+104.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.5 | 0.0 | +4 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.32ms | 1.62ms | +1.70ms (+104.5%) | 🔴 |
| Worst Frame Build Time Millis | 5.78ms | 5.47ms | +0.31ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.35ms | 8.73ms | +1.62ms (+18.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 8.0 | -2 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

</details>

