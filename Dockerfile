FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# -----------------------------
# Install Piper (stable version)
# -----------------------------
RUN wget https://github.com/rhasspy/piper/releases/download/v1.2.0/piper_linux_x86_64.tar.gz \
    && tar -xzf piper_linux_x86_64.tar.gz \
    && find . -name "piper" -type f -exec cp {} /app/piper \; \
    && chmod +x /app/piper \
    && rm -rf piper_linux_x86_64.tar.gz piper

# -----------------------------
# Download model from HuggingFace
# -----------------------------
RUN mkdir -p models && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx -O models/model.onnx && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json -O models/model.onnx.json

# -----------------------------
# Expose port (Render uses 10000)
# -----------------------------
EXPOSE 10000

# Start API
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "10000"]
