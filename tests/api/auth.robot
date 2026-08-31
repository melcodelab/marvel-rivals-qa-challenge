*** Settings ***
Documentation    Suíte de testes de Autenticação da API GraphQL (Cenários API-01 a API-04).
Resource         resources/keywords/auth_steps.resource
Suite Teardown   Encerrar Sessao GraphQL

*** Test Cases ***
API-01: Validar Autenticacao Com Token Valido
    [Documentation]    Garante que um token de acesso válido permite acessar consultas protegidas.
    [Tags]             api    auth    critical
    Configurar Token De Autenticacao Valido
    Enviar Query GraphQL Para Dados Do Usuario
    Validar Que O Status Code Da Resposta E    200
    Validar Que A Resposta Nao Contem Erros

API-02: Validar Autenticacao Com Token Invalido
    [Documentation]    Garante que a API barra acesso quando o token está incorreto (Unauthorized).
    [Tags]             api    auth    critical
    Configurar Token De Autenticacao Invalido
    Enviar Query GraphQL Para Dados Do Usuario
    Validar Que O Status Code Da Resposta E    401

API-03: Validar Requisicao Sem Cabecalho De Autenticacao
    [Documentation]    Garante que o fallback para o PublicQueries recuse consultas não permitidas.
    [Tags]             api    auth    critical
    Configurar Sessao Sem Autenticacao
    Enviar Query GraphQL Para Dados Do Usuario
    Validar Que O Status Code Da Resposta E    400
    Validar Que A Resposta Contem Erro De Validacao Do Schema Publico

API-04: Consultar Dados Do Usuario Autenticado
    [Documentation]    Valida se o schema do usuário atual é retornado corretamente pela API.
    [Tags]             api    auth    high
    Configurar Token De Autenticacao Valido
    Enviar Query GraphQL Para Dados Do Usuario
    Validar Que O Status Code Da Resposta E    200
    Validar Que A Resposta Nao Contem Erros
    Validar Que O Nome Do Usuario E Retornado Com Sucesso
