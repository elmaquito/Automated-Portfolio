# Data Directory

This directory contains synthetic time series datasets generated for anomaly detection experiments.

## Dataset Structure

### Time Series Data Files
Generated datasets contain multivariate time series with the following metrics:
- **latency_ms**: Response latency in milliseconds
- **error_rate_pct**: Error rate percentage
- **throughput_rps**: Throughput in requests per second

### Data Formats
- **CSV**: Human-readable format for inspection and basic analysis
- **Parquet**: Optimized columnar format for faster processing and smaller file size

### File Naming Convention
```
timeseries_data_YYYYMMDD_HHMMSS.{csv|parquet}
timeseries_metadata_YYYYMMDD_HHMMSS.{csv|parquet}
generation_config_YYYYMMDD_HHMMSS.json
```

## Data Schema

### Main Dataset (`timeseries_data_*.csv/parquet`)
| Column | Type | Description |
|--------|------|-------------|
| timestamp | datetime | Timestamp of the measurement |
| series_id | int | Unique identifier for the time series |
| latency_ms | float | Response latency in milliseconds |
| error_rate_pct | float | Error rate percentage |
| throughput_rps | float | Throughput in requests per second |
| is_anomaly | int | Binary label (0=normal, 1=anomaly) |

### Metadata (`timeseries_metadata_*.csv/parquet`)
| Column | Type | Description |
|--------|------|-------------|
| series_id | int | Unique identifier for the time series |
| has_anomaly | bool | Whether the series contains anomalies |
| anomaly_type | str | Type of anomaly (spike, level_shift, etc.) |
| anomaly_count | int | Number of anomalous points in the series |

### Generation Config (`generation_config_*.json`)
```json
{
  "generation_timestamp": "20231210_123045",
  "n_series": 1000,
  "n_points": 1440,
  "freq": "1min",
  "anomaly_ratio": 0.3,
  "seed": 42,
  "total_points": 1440000,
  "anomalous_points": 43200,
  "anomalous_series": 300
}
```

## Anomaly Types

The dataset includes the following anomaly patterns:

1. **Spike**: Sudden short-term increase/decrease in values
   - Duration: 3-15 data points
   - Magnitude: 2-4x normal values

2. **Level Shift**: Persistent change in baseline
   - Affects all subsequent values
   - Magnitude: 50% of mean value

3. **Gradual Drift**: Slow trend change over time
   - Duration: 100-300 data points
   - Magnitude: 30% of mean value

4. **Missing Values**: Gaps in data
   - Duration: 3-15 data points
   - Represented as NaN values

5. **Seasonal Change**: Altered seasonal patterns
   - Changes periodicity of seasonal component
   - Affects all subsequent values

## Usage

### Generate New Dataset
```bash
# Default configuration (1000 series, 1440 points, 30% anomalies)
python src/collector/generate_timeseries.py

# Custom configuration
python src/collector/generate_timeseries.py \
  --n-series 2000 \
  --n-points 2880 \
  --anomaly-ratio 0.4 \
  --format parquet \
  --output-dir data
```

### Load Data in Python
```python
import pandas as pd

# Load CSV
df = pd.read_csv('data/timeseries_data_20231210_123045.csv')
metadata = pd.read_csv('data/timeseries_metadata_20231210_123045.csv')

# Load Parquet (faster)
df = pd.read_parquet('data/timeseries_data_20231210_123045.parquet')
metadata = pd.read_parquet('data/timeseries_metadata_20231210_123045.parquet')

# Filter anomalous series
anomalous_series = metadata[metadata['has_anomaly']]['series_id']
df_anomalous = df[df['series_id'].isin(anomalous_series)]
```

### Visualize in Grafana/Kibana
See [infra/grafana/README.md](../infra/grafana/README.md) and [infra/elk/README.md](../infra/elk/README.md) for visualization setup instructions.

## Dataset Requirements

### Phase 1 Requirements ✓
- [x] At least N=1000 time series
- [x] Multiple metrics (latency, error_rate, throughput)
- [x] Normal behavior patterns with seasonality
- [x] Multiple anomaly types (spike, drift, level shift, missing, seasonal change)
- [x] Labeled anomalies for validation
- [x] Export in multiple formats (CSV, Parquet)

## Sample Data

Small sample datasets are provided for quick testing:
- `sample_100series.csv`: 100 time series for quick exploration
- `sample_10series.csv`: 10 time series for debugging

## Data Playback

For replaying data into Kafka for testing:
```bash
# Replay dataset to Kafka
python scripts/kafka_playback.py \
  --input data/timeseries_data_20231210_123045.csv \
  --topic metrics \
  --bootstrap-servers localhost:9092
```

See [scripts/README.md](../scripts/README.md) for more information on data playback scripts.

## Notes

- All timestamps are generated relative to current time
- Data includes realistic noise and seasonal patterns
- Anomalies are evenly distributed across anomaly types
- Random seed can be set for reproducibility
- Missing values are represented as NaN in the dataset
