#!/bin/bash

set -e

echo "🔄 Updating system..."
sudo yum update -y

echo "👤 Creating Prometheus user..."
sudo useradd --no-create-home --shell /bin/false prometheus || true

echo "⬇️ Downloading Prometheus..."
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v3.11.2/prometheus-3.11.2.linux-amd64.tar.gz

echo "📦 Extracting..."
tar -xvf prometheus-3.11.2.linux-amd64.tar.gz
cd prometheus-3.11.2.linux-amd64

echo "🚚 Moving binaries..."
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/

echo "📁 Creating directories..."
sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

echo "⚙️ Copying configuration..."
sudo cp prometheus.yml /etc/prometheus/

echo "🔐 Setting permissions..."
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chown -R prometheus:prometheus /var/lib/prometheus

echo "🧩 Creating systemd service..."
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus

Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "🚀 Starting Prometheus..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

echo "✅ Checking status..."
sudo systemctl status prometheus --no-pager

echo ""
echo "🌐 Access Prometheus at: http://<YOUR_EC2_PUBLIC_IP>:9090"
echo "⚠️ Make sure port 9090 is open in Security Group"
