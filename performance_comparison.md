## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-resizing**: Frame build time increased by 21.9%
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 17.0%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 16.1%
- 🔴 **ten_events_per_day-month-navigation**: Frame build time increased by 28.8%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 22.4%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 6.3%
- 🟠 **one_event_per_day-week-loadingEvents**: Frame build time increased by 6.5%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 7.3%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 6.9%
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 13.1%
- 🟠 **ten_events_per_day-week-scrolling**: Frame build time increased by 7.1%
- 🟠 **one_event_per_day-month-resizing**: Frame build time increased by 7.7%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 8.2%
- 🟠 **one_event_per_day-week-rescheduling**: Frame build time increased by 10.1%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 12.5%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.54ms | 4.54ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 8.95ms | 8.94ms | +0.02ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.35ms | 2.59ms | -0.25ms (-9.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.90ms | 4.98ms | -0.08ms (-1.6%) | 🟡 |
| Worst Frame Build Time Millis | 17.83ms | 17.65ms | +0.17ms (+1.0%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.25 | -0 (-20.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 3.92ms | 3.79ms | +0.13ms (+3.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.93ms | 0.79ms | +0.14ms (+17.0%) | 🔴 |
| Worst Frame Build Time Millis | 5.81ms | 4.37ms | +1.44ms (+33.1%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.46ms | 2.91ms | +1.54ms (+53.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.57ms | +0.04ms (+7.7%) | 🟠 |
| Worst Frame Build Time Millis | 3.93ms | 3.68ms | +0.25ms (+6.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.97ms | 2.59ms | +2.38ms (+91.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |
| Old Gen Gc Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.50ms | 8.94ms | -0.44ms (-4.9%) | 🟡 |
| Worst Frame Build Time Millis | 24.11ms | 25.45ms | -1.34ms (-5.3%) | 🟢 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.23ms | 2.48ms | +0.75ms (+30.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.28ms | 6.23ms | +0.05ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 10.99ms | 10.85ms | +0.14ms (+1.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.29ms | 3.31ms | -0.03ms (-0.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.08ms | 1.85ms | +0.23ms (+12.5%) | 🔴 |
| Worst Frame Build Time Millis | 28.18ms | 27.20ms | +0.98ms (+3.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.16ms | 3.10ms | +1.06ms (+34.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.31ms | 1.23ms | +0.08ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 2.50ms | 2.34ms | +0.16ms (+6.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 1.99ms | 2.00ms | -0.01ms (-0.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.80ms | 2.64ms | +0.17ms (+6.3%) | 🟠 |
| Worst Frame Build Time Millis | 9.56ms | 9.28ms | +0.28ms (+3.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.27ms | 3.16ms | +0.11ms (+3.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.62ms | 0.56ms | +0.06ms (+10.1%) | 🔴 |
| Worst Frame Build Time Millis | 3.67ms | 2.45ms | +1.21ms (+49.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.91ms | 2.28ms | +0.63ms (+27.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.55ms | 0.53ms | +0.02ms (+3.5%) | 🟠 |
| Worst Frame Build Time Millis | 1.82ms | 1.70ms | +0.12ms (+7.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.30ms | 2.10ms | +0.21ms (+9.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.00ms | 0.82ms | +0.18ms (+22.4%) | 🔴 |
| Worst Frame Build Time Millis | 1.37ms | 1.06ms | +0.31ms (+29.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.40ms | 2.70ms | +1.69ms (+62.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.95ms | 10.73ms | +0.22ms (+2.1%) | 🟠 |
| Worst Frame Build Time Millis | 31.47ms | 29.88ms | +1.59ms (+5.3%) | 🟠 |
| Missed Frame Build Budget Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.13ms | 5.28ms | -0.15ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 10.0 | +1 (+10.0%) | 🟠 |
| Old Gen Gc Count | 6.5 | 7.0 | -0 (-7.1%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 15.20ms | 11.80ms | +3.40ms (+28.8%) | 🔴 |
| Worst Frame Build Time Millis | 63.94ms | 40.13ms | +23.81ms (+59.3%) | 🔴 |
| Missed Frame Build Budget Count | 3.25 | 3.0 | +0 (+8.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 4.69ms | 5.50ms | -0.82ms (-14.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Old Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.83ms | 1.58ms | +0.25ms (+16.1%) | 🔴 |
| Worst Frame Build Time Millis | 13.84ms | 13.45ms | +0.39ms (+2.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.98ms | 4.16ms | +1.81ms (+43.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.67ms | 1.55ms | +0.13ms (+8.2%) | 🟠 |
| Worst Frame Build Time Millis | 13.68ms | 12.57ms | +1.11ms (+8.8%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.12ms | 4.36ms | +1.76ms (+40.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.41ms | 5.43ms | -0.02ms (-0.3%) | 🟡 |
| Worst Frame Build Time Millis | 28.67ms | 31.96ms | -3.29ms (-10.3%) | 🟢 |
| Missed Frame Build Budget Count | 3.75 | 3.0 | +1 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.27ms | 3.20ms | +0.07ms (+2.3%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 21.09ms | 19.73ms | +1.36ms (+6.9%) | 🟠 |
| Worst Frame Build Time Millis | 43.95ms | 41.97ms | +1.98ms (+4.7%) | 🟠 |
| Missed Frame Build Budget Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.22ms | 3.09ms | +0.13ms (+4.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.94ms | 0.88ms | +0.06ms (+7.3%) | 🟠 |
| Worst Frame Build Time Millis | 14.03ms | 13.68ms | +0.34ms (+2.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.82ms | 3.61ms | +1.21ms (+33.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.0 | +1 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.37ms | 2.29ms | +0.08ms (+3.6%) | 🟠 |
| Worst Frame Build Time Millis | 8.78ms | 8.57ms | +0.21ms (+2.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.47ms | 3.42ms | +0.05ms (+1.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.91ms | 8.83ms | +0.09ms (+1.0%) | 🟠 |
| Worst Frame Build Time Millis | 42.95ms | 44.49ms | -1.53ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.52ms | 5.37ms | +0.15ms (+2.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.21ms | 1.07ms | +0.14ms (+13.1%) | 🔴 |
| Worst Frame Build Time Millis | 6.71ms | 6.52ms | +0.19ms (+2.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.49ms | 4.89ms | +1.60ms (+32.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.05ms | 0.86ms | +0.19ms (+21.9%) | 🔴 |
| Worst Frame Build Time Millis | 3.82ms | 3.17ms | +0.65ms (+20.5%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.15ms | 4.58ms | +1.57ms (+34.3%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.91ms | 0.85ms | +0.06ms (+7.1%) | 🟠 |
| Worst Frame Build Time Millis | 1.37ms | 1.67ms | -0.30ms (-18.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.85ms | 5.36ms | +0.49ms (+9.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

</details>

