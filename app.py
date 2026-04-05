from fastapi import FastAPI
from fastapi.responses import FileResponse
from pydantic import BaseModel
import subprocess
import uuid
import os

app = FastAPI()

MODEL_PATH = "models/model.onnx"
CONFIG_PATH = "models/model.onnx.json"

class TTSRequest(BaseModel):
    text: str

@app.post("/tts")
def generate_tts(req: TTSRequest):
    output_file = f"/tmp/{uuid.uuid4()}.wav"

    process = subprocess.Popen(
        [
            "./piper",
            "--model", MODEL_PATH,
            "--config", CONFIG_PATH,
            "--output_file", output_file
        ],
        stdin=subprocess.PIPE,
        text=True
    )

    process.communicate(req.text)

    return FileResponse(output_file, media_type="audio/wav")
