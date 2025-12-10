# Phase 1 MVP - Data Collection & Simulation

## Overview

Phase 1 focuses on establishing a robust data collection and simulation infrastructure for anomaly detection in time series data. This MVP provides the foundation for building and training anomaly detection models.

## Objectives

1. ✅ Create a usable dataset (real or simulated) covering normal behaviors and anomalies
2. ✅ Establish data pipeline infrastructure (Kafka, Prometheus, ELK)
3. ✅ Generate synthetic time series with realistic patterns and anomalies
4. ✅ Enable data visualization in Grafana and Kibana

## Architecture

```
┌─────────────────┐
│  Data Generator │ (Python Script)
│   (Collector)   │
└────────┬────────┘
         │
         ├──────────────┐
         │              │
         ▼              ▼
   ┌─────────┐    ┌──────────┐
   │  Kafka  │    │Prometheus│
   │ Topics  │    │ Exporter │
   └────┬────┘    └─────┬────┘
        │               │
        │               ▼
        │         ┌──────────┐
        │         │Prometheus│
        │         └─────┬────┘
        │               │
        │               ▼
        │         ┌──────────┐
        │         │ Grafana  │
        │         └──────────┘
        │
        ▼
   ┌─────────┐
   │Logstash │
   └────┬────┘
        │
        ▼
   ┌─────────────┐
   │Elasticsearch│
   └──────┬──────┘
          │
          ▼
   ┌──────────┐
   │  Kibana  │
   └──────────┘
```

## Deliverables

### 1. Synthetic Dataset ✅

**Location**: `data/`

**Format**: CSV and Parquet

**Contents**:
- Multivariate time series (latency, error_rate, throughput)
- Normal behavior patterns with seasonality
- Multiple anomaly types properly labeled
- Metadata for each time series

**Specifications**:
- ✅ N ≥ 1000 time series
- ✅ Multiple metrics per series
- ✅ Labeled anomalies
- ✅ Export in multiple formats (CSV, Parquet)

### 2. Data Generation Scripts ✅

**Location**: `src/collector/generate_timeseries.py`

**Features**:
- Configurable number of series and data points
- Adjustable anomaly ratio
- Multiple anomaly types:
  - Spike: Sudden short-term increase/decrease
  - Level shift: Persistent baseline change
  - Gradual drift: Slow trend changes
  - Missing values: Data gaps
  - Seasonal change: Altered seasonal patterns
- Reproducible with seed control
- Export to CSV and Parquet

**Usage**:
```bash
python src/collector/generate_timeseries.py \
  --n-series 1000 \
  --n-points 1440 \
  --anomaly-ratio 0.3 \
  --format both
```

### 3. Kafka Playback Scripts ✅

**Location**: `scripts/kafka_playback.py`

**Features**:
- Replay time series data into Kafka topics
- Real-time simulation with speed control
- Support for CSV and Parquet files
- Configurable batch processing

**Usage**:
```bash
python scripts/kafka_playback.py \
  --input data/timeseries_data.csv \
  --topic metrics \
  --speed 10.0
```

### 4. Infrastructure Configuration ✅

**Components**:
- Kafka: Message broker for streaming data
- Prometheus: Metrics collection and monitoring
- Grafana: Metrics visualization
- Elasticsearch: Time series storage
- Logstash: Data ingestion pipeline
- Kibana: Data exploration and visualization

**Setup**:
```bash
# Bootstrap environment
./scripts/bootstrap.sh

# Initialize infrastructure
./scripts/init.sh

# Generate and load data
./scripts/seed-data.sh
```

## Testing & Validation

### Dataset Requirements ✅

- [x] At least N=1000 time series
- [x] Labeled anomalies for validation
- [x] Multiple anomaly types represented
- [x] Normal behavior patterns included
- [x] Realistic noise and seasonality

### Visualization Validation ✅

1. **Grafana** (http://localhost:3000)
   - View time series metrics
   - Monitor anomaly detection
   - Track system performance

2. **Kibana** (http://localhost:5601)
   - Explore raw data
   - Search and filter anomalies
   - Create visualizations

### Pipeline Testing ✅

```bash
# 1. Generate test data
python src/collector/generate_timeseries.py \
  --n-series 100 --n-points 288

# 2. Load into Kafka
python scripts/kafka_playback.py \
  --input data/timeseries_data_*.csv \
  --limit 1000

# 3. Verify in Elasticsearch
curl http://localhost:9200/metrics-*/_search?size=1

# 4. View in Kibana
open http://localhost:5601
```

## Dataset Statistics

### Generated Data Characteristics

**Temporal Coverage**:
- Default: 24 hours (1440 points at 1-minute intervals)
- Configurable frequency: 1min, 5min, 1H, etc.

**Metrics**:
- **Latency (ms)**: Base ~100ms, noise ±15%, seasonal variation ±20%
- **Error Rate (%)**: Base ~2%, noise ±30%, seasonal variation ±25%
- **Throughput (req/s)**: Base ~1000, noise ±10%, seasonal variation ±15%

**Anomaly Distribution** (30% anomaly ratio):
- Spike: 20% of anomalies
- Level shift: 20% of anomalies
- Gradual drift: 20% of anomalies
- Missing values: 20% of anomalies
- Seasonal change: 20% of anomalies

## Usage Examples

### Generate Different Datasets

```bash
# Small dataset (quick testing)
python src/collector/generate_timeseries.py \
  --n-series 100 \
  --n-points 288 \
  --anomaly-ratio 0.2

# Medium dataset (development)
python src/collector/generate_timeseries.py \
  --n-series 1000 \
  --n-points 1440 \
  --anomaly-ratio 0.3

# Large dataset (production-like)
python src/collector/generate_timeseries.py \
  --n-series 5000 \
  --n-points 2880 \
  --anomaly-ratio 0.25
```

### Load and Analyze

```python
import pandas as pd

# Load data
df = pd.read_parquet('data/timeseries_data_20231210.parquet')
metadata = pd.read_parquet('data/timeseries_metadata_20231210.parquet')

# Analyze
print(f"Total series: {df['series_id'].nunique()}")
print(f"Anomalous series: {metadata['has_anomaly'].sum()}")
print(f"Anomaly rate: {df['is_anomaly'].mean():.2%}")

# Filter anomalies
anomalies = df[df['is_anomaly'] == 1]
print(f"Anomalous points: {len(anomalies)}")
```

## Next Steps (Phase 2)

1. **Data Preprocessing**:
   - Implement data cleaning pipeline
   - Handle missing values
   - Normalize/standardize features
   - Feature engineering

2. **Model Training**:
   - Implement baseline models (IsolationForest, LOF)
   - Train deep learning models (LSTM, Autoencoder)
   - Hyperparameter tuning
   - Model evaluation and comparison

3. **Model Serving**:
   - Deploy models with TensorFlow Serving
   - Create API for anomaly detection
   - Real-time prediction pipeline
   - A/B testing framework

## References

- [Data Generation Script](../../src/collector/generate_timeseries.py)
- [Kafka Playback Script](../../scripts/kafka_playback.py)
- [Infrastructure Documentation](../../infra/README.md)
- [Data Directory README](../../data/README.md)
- [Scripts Documentation](../../scripts/README.md)

## Support

For issues or questions:
- Check [Infrastructure README](../../infra/README.md) for troubleshooting
- Review [Scripts README](../../scripts/README.md) for usage examples
- Check Docker logs: `docker-compose logs`
