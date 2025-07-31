## 📋 Summary

**🟠 Minor Performance Regressions:**
- 🟠 **one_event_per_day-week-resizing**: Frame build time increased by 5.3%
- 🟠 **one_event_per_day-schedule-loadingEvents**: Frame build time increased by 8.3%
- 🟠 **ten_events_per_day-month-resizing**: Frame build time increased by 6.2%
- 🟠 **ten_events_per_day-schedule-loadingEvents**: Frame build time increased by 5.7%

**✅ Performance Improvements:**
- 🟢 **ten_events_per_day-week-resizing**: Frame build time improved by 10.8%

**📊 Analysis Overview:**
- Total scenarios: 24
- Compared with baseline: 24

<details>
<summary><strong>📈 Detailed Performance Metrics</strong> (click to expand)</summary>

#### one_event_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.54ms | 4.38ms | +0.16ms (+3.7%) | 🟠 |
| Worst Frame Build Time Millis | 8.94ms | 8.63ms | +0.31ms (+3.6%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.59ms | 2.21ms | +0.38ms (+17.2%) | 🔴 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 4.98ms | 4.81ms | +0.18ms (+3.7%) | 🟠 |
| Worst Frame Build Time Millis | 17.65ms | 16.70ms | +0.96ms (+5.7%) | 🟠 |
| Missed Frame Build Budget Count | 1.25 | 1.0 | +0 (+25.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.79ms | 3.74ms | +0.05ms (+1.5%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.79ms | 0.82ms | -0.03ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 4.37ms | 5.44ms | -1.07ms (-19.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.91ms | 3.08ms | -0.17ms (-5.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.57ms | 0.56ms | +0.02ms (+2.8%) | 🟠 |
| Worst Frame Build Time Millis | 3.68ms | 3.62ms | +0.06ms (+1.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.59ms | 2.97ms | -0.38ms (-12.9%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.94ms | 8.26ms | +0.68ms (+8.3%) | 🟠 |
| Worst Frame Build Time Millis | 25.45ms | 23.57ms | +1.88ms (+8.0%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.48ms | 2.86ms | -0.38ms (-13.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 6.23ms | 6.05ms | +0.19ms (+3.1%) | 🟠 |
| Worst Frame Build Time Millis | 10.85ms | 10.79ms | +0.06ms (+0.5%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.31ms | 3.32ms | -0.01ms (-0.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |

#### one_event_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.85ms | 1.85ms | -0.01ms (-0.4%) | 🟡 |
| Worst Frame Build Time Millis | 27.20ms | 25.24ms | +1.96ms (+7.8%) | 🟠 |
| Missed Frame Build Budget Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.10ms | 3.34ms | -0.24ms (-7.3%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.23ms | 1.23ms | +0.00ms (+0.1%) | 🟠 |
| Worst Frame Build Time Millis | 2.34ms | 2.34ms | -0.01ms (-0.3%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.00ms | 2.04ms | -0.04ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.5 | 0.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.64ms | 2.73ms | -0.09ms (-3.2%) | 🟡 |
| Worst Frame Build Time Millis | 9.28ms | 9.57ms | -0.29ms (-3.0%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.16ms | 3.25ms | -0.08ms (-2.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.56ms | 0.56ms | -0.00ms (-0.1%) | 🟡 |
| Worst Frame Build Time Millis | 2.45ms | 2.82ms | -0.37ms (-13.0%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.28ms | 2.38ms | -0.10ms (-4.1%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 4.0 | 4.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.53ms | 0.50ms | +0.03ms (+5.3%) | 🟠 |
| Worst Frame Build Time Millis | 1.70ms | 1.58ms | +0.12ms (+7.9%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.10ms | 2.14ms | -0.04ms (-1.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |

#### one_event_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.82ms | 0.80ms | +0.02ms (+2.0%) | 🟠 |
| Worst Frame Build Time Millis | 1.06ms | 1.08ms | -0.03ms (-2.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 2.70ms | 2.79ms | -0.08ms (-2.9%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 10.73ms | 10.99ms | -0.27ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 29.88ms | 29.90ms | -0.02ms (-0.1%) | 🟡 |
| Missed Frame Build Budget Count | 8.0 | 8.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.28ms | 5.36ms | -0.08ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 10.5 | -0 (-4.8%) | 🟡 |
| Old Gen Gc Count | 7.0 | 7.5 | -0 (-6.7%) | 🟢 |

#### ten_events_per_day-month-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 11.80ms | 12.32ms | -0.52ms (-4.2%) | 🟡 |
| Worst Frame Build Time Millis | 40.13ms | 46.94ms | -6.81ms (-14.5%) | 🟢 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.50ms | 5.17ms | +0.33ms (+6.4%) | 🟠 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 9.5 | 10.0 | -0 (-5.0%) | 🟢 |
| Old Gen Gc Count | 5.5 | 6.0 | -0 (-8.3%) | 🟢 |

#### ten_events_per_day-month-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.58ms | 1.66ms | -0.08ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 13.45ms | 14.07ms | -0.62ms (-4.4%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.16ms | 4.56ms | -0.40ms (-8.7%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-month-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.55ms | 1.46ms | +0.09ms (+6.2%) | 🟠 |
| Worst Frame Build Time Millis | 12.57ms | 12.69ms | -0.12ms (-0.9%) | 🟡 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.36ms | 4.88ms | -0.52ms (-10.6%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.5 | 1.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 5.43ms | 5.14ms | +0.29ms (+5.7%) | 🟠 |
| Worst Frame Build Time Millis | 31.96ms | 28.74ms | +3.21ms (+11.2%) | 🔴 |
| Missed Frame Build Budget Count | 3.0 | 2.0 | +1 (+50.0%) | 🔴 |
| Average Frame Rasterizer Time Millis | 3.20ms | 3.25ms | -0.05ms (-1.6%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.5 | 11.0 | -0 (-4.5%) | 🟡 |
| Old Gen Gc Count | 5.5 | 5.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 19.73ms | 19.96ms | -0.23ms (-1.1%) | 🟡 |
| Worst Frame Build Time Millis | 41.97ms | 41.31ms | +0.66ms (+1.6%) | 🟠 |
| Missed Frame Build Budget Count | 10.0 | 9.5 | +0 (+5.3%) | 🟠 |
| Average Frame Rasterizer Time Millis | 3.09ms | 3.27ms | -0.18ms (-5.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 18.0 | 18.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 12.0 | 12.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-schedule-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.88ms | 0.89ms | -0.01ms (-1.3%) | 🟡 |
| Worst Frame Build Time Millis | 13.68ms | 13.39ms | +0.29ms (+2.2%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.61ms | 4.15ms | -0.54ms (-13.0%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 6.0 | 6.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-loadingEvents

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 2.29ms | 2.34ms | -0.06ms (-2.4%) | 🟡 |
| Worst Frame Build Time Millis | 8.57ms | 8.30ms | +0.28ms (+3.3%) | 🟠 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 3.42ms | 3.64ms | -0.22ms (-6.1%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.25 | 0.25 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.5 | 2.5 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-navigation

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 8.83ms | 8.88ms | -0.06ms (-0.6%) | 🟡 |
| Worst Frame Build Time Millis | 44.49ms | 42.86ms | +1.63ms (+3.8%) | 🟠 |
| Missed Frame Build Budget Count | 3.0 | 3.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.37ms | 5.54ms | -0.18ms (-3.2%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 10.0 | 8.0 | +2 (+25.0%) | 🔴 |
| Old Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-rescheduling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 1.07ms | 1.15ms | -0.08ms (-7.1%) | 🟢 |
| Worst Frame Build Time Millis | 6.52ms | 5.78ms | +0.75ms (+13.0%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.89ms | 5.72ms | -0.83ms (-14.5%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 1.0 | -1 (-100.0%) | 🟢 |
| New Gen Gc Count | 5.0 | 5.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 2.0 | 2.5 | -0 (-20.0%) | 🟢 |

#### ten_events_per_day-week-resizing

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.86ms | 0.96ms | -0.10ms (-10.8%) | 🟢 |
| Worst Frame Build Time Millis | 3.17ms | 3.95ms | -0.78ms (-19.7%) | 🟢 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 4.58ms | 4.75ms | -0.17ms (-3.5%) | 🟡 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 2.0 | 2.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.0 | +0 (+0.0%) | 🟡 |

#### ten_events_per_day-week-scrolling

| Metric | Current | Baseline | Change | Status |
|--------|---------|----------|--------|--------|
| Average Frame Build Time Millis | 0.85ms | 0.89ms | -0.04ms (-4.8%) | 🟡 |
| Worst Frame Build Time Millis | 1.67ms | 1.10ms | +0.57ms (+51.4%) | 🔴 |
| Missed Frame Build Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| Average Frame Rasterizer Time Millis | 5.36ms | 5.69ms | -0.33ms (-5.8%) | 🟢 |
| Missed Frame Rasterizer Budget Count | 0.0 | 0.0 | +0 (+0.0%) | 🟡 |
| New Gen Gc Count | 7.0 | 7.0 | +0 (+0.0%) | 🟡 |
| Old Gen Gc Count | 1.0 | 1.5 | -0 (-33.3%) | 🟢 |

</details>

