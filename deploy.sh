c#!/bin/bash

# Observability Stack Deployment Script
# Usage: ./deploy.sh [central|agent] [start|stop|restart|status]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to deploy central server
deploy_central() {
    local action=$1
    
    print_status "Central Observability Server - $action"
    
    cd central-server
    
    # Check if .env exists, if not copy from example
    if [ ! -f .env ]; then
        print_warning ".env file not found. Copying from env.example..."
        cp env.example .env
        print_warning "Please edit .env file with your configuration before starting services."
        exit 1
    fi
    
    case $action in
        "start")
            print_status "Starting central server services..."
            docker-compose up -d
            print_success "Central server started successfully!"
            print_status "Access points:"
            echo "  - Grafana: http://localhost:3000 (admin/admin)"
            echo "  - Prometheus: http://localhost:9090"
            echo "  - Loki: http://localhost:3100"
            echo "  - Alloy: http://localhost:12345"
            ;;
        "stop")
            print_status "Stopping central server services..."
            docker-compose down
            print_success "Central server stopped successfully!"
            ;;
        "restart")
            print_status "Restarting central server services..."
            docker-compose restart
            print_success "Central server restarted successfully!"
            ;;
        "status")
            print_status "Checking central server services status..."
            echo ""
            docker-compose ps
            echo ""
            print_status "Service endpoints:"
            echo "  - Grafana: http://localhost:3000"
            echo "  - Prometheus: http://localhost:9090"
            echo "  - Loki: http://localhost:3100"
            echo "  - Alloy: http://localhost:12345"
            ;;
        *)
            print_error "Invalid action. Use: start, stop, restart, or status"
            exit 1
            ;;
    esac
    
    cd ..
}

# Function to deploy remote agent
deploy_agent() {
    local action=$1
    
    print_status "Remote Monitoring Agent - $action"
    
    cd remote-agents
    
    # Check if .env exists, if not copy from example
    if [ ! -f .env ]; then
        print_warning ".env file not found. Copying from env.example..."
        cp env.example .env
        print_warning "Please edit .env file with your central server details before starting services."
        exit 1
    fi
    
    case $action in
        "start")
            print_status "Starting remote agent services..."
            docker-compose up -d
            print_success "Remote agent started successfully!"
            print_status "Agent endpoints:"
            echo "  - Node Exporter: http://localhost:19100"
            echo "  - cAdvisor: http://localhost:18080"
            ;;
        "stop")
            print_status "Stopping remote agent services..."
            docker-compose down
            print_success "Remote agent stopped successfully!"
            ;;
        "restart")
            print_status "Restarting remote agent services..."
            docker-compose restart
            print_success "Remote agent restarted successfully!"
            ;;
        "status")
            print_status "Checking remote agent services status..."
            echo ""
            docker-compose ps
            echo ""
            print_status "Agent endpoints:"
            echo "  - Node Exporter: http://localhost:19100"
            echo "  - cAdvisor: http://localhost:18080"
            ;;
        *)
            print_error "Invalid action. Use: start, stop, restart, or status"
            exit 1
            ;;
    esac
    
    cd ..
}

# Function to show overall status
show_overall_status() {
    print_status "Checking overall observability stack status..."
    echo ""
    
    # Check central server
    if [ -d "central-server" ]; then
        print_status "Central Server Status:"
        cd central-server
        if [ -f "docker-compose.yml" ]; then
            docker-compose ps 2>/dev/null || print_warning "Central server services not running"
        else
            print_warning "Central server docker-compose.yml not found"
        fi
        cd ..
    else
        print_warning "Central server directory not found"
    fi
    
    echo ""
    
    # Check remote agents
    if [ -d "remote-agents" ]; then
        print_status "Remote Agents Status:"
        cd remote-agents
        if [ -f "docker-compose.yml" ]; then
            docker-compose ps 2>/dev/null || print_warning "Remote agent services not running"
        else
            print_warning "Remote agents docker-compose.yml not found"
        fi
        cd ..
    else
        print_warning "Remote agents directory not found"
    fi
    
    echo ""
    print_status "Quick access:"
    echo "  - Check central server: ./deploy.sh central status"
    echo "  - Check remote agents: ./deploy.sh agent status"
}

# Function to show usage
show_usage() {
    echo "Observability Stack Deployment Script"
    echo ""
    echo "Usage: $0 [central|agent|all] [start|stop|restart|status]"
    echo ""
    echo "Commands:"
    echo "  central start    - Start central observability server"
    echo "  central stop     - Stop central observability server"
    echo "  central restart  - Restart central observability server"
    echo "  central status   - Check central server status"
    echo "  agent start      - Start remote monitoring agent"
    echo "  agent stop       - Stop remote monitoring agent"
    echo "  agent restart    - Restart remote monitoring agent"
    echo "  agent status     - Check remote agent status"
    echo "  all status       - Check status of all services"
    echo ""
    echo "Examples:"
    echo "  $0 central start"
    echo "  $0 agent start"
    echo "  $0 central status"
    echo "  $0 agent status"
    echo "  $0 all status"
}

# Main script logic
main() {
    # Check if correct number of arguments
    if [ $# -ne 2 ]; then
        show_usage
        exit 1
    fi
    
    local deployment_type=$1
    local action=$2
    
    # Check if Docker is running
    check_docker
    
    case $deployment_type in
        "central")
            deploy_central $action
            ;;
        "agent")
            deploy_agent $action
            ;;
        "all")
            if [ "$action" = "status" ]; then
                show_overall_status
            else
                print_error "Invalid action for 'all'. Use: status"
                exit 1
            fi
            ;;
        *)
            print_error "Invalid deployment type. Use: central, agent, or all"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
