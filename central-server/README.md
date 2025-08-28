# Central Observability Server

This directory contains the central observability stack that collects and processes data from remote agents.

## 🏗️ Architecture

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   Grafana       │  │   Prometheus    │  │     Loki        │
│   (Port 3000)   │  │   (Port 9090)   │  │   (Port 3100)   │
│                 │  │                 │  │                 │
│  Visualization  │  │  Metrics Store  │  │   Logs Store    │
└─────────────────┘  └─────────────────┘  └─────────────────┘
         │                       ▲                       ▲
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  Grafana Alloy  │
                    │  (Port 12345)   │
                    │                 │
                    │ Central Data    │
                    │ Collector       │
                    └─────────────────┘
                                 ▲
                                 │
                    ┌─────────────────┐
                    │  Remote Agents  │
                    │  (Multiple)     │
                    └─────────────────┘
```

## 🚀 Quick Start

1. **Copy environment file:**
   ```bash
   cp env.example .env
   ```

2. **Update configuration:**
   - Edit `.env` with your network details
   - Update `alloy-config.yml` with actual agent IPs/hostnames

3. **Start the stack:**
   ```bash
   docker-compose up -d
   ```

## 📊 Access Points

- **Grafana UI**: http://localhost:3000 (admin/admin)
- **Prometheus UI**: http://localhost:9090
- **Loki API**: http://localhost:3100
- **Alloy UI**: http://localhost:12345

## ⚙️ Configuration

### Environment Variables
- `GF_SECURITY_ADMIN_PASSWORD`: Grafana admin password
- `CENTRAL_SERVER_IP`: Your server's IP address
- `CENTRAL_SERVER_HOSTNAME`: Your server's hostname
- `GRAFANA_URL`: Full URL to Grafana (e.g., http://localhost:3000)
- `LOKI_URL`: Full URL to Loki (e.g., http://localhost:3100)
- `PROMETHEUS_URL`: Full URL to Prometheus (e.g., http://localhost:9090)
- `REMOTE_AGENT_1`, `REMOTE_AGENT_2`, etc.: IP addresses of remote agents

### Agent Configuration
Update `alloy-config.yml` with your actual agent details:
```alloy
{"__address__" = "agent1:9100", "job" = "node-exporter", "instance" = "agent1"},
{"__address__" = "agent2:9100", "job" = "node-exporter", "instance" = "agent2"},
```

### URL-based Configuration Benefits
- ✅ **Service Separation**: Grafana and Loki can be on different servers
- ✅ **Load Balancing**: Can point to load balancer URLs
- ✅ **Environment Flexibility**: Easy to switch between dev/staging/prod
- ✅ **Port Independence**: Change ports without editing config files

## 🔧 Maintenance

- **View logs**: `docker-compose logs -f [service]`
- **Restart services**: `docker-compose restart [service]`
- **Update configuration**: Edit config files and restart services

## 📁 Files

- `docker-compose.yml`: Service orchestration
- `alloy-config.yml`: Alloy data collection configuration
- `prometheus.yml`: Prometheus scrape configuration
- `env.example`: Environment variables template
