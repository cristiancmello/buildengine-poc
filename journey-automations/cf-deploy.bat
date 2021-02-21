
:: AWS Cloudformation Deploy
::   profile root : AWS Root Account
::   template-file : Cloudformation template file
::   stack-name : nome da stack
::   capabilities "CAPABILITY_NAMED_IAM" : O modelo inclui nomes personalizados para recursos IAM
::   no-execute-changeset : se tiver presente, indica REVIEW_IN_PROGRESS sinalizando uma revisão antes de efetivar o deploy.
::   parameter-overrides : aqui você pode passar uma lista de parâmetros

set AWS_PROFILE=root
set AWS_REGION=us-east-1
set AWS_ROOT_ACCOUNT_NUMBER=467742762527
set TEMPLATE_FILE=CfIamGroupKupoers.yml
set STACK_NAME=CfIamGroupKupoers001
set AWS_CAPABILITIES=CAPABILITY_NAMED_IAM
set KUPOERS_GROUPNAME=kupoers
set KUPOERS_NUMBER="001"

:: Outputs
:: IamGroupKupoersArn
:: Exported IamGroupKupoersGroupName

aws cloudformation deploy^
  --profile %AWS_PROFILE%^
  --region %AWS_REGION%^
  --template-file %TEMPLATE_FILE%^
  --stack-name %STACK_NAME%^
  --capabilities %AWS_CAPABILITIES%^
  --parameter-overrides^
  AwsRootAccountNumber=%AWS_ROOT_ACCOUNT_NUMBER%^
  KupoersGroupName=%KUPOERS_GROUPNAME%^
  KupoersNumber=%KUPOERS_NUMBER%