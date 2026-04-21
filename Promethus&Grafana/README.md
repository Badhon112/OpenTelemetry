# Prometheus, Grafana and Node Exporter

---

-> Day 1

- **What is Prometheus**
  - Prometheus is an open source linux server monitoring tool mainly used for metrics monitoring, event monitoring, alert management, etc.
  - Prometheus has changed the way of monitoring systems and that is why it has become the Top -Level project of Cloud Native Computing Foundation (CNCF).
  - Prometheus uses a powerful query language i.e. "promQL".
  - In Prometheus tabs handles hundreds of services and microservices.
  - Prometheus use multiple modes used for graphing and dashboard-ing support.

- **Prometheus Configuration file and Components**
  - **prometheus.yml** : It is the configuration file for prometheus where we can do all changes regarding configuration of Prometheus.
  - **Promtool** : It is command-line utility tool is used to verify the configuration of Prometheus.
  - **PromQl** : Prometheus uses its own query language e.x. PromQl which is very powerful querying language.
  - PromQl allows the user to select and aggregate the data.
  - 9090 port for Prometheus

- **What is Grafana**
  - Grafana is a free and open source visualization tool mostly used with Prometheus to which monitor metrics.
  - Grafana provides various dashboards, charts, graphs, alerts for the particular data source.
  - Grafana allows us to query, visualize, explore metrics and set alerts for the data source which can be a system, server, nodes, cluster, etc.
  - 3000 port for grafana

- **What is Node Exporter**
  - Node exporter is one of the Prometheus exports which is used to expose servers or system Os metrics
  - With the help of node exporter we can expose various resources of the system like RAM, CPU utilization, Memory Utilization, disk space.
  - Node exporter runs as a system service which gathers the metrics of your system and that gathered metrics is displayed with the help of Grafana visualization tool.
  - 9100 port for grafana

![Server Monitoring Using Prometheus and Grafana](./servermonitoring.png)

- **Install Prometheus in Linux**

```bash
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

```

- Check Prometheus Version
  $ prometheus --version
  $ promtool --version

- Prometheus configuration file
  $ cat /etc/prometheus/prometheus.yml

---

- **Install Grafana in Linux**

```bash
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
```

---

- **Install Node Exporter**

```bash
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

```

---

- **Configure the node exporter as a Prometheus target**
  - Now to scrape the node_exporter lets instruct the prometheus by making a minor change in prometheus.yml file
  - So go to etc/prometheus and open prometheus.yml
    - cd /etc/prometheus
    - sudo vim prometheus.yml
  - Now in static_configs in your configuration file replace the target line with below one
    - targets: ['localhost:9090','localhost:9100']
  - Now restart the Prometheus
    - sudo systemctl restart prometheus

---

-> Day 2
