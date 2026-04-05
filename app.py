from fastapi import FastAPI
from pydantic import BaseModel
import subprocess
import uuid
import os

app = FastAPI()

MODEL_PATH = "models/en_US-lessac-medium.onnx"
CONFIG_PATH = "models/en_US-lessac-medium.onnx.json"

class TTSRequest(BaseModel):
    text: str

@app.post("/tts")
def generate_tts(req: TTSRequest):
    output_file = f"/tmp/{uuid.uuid4()}.wav"

    command = [
        "./piper",
        "--model", MODEL_PATH,
        "--config", CONFIG_PATH,
        "--output_file", output_file
    ]

    process = subprocess.Popen(
        command,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )

    process.communicate(req.text)

    return {"audio_path": output_file}
