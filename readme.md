# DevOps FastTrack - Labs

- [DevOps FastTrack - Labs](#devops-fasttrack---labs)
  - [Deploy do Ambiente](#deploy-do-ambiente)
  - [Lab1 - Functions, Api Gateway e Queue](#lab1---functions-api-gateway-e-queue)
  - [Lab2 - Kubernetes](#lab2---kubernetes)
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

## Lab1 - Functions, Api Gateway e Queue

## Lab2 - Kubernetes

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