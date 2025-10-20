## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 5.9%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 11.8%
- 🟠 **one_event_per_day-month-rescheduling**: Frame build time increased by 14.4%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 5.4%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 7.6%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 7.8%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 17.4%
- 🟢 **one_event_per_day-month-resizing**: Frame build time improved by 28.8%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.90ms | 2.60ms | +0.31ms (+11.8%) | 🔴 |
| Worst Frame Build Time Millis | 6.84ms | 6.22ms | +0.62ms (+10.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.82ms | 2.79ms | +0.03ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.66ms | 4.57ms | +0.09ms (+2.0%) | 🟠 |
| Worst Frame Build Time Millis | 13.86ms | 13.81ms | +0.05ms (+0.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.41ms | 3.58ms | -0.17ms (-4.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.62ms | +0.09ms (+14.4%) | 🔴 |
| Worst Frame Build Time Millis | 5.32ms | 3.62ms | +1.69ms (+46.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.12ms | 4.67ms | -0.55ms (-11.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 3.75 | 8.75 | -5 (-57.1%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.68ms | -0.20ms (-28.8%) | 🟢 |
| Worst Frame Build Time Millis | 2.11ms | 5.08ms | -2.97ms (-58.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.42ms | 7.42ms | -5.00ms (-67.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 4.0 | -4 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.74ms | 10.39ms | -0.65ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 27.71ms | 29.67ms | -1.96ms (-6.6%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.57ms | 3.50ms | -0.93ms (-26.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.85ms | 7.30ms | +0.55ms (+7.6%) | 🟠 |
| Worst Frame Build Time Millis | 16.59ms | 17.61ms | -1.02ms (-5.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.75 | -0 (-66.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.39ms | 3.44ms | -0.05ms (-1.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| Old Gen Gc Count | 3.5 | 2.0 | +2 (+75.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.24ms | 2.14ms | +0.10ms (+4.6%) | 🟠 |
| Worst Frame Build Time Millis | 30.92ms | 27.03ms | +3.89ms (+14.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.25 | 1.75 | -0 (-28.6%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.50ms | 4.18ms | -0.68ms (-16.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.75 | 4.5 | -3 (-61.1%) | 🟢 |
| New Gen Gc Count | 8.5 | 9.5 | -1 (-10.5%) | 🟢 |
| Old Gen Gc Count | 4.5 | 5.5 | -1 (-18.2%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.76ms | -0.02ms (-3.1%) | 🟡 |
| Worst Frame Build Time Millis | 1.89ms | 1.96ms | -0.07ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.75ms | 9.86ms | -0.10ms (-1.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.82ms | 2.77ms | +0.05ms (+1.7%) | 🟠 |
| Worst Frame Build Time Millis | 8.94ms | 8.76ms | +0.18ms (+2.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.89ms | 3.00ms | -0.11ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.53ms | +0.01ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 2.24ms | 2.53ms | -0.30ms (-11.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.52ms | 2.70ms | -0.18ms (-6.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |
| Old Gen Gc Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.54ms | -0.02ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 1.95ms | 2.55ms | -0.60ms (-23.5%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.42ms | 3.30ms | -0.88ms (-26.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.09ms | 2.01ms | +0.09ms (+4.3%) | 🟠 |
| Worst Frame Build Time Millis | 5.18ms | 4.56ms | +0.62ms (+13.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.66ms | 5.51ms | -0.85ms (-15.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.56ms | 6.52ms | +0.04ms (+0.7%) | 🟠 |
| Worst Frame Build Time Millis | 24.41ms | 27.02ms | -2.62ms (-9.7%) | 🟢 |
| Missed Frame Build Budget Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Average Frame Rasterizer Time Millis | 4.68ms | 4.73ms | -0.05ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 9.5 | +1 (+10.5%) | 🔴 |
| Old Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.50ms | 11.44ms | +0.06ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 37.25ms | 34.31ms | +2.94ms (+8.6%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.75 | +0 (+6.7%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.02ms | 5.08ms | -0.06ms (-1.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.5 | 8.0 | +0 (+6.2%) | 🟠 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.32ms | 1.25ms | +0.07ms (+5.4%) | 🟠 |
| Worst Frame Build Time Millis | 8.55ms | 8.04ms | +0.51ms (+6.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.64ms | 4.13ms | +0.51ms (+12.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.25 | 0.75 | +2 (+200.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.5 | -0 (-11.1%) | 🟢 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.30ms | 1.34ms | -0.04ms (-2.9%) | 🟡 |
| Worst Frame Build Time Millis | 7.56ms | 8.08ms | -0.51ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.64ms | 10.23ms | -2.59ms (-25.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 4.0 | 7.5 | -4 (-46.7%) | 🟢 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.06ms | 6.45ms | -0.38ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 32.76ms | 29.50ms | +3.26ms (+11.0%) | 🔴 |
| Missed Frame Build Budget Count | 4.5 | 5.25 | -1 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.17ms | 3.26ms | -0.09ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.5 | 12.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 24.79ms | 25.40ms | -0.62ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 49.67ms | 49.44ms | +0.23ms (+0.5%) | 🟠 |
| Missed Frame Build Budget Count | 10.75 | 10.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.15ms | 3.18ms | -0.03ms (-0.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 19.0 | -1 (-5.3%) | 🟢 |
| Old Gen Gc Count | 11.0 | 11.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.08ms | 1.08ms | +0.00ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 24.61ms | 19.90ms | +4.72ms (+23.7%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.52ms | 4.34ms | -0.83ms (-19.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 4.5 | -4 (-100.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.37ms | 1.30ms | +0.08ms (+5.9%) | 🟠 |
| Worst Frame Build Time Millis | 8.84ms | 7.85ms | +1.00ms (+12.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.06ms | 3.89ms | +0.17ms (+4.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.62ms | 7.99ms | +0.63ms (+7.8%) | 🟠 |
| Worst Frame Build Time Millis | 31.84ms | 29.90ms | +1.94ms (+6.5%) | 🟠 |
| Missed Frame Build Budget Count | 3.25 | 2.5 | +1 (+30.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.84ms | 5.49ms | +0.35ms (+6.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.97ms | 0.94ms | +0.03ms (+3.4%) | 🟠 |
| Worst Frame Build Time Millis | 6.55ms | 6.31ms | +0.24ms (+3.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.93ms | 6.13ms | -0.20ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.58ms | -0.28ms (-17.4%) | 🟢 |
| Worst Frame Build Time Millis | 6.38ms | 7.77ms | -1.38ms (-17.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 10.11ms | 10.56ms | -0.46ms (-4.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 6.25 | 7.0 | -1 (-10.7%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.82ms | 1.79ms | +0.02ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 2.83ms | 3.60ms | -0.78ms (-21.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.39ms | 6.23ms | +0.17ms (+2.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

