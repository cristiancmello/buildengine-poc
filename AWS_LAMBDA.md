
## Custom Fn 1 - Função definida como uma imagem de Container

Ferramentas usadas:
  * AWSCLI (configurado com usuario sandboxuser para autenticação);
  * Console do Lambda;
  * Docker;
  * Linux;
  * NodeJS instalado num local (Maquina Local ou Outro Ambiente);
  * cURL;

### 1. Criar a Imagem de Container 

* A AWS fornece um conjunto de imagens básicas com o AWS ECR;
* Usaremos a imagem básica fornecida pela AWS com NodeJS;

```
[Num PC/Maquina Local] 
  -> [Criar Pasta 'fn-1']
  -> [Criar Arquivo 'fn-1/app.js']
  -> [Criar Arquivo 'fn-1/Dockerfile']
  -> [Criar Arquivo 'fn-1/package.json' executando o comando `npm init --force --yes`]
  -> [Criar Imagem do Docker executando o comando 
      Windows CMD: `
      set AWS_ECR_REPONAME=fn-1
      shift
      docker build -t %AWS_ECR_REPONAME% .
    `
  ]
  -> [Emular Runtime Interface com o comando 
      Windows CMD: `
      set AWS_ECR_REPONAME=fn-1
      set AWS_ECR_REPOTAG=latest
      set CONTAINER_PORT_EXTERNAL=9000
      set CONTAINER_PORT_INTERNAL=8080
      shift
      shift
      shift
      shift
      docker run -p %CONTAINER_PORT_EXTERNAL%:%CONTAINER_PORT_INTERNAL% %AWS_ECR_REPONAME%:%AWS_ECR_REPOTAG%
    `]
  -> [Testar Invocação da Função Lambda com o comando `curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'`]
```

* `fn-1/app.js`

```js
exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda')
  }

  return response;
}
```

* `fn-1/Dockerfile`

```Dockerfile
FROM public.ecr.aws/lambda/nodejs:12

# Copy function code and package.json
COPY app.js package.json /var/task/

# Install NPM dependencies for function
RUN npm install

# Set the CMD to your handler
CMD [ "app.handler" ]
```

### 2. Fazer Push da Imagem para o Amazon ECR

```
[Num PC/Maquina Local]
  -> [Conceder Permissão IAM `ecr:GetAuthorizationToken` para Conseguir fazer Login no ECR.

    (Essential):
      Descrição: para facilitar o uso do ECR, conceder todas as permissões em todos os recursos.

      1. Acesse o AWS IAM 
      2. Clique em "Add inline policy"
      3. Na aba "JSON", cole:
          {
            "Version": "2012-10-17",
            "Statement": [
              {
                  "Effect": "Allow",
                  "Action": "ecr:*",
                  "Resource": "*"
              }
            ]
          }
      4. Em Review Policy, dê o nome "ECRFullPolicies".
      5. Agora é possível logar com sucesso :)
    (Avançado)
      Descrição: A forma Essential é muito insegura e pode criar vulnerabilidades.
      Temos que delimitar as permissões exatas para evitar acessos indevidos que
      podem expor nossa imagem, podendo ser excluída acidentalmente ou obtida por usuários
      que só irão fazer ações específicas, como apenas baixar a imagem do Docker do ECR.

      1. Adicionar um User Policy ao usuário 'sandboxuser' com o comando 
         Windows CMD `
           set AWS_CLI_PROFILE=sandboxuser
           set AWS_IAM_USERNAME=sandboxuser
           set AWS_IAM_USERPOLICY_NAME=ECRPolicies
           set AWS_IAM_USERPOLICY_DOC="file://ECRPolicies.json"
           shift
           shift
           shift
           shift
           aws iam put-user-policy --profile %AWS_CLI_PROFILE% --user-name %AWS_IAM_USERNAME% --policy-name %AWS_IAM_USERPOLICY_NAME% --policy-document %AWS_IAM_USERPOLICY_DOC%
         `
  ]
  -> [Autenticar o Docker CLI no seu registry do Amazon ECR com o comando
    Windows CMD: `
    set AWS_REGION=us-east-1
    set AWS_ACCOUNT=467742762527
    set AWS_CLI_USER_PROFILE=sandboxuser
    set AWS_ECR_URL=%AWS_ACCOUNT%.dkr.ecr.%AWS_REGION%.amazonaws.com
    shift
    shift
    shift
    shift
    aws ecr get-login-password --profile %AWS_CLI_USER_PROFILE% --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ECR_URL%
    `
  ]
  -> [Dar Permissão ao IAM User para poder Criar Repository e ecr:DescribeRepositories no ECR.

    Descrição:
      - ecr:DescribeRepositories : permite que usuário veja outros repositórios criados
      - ecr:CreateRepository : permite que o usuário crie repositórios
      - ecr:DeleteRepository : permite que o usuário delete repositórios criados.
    
    1. Adicionar Actions ecr:CreateRepository e ecr:DescribeRepositories em ECRPolicies.json
  ]
  -> [Criar Repositório 'fn-1' no Amazon ECR.
    (Essential)
      1. Acesse o Console Management do ECR https://console.aws.amazon.com/ecr/home?region=us-east-1
      2. Clique em Create Repository ou https://console.aws.amazon.com/ecr/create-repository?region=us-east-1
      3. Preencha com as settings:
         - Visibility settings: Private
         - Repository name: fn-1
         - Tag immutability: DISABLED (image-tag-mutability MUTABLE)
         - Image Scan Settings
           - Scan on push: DISABLED
         - KMS Encryption: DISABLED
      4. Confirme e veja a seu repository 'fn-1' criado na lista de repositórios.

    (Avançado) 
      Windows CMD: `
        set AWS_ECR_REPONAME=fn-1
        set AWS_CLI_USER_PROFILE=sandboxuser
        shift
        shift

        1. Criar Repository no ECR
        (Essential) Comando sem Scanning False
        aws ecr create-repository --profile %AWS_CLI_USER_PROFILE% --repository-name %AWS_ECR_REPONAME% --image-tag-mutability MUTABLE

        (Avançado) Comando com Scanning True
        aws ecr create-repository --profile %AWS_CLI_USER_PROFILE% --repository-name %AWS_ECR_REPONAME% --image-scanning-configuration scanOnPush=true --image-tag-mutability MUTABLE
        `
  ]
  -> [Criar uma Docker Tag da Imagem do Docker para corresponder com Repo do ECR
  Windows CMD: `
    set AWS_REGION=us-east-1
    set AWS_ECR_REPONAME=fn-1
    set AWS_ACCOUNT=467742762527
    set AWS_CLI_USER_PROFILE=sandboxuser
    set AWS_ECR_REPONAME=fn-1
    set AWS_ECR_REPOTAG=latest
    shift
    shift
    shift
    shift
    shift
    shift
    docker tag %AWS_ECR_REPONAME%:%AWS_ECR_REPOTAG% %AWS_ACCOUNT%.dkr.ecr.%AWS_REGION%.amazonaws.com/%AWS_ECR_REPONAME%:%AWS_ECR_REPOTAG%
  `
  ]
  -> [Fazer Push da Imagem Docker para o Amazon ECR com o comando com
  Windows CMD: `
    set AWS_ACCOUNT=467742762527
    set AWS_REGION=us-east-1
    set AWS_ECR_REPONAME=fn-1
    set AWS_ECR_REPOTAG=latest
    shift
    shift
    shift
    shift
    docker push %AWS_ACCOUNT%.dkr.ecr.%AWS_REGION%.amazonaws.com/%AWS_ECR_REPONAME%:%AWS_ECR_REPOTAG%
  `
  ]

```

* Erro ao fazer login no ECR sem permissão `ecr:GetAuthorizationToken`
```log
An error occurred (AccessDeniedException) when calling the GetAuthorizationToken operation: User: arn:aws:iam::467742762527:user/iac@sandbox is not authorized to perform: ecr:GetAuthorizationToken on resource: *
Error: Cannot perform an interactive login from a non TTY device
```

* Erro ao adicionar User Policy ao usuário IAM iac@sandbox sem permissão `iam:PutUserPolicy`
```log
An error occurred (AccessDenied) when calling the PutUserPolicy operation: User: arn:aws:iam::467742762527:user/iac@sandbox is not authorized to perform: iam:PutUserPolicy on resource: user iac@sandbox
```

* `fn-1/IAMPutUserPolicy.json`
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": "iam:PutUserPolicy",
        "Resource": "*"
    }
  ]
}
```

* `fn-1/ECRGetAuthorizationTokenPolicy.json`
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": "ecr:GetAuthorizationToken",
        "Resource": "*"
    }
  ]
}
```

### QUESTÕES A SE PENSAR

#### Sandboxuser-A deletando Resources de Sandboxuser

Eu experimentei fazer com que Sandboxuser criasse, por exemplo,
repositório no ECR 'fn-1'. Graças as liberdades de conceder a si permissões 
dadas para integrantes do grupo sandboxusers, Sandboxuser-A (um irmão de sandboxuser) 
acaba podendo excluir o repositório criado por Sandboxuser.

* TENTATIVAS DE SOLUÇÃO:
  - Tentei fazer com que sandboxuser faça um Deny com Condition
    aws:username não seja diferente de seu próprio 'sandboxuser'.

#### Quotas de AWS IAM Users e AWS Root Account

* Existem quotas globais da AWS Root Account que pode atrapalhar
a experiência de desenvolviento dos AWS IAM Users.

* Doc.: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_iam-quotas.html

* TENTATIVAS DE SOLUÇÃO:
  - Tentar confiurar Federated Users. https://aws.amazon.com/pt/identity/federation/?nc1=h_ls
  - Users in AWS Accont: 5000 (para fornecer mais, a AWS considera o uso do temporary security credentials)
    Temporary Security Credentials in IAM: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp.html

    