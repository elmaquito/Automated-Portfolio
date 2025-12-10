#!/usr/bin/env python3
"""
Time Series Data Generator with Anomaly Injection

Generates synthetic multivariate time series data simulating system metrics:
- latency (ms)
- error_rate (%)
- throughput (req/s)

Includes various anomaly types:
- spike: sudden short-term increase/decrease
- level_shift: persistent change in baseline
- gradual_drift: slow trend change over time
- missing_values: gaps in data
- seasonal_change: altered seasonal patterns
"""

import numpy as np
import pandas as pd
import argparse
from datetime import datetime, timedelta
from pathlib import Path
import json


class TimeSeriesGenerator:
    """Generate synthetic time series with configurable anomalies."""
    
    def __init__(self, n_series=1000, n_points=1440, freq='1min', seed=42):
        """
        Initialize time series generator.
        
        Args:
            n_series: Number of time series to generate
            n_points: Number of data points per series
            freq: Frequency of data points (e.g., '1min', '5min', '1H')
            seed: Random seed for reproducibility
        """
        self.n_series = n_series
        self.n_points = n_points
        self.freq = freq
        self.seed = seed
        np.random.seed(seed)
        
    def generate_baseline(self, base_value, noise_level=0.1):
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
        return np.maximum(baseline, 0)  # Ensure non-negative values
    
    def add_seasonality(self, series, period=60, amplitude=0.2):
        """
        Add seasonal pattern to series.
        
        Args:
            series: Input time series
            period: Period of seasonality (in data points)
            amplitude: Amplitude of seasonal variation (relative to mean)
            
        Returns:
            Series with added seasonality
        """
        t = np.arange(self.n_points)
        seasonal = amplitude * np.mean(series) * np.sin(2 * np.pi * t / period)
        return series + seasonal
    
    def inject_spike(self, series, position, duration=5, magnitude=3.0):
        """
        Inject spike anomaly.
        
        Args:
            series: Input time series
            position: Position of spike (data point index)
            duration: Duration of spike in data points
            magnitude: Spike magnitude (multiplier of local mean)
            
        Returns:
            Series with spike anomaly and anomaly label
        """
        series_copy = series.copy()
        labels = np.zeros(len(series), dtype=int)
        
        end_pos = min(position + duration, len(series))
        local_mean = np.mean(series[max(0, position-10):position+10])
        series_copy[position:end_pos] *= magnitude
        labels[position:end_pos] = 1  # Mark as anomaly
        
        return series_copy, labels
    
    def inject_level_shift(self, series, position, shift_magnitude=0.5):
        """
        Inject level shift anomaly.
        
        Args:
            series: Input time series
            position: Position where level shift occurs
            shift_magnitude: Magnitude of shift (relative to mean)
            
        Returns:
            Series with level shift and anomaly labels
        """
        series_copy = series.copy()
        labels = np.zeros(len(series), dtype=int)
        
        mean_val = np.mean(series)
        series_copy[position:] += shift_magnitude * mean_val
        labels[position:] = 1  # Mark as anomaly
        
        return series_copy, labels
    
    def inject_gradual_drift(self, series, start_pos, end_pos, drift_magnitude=0.3):
        """
        Inject gradual drift anomaly.
        
        Args:
            series: Input time series
            start_pos: Start position of drift
            end_pos: End position of drift
            drift_magnitude: Magnitude of drift (relative to mean)
            
        Returns:
            Series with gradual drift and anomaly labels
        """
        series_copy = series.copy()
        labels = np.zeros(len(series), dtype=int)
        
        # Ensure end_pos doesn't exceed series length
        end_pos = min(end_pos, len(series))
        
        mean_val = np.mean(series)
        duration = end_pos - start_pos
        drift = np.linspace(0, drift_magnitude * mean_val, duration)
        series_copy[start_pos:end_pos] += drift
        labels[start_pos:end_pos] = 1  # Mark as anomaly
        
        return series_copy, labels
    
    def inject_missing_values(self, series, position, duration=10):
        """
        Inject missing values.
        
        Args:
            series: Input time series
            position: Start position of missing values
            duration: Duration of missing values
            
        Returns:
            Series with missing values and anomaly labels
        """
        series_copy = series.copy()
        labels = np.zeros(len(series), dtype=int)
        
        end_pos = min(position + duration, len(series))
        series_copy[position:end_pos] = np.nan
        labels[position:end_pos] = 1  # Mark as anomaly
        
        return series_copy, labels
    
    def inject_seasonal_change(self, series, position, old_period=60, new_period=40):
        """
        Inject change in seasonal pattern.
        
        Args:
            series: Input time series
            position: Position where seasonal pattern changes
            old_period: Original seasonal period
            new_period: New seasonal period
            
        Returns:
            Series with seasonal change and anomaly labels
        """
        series_copy = series.copy()
        labels = np.zeros(len(series), dtype=int)
        
        # Remove old seasonality from second part
        t = np.arange(self.n_points)
        amplitude = 0.2 * np.mean(series)
        old_seasonal = amplitude * np.sin(2 * np.pi * t / old_period)
        new_seasonal = amplitude * np.sin(2 * np.pi * t / new_period)
        
        series_copy[position:] = series_copy[position:] - old_seasonal[position:] + new_seasonal[position:]
        labels[position:] = 1  # Mark as anomaly
        
        return series_copy, labels
    
    def generate_metric_series(self, metric_type, anomaly_config=None):
        """
        Generate single metric time series with optional anomalies.
        
        Args:
            metric_type: Type of metric ('latency', 'error_rate', 'throughput')
            anomaly_config: Configuration dict for anomaly injection
            
        Returns:
            Tuple of (series, labels, anomaly_type)
        """
        # Define baseline parameters for each metric type
        metric_params = {
            'latency': {'base': 100, 'noise': 0.15, 'period': 60, 'amplitude': 0.2},
            'error_rate': {'base': 2.0, 'noise': 0.3, 'period': 60, 'amplitude': 0.25},
            'throughput': {'base': 1000, 'noise': 0.1, 'period': 60, 'amplitude': 0.15}
        }
        
        params = metric_params.get(metric_type, metric_params['latency'])
        
        # Generate baseline
        series = self.generate_baseline(params['base'], params['noise'])
        series = self.add_seasonality(series, params['period'], params['amplitude'])
        
        labels = np.zeros(len(series), dtype=int)
        anomaly_type = 'normal'
        
        # Inject anomaly if configured
        if anomaly_config:
            anomaly_type = anomaly_config['type']
            position = anomaly_config.get('position', self.n_points // 2)
            
            if anomaly_type == 'spike':
                series, labels = self.inject_spike(
                    series, position,
                    duration=anomaly_config.get('duration', 5),
                    magnitude=anomaly_config.get('magnitude', 3.0)
                )
            elif anomaly_type == 'level_shift':
                series, labels = self.inject_level_shift(
                    series, position,
                    shift_magnitude=anomaly_config.get('magnitude', 0.5)
                )
            elif anomaly_type == 'gradual_drift':
                end_pos = anomaly_config.get('end_position', position + 200)
                series, labels = self.inject_gradual_drift(
                    series, position, end_pos,
                    drift_magnitude=anomaly_config.get('magnitude', 0.3)
                )
            elif anomaly_type == 'missing_values':
                series, labels = self.inject_missing_values(
                    series, position,
                    duration=anomaly_config.get('duration', 10)
                )
            elif anomaly_type == 'seasonal_change':
                series, labels = self.inject_seasonal_change(
                    series, position,
                    old_period=params['period'],
                    new_period=anomaly_config.get('new_period', 40)
                )
        
        return series, labels, anomaly_type
    
    def generate_dataset(self, anomaly_ratio=0.3):
        """
        Generate complete multivariate time series dataset.
        
        Args:
            anomaly_ratio: Ratio of series with anomalies (0.0 to 1.0)
            
        Returns:
            DataFrame with all time series and metadata
        """
        # Reset random seed for reproducibility
        np.random.seed(self.seed)
        
        print(f"Generating {self.n_series} time series...")
        
        # Create timestamp index
        start_time = datetime.now() - timedelta(minutes=self.n_points)
        timestamps = pd.date_range(start=start_time, periods=self.n_points, freq=self.freq)
        
        all_data = []
        metadata = []
        
        anomaly_types = ['spike', 'level_shift', 'gradual_drift', 'missing_values', 'seasonal_change']
        n_anomalies = int(self.n_series * anomaly_ratio)
        
        for i in range(self.n_series):
            # Determine if this series should have an anomaly
            has_anomaly = i < n_anomalies
            anomaly_config = None
            
            if has_anomaly:
                anomaly_type = np.random.choice(anomaly_types)
                position = np.random.randint(self.n_points // 4, 3 * self.n_points // 4)
                
                anomaly_config = {
                    'type': anomaly_type,
                    'position': position,
                    'duration': np.random.randint(3, 15),
                    'magnitude': np.random.uniform(2.0, 4.0),
                    'end_position': position + np.random.randint(100, 300),
                    'new_period': np.random.randint(30, 70)
                }
            
            # Generate each metric
            latency, latency_labels, latency_anomaly = self.generate_metric_series('latency', anomaly_config)
            error_rate, error_labels, error_anomaly = self.generate_metric_series('error_rate', anomaly_config)
            throughput, throughput_labels, throughput_anomaly = self.generate_metric_series('throughput', anomaly_config)
            
            # Combine labels (any metric with anomaly marks the timestamp as anomalous)
            combined_labels = np.maximum.reduce([latency_labels, error_labels, throughput_labels])
            
            # Create dataframe for this series
            series_df = pd.DataFrame({
                'timestamp': timestamps,
                'series_id': i,
                'latency_ms': latency,
                'error_rate_pct': error_rate,
                'throughput_rps': throughput,
                'is_anomaly': combined_labels
            })
            
            all_data.append(series_df)
            
            # Store metadata
            metadata.append({
                'series_id': i,
                'has_anomaly': has_anomaly,
                'anomaly_type': latency_anomaly if has_anomaly else 'normal',
                'anomaly_count': int(np.sum(combined_labels))
            })
            
            if (i + 1) % 100 == 0:
                print(f"  Generated {i + 1}/{self.n_series} series...")
        
        # Combine all series
        df = pd.concat(all_data, ignore_index=True)
        metadata_df = pd.DataFrame(metadata)
        
        print(f"✓ Generated {self.n_series} series with {n_anomalies} anomalous series")
        print(f"✓ Total data points: {len(df)}")
        print(f"✓ Anomalous points: {df['is_anomaly'].sum()} ({100*df['is_anomaly'].mean():.2f}%)")
        
        return df, metadata_df


def main():
    """Main function to generate and save time series data."""
    parser = argparse.ArgumentParser(description='Generate synthetic time series data with anomalies')
    parser.add_argument('--n-series', type=int, default=1000,
                       help='Number of time series to generate (default: 1000)')
    parser.add_argument('--n-points', type=int, default=1440,
                       help='Number of points per series (default: 1440 = 24 hours at 1min)')
    parser.add_argument('--freq', type=str, default='1min',
                       help='Frequency of data points (default: 1min)')
    parser.add_argument('--anomaly-ratio', type=float, default=0.3,
                       help='Ratio of series with anomalies (default: 0.3)')
    parser.add_argument('--output-dir', type=str, default='data',
                       help='Output directory for generated data (default: data)')
    parser.add_argument('--format', type=str, choices=['csv', 'parquet', 'both'], default='both',
                       help='Output format (default: both)')
    parser.add_argument('--seed', type=int, default=42,
                       help='Random seed for reproducibility (default: 42)')
    
    args = parser.parse_args()
    
    # Create output directory
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    print("=" * 60)
    print("Time Series Generator - Anomaly Detection Dataset")
    print("=" * 60)
    print(f"Configuration:")
    print(f"  Number of series: {args.n_series}")
    print(f"  Points per series: {args.n_points}")
    print(f"  Frequency: {args.freq}")
    print(f"  Anomaly ratio: {args.anomaly_ratio}")
    print(f"  Random seed: {args.seed}")
    print(f"  Output directory: {output_dir}")
    print("=" * 60)
    
    # Generate dataset
    generator = TimeSeriesGenerator(
        n_series=args.n_series,
        n_points=args.n_points,
        freq=args.freq,
        seed=args.seed
    )
    
    df, metadata_df = generator.generate_dataset(anomaly_ratio=args.anomaly_ratio)
    
    # Save data
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    
    if args.format in ['csv', 'both']:
        csv_path = output_dir / f'timeseries_data_{timestamp}.csv'
        metadata_csv_path = output_dir / f'timeseries_metadata_{timestamp}.csv'
        print(f"\nSaving CSV files...")
        df.to_csv(csv_path, index=False)
        metadata_df.to_csv(metadata_csv_path, index=False)
        print(f"  ✓ Data: {csv_path}")
        print(f"  ✓ Metadata: {metadata_csv_path}")
    
    if args.format in ['parquet', 'both']:
        parquet_path = output_dir / f'timeseries_data_{timestamp}.parquet'
        metadata_parquet_path = output_dir / f'timeseries_metadata_{timestamp}.parquet'
        print(f"\nSaving Parquet files...")
        df.to_parquet(parquet_path, index=False)
        metadata_df.to_parquet(metadata_parquet_path, index=False)
        print(f"  ✓ Data: {parquet_path}")
        print(f"  ✓ Metadata: {metadata_parquet_path}")
    
    # Save generation config
    config = {
        'generation_timestamp': timestamp,
        'n_series': args.n_series,
        'n_points': args.n_points,
        'freq': args.freq,
        'anomaly_ratio': args.anomaly_ratio,
        'seed': args.seed,
        'total_points': len(df),
        'anomalous_points': int(df['is_anomaly'].sum()),
        'anomalous_series': int(metadata_df['has_anomaly'].sum())
    }
    
    config_path = output_dir / f'generation_config_{timestamp}.json'
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=2)
    print(f"  ✓ Config: {config_path}")
    
    print("\n" + "=" * 60)
    print("✓ Dataset generation complete!")
    print("=" * 60)


if __name__ == '__main__':
    main()
