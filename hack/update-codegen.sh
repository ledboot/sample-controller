#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
REPO_ROOT_DIR="$(pwd)"

SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
CODEGEN_PKG=${CODEGEN_PKG:-$(cd "${REPO_ROOT_DIR}"; ls -d -1 ./vendor/k8s.io/code-generator 2>/dev/null || echo ../code-generator)}

# generate the code with:
# --output-base    because this script should also be able to run inside the vendor dir of
#                  k8s.io/kubernetes. The output-base is needed for the generators to output into the vendor dir
#                  instead of the $GOPATH directly. For normal projects this can be dropped.
"${CODEGEN_PKG}"/generate-groups.sh "deepcopy,client,informer,lister" \
  github.com/ledboot/sample-controller/pkg/client github.com/ledboot/sample-controller/pkg/apis \
  samplecontroller:v1alpha1 \
  --go-header-file "${REPO_ROOT_DIR}"/hack/boilerplate/boilerplate.go.txt
