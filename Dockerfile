# ComfyUI Chroma + PuLID Serverless Worker
# Built from clean base — no FLUX models, only what we need
# Deploy via RunPod GitHub Integration (builds on their servers)
#
# Total image: ~25GB
#   Base:     ~3-5GB (ComfyUI + Python + worker handler)
#   Models:   ~20GB  (Chroma 17.8GB + T5-XXL 9.1GB + VAE 0.3GB + PuLID 1GB + EVA-CLIP 0.8GB + AntelopeV2 0.3GB)
#   Nodes:    ~0.5GB (custom nodes + pip deps)
#
FROM runpod/worker-comfyui:5.7.1-base

# ── Custom Nodes ────────────────────────────────────────────────────
# PuLID-Flux-Chroma (not on comfy registry, install from git)
RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/jeankassio/ComfyUI-PuLID-Flux-Chroma.git && \
    cd ComfyUI-PuLID-Flux-Chroma && \
    if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

# GGUF support (for future quantized model use)
RUN comfy-node-install comfyui-gguf || \
    (cd /comfyui/custom_nodes && \
     git clone https://github.com/city96/ComfyUI-GGUF.git && \
     cd ComfyUI-GGUF && \
     if [ -f requirements.txt ]; then pip install -r requirements.txt; fi)

# PuLID dependencies
RUN pip install insightface facexlib onnxruntime-gpu

# ── Small Models (baked in, ~2.4GB total) ───────────────────────────
# PuLID Flux model (~1GB)
RUN comfy model download \
    --url https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.1.safetensors \
    --relative-path models/pulid \
    --filename pulid_flux_v0.9.1.safetensors

# EVA02-CLIP for PuLID face conditioning (~800MB)
RUN comfy model download \
    --url https://huggingface.co/QuanSun/EVA-CLIP/resolve/main/EVA02_CLIP_L_336_psz14_s6B.pt \
    --relative-path models/clip \
    --filename EVA02_CLIP_L_336_psz14_s6B.pt

# InsightFace AntelopeV2 face detection (~300MB)
RUN mkdir -p /comfyui/models/insightface/models/antelopev2 && \
    cd /tmp && \
    wget -q https://huggingface.co/MonsterMMORPG/tools/resolve/main/antelopev2.zip && \
    python3 -c "import zipfile; zipfile.ZipFile('/tmp/antelopev2.zip').extractall('/comfyui/models/insightface/models/antelopev2/')" && \
    rm antelopev2.zip

# FLUX VAE (~310MB, from Chroma repo — no auth needed)
RUN comfy model download \
    --url https://huggingface.co/lodestones/Chroma/resolve/main/ae.safetensors \
    --relative-path models/vae \
    --filename ae.safetensors

# ── Large Models (separate layers for caching) ─────────────────────
# T5-XXL fp16 text encoder (~9.1GB)
RUN comfy model download \
    --url https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors \
    --relative-path models/clip \
    --filename t5xxl_fp16.safetensors

# Chroma1-HD full precision (~17.8GB) — LARGEST LAYER, keep last for caching
RUN comfy model download \
    --url https://huggingface.co/lodestones/Chroma1-HD/resolve/main/Chroma1-HD.safetensors \
    --relative-path models/unet \
    --filename Chroma1-HD.safetensors
