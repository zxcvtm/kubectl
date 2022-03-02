#!/bin/sh

set -e

version="$1"
config="$2"
command="$3"

if [ "$version" = "latest" ]; then
  version=$(curl -Ls https://dl.k8s.io/release/stable.txt)
fi

echo "using kubectl@$version"

curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$config" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

sh -c "kubectl $command"
