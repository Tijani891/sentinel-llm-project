# backend/app/main.py
import os
import time
import logging
from fastapi import FastAPI, Request
from pydantic import BaseModel
from datadog import initialize, api
from ddtrace import patch_all, tracer

patch_all()  # auto-instrument supported libs

# Datadog init (optional for metrics via API)
DATADOG_API_KEY = os.getenv("DATADOG_API_KEY")
DATADOG_APP_KEY = os.getenv("DATADOG_APP_KEY")

if DATADOG_API_KEY:
    options = {"api_key": DATADOG_API_KEY}
    initialize(**options)

logger = logging.getLogger("sentinel")
logging.basicConfig(level=logging.INFO)

app = FastAPI(title="SentinelLLM API")


class ChatRequest(BaseModel):
    user_id: str
    prompt: str


@app.post("/chat")
async def chat(req: ChatRequest, request: Request):
    start = time.time()
    request_id = request.headers.get("x-request-id", str(int(start*1000)))
    # Example metadata
    logger.info("received_prompt", extra={
        "request_id": request_id,
        "user_id": req.user_id,
        "prompt_length": len(req.prompt)
    })

    # TODO: call Vertex AI Gemini here (later milestone)
    # For now return a canned response
    response_text = f"Echo: {req.prompt}"
    latency_ms = int((time.time() - start) * 1000)

    # Send simple metric to Datadog via API (optional)
    if DATADOG_API_KEY:
        api.Metric.send(metric="sentinel.chat.latency_ms",
                        points=latency_ms,
                        tags=[f"user:{req.user_id}"])

    return {"request_id": request_id, "response": response_text, "latency_ms": latency_ms}
