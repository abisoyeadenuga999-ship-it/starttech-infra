#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../terraform"

terraform init -input=false
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan

read -r -p "Apply this plan? (yes/no) " answer
if [ "$answer" = "yes" ]; then
  terraform apply tfplan
else
  echo "Aborted."
fi
