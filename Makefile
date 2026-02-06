REPO_URL=https://github.com/projectdiscovery/simplehttpserver
GO_SERVER_PORT=8080
DOMAIN=www.rez-test.test

.PHONY: help install run stop restart logs status clean setup

help:
	@echo "🚀 Global Server Management Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make run          - Start the server with global tunnel"
	@echo "  make install      - Install dependencies (cloudflared)"
	@echo "  make stop         - Stop all servers"
	@echo "  make logs         - View tunnel logs"
	@echo "  make status       - Check server status"
	@echo "  make clean        - Clean up logs and temporary files"
	@echo "  make setup        - Full initial setup"
	@echo ""

install:
	@echo "📦 Installing dependencies..."
	@mkdir -p ~/.global-server
	@if [ ! -f ~/.global-server/cloudflared ]; then \
		echo "Downloading cloudflared..."; \
		OS=$$(uname -s); \
		ARCH=$$(uname -m); \
		case "$$OS" in \
			Linux) \
				case "$$ARCH" in \
					x86_64) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64";; \
					aarch64) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64";; \
					*) echo "Unsupported architecture"; exit 1;; \
				esac;; \
			Darwin) \
				case "$$ARCH" in \
					arm64) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-arm64";; \
					*) URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64";; \
				esac;; \
		esac; \
		curl -L "$$URL" -o ~/.global-server/cloudflared; \
		chmod +x ~/.global-server/cloudflared; \
		echo "✅ Cloudflare installed"; \
	else \
		echo "✅ Cloudflare already installed"; \
	fi

run: install
	@echo "🌐 Starting global server..."
	@chmod +x start-global.sh
	@./start-global.sh $(PORT)

stop:
	@echo "🛑 Stopping servers..."
	@pkill -f "cloudflared tunnel" 2>/dev/null || true
	@pkill -f "go run main.go" 2>/dev/null || true
	@echo "✅ All servers stopped"

logs:
	@echo "📋 Viewing tunnel logs..."
	@tail -f ~/.global-server/tunnel.log 2>/dev/null || echo "No logs found. Run 'make run' first."

status:
	@echo "📊 Server Status:"
	@echo ""
	@echo "Go Server:"
	@pgrep -f "go run main.go" > /dev/null && echo "✅ Running" || echo "❌ Not running"
	@echo ""
	@echo "Cloudflare Tunnel:"
	@pgrep -f "cloudflared tunnel" > /dev/null && echo "✅ Running" || echo "❌ Not running"
	@echo ""
	@echo "Public URL:"
	@if grep -q "https://" ~/.global-server/tunnel.log 2>/dev/null; then \
		grep "https://" ~/.global-server/tunnel.log | tail -1; \
	else \
		echo "Not available yet. Run 'make run' first."; \
	fi

clean:
	@echo "🧹 Cleaning up..."
	@rm -f ~/.global-server/tunnel.log 2>/dev/null || true
	@echo "✅ Cleaned up"

setup: install
	@echo "⚙️  Full setup complete!"
	@echo ""
	@echo "Next steps:"
	@echo "1. Run 'make run' to start your global server"
	@echo "2. You'll get a public URL like: https://www.rez-test.test"
	@echo ""
	@echo "For your domain www.rez-test.test:"
	@echo "- Configure DNS to point to Cloudflare"
	@echo "- Enable Cloudflare proxy (orange cloud)"

