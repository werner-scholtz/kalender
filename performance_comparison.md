## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 6730.4%
- 🔴 **ten_events_per_day-schedule-navigation**: Frame build time increased by 16.8%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 53.5%
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 645.1%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 2772.6%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 10.6%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 6.5%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 6.1%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 13.4%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-loadingEvents**: Frame build time improved by 33.4%
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 15.8%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 20.6%
- 🟢 **ten_events_per_day-month-loadingEvents**: Frame build time improved by 31.6%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 27.4%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 21.3%
- 🟢 **ten_events_per_day-month-resizing**: Frame build time improved by 26.3%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 11.1%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 36.4%
- 🟢 **one_event_per_day-week-scrolling**: Frame build time improved by 15.3%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.73ms | 0.13ms | +3.60ms (+2772.6%) | 🔴 |
| Worst Frame Build Time Millis | 7.30ms | 0.13ms | +7.17ms (+5516.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.96ms | 1.74ms | +0.22ms (+12.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.90ms | 5.41ms | -0.51ms (-9.4%) | 🟢 |
| Worst Frame Build Time Millis | 16.84ms | 23.09ms | -6.25ms (-27.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 2 | -1 (-62.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.96ms | 5.99ms | -2.03ms (-33.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 4 | -2 (-50.0%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.86ms | -0.10ms (-11.1%) | 🟢 |
| Worst Frame Build Time Millis | 4.63ms | 4.35ms | +0.29ms (+6.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.89ms | 2.80ms | +0.09ms (+3.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 2 | +2 (+100.0%) | 🔴 |
| Old Gen Gc Count | 3.5 | 0 | +4 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.76ms | -0.21ms (-27.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.99ms | 3.77ms | +0.21ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.63ms | 2.54ms | +0.10ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.10ms | 0.10ms | +7.00ms (+6730.4%) | 🔴 |
| Worst Frame Build Time Millis | 19.89ms | 0.10ms | +19.79ms (+19026.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.05ms | 1.35ms | +1.70ms (+125.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.5 | 2 | -2 (-75.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.21ms | 5.83ms | +0.38ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 11.19ms | 10.93ms | +0.26ms (+2.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.48ms | 3.21ms | +0.27ms (+8.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.89ms | 1.23ms | +0.66ms (+53.5%) | 🔴 |
| Worst Frame Build Time Millis | 30.68ms | 23.48ms | +7.20ms (+30.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.92ms | 3.69ms | -0.78ms (-21.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 4 | +4 (+100.0%) | 🔴 |
| Old Gen Gc Count | 5.0 | 0 | +5 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.19ms | 0.16ms | +1.03ms (+645.1%) | 🔴 |
| Worst Frame Build Time Millis | 2.26ms | 0.16ms | +2.10ms (+1313.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.06ms | 2.19ms | -0.13ms (-6.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.82ms | 2.71ms | +0.11ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 9.43ms | 8.89ms | +0.53ms (+6.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.24ms | 5.09ms | -1.85ms (-36.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 6 | -2 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.56ms | +0.01ms (+1.2%) | 🟠 |
| Worst Frame Build Time Millis | 2.19ms | 1.70ms | +0.49ms (+28.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.42ms | 2.80ms | -0.38ms (-13.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 0 | +4 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.52ms | -0.01ms (-1.7%) | 🟡 |
| Worst Frame Build Time Millis | 1.78ms | 1.40ms | +0.39ms (+27.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.94ms | 1.87ms | +0.07ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 2 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 0.0 | 2 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 0.95ms | -0.15ms (-15.3%) | 🟢 |
| Worst Frame Build Time Millis | 1.07ms | 2.45ms | -1.38ms (-56.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.22ms | 6.39ms | -2.17ms (-33.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 2.5 | 2 | +0 (+25.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0 | +2 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.51ms | 15.38ms | -4.86ms (-31.6%) | 🟢 |
| Worst Frame Build Time Millis | 29.45ms | 25.14ms | +4.31ms (+17.1%) | 🔴 |
| Missed Frame Build Budget Count | 7.5 | 5 | +2 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.19ms | 5.00ms | +0.19ms (+3.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 12 | -2 (-16.7%) | 🟢 |
| Old Gen Gc Count | 6.5 | 6 | +0 (+8.3%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.42ms | 11.22ms | +1.19ms (+10.6%) | 🔴 |
| Worst Frame Build Time Millis | 41.29ms | 38.90ms | +2.39ms (+6.1%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 3 | +0 (+16.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.34ms | 4.88ms | +0.45ms (+9.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 10 | -1 (-10.0%) | 🟢 |
| Old Gen Gc Count | 5.0 | 4 | +1 (+25.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.53ms | 2.40ms | -0.87ms (-36.4%) | 🟢 |
| Worst Frame Build Time Millis | 13.89ms | 13.41ms | +0.48ms (+3.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.07ms | 6.67ms | -2.60ms (-39.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 4 | +2 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.47ms | 1.99ms | -0.52ms (-26.3%) | 🟢 |
| Worst Frame Build Time Millis | 13.67ms | 11.87ms | +1.80ms (+15.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.25 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.71ms | 5.71ms | -2.00ms (-35.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 2 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.46ms | 6.88ms | -1.42ms (-20.6%) | 🟢 |
| Worst Frame Build Time Millis | 29.75ms | 30.15ms | -0.39ms (-1.3%) | 🟡 |
| Missed Frame Build Budget Count | 3.5 | 1 | +2 (+250.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.35ms | 3.29ms | +0.06ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 12 | -2 (-12.5%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 20.88ms | 17.88ms | +3.01ms (+16.8%) | 🔴 |
| Worst Frame Build Time Millis | 42.32ms | 39.87ms | +2.45ms (+6.1%) | 🟠 |
| Missed Frame Build Budget Count | 9.5 | 9 | +0 (+5.6%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.53ms | 2.75ms | +0.78ms (+28.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 16 | +2 (+12.5%) | 🔴 |
| Old Gen Gc Count | 12.0 | 14 | -2 (-14.3%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.85ms | 0.75ms | +0.10ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 13.41ms | 11.11ms | +2.30ms (+20.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.28ms | 3.59ms | -0.31ms (-8.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 4 | +2 (+50.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.39ms | 3.59ms | -1.20ms (-33.4%) | 🟢 |
| Worst Frame Build Time Millis | 8.76ms | 5.30ms | +3.47ms (+65.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.52ms | 5.77ms | -2.25ms (-39.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 4 | -2 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2 | +0 (+25.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.06ms | 8.53ms | +0.52ms (+6.1%) | 🟠 |
| Worst Frame Build Time Millis | 45.56ms | 45.81ms | -0.25ms (-0.5%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.61ms | 5.07ms | +0.54ms (+10.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 12 | -4 (-33.3%) | 🟢 |
| Old Gen Gc Count | 7.0 | 8 | -1 (-12.5%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.04ms | 1.23ms | -0.19ms (-15.8%) | 🟢 |
| Worst Frame Build Time Millis | 6.38ms | 4.29ms | +2.09ms (+48.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.32ms | 6.23ms | +0.09ms (+1.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 8.75 | 0 | +9 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 2 | +3 (+150.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 0 | +3 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.85ms | 1.08ms | -0.23ms (-21.3%) | 🟢 |
| Worst Frame Build Time Millis | 3.72ms | 3.08ms | +0.64ms (+20.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.63ms | 5.92ms | -0.30ms (-5.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0 | +1 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.78ms | 0.79ms | -0.01ms (-0.7%) | 🟡 |
| Worst Frame Build Time Millis | 1.08ms | 1.02ms | +0.06ms (+5.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.15ms | 7.23ms | -2.08ms (-28.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 6 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 1.0 | 2 | -1 (-50.0%) | 🟢 |

</details>

