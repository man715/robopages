FROM debian:bookworm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    cmake \
    python3 \
    xvfb \
    python3-pip \
    python3-netaddr \
    python3-dev \
    firefox-esr \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Clone EyeWitness
RUN git clone --depth 1 https://github.com/RedSiege/EyeWitness.git /EyeWitness
WORKDIR /EyeWitness

# Setup Python virtual environment and dependencies
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    python3 -m pip install \
    fuzzywuzzy \
    selenium==4.9.1 \
    python-Levenshtein \
    pyvirtualdisplay \
    netaddr && \
    cd Python/setup && \
    ./setup.sh

# Set environment variables
ENV TERM=xterm \
    SCREENSHOT_DIR=/eyewitness/screens \
    LOGDIR=/eyewitness/logs

# Create directories and selenium log path
RUN mkdir -p /eyewitness/screens /eyewitness/logs

# Create wrapper script to handle venv activation and Xvfb
RUN echo '#!/bin/bash\n\
    source /EyeWitness/venv/bin/activate\n\
    mkdir -p "$SCREENSHOT_DIR"\n\
    xvfb-run --server-args="-screen 0, 1024x768x24" \\\n\
    python3 /EyeWitness/Python/EyeWitness.py \\\n\
    --selenium-log-path "$LOGDIR" "$@"' > /usr/local/bin/run-eyewitness && \
    chmod +x /usr/local/bin/run-eyewitness

VOLUME ["/eyewitness"]
WORKDIR /eyewitness

ENTRYPOINT ["/usr/local/bin/run-eyewitness"]
