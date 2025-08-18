## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 24.0%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 26.4%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 17.2%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 21.1%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 34.2%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 19.8%
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 22.2%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 7.3%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 6.6%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 6.4%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 7.0%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 6.5%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-month-loadingEvents**: Frame build time improved by 37.9%
- 🟢 **ten_events_per_day-week-scrolling**: Frame build time improved by 13.5%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.48ms | 7.22ms | -2.74ms (-37.9%) | 🟢 |
| Worst Frame Build Time Millis | 8.84ms | 14.33ms | -5.48ms (-38.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 2.47ms | 2.15ms | +0.31ms (+14.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.25ms | 5.10ms | +0.15ms (+2.9%) | 🟠 |
| Worst Frame Build Time Millis | 20.85ms | 18.24ms | +2.60ms (+14.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 1.25 | +0 (+20.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.98ms | 3.76ms | +0.22ms (+5.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 4.0 | -2 (-50.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 0.73ms | +0.18ms (+24.0%) | 🔴 |
| Worst Frame Build Time Millis | 4.65ms | 4.11ms | +0.54ms (+13.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.21ms | 3.91ms | +1.29ms (+33.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.59ms | +0.12ms (+19.8%) | 🔴 |
| Worst Frame Build Time Millis | 4.86ms | 4.04ms | +0.82ms (+20.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.68ms | 3.49ms | +3.20ms (+91.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 1.5 | +1 (+66.7%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.81ms | 7.21ms | +1.60ms (+22.2%) | 🔴 |
| Worst Frame Build Time Millis | 25.12ms | 20.55ms | +4.57ms (+22.2%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.66ms | 2.61ms | +0.06ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.02ms | 6.82ms | +0.21ms (+3.0%) | 🟠 |
| Worst Frame Build Time Millis | 16.78ms | 16.03ms | +0.75ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.31ms | 3.31ms | +0.00ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.75 | -1 (-27.3%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.14ms | 1.82ms | +0.31ms (+17.2%) | 🔴 |
| Worst Frame Build Time Millis | 24.35ms | 24.61ms | -0.26ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.62ms | 3.35ms | +1.27ms (+37.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.24ms | 1.25ms | -0.01ms (-0.7%) | 🟡 |
| Worst Frame Build Time Millis | 2.33ms | 2.36ms | -0.03ms (-1.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.25ms | 2.24ms | +0.01ms (+0.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.09ms | 3.01ms | +0.08ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 10.12ms | 9.74ms | +0.38ms (+3.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.65ms | 3.60ms | +0.05ms (+1.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.78ms | 0.64ms | +0.14ms (+21.1%) | 🔴 |
| Worst Frame Build Time Millis | 3.56ms | 3.02ms | +0.54ms (+17.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.46ms | 3.95ms | +1.51ms (+38.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.25 | 0.25 | +1 (+400.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.80ms | 0.59ms | +0.20ms (+34.2%) | 🔴 |
| Worst Frame Build Time Millis | 4.47ms | 2.36ms | +2.11ms (+89.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.57ms | 3.10ms | +2.46ms (+79.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.08ms | 1.93ms | +0.14ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 4.57ms | 3.75ms | +0.82ms (+21.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.83ms | 4.78ms | +1.06ms (+22.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.93ms | 10.58ms | -0.66ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 29.03ms | 29.73ms | -0.70ms (-2.3%) | 🟡 |
| Missed Frame Build Budget Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.87ms | 5.04ms | -0.17ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 10.5 | +0 (+4.8%) | 🟠 |
| Old Gen Gc Count | 6.5 | 8.0 | -2 (-18.8%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.80ms | 11.96ms | +0.84ms (+7.0%) | 🟠 |
| Worst Frame Build Time Millis | 42.84ms | 42.29ms | +0.55ms (+1.3%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.17ms | 4.93ms | +0.24ms (+4.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.95ms | 1.83ms | +0.12ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 13.90ms | 14.40ms | -0.49ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.14ms | 8.34ms | -0.20ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.11ms | 2.07ms | +0.05ms (+2.2%) | 🟠 |
| Worst Frame Build Time Millis | 18.38ms | 19.40ms | -1.02ms (-5.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.5 | 0.75 | +1 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 8.08ms | 8.80ms | -0.72ms (-8.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.71ms | 5.56ms | +0.15ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 28.95ms | 27.37ms | +1.58ms (+5.8%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.25 | +1 (+23.1%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.40ms | 3.21ms | +0.19ms (+5.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.69ms | 20.92ms | +0.77ms (+3.7%) | 🟠 |
| Worst Frame Build Time Millis | 43.92ms | 43.57ms | +0.35ms (+0.8%) | 🟠 |
| Missed Frame Build Budget Count | 10.25 | 9.5 | +1 (+7.9%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.25ms | 3.07ms | +0.18ms (+5.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 20.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.04ms | 1.03ms | +0.00ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 21.33ms | 21.57ms | -0.24ms (-1.1%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.28ms | 5.48ms | +0.80ms (+14.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 5.0 | -4 (-70.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.31ms | 2.45ms | -0.14ms (-5.7%) | 🟢 |
| Worst Frame Build Time Millis | 8.57ms | 10.14ms | -1.57ms (-15.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.89ms | 3.99ms | -0.11ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.17ms | 8.62ms | +0.55ms (+6.4%) | 🟠 |
| Worst Frame Build Time Millis | 40.77ms | 36.17ms | +4.60ms (+12.7%) | 🔴 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.69ms | 5.83ms | -0.15ms (-2.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.35ms | 1.27ms | +0.08ms (+6.6%) | 🟠 |
| Worst Frame Build Time Millis | 6.91ms | 6.14ms | +0.76ms (+12.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.89ms | 8.94ms | -1.04ms (-11.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.0 | 8.0 | -4 (-50.0%) | 🟢 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.41ms | 1.11ms | +0.29ms (+26.4%) | 🔴 |
| Worst Frame Build Time Millis | 10.02ms | 4.57ms | +5.45ms (+119.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.89ms | 7.67ms | +1.22ms (+15.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.0 | 0.0 | +3 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.75ms | 2.02ms | -0.27ms (-13.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.91ms | 6.37ms | -2.45ms (-38.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.00ms | 6.57ms | -0.57ms (-8.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

</details>

