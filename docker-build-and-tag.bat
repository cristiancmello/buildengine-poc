
set imagename=%1
shift

cd %imagename%

docker build -t fnbuildimagef1/%imagename% .
docker tag fnbuildimagef1/%imagename%:latest 467742762527.dkr.ecr.us-east-1.amazonaws.com/fnbuildimagef1/%imagename%:latest

cd ..