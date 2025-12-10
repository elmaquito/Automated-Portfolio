# Grafana Configuration

This directory contains Grafana configuration for visualizing time series metrics.

## Structure

```
grafana/
├── provisioning/
│   ├── datasources/       # Data source configurations
│   │   └── prometheus.yml # Prometheus datasource
│   └── dashboards/        # Dashboard provisioning config
│       └── dashboard.yml  # Dashboard provider config
├── dashboards/            # Dashboard JSON definitions
│   └── timeseries.json   # Time series anomaly dashboard
└── README.md
```

## Quick Start

### Using Docker Compose

```bash
# Start all services
docker-compose up -d

# Access Grafana
open http://localhost:3000

# Default credentials
Username: admin
Password: admin
```

### Manual Setup

1. Start Grafana:
```bash
docker run -d \
  -p 3000:3000 \
  -v $(pwd)/infra/grafana/provisioning:/etc/grafana/provisioning \
  -v $(pwd)/infra/grafana/dashboards:/var/lib/grafana/dashboards \
  --name grafana \
  grafana/grafana:10.1.0
```

2. Access Grafana at http://localhost:3000
3. Login with admin/admin
4. Dashboards are automatically loaded from the dashboards/ directory

## Dashboards

### Time Series Anomaly Dashboard
- **File**: `dashboards/timeseries.json`
- **Description**: Visualizes latency, error rate, and throughput metrics with anomaly highlighting
- **Features**:
  - Multi-metric time series visualization
  - Anomaly markers and highlighting
  - Aggregated statistics
  - Per-series drill-down

## Data Sources

### Prometheus
- **URL**: http://prometheus:9090
- **Type**: Prometheus
- **Refresh Interval**: 15s
- **Configuration**: `provisioning/datasources/prometheus.yml`

## Creating Custom Dashboards

1. Create dashboard in Grafana UI
2. Export JSON (Share → Export → Save to file)
3. Save to `dashboards/` directory
4. Restart Grafana or wait for auto-reload

## Querying Time Series Data

### PromQL Examples

```promql
# Average latency across all series
avg(latency_ms)

# Error rate > 5%
error_rate_pct > 5

# Throughput rate
rate(throughput_rps[5m])

# Anomaly count
sum(is_anomaly)
```

## Visualization Tips

1. **Time Series Panel**: Best for showing metrics over time
2. **Stat Panel**: Display current value and trend
3. **Table Panel**: Show detailed series information
4. **Heatmap**: Visualize distribution of values
5. **Alert List**: Show active anomaly alerts

## Configuration

### Environment Variables
- `GF_SECURITY_ADMIN_USER`: Admin username (default: admin)
- `GF_SECURITY_ADMIN_PASSWORD`: Admin password (default: admin)
- `GF_USERS_ALLOW_SIGN_UP`: Allow user registration (default: false)

### Volume Mounts
- `/etc/grafana/provisioning`: Provisioning configs
- `/var/lib/grafana/dashboards`: Dashboard definitions
- `/var/lib/grafana`: Grafana data (persisted)

## Troubleshooting

### Dashboard Not Loading
1. Check provisioning config: `provisioning/dashboards/dashboard.yml`
2. Verify dashboard JSON is valid
3. Check Grafana logs: `docker logs grafana`

### Data Source Connection Failed
1. Verify Prometheus is running: `curl http://localhost:9090/-/healthy`
2. Check network connectivity between containers
3. Verify datasource config: `provisioning/datasources/prometheus.yml`

### No Data Displayed
1. Verify metrics are being scraped by Prometheus
2. Check time range in dashboard
3. Verify PromQL queries are correct
4. Check Prometheus targets: http://localhost:9090/targets

## References

- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Data Source](https://grafana.com/docs/grafana/latest/datasources/prometheus/)
- [Dashboard Provisioning](https://grafana.com/docs/grafana/latest/administration/provisioning/)
