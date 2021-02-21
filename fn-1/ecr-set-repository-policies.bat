
aws ecr set-repository-policy^
  --profile root^
  --repository-name sandboxuser-a-fn1^
  --policy-text file://ECRComplexPolicies.json^
  --force