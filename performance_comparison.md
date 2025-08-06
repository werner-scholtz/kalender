## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-week-loadingEvents**: Frame build time increased by 16.4%
- 🔴 **one_event_per_day-month-navigation**: Frame build time increased by 21.2%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 16.7%
- 🔴 **one_event_per_day-week-navigation**: Frame build time increased by 17.4%
- 🔴 **one_event_per_day-month-loadingEvents**: Frame build time increased by 71.8%
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 16.0%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 12.8%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 8.7%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 11.7%
- 🟠 **ten_events_per_day-week-resizing**: Frame build time increased by 7.2%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 6.3%
- 🟠 **one_event_per_day-week-scrolling**: Frame build time increased by 11.8%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 10.4%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 7.5%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 13.5%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 12.2%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.21ms | 4.20ms | +3.01ms (+71.8%) | 🔴 |
| Worst Frame Build Time Millis | 14.28ms | 8.25ms | +6.03ms (+73.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.60ms | 2.58ms | +0.02ms (+0.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.73ms | 4.73ms | +1.00ms (+21.2%) | 🔴 |
| Worst Frame Build Time Millis | 21.40ms | 16.41ms | +4.98ms (+30.4%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 0.5 | +1 (+200.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.43ms | 3.83ms | +0.61ms (+15.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.81ms | 0.84ms | -0.03ms (-3.1%) | 🟡 |
| Worst Frame Build Time Millis | 5.00ms | 5.70ms | -0.70ms (-12.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.29ms | 4.00ms | -0.71ms (-17.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 2.75 | 0.25 | +2 (+1000.0%) | 🔴 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.69ms | 0.62ms | +0.06ms (+10.4%) | 🔴 |
| Worst Frame Build Time Millis | 4.64ms | 4.42ms | +0.23ms (+5.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.93ms | 3.93ms | -1.00ms (-25.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.12ms | 7.93ms | +0.19ms (+2.4%) | 🟠 |
| Worst Frame Build Time Millis | 22.94ms | 22.59ms | +0.35ms (+1.5%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.90ms | 2.79ms | +0.11ms (+4.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.71ms | 5.95ms | +0.76ms (+12.8%) | 🔴 |
| Worst Frame Build Time Millis | 12.46ms | 10.95ms | +1.51ms (+13.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.83ms | 3.27ms | +0.56ms (+17.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.98ms | 1.94ms | +0.04ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 27.28ms | 27.00ms | +0.28ms (+1.1%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.81ms | 3.72ms | +0.09ms (+2.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.49ms | 1.28ms | +0.21ms (+16.4%) | 🔴 |
| Worst Frame Build Time Millis | 2.86ms | 2.43ms | +0.43ms (+17.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.15ms | 1.91ms | +0.24ms (+12.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.12ms | 2.66ms | +0.46ms (+17.4%) | 🔴 |
| Worst Frame Build Time Millis | 11.78ms | 9.34ms | +2.44ms (+26.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.49ms | 3.20ms | +0.29ms (+9.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.54ms | +0.03ms (+5.0%) | 🟠 |
| Worst Frame Build Time Millis | 2.79ms | 1.96ms | +0.83ms (+42.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.90ms | 2.66ms | +0.25ms (+9.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.0 | 4.0 | -1 (-25.0%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.48ms | 0.52ms | -0.04ms (-7.7%) | 🟢 |
| Worst Frame Build Time Millis | 1.58ms | 1.64ms | -0.06ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.92ms | 2.53ms | -0.61ms (-24.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.94ms | 0.84ms | +0.10ms (+11.8%) | 🔴 |
| Worst Frame Build Time Millis | 1.81ms | 1.25ms | +0.56ms (+44.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.54ms | 3.92ms | -0.38ms (-9.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 3.5 | 2.5 | +1 (+40.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.15ms | 10.36ms | +0.78ms (+7.5%) | 🟠 |
| Worst Frame Build Time Millis | 31.49ms | 27.99ms | +3.50ms (+12.5%) | 🔴 |
| Missed Frame Build Budget Count | 8.0 | 8.5 | -0 (-5.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.81ms | 5.08ms | +0.73ms (+14.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.66ms | 11.78ms | +1.89ms (+16.0%) | 🔴 |
| Worst Frame Build Time Millis | 46.25ms | 42.56ms | +3.68ms (+8.7%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 2.75 | +1 (+45.5%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.84ms | 5.31ms | +0.53ms (+10.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 9.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.74ms | 1.72ms | +0.03ms (+1.6%) | 🟠 |
| Worst Frame Build Time Millis | 14.61ms | 14.39ms | +0.22ms (+1.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.75ms | 5.63ms | -0.88ms (-15.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.75ms | 1.50ms | +0.25ms (+16.7%) | 🔴 |
| Worst Frame Build Time Millis | 13.97ms | 12.23ms | +1.74ms (+14.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.92ms | 5.90ms | +0.02ms (+0.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.71ms | 5.37ms | +0.34ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 33.82ms | 29.58ms | +4.24ms (+14.3%) | 🔴 |
| Missed Frame Build Budget Count | 4.25 | 3.5 | +1 (+21.4%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.68ms | 3.13ms | +0.55ms (+17.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 22.50ms | 20.13ms | +2.36ms (+11.7%) | 🔴 |
| Worst Frame Build Time Millis | 46.59ms | 42.52ms | +4.07ms (+9.6%) | 🟠 |
| Missed Frame Build Budget Count | 11.0 | 9.5 | +2 (+15.8%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.84ms | 3.38ms | +0.46ms (+13.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 18.0 | +1 (+5.6%) | 🟠 |
| Old Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.92ms | 0.85ms | +0.07ms (+8.7%) | 🟠 |
| Worst Frame Build Time Millis | 14.36ms | 13.40ms | +0.96ms (+7.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.44ms | 4.27ms | +0.18ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 2.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.54ms | 2.24ms | +0.30ms (+13.5%) | 🔴 |
| Worst Frame Build Time Millis | 10.18ms | 8.52ms | +1.67ms (+19.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.90ms | 3.41ms | +0.49ms (+14.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.43ms | 8.41ms | +1.02ms (+12.2%) | 🔴 |
| Worst Frame Build Time Millis | 43.65ms | 41.89ms | +1.77ms (+4.2%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.89ms | 5.21ms | +0.68ms (+13.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.09ms | 1.12ms | -0.02ms (-2.0%) | 🟡 |
| Worst Frame Build Time Millis | 7.43ms | 5.84ms | +1.60ms (+27.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.80ms | 6.23ms | -0.43ms (-6.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 8.75 | 0.5 | +8 (+1650.0%) | 🔴 |
| New Gen Gc Count | 5.0 | 5.5 | -0 (-9.1%) | 🟢 |
| Old Gen Gc Count | 1.5 | 2.5 | -1 (-40.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.00ms | 0.93ms | +0.07ms (+7.2%) | 🟠 |
| Worst Frame Build Time Millis | 3.72ms | 3.33ms | +0.40ms (+11.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.84ms | 5.52ms | -0.68ms (-12.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.87ms | 0.87ms | -0.01ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 1.58ms | 1.20ms | +0.39ms (+32.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.52ms | 5.86ms | -0.34ms (-5.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

</details>

