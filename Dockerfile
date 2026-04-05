FROM python:3.10-slim

WORKDIR /app

# System deps
RUN apt-get update && apt-get install -y \
    libsndfile1 \
    ffmpeg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Piper
RUN pip install --no-cache-dir piper-tts[http]

# Download model manually (important)
RUN mkdir -p models && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx -O models/model.onnx && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json -O models/model.onnx.json

# Expose port
EXPOSE 10000

# ✅ FIX: Provide model path
CMD ["python3", "-m", "piper.http_server", \
     "-m", "models/model.onnx", \
     "-c", "models/model.onnx.json", \
     "--host", "0.0.0.0", \
     "--port", "10000"]
