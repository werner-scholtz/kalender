## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 16.5%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 17.7%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 75.5%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 18.5%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 6.4%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 9.8%
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 8.1%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 13.6%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 11.1%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 7.3%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 7.4%
- 🟠 **ten_events_per_day-month-rescheduling**: Frame build time increased by 6.4%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 7.3%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 22.5%
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 20.9%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 29.4%
- 🟢 **one_event_per_day-schedule-loadingEvents**: Frame build time improved by 11.7%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.22ms | 4.12ms | +3.11ms (+75.5%) | 🔴 |
| Worst Frame Build Time Millis | 14.33ms | 8.10ms | +6.23ms (+76.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.15ms | 2.23ms | -0.08ms (-3.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.10ms | 4.72ms | +0.38ms (+8.1%) | 🟠 |
| Worst Frame Build Time Millis | 18.24ms | 17.53ms | +0.71ms (+4.0%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 0.75 | +0 (+66.7%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.76ms | 3.75ms | +0.01ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.5 | 4.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.94ms | -0.21ms (-22.5%) | 🟢 |
| Worst Frame Build Time Millis | 4.11ms | 7.20ms | -3.08ms (-42.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.91ms | 4.79ms | -0.88ms (-18.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 3.25 | -3 (-92.3%) | 🟢 |
| New Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 3.75 | -2 (-46.7%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.62ms | -0.02ms (-3.8%) | 🟡 |
| Worst Frame Build Time Millis | 4.04ms | 3.74ms | +0.31ms (+8.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.49ms | 3.84ms | -0.35ms (-9.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.21ms | 8.17ms | -0.96ms (-11.7%) | 🟢 |
| Worst Frame Build Time Millis | 20.55ms | 23.48ms | -2.93ms (-12.5%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.61ms | 2.60ms | +0.01ms (+0.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.82ms | 6.00ms | +0.82ms (+13.6%) | 🔴 |
| Worst Frame Build Time Millis | 16.03ms | 10.72ms | +5.31ms (+49.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.31ms | 3.21ms | +0.10ms (+3.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.75 | 2.5 | +0 (+10.0%) | 🟠 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.82ms | 1.91ms | -0.08ms (-4.4%) | 🟡 |
| Worst Frame Build Time Millis | 24.61ms | 24.41ms | +0.20ms (+0.8%) | 🟠 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.35ms | 4.95ms | -1.60ms (-32.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 9.0 | 8.0 | +1 (+12.5%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.25ms | 1.21ms | +0.03ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 2.36ms | 2.30ms | +0.07ms (+2.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.24ms | 2.15ms | +0.10ms (+4.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.01ms | 2.83ms | +0.18ms (+6.4%) | 🟠 |
| Worst Frame Build Time Millis | 9.74ms | 9.32ms | +0.42ms (+4.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.60ms | 3.56ms | +0.04ms (+1.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.64ms | 0.60ms | +0.04ms (+7.4%) | 🟠 |
| Worst Frame Build Time Millis | 3.02ms | 2.43ms | +0.59ms (+24.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.95ms | 3.05ms | +0.90ms (+29.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 3.5 | +0 (+14.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.59ms | 0.84ms | -0.25ms (-29.4%) | 🟢 |
| Worst Frame Build Time Millis | 2.36ms | 4.72ms | -2.36ms (-50.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.10ms | 5.39ms | -2.29ms (-42.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 0.5 | 1.5 | -1 (-66.7%) | 🟢 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.93ms | 1.91ms | +0.03ms (+1.3%) | 🟠 |
| Worst Frame Build Time Millis | 3.75ms | 4.82ms | -1.08ms (-22.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.78ms | 5.21ms | -0.43ms (-8.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.58ms | 10.37ms | +0.21ms (+2.1%) | 🟠 |
| Worst Frame Build Time Millis | 29.73ms | 28.17ms | +1.56ms (+5.5%) | 🟠 |
| Missed Frame Build Budget Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.04ms | 5.22ms | -0.18ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 12.0 | -2 (-12.5%) | 🟢 |
| Old Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.96ms | 11.67ms | +0.29ms (+2.5%) | 🟠 |
| Worst Frame Build Time Millis | 42.29ms | 42.13ms | +0.16ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.93ms | 5.15ms | -0.22ms (-4.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.83ms | 1.72ms | +0.11ms (+6.4%) | 🟠 |
| Worst Frame Build Time Millis | 14.40ms | 13.28ms | +1.12ms (+8.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.34ms | 7.04ms | +1.30ms (+18.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 1.5 | +2 (+133.3%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.07ms | 1.76ms | +0.31ms (+17.7%) | 🔴 |
| Worst Frame Build Time Millis | 19.40ms | 15.11ms | +4.30ms (+28.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 8.80ms | 8.61ms | +0.19ms (+2.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 0.0 | +2 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.56ms | 5.07ms | +0.49ms (+9.8%) | 🟠 |
| Worst Frame Build Time Millis | 27.37ms | 27.26ms | +0.10ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 3.25 | 2.25 | +1 (+44.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.21ms | 3.13ms | +0.08ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 10.5 | +4 (+33.3%) | 🔴 |
| Old Gen Gc Count | 7.5 | 5.5 | +2 (+36.4%) | 🔴 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 20.92ms | 19.49ms | +1.43ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 43.57ms | 41.54ms | +2.03ms (+4.9%) | 🟠 |
| Missed Frame Build Budget Count | 9.5 | 8.75 | +1 (+8.6%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.07ms | 3.38ms | -0.31ms (-9.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 18.5 | +2 (+8.1%) | 🟠 |
| Old Gen Gc Count | 10.0 | 10.5 | -0 (-4.8%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 0.87ms | +0.16ms (+18.5%) | 🔴 |
| Worst Frame Build Time Millis | 21.57ms | 13.40ms | +8.17ms (+61.0%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.48ms | 5.27ms | +0.21ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 5.0 | 2.25 | +3 (+122.2%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 3.0 | +2 (+83.3%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.45ms | 2.20ms | +0.24ms (+11.1%) | 🔴 |
| Worst Frame Build Time Millis | 10.14ms | 8.38ms | +1.76ms (+21.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.99ms | 3.75ms | +0.25ms (+6.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 2.5 | +0 (+20.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 1.5 | +2 (+100.0%) | 🔴 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.62ms | 8.39ms | +0.23ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 36.17ms | 37.40ms | -1.23ms (-3.3%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.83ms | 5.60ms | +0.23ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.27ms | 1.18ms | +0.09ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 6.14ms | 6.10ms | +0.04ms (+0.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.94ms | 8.32ms | +0.62ms (+7.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 8.0 | 4.75 | +3 (+68.4%) | 🔴 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.11ms | 1.41ms | -0.29ms (-20.9%) | 🟢 |
| Worst Frame Build Time Millis | 4.57ms | 8.19ms | -3.61ms (-44.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.67ms | 10.20ms | -2.53ms (-24.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 5.75 | -6 (-100.0%) | 🟢 |
| New Gen Gc Count | 0.5 | 2.0 | -2 (-75.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 2.0 | -1 (-50.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.02ms | 1.73ms | +0.29ms (+16.5%) | 🔴 |
| Worst Frame Build Time Millis | 6.37ms | 4.61ms | +1.76ms (+38.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.57ms | 6.77ms | -0.21ms (-3.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.25 | -0 (-100.0%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

