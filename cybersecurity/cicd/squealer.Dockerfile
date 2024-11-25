# Git clone stage
FROM alpine:latest AS source
RUN apk add --no-cache git
WORKDIR /src
RUN git clone https://github.com/owenrumney/squealer.git . && \
    ls -la  # Debug: verify files

# Build stage
FROM golang:1.21-alpine AS builder
WORKDIR /build
COPY --from=source /src/ ./
RUN ls -la && \
    go mod vendor && \
    go build -mod=vendor -ldflags="-w -s" -o squealer ./cmd/squealer

# Final stage
FROM gcr.io/distroless/static-debian12:nonroot
WORKDIR /app
COPY --from=builder /build/squealer /app/
USER nonroot:nonroot
ENTRYPOINT ["/app/squealer"]