#!/bin/bash
# Bootstrap script for setting up the development environment

set -e

echo "========================================"
echo "  Automated Portfolio - Bootstrap"
echo "========================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi
echo "✓ Docker is installed"

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi
echo "✓ Docker Compose is installed"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "⚠️  Python 3 is not installed. Some scripts may not work."
else
    echo "✓ Python 3 is installed ($(python3 --version))"
fi

# Create necessary directories
echo ""
echo "Creating directories..."
mkdir -p data logs infra/prometheus/rules
echo "✓ Directories created"

# Check if .env file exists
if [ ! -f .env ]; then
    echo ""
    echo "Creating .env file..."
    cat > .env << 'EOF'
# Kafka
KAFKA_BOOTSTRAP_SERVERS=kafka:29092

# Elasticsearch
ELASTICSEARCH_HOST=elasticsearch:9200

# Prometheus
PROMETHEUS_PUSHGATEWAY=prometheus:9091

# Grafana
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=admin
EOF
    echo "✓ .env file created"
else
    echo "✓ .env file already exists"
fi

# Install Python dependencies (optional)
if command -v python3 &> /dev/null; then
    echo ""
    read -p "Install Python dependencies? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f requirements.txt ]; then
            python3 -m pip install -r requirements.txt
            echo "✓ Python dependencies installed"
        else
            echo "⚠️  requirements.txt not found"
        fi
    fi
fi

# Pull Docker images
echo ""
read -p "Pull Docker images? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pulling Docker images..."
    docker-compose pull
    echo "✓ Docker images pulled"
fi

# Start services
echo ""
read -p "Start all services? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Starting services..."
    docker-compose up -d
    echo "✓ Services started"
    
    echo ""
    echo "Waiting for services to be ready..."
    sleep 10
    
    # Check service health
    echo ""
    echo "Service Status:"
    docker-compose ps
    
    echo ""
    echo "========================================"
    echo "  Services are running!"
    echo "========================================"
    echo ""
    echo "Access points:"
    echo "  Grafana:        http://localhost:3000 (admin/admin)"
    echo "  Prometheus:     http://localhost:9090"
    echo "  Kibana:         http://localhost:5601"
    echo "  Elasticsearch:  http://localhost:9200"
    echo ""
    echo "Next steps:"
    echo "  1. Generate sample data: python src/collector/generate_timeseries.py"
    echo "  2. Replay data to Kafka: python scripts/kafka_playback.py --input data/timeseries_data_*.csv"
    echo "  3. View metrics in Grafana and Kibana"
    echo ""
fi

echo "✓ Bootstrap complete!"
