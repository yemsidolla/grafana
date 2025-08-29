# Remote Monitoring Agents

This directory contains Grafana Alloy agents that collect metrics and logs from remote servers and forward them to the central observability server.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMOTE AGENT                                 │
│                                                                 │
│                ┌─────────────────┐                            │
│                │  Grafana Alloy  │                            │
│                │  (Port 12345)   │                            │
│                │                 │                            │
│                │ Collects:       │                            │
│                │ • System metrics│                            │
│                │ • Container     │                            │
│                │   metrics       │                            │
│                │ • System logs   │                            │
│                │ • Container     │                            │
│                │   logs          │                            │
│                └─────────────────┘                            │
└─────────────────────────────────────────────────────────────────┘
                           │
                           │ (Pushes data to central server)
                           │
                ┌─────────────────┐
                │  Central Server │
                │  (Prometheus +  │
                │   Loki + etc.)  │
                └─────────────────┘
```

## 🚀 Quick Start

1. **Copy environment file:**
   ```bash
   cp env.example .env
   ```

2. **Update configuration:**
   - Edit `.env` with your central server details
   - Update URLs for Prometheus and Loki

3. **Start the agent:**
   ```bash
   docker-compose up -d
   ```

## 📊 What Alloy Collects

### Metrics (Forwarded to Prometheus)
- **System Metrics**: CPU, memory, disk, network (via `prometheus.exporter.unix`)
- **Container Metrics**: Docker container stats (via `prometheus.exporter.cadvisor`)
- **Process Metrics**: System process information

### Logs (Forwarded to Loki)
- **System Logs**: `/var/log/*.log`, `/var/log/syslog`, `/var/log/auth.log`
- **Container Logs**: Docker container logs via Docker socket
- **Filtered**: Removes noisy logs automatically

## ⚙️ Configuration

### Environment Variables
- `ALLOY_PORT`: Port for Alloy UI (default: 12345)
- `CENTRAL_SERVER_IP`: IP address of central observability server
- `CENTRAL_SERVER_HOSTNAME`: Hostname of central server
- `PROMETHEUS_URL`: Full URL to Prometheus (e.g., http://192.168.1.100:9090)
- `LOKI_URL`: Full URL to Loki (e.g., http://192.168.1.100:3100)
- `GRAFANA_URL`: Full URL to Grafana (e.g., http://192.168.1.100:3000)
- `HOSTNAME`: Unique identifier for this agent

### Alloy Configuration
The `alloy-config.yml` file configures:
- **Metrics Collection**: System and container metrics
- **Log Collection**: System and Docker logs
- **Data Forwarding**: To central Prometheus and Loki
- **Labeling**: Adds instance labels for identification

## 🔧 Maintenance

- **View logs**: `docker-compose logs -f grafana-alloy`
- **Restart agent**: `docker-compose restart grafana-alloy`
- **Check status**: `docker-compose ps`
- **Access Alloy UI**: http://localhost:12345

## 📁 Files

- `docker-compose.yml`: Agent service orchestration
- `alloy-config.yml`: Alloy data collection and forwarding configuration
- `env.example`: Environment variables template

## 🌐 Network Requirements

- **Outbound**: Agent must be able to reach central server
- **Prometheus**: Agent pushes metrics to central Prometheus
- **Loki**: Agent pushes logs to central Loki
- **Port**: 12345 (Alloy UI, optional)

## 🔄 Deployment

1. Copy this directory to each remote server
2. Update `.env` with central server details
3. Start the agent: `docker-compose up -d`

## 🎯 Benefits of Alloy-based Agents

- ✅ **Unified Collection**: Single agent for metrics and logs
- ✅ **Efficient**: Built-in filtering and processing
- ✅ **Reliable**: Automatic retry and buffering
- ✅ **Flexible**: Easy to configure and extend
- ✅ **Resource Efficient**: Lower overhead than multiple exporters
- ✅ **Push-based**: No need for central server to scrape agents

## 📈 Scaling

- **Add Agents**: Copy directory to new servers
- **No Central Changes**: Agents push data directly
- **Load Distribution**: Each agent handles its own data collection
- **Fault Tolerance**: Agents continue working if central server is down
