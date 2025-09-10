## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 7.5%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-rescheduling**: Frame build time improved by 11.3%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 13.1%
- 🟢 **one_event_per_day-week-resizing**: Frame build time improved by 27.3%
- 🟢 **one_event_per_day-month-rescheduling**: Frame build time improved by 14.4%
- 🟢 **ten_events_per_day-schedule-loadingEvents**: Frame build time improved by 12.3%
- 🟢 **ten_events_per_day-week-navigation**: Frame build time improved by 10.3%
- 🟢 **one_event_per_day-week-rescheduling**: Frame build time improved by 19.3%
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 10.6%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.04ms | 4.14ms | -0.10ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 7.93ms | 8.15ms | -0.22ms (-2.7%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.69ms | 2.38ms | +0.31ms (+13.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.27ms | 4.70ms | -0.43ms (-9.2%) | 🟢 |
| Worst Frame Build Time Millis | 17.30ms | 18.96ms | -1.66ms (-8.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.63ms | 3.89ms | -0.27ms (-6.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.72ms | -0.10ms (-14.4%) | 🟢 |
| Worst Frame Build Time Millis | 4.45ms | 4.66ms | -0.21ms (-4.6%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.11ms | 3.57ms | +0.54ms (+15.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.75 | 0.25 | +4 (+1400.0%) | 🔴 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.51ms | 0.56ms | -0.04ms (-7.5%) | 🟢 |
| Worst Frame Build Time Millis | 3.31ms | 3.57ms | -0.27ms (-7.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.95ms | 3.77ms | -0.82ms (-21.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.67ms | 9.07ms | -0.40ms (-4.4%) | 🟡 |
| Worst Frame Build Time Millis | 24.64ms | 25.85ms | -1.21ms (-4.7%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.23ms | 2.94ms | +0.29ms (+9.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.75 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.38ms | 6.84ms | -0.46ms (-6.8%) | 🟢 |
| Worst Frame Build Time Millis | 12.88ms | 14.21ms | -1.33ms (-9.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.24ms | 3.36ms | -0.12ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.25 | 2.0 | +0 (+12.5%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.01ms | 2.24ms | -0.24ms (-10.6%) | 🟢 |
| Worst Frame Build Time Millis | 29.36ms | 30.71ms | -1.35ms (-4.4%) | 🟡 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.23ms | 4.98ms | +0.24ms (+4.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 6.0 | 4.25 | +2 (+41.2%) | 🔴 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.23ms | -0.00ms (-0.3%) | 🟡 |
| Worst Frame Build Time Millis | 2.32ms | 2.33ms | -0.01ms (-0.5%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.22ms | 2.11ms | +0.11ms (+5.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.87ms | 3.06ms | -0.19ms (-6.1%) | 🟢 |
| Worst Frame Build Time Millis | 10.09ms | 10.10ms | -0.01ms (-0.1%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.33ms | 3.48ms | -0.15ms (-4.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.70ms | -0.14ms (-19.3%) | 🟢 |
| Worst Frame Build Time Millis | 2.57ms | 6.84ms | -4.27ms (-62.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.84ms | 3.76ms | +0.08ms (+2.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 1.25 | -0 (-40.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.76ms | -0.21ms (-27.3%) | 🟢 |
| Worst Frame Build Time Millis | 2.20ms | 4.05ms | -1.86ms (-45.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.82ms | 4.73ms | -1.91ms (-40.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.5 | -2 (-100.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.77ms | 1.88ms | -0.11ms (-5.9%) | 🟢 |
| Worst Frame Build Time Millis | 3.94ms | 3.67ms | +0.27ms (+7.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.40ms | 4.12ms | +0.28ms (+6.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.59ms | 10.47ms | -0.87ms (-8.3%) | 🟢 |
| Worst Frame Build Time Millis | 26.49ms | 29.43ms | -2.95ms (-10.0%) | 🟢 |
| Missed Frame Build Budget Count | 7.5 | 7.25 | +0 (+3.4%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.05ms | 5.33ms | -0.28ms (-5.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.5 | -0 (-4.8%) | 🟡 |
| Old Gen Gc Count | 7.5 | 8.0 | -0 (-6.2%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.87ms | 10.86ms | -0.98ms (-9.1%) | 🟢 |
| Worst Frame Build Time Millis | 42.28ms | 46.24ms | -3.96ms (-8.6%) | 🟢 |
| Missed Frame Build Budget Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.75ms | 5.13ms | -0.38ms (-7.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.62ms | -0.21ms (-13.1%) | 🟢 |
| Worst Frame Build Time Millis | 18.07ms | 19.92ms | -1.86ms (-9.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 0.75 | +0 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 6.12ms | 5.10ms | +1.02ms (+20.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.40ms | 1.46ms | -0.06ms (-4.1%) | 🟡 |
| Worst Frame Build Time Millis | 12.36ms | 12.08ms | +0.28ms (+2.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.27ms | 7.85ms | +0.42ms (+5.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 4.0 | -4 (-87.5%) | 🟢 |
| New Gen Gc Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.30ms | 6.04ms | -0.75ms (-12.3%) | 🟢 |
| Worst Frame Build Time Millis | 25.75ms | 32.47ms | -6.72ms (-20.7%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 4.5 | -1 (-22.2%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.14ms | 3.22ms | -0.09ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.5 | -0 (-4.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.65ms | 23.03ms | -1.38ms (-6.0%) | 🟢 |
| Worst Frame Build Time Millis | 41.07ms | 42.30ms | -1.23ms (-2.9%) | 🟡 |
| Missed Frame Build Budget Count | 9.0 | 10.5 | -2 (-14.3%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.03ms | 3.34ms | -0.31ms (-9.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 19.0 | -1 (-5.3%) | 🟢 |
| Old Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.90ms | 1.00ms | -0.10ms (-9.9%) | 🟢 |
| Worst Frame Build Time Millis | 16.95ms | 18.59ms | -1.64ms (-8.8%) | 🟢 |
| Missed Frame Build Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.75ms | 4.65ms | +1.10ms (+23.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 1.0 | +2 (+250.0%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.5 | 3.5 | +1 (+28.6%) | 🔴 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.07ms | 2.23ms | -0.17ms (-7.4%) | 🟢 |
| Worst Frame Build Time Millis | 7.68ms | 8.56ms | -0.89ms (-10.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.63ms | 3.85ms | -0.23ms (-5.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.85ms | 8.75ms | -0.90ms (-10.3%) | 🟢 |
| Worst Frame Build Time Millis | 35.13ms | 38.81ms | -3.69ms (-9.5%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.08ms | 5.56ms | -0.48ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.07ms | 1.20ms | -0.14ms (-11.3%) | 🟢 |
| Worst Frame Build Time Millis | 8.66ms | 6.63ms | +2.03ms (+30.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.24ms | 6.35ms | +0.89ms (+14.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.0 | 6.75 | -2 (-25.9%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.22ms | 1.14ms | +0.09ms (+7.5%) | 🟠 |
| Worst Frame Build Time Millis | 5.89ms | 5.38ms | +0.51ms (+9.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 8.88ms | 7.89ms | +1.00ms (+12.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 4.0 | -0 (-12.5%) | 🟢 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.64ms | 1.59ms | +0.06ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 3.78ms | 2.30ms | +1.48ms (+64.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.67ms | 6.16ms | +0.51ms (+8.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

