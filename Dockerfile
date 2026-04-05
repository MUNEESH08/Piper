FROM python:3.10-slim

WORKDIR /app

# Install system deps
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Copy code
COPY . .

# Install Python deps
RUN pip install --no-cache-dir -r requirements.txt

# Download Piper binary
RUN wget https://github.com/rhasspy/piper/releases/latest/download/piper_linux_x86_64.tar.gz \
    && tar -xvf piper_linux_x86_64.tar.gz \
    && mv piper/piper ./piper \
    && chmod +x ./piper

# 🔥 Download model from HuggingFace
RUN mkdir -p models && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx -O models/model.onnx && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json -O models/model.onnx.json

EXPOSE 10000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "10000"]
