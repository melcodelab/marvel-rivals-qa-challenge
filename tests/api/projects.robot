*** Settings ***
Documentation    Suíte de testes de Projetos da API GraphQL (Cenários API-05 a API-10).
Resource         resources/keywords/auth_steps.resource
Resource         resources/keywords/project_steps.resource
Suite Setup      Configurar Token De Autenticacao Valido
Suite Teardown   Encerrar Sessao GraphQL

*** Test Cases ***
API-05: Validar Criacao De Projeto Com Sucesso E Limite Do Plano
    [Documentation]    Garante a criação de um projeto (API-05) e a validação do limite da conta (Cenário de limite).
    [Tags]             api    project    high
    # 1. Cria o projeto
    Enviar Mutation GraphQL Para Criar Projeto    Projeto QA Automacao
    Validar Que O Projeto Foi Criado Com Sucesso
    
    # 2. Tenta criar o segundo projeto (deve bater na cota)
    Enviar Mutation GraphQL Para Criar Projeto    Projeto Cota Excedida
    Validar Que O Status Code Da Resposta E    200
    Validar Que O Limite De Projetos Foi Atingido
    
    [Teardown]         Deletar Projeto Atual

API-06 e API-08: Validar Leitura De Dados De Um Projeto Especifico e Contrato
    [Documentation]    Garante que podemos ler os detalhes de um projeto através de sua PK e validar os campos.
    [Tags]             api    project    high
    Enviar Mutation GraphQL Para Criar Projeto    Projeto Para Leitura
    Validar Que O Projeto Foi Criado Com Sucesso
    
    Enviar Query GraphQL Para Dados Do Projeto    ${CREATED_PROJECT_PK}
    Validar Que O Status Code Da Resposta E    200
    Validar Que A Resposta Nao Contem Erros
    
    [Teardown]         Deletar Projeto Atual

API-07: Validar Exclusao De Um Projeto Existente
    [Documentation]    Garante que a mutation deleteProject exclui o projeto.
    [Tags]             api    project    high
    Enviar Mutation GraphQL Para Criar Projeto    Projeto Para Exclusao
    Validar Que O Projeto Foi Criado Com Sucesso
    
    # O próprio Teardown padrão da Suite foi desenhado para excluir o projeto validando o status HTTP 200.
    [Teardown]         Deletar Projeto Atual

API-08: Enviar Query Com Campos Sintaticamente Invalidos
    [Documentation]    Valida se a engine GraphQL rejeita formatação mal formada.
    [Tags]             api    project    medium
    Enviar Query GraphQL Mal Formada
    Validar Que O Status Code Da Resposta E    400
    Validar Resposta GraphQL Em Caso De Erro Sintatico
