class PerformanceDashboard {
    constructor() {
        this.data = [];
        this.charts = {};
        this.init();
    }

    async init() {
        try {
            await this.loadData();
            this.renderDashboard();
        } catch (error) {
            console.error('Failed to initialize dashboard:', error);
            this.showError();
        }
    }

    async loadData() {
        try {
            // Load latest metadata
            const latestResponse = await fetch('./data/latest.json');
            this.latest = await latestResponse.json();

            // Load all performance data files
            const dataFiles = await this.discoverDataFiles();
            const promises = dataFiles.map(file => this.loadDataFile(file));
            const results = await Promise.all(promises);
            
            this.data = results
                .filter(result => result !== null)
                .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

            console.log(`Loaded ${this.data.length} performance records`);
        } catch (error) {
            console.error('Error loading data:', error);
            throw error;
        }
    }

    async discoverDataFiles() {
        // In a real implementation, you might have an index file
        // For now, we'll try to load recent files based on patterns
        const files = [];
        const now = new Date();
        
        // Try to find files from last 30 days
        for (let i = 0; i < 30; i++) {
            const date = new Date(now);
            date.setDate(date.getDate() - i);
            const dateStr = date.toISOString().split('T')[0].replace(/-/g, '');
            
            // Try different time patterns for that day
            for (let hour = 0; hour < 24; hour += 2) {
                const timeStr = String(hour).padStart(2, '0') + '0000';
                files.push(`./data/perf_linux_${dateStr}_${timeStr}.json`);
            }
        }
        
        return files;
    }

    async loadDataFile(filename) {
        try {
            const response = await fetch(filename);
            if (!response.ok) return null;
            
            const data = await response.json();
            return data;
        } catch (error) {
            return null;
        }
    }

    renderDashboard() {
        document.getElementById('loading').style.display = 'none';
        document.getElementById('dashboard').style.display = 'block';

        this.updateLastUpdate();
        this.renderMetrics();
        this.renderCharts();
        this.renderTable();
    }

    updateLastUpdate() {
        const lastUpdate = document.getElementById('lastUpdate');
        if (this.latest) {
            const date = new Date(this.latest.lastUpdate);
            lastUpdate.textContent = `Last updated: ${date.toLocaleString()}`;
        }
    }

    renderMetrics() {
        if (this.data.length === 0) return;

        const latest = this.data[0];
        const testResults = latest.test_results || {};

        // Extract performance metrics (adjust based on your actual test output)
        const buildTime = this.extractMetric(testResults, 'frame_build_time') || '--';
        const rasterTime = this.extractMetric(testResults, 'frame_raster_time') || '--';
        
        document.getElementById('latestBuildTime').textContent = 
            typeof buildTime === 'number' ? buildTime.toFixed(2) : buildTime;
        document.getElementById('latestRasterTime').textContent = 
            typeof rasterTime === 'number' ? rasterTime.toFixed(2) : rasterTime;
        
        // Test status
        const status = testResults.success !== undefined ? 
            (testResults.success ? 'PASS' : 'FAIL') : 'UNKNOWN';
        const statusElement = document.getElementById('testStatus');
        statusElement.textContent = status;
        statusElement.className = `metric-value ${status.toLowerCase()}`;

        // Total tests
        document.getElementById('totalTests').textContent = this.data.length;

        // Trends (compare with previous result)
        if (this.data.length > 1) {
            this.renderTrends();
        }
    }

    extractMetric(testResults, metricName) {
        // Adjust this based on your actual test result structure
        if (testResults.metrics && testResults.metrics[metricName]) {
            return testResults.metrics[metricName];
        }
        if (testResults[metricName]) {
            return testResults[metricName];
        }
        return null;
    }

    renderTrends() {
        const current = this.data[0];
        const previous = this.data[1];
        
        const currentBuild = this.extractMetric(current.test_results, 'frame_build_time');
        const previousBuild = this.extractMetric(previous.test_results, 'frame_build_time');
        
        if (currentBuild && previousBuild) {
            this.renderTrend('buildTimeTrend', currentBuild, previousBuild);
        }
        
        const currentRaster = this.extractMetric(current.test_results, 'frame_raster_time');
        const previousRaster = this.extractMetric(previous.test_results, 'frame_raster_time');
        
        if (currentRaster && previousRaster) {
            this.renderTrend('rasterTimeTrend', currentRaster, previousRaster);
        }
    }

    renderTrend(elementId, current, previous) {
        const element = document.getElementById(elementId);
        const diff = current - previous;
        const percent = ((diff / previous) * 100).toFixed(1);
        
        if (Math.abs(diff) < 0.01) {
            element.textContent = '→ No change';
            element.className = 'metric-trend trend-stable';
        } else if (diff > 0) {
            element.textContent = `↗ +${percent}%`;
            element.className = 'metric-trend trend-down'; // Higher is worse for performance
        } else {
            element.textContent = `↘ ${percent}%`;
            element.className = 'metric-trend trend-up'; // Lower is better for performance
        }
    }

    renderCharts() {
        this.renderPerformanceChart();
        this.renderStatusChart();
    }

    renderPerformanceChart() {
        const ctx = document.getElementById('performanceChart').getContext('2d');
        
        // Get last 30 data points
        const recentData = this.data.slice(0, 30).reverse();
        
        const labels = recentData.map(d => new Date(d.timestamp).toLocaleDateString());
        const buildTimes = recentData.map(d => this.extractMetric(d.test_results, 'frame_build_time') || 0);
        const rasterTimes = recentData.map(d => this.extractMetric(d.test_results, 'frame_raster_time') || 0);

        this.charts.performance = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Frame Build Time (ms)',
                    data: buildTimes,
                    borderColor: '#2196F3',
                    backgroundColor: '#2196F3',
                    fill: false,
                    tension: 0.4
                }, {
                    label: 'Frame Raster Time (ms)',
                    data: rasterTimes,
                    borderColor: '#FF9800',
                    backgroundColor: '#FF9800',
                    fill: false,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Time (ms)'
                        }
                    }
                }
            }
        });
    }

    renderStatusChart() {
        const ctx = document.getElementById('statusChart').getContext('2d');
        
        const statusCounts = this.data.reduce((acc, d) => {
            const success = d.test_results?.success;
            if (success === true) acc.pass++;
            else if (success === false) acc.fail++;
            else acc.unknown++;
            return acc;
        }, { pass: 0, fail: 0, unknown: 0 });

        this.charts.status = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Pass', 'Fail', 'Unknown'],
                datasets: [{
                    data: [statusCounts.pass, statusCounts.fail, statusCounts.unknown],
                    backgroundColor: ['#4CAF50', '#F44336', '#9C27B0']
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }

    renderTable() {
        const tbody = document.getElementById('resultsTableBody');
        const recentData = this.data.slice(0, 20); // Show last 20 results

        tbody.innerHTML = recentData.map(d => {
            const date = new Date(d.timestamp).toLocaleString();
            const commitShort = d.commit_sha?.substring(0, 7) || 'unknown';
            const commitUrl = `https://github.com/${this.getRepoPath()}/commit/${d.commit_sha}`;
            const status = d.test_results?.success === true ? 'pass' : 
                         d.test_results?.success === false ? 'fail' : 'unknown';
            const buildTime = this.extractMetric(d.test_results, 'frame_build_time');
            const rasterTime = this.extractMetric(d.test_results, 'frame_raster_time');

            return `
                <tr>
                    <td>${date}</td>
                    <td><a href="${commitUrl}" class="commit-link" target="_blank">${commitShort}</a></td>
                    <td>${d.branch || 'unknown'}</td>
                    <td><span class="status ${status}">${status.toUpperCase()}</span></td>
                    <td>${buildTime ? buildTime.toFixed(2) + ' ms' : '--'}</td>
                    <td>${rasterTime ? rasterTime.toFixed(2) + ' ms' : '--'}</td>
                    <td><button onclick="dashboard.showDetails(${d.run_number})">View</button></td>
                </tr>
            `;
        }).join('');
    }

    getRepoPath() {
        // Extract from current URL or return default
        const path = window.location.pathname;
        const match = path.match(/github\.io\/([^\/]+)/);
        return match ? `kdab/${match[1]}` : 'kdab/kalender';
    }

    showDetails(runNumber) {
        const data = this.data.find(d => d.run_number === runNumber);
        if (data) {
            alert(`Test Details:\n${JSON.stringify(data.test_results, null, 2)}`);
        }
    }

    showError() {
        document.getElementById('loading').style.display = 'none';
        document.getElementById('error').style.display = 'block';
    }
}

// Initialize dashboard when page loads
let dashboard;
document.addEventListener('DOMContentLoaded', () => {
    dashboard = new PerformanceDashboard();
});
