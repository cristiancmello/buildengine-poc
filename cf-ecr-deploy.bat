
set imagename=%1
shift

cd ecr-stack-%imagename%

aws cloudformation deploy^
  --profile sandboxuser^
  --template-file template.yml^
  --stack-name ecr-%imagename%^
  --capabilities CAPABILITY_NAMED_IAM

cd ..