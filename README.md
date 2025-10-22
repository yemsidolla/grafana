# Grafana Central - Multi-Host Monitoring with Grafana

Centralized monitoring solution using Grafana, Loki, Prometheus, and Alloy agents for monitoring Docker containers across multiple hosts.

## 🏗️ Architecture

- **Grafana Central**: Central monitoring server (Grafana + Loki + Prometheus)
- **Alloy Agents**: Lightweight agents deployed on each Docker host for data collection

## 🚀 Quick Start

### 1. Deploy Grafana Central

```bash
cd grafana-central
docker-compose up -d
```

**Access:**
- Grafana: http://localhost:3000 (admin/admin)
- Prometheus: http://localhost:9090
- Loki: http://localhost:3100

### 2. Deploy Alloy Agents

On each Docker host you want to monitor:

```bash
cd grafana-agents
# Set unique hostname for this agent
export HOSTNAME=web-server-01
docker-compose up -d
```

## 📊 Using Grafana

### Log Queries

**All Docker Logs:**
```logql
{job="docker"}
```

**Logs by Host:**
```logql
{job="docker", host="web-server-01"}
```

**Error Logs:**
```logql
{job="docker", stream="stderr"}
```

**Search for Content:**
```logql
{job="docker"} |= "error"
{job="docker"} |= "failed"
```

### Metrics Queries

**Container Count by Host:**
```promql
sum by (host) (count_over_time({job="docker"}[5m]))
```

## 🔧 Configuration

### Grafana Central
- `docker-compose.yml` - Main services (Grafana + Loki + Prometheus)
- `datasources.yml` - Auto-configure Grafana datasources
- `prometheus.yml` - Prometheus configuration

### Alloy Agents
- `docker-compose.yml` - Alloy agent
- `alloy-config.yml` - Log and metrics collection
- Set `HOSTNAME` environment variable for each host

## 📁 File Structure

```
grafana/
├── grafana-central/         # Central monitoring server
│   ├── docker-compose.yml    # Grafana + Loki + Prometheus
│   ├── datasources.yml       # Auto-configure Grafana datasources
│   └── prometheus.yml        # Prometheus configuration
├── grafana-agents/           # Alloy agents for each Docker host
│   ├── docker-compose.yml    # Alloy agent
│   └── alloy-config.yml      # Log and metrics collection
└── README.md                 # This guide
```

## 🛠️ Management

**Start Grafana Central:**
```bash
cd grafana-central && docker-compose up -d
```

**Start Alloy Agent:**
```bash
cd grafana-agents && HOSTNAME=my-host docker-compose up -d
```

**Stop Services:**
```bash
docker-compose down
```

**View Logs:**
```bash
docker-compose logs -f
```

## 🔍 Troubleshooting

**Check if agents are connected:**
```bash
curl http://localhost:3100/loki/api/v1/labels
```

**View agent status:**
```bash
curl http://localhost:12345/api/v0/component/
```

**Check network connectivity:**
```bash
docker network ls | grep observability
```

## 📈 Multi-Host Setup

1. Deploy Grafana Central on monitoring host
2. Deploy Alloy agents on each Docker host with unique `HOSTNAME`
3. Use Grafana to filter logs by host, container, or content
4. Create dashboards for different teams/environments

## 🏷️ Available Labels

- `job` - "docker" or "system"
- `host` - Host identifier
- `service_name` - Container/service name
- `stream` - "stdout" or "stderr"
- `log_type` - "container" or "system"

## 🎯 Benefits

- **Centralized Monitoring**: Single Grafana instance monitors all hosts
- **Lightweight Agents**: Alloy agents have minimal resource footprint
- **Easy Deployment**: Simple Docker Compose setup
- **Multi-Host Support**: Scale to monitor unlimited hosts
- **Real-time Logs**: Stream logs from all containers in real-time
- **Flexible Filtering**: Filter by host, container, or content