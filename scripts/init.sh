#!/bin/bash
# Initialize Kafka topics and other infrastructure components

set -e

echo "========================================"
echo "  Infrastructure Initialization"
echo "========================================"
echo ""

# Wait for Kafka to be ready
echo "Waiting for Kafka to be ready..."
max_retries=30
retry_count=0

while [ $retry_count -lt $max_retries ]; do
    if docker exec kafka kafka-broker-api-versions --bootstrap-server localhost:9092 &> /dev/null; then
        echo "✓ Kafka is ready"
        break
    fi
    retry_count=$((retry_count + 1))
    echo "  Attempt $retry_count/$max_retries..."
    sleep 2
done

if [ $retry_count -eq $max_retries ]; then
    echo "❌ Kafka failed to start after $max_retries attempts"
    exit 1
fi

# Create Kafka topics
echo ""
echo "Creating Kafka topics..."

topics=("metrics" "alerts" "anomalies")

for topic in "${topics[@]}"; do
    if docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list | grep -q "^${topic}$"; then
        echo "  Topic '$topic' already exists"
    else
        docker exec kafka kafka-topics \
            --create \
            --bootstrap-server localhost:9092 \
            --replication-factor 1 \
            --partitions 3 \
            --topic "$topic"
        echo "  ✓ Created topic: $topic"
    fi
done

# Wait for Elasticsearch to be ready
echo ""
echo "Waiting for Elasticsearch to be ready..."
retry_count=0

while [ $retry_count -lt $max_retries ]; do
    if curl -s http://localhost:9200/_cluster/health &> /dev/null; then
        echo "✓ Elasticsearch is ready"
        break
    fi
    retry_count=$((retry_count + 1))
    echo "  Attempt $retry_count/$max_retries..."
    sleep 2
done

if [ $retry_count -eq $max_retries ]; then
    echo "❌ Elasticsearch failed to start after $max_retries attempts"
    exit 1
fi

# Create Elasticsearch index template
echo ""
echo "Creating Elasticsearch index template..."

curl -s -X PUT "http://localhost:9200/_index_template/metrics-template" \
  -H 'Content-Type: application/json' \
  -d '{
    "index_patterns": ["metrics-*"],
    "template": {
      "settings": {
        "number_of_shards": 1,
        "number_of_replicas": 0
      },
      "mappings": {
        "properties": {
          "@timestamp": {"type": "date"},
          "timestamp": {"type": "date"},
          "series_id": {"type": "integer"},
          "latency_ms": {"type": "float"},
          "error_rate_pct": {"type": "float"},
          "throughput_rps": {"type": "float"},
          "is_anomaly": {"type": "integer"}
        }
      }
    }
  }' > /dev/null

echo "✓ Index template created"

# Wait for Kibana to be ready
echo ""
echo "Waiting for Kibana to be ready..."
retry_count=0

while [ $retry_count -lt $max_retries ]; do
    if curl -s http://localhost:5601/api/status &> /dev/null; then
        echo "✓ Kibana is ready"
        break
    fi
    retry_count=$((retry_count + 1))
    echo "  Attempt $retry_count/$max_retries..."
    sleep 2
done

echo ""
echo "========================================"
echo "  Initialization Complete!"
echo "========================================"
echo ""
echo "Kafka Topics:"
docker exec kafka kafka-topics --bootstrap-server localhost:9092 --list
echo ""
echo "Next steps:"
echo "  1. Generate data: python src/collector/generate_timeseries.py"
echo "  2. Replay to Kafka: python scripts/kafka_playback.py --input data/timeseries_data_*.csv"
echo ""
