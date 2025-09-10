## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **one_event_per_day-month-rescheduling**: Frame build time increased by 17.5%
- 🔴 **ten_events_per_day-week-rescheduling**: Frame build time increased by 23.0%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 18.7%
- 🔴 **one_event_per_day-month-resizing**: Frame build time increased by 16.2%
- 🔴 **one_event_per_day-week-resizing**: Frame build time increased by 36.5%
- 🔴 **ten_events_per_day-month-rescheduling**: Frame build time increased by 20.4%
- 🔴 **one_event_per_day-week-scrolling**: Frame build time increased by 20.2%

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-month-navigation**: Frame build time increased by 8.1%
- 🟠 **one_event_per_day-schedule-rescheduling**: Frame build time increased by 11.8%
- 🟠 **ten_events_per_day-month-loadingEvents**: Frame build time increased by 10.9%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 9.3%
- 🟠 **ten_events_per_day-schedule-navigation**: Frame build time increased by 10.3%
- 🟠 **ten_events_per_day-week-loadingEvents**: Frame build time increased by 5.7%
- 🟠 **ten_events_per_day-month-navigation**: Frame build time increased by 10.2%
- 🟠 **one_event_per_day-week-navigation**: Frame build time increased by 8.9%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 10.2%
- 🟠 **one_event_per_day-schedule-navigation**: Frame build time increased by 5.7%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 5.3%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.14ms | 4.03ms | +0.11ms (+2.7%) | 🟠 |
| Worst Frame Build Time Millis | 8.15ms | 7.94ms | +0.21ms (+2.7%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.38ms | 2.65ms | -0.28ms (-10.4%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.70ms | 4.35ms | +0.35ms (+8.1%) | 🟠 |
| Worst Frame Build Time Millis | 18.96ms | 16.12ms | +2.85ms (+17.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.75 | 0.5 | +0 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.89ms | 3.82ms | +0.08ms (+2.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.72ms | 0.61ms | +0.11ms (+17.5%) | 🔴 |
| Worst Frame Build Time Millis | 4.66ms | 4.56ms | +0.10ms (+2.1%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.57ms | 3.73ms | -0.17ms (-4.4%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 3.25 | -3 (-92.3%) | 🟢 |
| New Gen Gc Count | 3.5 | 3.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 3.0 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.48ms | +0.08ms (+16.2%) | 🔴 |
| Worst Frame Build Time Millis | 3.57ms | 3.03ms | +0.54ms (+17.8%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.77ms | 2.41ms | +1.36ms (+56.6%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.07ms | 8.91ms | +0.16ms (+1.8%) | 🟠 |
| Worst Frame Build Time Millis | 25.85ms | 25.30ms | +0.55ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.94ms | 2.93ms | +0.01ms (+0.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.75 | 1.5 | +0 (+16.7%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.84ms | 6.48ms | +0.37ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 14.21ms | 12.85ms | +1.36ms (+10.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.36ms | 3.34ms | +0.02ms (+0.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.24ms | 2.00ms | +0.24ms (+11.8%) | 🔴 |
| Worst Frame Build Time Millis | 30.71ms | 27.97ms | +2.74ms (+9.8%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.98ms | 4.58ms | +0.40ms (+8.8%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 4.25 | 4.5 | -0 (-5.6%) | 🟢 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.21ms | +0.03ms (+2.2%) | 🟠 |
| Worst Frame Build Time Millis | 2.33ms | 2.30ms | +0.03ms (+1.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.11ms | 1.98ms | +0.13ms (+6.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 3.06ms | 2.81ms | +0.25ms (+8.9%) | 🟠 |
| Worst Frame Build Time Millis | 10.10ms | 9.62ms | +0.48ms (+5.0%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.48ms | 3.36ms | +0.12ms (+3.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.70ms | 0.59ms | +0.11ms (+18.7%) | 🔴 |
| Worst Frame Build Time Millis | 6.84ms | 4.56ms | +2.28ms (+50.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.76ms | 3.46ms | +0.30ms (+8.7%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.25 | 4.25 | -3 (-70.6%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 3.0 | -0 (-16.7%) | 🟢 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.76ms | 0.56ms | +0.20ms (+36.5%) | 🔴 |
| Worst Frame Build Time Millis | 4.05ms | 1.94ms | +2.12ms (+109.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.73ms | 3.57ms | +1.17ms (+32.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 1.5 | 0.0 | +2 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.88ms | 1.57ms | +0.32ms (+20.2%) | 🔴 |
| Worst Frame Build Time Millis | 3.67ms | 3.65ms | +0.02ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.12ms | 4.46ms | -0.35ms (-7.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 5.5 | 4.5 | +1 (+22.2%) | 🔴 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.47ms | 9.44ms | +1.03ms (+10.9%) | 🔴 |
| Worst Frame Build Time Millis | 29.43ms | 26.14ms | +3.30ms (+12.6%) | 🔴 |
| Missed Frame Build Budget Count | 7.25 | 7.75 | -0 (-6.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.33ms | 4.69ms | +0.63ms (+13.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 10.0 | +0 (+5.0%) | 🟠 |
| Old Gen Gc Count | 8.0 | 6.5 | +2 (+23.1%) | 🔴 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.86ms | 9.85ms | +1.00ms (+10.2%) | 🔴 |
| Worst Frame Build Time Millis | 46.24ms | 42.09ms | +4.15ms (+9.9%) | 🟠 |
| Missed Frame Build Budget Count | 2.5 | 2.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 5.13ms | 4.76ms | +0.38ms (+7.9%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 7.0 | 6.0 | +1 (+16.7%) | 🔴 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.62ms | 1.34ms | +0.27ms (+20.4%) | 🔴 |
| Worst Frame Build Time Millis | 19.92ms | 19.75ms | +0.18ms (+0.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.75 | 1.0 | -0 (-25.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.10ms | 4.33ms | +0.77ms (+17.7%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.46ms | 1.39ms | +0.07ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 12.08ms | 13.77ms | -1.70ms (-12.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.85ms | 5.28ms | +2.57ms (+48.8%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.0 | 1.0 | +3 (+300.0%) | 🔴 |
| New Gen Gc Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.04ms | 5.53ms | +0.52ms (+9.3%) | 🟠 |
| Worst Frame Build Time Millis | 32.47ms | 28.00ms | +4.47ms (+16.0%) | 🔴 |
| Missed Frame Build Budget Count | 4.5 | 4.25 | +0 (+5.9%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.22ms | 3.09ms | +0.13ms (+4.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.5 | 12.0 | +0 (+4.2%) | 🟠 |
| Old Gen Gc Count | 6.0 | 5.5 | +0 (+9.1%) | 🟠 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.03ms | 20.88ms | +2.15ms (+10.3%) | 🔴 |
| Worst Frame Build Time Millis | 42.30ms | 46.66ms | -4.36ms (-9.3%) | 🟢 |
| Missed Frame Build Budget Count | 10.5 | 10.25 | +0 (+2.4%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.34ms | 3.11ms | +0.22ms (+7.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 19.0 | 19.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.00ms | 0.91ms | +0.09ms (+10.2%) | 🔴 |
| Worst Frame Build Time Millis | 18.59ms | 17.60ms | +0.99ms (+5.6%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 0.5 | +0 (+100.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 4.65ms | 4.58ms | +0.07ms (+1.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 1.0 | 3.0 | -2 (-66.7%) | 🟢 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.5 | 4.5 | -1 (-22.2%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.23ms | 2.11ms | +0.12ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 8.56ms | 7.83ms | +0.74ms (+9.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.85ms | 3.63ms | +0.22ms (+6.2%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.75ms | 8.53ms | +0.22ms (+2.6%) | 🟠 |
| Worst Frame Build Time Millis | 38.81ms | 37.60ms | +1.22ms (+3.2%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.56ms | 5.72ms | -0.15ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.20ms | 0.98ms | +0.22ms (+23.0%) | 🔴 |
| Worst Frame Build Time Millis | 6.63ms | 6.28ms | +0.35ms (+5.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.35ms | 6.54ms | -0.19ms (-3.0%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 6.75 | 3.5 | +3 (+92.9%) | 🔴 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.14ms | 1.13ms | +0.01ms (+0.8%) | 🟠 |
| Worst Frame Build Time Millis | 5.38ms | 5.71ms | -0.34ms (-5.9%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.89ms | 6.46ms | +1.42ms (+22.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 4.0 | 1.25 | +3 (+220.0%) | 🔴 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 2.0 | -0 (-25.0%) | 🟢 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.59ms | 1.70ms | -0.11ms (-6.5%) | 🟢 |
| Worst Frame Build Time Millis | 2.30ms | 4.93ms | -2.63ms (-53.4%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.16ms | 5.55ms | +0.62ms (+11.1%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

</details>

