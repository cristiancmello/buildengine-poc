
aws cloudformation delete-stack^
  --profile sandboxuser^
  --stack-name buildengine

aws cloudformation delete-stack^
  --profile sandboxuser^
  --stack-name ecr-custom-fn-1

aws cloudformation delete-stack^
  --profile sandboxuser^
  --stack-name ecr-custom-fn-2