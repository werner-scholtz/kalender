## 📋 Summary

**⚠️ Critical Performance Issues:**
- 🔴 **ten_events_per_day-week-scrolling**: Frame build time increased by 21.1%
- 🔴 **one_event_per_day-week-rescheduling**: Frame build time increased by 20.3%
- 🔴 **ten_events_per_day-month-resizing**: Frame build time increased by 26.2%

**🟠 Minor Performance Regressions:**
- 🟠 **ten_events_per_day-week-rescheduling**: Frame build time increased by 6.1%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 5.6%
- 🟠 **ten_events_per_day-schedule-rescheduling**: Frame build time increased by 6.5%

**✅ Performance Improvements:**
- 🟢 **one_event_per_day-schedule-rescheduling**: Frame build time improved by 10.9%
- 🟢 **ten_events_per_day-month-rescheduling**: Frame build time improved by 14.8%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.35ms | 2.51ms | -0.16ms (-6.3%) | 🟢 |
| Worst Frame Build Time Millis | 5.60ms | 6.10ms | -0.50ms (-8.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.74ms | 4.17ms | -0.43ms (-10.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.74ms | 4.87ms | -0.14ms (-2.8%) | 🟡 |
| Worst Frame Build Time Millis | 14.54ms | 15.28ms | -0.75ms (-4.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.5 | -0 (-100.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 4.94ms | 4.98ms | -0.03ms (-0.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 4.0 | 2.0 | +2 (+100.0%) | 🔴 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.61ms | 0.62ms | -0.01ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 3.26ms | 3.90ms | -0.65ms (-16.6%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.58ms | 4.71ms | -0.14ms (-2.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 1.0 | 0.25 | +1 (+300.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.46ms | 0.47ms | -0.01ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 2.14ms | 2.14ms | +0.00ms (+0.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.86ms | 3.79ms | +0.08ms (+2.1%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 9.11ms | 8.63ms | +0.48ms (+5.6%) | 🟠 |
| Worst Frame Build Time Millis | 25.94ms | 24.49ms | +1.45ms (+5.9%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.54ms | 3.95ms | +0.59ms (+15.0%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 3.0 | -1 (-33.3%) | 🟢 |
| Old Gen Gc Count | 2.0 | 1.5 | +0 (+33.3%) | 🔴 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.45ms | 6.54ms | -0.08ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 12.85ms | 13.30ms | -0.45ms (-3.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.22ms | 5.14ms | +0.08ms (+1.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 5.0 | +1 (+20.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.03ms | 2.27ms | -0.25ms (-10.9%) | 🟢 |
| Worst Frame Build Time Millis | 27.12ms | 28.90ms | -1.78ms (-6.1%) | 🟢 |
| Missed Frame Build Budget Count | 1.75 | 2.0 | -0 (-12.5%) | 🟢 |
| Average Frame Rasterizer Time Millis | 5.61ms | 6.47ms | -0.85ms (-13.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 1.25 | 4.0 | -3 (-68.8%) | 🟢 |
| New Gen Gc Count | 7.5 | 7.0 | +0 (+7.1%) | 🟠 |
| Old Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.73ms | 0.72ms | +0.00ms (+0.2%) | 🟠 |
| Worst Frame Build Time Millis | 1.90ms | 1.89ms | +0.01ms (+0.4%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 14.16ms | 14.24ms | -0.08ms (-0.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.64ms | 2.67ms | -0.03ms (-1.2%) | 🟡 |
| Worst Frame Build Time Millis | 8.80ms | 9.33ms | -0.53ms (-5.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.91ms | 4.02ms | -0.10ms (-2.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.63ms | 0.52ms | +0.11ms (+20.3%) | 🔴 |
| Worst Frame Build Time Millis | 4.73ms | 3.15ms | +1.58ms (+50.2%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.97ms | 4.67ms | +0.30ms (+6.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.75 | 2.75 | -2 (-72.7%) | 🟢 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.49ms | 0.51ms | -0.01ms (-2.6%) | 🟡 |
| Worst Frame Build Time Millis | 1.92ms | 2.10ms | -0.18ms (-8.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.50ms | 3.48ms | +0.02ms (+0.6%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.69ms | 1.75ms | -0.07ms (-3.8%) | 🟡 |
| Worst Frame Build Time Millis | 4.12ms | 4.34ms | -0.22ms (-5.1%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.72ms | 5.81ms | -0.09ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.58ms | 6.56ms | +0.02ms (+0.4%) | 🟠 |
| Worst Frame Build Time Millis | 24.43ms | 23.27ms | +1.16ms (+5.0%) | 🟠 |
| Missed Frame Build Budget Count | 6.25 | 6.5 | -0 (-3.8%) | 🟡 |
| Average Frame Rasterizer Time Millis | 6.73ms | 6.88ms | -0.15ms (-2.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 11.0 | 10.5 | +0 (+4.8%) | 🟠 |
| Old Gen Gc Count | 6.5 | 7.5 | -1 (-13.3%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.93ms | 11.68ms | -0.76ms (-6.5%) | 🟢 |
| Worst Frame Build Time Millis | 32.17ms | 35.44ms | -3.27ms (-9.2%) | 🟢 |
| Missed Frame Build Budget Count | 3.5 | 3.75 | -0 (-6.7%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.12ms | 7.28ms | -0.17ms (-2.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.5 | -2 (-15.8%) | 🟢 |
| Old Gen Gc Count | 6.0 | 7.5 | -2 (-20.0%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.44ms | -0.21ms (-14.8%) | 🟢 |
| Worst Frame Build Time Millis | 8.25ms | 11.50ms | -3.25ms (-28.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 7.11ms | 8.20ms | -1.09ms (-13.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 13.25 | -13 (-100.0%) | 🟢 |
| New Gen Gc Count | 4.0 | 5.5 | -2 (-27.3%) | 🟢 |
| Old Gen Gc Count | 0.0 | 3.0 | -3 (-100.0%) | 🟢 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.36ms | 1.08ms | +0.28ms (+26.2%) | 🔴 |
| Worst Frame Build Time Millis | 10.18ms | 6.95ms | +3.23ms (+46.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 12.64ms | 6.17ms | +6.47ms (+104.9%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 7.5 | 1.0 | +6 (+650.0%) | 🔴 |
| New Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |
| Old Gen Gc Count | 2.0 | 0.5 | +2 (+300.0%) | 🔴 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.82ms | 6.16ms | -0.34ms (-5.5%) | 🟢 |
| Worst Frame Build Time Millis | 30.33ms | 31.17ms | -0.84ms (-2.7%) | 🟡 |
| Missed Frame Build Budget Count | 4.75 | 4.5 | +0 (+5.6%) | 🟠 |
| Average Frame Rasterizer Time Millis | 5.16ms | 5.30ms | -0.14ms (-2.7%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 14.0 | 14.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 23.56ms | 22.65ms | +0.91ms (+4.0%) | 🟠 |
| Worst Frame Build Time Millis | 47.11ms | 44.09ms | +3.02ms (+6.9%) | 🟠 |
| Missed Frame Build Budget Count | 10.0 | 10.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.33ms | 5.88ms | -0.54ms (-9.2%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 16.5 | 16.0 | +0 (+3.1%) | 🟠 |
| Old Gen Gc Count | 10.5 | 9.5 | +1 (+10.5%) | 🔴 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.94ms | 0.88ms | +0.06ms (+6.5%) | 🟠 |
| Worst Frame Build Time Millis | 20.42ms | 16.37ms | +4.05ms (+24.7%) | 🔴 |
| Missed Frame Build Budget Count | 0.5 | 1.0 | -0 (-50.0%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.09ms | 7.02ms | +0.07ms (+1.0%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 8.5 | 8.5 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 8.0 | -1 (-12.5%) | 🟢 |
| Old Gen Gc Count | 6.0 | 7.0 | -1 (-14.3%) | 🟢 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.34ms | 1.43ms | -0.09ms (-6.2%) | 🟢 |
| Worst Frame Build Time Millis | 6.74ms | 9.03ms | -2.29ms (-25.3%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.56ms | 5.58ms | -0.02ms (-0.3%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 4.0 | -2 (-37.5%) | 🟢 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 7.12ms | 7.12ms | -0.00ms (-0.0%) | 🟡 |
| Worst Frame Build Time Millis | 28.86ms | 30.83ms | -1.97ms (-6.4%) | 🟢 |
| Missed Frame Build Budget Count | 2.0 | 2.25 | -0 (-11.1%) | 🟢 |
| Average Frame Rasterizer Time Millis | 7.65ms | 7.87ms | -0.22ms (-2.8%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 9.0 | -1 (-11.1%) | 🟢 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.03ms | 0.98ms | +0.06ms (+6.1%) | 🟠 |
| Worst Frame Build Time Millis | 5.69ms | 6.49ms | -0.79ms (-12.2%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.44ms | 8.11ms | +1.33ms (+16.4%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 6.5 | 6.0 | +0 (+8.3%) | 🟠 |
| New Gen Gc Count | 4.0 | 5.0 | -1 (-20.0%) | 🟢 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.88ms | 0.92ms | -0.03ms (-3.6%) | 🟡 |
| Worst Frame Build Time Millis | 3.62ms | 3.73ms | -0.11ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.27ms | 7.64ms | +1.62ms (+21.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.25 | 1.0 | -1 (-75.0%) | 🟢 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.66ms | 1.37ms | +0.29ms (+21.1%) | 🔴 |
| Worst Frame Build Time Millis | 3.29ms | 2.90ms | +0.40ms (+13.6%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 9.05ms | 7.33ms | +1.72ms (+23.5%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.5 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 1.0 | +1 (+100.0%) | 🔴 |

</details>

