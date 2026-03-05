# ComfyUI Chroma + PuLID — RunPod Serverless Worker

Custom ComfyUI worker for RunPod Serverless with:
- **Chroma1-HD** (17.8GB) — uncensored image generation model
- **PuLID-Flux-Chroma** — face/character consistency
- **T5-XXL fp16** text encoder (9.1GB)
- Supporting models: EVA02-CLIP, InsightFace AntelopeV2, FLUX VAE

## Deploy

1. Connect this repo to RunPod via GitHub Integration
2. Create a new Serverless endpoint → Import Git Repository
3. Select GPU: A40 (48GB VRAM) or RTX A6000 (48GB)
4. Deploy

## Workflow Nodes Used

- `UNETLoader` (Chroma1-HD.safetensors)
- `CLIPLoader` with `type: 'chroma'` (t5xxl_fp16.safetensors)
- `VAELoader` (ae.safetensors)
- `ModelSamplingAuraFlow`, `CFGGuider`, `BetaSamplingScheduler`, `SamplerCustomAdvanced`
- `PulidFluxModelLoader`, `PulidFluxInsightFaceLoader`, `PulidFluxEvaClipLoader`, `ApplyPulidFlux`

## Image Size

~25GB total (base ~5GB + models ~20GB)
