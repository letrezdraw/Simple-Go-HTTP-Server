FROM golang:1.21-alpine

WORKDIR /app

# Copy go mod and download dependencies
COPY go.mod .
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN go build -o server main.go

# Expose port
EXPOSE 8080

# Run the server
CMD ["sh", "-c", "mkdir -p /app/uploads && ./server -port 8080"]

