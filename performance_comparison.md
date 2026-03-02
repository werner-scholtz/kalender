## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 15.8%
- 🔴 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 25.0%
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 22.1%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 48.0%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 31.7%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 27.2%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 15.7%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 16.8%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 9.7%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 7.1%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 8.7%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 14.3%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 6.8%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 6.0%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.5%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 7.1%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 8.5%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.29ms | 2.84ms | +0.45ms (+15.8%) | 🔴 |
| Worst Frame Build Time Millis | 8.22ms | 6.71ms | +1.52ms (+22.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.27ms | 4.69ms | -0.42ms (-8.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.53ms | 5.33ms | +0.20ms (+3.7%) | 🟠 |
| Worst Frame Build Time Millis | 20.28ms | 16.46ms | +3.82ms (+23.2%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 0.5 | +1 (+150.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.64ms | 5.50ms | +0.14ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.77ms | +0.05ms (+6.0%) | 🟠 |
| Worst Frame Build Time Millis | 3.15ms | 3.06ms | +0.09ms (+3.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.20ms | 4.88ms | +0.32ms (+6.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.75ms | 0.59ms | +0.16ms (+27.2%) | 🔴 |
| Worst Frame Build Time Millis | 2.53ms | 1.96ms | +0.57ms (+28.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.01ms | 4.10ms | +0.91ms (+22.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 12.12ms | 11.95ms | +0.18ms (+1.5%) | 🟠 |
| Worst Frame Build Time Millis | 33.60ms | 33.98ms | -0.38ms (-1.1%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.36ms | 5.36ms | +0.01ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.87ms | 7.70ms | +0.17ms (+2.2%) | 🟠 |
| Worst Frame Build Time Millis | 14.60ms | 17.84ms | -3.24ms (-18.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.75 | -1 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 6.83ms | 6.38ms | +0.45ms (+7.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 4.5 | +2 (+33.3%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.77ms | 2.21ms | +0.55ms (+25.0%) | 🔴 |
| Worst Frame Build Time Millis | 28.79ms | 25.80ms | +2.98ms (+11.6%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 1.25 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.28ms | 6.06ms | +0.22ms (+3.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |
| Old Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.85ms | 0.70ms | +0.15ms (+22.1%) | 🔴 |
| Worst Frame Build Time Millis | 2.20ms | 1.82ms | +0.38ms (+20.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.32ms | 4.08ms | +0.24ms (+5.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.13ms | 3.01ms | +0.12ms (+4.2%) | 🟠 |
| Worst Frame Build Time Millis | 10.11ms | 9.88ms | +0.23ms (+2.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.20ms | 4.01ms | +0.19ms (+4.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 1.0 | +2 (+200.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.87ms | 0.74ms | +0.12ms (+16.8%) | 🔴 |
| Worst Frame Build Time Millis | 4.16ms | 3.51ms | +0.65ms (+18.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.53ms | 4.19ms | +0.34ms (+8.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.77ms | 0.66ms | +0.10ms (+15.7%) | 🔴 |
| Worst Frame Build Time Millis | 2.97ms | 2.98ms | -0.00ms (-0.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.39ms | 3.91ms | +0.48ms (+12.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.16ms | 2.18ms | -0.02ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 4.75ms | 4.35ms | +0.40ms (+9.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.87ms | 5.26ms | +0.61ms (+11.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.44ms | 6.85ms | +0.58ms (+8.5%) | 🟠 |
| Worst Frame Build Time Millis | 23.84ms | 24.15ms | -0.31ms (-1.3%) | 🟡 |
| Missed Frame Build Budget Count | 6.75 | 5.75 | +1 (+17.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 8.68ms | 8.62ms | +0.06ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.98ms | 13.66ms | +1.32ms (+9.7%) | 🟠 |
| Worst Frame Build Time Millis | 47.05ms | 37.49ms | +9.56ms (+25.5%) | 🔴 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.37ms | 8.71ms | +0.67ms (+7.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.54ms | 1.42ms | +0.12ms (+8.7%) | 🟠 |
| Worst Frame Build Time Millis | 8.45ms | 7.91ms | +0.54ms (+6.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.84ms | 7.54ms | +0.30ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.0 | 5.75 | -2 (-30.4%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.77ms | 1.20ms | +0.57ms (+48.0%) | 🔴 |
| Worst Frame Build Time Millis | 7.18ms | 5.84ms | +1.34ms (+22.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.61ms | 6.08ms | +1.53ms (+25.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.87ms | 5.56ms | +0.30ms (+5.5%) | 🟠 |
| Worst Frame Build Time Millis | 26.38ms | 27.37ms | -1.00ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 4.25 | 3.5 | +1 (+21.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.55ms | 6.32ms | +0.22ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 6.0 | -2 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 25.08ms | 23.42ms | +1.66ms (+7.1%) | 🟠 |
| Worst Frame Build Time Millis | 47.52ms | 47.47ms | +0.05ms (+0.1%) | 🟠 |
| Missed Frame Build Budget Count | 9.0 | 9.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.53ms | 7.10ms | +0.44ms (+6.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.54ms | 1.35ms | +0.19ms (+14.3%) | 🔴 |
| Worst Frame Build Time Millis | 21.98ms | 20.28ms | +1.69ms (+8.3%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 7.13ms | 6.57ms | +0.55ms (+8.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.0 | 2.75 | +1 (+45.5%) | 🔴 |
| New Gen Gc Count | 9.0 | 8.5 | +0 (+5.9%) | 🟠 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.28ms | 1.26ms | +0.02ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 6.87ms | 6.35ms | +0.52ms (+8.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.52ms | 6.47ms | +0.05ms (+0.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.5 | -2 (-42.9%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.49ms | 7.95ms | +0.54ms (+6.8%) | 🟠 |
| Worst Frame Build Time Millis | 28.09ms | 29.58ms | -1.50ms (-5.1%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.21ms | 8.88ms | +0.33ms (+3.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.38ms | 1.29ms | +0.09ms (+7.1%) | 🟠 |
| Worst Frame Build Time Millis | 5.42ms | 5.50ms | -0.08ms (-1.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.96ms | 10.12ms | +0.83ms (+8.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 21.25 | 15.25 | +6 (+39.3%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.39ms | 1.05ms | +0.33ms (+31.7%) | 🔴 |
| Worst Frame Build Time Millis | 7.65ms | 3.48ms | +4.17ms (+119.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.73ms | 9.56ms | +1.16ms (+12.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 3.25 | +0 (+7.7%) | 🟠 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.57ms | 3.89ms | -0.32ms (-8.2%) | 🟢 |
| Worst Frame Build Time Millis | 9.56ms | 8.69ms | +0.87ms (+10.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.03ms | 10.29ms | -0.25ms (-2.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

