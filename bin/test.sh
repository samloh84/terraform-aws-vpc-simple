#!/bin/bash

if [[ -f ${HOME}/.aws/login_aws.sh ]]; then
    source ${HOME}/.aws/login_aws.sh
fi


ACTION=${1}

if [[ "${ACTION}" == "" ]]; then
    ACTION="converge"
fi


bundle exec kitchen ${ACTION}


if command -v osascript; then
    osascript -e "tell app \"System Events\" to display alert \"terraform-aws-vpc-simple\" message \"terraform-aws-vpc-simple kitchen ${ACTION} completed.\""
fi
