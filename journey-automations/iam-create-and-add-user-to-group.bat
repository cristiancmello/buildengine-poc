
set AWS_PROFILE=root
set AWS_REGION=us-east-1
set AWS_IAM_USERNAME=kupo-a
set AWS_IAM_USERPATH=/kupoers/
set AWS_IAM_GROUPNAME=us-east-1_kupoers_001

aws iam create-user^
  --profile %AWS_PROFILE%^
  --region %AWS_REGION%^
  --path %AWS_IAM_USERPATH%^
  --user-name %AWS_IAM_USERNAME%

aws iam add-user-to-group^
  --profile %AWS_PROFILE%^
  --region %AWS_REGION%^
  --group-name %AWS_IAM_GROUPNAME%^
  --user-name %AWS_IAM_USERNAME%