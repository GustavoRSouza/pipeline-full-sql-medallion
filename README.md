# Pipeline Full SQL – Medallion Architecture

Este projeto demonstra a estruturação de um pipeline analítico completo utilizando apenas SQL, inspirado na experiência prática que tive no início da minha trajetória com dados, onde precisei organizar bases descentralizadas e transformar planilhas operacionais em um ambiente analítico estruturado.

A proposta aqui foi recriar aquele cenário, mas aplicando conceitos modernos de arquitetura de dados e boas práticas de modelagem.

---

## 🎯 Objetivo do Projeto

Construir um pipeline de dados organizado em camadas (Medallion Architecture) para:

- Garantir rastreabilidade dos dados
- Separar dados brutos de dados tratados
- Criar uma camada analítica pronta para BI
- Demonstrar organização e clareza estrutural usando apenas SQL

O foco não está na visualização, mas na base que sustenta análicas confiáveis.

---

## 🏗 Arquitetura Utilizada

O pipeline segue o padrão **Medallion Architecture**, dividido em três camadas:

### 🥉 Bronze
- Dados brutos
- Sem transformação
- Espelho da fonte original

### 🥈 Silver
- Dados tratados
- Padronização de colunas
- Limpeza e normalização
- Regras de negócio aplicadas

### 🥇 Gold
- Camada analítica
- Tabelas agregadas
- Modelagem dimensional
- Estrutura pronta para consumo por BI

---

## 🔎 Estrutura do Repositório
- 🥉 [Bronze](./bronze) – Dados brutos
- 🥈 [Silver](./silver) – Dados tratados e padronizados
- 🥇 [Gold](./gold) – Camada analítica pronta para BI


Cada pasta contém os scripts SQL responsáveis por construir as respectivas camadas.

---

## 🧠 Conceitos Aplicados

- ETL utilizando apenas SQL
- Separação lógica de camadas
- Modelagem dimensional
- Criação de tabelas analíticas
- Aplicação de regras de negócio
- Organização incremental do pipeline

---

## 📈 Por que esse projeto é relevante?

Durante minha primeira experiência profissional com dados, grande parte das análises eram feitas manualmente em Excel.

Com o tempo, percebi que o verdadeiro ganho não estava apenas em criar dashboards, mas em estruturar corretamente a base de dados.

Este projeto representa:

- A evolução daquela experiência inicial
- A formalização de práticas que antes eram intuitivas
- A aplicação de arquitetura moderna em um cenário realista

---

## 🚀 Próximos Passos (Possíveis Evoluções)

- Versionamento de modelos com dbt
- Implementação de testes de qualidade de dados
- Automatização do pipeline
- Integração com ferramentas de BI

---

## 👨‍💻 Autor

Gustavo Rodrigues de Souza  
Analista de Dados | SQL | Modelagem | BI | ETL