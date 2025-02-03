# DevOps FastTrack - Labs

- [DevOps FastTrack - Labs](#devops-fasttrack---labs)
  - [Deploy do Ambiente](#deploy-do-ambiente)
  - [Lab1 - OCI DevOps](#lab1---oci-devops)
  - [Lab2 - Functions, Api Gateway e Queue](#lab2---functions-api-gateway-e-queue)
  - [Lab3 - Kubernetes](#lab3---kubernetes)
    - [Configurar acesso do Cluster no Cloud Shell](#configurar-acesso-do-cluster-no-cloud-shell)
    - [Buscar informações de Serviços necessários](#buscar-informações-de-serviços-necessários)
    - [Configurar os manifestos e fazer apply no cluster](#configurar-os-manifestos-e-fazer-apply-no-cluster)

## Deploy do Ambiente

O ambiente vai ser todo provisionado via Terraform, vamos utilizar um serviço do OCI chamado **Resource Manager**.

1. Faça o download do código em zip [aqui](https://github.com/ChristoPedro/dev-ft/releases/download/v0.1/terraform.zip)
2. Na console do OCI navegue no menu hamburger em **Developer Services -> Resource Manager -> Stacks**
3. Clique em **Create New Stack**
4. Selecion o Arquivo ZIP que foi baixado anteriormente
5. Confira se o Terraform está na versão **1.5**
6. Na próxima tela selecione o compartment correto e clicar em Next
7. **Marcar o Checkbox Run apply**
8. Clicar em create

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


## Lab2 - Functions, Api Gateway e Queue

## Lab3 - Kubernetes

### Configurar acesso do Cluster no Cloud Shell

1. Na console do OCI navegue no menu hamburger em **Developer Services -> Kubernetes Cluter(OKE)**
2. Confira o compartment, se está no correto escolhido no Resouce Manager
3. Clique no cluster e selecione **Access Cluster**
4. Siga o Passo-a-Passo do Pop-up
5. Para testar o acesso o cluster, executar o código abaixo.

```bash
kubectl get nodes
```
### Buscar informações de Serviços necessários

1. **Autonomous Json**, navegue no menu hamburger **Oracle Database > Autonomous JSON Database**
   
2. Selecione o banco criado pelo Resource Manager vá em **Tool Configuration** e copie o string do banco de dados como na figura abaixo.

![String banco de dados](/images/autonomous-string.png)

3. **Queue**, navegue no menu hamburger **Developer Services -> Queue**
4. No menu do lado esquerdo clique em Queues
5. Clique na Queue criado via Resource Manager
6. Copie da Conole o OCID da Fila e o Endpoint
7. **Scret**, navegue no menu hamburger **Identity and Security -> Vault**
8. Clique no vault criado pelo Resource Manager
9. No lado esquerdo selecione Secrets
10. Copie o OCID do Secret criado pelo Resource Manager

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