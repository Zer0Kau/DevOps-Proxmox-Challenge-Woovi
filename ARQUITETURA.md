## Diagrama de Arquitetura - Desafio Woovi

Este documento descreve a arquitetura do projeto de automação de infraestrutura.

### Visão Geral

O diagrama representa o fluxo de automação e os componentes envolvidos na criação do cluster Kubernetes.

```mermaid
graph TD
    subgraph Ferramentas de Automação
        A[Packer] --> B{Template VM Ubuntu};
        C[Terraform] --> D{Provisionamento de VMs};
        E[Ansible] --> F{Configuração do Cluster};
    end

    subgraph Ambiente Proxmox
        B --> G[VM k8s-1];
        B --> H[VM k8s-2];
        B --> I[VM k8s-3];
        
        D -- clona --> G;
        D -- clona --> H;
        D -- clona --> I;
    end

    subgraph Cluster Kubernetes (MicroK8s)
        F -- instala/configura --> G;
        F -- instala/configura --> H;
        F -- instala/configura --> I;

        G <--> H;
        H <--> I;
        I <--> G;

        subgraph Serviços no Cluster
            J[VictoriaMetrics];
            K[Grafana];
            L[Node Exporter];
            M[MongoDB ReplicaSet];
        end

        F -- deploy --> J;
        F -- deploy --> K;
        F -- deploy --> L;
        F -- deploy --> M;
    end

    style A fill:#E7EEF0,stroke:#02A8EF,stroke-width:2px
    style C fill:#ede7f6,stroke:#5835CC,stroke-width:2px
    style E fill:#cfd8dc,stroke:#1A1918,stroke-width:2px
```

### Componentes

1.  **Packer**: Responsável por criar uma imagem de VM (template) padronizada no Proxmox.
    -   **Entrada**: ISO do Ubuntu 24.04.2 LTS.
    -   **Saída**: Template de VM com `qemu-guest-agent` e outras otimizações.

2.  **Terraform**: Utiliza o template criado pelo Packer para provisionar a infraestrutura.
    -   **Entrada**: Variáveis de configuração (`sekret.tfvars`).
    -   **Saída**: 3 VMs (k8s-1, k8s-2, k8s-3) em execução no Proxmox.

3.  **Ansible**: Configura o software nas VMs provisionadas pelo Terraform.
    -   **Entrada**: Inventário gerado pelo Terraform.
    -   **Saída**:
        -   Cluster Kubernetes (MicroK8s) de alta disponibilidade.
        -   Stack de monitoramento (VictoriaMetrics, Grafana).
        -   Banco de dados (MongoDB ReplicaSet).

### Fluxo de Execução

1.  **Packer**: Cria o template `ubuntu-server` no Proxmox.
2.  **Terraform**: Clona o template 3 vezes para criar as VMs do cluster.
3.  **Ansible**:
    -   Conecta-se às VMs via SSH.
    -   Instala e configura o MicroK8s em todos os nós.
    -   Une os nós para formar um cluster HA.
    -   Implanta os manifestos/charts para os serviços de monitoramento e banco de dados.

Este fluxo garante um processo de implantação totalmente automatizado e repetível.