# Deployment Notes

This repository builds a RunPod Serverless ComfyUI worker from `Dockerfile`.

## Current Build Shape

- Base image: `runpod/worker-comfyui:5.7.1-base`
- Model strategy: fp8 quantized Chroma and T5 weights for 24GB GPU targets
- Runtime model directories:
  - `/comfyui/models/unet`
  - `/comfyui/models/clip`
  - `/comfyui/models/vae`
  - `/comfyui/models/loras`

## Model Download Inventory

| Component | Source noted in Dockerfile | Local filename |
| --- | --- | --- |
| Chroma1-HD fp8 | `silveroxides/Chroma1-HD-fp8-scaled` | `Chroma1-HD-fp8.safetensors` |
| T5-XXL fp8 | `comfyanonymous/flux_text_encoders` | `t5xxl_fp8_e4m3fn.safetensors` |
| CLIP-L | `comfyanonymous/flux_text_encoders` | `clip_l.safetensors` |
| FLUX VAE | `cocktailpeanut/xulf-dev` | `ae.safetensors` |
| Flux Uncensored V2 LoRA | `enhanceaiteam/Flux-Uncensored-V2` | `flux_uncensored_v2.safetensors` |

## Maintenance Checklist

- Confirm every Hugging Face URL still resolves before rebuilding the endpoint.
- Recheck the final image size after changing the RunPod base image or model list.
- Keep the README GPU guidance aligned with the model precision used in `Dockerfile`.
- If a future workflow requires PuLID or other custom nodes, document those nodes here and add the installation steps to `Dockerfile`.
