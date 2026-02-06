# 🌐 Global HTTP Server - Quick Setup Guide

This guide will help you make your local Go HTTP server accessible from anywhere in the world!

## 🚀 Quick Start (3 Steps)

### Step 1: Make the script executable
```bash
chmod +x start-global.sh
```

### Step 2: Start your global server
```bash
./start-global.sh
```

That's it! You'll get a public URL that you can share with anyone.

## 📋 What Gets Installed

### Prerequisites
- **Go** (1.18+) - Already installed if you're running Go code
- **Cloudflare Tunnel** - Installed automatically by the script

### What the Script Does
1. ✅ Installs Cloudflare Tunnel (if not present)
2. ✅ Starts your Go HTTP server
3. ✅ Creates a secure tunnel to the internet
4. ✅ Provides you with a public URL

## 🖥️ Usage Options

### Option 1: Quick Start (Simplest)
```bash
# Start with default port (8080)
./start-global.sh

# Start with custom port
./start-global.sh 3000
```

### Option 2: Using Make (Advanced)
```bash
# Full setup
make setup

# Start the server
make run

# Check status
make status

# Stop servers
make stop

# View logs
make logs
```

### Option 3: Docker (Production)
```bash
# Start with Docker
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

## 🌐 Accessing Your Server

### During Development
When you run the script, you'll see output like:
```
🌐 Starting your Go HTTP server on port 8080...
✅ Your server is ready!

🔗 Starting Cloudflare Tunnel...
Your server will be accessible at:
https://www.rez-test.test
```

### For Permanent Hosting
For `www.rez-test.test` to work globally:

1. **Domain DNS Setup:**
   - Go to your domain registrar (where you bought `rez-test.test`)
   - Point `www.rez-test.test` to Cloudflare nameservers:
     ```
     Nameserver 1: ns1.cloudflare.com
     Nameserver 2: ns2.cloudflare.com
     ```

2. **Cloudflare Dashboard:**
   - Add your domain to Cloudflare
   - Go to DNS settings
   - Create an A record:
     ```
     Type: A
     Name: www
     Content: [Cloudflare will auto-assign]
     Proxy status: Proxied (orange cloud)
     ```

## 🛠️ Server Features

Your server supports:
- ✅ Static file serving
- ✅ File uploads (creates `/uploads` directory)
- ✅ HTTPS (self-signed for local, Cloudflare proxy for global)
- ✅ Directory listing
- ✅ Custom port selection

### Available Endpoints
- `/` - Main page
- `/files/` - File browser
- Upload via POST request

## 🔧 Configuration

### Environment Variables
Create a `.env` file from the example:
```bash
cp .env.example .env
```

### Custom Port
```bash
./start-global.sh 3000
```

## 📊 Troubleshooting

### "Port already in use"
```bash
# Find what's using the port
lsof -i :8080

# Kill the process
kill <PID>

# Or use a different port
./start-global.sh 8081
```

### "Go is not installed"
Install Go from: https://go.dev/dl/

### Can't access from other devices
1. Check your firewall:
   ```bash
   # Allow port 8080
   sudo ufw allow 8080
   ```

2. Make sure you're using `0.0.0.0` (not `127.0.0.1`)
   - The script automatically configures this

### Tunnel not connecting
1. Check your internet connection
2. Try running the script again
3. Check logs: `tail -f ~/.global-server/tunnel.log`

## 🔒 Security Notes

### For Development
- ✅ Fine for testing on mobile hotspot
- ✅ Uses Cloudflare's secure tunnel
- ⚠️ Self-signed certificates for local HTTPS

### For Production
1. Set up proper SSL/TLS certificates
2. Configure Cloudflare for full SSL mode
3. Set up authentication if needed
4. Consider rate limiting
5. Use environment variables for secrets

## 📈 Next Steps

1. ✅ Test locally first: `go run main.go`
2. 🌐 Try global access: `./start-global.sh`
3. 🔧 Customize your HTML files in `cmd/simplehttpserver/`
4. 🚀 Deploy to production when ready

## 📞 Support

- Check logs: `tail -f ~/.global-server/tunnel.log`
- View server status: `make status`
- Stop everything: `make stop`

---

**🎉 Happy Hosting!** Your server is now ready to be seen by the world! 🌍

