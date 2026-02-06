# 🌍 Global HTTP Server

Make your local Go HTTP server accessible from anywhere in the world!

![Go Version](https://img.shields.io/badge/Go-1.18+-00ADD8?style=for-the-badge&logo=go)
![Status](https://img.shields.io/badge/Status-Global_Ready-green?style=for-the-badge)

---

## 🚀 Quick Start (3 Steps)

```bash
# Step 1: Make the script executable
chmod +x start-global.sh

# Step 2: Start your global server
./start-global.sh

# Step 3: Access your server globally!
# Your URL will be displayed in the terminal
```

**That's it!** Your server is now accessible worldwide at `https://www.rez-test.test`

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🌐 **Global Access** | Access from anywhere via Cloudflare Tunnel |
| 📁 **File Serving** | Serve static files from any directory |
| 📤 **File Upload** | Enable upload functionality |
| 🔒 **HTTPS** | Secure encrypted connections |
| ⚡ **Fast Setup** | Ready in under 2 minutes |
| 🖥️ **Cross-Platform** | Works on macOS, Linux, Windows |

---

## 📦 Installation

### Prerequisites

- **Go 1.18+** - [Download here](https://go.dev/dl/)
- **Internet connection** - Required for the tunnel

### Setup

```bash
# Clone or download this project
cd Simple-Go-HTTP-Server

# Make the script executable
chmod +x start-global.sh
```

---

## 🎮 Usage

### Basic Usage

```bash
# Start with default port (8080)
./start-global.sh
```

### Custom Port

```bash
# Start on port 3000
./start-global.sh 3000
```

### Using Make (Advanced)

```bash
# Install dependencies and setup
make setup

# Start the global server
make run

# Check server status
make status

# View logs
make logs

# Stop all servers
make stop
```

### Using Docker

```bash
# Start with Docker
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

---

## 🔧 Configuration

### Environment Variables

Create a `.env` file:

```bash
cp .env.example .env
```

Edit with your settings:

```env
DOMAIN=www.rez-test.test
PORT=8080
UPLOAD_ENABLED=true
```

### Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| Port | Server port number | 8080 |
| Domain | Your domain name | www.rez-test.test |

---

## 🌐 Accessing Your Server

### During Development

When you run `./start-global.sh`, you'll see:

```
🌐 Starting your Go HTTP server on port 8080...
✅ Your server is ready!

🔗 Starting Cloudflare Tunnel...
Your server will be accessible at:
https://www.rez-test.test
```

### For Permanent Hosting

For `www.rez-test.test` to work globally:

1. **Domain Registrar Setup:**
   - Go to where you bought `rez-test.test`
   - Change nameservers to Cloudflare:
     ```
     ns1.cloudflare.com
     ns2.cloudflare.com
     ```

2. **Cloudflare Dashboard:**
   - Add your domain to Cloudflare
   - Go to DNS → Add record:
     ```
     Type: A
     Name: www
     Content: (auto-assigned by Cloudflare)
     Proxy: ☁️ Proxied
     ```

---

## 📁 Project Structure

```
Simple-Go-HTTP-Server/
├── cmd/
│   └── simplehttpserver/
│       └── index.html          # Your website files
├── start-global.sh             # 🚀 Main script - RUN THIS!
├── Makefile                    # Advanced management
├── Dockerfile                  # Docker setup
├── docker-compose.yml         # Container orchestration
├── main.go                    # Server source code
├── go.mod                     # Go module
├── SETUP.md                   # Detailed setup guide
└── README.md                  # This file
```

---

## 🛠️ Server Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Main page |
| `/files/` | GET | File browser |
| `/upload` | POST | Upload files |

---

## 📊 Troubleshooting

### ❌ "Port already in use"

```bash
# Find the process
lsof -i :8080

# Kill it
kill <PID>

# Or use different port
./start-global.sh 8081
```

### ❌ "Go is not installed"

Download Go: https://go.dev/dl/

### ❌ Can't access from other devices

Check firewall:
```bash
sudo ufw allow 8080
```

### ❌ Tunnel not connecting

```bash
# Check logs
make logs

# Restart
make stop
./start-global.sh
```

---

## 🔒 Security

### For Development ✅
- ✅ Fine for testing on mobile hotspot
- ✅ Uses Cloudflare's secure tunnel
- ⚠️ Self-signed certificates for local HTTPS

### For Production 🚀
1. Set up proper SSL/TLS certificates
2. Configure Cloudflare full SSL mode
3. Add authentication
4. Enable rate limiting
5. Use environment variables for secrets

---

## 📈 Roadmap

- [ ] Add custom domain support
- [ ] Add authentication
- [ ] Add rate limiting
- [ ] Add SSL certificate management
- [ ] Add logging dashboard

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing`
5. Open Pull Request

---

## 📝 License

MIT License - feel free to use in your projects!

---

<div align="center">

**🎉 Happy Hosting!** 🌍

Your server is now ready for the world!

</div>

