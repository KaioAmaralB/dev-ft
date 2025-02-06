# DevOps FastTrack - Labs

- [DevOps FastTrack - Labs](#devops-fasttrack---labs)
  - [Deploy do Ambiente](#deploy-do-ambiente)
  - [Lab1 - OCI DevOps](#lab1---oci-devops)
  - [Lab2 - Functions, Api Gateway e Queue](#lab2---functions-api-gateway-e-queue)
    - [Functions](#functions)
    - [API Gateway](#api-gateway)
    - [Enviando Menssagem](#enviando-menssagem)
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

1. Após a criação do projeto feito pelo **Resource Manager**, vamos começara criar a nossa esteira. Vamos em **Developer Services > DevOps > Projects** 
   ![menu devops](/images/menu-devops.png)
2. Depois em  **Projects** selecione o projeto criado pelo Resrouce Manager anteriormente
   ![](/images/devops-project.png)
  
3. Ao entrar no nosso projeto da esteira vamos em **Code Repositories** 
   
4. Nessa parte podemos fazer um Mirror de um repo existente, ou podemos criar um do zero. Para facilitar o nosso LAB vamos criar um repositorio no **OCI DevOps** e vamos fazer o git clone então vamos criar o nosso repositorio clicando em **Create Repository**
   
   ![create repository](/images/create-repository.png)
5. Na tela seguinte coloque um nome da sua escolha no repositório e clique em create.
6. Esse Repositório é baseado em GIT e precisa de autenticação para ser utilizado em ambientes remotos.
7. Vamos gerar o **Token de Autenticação** para conseguirmos fazer o git clone e depois o push do código para o repositorio:
   **GUARDE O TOKEN POIS ELE NÃO APARECE NOVAMENTE E SERÁ PRECISO RECIRAR UM NOVO**
   1.  Na console no lado direito clique no ícone do boneco e depois vai no nome do seu profile
   ![](/images/user01.png)
   2.  Dentro do seu profile vai em **Auth Tokens** e depois em **Generate token** essa será seu password para se autenticar no repositorio criado
 ![](/images/user02.png)
8.  Após gerado o token vamos voltar ao **OCI DevOps** ir em **Code Repositories** entrar no repo que criamos no  _passo 4_ ir em **Details** e descendo a tela ir em **HTTPS** 
  ![Repo Clone](/images/git-clone.png)
9.  Após isso em uma nova abra abra o **Code Editor** 
10. ![](/images/code-editor.png)

11. E copie o comando no terminal
    ![](/images/terminal.png)

12. Após isso, ele vai pedir o username e password, na parte de cima do Code Editor. Na tabela abaixo mostra qual como montar o seu username e password (token criado no _passo 5_)
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

13. Depois de feito o git clone de maneira correta vamos fazer o download do repositório do Lab utilizando o seguinte comando no code editor
    
  ```bash
  wget https://github.com/ChristoPedro/dev-ft/archive/refs/heads/main.zip
  ```
14.  Rode o seguinte comando para fazer o unzip
  ```bash
    unzip main.zip -d [DIRETORIO REPO]
  ```

![](/images/unzip.png)

15. Depois vamos fazer os seguintes comandos para fazer o push para o repositorio
  ```bash
    cd DIRETORIO_CRIADO_REPO
    git config --global user.email "EMAIL DO SEU USUARIO"
    git config --global user.name "SEU USUARIO"
    git add .
    git commit -m "novo commit"
    git push
  ```
16. Mais uma vez será necessário entrar com as informações de usuário e senha, os memos utilizados no Git Clone.
    
17. Repo irá ficar assim: 
    ![](/images/devops-repo.png)

18. Agora vamos criar a nossa pipeline, vamos voltar ao **OCI DevOps** -> **Projects** -> **Build Pipelines** e **Create build pipeline** e vamos dar um nome a nossa pipeline de build e depois ir em **Create**
    ![](/images/build01.png)

19. Após a criação vamos adicionar um estágio indo no **Add Stage** , depois vamos dar **Next** e iremos cair nessa tela:
    ![](/images/build02.png)
    ![](/images/build03.png)

20. Na tela de configuração entre com os seguites parametros:
* **Stage Name**: Build_Function
* **Shape, Image e Subnet**: Default
*  **Build_spec file path** : dev-ft-main/build_spec.yaml
  
21.    Após isso vamos **Primary code repository** -> **select** -> **OCI Code Repository** seleciona o repositorio criado e clique em **Select**
    ![select code](/images/primary-code.png)
22. Depois só dar **Add** e já temos o nosso primeiro stage onde iremos buildar a nossa função, no próximo passa vamos fazer um push dessa image até o repositorio
23. Embaixo no stage criado no passa anterior vá no sinal de **+** e depois em **Add Stage** e depois em **Deliver Artifacts** 
    ![](/images/build04.png)
    ![](/images/build05.png)

24. Vamos preencher o nome do **Stage Name** como **delivery_container** e depois vamos criar um artefato novo clicando em **Create Artifact**.
25. No Artefato vamos colocar o nome **Container** ele será do tipo **Container image repository** e no **Artifact source: Container registry** temos que entrar no o caminho do o nosso repositorio seguindo o modelo proposto
    ```bash
      <region-key>.ocir.io/<tenancy-namespace>/<repo-name>:<tag>
    ```
26. A region key podemos encontrar nesse link: https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm
    **Ex: Região de São Paulo é gru, Vinhedo é vpc e Ashburn é iad**
27. Para pegarmos o tenancy namespace vamos até o **profile** boneco no canto da direita e depois em **Tenancy** ira mudar a tela e teremos no **Object storage namespace** o nosso namespace
  ![](/images/namespace.png)
  ![](/images/namespace2.png)

28.  Com essas duas informações e já com o nosso repositorio criado pelo terraform (nome do repo é **function-img**) podemos entrar com as informações, no meu caso ficou assim, basta apenas colocar o namespace de vocês mais o region key (estou usando são paulo)
    ```bash
      [Region-Key].ocir.io/[namespace]/function-img:latest
    ```
29.  Apois isso no **Build config/result artifact name** colocar o **function** ficando assim nossa configuração final
  ![](/images/build06.png)

30. Apoós isso vamos rodar manualmente a nossa esteira para buildar a nossa aplicação e fazer o push no nosso registry
   ![](/images/build07.png)
   ![](/images/start-manual-run2.png)
31. O processo vai iniciar e podemos acompanhar os stages e os logs no lado direito da console.
  ![](/images/build-run1.png)
32. Após alguns minutos teremos esse resultado abaixo:
  

## Lab2 - Functions, Api Gateway e Queue

### Functions
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

### API Gateway

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

### Enviando Menssagem

Execute o comando abaixo substituindo o endpoint pelo do seu Deployment no Api Gateway

```bash
curl --location '[Seu Endpoint]' \
--header 'Content-Type: application/json' \
--data '{"Teste" : "Lab2"}'
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