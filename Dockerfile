FROM python:3.10-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    libsndfile1 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install Piper (Python version)
RUN pip install --no-cache-dir piper-tts[http]

# Download voice from HuggingFace
RUN python3 -m piper.download_voices en_US-lessac-medium

# Expose port
EXPOSE 10000

# Run built-in HTTP server
CMD ["python3", "-m", "piper.http_server", "--host", "0.0.0.0", "--port", "10000"]
