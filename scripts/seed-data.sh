#!/bin/bash
# Seed data generation and loading script

set -e

echo "========================================"
echo "  Data Seeding"
echo "========================================"
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    exit 1
fi

# Install dependencies if needed
if ! python3 -c "import pandas" 2>/dev/null; then
    echo "Installing Python dependencies..."
    pip3 install -r requirements.txt
fi

# Generate sample data
echo "Generating sample datasets..."
echo ""

# Small dataset for quick testing
echo "1. Generating small dataset (100 series)..."
python3 src/collector/generate_timeseries.py \
    --n-series 100 \
    --n-points 288 \
    --anomaly-ratio 0.3 \
    --format both \
    --output-dir data

echo "✓ Small dataset generated"
echo ""

# Medium dataset
echo "2. Generating medium dataset (1000 series)..."
python3 src/collector/generate_timeseries.py \
    --n-series 1000 \
    --n-points 1440 \
    --anomaly-ratio 0.3 \
    --format both \
    --output-dir data

echo "✓ Medium dataset generated"
echo ""

# Check if Kafka is running
if docker ps | grep -q kafka; then
    echo "Kafka is running. Would you like to load data into Kafka? (y/n)"
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        # Find the most recent dataset
        latest_file=$(ls -t data/timeseries_data_*.csv | head -n 1)
        
        echo "Loading data from $latest_file into Kafka..."
        python3 scripts/kafka_playback.py \
            --input "$latest_file" \
            --topic metrics \
            --bootstrap-servers localhost:9092 \
            --speed 10.0 \
            --limit 10000
        
        echo "✓ Data loaded into Kafka"
    fi
else
    echo "⚠️  Kafka is not running. Start services with: docker-compose up -d"
fi

echo ""
echo "========================================"
echo "  Data Seeding Complete!"
echo "========================================"
echo ""
echo "Generated files in data/ directory:"
ls -lh data/timeseries_*
echo ""
