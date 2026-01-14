# 📚 API BookStore - Automação de Testes com Karate
Este projeto contém testes de automação para a API Book Store (https://bookstore.demoqa.com) utilizando Karate Framework e IntelliJ IDEA.

## 🎯 Objetivo

Criar uma suíte de testes automatizados para a API BookStore usando Karate DSL, cobrindo endpoints Account (para gerar token) e BookStore (GET, POST, DELETE, PUT), com cenários de sucesso e falha.

## 📋 Pré-requisitos
Java 11 ou superior

Maven 3.6 ou superior

IntelliJ IDEA (recomendado) ou outra IDE

Conexão com internet para acessar a API

Git para clonar o repositório

## 📋 Cenários Implementados:

# Cenários Implementados

O arquivo GetUsuarios.feature contém 17 cenários organizados em:

1. Account Endpoints (Usuários e Autenticação)

   ✅ Criação de usuário com sucesso

   ✅ Geração de token de autenticação

   ✅ Validação de prevenção de duplicidade

   ✅ Exclusão de conta de usuário
   

2. BookStore Endpoints (Gerenciamento de Livros)

   ✅ Listagem de todos os livros disponíveis

   ✅ Busca de livro específico por ISBN

   ✅ Validação de falha com ISBN inexistente

   ✅ Adição de livro à coleção do usuário

   ✅ Atualização de ISBN de livro

   ✅ Remoção de livro da coleção

   ✅ Testes com múltiplos livros

## 🛠️ Tecnologias Utilizadas
    Java 8+

    Karate DSL - Framework de automação de APIs

    Maven - Gerenciamento de dependências

    JUnit - Execução de testes

    Git - Sistema de controle de versão

    GitHub - Plataforma que hospeda repositórios Git


## 🚀 Como Executar os Testes
1. Clone o repositório
https://github.com/dawidsongru/bookstoreAPI.git

2. Execute todos os testes


## Opção 1: Via Maven Command Line bash
Executar todos os testes:
mvn test

Executar com relatório detalhado:
mvn test -Dtest=GetusuarioTestRunner

Executar com tags específicas (se configuradas):
mvn test -Dkarate.options="--tags=@smoke"


## Opção 2: Via IntelliJ IDEA
Abra o projeto no IntelliJ IDEA

Navegue até GetusuarioTestRunner.java
Clique com o botão direito na classe
Selecione "Run 'GetusuarioTestRunner'"
Ou use o atalho: Ctrl+Shift+F10


## Opção 3: Executar Feature File diretamente
Abra o arquivo GetUsuarios.feature
Clique no ícone de play (▶) ao lado do nome do cenário
ou clique com botão direito e selecione "Run Feature"


## Padrões de Nomenclatura
Scenario: Teste individual com descrição clara

Background: Configurações comuns executadas antes de cada cenário

def: Definição de variáveis e funções

Given/When/Then: Padrão BDD (Behavior Driven Development)

## Nota:
Este projeto é para fins de demonstração e teste da API pública Book Store.

Certifique-se de respeitar os termos de uso da API durante a execução dos testes.








