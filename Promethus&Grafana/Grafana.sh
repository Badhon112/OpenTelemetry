#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo yum update -y

echo "📦 Install Grafana manually..."
sudo yum install -y https://dl.grafana.com/grafana-enterprise/release/13.0.1/grafana-enterprise_13.0.1_24542347077_linux_amd64.rpm

echo "Start Grafana"
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

echo "Check status ... "
sudo systemctl status grafana-server