
aws lambda invoke^
  --profile sandboxuser^
  --function-name bash-runtime^
  --payload "{\"text\":\"Hello\"}"^
  response.txt --cli-binary-format raw-in-base64-out
