#!/usr/bin/env python3
"""
Kafka Playback Script

Replays time series data from CSV/Parquet files into Kafka topics.
Supports real-time simulation with configurable speed multiplier.
"""

import argparse
import json
import time
from pathlib import Path
from datetime import datetime, timedelta
import pandas as pd
import sys

# Kafka import with fallback
try:
    from kafka import KafkaProducer
    from kafka.errors import KafkaError
    KAFKA_AVAILABLE = True
except ImportError:
    KAFKA_AVAILABLE = False
    print("WARNING: kafka-python not installed. Run: pip install kafka-python")


class KafkaDataPlayback:
    """Replay time series data into Kafka topics."""
    
    def __init__(self, bootstrap_servers, topic, speed_multiplier=1.0):
        """
        Initialize Kafka playback.
        
        Args:
            bootstrap_servers: Kafka bootstrap servers (e.g., 'localhost:9092')
            topic: Kafka topic name
            speed_multiplier: Speed multiplier for replay (1.0 = real-time)
        """
        if not KAFKA_AVAILABLE:
            raise RuntimeError("kafka-python is not installed")
        
        self.topic = topic
        self.speed_multiplier = speed_multiplier
        self.producer = KafkaProducer(
            bootstrap_servers=bootstrap_servers,
            value_serializer=lambda v: json.dumps(v).encode('utf-8'),
            key_serializer=lambda k: str(k).encode('utf-8') if k else None
        )
        self.messages_sent = 0
        self.start_time = None
    
    def send_message(self, key, value, timestamp=None):
        """
        Send a message to Kafka.
        
        Args:
            key: Message key (series_id)
            value: Message value (dict with metrics)
            timestamp: Optional timestamp for the message
        """
        try:
            future = self.producer.send(
                self.topic,
                key=key,
                value=value,
                timestamp_ms=int(timestamp.timestamp() * 1000) if timestamp else None
            )
            # Wait for send to complete
            future.get(timeout=10)
            self.messages_sent += 1
            return True
        except KafkaError as e:
            print(f"Error sending message: {e}")
            return False
    
    def replay_dataframe(self, df, group_by_timestamp=True):
        """
        Replay data from DataFrame into Kafka.
        
        Args:
            df: DataFrame with time series data
            group_by_timestamp: If True, group by timestamp and replay in temporal order
        """
        print(f"Starting Kafka playback to topic '{self.topic}'...")
        print(f"Speed multiplier: {self.speed_multiplier}x")
        print(f"Total records: {len(df)}")
        print("-" * 60)
        
        self.start_time = time.time()
        
        if group_by_timestamp:
            # Group by timestamp and replay in order
            df = df.sort_values('timestamp')
            grouped = df.groupby('timestamp')
            
            prev_timestamp = None
            
            for timestamp, group in grouped:
                # Calculate sleep time based on time difference and speed multiplier
                if prev_timestamp is not None:
                    time_diff = (timestamp - prev_timestamp).total_seconds()
                    sleep_time = time_diff / self.speed_multiplier
                    if sleep_time > 0:
                        time.sleep(sleep_time)
                
                # Send all records for this timestamp
                for _, row in group.iterrows():
                    message = {
                        'timestamp': timestamp.isoformat(),
                        'series_id': int(row['series_id']),
                        'latency_ms': float(row['latency_ms']) if pd.notna(row['latency_ms']) else None,
                        'error_rate_pct': float(row['error_rate_pct']) if pd.notna(row['error_rate_pct']) else None,
                        'throughput_rps': float(row['throughput_rps']) if pd.notna(row['throughput_rps']) else None,
                        'is_anomaly': int(row['is_anomaly'])
                    }
                    
                    self.send_message(
                        key=str(row['series_id']),
                        value=message,
                        timestamp=timestamp
                    )
                
                prev_timestamp = timestamp
                
                # Print progress
                if self.messages_sent % 1000 == 0:
                    elapsed = time.time() - self.start_time
                    rate = self.messages_sent / elapsed
                    print(f"Sent {self.messages_sent} messages ({rate:.1f} msg/s)")
        
        else:
            # Send all records as fast as possible
            for _, row in df.iterrows():
                timestamp = pd.to_datetime(row['timestamp'])
                message = {
                    'timestamp': timestamp.isoformat(),
                    'series_id': int(row['series_id']),
                    'latency_ms': float(row['latency_ms']) if pd.notna(row['latency_ms']) else None,
                    'error_rate_pct': float(row['error_rate_pct']) if pd.notna(row['error_rate_pct']) else None,
                    'throughput_rps': float(row['throughput_rps']) if pd.notna(row['throughput_rps']) else None,
                    'is_anomaly': int(row['is_anomaly'])
                }
                
                self.send_message(
                    key=str(row['series_id']),
                    value=message,
                    timestamp=timestamp
                )
                
                # Print progress
                if self.messages_sent % 1000 == 0:
                    elapsed = time.time() - self.start_time
                    rate = self.messages_sent / elapsed
                    print(f"Sent {self.messages_sent} messages ({rate:.1f} msg/s)")
    
    def close(self):
        """Close Kafka producer and print statistics."""
        if self.producer:
            self.producer.flush()
            self.producer.close()
        
        if self.start_time:
            elapsed = time.time() - self.start_time
            rate = self.messages_sent / elapsed if elapsed > 0 else 0
            print("\n" + "=" * 60)
            print(f"Playback complete!")
            print(f"Total messages sent: {self.messages_sent}")
            print(f"Elapsed time: {elapsed:.2f}s")
            print(f"Average rate: {rate:.1f} msg/s")
            print("=" * 60)


def load_data(input_path):
    """
    Load data from CSV or Parquet file.
    
    Args:
        input_path: Path to input file
        
    Returns:
        DataFrame with loaded data
    """
    path = Path(input_path)
    
    if not path.exists():
        raise FileNotFoundError(f"Input file not found: {input_path}")
    
    print(f"Loading data from {input_path}...")
    
    if path.suffix == '.csv':
        df = pd.read_csv(input_path, parse_dates=['timestamp'])
    elif path.suffix == '.parquet':
        df = pd.read_parquet(input_path)
    else:
        raise ValueError(f"Unsupported file format: {path.suffix}")
    
    print(f"✓ Loaded {len(df)} records")
    print(f"  Date range: {df['timestamp'].min()} to {df['timestamp'].max()}")
    print(f"  Series count: {df['series_id'].nunique()}")
    
    return df


def main():
    """Main function for Kafka playback."""
    parser = argparse.ArgumentParser(description='Replay time series data into Kafka')
    parser.add_argument('--input', '-i', required=True,
                       help='Input CSV or Parquet file')
    parser.add_argument('--topic', '-t', default='metrics',
                       help='Kafka topic name (default: metrics)')
    parser.add_argument('--bootstrap-servers', '-b', default='localhost:9092',
                       help='Kafka bootstrap servers (default: localhost:9092)')
    parser.add_argument('--speed', '-s', type=float, default=1.0,
                       help='Speed multiplier (default: 1.0 = real-time)')
    parser.add_argument('--no-timing', action='store_true',
                       help='Send all messages as fast as possible (ignore timestamps)')
    parser.add_argument('--limit', '-l', type=int, default=None,
                       help='Limit number of records to replay (for testing)')
    
    args = parser.parse_args()
    
    if not KAFKA_AVAILABLE:
        print("ERROR: kafka-python is not installed")
        print("Install with: pip install kafka-python")
        sys.exit(1)
    
    try:
        # Load data
        df = load_data(args.input)
        
        # Limit records if specified
        if args.limit:
            df = df.head(args.limit)
            print(f"Limited to first {args.limit} records")
        
        # Initialize Kafka playback
        playback = KafkaDataPlayback(
            bootstrap_servers=args.bootstrap_servers,
            topic=args.topic,
            speed_multiplier=args.speed
        )
        
        # Replay data
        playback.replay_dataframe(df, group_by_timestamp=not args.no_timing)
        
        # Close and print statistics
        playback.close()
        
    except KeyboardInterrupt:
        print("\n\nPlayback interrupted by user")
        if 'playback' in locals():
            playback.close()
        sys.exit(0)
    except Exception as e:
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
