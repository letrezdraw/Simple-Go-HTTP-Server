package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"flag"
	"fmt"
	"io"
	"log"
	"math/big"
	"net"
	"net/http"
	"os"
	"time"
)

var (
	port      = flag.Int("port", 8080, "Port to listen on")
	https     = flag.Bool("https", false, "Enable HTTPS server")
	upload    = flag.Bool("upload", false, "Enable file upload")
	dir       = flag.String("dir", "cmd/simplehttpserver", "Directory to serve files from")
	uploadDir = "./uploads"
)

func main() {
	flag.Parse()

	// Create upload directory if upload is enabled
	if *upload {
		if err := os.MkdirAll(uploadDir, 0755); err != nil {
			log.Fatalf("Failed to create upload directory: %v", err)
		}
		log.Printf("Upload directory created: %s", uploadDir)
	}

	// Handler for static files
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == http.MethodGet {
			serveStaticFile(w, r)
		} else if r.Method == http.MethodPost && *upload {
			handleUpload(w, r)
		} else {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	// Handler for directory listing
	http.HandleFunc("/files/", func(w http.ResponseWriter, r *http.Request) {
		path := r.URL.Path[len("/files/"):]
		if path == "" {
			path = "."
		}
		serveDirectory(w, r, path)
	})

	addr := fmt.Sprintf("0.0.0.0:%d", *port)

	if *https {
		// Generate self-signed certificate
		cert, err := generateSelfSignedCert()
		if err != nil {
			log.Fatalf("Failed to generate certificate: %v", err)
		}

		server := &http.Server{
			Addr: addr,
			TLSConfig: &tls.Config{
				Certificates: []tls.Certificate{*cert},
			},
		}

		log.Printf("HTTPS server starting on https://%s", addr)
		log.Printf("Access from other PCs: https://<your-ip>:%d", *port)
		log.Fatal(server.ListenAndServeTLS("", ""))
	} else {
		log.Printf("HTTP server starting on http://%s", addr)
		log.Printf("Access from other PCs: http://<your-ip>:%d", *port)
		log.Fatal(http.ListenAndServe(addr, nil))
	}
}

func serveStaticFile(w http.ResponseWriter, r *http.Request) {
	// Remove leading slash
	path := r.URL.Path[1:]

	// Default to index.html
	if path == "" {
		path = "index.html"
	}

	// Prepend the serve directory
	fullPath := *dir + "/" + path

	// Check if file exists
	info, err := os.Stat(fullPath)
	if err != nil {
		// If index.html doesn't exist, show directory listing
		if path == "index.html" {
			serveDirectory(w, r, *dir)
			return
		}
		http.Error(w, "File not found", http.StatusNotFound)
		return
	}

	// If it's a directory, serve index.html or list contents
	if info.IsDir() {
		indexPath := fullPath + "/index.html"
		if _, err := os.Stat(indexPath); err == nil {
			path = indexPath
		} else {
			serveDirectory(w, r, fullPath)
			return
		}
	}

	// Serve the file
	http.ServeFile(w, r, fullPath)
}

func serveDirectory(w http.ResponseWriter, r *http.Request, dir string) {
	// Security: prevent directory traversal
	if dir == ".." || (len(dir) >= 2 && dir[:2] == "..") {
		http.Error(w, "Access denied", http.StatusForbidden)
		return
	}

	files, err := os.ReadDir(dir)
	if err != nil {
		http.Error(w, "Could not read directory", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	fmt.Fprintf(w, "<html><head><title>Simple HTTP Server</title></head><body>")
	fmt.Fprintf(w, "<h1>Directory: %s</h1>", dir)
	fmt.Fprintf(w, "<ul>")

	if dir != "." {
		fmt.Fprintf(w, "<li><a href=\"/files/..\">.. (Parent)</a></li>")
	}

	for _, file := range files {
		name := file.Name()
		if file.IsDir() {
			fmt.Fprintf(w, "<li><a href=\"/files/%s\">📁 %s/</a></li>", name, name)
		} else {
			if dir == "." {
				fmt.Fprintf(w, "<li><a href=\"/%s\">📄 %s</a></li>", name, name)
			} else {
				fmt.Fprintf(w, "<li><a href=\"/%s/%s\">📄 %s</a></li>", dir, name, name)
			}
		}
	}
	fmt.Fprintf(w, "</ul></body></html>")
}

func handleUpload(w http.ResponseWriter, r *http.Request) {
	// Parse multipart form
	if err := r.ParseMultipartForm(10 << 20); err != nil { // 10MB max
		http.Error(w, "Failed to parse form", http.StatusBadRequest)
		return
	}

	file, header, err := r.FormFile("file")
	if err != nil {
		http.Error(w, "Failed to get file", http.StatusBadRequest)
		return
	}
	defer file.Close()

	// Create the uploaded file
	dst, err := os.Create(uploadDir + "/" + header.Filename)
	if err != nil {
		http.Error(w, "Failed to save file", http.StatusInternalServerError)
		return
	}
	defer dst.Close()

	// Copy the file
	if _, err := io.Copy(dst, file); err != nil {
		http.Error(w, "Failed to save file", http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, "File uploaded successfully: %s", header.Filename)
}

func generateSelfSignedCert() (*tls.Certificate, error) {
	// Generate RSA key
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		return nil, err
	}

	// Create certificate template
	template := x509.Certificate{
		SerialNumber: big.NewInt(1),
		Subject: pkix.Name{
			Organization: []string{"Simple HTTP Server"},
		},
		NotBefore:             time.Now(),
		NotAfter:              time.Now().Add(365 * 24 * time.Hour),
		KeyUsage:              x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
		ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		BasicConstraintsValid: true,
		IPAddresses:           []net.IP{net.ParseIP("127.0.0.1"), net.ParseIP("0.0.0.0")},
	}

	// Create certificate
	derBytes, err := x509.CreateCertificate(rand.Reader, &template, &template, &privateKey.PublicKey, privateKey)
	if err != nil {
		return nil, err
	}

	// Encode certificate and key to PEM
	certPEM := pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE", Bytes: derBytes})
	keyPEM := pem.EncodeToMemory(&pem.Block{Type: "RSA PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(privateKey)})

	// Parse into tls.Certificate
	cert, err := tls.X509KeyPair(certPEM, keyPEM)
	if err != nil {
		return nil, err
	}

	return &cert, nil
}
