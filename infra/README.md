# Infrastructure Configuration

This directory contains infrastructure configuration for the Automated Portfolio monitoring and anomaly detection system.

## Directory Structure

```
infra/
├── dockerfiles/       # Docker images for application components
│   ├── Dockerfile.collector   # Data collector/generator
│   └── Dockerfile.ingestion   # Kafka consumer/preprocessor
├── prometheus/        # Prometheus monitoring configuration
│   ├── prometheus.yml         # Main Prometheus config
│   └── rules/                 # Alert rules
├── grafana/          # Grafana visualization configuration
│   ├── provisioning/         # Auto-provisioning configs
│   └── dashboards/           # Dashboard definitions
├── elk/              # Elasticsearch, Logstash, Kibana stack
│   └── logstash/            # Logstash pipeline configuration
└── kafka/            # Kafka configuration (future)
```

## Quick Start

### Start All Services

```bash
# From repository root
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f
```

### Access Services

- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Kibana**: http://localhost:5601
- **Elasticsearch**: http://localhost:9200
- **Kafka**: localhost:9092

### Stop Services

```bash
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Components

### Kafka
- **Port**: 9092
- **Purpose**: Message broker for streaming time series data
- **Topics**: 
  - `metrics`: Time series metrics (latency, error_rate, throughput)

### Prometheus
- **Port**: 9090
- **Purpose**: Metrics collection and monitoring
- **Config**: `prometheus/prometheus.yml`
- **Scrape Interval**: 15s
- **Retention**: 30 days

### Grafana
- **Port**: 3000
- **Purpose**: Metrics visualization and dashboarding
- **Data Source**: Prometheus
- **Dashboards**: Auto-provisioned from `grafana/dashboards/`

### ELK Stack

#### Elasticsearch
- **Port**: 9200 (HTTP), 9300 (Transport)
- **Purpose**: Time series data storage and search
- **Index Pattern**: `metrics-YYYY.MM.dd`

#### Logstash
- **Ports**: 5044, 5000, 9600
- **Purpose**: Data ingestion pipeline (Kafka → Elasticsearch)
- **Pipeline**: `elk/logstash/pipeline/logstash.conf`

#### Kibana
- **Port**: 5601
- **Purpose**: Elasticsearch visualization and exploration
- **Index Pattern**: Create `metrics-*` pattern on first use

### Application Services

#### Collector
- **Purpose**: Generate and collect time series data
- **Output**: Kafka topics, Prometheus metrics
- **Dockerfile**: `dockerfiles/Dockerfile.collector`

#### Ingestion
- **Purpose**: Consume and preprocess Kafka messages
- **Output**: Elasticsearch indices
- **Dockerfile**: `dockerfiles/Dockerfile.ingestion`

## Configuration

### Environment Variables

Create a `.env` file in the repository root:

```bash
# Kafka
KAFKA_BOOTSTRAP_SERVERS=kafka:29092

# Elasticsearch
ELASTICSEARCH_HOST=elasticsearch:9200

# Prometheus
PROMETHEUS_PUSHGATEWAY=prometheus:9091

# Grafana
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=admin
```

### Scaling Services

```bash
# Scale Kafka consumers
docker-compose up -d --scale ingestion=3

# Scale collectors
docker-compose up -d --scale collector=2
```

## Data Flow

```
Data Generator (collector)
    ↓
Kafka Topic (metrics)
    ↓
    ├─→ Logstash → Elasticsearch → Kibana
    └─→ Prometheus Exporter → Prometheus → Grafana
```

## Monitoring

### Prometheus Metrics
- Application metrics exposed on port 8000
- Kafka metrics via JMX exporter (port 9101)
- Node metrics via node-exporter (port 9100)

### Health Checks

```bash
# Kafka
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list

# Elasticsearch
curl http://localhost:9200/_cluster/health

# Prometheus
curl http://localhost:9090/-/healthy

# Grafana
curl http://localhost:3000/api/health
```

## Troubleshooting

### Service Won't Start
```bash
# Check logs
docker-compose logs <service-name>

# Restart service
docker-compose restart <service-name>

# Rebuild service
docker-compose up -d --build <service-name>
```

### Network Issues
```bash
# Inspect network
docker network inspect automated-portfolio_monitoring

# Check DNS resolution
docker exec <container> nslookup <service-name>
```

### Data Issues
```bash
# Check Kafka topics
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --describe --topic metrics

# Check Elasticsearch indices
curl http://localhost:9200/_cat/indices?v

# Check Prometheus targets
curl http://localhost:9090/api/v1/targets
```

## Development

### Local Development Without Docker

```bash
# Install dependencies
pip install -r requirements.txt

# Start Kafka locally
brew install kafka
brew services start kafka

# Start Prometheus
brew install prometheus
prometheus --config.file=infra/prometheus/prometheus.yml

# Run collector
python src/collector/generate_timeseries.py

# Run ingestion
python src/ingestion/consumer.py
```

## References

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Kafka Documentation](https://kafka.apache.org/documentation/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [ELK Stack Documentation](https://www.elastic.co/guide/)
