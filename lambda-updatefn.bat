
aws lambda update-function-code^
  --profile sandboxuser^
  --region us-east-1^
  --function-name fnbuildengine^
  --image-uri 467742762527.dkr.ecr.us-east-1.amazonaws.com/fnbuildimagef1/custom-node:latest