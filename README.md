# PresoAI — Kubernetes Manifests

K8s deployment manifests for [preso.ai](https://preso.ai) — AI-Powered Presentation Generator.

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Ingress (nginx)                    │
│                   preso.ai / *.preso.ai              │
├──────────┬──────────┬───────────┬───────────────────┤
│   Web    │ Collabora│  Python   │    Node Worker     │
│ (Next.js)│  (CODE)  │  Agent    │   (pptxgenjs)      │
│  :3000   │  :9980   │  :8000    │                    │
├──────────┴──────────┴───────────┴───────────────────┤
│        PostgreSQL      Redis        MinIO (S3)       │
│          :5432         :6379        :9000             │
└─────────────────────────────────────────────────────┘
```

## CI/CD Flow

1. **Push to `main`** on [PresoAI](https://github.com/akshay-eng/PresoAI)
2. **GitHub Actions** builds Docker images → pushes to DockerHub (`ak3hay/preso-*`)
3. **Actions updates** image tags in `overlays/*/kustomization.yaml`
4. **ArgoCD detects** changes → syncs to K8s cluster

## Quick Start

```bash
# Apply ArgoCD application (one-time)
kubectl apply -f argocd-app.yaml

# Or deploy manually with kustomize
kubectl apply -k overlays/dev
```

## Structure

```
├── argocd-app.yaml          # ArgoCD Application CRDs
├── base/
│   ├── kustomization.yaml   # Base kustomize config
│   ├── namespace/            # Namespace
│   ├── configmap.yaml        # Non-secret config
│   ├── secrets.yaml          # Secrets (update before deploying!)
│   ├── ingress.yaml          # Ingress rules
│   ├── postgres/             # PostgreSQL 16
│   ├── redis/                # Redis 7
│   ├── minio/                # MinIO S3 + init job
│   ├── collabora/            # Collabora CODE editor
│   ├── web/                  # Next.js frontend + API
│   ├── python-agent/         # LangGraph AI agent
│   ├── node-worker/          # pptxgenjs PPTX generator
│   └── pptx-agent/           # Claude Code PPTX agent
├── overlays/
│   ├── dev/                  # Dev: 1 replica, latest tags
│   └── prod/                 # Prod: 2 replicas, pinned tags
```

## Secrets

**⚠️ Update `base/secrets.yaml` before deploying!**

Required secrets:
- `POSTGRES_PASSWORD` — database password
- `NEXTAUTH_SECRET` — JWT signing key (32+ chars)
- `ENCRYPTION_KEY` — API key encryption (64 hex chars)
- `GOOGLE_API_KEY` — for free tier Gemini access
- `TAVILY_API_KEY` — for web research agent
