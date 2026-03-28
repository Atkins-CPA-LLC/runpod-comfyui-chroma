# ComfyUI Chroma1-HD fp8 Serverless Worker for RunPod
# Uses fp8 quantized models — fits on 24GB GPUs (RTX 3090/4090/A5000)
# Deploy via RunPod GitHub Integration
#
# Total image: ~15GB
#   Base:     ~3GB  (ComfyUI + Python + worker handler)
#   Models:   ~14GB (Chroma fp8 8.6GB + T5 fp8 4.6GB + CLIP 235MB + VAE 320MB + LoRA 656MB)
#
FROM runpod/worker-comfyui:5.7.1-base

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Model directories
RUN mkdir -p /comfyui/models/unet /comfyui/models/clip /comfyui/models/vae /comfyui/models/loras

# ── Models (fp8 quantized for 24GB GPUs) ────────────────────────────

# Chroma1-HD fp8 (~8.6GB) — natively uncensored, Apache 2.0
RUN wget --progress=bar:force:noscroll -O /comfyui/models/unet/Chroma1-HD-fp8.safetensors \
    "https://huggingface.co/silveroxides/Chroma1-HD-fp8-scaled/resolve/main/Chroma1-HD-fp8_scaled.safetensors"

# T5-XXL fp8 text encoder (~4.6GB)
RUN wget --progress=bar:force:noscroll -O /comfyui/models/clip/t5xxl_fp8_e4m3fn.safetensors \
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors"

# CLIP-L encoder (~235MB)
RUN wget --progress=bar:force:noscroll -O /comfyui/models/clip/clip_l.safetensors \
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"

# VAE (~320MB) — public mirror (official FLUX repo is gated)
RUN wget --progress=bar:force:noscroll -O /comfyui/models/vae/ae.safetensors \
    "https://huggingface.co/cocktailpeanut/xulf-dev/resolve/main/ae.safetensors"

# Flux Uncensored V2 LoRA (~656MB) — additional uncensored support
RUN wget --progress=bar:force:noscroll -O /comfyui/models/loras/flux_uncensored_v2.safetensors \
    "https://huggingface.co/enhanceaiteam/Flux-Uncensored-V2/resolve/main/lora.safetensors"

# Verify downloads
RUN echo "=== Model sizes ===" && \
    du -h /comfyui/models/unet/* && \
    du -h /comfyui/models/clip/* && \
    du -h /comfyui/models/vae/* && \
    du -h /comfyui/models/loras/* && \
    echo "=== Total ===" && du -sh /comfyui/models/
