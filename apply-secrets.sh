#!/bin/bash
# Run this ONCE on your cluster to create secrets
# Fill in your actual values below

kubectl create secret generic preso-secrets -n preso \
  --from-literal=POSTGRES_USER=preso \
  --from-literal=POSTGRES_PASSWORD="YOUR_DB_PASSWORD" \
  --from-literal=AWS_ACCESS_KEY_ID=minioadmin \
  --from-literal=AWS_SECRET_ACCESS_KEY="YOUR_MINIO_PASSWORD" \
  --from-literal=MINIO_ROOT_USER=minioadmin \
  --from-literal=MINIO_ROOT_PASSWORD="YOUR_MINIO_PASSWORD" \
  --from-literal=NEXTAUTH_SECRET="YOUR_32_CHAR_JWT_SECRET" \
  --from-literal=ENCRYPTION_KEY="YOUR_64_HEX_CHAR_KEY" \
  --from-literal=GOOGLE_API_KEY="YOUR_GEMINI_KEY" \
  --from-literal=ANTHROPIC_API_KEY="YOUR_ANTHROPIC_KEY" \
  --from-literal=OPENAI_API_KEY="" \
  --from-literal=MISTRAL_API_KEY="" \
  --from-literal=TAVILY_API_KEY="YOUR_TAVILY_KEY" \
  --from-literal=ADMIN_USERNAME="admin" \
  --from-literal=ADMIN_PASSWORD="YOUR_ADMIN_PASSWORD" \
  --from-literal=ADMIN_COOKIE_SECRET="YOUR_32_CHAR_RANDOM_SECRET" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Secrets applied!"
