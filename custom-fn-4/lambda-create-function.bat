
aws lambda create-function^
  --profile sandboxuser^
  --function-name bash-runtime^
  --zip-file fileb://function.zip^
  --handler function.handler^
  --runtime provided^
  --role arn:aws:iam::467742762527:role/buildengine-FnBuildLambdaExecutionRole-V2E0EIP26021