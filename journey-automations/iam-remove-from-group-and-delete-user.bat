

@REM Before attempting to delete a user, remove the following items:
@REM   Password ( DeleteLoginProfile )
@REM   Access keys ( DeleteAccessKey )
@REM   Signing certificate ( DeleteSigningCertificate )
@REM   SSH public key ( DeleteSSHPublicKey )
@REM   Git credentials ( DeleteServiceSpecificCredential )
@REM   Multi-factor authentication (MFA) device ( DeactivateMFADevice , DeleteVirtualMFADevice )
@REM   Inline policies ( DeleteUserPolicy )
@REM   Attached managed policies ( DetachUserPolicy )
@REM   Group memberships ( RemoveUserFromGroup )

set AWS_PROFILE=root
set AWS_REGION=us-east-1
set AWS_IAM_USERNAME=kupo-a
set AWS_IAM_GROUPNAME=us-east-1_kupoers_001

aws iam remove-user-from-group^
  --profile %AWS_PROFILE%^
  --region %AWS_REGION%^
  --group-name %AWS_IAM_GROUPNAME%^
  --user-name %AWS_IAM_USERNAME%

aws iam delete-user^
  --profile %AWS_PROFILE%^
  --region %AWS_REGION%^
  --user-name %AWS_IAM_USERNAME%