# Projeto: CI/CD com GitHub Actions para uma Aplicação FastAPI

## Descrição

Este projeto implementa um pipeline de Integração Contínua e Entrega Contínua (CI/CD) para uma aplicação FastAPI simples.  O objetivo é automatizar todo o ciclo: desde um `git push` com alterações no código até ao `deploy` da nova versão da aplicação num cluster Kubernetes local.

A automação utiliza GitHub Actions para o build e publicação de imagens Docker, e o ArgoCD para sincronizar o estado do cluster com os manifestos de configuração definidos num repositório Git (GitOps).

## Arquitetura do Fluxo

O fluxo de automação segue os seguintes passos:

1.  **Commit & Push**: Um programador envia alterações para a branch `main` do repositório da aplicação (`hello-app`).
2.  **GitHub Actions (CI)**: O `push` aciona um workflow do GitHub Actions que:
    * Faz o build de uma nova imagem Docker da aplicação.
    * Publica a imagem no Docker Hub com uma tag única (o hash do commit).
3.  **GitHub Actions (CD)**: O mesmo workflow, num passo seguinte, clona o repositório de manifestos (`hello-manifests`) e atualiza o ficheiro `deployment.yaml` com a nova tag da imagem.
4.  **ArgoCD (GitOps)**: O ArgoCD, que está a monitorizar o repositório de manifestos, deteta a alteração no `deployment.yaml`.
5.  **Sync & Deploy**: O ArgoCD aplica automaticamente as alterações ao cluster Kubernetes, fazendo o `deploy` dos `pods` com a nova versão da aplicação.

## Pré-requisitos

Para replicar este ambiente, é necessário ter as seguintes ferramentas instaladas e configuradas:

*  Git
*  Python 3
*  Docker
*  `kubectl` configurado para aceder a um cluster Kubernetes
*  Um cluster Kubernetes (ex: Docker Desktop com Kubernetes habilitado ou Rancher Desktop)
*  ArgoCD instalado no cluster
*  Uma conta no GitHub
*  Uma conta no Docker Hub com um token de acesso

## Configuração

A configuração inicial requer os seguintes passos manuais:

1.  **Repositórios**: Crie dois repositórios públicos no GitHub:
    * `hello-app`: Para o código da aplicação FastAPI, Dockerfile e o workflow do GitHub Actions.
    * `hello-manifests`: Para os manifestos Kubernetes (`deployment.yaml` e `service.yaml`).

2.  **Segredos do GitHub Actions**: No repositório `hello-app`, navegue até `Settings > Secrets and variables > Actions` e configure os seguintes **Repository secrets**:
    * `DOCKER_USERNAME`: O seu nome de utilizador do Docker Hub.
    * `DOCKER_PASSWORD`: Um token de acesso do Docker Hub com permissões de `Read & Write`.
    * `SSH_PRIVATE_KEY`: Uma chave SSH privada (sem passphrase) para permitir que a pipeline faça `push` para o repositório `hello-manifests`.

3.  **Deploy Key**: No repositório `hello-manifests`, navegue até `Settings > Deploy keys` e adicione a chave pública correspondente à `SSH_PRIVATE_KEY` acima. **Marque a opção "Allow write access"**.

4.  **Credenciais do ArgoCD**: Na interface do ArgoCD, navegue até `Settings > Repositories` e adicione as credenciais do repositório `hello-manifests`, fornecendo o URL SSH e a mesma chave SSH privada do passo 2.

## Como Testar a Pipeline

1.  **Aceder à Aplicação**: Após o primeiro deploy bem-sucedido, use `port-forward` para aceder ao serviço:
    ```bash
    kubectl port-forward svc/hello-app-service 8081:8080
    ```
    A aplicação estará acessível em `http://localhost:8081`.

2.  **Verificar a Automação**:
    * Faça uma alteração no ficheiro `main.py` no repositório `hello-app`.
    * Faça `commit` e `push` para a branch `main`.
    * Aguarde alguns minutos. A pipeline do GitHub Actions será executada, e o ArgoCD irá sincronizar a aplicação.
    * Atualize a página `http://localhost:8081`. A sua alteração deverá estar refletida.
---
## Configuração do Workflow
O workflow do GitHub Actions está definido no ficheiro `.github/workflows/ci.yaml`. Ele é acionado por `push` na branch `main` e executa os seguintes passos:

* **Build da Imagem Docker**: Utiliza o Dockerfile para construir a imagem da aplicação.
* **Login no Docker Hub**: Autentica-se no Docker Hub usando as credenciais fornecidas.
* **Push da Imagem**: Publica a imagem no Docker Hub com uma tag baseada no hash do commit.
* **Clonagem do Repositório de Manifestos**: Clona o repositório `hello-manifests` para atualizar os manifestos Kubernetes.

* **Atualização do Manifesto de Deployment**: Substitui a tag da imagem no `deployment.yaml` pela nova tag da imagem Docker.
* **Commit e Push das Alterações**: Faz commit das alterações no `deployment.yaml` e faz push para o repositório `hello-manifests`.

* **Sincronização com o ArgoCD**: O ArgoCD detecta automaticamente a alteração no repositório de manifestos e aplica as mudanças ao cluster Kubernetes.
---
# CI/CD Pipeline para Aplicação FastAPI
Este repositório contém um pipeline de CI/CD para uma aplicação FastAPI, utilizando GitHub Actions para automação de build e deploy. O objetivo é facilitar o processo de integração contínua e entrega contínua, garantindo que as alterações no código sejam testadas e implantadas automaticamente.
## Estrutura do Repositório
- `.github/workflows/ci.yaml`: Define o workflow de CI/CD que é acionado por pushs na branch `main`.
- `main.py`: Código da aplicação FastAPI.
- `Dockerfile`: Define como a imagem Docker da aplicação é construída.
- `requirements.txt`: Lista as dependências da aplicação.
- `README.md`: Documentação do projeto e instruções de uso.

## resultado final
