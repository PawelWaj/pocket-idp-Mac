#!/usr/bin/env bash
set -eo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check required environment variables
check_env_var() {
    if [ -z "${!1}" ]; then
        echo -e "${RED}Error: $1 environment variable is not set${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ $1 is set${NC}"
    fi
}

# Check if humctl is logged in

humctl get organization

if [ $? -ne 0 ]; then
  echo -e "${RED}Error: humctl is not logged in${NC}"
  echo -e "${RED}Please run 'humctl login' and try again${NC}"
fi

# Check required environment variables
echo "Checking required environment variables..."
check_env_var "HUMANITEC_ORG"

mkdir -p /state/kube

# 1. Create registry container unless it already exists
reg_name='kind-registry'
reg_port='5001'
if [ "$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)" != 'true' ]; then
  docker run \
    -d --restart=always -p "127.0.0.1:${reg_port}:5000" --network bridge --name "${reg_name}" \
    registry:2
fi

# 2. Create Kind cluster
if [ ! -f /state/kube/config.yaml ]; then
  kind create cluster -n 5min-idp --kubeconfig /state/kube/config.yaml --config ./setup/kind/cluster.yaml
fi

# connect current container to the kind network
container_name="5min-idp"
if [ "$(docker inspect -f='{{json .NetworkSettings.Networks.kind}}' "${container_name}")" = 'null' ]; then
  docker network connect "kind" "${container_name}"
fi

# used by humanitec-agent / inside docker to reach the cluster
kubeconfig_docker=/state/kube/config-internal.yaml
kind export kubeconfig --internal  -n 5min-idp --kubeconfig "$kubeconfig_docker"

### Export needed env-vars for terraform
export TF_VAR_humanitec_org=$HUMANITEC_ORG
export TF_VAR_kubeconfig=$kubeconfig_docker

terraform -chdir=setup/terraform init -upgrade
terraform -chdir=setup/terraform apply -auto-approve

echo ""
echo ">>>> Everything prepared, ready to deploy application."
