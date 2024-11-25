# ffufai.Dockerfile
# Git clone stage
FROM alpine:latest AS source
RUN apk add --no-cache git
WORKDIR /src
RUN git clone https://github.com/jthack/ffufai.git . || exit 1

# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /build
COPY --from=source /src .

# Set Go build flags
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GO111MODULE=on

# Build optimized binary
RUN go mod download && \
    go build -ldflags="-w -s" -o ffufai main.go

# Final stage
FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app

# Copy binary and wordlists
COPY --from=builder /build/ffufai /app/
COPY --from=builder /build/wordlists /app/wordlists

USER nonroot:nonroot
EXPOSE 8080

ENTRYPOINT ["/app/ffufai"]