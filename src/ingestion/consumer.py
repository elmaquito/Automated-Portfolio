#!/usr/bin/env python3
"""
Kafka Consumer for Time Series Data Ingestion

Consumes time series metrics from Kafka and performs preprocessing.
"""

import json
import os
import sys
from datetime import datetime

# Kafka import with fallback
try:
    from kafka import KafkaConsumer
    from kafka.errors import KafkaError
    KAFKA_AVAILABLE = True
except ImportError:
    KAFKA_AVAILABLE = False
    print("WARNING: kafka-python not installed. Run: pip install kafka-python")


class MetricsConsumer:
    """Consume and process time series metrics from Kafka."""
    
    def __init__(self, bootstrap_servers, topic, group_id='metrics-consumer'):
        """
        Initialize Kafka consumer.
        
        Args:
            bootstrap_servers: Kafka bootstrap servers
            topic: Topic to consume from
            group_id: Consumer group ID
        """
        if not KAFKA_AVAILABLE:
            raise RuntimeError("kafka-python is not installed")
        
        self.topic = topic
        self.group_id = group_id
        self.consumer = KafkaConsumer(
            topic,
            bootstrap_servers=bootstrap_servers,
            group_id=group_id,
            value_deserializer=lambda m: json.loads(m.decode('utf-8')),
            auto_offset_reset='earliest',
            enable_auto_commit=True
        )
        self.message_count = 0
        self.anomaly_count = 0
        self.start_time = datetime.now()
        
    def process_message(self, message):
        """
        Process a single message.
        
        Args:
            message: Message from Kafka
            
        Returns:
            Processed data dict
        """
        data = message.value
        
        # Basic preprocessing
        processed = {
            'timestamp': data.get('timestamp'),
            'series_id': data.get('series_id'),
            'metrics': {
                'latency_ms': data.get('latency_ms'),
                'error_rate_pct': data.get('error_rate_pct'),
                'throughput_rps': data.get('throughput_rps')
            },
            'is_anomaly': data.get('is_anomaly', 0),
            'processed_at': datetime.now().isoformat()
        }
        
        # Count anomalies
        if processed['is_anomaly'] == 1:
            self.anomaly_count += 1
        
        return processed
    
    def consume(self):
        """Start consuming messages."""
        print(f"Starting consumer for topic '{self.topic}'...")
        print(f"Group ID: {self.group_id}")
        print("-" * 60)
        
        try:
            for message in self.consumer:
                # Process message
                processed = self.process_message(message)
                self.message_count += 1
                
                # Log progress
                if self.message_count % 1000 == 0:
                    elapsed = (datetime.now() - self.start_time).total_seconds()
                    rate = self.message_count / elapsed if elapsed > 0 else 0
                    anomaly_pct = (self.anomaly_count / self.message_count * 100) if self.message_count > 0 else 0
                    print(f"Processed {self.message_count} messages "
                          f"({rate:.1f} msg/s, {anomaly_pct:.1f}% anomalies)")
                
                # Here you would typically:
                # - Store in database (Elasticsearch, InfluxDB, etc.)
                # - Apply ML models for anomaly detection
                # - Send alerts for anomalies
                # - Update metrics/dashboards
                
        except KeyboardInterrupt:
            print("\nConsumer interrupted by user")
        finally:
            self.close()
    
    def close(self):
        """Close consumer and print statistics."""
        if self.consumer:
            self.consumer.close()
        
        elapsed = (datetime.now() - self.start_time).total_seconds()
        rate = self.message_count / elapsed if elapsed > 0 else 0
        anomaly_pct = (self.anomaly_count / self.message_count * 100) if self.message_count > 0 else 0
        
        print("\n" + "=" * 60)
        print("Consumer Statistics")
        print("=" * 60)
        print(f"Total messages: {self.message_count}")
        print(f"Anomalies: {self.anomaly_count} ({anomaly_pct:.1f}%)")
        print(f"Elapsed time: {elapsed:.2f}s")
        print(f"Average rate: {rate:.1f} msg/s")
        print("=" * 60)


def main():
    """Main function."""
    # Get configuration from environment
    bootstrap_servers = os.getenv('KAFKA_BOOTSTRAP_SERVERS', 'localhost:9092')
    topic = os.getenv('KAFKA_TOPIC', 'metrics')
    group_id = os.getenv('KAFKA_GROUP_ID', 'metrics-consumer')
    
    if not KAFKA_AVAILABLE:
        print("ERROR: kafka-python is not installed")
        print("Install with: pip install kafka-python")
        sys.exit(1)
    
    print("=" * 60)
    print("Metrics Consumer")
    print("=" * 60)
    print(f"Bootstrap servers: {bootstrap_servers}")
    print(f"Topic: {topic}")
    print(f"Group ID: {group_id}")
    print("=" * 60)
    print()
    
    try:
        consumer = MetricsConsumer(bootstrap_servers, topic, group_id)
        consumer.consume()
    except Exception as e:
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == '__main__':
    main()
