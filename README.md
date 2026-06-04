# ComfyUI Chroma fp8 — RunPod Serverless Worker

Custom ComfyUI worker for RunPod Serverless with:
- **Chroma1-HD fp8** (~8.6GB) — fp8 quantized image generation model
- **T5-XXL fp8** text encoder (~4.6GB)
- Supporting models: CLIP-L, FLUX VAE, and Flux Uncensored V2 LoRA
- Base image: `runpod/worker-comfyui:5.7.1-base`

The Docker image is designed around fp8 model weights so it can fit on 24GB GPUs such as RTX 3090, RTX 4090, and A5000-class cards.

## Deploy

1. Connect this repo to RunPod via GitHub Integration
2. Create a new Serverless endpoint → Import Git Repository
3. Select a 24GB+ GPU
4. Deploy

## Bundled Models

| Path | Model |
| --- | --- |
| `/comfyui/models/unet/Chroma1-HD-fp8.safetensors` | Chroma1-HD fp8 |
| `/comfyui/models/clip/t5xxl_fp8_e4m3fn.safetensors` | T5-XXL fp8 text encoder |
| `/comfyui/models/clip/clip_l.safetensors` | CLIP-L encoder |
| `/comfyui/models/vae/ae.safetensors` | FLUX VAE |
| `/comfyui/models/loras/flux_uncensored_v2.safetensors` | Flux Uncensored V2 LoRA |

## Image Size

The Dockerfile estimates the model set at roughly 14GB, plus the RunPod ComfyUI base image. The final image size may vary as the upstream base image changes.

## Maintenance

See `docs/deployment.md` for deployment notes and the checks to make when model URLs, GPU sizing, or the RunPod base image changes.
