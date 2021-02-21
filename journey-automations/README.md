# AWS Journey Automations

Automações para facilitar a criação e gerenciamento de grupos
para treinamento da AWS e outros fins.

## Implantar e Atualizar Cloudformation para criar Grupo Kupoers.

Kupoers: nome carinhoso para os kupos!
AWS Account: root

```bat
cf-deploy.bat
```

## Criar AWS IAM User 'kupo' e incluí-lo num Kupoers

AWS Account: root


## Remover Stacks

```bat
cf-delete-stack.bat
```

## Workflow


* Criar CF stack e adicionar usuários.

```
[worflow definitions
  STORAGE: [
    workflow_name: from drive dynamo
    kupoers: from drive dynamo
    template_file: from drive S3
    stack_name: from dynamo
    aws_capabilities: from dynamo
  ]
  INPUTS:
    Null
  OUTPUTS:
    - AWS_ROOT_ACCOUNT_PROFILE: get from privileged place (AWS Root Account Credentials Present (.aws/config and .aws/credentials))
    - AWS_REGION: AWS Region enabled by AWS Root Account
    - AWS_ROOT_ACCOUNT_NUMBER: get from privileged place
    - TEMPLATE_FILE: STORAGE.template_file
    - STACK_NAME: STORAGE.stack_name
    - AWS_CAPABILITIES: STORAGE.aws_capabilities
]
|
v
[cf-deploy
  INPUTS:
    - AWS_PROFILE=worflow.OUTPUTS.AWS_ROOT_ACCOUNT_PROFILE
    - AWS_REGION=worflow.OUTPUTS.AWS_REGION
    - AWS_ROOT_ACCOUNT_NUMBER=worflow.OUTPUTS.AWS_ROOT_ACCOUNT_NUMBER
    - TEMPLATE_FILE=worflow.OUTPUTS.TEMPLATE_FILE
    - STACK_NAME=worflow.OUTPUTS.STACK_NAME
    - AWS_CAPABILITIES=worflow.OUTPUTS.AWS_CAPABILITIES
    - KUPOERS_GROUPNAME=workflow.STORAGE.kupoers.last_created.groupname
    - KUPOERS_NUMBER=workflow.STORAGE.kupoers.last_created.number
  OUTPUTS:
    - IamGroupKupoersArn
    - Exported IamGroupKupoersGroupName
    - workflow.STORAGE.store(kupoers: new kupoers (IamGroupKupoersArn, IamGroupKupoersGroupName))
]
|
v
[iam-create-and-add-user-to-group
  REQUIREMENTS:
    - AWS_IAM_USERNAME: generated string
    - AWS_IAM_USERPATH: generated string
    - AWS_IAM_GROUPNAME: cf-deploy.OUTPUTS.IamGroupKupoersGroupName
  INPUTS:
    - AWS_PROFILE=<REQUIREMENTS::AWS_ROOT_ACCOUNT_PROFILE>
    - AWS_REGION=<REQUIREMENTS::AWS_REGION>
    - AWS_IAM_USERNAME=<REQUIREMENTS::AWS_IAM_USERNAME>
    - AWS_IAM_USERPATH=<REQUIREMENTS::AWS_IAM_USERPATH>
    - AWS_IAM_GROUPNAME=<REQUIREMENTS::AWS_IAM_GROUPNAME>
  OUTPUTS:
    Null
]
```

State Machine

```
Start
|
v
[workflowdefs]
|
v
[cf-deploy]
| OPTIONAL STEP
v
[iam-create-and-add-user-to-group]
|
v
Finish
```

* Clean up

```
[iam-remove-from-group-and-delete-user
  REQUIREMENTS:
    - AWS_ROOT_ACCOUNT_PROFILE: AWS Root Account Credentials Present

  INPUTS:
    - AWS_PROFILE=<REQUIREMENTS::AWS_ROOT_ACCOUNT_PROFILE>
    - AWS_REGION=us-east-1
    - AWS_IAM_USERNAME=kupo-a
    - AWS_IAM_GROUPNAME=us-east-1_kupoers_001
]
|
v
[cf-delete-stack]
```