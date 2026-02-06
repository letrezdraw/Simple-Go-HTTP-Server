#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting Global Server Setup${NC}"
echo ""

# Configuration
PORT=${1:-8080}
DOMAIN="www.rez-test.test"
INSTALL_DIR="$HOME/.global-server"
TUNNEL_LOG="$INSTALL_DIR/tunnel.log"

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo -e "${RED}❌ Go is not installed. Please install Go first:${NC}"
    echo "   Visit: https://go.dev/dl/"
    exit 1
fi

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Function to install cloudflared
install_cloudflared() {
    echo -e "${YELLOW}📦 Installing Cloudflare Tunnel...${NC}"
    
    # Detect OS and architecture
    OS=$(uname -s)
    ARCH=$(uname -m)
    
    case "$OS" in
        Linux)
            case "$ARCH" in
                x86_64)
                    URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
                    ;;
                armv6l|armv7l)
                    URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm"
                    ;;
                aarch64)
                    URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
                    ;;
                *)
                    echo -e "${RED}❌ Unsupported architecture: $ARCH${NC}"
                    exit 1
                    ;;
            esac
            ;;
        Darwin)
            URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64"
            ;;
        *)
            echo -e "${RED}❌ Unsupported OS: $OS${NC}"
            exit 1
            ;;
    esac
    
    # Download and install
    curl -L "$URL" -o "$INSTALL_DIR/cloudflared"
    chmod +x "$INSTALL_DIR/cloudflared"
    
    echo -e "${GREEN}✅ Cloudflare Tunnel installed successfully${NC}"
}

# Function to start the tunnel
start_tunnel() {
    echo -e "${YELLOW}🔗 Starting Cloudflare Tunnel...${NC}"
    echo ""
    echo -e "${BLUE}Your server will be accessible at:${NC}"
    echo -e "${GREEN}https://$DOMAIN${NC}"
    echo ""
    echo -e "${YELLOW}📝 Note: You'll need to:${NC}"
    echo "   1. Point your DNS to Cloudflare"
    echo "   2. Configure Cloudflare to proxy the traffic"
    echo ""
    echo -e "${BLUE}Press Ctrl+C to stop the server${NC}"
    echo ""
    
    # Start cloudflared tunnel
    "$INSTALL_DIR/cloudflared" tunnel --url "http://localhost:$PORT" --hostname "$DOMAIN" 2>&1 | tee "$TUNNEL_LOG"
}

# Function to start the Go server
start_server() {
    echo -e "${GREEN}🌐 Starting your Go HTTP server on port $PORT...${NC}"
    echo ""
    
    # Get the directory where the script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR"
    
    # Start the server in background
    go run main.go -port "$PORT" &
    SERVER_PID=$!
    
    echo -e "${GREEN}✅ Server started (PID: $SERVER_PID)${NC}"
    echo ""
    
    # Wait for server to be ready
    sleep 2
    
    # Check if server is running
    if ! kill -0 $SERVER_PID 2>/dev/null; then
        echo -e "${RED}❌ Failed to start Go server${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Your server is ready!${NC}"
    echo ""
}

# Main execution
echo -e "${BLUE}📋 Configuration:${NC}"
echo "   Port: $PORT"
echo "   Domain: $DOMAIN"
echo "   Install Directory: $INSTALL_DIR"
echo ""

# Install cloudflared if not present
if [ ! -f "$INSTALL_DIR/cloudflared" ]; then
    install_cloudflared
    echo ""
fi

# Start the Go server
start_server

# Start the tunnel
start_tunnel

# Cleanup on exit
trap "echo -e '\n${YELLOW}🛑 Stopping servers...${NC}'; kill $SERVER_PID 2>/dev/null; exit" INT

