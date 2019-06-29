#!/bin/bash

if [[ -f ${HOME}/.aws/login_aws.sh ]]; then
source ${HOME}/.aws/login_aws.sh
fi

bundle exec kitchen test
