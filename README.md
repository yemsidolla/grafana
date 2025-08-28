# Quick Git Cheat

## Initialize a new git repository
```bash
git init
```
## Add all files to staging
```bash
git add .
```

## Commit with a message
```bash
git commit -m "Initial commit"
```

## Set the main branch name (optional, for new repos)
```bash
git branch -M main
```

## Add remote origin (replace with your repo URL)
```bash
git remote add origin git@github.com:yemsidolla/grafana.git
```

## Push to remote main branch
```bash
git push -u origin main
```

# Observability Stack with Grafana Alloy

A complete observability solution using Grafana Alloy as a data collector and forwarder, with separate deployments for central server and remote agents.

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    CENTRAL OBSERVABILITY STACK                  │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Grafana   │  │ Prometheus  │  │    Loki     │            │
│  │   (Port 3000)│  │  (Port 9090) │  │  (Port 3100) │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│           │               ▲               ▲                   │
│           └───────────────┼───────────────┘                   │
│                           │                                   │
│                ┌─────────────────┐                            │
│                │  Grafana Alloy  │                            │
│                │  (Port 12345)   │                            │
│                │                 │                            │
│                │ Scrapes remote  │                            │
│                │ agents &        │                            │
│                │ forwards data   │                            │
│                └─────────────────┘                            │
│                           ▲                                   │
└───────────────────────────┼───────────────────────────────────┘
                            │
                            │ (Scrapes metrics from agents)
                            │
┌───────────────────────────┼───────────────────────────────────┐
│                    REMOTE AGENTS                              │
│                                                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │ Node Exporter│  │  cAdvisor   │  │  Promtail   │            │
│  │ (Port 19100) │  │ (Port 18080) │  │   (Logs)    │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│           │               │               │                   │
│           │               │               └───► Loki           │
│           │               │                   (Central)       │
│           └───────────────┼─────────────────┘                   │
│                           │                                   │
│                ┌─────────────────┐                            │
│                │   Agent Side    │                            │
│                │   (No Alloy)    │                            │
│                └─────────────────┘                            │
└─────────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
grafana/
├── central-server/          # Central observability stack
│   ├── docker-compose.yml   # Central services orchestration
│   ├── alloy-config.yml     # Alloy scraping & forwarding config
│   ├── prometheus.yml       # Prometheus scrape config
│   ├── env.example          # Environment variables template
│   └── README.md            # Central server documentation
├── remote-agents/           # Lightweight monitoring agents
│   ├── docker-compose.yml   # Agent services orchestration
│   ├── promtail-config.yml  # Log collection & forwarding config
│   ├── env.example          # Environment variables template
│   └── README.md            # Remote agents documentation
├── deploy.sh                # Easy deployment script
└── README.md                # This file
```

## 🚀 Quick Start

### 1. Deploy Central Server

```bash
cd central-server
cp env.example .env
# Edit .env with your network details
docker-compose up -d
```

### 2. Deploy Remote Agents

```bash
cd remote-agents
cp env.example .env
# Edit .env with central server details
docker-compose up -d
```

### 3. Configure Agent Discovery

Update `central-server/alloy-config.yml` with actual agent IPs/hostnames.

## 🚀 Easy Deployment (Alternative)

Use the deployment script for easier management:

```bash
# Deploy Central Server
./deploy.sh central start

# Deploy Remote Agent
./deploy.sh agent start

# Check Status
./deploy.sh central status
./deploy.sh agent status
./deploy.sh all status

# Stop services
./deploy.sh central stop
./deploy.sh agent stop

# Restart services
./deploy.sh central restart
./deploy.sh agent restart
```

## 📊 Access Points

### Central Server
- **Grafana UI**: http://localhost:3000 (admin/admin)
- **Prometheus UI**: http://localhost:9090
- **Loki API**: http://localhost:3100
- **Alloy UI**: http://localhost:12345

### Remote Agents
- **Node Exporter**: http://agent-ip:19100
- **cAdvisor**: http://agent-ip:18080

## 🎯 Key Features

- **Centralized Data Collection**: Alloy scrapes metrics from multiple agents
- **Dual Data Flow**: Metrics via Alloy → Prometheus, Logs via Promtail → Loki
- **Scalable Architecture**: Add agents without central server changes
- **Resource Efficient**: Lightweight agents, powerful central processing
- **Complete Observability**: Metrics, logs, and visualization
- **Production Ready**: Proper networking, security, and monitoring

## 🔧 Configuration

### Central Server
- **Grafana Alloy**: Scrapes metrics from remote agents and forwards to Prometheus
- **Prometheus**: Stores and queries metrics (receives from Alloy)
- **Loki**: Stores and queries logs (receives from Promtail)
- **Grafana**: Visualization and dashboards for both metrics and logs

### Remote Agents
- **Node Exporter**: Exposes host metrics on port 19100
- **cAdvisor**: Exposes container metrics on port 18080
- **Promtail**: Collects logs and forwards directly to central Loki

## 🌐 Network Requirements

- **Central Server**: Exposes ports for web UI and agent communication
- **Remote Agents**: Expose metrics ports (19100, 18080) for Alloy scraping
- **Promtail**: Sends logs directly to central Loki (port 3100)
- **Firewall**: Allow communication between central server and agents

## 📈 Scaling

1. **Add Agents**: Copy `remote-agents/` to new servers
2. **Update Discovery**: Add agent details to `central-server/alloy-config.yml`
3. **Monitor**: Use Grafana to monitor new agents

## 🔒 Security Considerations

- Change default passwords
- Use HTTPS in production
- Implement network segmentation
- Regular security updates

## 📚 Documentation

- [Central Server README](central-server/README.md)
- [Remote Agents README](remote-agents/README.md)
- [Grafana Alloy Documentation](https://grafana.com/docs/alloy/latest/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
