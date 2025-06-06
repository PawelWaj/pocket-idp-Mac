#!/usr/bin/env bash
set -eo pipefail

if [ -z "${HUMANITEC_ORG}" ]; then
    echo "Error: HUMANITEC_ORG environment variable is not set"
    exit 1
fi

echo "Deploying workload with Backstage"

humanitec_app=$(terraform -chdir=setup/tf_backstage output -raw humanitec_app_backstage)

humctl score deploy --app "$humanitec_app" --env 5min-local -f score-files/backstage.yaml --wait

workload_host=$(humctl get active-resources --app "$humanitec_app" --env 5min-local  -o yaml | yq '.[] | select(.metadata.type == "route") | .status.resource.host')

echo "Waiting for workload to be available"

kubectl get pods --all-namespaces
#   kubectl -n "$humanitec_app-development" logs deployment/hello-world

# manually change the host here as the workload host resolves to localhost, which is not reachable from the container
# if curl -I --retry 30 --retry-delay 3 --retry-all-errors --fail \
#   --connect-to "$workload_host:30443:5min-idp-control-plane:30443" \
#   "https://$workload_host:30443"; then
#   echo "Workload available at: https://$workload_host:30443"
# else
#   echo "Workload not available"
#   kubectl get pods --all-namespaces
#   kubectl -n "$humanitec_app-development" logs deployment/hello-world
#   exit 1
# fi
