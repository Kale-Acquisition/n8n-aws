#!/bin/bash

svc=$1
environment=$2

if [ -z $svc  ]
then 
  echo "No \$svc parameter provided.";
  exit 1;
fi

if [ -z $environment  ]
then 
  echo "No \$environment parameter provided.";
  exit 1;
fi

echo 'Downloading copilot...'
wget https://ecs-cli-v2-release.s3.amazonaws.com/copilot-linux-v1.33.4
mv ./copilot-linux-v1.33.4 ./copilot-linux
chmod +x ./copilot-linux

echo 'Upgrading app...'
./copilot-linux app upgrade;

echo 'Executing copilot svc deploy...'

./copilot-linux svc deploy -n $svc -e $environment ;

if [ $? -ne 0 ]; then
  echo "Service deployment failed. Please check build logs to see if there was a manifest validation error." 1>&2;
  exit 1;
fi