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
│                           │ (Receives data from agents)       │
│                           │                                   │
└───────────────────────────┼───────────────────────────────────┘
                            │
                            │
┌───────────────────────────┼───────────────────────────────────┐
│                    REMOTE AGENTS                              │
│                                                                 │
│                ┌─────────────────┐                            │
│                │  Grafana Alloy  │                            │
│                │  (Port 12345)   │                            │
│                │                 │                            │
│                │ Collects &      │                            │
│                │ forwards:       │                            │
│                │ • System metrics│                            │
│                │ • Container     │                            │
│                │   metrics       │                            │
│                │ • System logs   │                            │
│                │ • Container     │                            │
│                │   logs          │                            │
│                └─────────────────┘                            │
│                           │                                   │
│                           └───► Prometheus & Loki             │
│                               (Central)                       │
└─────────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
grafana/
├── central-server/          # Central observability stack
│   ├── docker-compose.yml   # Central services orchestration
│   ├── prometheus.yml       # Prometheus scrape config
│   ├── env.example          # Environment variables template
│   └── README.md            # Central server documentation
├── remote-agents/           # Alloy-based monitoring agents
│   ├── docker-compose.yml   # Agent service orchestration
│   ├── alloy-config.yml     # Alloy data collection & forwarding config
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

### Remote Agents
- **Alloy UI**: http://agent-ip:12345

## 🎯 Key Features

- **Unified Agent Architecture**: Alloy on every agent collects metrics and logs
- **Push-based Data Flow**: Agents push data directly to Prometheus and Loki
- **Scalable Architecture**: Add agents without central server changes
- **Resource Efficient**: Single agent per server, lower overhead
- **Complete Observability**: Metrics, logs, and visualization
- **Production Ready**: Proper networking, security, and monitoring

## 🔧 Configuration

### Central Server
- **Prometheus**: Stores and queries metrics (receives from remote Alloy agents)
- **Loki**: Stores and queries logs (receives from remote Alloy agents)
- **Grafana**: Visualization and dashboards for both metrics and logs

### Remote Agents
- **Grafana Alloy**: Collects system metrics, container metrics, and logs
- **Data Forwarding**: Pushes metrics to Prometheus, logs to Loki
- **Self-contained**: Single agent handles all data collection

## 🌐 Network Requirements

- **Central Server**: Exposes ports for web UI and data reception
- **Remote Agents**: Push data to central Prometheus and Loki
- **Data Flow**: Agents → Prometheus (port 9090), Agents → Loki (port 3100)
- **Firewall**: Allow outbound connections from agents to central server

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
