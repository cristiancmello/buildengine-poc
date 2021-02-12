

aws cloudformation deploy^
  --profile sandboxuser^
  --template-file template.yml^
  --stack-name buildengine^
  --capabilities CAPABILITY_NAMED_IAM