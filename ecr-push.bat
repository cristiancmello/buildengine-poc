
set imagename=%1
shift

aws ecr get-login-password --profile sandboxuser --region us-east-1 | docker login --username AWS --password-stdin 467742762527.dkr.ecr.us-east-1.amazonaws.com
docker push 467742762527.dkr.ecr.us-east-1.amazonaws.com/fnbuildimagef1/%imagename%:latest