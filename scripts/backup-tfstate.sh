#!/usr/bin/env bash
set -euo pipefail
ENV="${1:?usage: $0 <env>}"
LAYER="${2:?usage: $0 <env> <layer>}"
STORAGE="sttfstate${ENV}001"
CONTAINER="tfstate"
KEY="${ENV}/${LAYER}.tfstate"
TS="$(date +%Y%m%d%H%M%S)"
az storage blob copy start \
  --source-container "${CONTAINER}" --source-blob "${KEY}" \
  --destination-container "${CONTAINER}" --destination-blob "${KEY}.backup-${TS}" \
  --account-name "${STORAGE}" --auth-mode login
echo "Snapshot created: ${KEY}.backup-${TS}"
