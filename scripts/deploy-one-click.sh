#!/usr/bin/env bash
set -euo pipefail

ENV="${1:?usage: $0 <env>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LAYERS=(
  "01-management-and-monitoring"
  "02-connectivity-hub"
  "03-monolith-spokes"
  "04-global-edge-and-dr"
)

for layer in "${LAYERS[@]}"; do
  echo "=== Deploying ${ENV}/${layer} ==="
  dir="${ROOT}/environments/${ENV}/${layer}"
  (cd "${dir}" && terraform init -input=false && terraform apply -auto-approve -input=false)
done
echo "=== Deployment complete for ${ENV} ==="
