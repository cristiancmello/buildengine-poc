

cd ecr-stack-fn-1

aws cloudformation deploy^
  --profile sandboxuser^
  --template-file template.yml^
  --stack-name ecr-stack-fn-1^
  --capabilities CAPABILITY_NAMED_IAM

cd ..