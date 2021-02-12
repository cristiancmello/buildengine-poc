
# The AWS base images provide the following environment variables:
# LAMBDA_TASK_ROOT=/var/task
# LAMBDA_RUNTIME_DIR=/var/runtime

FROM public.ecr.aws/lambda/nodejs:12
# Alternatively, you can pull the base image from Docker Hub: amazon/aws-lambda-nodejs:12

COPY index.js package.json /var/task/

# Install NPM dependencies for function
RUN npm install

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "index.handler" ]