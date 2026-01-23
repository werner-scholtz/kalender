## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 18.6%
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 18.6%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 6.3%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 20.7%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 11.5%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 20.4%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.96ms | 2.95ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 7.27ms | 7.07ms | +0.20ms (+2.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.25ms | 3.60ms | +0.65ms (+18.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.41ms | 5.48ms | -0.07ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 21.19ms | 20.21ms | +0.99ms (+4.9%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.09ms | 5.07ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.58ms | 0.74ms | -0.15ms (-20.7%) | 🟢 |
| Worst Frame Build Time Millis | 2.78ms | 5.05ms | -2.27ms (-45.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.85ms | 6.21ms | -1.36ms (-21.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.25 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 2.0 | +2 (+100.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.50ms | -0.02ms (-4.0%) | 🟡 |
| Worst Frame Build Time Millis | 2.28ms | 2.28ms | +0.00ms (+0.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.88ms | 4.84ms | +0.04ms (+0.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.29ms | 9.03ms | +0.26ms (+2.9%) | 🟠 |
| Worst Frame Build Time Millis | 26.54ms | 25.65ms | +0.89ms (+3.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.92ms | 4.05ms | -0.13ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.69ms | 6.86ms | -0.17ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 13.76ms | 13.98ms | -0.22ms (-1.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.32ms | 5.26ms | +0.06ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.21ms | 2.27ms | -0.07ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 27.00ms | 30.14ms | -3.14ms (-10.4%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.36ms | 7.85ms | -0.48ms (-6.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 7.5 | 0.5 | +7 (+1400.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.74ms | -0.02ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 1.88ms | 1.95ms | -0.07ms (-3.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.45ms | 14.18ms | +0.28ms (+1.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.86ms | 2.86ms | +0.00ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 9.45ms | 9.59ms | -0.13ms (-1.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.94ms | 3.89ms | +0.05ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.70ms | -0.07ms (-9.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.56ms | 3.22ms | +0.34ms (+10.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.22ms | 5.09ms | +0.13ms (+2.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.25 | 0.25 | +2 (+800.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.50ms | 0.63ms | -0.13ms (-20.4%) | 🟢 |
| Worst Frame Build Time Millis | 1.89ms | 3.44ms | -1.54ms (-44.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.54ms | 4.32ms | -0.78ms (-18.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.01ms | 2.11ms | -0.10ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 5.76ms | 7.11ms | -1.35ms (-18.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.22ms | 6.46ms | -0.24ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.87ms | 8.34ms | +0.53ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 41.00ms | 36.06ms | +4.94ms (+13.7%) | 🔴 |
| Missed Frame Build Budget Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.32ms | 6.90ms | +0.42ms (+6.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 13.5 | 12.0 | +2 (+12.5%) | 🔴 |
| Old Gen Gc Count | 8.5 | 7.5 | +1 (+13.3%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 14.80ms | 14.77ms | +0.03ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 45.17ms | 47.18ms | -2.01ms (-4.3%) | 🟡 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.18ms | 7.09ms | +0.09ms (+1.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.0 | +0 (+5.6%) | 🟠 |
| Old Gen Gc Count | 7.5 | 6.0 | +2 (+25.0%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.57ms | 1.63ms | -0.06ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 15.53ms | 13.26ms | +2.27ms (+17.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.80ms | 10.14ms | -0.34ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 13.0 | 6.5 | +6 (+100.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.52ms | 1.28ms | +0.24ms (+18.6%) | 🔴 |
| Worst Frame Build Time Millis | 11.99ms | 8.23ms | +3.77ms (+45.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.32ms | 11.29ms | -1.97ms (-17.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 4.5 | -3 (-61.1%) | 🟢 |
| New Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.11ms | 6.01ms | +0.10ms (+1.6%) | 🟠 |
| Worst Frame Build Time Millis | 35.61ms | 33.49ms | +2.11ms (+6.3%) | 🟠 |
| Missed Frame Build Budget Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.34ms | 5.36ms | -0.02ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 20.0 | -1 (-5.0%) | 🟢 |
| Old Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.01ms | 23.31ms | +0.70ms (+3.0%) | 🟠 |
| Worst Frame Build Time Millis | 38.98ms | 45.98ms | -7.00ms (-15.2%) | 🟢 |
| Missed Frame Build Budget Count | 10.5 | 10.0 | +0 (+5.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.57ms | 5.29ms | +0.28ms (+5.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.0 | 16.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.0 | 9.5 | -0 (-5.3%) | 🟢 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.92ms | 0.98ms | -0.06ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 21.20ms | 21.28ms | -0.08ms (-0.4%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.76ms | 8.22ms | -1.46ms (-17.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 9.25 | 6.25 | +3 (+48.0%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.25 | 4.0 | +0 (+6.2%) | 🟠 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.46ms | -0.05ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 6.98ms | 7.20ms | -0.22ms (-3.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.77ms | 5.71ms | +0.06ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.32ms | 8.75ms | -0.43ms (-4.9%) | 🟡 |
| Worst Frame Build Time Millis | 34.73ms | 34.53ms | +0.20ms (+0.6%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.58ms | 7.70ms | -0.12ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.31ms | -0.09ms (-6.9%) | 🟢 |
| Worst Frame Build Time Millis | 9.20ms | 8.85ms | +0.35ms (+3.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.91ms | 11.22ms | -0.31ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 18.0 | 15.5 | +2 (+16.1%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 1.03ms | -0.12ms (-11.5%) | 🟢 |
| Worst Frame Build Time Millis | 4.88ms | 3.99ms | +0.89ms (+22.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.69ms | 9.94ms | -2.25ms (-22.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.79ms | 1.51ms | +0.28ms (+18.6%) | 🔴 |
| Worst Frame Build Time Millis | 4.93ms | 2.19ms | +2.74ms (+125.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.67ms | 8.55ms | +1.12ms (+13.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

