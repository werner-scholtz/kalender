## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 58.4%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 16.3%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 18.4%
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 20.7%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 21.8%
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 40.0%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 33.3%
- 🔴 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 21.4%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 16.9%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 24.3%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 8.2%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 11.4%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 12.0%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 5.8%
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 10.6%
- 🟠 **ten_events_per_day-week-navigation**: Frame build time increased by 6.7%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 13.4%
- 🟠 **one_event_per_day-month-loadingEvents**: Frame build time increased by 7.4%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.41ms | 4.10ms | +0.30ms (+7.4%) | 🟠 |
| Worst Frame Build Time Millis | 8.64ms | 8.09ms | +0.55ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.96ms | 2.61ms | -0.65ms (-24.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.35ms | 5.49ms | -0.14ms (-2.5%) | 🟡 |
| Worst Frame Build Time Millis | 19.00ms | 21.00ms | -2.00ms (-9.5%) | 🟢 |
| Missed Frame Build Budget Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.18ms | 3.68ms | +0.49ms (+13.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 4.0 | +1 (+25.0%) | 🔴 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.88ms | 0.73ms | +0.15ms (+20.7%) | 🔴 |
| Worst Frame Build Time Millis | 7.37ms | 4.93ms | +2.44ms (+49.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.60ms | 3.04ms | +0.56ms (+18.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.75 | 0.25 | +0 (+200.0%) | 🔴 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.5 | -0 (-14.3%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.67ms | 0.57ms | +0.10ms (+16.9%) | 🔴 |
| Worst Frame Build Time Millis | 5.60ms | 4.04ms | +1.57ms (+38.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.68ms | 2.39ms | +1.28ms (+53.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.31ms | 8.41ms | +4.91ms (+58.4%) | 🔴 |
| Worst Frame Build Time Millis | 38.77ms | 23.95ms | +14.82ms (+61.9%) | 🔴 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.83ms | 2.94ms | -0.11ms (-3.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.91ms | 6.91ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 13.78ms | 16.23ms | -2.46ms (-15.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.25 | 0.5 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.58ms | 3.23ms | +0.35ms (+10.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.94ms | 1.84ms | +0.11ms (+5.8%) | 🟠 |
| Worst Frame Build Time Millis | 24.34ms | 25.20ms | -0.87ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.58ms | 3.88ms | -0.30ms (-7.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 3.0 | -3 (-100.0%) | 🟢 |
| New Gen Gc Count | 10.0 | 9.0 | +1 (+11.1%) | 🔴 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.33ms | 1.19ms | +0.14ms (+12.0%) | 🔴 |
| Worst Frame Build Time Millis | 2.51ms | 2.26ms | +0.25ms (+11.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.70ms | 2.22ms | +0.48ms (+21.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.29ms | 2.97ms | +0.32ms (+10.6%) | 🔴 |
| Worst Frame Build Time Millis | 11.73ms | 9.84ms | +1.89ms (+19.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.87ms | 3.45ms | +0.41ms (+12.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 6.0 | -1 (-16.7%) | 🟢 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.53ms | +0.18ms (+33.3%) | 🔴 |
| Worst Frame Build Time Millis | 4.07ms | 2.71ms | +1.36ms (+50.3%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.55ms | 2.53ms | +1.03ms (+40.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 2.5 | +2 (+60.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.71ms | 0.57ms | +0.14ms (+24.3%) | 🔴 |
| Worst Frame Build Time Millis | 3.60ms | 2.81ms | +0.78ms (+27.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.30ms | 2.25ms | +2.05ms (+90.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.10ms | 1.77ms | +0.33ms (+18.4%) | 🔴 |
| Worst Frame Build Time Millis | 4.33ms | 4.13ms | +0.21ms (+5.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.38ms | 4.39ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.98ms | 10.15ms | +0.83ms (+8.2%) | 🟠 |
| Worst Frame Build Time Millis | 31.82ms | 27.07ms | +4.75ms (+17.5%) | 🔴 |
| Missed Frame Build Budget Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.24ms | 5.14ms | +0.10ms (+2.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 13.19ms | 11.84ms | +1.35ms (+11.4%) | 🔴 |
| Worst Frame Build Time Millis | 43.81ms | 43.19ms | +0.62ms (+1.4%) | 🟠 |
| Missed Frame Build Budget Count | 4.0 | 3.0 | +1 (+33.3%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.24ms | 5.00ms | +0.24ms (+4.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.95ms | 1.60ms | +0.35ms (+21.8%) | 🔴 |
| Worst Frame Build Time Millis | 15.71ms | 13.61ms | +2.10ms (+15.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.56ms | 5.82ms | +0.73ms (+12.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 5.25 | 6.25 | -1 (-16.0%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.02ms | 1.98ms | +0.04ms (+1.9%) | 🟠 |
| Worst Frame Build Time Millis | 18.44ms | 20.25ms | -1.82ms (-9.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.75 | 0.75 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.69ms | 5.28ms | +1.40ms (+26.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.74ms | 5.60ms | +0.14ms (+2.6%) | 🟠 |
| Worst Frame Build Time Millis | 27.39ms | 28.08ms | -0.68ms (-2.4%) | 🟡 |
| Missed Frame Build Budget Count | 4.0 | 4.25 | -0 (-5.9%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.64ms | 3.27ms | +0.37ms (+11.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.5 | 7.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.41ms | 21.29ms | +0.12ms (+0.5%) | 🟠 |
| Worst Frame Build Time Millis | 42.61ms | 42.00ms | +0.61ms (+1.4%) | 🟠 |
| Missed Frame Build Budget Count | 10.5 | 10.5 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.34ms | 3.32ms | +0.02ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 20.0 | 17.5 | +2 (+14.3%) | 🔴 |
| Old Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.10ms | 0.90ms | +0.19ms (+21.4%) | 🔴 |
| Worst Frame Build Time Millis | 23.07ms | 18.30ms | +4.77ms (+26.1%) | 🔴 |
| Missed Frame Build Budget Count | 1.5 | 0.75 | +1 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.25ms | 3.42ms | +1.82ms (+53.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 2.0 | 1.75 | +0 (+14.3%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.31ms | 2.48ms | -0.17ms (-7.0%) | 🟢 |
| Worst Frame Build Time Millis | 8.95ms | 9.94ms | -1.00ms (-10.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.92ms | 3.97ms | -0.05ms (-1.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.5 | 3.5 | -1 (-28.6%) | 🟢 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.21ms | 8.63ms | +0.58ms (+6.7%) | 🟠 |
| Worst Frame Build Time Millis | 38.38ms | 35.56ms | +2.82ms (+7.9%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.87ms | 5.55ms | +0.32ms (+5.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 8.0 | 7.0 | +1 (+14.3%) | 🔴 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.17ms | 1.01ms | +0.17ms (+16.3%) | 🔴 |
| Worst Frame Build Time Millis | 6.22ms | 4.88ms | +1.34ms (+27.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.91ms | 5.68ms | +0.22ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 3.5 | 7.0 | -4 (-50.0%) | 🟢 |
| New Gen Gc Count | 5.5 | 5.0 | +0 (+10.0%) | 🟠 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.24ms | 0.89ms | +0.35ms (+40.0%) | 🔴 |
| Worst Frame Build Time Millis | 5.96ms | 3.95ms | +2.01ms (+50.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.83ms | 4.58ms | +3.25ms (+70.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 3.5 | 0.0 | +4 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.71ms | 1.51ms | +0.20ms (+13.4%) | 🔴 |
| Worst Frame Build Time Millis | 3.24ms | 2.90ms | +0.34ms (+11.9%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.16ms | 5.93ms | +0.23ms (+3.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.0 | +0 (+50.0%) | 🔴 |

</details>

