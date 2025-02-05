# DevOps FastTrack - Labs

- [DevOps FastTrack - Labs](#devops-fasttrack---labs)
  - [Deploy do Ambiente](#deploy-do-ambiente)
  - [Lab1 - OCI DevOps](#lab1---oci-devops)
  - [Lab2 - Functions, Api Gateway e Queue](#lab2---functions-api-gateway-e-queue)
  - [Functions](#functions)
  - [API Gateway](#api-gateway)
  - [Lab3 - Kubernetes](#lab3---kubernetes)
    - [Configurar acesso do Cluster no Cloud Shell](#configurar-acesso-do-cluster-no-cloud-shell)
    - [Buscar informações de Serviços necessários](#buscar-informações-de-serviços-necessários)
    - [Configurar os manifestos e fazer apply no cluster](#configurar-os-manifestos-e-fazer-apply-no-cluster)

## Deploy do Ambiente

O ambiente vai ser todo provisionado via Terraform, vamos utilizar um serviço do OCI chamado **Resource Manager**.

1. Faça o download do código em zip [aqui](https://github.com/ChristoPedro/dev-ft/releases/download/v0.1/terraform.zip)
2. Na console do OCI navegue no menu hamburger em **Developer Services -> Resource Manager -> Stacks**
![Resource Manager](/images/resource-manager-menu.png)
3. Clique em **Create New Stack**
4. Selecion o Arquivo ZIP que foi baixado anteriormente
![Stack](/images/stack-1.png)
5. Confira se o Terraform está na versão **1.5**
6. Na próxima tela selecione o compartment correto e clicar em Next
 ![Stack 2](/images/stack-2.png)
7. **Marcar o Checkbox Run apply**
8. Clicar em create
   ![Apply](/images/apply.png)

## Lab1 - OCI DevOps

1. Após a criação do projeto feito pelo **Resource Manager**, vamos começara criar a nossa esteira. Vamos em **Developer Services** 
2. Depois em  **Projects** 
![](/images/devops-project.png)
  
1. Ao entrar no nosso projeto da esteira vamos em **Code Repositories** 
   
2. Nessa parte podemos fazer um Mirror de um repo existente, ou podemos criar um do zero. Para facilitar o nosso LAB vamos criar um repositorio no **OCI DevOps** e vamos fazer o git clone então vamos criar o nosso repositorio indo no **Create Repository** e entrando com o nome no **Repository Name**


5. Vamos gerar o  **Token de Autenticação** para conseguirmos fazer o git clone e depois o push do código para o reposotorio:
   1.  Na console no lado direito clique no ícone do boneco e depois vai no nome do seu profile
   ![](/images/user01.png)
   2.  Dentro do seu profile vai em **Auth Tokens** e depois em **Generate token** essa será seu password para se autenticar no repositorio criado
 ![](/images/user02.png)

1.  Após gerado o token vamos voltar ao **OCI DevOps** ir em **Code Repositories** entrar no repo que criamos no  _passo 4_ ir em **Details** e descendo a tela ir em **HTTPS** 
   
2.  Após isso em uma nova abra abra o **Code Editor** 
![](/images/code-editor.png)
  Lá no final vamos ter um comando do git clone, copie esse comando e vá até ao **Code Editor**, é um comando que começa assim
      ```bash
    git clone https://devops.....
    ```
 
1.  Após isso em uma nova abra abra o  **Code Editor** 
![](/images/code-editor.png)
1. E copie o comando no terminal
  ![](/images/terminal.png)

1.  Após isso, ele vai pedir o username e password, na tabela abaixo mostra qual será o seu username e password (token criado no _passo 5_)


<table>
  <tr>
    <td>username</td>
    <td>TenancyName/YourUserName</td>
  </tr>
  <tr>
    <td>password</td>
    <td>token</td>
  </tr>
</table>

11. Depois de feito o git clone de maneira correta vamos fazer o upload do arquivo, mas primeiramente vamos fazer o download do mesmo nesse link: https://github.com/ChristoPedro/dev-ft/archive/refs/tags/v0.1.zip
12.  Vá em **File** e depois em **Upload Files** e faço o upload do arquivo que fez o download **dev-ft-0.1.zip**
![](/images/code-editor02.png)


 Rode o seguinte comando para fazer o unzip
  ```bash
    unzip dev-ft-0.1.zip -d DIRETORIO REPO
  ```

![](/images/unzip.png)

13. Depois vamos fazer os seguintes comandos para fazer o push para o repositorio
  ```bash
    cd DIRETORIO_CRIADO_REPO
    git config --global user.email "EMAIL DO SEU USUARIO"
    git add .
    git commit -m "novo commit"
    git push
  ```
14. Repo irá ficar assim: 
    ![](/images/devops-repo.png)

15. Agora vamos criar a nossa pipeline, vamos voltar ao **OCI DevOps** -> **Projects** -> **Build Pipelines** e **Create build pipeline** e vamos dar um nome a nossa pipeline de build e depois ir em **Create**
    ![](/images/build01.png)

16. Após a criação vamos adicionar um estágio indo no **Add Stage** , depois vamos dar **Next** e iremos cair nessa tela:
 ![](/images/build02.png)
 ![](/images/build03.png)

17. Na tela de configuração entre com um nome no **Stage name**, pode deixar as configurações de _Shape_ , _Image_ e _subnet_ padrão, só vamos alterar o **Build_spec file path** que é o caminnhioo até o nosso arquivo de build spec dentro do repositorio onde fizemos o commit e vamos colocar esse caminho:
    ```bash
        dev-ft-0.1/build_spec.yaml
    ```
18. Após isso vamos **Primary code repository** -> **select** -> **OCI Code Repository** seleciona o repositorio criado e clique em **Select**
19. Depois só dar **Add** e já temos o nosso primeiro stage onde iremos buildar a nossa função, no próximo passa vamos fazer um push dessa image até o repositorio
20. Embaixo no stage criado no passa anterior vá no sinal de **+** e depois em **Add Stage** e depois em **Deliver Artifacts** 
 ![](/images/build04.png)
 ![](/images/build05.png)

21. Vamos entrar com um nome no **Stage Name** e depois vamos criar um artefato no ***Create Artifact**
22. No Artefato vamos colocar um nome e será do tipo **Container image repository** e no **Artifact source: Container registry** temos que entrar no o caminho até o nosso repositorio seguindo o modelo proposto
    ```bash
      <region-key>.ocir.io\<tenancy-namespace>\<repo-name>:<tag>
    ```

23. A region key podemos encontrar nesse link: https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
    1.  Ex: Região de São Paulo é gru, Vinhedo é vpc e Ashburn é iad
    2.  Para pegarmos o tenancy namespace vamos até o **profile** boneco no canto da direita e depois em **Tenancy** ira mudar a tela e teremos no **Object storage namespace** o nosso namespace
      ![](/images/namespace.png)
      ![](/images/namespace2.png)

24. Com essas duas informações e já com o nosso repositorio criado pelo terraform (nome do repo é **java-img**) podemos entrar com as informações, no meu caso ficou assim, basta apenas colocar o namespace de vocês mais o region key (estou usando são paulo)
    ```bash
      gru.ocir.io\gr3yho6wbbm5\java-img:latest
    ```
25. Apois isso no **Build config/result artifact name** colocar o **output_fn_network** ficando assim nossa configuração final
![](/images/build06.png)

26. Apoós isso vamos rodar manualmente a nossa esteira para buildar a nossa aplicação e fazer o push no nosso registry
   ![](/images/build07.png)

## Lab2 - Functions, Api Gateway e Queue

## Functions
1. Vamos criar a nossa functions dentro no serviço de **Functions**, assim que a esteira rodar vamos ter uma image dentro do nosso **OCI Registry** , vamos em **Developer Services** -> **Functions** -> **Applications** e vamos entrar no **functionworkshop**
2. Vamos fazer um create function no modelo de **Create from existing image** conforme as imagens abaixo
 ![](/images/fn01.png)
 ![](/images/fn02.png)

3. Após criado vamos pegar as informações no serviço do **Queue** que será o _OCID_ e o _Endpoint_
4. vamos em **Developer Services** -> **Queues** e entrar no **FT-Queue** e copiar essas duas informações, conforme a imagem abaixo: 
  ![](/images/queues.png)

5. Vamos voltar a nossa **Functions** que foi criada no _passo 2_ incluir as seguintes informações no **Configuration** -> **Key/Value** igual na imagem:
   ![](/images/fn03.png)

6. Após isso, vamos criar o nosso deployment no **API Gateway**

## API Gateway

1. Vamos em **Developer Services** -> **API Gateway** -> **API Gateway FT**
2. Vamos em **Deployments** -> **Create deployment**
3. Entre com nome de _endpoint_ e o path _/v1_ e de **Next*
 ![](/images/api01.png)

4. Na parte de autenticação pode deixar no **No Authentication** e dê **Next**
5. No **Route** coloquei no **Path** _/cliete_ e no **Methods** pode colocar _POST_ e _PUT_
6. Já no **Backend Type** coloque _Oracle Functions_ e adicione a Functions que criamos, no final vamos ficar assim:
 ![](/images/api02.png)

7. Após a criação vamos pegar o endpoint no deployment
   ![](/images/api03.png)
8. No meu caso ficou, guarde o endpoint pois usaremos para fazer um PUT da uma mensagem em breve
  ```bash
    https://nxtjmvbllu7tao5uztmhbhsjc4.apigateway.sa-saopaulo-1.oci.customer-oci.com/v1
  ```
Pórem como o nosso route foi o /cliente nosso endpoint ficará assim
  ```bash
    https://nxtjmvbllu7tao5uztmhbhsjc4.apigateway.sa-saopaulo-1.oci.customer-oci.com/v1/cliente
  ```

## Lab3 - Kubernetes

### Configurar acesso do Cluster no Cloud Shell

1. Na console do OCI navegue no menu hamburger em **Developer Services -> Kubernetes Cluter(OKE)**
![Menu OKE](/images/oke-menu.png)
2. Confira o compartment, se está no correto escolhido no Resouce Manager
3. Clique no cluster criado no resource manager e selecione **Access Cluster**
![Acess Cluster](/images/oke-acess.png)
4. Siga o Passo-a-Passo do Pop-up
![Tutorial](/images/oke-acess-2.png)
5. Para testar o acesso o cluster, executar o código abaixo.

```bash
kubectl get nodes
```

```bash
$ kubectl get nodes
NAME          STATUS   ROLES   AGE     VERSION
10.0.254.86   Ready    node    1h      v1.31.1
```

### Buscar informações de Serviços necessários

1. **Autonomous Json**, navegue no menu hamburger **Oracle Database > Autonomous JSON Database**
   
2. Selecione o banco criado pelo Resource Manager vá em **Tool Configuration** e copie o string do banco de dados como na figura abaixo.
![String banco de dados](/images/autonomous-string.png)

3. **Queue**, navegue no menu hamburger **Developer Services -> Queue**
![Queue Menu](/images/queue-menu.png)
4. No menu do lado esquerdo clique em Queues
5. Clique na Queue criado via Resource Manager
6. Copie da Conole o OCID da Fila e o Endpoint
![Queue Info](/images/queue-info.png)
7. **Scret**, navegue no menu hamburger **Identity and Security -> Vault**
![Vault Manu](/images/vault-menu.png)
8. Clique no vault criado pelo Resource Manager
9.  No lado esquerdo selecione Secrets
10. Copie o OCID do Secret criado pelo Resource Manager
![Secret Info](/images/secret-info.png)

### Configurar os manifestos e fazer apply no cluster

1. Criar uma nova pasta no Cloud Shell e acessar a pasta

```bash
mkdir app
cd app
```
2. Downloads dos Manifestos do Kubernetes

```bash
wget https://github.com/ChristoPedro/dev-ft/releases/download/v0.1/config-maps.yaml
wget https://github.com/ChristoPedro/dev-ft/releases/download/v0.1/deployapp.yaml
```
3. Fazer Update do Config Map para passar as informações do Banco e do Queue

- **SERVICE_ENDPOINT:** Endpoint do serviço de Queue
- **QUEUE_ID:** Queue OCID
- **SECRET_ID:** Com a senha do Autonomous Json
- **AUTONOMOUS:** String do Autonomous Json
- **USER:** Admin

4. Fazer o apply do arquivo do Config Map com o comando:

```bash
kubectl apply -f config-maps.yaml
```

5. Fazer o apply do arquivo de Deployment da aplicação

```bash
kubectl apply -f deployapp.yaml
```

6. Validar se os PODs estão rodando correntamente

```bash
kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
queue-reader-5b965f75bc-8p7fw   1/1     Running   0          3m27s
```