
## AWS Users

### Sandbox

* Example for profile switch

```bash
aws s3 ls --profile sandboxuser
```

### Steps...

```bat
.\cf-fn1-deploy.bat         # fn1 ECR Container Repo Infra
.\docker-build-and-tag.bat
.\ecr-push.bat
.\cf-deploy.bat
```