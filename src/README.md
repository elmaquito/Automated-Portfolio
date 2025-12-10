# Source Code Directory

This directory contains the application source code for data collection, ingestion, and model training.

## Directory Structure

```
src/
├── collector/           # Data collection and generation
│   └── generate_timeseries.py   # Time series data generator
├── ingestion/          # Data ingestion and preprocessing
│   └── consumer.py              # Kafka consumer
├── models/             # Machine learning models
│   ├── training/               # Model training scripts
│   └── serving/                # Model serving (TensorFlow SavedModel)
├── tests/              # Unit and integration tests
│   └── test_generator.py       # Tests for data generator
└── README.md
```

## Components

### Collector
Data collection and generation components.

**Files**:
- `generate_timeseries.py`: Synthetic time series generator with anomaly injection

**Usage**:
```bash
python src/collector/generate_timeseries.py \
  --n-series 1000 \
  --n-points 1440 \
  --anomaly-ratio 0.3 \
  --output-dir data
```

### Ingestion
Data ingestion and preprocessing pipeline.

**Files**:
- `consumer.py`: Kafka consumer for time series metrics

**Usage**:
```bash
# Using environment variables
export KAFKA_BOOTSTRAP_SERVERS=localhost:9092
export KAFKA_TOPIC=metrics
python src/ingestion/consumer.py

# Or with Docker
docker-compose up ingestion
```

### Models
Machine learning models for anomaly detection.

**Structure**:
- `training/`: Training scripts and notebooks
- `serving/`: Deployed models in TensorFlow SavedModel format

**Future Features** (Phase 2):
- Baseline models (Isolation Forest, LOF)
- Deep learning models (LSTM, Autoencoder)
- Model evaluation and comparison
- Hyperparameter tuning

### Tests
Unit and integration tests.

**Running Tests**:
```bash
# Run all tests
pytest src/tests/

# Run specific test file
pytest src/tests/test_generator.py

# Run with coverage
pytest --cov=src --cov-report=html src/tests/

# Run verbose
pytest -v src/tests/
```

## Development Setup

### Prerequisites
- Python 3.11+
- pip or conda

### Installation

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Install development dependencies
pip install pytest pytest-cov black flake8
```

### Code Quality

```bash
# Format code
black src/

# Lint code
flake8 src/

# Run tests
pytest src/tests/

# Type checking (if using mypy)
mypy src/
```

## Code Style

This project follows:
- **PEP 8** style guide
- **Black** code formatter (line length: 100)
- **Type hints** for function signatures
- **Docstrings** for all public functions and classes

### Example
```python
def generate_baseline(self, base_value: float, noise_level: float = 0.1) -> np.ndarray:
    """
    Generate baseline time series with noise.
    
    Args:
        base_value: Mean value for the series
        noise_level: Standard deviation of noise (relative to base_value)
        
    Returns:
        numpy array of baseline values
    """
    noise = np.random.normal(0, base_value * noise_level, self.n_points)
    baseline = base_value + noise
    return np.maximum(baseline, 0)
```

## Testing Guidelines

### Test Structure
- Use pytest fixtures for common setup
- Parametrize tests when testing multiple scenarios
- Mock external dependencies (Kafka, Elasticsearch)
- Test edge cases and error conditions

### Example Test
```python
def test_generate_baseline(self, generator):
    """Test baseline generation."""
    baseline = generator.generate_baseline(100, 0.1)
    
    assert len(baseline) == 100
    assert np.all(baseline >= 0)
    assert np.mean(baseline) > 0
    assert np.std(baseline) > 0
```

## Environment Variables

### Collector
```bash
KAFKA_BOOTSTRAP_SERVERS=localhost:9092
PROMETHEUS_PUSHGATEWAY=localhost:9091
```

### Ingestion
```bash
KAFKA_BOOTSTRAP_SERVERS=localhost:9092
KAFKA_TOPIC=metrics
KAFKA_GROUP_ID=metrics-consumer
ELASTICSEARCH_HOST=localhost:9200
```

## Docker Usage

### Build Images
```bash
# Build collector image
docker build -f infra/dockerfiles/Dockerfile.collector -t collector:latest .

# Build ingestion image
docker build -f infra/dockerfiles/Dockerfile.ingestion -t ingestion:latest .
```

### Run Containers
```bash
# Run collector
docker run -v $(pwd)/data:/app/data collector:latest

# Run ingestion
docker run -e KAFKA_BOOTSTRAP_SERVERS=kafka:29092 ingestion:latest
```

## Contributing

1. Create a feature branch
2. Write tests for new functionality
3. Ensure all tests pass
4. Format code with Black
5. Update documentation
6. Submit pull request

## Future Work (Phase 2+)

### Preprocessing
- [ ] Data cleaning pipeline
- [ ] Feature engineering
- [ ] Normalization/standardization
- [ ] Missing value imputation

### Model Training
- [ ] Baseline models (IsolationForest, LOF, DBSCAN)
- [ ] Deep learning models (LSTM, GRU, Autoencoder, VAE)
- [ ] Ensemble methods
- [ ] Hyperparameter optimization

### Model Serving
- [ ] TensorFlow Serving integration
- [ ] REST API for predictions
- [ ] Real-time anomaly detection
- [ ] Model versioning and A/B testing

### Monitoring
- [ ] Model performance tracking
- [ ] Data drift detection
- [ ] Alert generation
- [ ] Dashboard integration

## References

- [Data Directory](../data/README.md)
- [Infrastructure](../infra/README.md)
- [Scripts](../scripts/README.md)
- [Phase 1 MVP](../docs/phase1/MVP.md)
