## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 5.2%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 6.1%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 11.5%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 12.0%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 12.0%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.86ms | 2.92ms | -0.06ms (-1.9%) | 🟡 |
| Worst Frame Build Time Millis | 7.02ms | 7.11ms | -0.09ms (-1.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.68ms | 3.80ms | -0.12ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.28ms | 5.39ms | -0.11ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 19.92ms | 22.35ms | -2.43ms (-10.9%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.05ms | 5.07ms | -0.03ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.74ms | -0.02ms (-3.1%) | 🟡 |
| Worst Frame Build Time Millis | 5.72ms | 3.45ms | +2.27ms (+65.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.84ms | 6.11ms | -0.27ms (-4.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.56ms | -0.00ms (-0.9%) | 🟡 |
| Worst Frame Build Time Millis | 3.25ms | 2.63ms | +0.61ms (+23.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.95ms | 8.24ms | -2.30ms (-27.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.5 | 3.0 | -2 (-83.3%) | 🟢 |
| New Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.50ms | 8.95ms | +0.55ms (+6.1%) | 🟠 |
| Worst Frame Build Time Millis | 27.08ms | 25.69ms | +1.40ms (+5.4%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.91ms | 3.90ms | +0.00ms (+0.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.70ms | 6.51ms | +0.20ms (+3.0%) | 🟠 |
| Worst Frame Build Time Millis | 13.98ms | 13.23ms | +0.75ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.31ms | 5.18ms | +0.13ms (+2.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 4.75 | +1 (+26.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.13ms | 2.27ms | -0.14ms (-6.1%) | 🟢 |
| Worst Frame Build Time Millis | 28.19ms | 27.42ms | +0.77ms (+2.8%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.84ms | 8.49ms | -1.64ms (-19.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.5 | 11.25 | -8 (-68.9%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.78ms | -0.02ms (-2.1%) | 🟡 |
| Worst Frame Build Time Millis | 1.99ms | 2.03ms | -0.05ms (-2.2%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.48ms | 14.34ms | +0.14ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.91ms | 2.76ms | +0.14ms (+5.2%) | 🟠 |
| Worst Frame Build Time Millis | 9.59ms | 9.69ms | -0.10ms (-1.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.94ms | 3.89ms | +0.05ms (+1.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.76ms | -0.07ms (-9.4%) | 🟢 |
| Worst Frame Build Time Millis | 3.55ms | 5.23ms | -1.68ms (-32.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.57ms | 5.60ms | -0.03ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 2.25 | 0.25 | +2 (+800.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.67ms | -0.08ms (-12.0%) | 🟢 |
| Worst Frame Build Time Millis | 2.85ms | 3.39ms | -0.54ms (-16.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.07ms | 5.27ms | -1.20ms (-22.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.88ms | 1.80ms | +0.07ms (+4.1%) | 🟠 |
| Worst Frame Build Time Millis | 5.39ms | 3.79ms | +1.60ms (+42.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.79ms | 5.85ms | -0.06ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.0 | +0 (+12.5%) | 🔴 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.36ms | 8.48ms | -0.11ms (-1.4%) | 🟡 |
| Worst Frame Build Time Millis | 36.01ms | 35.57ms | +0.44ms (+1.2%) | 🟠 |
| Missed Frame Build Budget Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.90ms | 6.94ms | -0.03ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.18ms | 15.24ms | -0.06ms (-0.4%) | 🟡 |
| Worst Frame Build Time Millis | 48.20ms | 48.74ms | -0.54ms (-1.1%) | 🟡 |
| Missed Frame Build Budget Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.96ms | 7.08ms | -0.12ms (-1.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.55ms | 1.63ms | -0.09ms (-5.2%) | 🟢 |
| Worst Frame Build Time Millis | 12.93ms | 13.72ms | -0.79ms (-5.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.42ms | 8.90ms | +1.51ms (+17.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.5 | 1.0 | +2 (+150.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.42ms | 1.27ms | +0.15ms (+12.0%) | 🔴 |
| Worst Frame Build Time Millis | 8.81ms | 8.58ms | +0.23ms (+2.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.68ms | 10.28ms | +2.40ms (+23.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.0 | 3.5 | +2 (+71.4%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.15ms | 5.94ms | +0.21ms (+3.5%) | 🟠 |
| Worst Frame Build Time Millis | 39.01ms | 32.53ms | +6.48ms (+19.9%) | 🔴 |
| Missed Frame Build Budget Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.31ms | 5.33ms | -0.02ms (-0.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 20.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.65ms | 22.85ms | -1.21ms (-5.3%) | 🟢 |
| Worst Frame Build Time Millis | 44.59ms | 50.96ms | -6.36ms (-12.5%) | 🟢 |
| Missed Frame Build Budget Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.45ms | 5.65ms | -0.19ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.5 | 17.0 | +2 (+8.8%) | 🟠 |
| Old Gen Gc Count | 10.5 | 10.0 | +0 (+5.0%) | 🟠 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.04ms | 1.01ms | +0.03ms (+2.9%) | 🟠 |
| Worst Frame Build Time Millis | 20.60ms | 18.02ms | +2.58ms (+14.3%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 0.5 | +1 (+150.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 8.20ms | 7.94ms | +0.26ms (+3.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 7.5 | 9.0 | -2 (-16.7%) | 🟢 |
| New Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |
| Old Gen Gc Count | 4.5 | 5.0 | -0 (-10.0%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.47ms | 1.46ms | +0.01ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 7.18ms | 8.00ms | -0.83ms (-10.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.68ms | 5.76ms | -0.07ms (-1.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.51ms | 8.53ms | -0.02ms (-0.2%) | 🟡 |
| Worst Frame Build Time Millis | 35.86ms | 32.74ms | +3.12ms (+9.5%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.67ms | 7.81ms | -0.14ms (-1.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.36ms | -0.05ms (-3.9%) | 🟡 |
| Worst Frame Build Time Millis | 10.11ms | 8.96ms | +1.16ms (+12.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.03ms | 10.21ms | +1.82ms (+17.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 16.0 | 8.5 | +8 (+88.2%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.99ms | 1.02ms | -0.03ms (-2.7%) | 🟡 |
| Worst Frame Build Time Millis | 4.02ms | 3.71ms | +0.30ms (+8.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.46ms | 8.74ms | +1.72ms (+19.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.77ms | 1.58ms | +0.18ms (+11.5%) | 🔴 |
| Worst Frame Build Time Millis | 5.16ms | 2.36ms | +2.80ms (+118.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.08ms | 8.27ms | +0.81ms (+9.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

