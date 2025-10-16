## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 15.1%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 5.8%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 7.3%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 5.8%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 14.3%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 10.6%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 6.3%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 11.5%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 12.6%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 12.1%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.10ms | 3.88ms | +0.23ms (+5.8%) | 🟠 |
| Worst Frame Build Time Millis | 8.06ms | 7.62ms | +0.44ms (+5.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.63ms | 2.36ms | +0.27ms (+11.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.79ms | 4.66ms | +0.13ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 18.75ms | 18.24ms | +0.50ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 1.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.96ms | 3.82ms | +0.14ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.65ms | +0.05ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 7.40ms | 6.07ms | +1.33ms (+21.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.87ms | 2.57ms | +0.30ms (+11.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.53ms | +0.06ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 4.33ms | 3.59ms | +0.74ms (+20.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.62ms | 2.58ms | +0.05ms (+1.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.12ms | 8.90ms | +0.22ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 26.16ms | 25.36ms | +0.80ms (+3.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.86ms | 2.85ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.83ms | 6.98ms | -0.15ms (-2.2%) | 🟡 |
| Worst Frame Build Time Millis | 14.28ms | 16.47ms | -2.18ms (-13.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.38ms | 3.23ms | +0.15ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.96ms | 1.95ms | +0.01ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 28.18ms | 28.35ms | -0.17ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.06ms | 3.11ms | -0.05ms (-1.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.5 | 9.0 | -0 (-5.6%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 1.24ms | +0.01ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.38ms | 2.33ms | +0.05ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.05ms | 2.41ms | -0.37ms (-15.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.93ms | 2.91ms | +0.02ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 9.71ms | 9.76ms | -0.05ms (-0.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.47ms | 3.39ms | +0.08ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.59ms | +0.09ms (+14.3%) | 🔴 |
| Worst Frame Build Time Millis | 5.76ms | 2.34ms | +3.42ms (+146.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.88ms | 2.97ms | -0.08ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.68ms | 0.59ms | +0.09ms (+15.1%) | 🔴 |
| Worst Frame Build Time Millis | 2.49ms | 2.45ms | +0.04ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 3.61ms | +0.34ms (+9.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.69ms | 1.74ms | -0.04ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 3.82ms | 2.99ms | +0.83ms (+27.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.88ms | 3.35ms | +0.53ms (+15.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.12ms | 9.56ms | +0.56ms (+5.8%) | 🟠 |
| Worst Frame Build Time Millis | 28.38ms | 27.51ms | +0.87ms (+3.2%) | 🟠 |
| Missed Frame Build Budget Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.97ms | 4.92ms | +0.05ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 10.0 | +1 (+10.0%) | 🟠 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.77ms | 10.27ms | +0.50ms (+4.9%) | 🟠 |
| Worst Frame Build Time Millis | 40.45ms | 38.31ms | +2.14ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.31ms | 4.82ms | +0.49ms (+10.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.41ms | 1.42ms | -0.01ms (-0.5%) | 🟡 |
| Worst Frame Build Time Millis | 14.64ms | 14.41ms | +0.23ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.24ms | 4.04ms | +0.20ms (+5.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.48ms | 1.60ms | -0.12ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 11.70ms | 14.16ms | -2.46ms (-17.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.35ms | 5.23ms | +0.12ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.77ms | 5.52ms | +0.25ms (+4.5%) | 🟠 |
| Worst Frame Build Time Millis | 29.34ms | 27.03ms | +2.31ms (+8.5%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.26ms | 3.28ms | -0.03ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 13.5 | 14.0 | -0 (-3.6%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.32ms | 20.71ms | +2.61ms (+12.6%) | 🔴 |
| Worst Frame Build Time Millis | 43.36ms | 43.57ms | -0.20ms (-0.5%) | 🟡 |
| Missed Frame Build Budget Count | 11.0 | 10.0 | +1 (+10.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.27ms | 2.99ms | +0.29ms (+9.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 17.5 | 18.0 | -0 (-2.8%) | 🟡 |
| Old Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.98ms | 0.96ms | +0.02ms (+1.8%) | 🟠 |
| Worst Frame Build Time Millis | 19.27ms | 19.05ms | +0.22ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.88ms | 3.34ms | +0.54ms (+16.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.5 | -0 (-7.7%) | 🟢 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.34ms | 2.20ms | +0.14ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 8.68ms | 8.28ms | +0.40ms (+4.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.98ms | 3.76ms | +0.22ms (+5.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.53ms | 8.63ms | -0.10ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 38.82ms | 38.50ms | +0.32ms (+0.8%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.24ms | 5.70ms | -0.46ms (-8.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.15ms | 1.04ms | +0.11ms (+10.6%) | 🔴 |
| Worst Frame Build Time Millis | 6.14ms | 6.53ms | -0.38ms (-5.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.31ms | 5.70ms | +0.61ms (+10.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 9.0 | 2.0 | +7 (+350.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.98ms | 1.12ms | -0.14ms (-12.1%) | 🟢 |
| Worst Frame Build Time Millis | 5.94ms | 4.71ms | +1.22ms (+26.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.00ms | 7.44ms | -2.45ms (-32.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 3.5 | -4 (-100.0%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.67ms | 1.63ms | +0.04ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 2.88ms | 3.38ms | -0.50ms (-14.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.96ms | 6.17ms | -0.21ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

