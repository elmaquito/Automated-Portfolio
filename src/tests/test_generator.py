"""
Tests for time series generator
"""

import pytest
import numpy as np
import pandas as pd
from pathlib import Path
import sys

# Add src directory to path for testing
sys.path.insert(0, str(Path(__file__).parent.parent))

try:
    from collector.generate_timeseries import TimeSeriesGenerator
except ImportError:
    from src.collector.generate_timeseries import TimeSeriesGenerator


class TestTimeSeriesGenerator:
    """Test suite for TimeSeriesGenerator."""
    
    @pytest.fixture
    def generator(self):
        """Create a generator instance for testing."""
        return TimeSeriesGenerator(n_series=10, n_points=100, freq='1min', seed=42)
    
    def test_initialization(self, generator):
        """Test generator initialization."""
        assert generator.n_series == 10
        assert generator.n_points == 100
        assert generator.freq == '1min'
        assert generator.seed == 42
    
    def test_generate_baseline(self, generator):
        """Test baseline generation."""
        baseline = generator.generate_baseline(100, 0.1)
        
        assert len(baseline) == 100
        assert np.all(baseline >= 0)  # Non-negative values
        assert np.mean(baseline) > 0  # Has positive mean
        assert np.std(baseline) > 0   # Has variance
    
    def test_add_seasonality(self, generator):
        """Test seasonality addition."""
        series = np.ones(100) * 100
        seasonal = generator.add_seasonality(series, period=20, amplitude=0.2)
        
        assert len(seasonal) == 100
        assert not np.array_equal(series, seasonal)  # Modified
        # Check that seasonality has expected amplitude
        deviation = seasonal - series
        assert np.max(np.abs(deviation)) > 0
    
    def test_inject_spike(self, generator):
        """Test spike anomaly injection."""
        series = np.ones(100) * 100
        modified, labels = generator.inject_spike(series, position=50, duration=5, magnitude=3.0)
        
        assert len(modified) == 100
        assert len(labels) == 100
        assert np.sum(labels) == 5  # 5 anomalous points
        assert np.max(modified[50:55]) > np.max(series) * 2  # Spike is significant
    
    def test_inject_level_shift(self, generator):
        """Test level shift anomaly injection."""
        series = np.ones(100) * 100
        modified, labels = generator.inject_level_shift(series, position=50, shift_magnitude=0.5)
        
        assert len(modified) == 100
        assert len(labels) == 100
        assert np.sum(labels) == 50  # Second half is anomalous
        # Check that level shift occurred
        assert np.mean(modified[50:]) > np.mean(series[:50])
    
    def test_inject_gradual_drift(self, generator):
        """Test gradual drift anomaly injection."""
        series = np.ones(100) * 100
        modified, labels = generator.inject_gradual_drift(series, start_pos=30, end_pos=70)
        
        assert len(modified) == 100
        assert len(labels) == 100
        assert np.sum(labels) == 40  # Drift region
        # Check that drift is gradual
        drift_region = modified[30:70]
        assert drift_region[0] < drift_region[-1]  # Increasing trend
    
    def test_inject_missing_values(self, generator):
        """Test missing values injection."""
        series = np.ones(100) * 100
        modified, labels = generator.inject_missing_values(series, position=50, duration=10)
        
        assert len(modified) == 100
        assert len(labels) == 100
        assert np.sum(labels) == 10  # 10 anomalous points
        assert np.sum(np.isnan(modified[50:60])) == 10  # NaN values present
    
    def test_generate_metric_series_normal(self, generator):
        """Test normal metric series generation."""
        series, labels, anomaly_type = generator.generate_metric_series('latency', anomaly_config=None)
        
        assert len(series) == 100
        assert len(labels) == 100
        assert anomaly_type == 'normal'
        assert np.sum(labels) == 0  # No anomalies
        assert np.all(series > 0)  # Positive values
    
    def test_generate_metric_series_with_anomaly(self, generator):
        """Test metric series generation with anomaly."""
        anomaly_config = {
            'type': 'spike',
            'position': 50,
            'duration': 5,
            'magnitude': 3.0
        }
        series, labels, anomaly_type = generator.generate_metric_series('latency', anomaly_config)
        
        assert len(series) == 100
        assert len(labels) == 100
        assert anomaly_type == 'spike'
        assert np.sum(labels) > 0  # Has anomalies
    
    def test_generate_dataset(self, generator):
        """Test complete dataset generation."""
        df, metadata_df = generator.generate_dataset(anomaly_ratio=0.3)
        
        # Check dataframe structure
        assert len(df) == 10 * 100  # n_series * n_points
        assert 'timestamp' in df.columns
        assert 'series_id' in df.columns
        assert 'latency_ms' in df.columns
        assert 'error_rate_pct' in df.columns
        assert 'throughput_rps' in df.columns
        assert 'is_anomaly' in df.columns
        
        # Check metadata
        assert len(metadata_df) == 10
        assert 'series_id' in metadata_df.columns
        assert 'has_anomaly' in metadata_df.columns
        assert 'anomaly_type' in metadata_df.columns
        
        # Check anomaly ratio
        n_anomalous = metadata_df['has_anomaly'].sum()
        assert n_anomalous == 3  # 30% of 10
    
    def test_reproducibility(self):
        """Test that same seed produces same results."""
        gen1 = TimeSeriesGenerator(n_series=5, n_points=50, seed=42)
        gen2 = TimeSeriesGenerator(n_series=5, n_points=50, seed=42)
        
        df1, _ = gen1.generate_dataset(anomaly_ratio=0.2)
        df2, _ = gen2.generate_dataset(anomaly_ratio=0.2)
        
        # Check that results are identical
        pd.testing.assert_frame_equal(
            df1[['latency_ms', 'error_rate_pct', 'throughput_rps', 'is_anomaly']],
            df2[['latency_ms', 'error_rate_pct', 'throughput_rps', 'is_anomaly']]
        )
    
    def test_different_seeds_produce_different_results(self):
        """Test that different seeds produce different results."""
        gen1 = TimeSeriesGenerator(n_series=5, n_points=50, seed=42)
        gen2 = TimeSeriesGenerator(n_series=5, n_points=50, seed=123)
        
        df1, _ = gen1.generate_dataset(anomaly_ratio=0.2)
        df2, _ = gen2.generate_dataset(anomaly_ratio=0.2)
        
        # Check that results are different
        assert not df1['latency_ms'].equals(df2['latency_ms'])


class TestAnomalyTypes:
    """Test different anomaly types."""
    
    @pytest.fixture
    def generator(self):
        return TimeSeriesGenerator(n_series=1, n_points=100, seed=42)
    
    @pytest.mark.parametrize("anomaly_type", [
        'spike', 'level_shift', 'gradual_drift', 'missing_values', 'seasonal_change'
    ])
    def test_anomaly_type(self, generator, anomaly_type):
        """Test that each anomaly type can be generated."""
        anomaly_config = {
            'type': anomaly_type,
            'position': 50,
            'duration': 5,
            'magnitude': 2.5,
            'end_position': 80,
            'new_period': 40
        }
        
        series, labels, result_type = generator.generate_metric_series('latency', anomaly_config)
        
        assert result_type == anomaly_type
        assert len(series) == 100
        assert len(labels) == 100
        assert np.sum(labels) > 0  # Has anomalies


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
