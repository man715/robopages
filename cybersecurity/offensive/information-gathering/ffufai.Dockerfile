# Git clone stage
FROM alpine:latest AS source
RUN apk add --no-cache git
WORKDIR /src
RUN git clone https://github.com/GangGreenTemperTatum/ffufai.git . || exit 1

# Final stage
FROM python:3.9-slim
WORKDIR /app

# Copy from source
COPY --from=source /src /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

USER nobody:nogroup
EXPOSE 8080

ENTRYPOINT ["python", "ffufai.py"]