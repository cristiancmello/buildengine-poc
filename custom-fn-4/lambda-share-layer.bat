
aws lambda add-layer-version-permission^
  --profile sandboxuser^
  --layer-name bash-runtime --version-number 4 ^
  --principal "*"^
  --statement-id publish^
  --action lambda:GetLayerVersion