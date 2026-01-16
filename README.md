# 🚀 Simple HTTP Server

A powerful, lightweight HTTP server built with Go that supports file serving, uploads, HTTPS, and Python CGI execution.

![Go Version](https://img.shields.io/badge/Go-1.18+-00ADD8?style=for-the-badge&logo=go)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📁 **File Serving** | Serve static files from any directory |
| 📤 **File Upload** | Enable upload functionality for clients |
| 🔒 **HTTPS Support** | Serve over secure HTTPS protocol |
| 🐍 **Python CGI** | Execute Python scripts via CGI |
| ⚡ **Lightweight** | Minimal dependencies, high performance |
| 🎯 **Cross-Platform** | Works on Linux, macOS, and Windows |

---

## 📦 Installation

### Option 1: Go Install (Recommended)

```bash
# Install the latest version
go install -v github.com/projectdiscovery/simplehttpserver/cmd/simplehttpserver@latest

# Add to PATH (add this to your ~/.bashrc or ~/.zshrc for persistence)
export PATH=$PATH:$(go env GOPATH)/bin
```

### Option 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/projectdiscovery/simplehttpserver.git
cd simplehttpserver/cmd/simplehttpserver

# Build the binary
go build -o simplehttpserver simplehttpserver.go

# Move to PATH
sudo mv simplehttpserver /usr/local/bin/
```

### Option 3: Download Binary

Visit the [releases page](https://github.com/projectdiscovery/simplehttpserver/releases) and download the pre-compiled binary for your platform.

---

## 🚀 Quick Start

### 1. View Help

```bash
simplehttpserver -h
```

Output:
```
$ simplehttpserver -h

   __
  / /  __ _____  ___ ___
 / _ \/ // / _ \/ // / -_)
/_//_/\_, / .__/\_, /_/\_\
     /___/_/  /___/

Usage: ./simplehttpserver [options]

Options:
  -listen string      Address to listen on (default ":8000")
  -upload             Enable file upload
  -https              Enable HTTPS
  -domain string      Domain for HTTPS certificate
  -py                 Enable Python CGI support
  -cors               Enable CORS headers
  -config string      Configuration file path
  -h                  Show help
  -version            Show version

Examples:
  simplehttpserver -listen 127.0.0.1:8000
  simplehttpserver -upload -listen :8080
  simplehttpserver -https -domain localhost
  simplehttpserver -py -listen :8000
```

### 2. Start Basic Server

```bash
# Listen on specific address and port
simplehttpserver -listen 127.0.0.1:8000
```

Expected output:
```
[INF] Serving files on http://127.0.0.1:8000
[INF] Directory: /home/user/current/directory
```

### 3. Access Your Server

Open your browser and navigate to:
```
http://127.0.0.1:8000
```

---

## 📋 Command Reference

### Basic Commands

```bash
# Listen on all interfaces
simplehttpserver -listen 0.0.0.0:8080

# Custom port only
simplehttpserver -listen :8080
```

### With File Upload

```bash
# Enable file upload functionality
simplehttpserver -upload -listen 127.0.0.1:8000

# Upload + custom port
simplehttpserver -upload -listen :8080
```

### With HTTPS

```bash
# Enable HTTPS with default settings
simplehttpserver -https

# HTTPS with custom domain
simplehttpserver -https -domain localhost

# HTTPS on custom port
simplehttpserver -https -listen :8443
```

### With Python CGI

```bash
# Enable Python script execution via CGI
simplehttpserver -py -listen 8000

# Python + HTTPS
simplehttpserver -py -https -domain localhost
```

### Combined Options

```bash
# All features enabled
simplehttpserver -upload -https -py -listen :8000

# Upload + CORS
simplehttpserver -upload -cors -listen :8080
```

---

## 🎯 Usage Examples

### Example 1: Development Server

```bash
# Start a local development server
simplehttpserver -listen 127.0.0.1:3000 -cors
```

**Use case:** Serving a frontend application during development

```
┌─────────────────────────────────────────────────┐
│  Browser                                        │
│  http://127.0.0.1:3000                         │
│         │                                      │
│         ▼                                      │
│  ┌───────────────────────────────────────┐     │
│  │  simplehttpserver                     │     │
│  │  - Listens on :3000                   │     │
│  │  - Serves static files                │     │
│  │  - CORS enabled                       │     │
│  └───────────────────────────────────────┘     │
│         │                                      │
│         ▼                                      │
│  /home/user/project/                           │
└─────────────────────────────────────────────────┘
```

### Example 2: File Sharing Server

```bash
# Share files with upload capability
cd /path/to/share
simplehttpserver -upload -listen 192.168.1.100:8080
```

**Use case:** Sharing files on a local network

### Example 3: Secure File Server

```bash
# HTTPS file server with upload
simplehttpserver -upload -https -domain files.example.com -listen :443
```

**Use case:** Secure file sharing over the internet

### Example 4: Python CGI Server

```bash
# Python CGI execution
simplehttpserver -py -listen 8000
```

**Use case:** Running Python web scripts and CGIs

```
Request Flow:
┌──────────┐    GET /script.py    ┌──────────────┐
│  Client  │ ───────────────────► │  simplehttpserver  │
└──────────┘                      └───────┬──────┘
                                          │
                                          ▼
                                  ┌──────────────┐
                                  │  Python CGI  │
                                  │  Interpreter │
                                  └──────┬───────┘
                                         │
                                         ▼
                                  ┌──────────────┐
                                  │  Response    │
                                  └──────────────┘
```

---

## ⚙️ Configuration File

Create a `config.yaml` file:

```yaml
# simplehttpserver configuration
listen: ":8000"
upload: true
https: false
domain: "localhost"
py: false
cors: true
directory: "/path/to/serve"
```

Run with config:
```bash
simplehttpserver -config config.yaml
```

---

## 🔧 Troubleshooting

### Command Not Found

If `simplehttpserver` is not found after installation:

```bash
# Check if it's in GOPATH
ls $(go env GOPATH)/bin/simplehttpserver

# Add to PATH permanently
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc
```

### Port Already in Use

```bash
# Find process using the port
lsof -i :8000

# Kill the process
kill <PID>

# Or use a different port
simplehttpserver -listen :8080
```

### Permission Denied

```bash
# For ports below 1024 (Linux/macOS)
sudo simplehttpserver -listen :80

# Or use a port above 1024
simplehttpserver -listen :8080
```

---

## 🏗️ Project Structure

```
simplehttpserver/
├── cmd/
│   └── simplehttpserver/
│       └── simplehttpserver.go    # Main entry point
├── internal/
│   └── runner/                     # Core server logic
├── go.mod                          # Go module definition
├── main.go                         # Root main.go
└── README.md                       # This file
```

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📧 Contact

- **Project**: [projectdiscovery/simplehttpserver](https://github.com/projectdiscovery/simplehttpserver)
- **Issues**: [GitHub Issues](https://github.com/projectdiscovery/simplehttpserver/issues)

---

<div align="center">

**Happy Serving! 🌐**

Made with ❤️ by the ProjectDiscovery Team

</div>

