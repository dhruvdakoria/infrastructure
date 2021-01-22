#!/bin/bash
usermod -a -G docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
mkdir /home/ec2-user/prometheus/
cat <<EOF >/home/ec2-user/prometheus/prometheus.yml
global:
  scrape_interval: 5s
  external_labels:
    monitor: 'devopsage-monitor'
scrape_configs:
  - job_name: ecs_CAAdvisor
    ec2_sd_configs:
      - region: us-east-1
        port: 9200
  - job_name: ecs_NodeExporter
    ec2_sd_configs:
      - region: us-east-1
        port: 9100
EOF
cat <<EOF >/home/ec2-user/docker-compose.yml
version: "3"

networks:
  monitoring:

volumes:
    prometheus_data: {}

services:
  loki:
    image: grafana/loki:2.0.0
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:latest
    ports:
      - "80:3000"
    networks:
      - monitoring

  prometheus:
    image: prom/prometheus:v2.4.0
    volumes:
      - ./prometheus/:/etc/prometheus/
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'
    ports:
      - 9090:9090
    networks:
      - monitoring
    restart: always
EOF
chown ec2-user:ec2-user /home/ec2-user/docker-compose.yml
/usr/local/bin/docker-compose -f /home/ec2-user/docker-compose.yml up -d