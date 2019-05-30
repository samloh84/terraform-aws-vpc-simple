#!/bin/bash

if [[ -f ${HOME}/.aws/login_aws.sh ]]; then
source ${HOME}/.aws/login_aws.sh
fi

let TIMESTAMP=$(date "+%Y%m%d%H%M%S")

cd test
terraform init
terraform apply -auto-approve | tee output_${TIMESTAMP}.log
TEST_RESULT=$?
terraform destroy -auto-approve
exit ${TEST_RESULT}
