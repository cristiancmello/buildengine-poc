
## AWS Users

### Sandbox

* Example for profile switch

```bash
aws s3 ls --profile sandboxuser
```

### Steps...

```bat
.\docker-build-and-tag.bat [custom-fn-1 | custom-fn-2]
.\cf-ecr-deploy.bat [custom-fn-1 | custom-fn-2]
.\ecr-push.bat [custom-fn-1 | custom-fn-2]
.\cf-deploy.bat [custom-fn-1 | custom-fn-2]

.\cf-destroy-all.bat
```

### Functions

#### custom-fn-3

* Test with:
 - Debian-based container
 - Lambda Runtime Interface Client (lambda-ric)
 - Lambda Runtime Interface Emulator (setup into container)

* How to test?
 - cd custom-fn-3
 - ./build.sh
 - ./run.sh
 - curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'