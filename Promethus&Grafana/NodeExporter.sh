# #!/bin/bash

# set -e

# echo "🔄 Updating system..."
# sudo yum update -y
# wget https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-amd64.tar.gz
# tar xvfz node_exporter-1.10.2.linux-amd64.tar.gz
# cd node_exporter-1.10.2.linux-amd64
# sudo cp node_exporter /usr/local/bin/
# sudo useradd --no-create-home --shell /bin/false node_exporter
# sudo nano /etc/systemd/system/node_exporter.service
# [Unit]
# Description=Node Exporter
# Wants=network-online.target
# After=network-online.target

# [Service]
# User=node_exporter
# ExecStart=/usr/local/bin/node_exporter

# Restart=always

# [Install]
# WantedBy=multi-user.target

# sudo systemctl daemon-reload
# sudo systemctl start node_exporter
# sudo systemctl enable node_exporter
# sudo systemctl status node_exporter


# --- 
#!/bin/bash

set -e

NODE_EXPORTER_VERSION="1.10.2"

echo "🔄 Updating system..."
sudo yum update -y

echo "⬇️ Downloading Node Exporter..."
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-amd64.tar.gz

echo "📦 Extracting..."
tar -xvf node_exporter-1.10.2.linux-amd64.tar.gz

cd node_exporter-1.10.2.linux-amd64

echo "🚚 Installing binary..."
sudo cp node_exporter /usr/local/bin/

echo "👤 Creating user..."
sudo useradd --no-create-home --shell /bin/false node_exporter || true

echo "🧩 Creating systemd service..."
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 Reloading systemd..."
sudo systemctl daemon-reload

echo "🚀 Starting Node Exporter..."
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

echo "📊 Checking status..."
sudo systemctl status node_exporter --no-pager

echo ""
echo "✅ Node Exporter is running at: http://<EC2-IP>:9100/metrics"
