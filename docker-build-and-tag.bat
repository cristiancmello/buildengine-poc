

cd custom-fn-1

docker build -t fnbuildimagef1/custom-node .
docker tag fnbuildimagef1/custom-node:latest 467742762527.dkr.ecr.us-east-1.amazonaws.com/fnbuildimagef1/custom-node:latest

cd ..