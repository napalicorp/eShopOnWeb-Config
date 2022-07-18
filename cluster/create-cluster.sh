#!/bin/bash

aws cloudformation deploy \
--template eShopOnWeb-Config/cluster/eks-cluster-control-pane.yaml \
--stack-name eshop-dev \
--capabilities CAPABILITY_NAMED_IAM

aws cloudformation deploy \
--template eks-cluster-nodes.yaml \
--stack-name eshop-dev-eks-nodes \
--capabilities CAPABILITY_NAMED_IAM \
--parameter-overrides ClusterName=eshop-dev-EksCluster \
KeyName=eshop-dev-node-keypair \
NodeGroupName=eshop-dev-nodegroup \
ClusterControlPlaneSecurityGroup=sg-07bef293a4124b069 \
Subnets=subnet-0ff81b4432762bfa2,subnet-0ac6a27c713c22b3a \
VpcId=vpc-01aa8d09e7193fe75

aws eks --region ap-southeast-2 update-kubeconfig --name eshop-dev-EksCluster

kubectl apply -f aws-auth-cm.yaml

kubectl get nodes --watch