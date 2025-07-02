#!/bin/bash

environment=$1

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

echo 'Executing copilot env deploy...'

./copilot-linux env deploy -n $environment ;

if [ $? -ne 0 ]; then
  echo "Environment deployment failed. Please check build logs to see if there was a manifest validation error." 1>&2;
  exit 1;
fi