# Scripts Directory

Utility scripts for bootstrapping, initialization, and data management.

## Available Scripts

### bootstrap.sh
Complete environment setup script.

```bash
./scripts/bootstrap.sh
```

**Features:**
- Checks Docker and Docker Compose installation
- Creates necessary directories
- Creates .env file with default configuration
- Optionally installs Python dependencies
- Optionally pulls Docker images and starts services

**Usage:**
```bash
# Make executable
chmod +x scripts/bootstrap.sh

# Run
./scripts/bootstrap.sh
```

### init.sh
Infrastructure initialization script.

```bash
./scripts/init.sh
```

**Features:**
- Waits for Kafka to be ready
- Creates Kafka topics (metrics, alerts, anomalies)
- Waits for Elasticsearch to be ready
- Creates Elasticsearch index templates
- Verifies Kibana is ready

**Prerequisites:**
- Docker services must be running (`docker-compose up -d`)

**Usage:**
```bash
# Start services first
docker-compose up -d

# Run initialization
./scripts/init.sh
```

### seed-data.sh
Generate and optionally load sample data.

```bash
./scripts/seed-data.sh
```

**Features:**
- Generates small dataset (100 series) for quick testing
- Generates medium dataset (1000 series) for full testing
- Optionally loads data into Kafka
- Supports both CSV and Parquet formats

**Usage:**
```bash
# Generate sample data
./scripts/seed-data.sh

# Data will be created in data/ directory
ls -lh data/
```

### kafka_playback.py
Replay time series data from files into Kafka.

```bash
python scripts/kafka_playback.py [options]
```

**Options:**
- `--input, -i`: Input CSV or Parquet file (required)
- `--topic, -t`: Kafka topic name (default: metrics)
- `--bootstrap-servers, -b`: Kafka servers (default: localhost:9092)
- `--speed, -s`: Speed multiplier (default: 1.0)
- `--no-timing`: Send all messages as fast as possible
- `--limit, -l`: Limit number of records

**Examples:**
```bash
# Real-time replay
python scripts/kafka_playback.py \
  --input data/timeseries_data_20231210.csv \
  --topic metrics

# Fast replay (10x speed)
python scripts/kafka_playback.py \
  --input data/timeseries_data_20231210.csv \
  --speed 10.0

# Test with limited data
python scripts/kafka_playback.py \
  --input data/timeseries_data_20231210.csv \
  --limit 1000 \
  --no-timing
```

## Workflow

### Complete Setup

```bash
# 1. Bootstrap environment
./scripts/bootstrap.sh

# 2. Initialize infrastructure
./scripts/init.sh

# 3. Generate and load sample data
./scripts/seed-data.sh

# 4. Verify services are running
docker-compose ps

# 5. Access dashboards
# - Grafana: http://localhost:3000
# - Kibana: http://localhost:5601
# - Prometheus: http://localhost:9090
```

### Custom Data Generation

```bash
# Generate custom dataset
python src/collector/generate_timeseries.py \
  --n-series 2000 \
  --n-points 2880 \
  --anomaly-ratio 0.4 \
  --format parquet \
  --output-dir data

# Load into Kafka
python scripts/kafka_playback.py \
  --input data/timeseries_data_*.parquet \
  --topic metrics \
  --speed 5.0
```

### Testing Pipeline

```bash
# 1. Generate small test dataset
python src/collector/generate_timeseries.py \
  --n-series 10 \
  --n-points 100 \
  --output-dir data

# 2. Load into Kafka quickly
python scripts/kafka_playback.py \
  --input data/timeseries_data_*.csv \
  --no-timing \
  --limit 1000

# 3. Verify in Elasticsearch
curl http://localhost:9200/metrics-*/_search?size=1

# 4. View in Kibana
open http://localhost:5601
```

## Troubleshooting

### bootstrap.sh Fails

```bash
# Check Docker installation
docker --version
docker-compose --version

# Check Docker daemon is running
docker ps
```

### init.sh Times Out

```bash
# Check services are running
docker-compose ps

# View service logs
docker-compose logs kafka
docker-compose logs elasticsearch

# Restart services
docker-compose restart
```

### kafka_playback.py Connection Error

```bash
# Check Kafka is accessible
docker exec kafka kafka-broker-api-versions \
  --bootstrap-server localhost:9092

# Check Kafka topics
docker exec kafka kafka-topics \
  --bootstrap-server localhost:9092 --list

# Verify Kafka port is exposed
netstat -an | grep 9092
```

### Python Dependencies Missing

```bash
# Install dependencies
pip3 install -r requirements.txt

# Or use virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Environment Variables

Scripts support the following environment variables:

```bash
# Kafka
export KAFKA_BOOTSTRAP_SERVERS=localhost:9092
export KAFKA_TOPIC=metrics
export KAFKA_GROUP_ID=metrics-consumer

# Elasticsearch
export ELASTICSEARCH_HOST=localhost:9200

# Prometheus
export PROMETHEUS_PUSHGATEWAY=localhost:9091
```

## Notes

- All scripts should be run from the repository root directory
- Scripts create necessary directories automatically
- Generated data is stored in `data/` directory
- Logs are stored in `logs/` directory (if created by applications)
- Scripts are idempotent - safe to run multiple times
