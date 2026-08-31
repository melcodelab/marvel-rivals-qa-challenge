*** Settings ***
Documentation    Palavras-chave de negócio (BDD-like) para fluxos de autenticação da API.
Resource         ../base.resource
Resource         ../payloads/graphql_queries.resource

*** Keywords ***
Configurar Token De Autenticacao Valido
    [Documentation]    Configura a sessão global injetando o token válido do ambiente.
    Criar Sessao GraphQL

Configurar Token De Autenticacao Invalido
    [Documentation]    Configura uma sessão global injetando um token fake (inválido).
    ${headers}=        Create Dictionary
    ...                Authorization=Bearer INVALID_TOKEN_123
    ...                Content-Type=application/json
    Create Session     marvel_api    ${BASE_URL}    headers=${headers}    verify=True

Configurar Sessao Sem Autenticacao
    [Documentation]    Configura uma sessão global sem passar o Header de Authorization.
    ${headers}=        Create Dictionary
    ...                Content-Type=application/json
    Create Session     marvel_api    ${BASE_URL}    headers=${headers}    verify=True

Enviar Query GraphQL Para Dados Do Usuario
    [Documentation]    Dispara a query GraphQL `user` para obter os dados do usuário autenticado.
    ${body}=           Create Dictionary    query=${QUERY_USER_AUTH}
    
    # expected_status=any garante que o Robot não falhe a suíte se receber um 400/401, permitindo a validação.
    ${response}=       POST On Session    marvel_api    ${GRAPHQL_URI}    json=${body}    expected_status=any
    Set Suite Variable    ${LAST_RESPONSE}    ${response}

Validar Que O Status Code Da Resposta E
    [Arguments]        ${expected_status_code}
    [Documentation]    Valida o status HTTP da última requisição.
    Should Be Equal As Strings    ${LAST_RESPONSE.status_code}    ${expected_status_code}

Validar Que A Resposta Nao Contem Erros
    [Documentation]    Valida que o nó `errors` não existe no JSON de resposta.
    ${json}=           Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Not Contain Key    ${json}    errors

Validar Que A Resposta Contem Erro De Validacao Do Schema Publico
    [Documentation]    Valida a mensagem de erro específica de requisição não autenticada (API-03).
    ${json}=           Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${json}    errors
    ${error_msg}=      Set Variable    ${json["errors"][0]["message"]}
    Should Contain     ${error_msg}    Cannot query field "user" on type "PublicQueries"

Validar Que O Nome Do Usuario E Retornado Com Sucesso
    [Documentation]    Valida se o JSON da resposta contém o dicionário do user (API-04).
    ${json}=           Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${json}    data
    Dictionary Should Contain Key    ${json["data"]}    user
    Should Not Be Empty    ${json["data"]["user"]["username"]}
