# Remote Monitoring Agents

This directory contains lightweight monitoring agents that collect data and send it to the central observability server.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    REMOTE AGENT                                 │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │ Node Exporter│  │  cAdvisor   │  │  Promtail   │            │
│  │ (Metrics)   │  │ (Container) │  │   (Logs)    │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│           │               │               │                   │
│           └───────────────┼───────────────┘                   │
│                           │                                   │
│                ┌─────────────────┐                            │
│                │   Agent Side    │                            │
│                │   (No Alloy)    │                            │
│                └─────────────────┘                            │
└─────────────────────────────────────────────────────────────────┘
                           │
                           │ (Sends data to central server)
                           │
                ┌─────────────────┐
                │  Central Server │
                │  (Alloy + etc.) │
                └─────────────────┘
```

## 🚀 Quick Start

1. **Copy environment file:**
   ```bash
   cp env.example .env
   ```

2. **Update configuration:**
   - Edit `.env` with your central server details
   - Update `promtail-config.yml` with central server IP/hostname

3. **Start the agents:**
   ```bash
   docker-compose up -d
   ```

## 📊 Services

### Node Exporter (Port 19100)
- Collects host metrics (CPU, memory, disk, network)
- Exposes metrics on `/metrics` endpoint
- Central server scrapes these metrics

### cAdvisor (Port 18080)
- Collects container metrics
- Monitors Docker containers
- Exposes metrics on `/metrics` endpoint

### Promtail
- Collects system and container logs
- Sends logs to central Loki server
- No exposed ports (internal only)

## ⚙️ Configuration

### Environment Variables
- `CENTRAL_SERVER_IP`: IP address of central observability server
- `CENTRAL_SERVER_HOSTNAME`: Hostname of central server
- `HOSTNAME`: Unique identifier for this agent

### Network Configuration
Update `promtail-config.yml`:
```yaml
clients:
  - url: http://CENTRAL_SERVER_IP:3100/loki/api/v1/push
```

## 🔧 Maintenance

- **View logs**: `docker-compose logs -f [service]`
- **Restart services**: `docker-compose restart [service]`
- **Check status**: `docker-compose ps`

## 📁 Files

- `docker-compose.yml`: Agent service orchestration
- `promtail-config.yml`: Log collection configuration
- `env.example`: Environment variables template

## 🌐 Network Requirements

- **Outbound**: Agent must be able to reach central server
- **Inbound**: Central server must be able to reach agent ports
- **Ports**: 19100 (Node Exporter), 18080 (cAdvisor)

## 🔄 Deployment

1. Copy this directory to each remote server
2. Update configuration for each agent
3. Start services on each agent
4. Update central server configuration with agent details
