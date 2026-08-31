*** Settings ***
Documentation    Palavras-chave de negócio para fluxos de manipulação de Projetos na API.
Resource         ../base.resource
Resource         ../payloads/graphql_queries.resource
Library          String

*** Keywords ***
Enviar Mutation GraphQL Para Criar Projeto
    [Arguments]        ${nome_projeto}
    [Documentation]    Dispara a mutation GraphQL `createProject` para criar um novo projeto.
    
    # Monta a string da query injetando o nome dinâmico
    ${query}=          Replace String    ${MUTATION_CREATE_PROJECT}    PROJECT_NAME_PLACEHOLDER    ${nome_projeto}
    ${body}=           Create Dictionary    query=${query}
    
    ${response}=       POST On Session    marvel_api    ${GRAPHQL_URI}    json=${body}    expected_status=any
    Set Suite Variable    ${LAST_RESPONSE}    ${response}
    
    # Extrai o PK (ID) do projeto criado caso tenha sucesso, para limpeza (Teardown)
    ${json}=           Set Variable    ${response.json()}
    ${has_data}=       Run Keyword And Return Status    Dictionary Should Contain Key    ${json}    data
    IF  ${has_data}
        ${createProj}=  Set Variable    ${json["data"].get("createProject")}
        IF  ${createProj} != None
            Set Suite Variable    ${CREATED_PROJECT_PK}    ${createProj["project"]["pk"]}
        END
    END

Validar Que O Projeto Foi Criado Com Sucesso
    [Documentation]    Valida se o JSON da resposta contém os dados do projeto criado (ok=true e pk presente).
    ${json}=           Set Variable    ${LAST_RESPONSE.json()}
    Should Be True     ${json["data"]["createProject"]["ok"]}
    ${pk}=             Convert To String    ${json["data"]["createProject"]["project"]["pk"]}
    Should Not Be Empty    ${pk}

Validar Que O Limite De Projetos Foi Atingido
    [Documentation]    Valida o comportamento de cota (Plano Gratuito - API-05).
    ${json}=           Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${json}    errors
    ${error_msg}=      Set Variable    ${json["errors"][0]["message"]}
    Should Contain     ${error_msg}    User has hit their project quota

Deletar Projeto Atual
    [Documentation]    Executa o Teardown de testes limpando o projeto criado para não ferir a cota da conta gratuita.
    ${has_pk}=         Run Keyword And Return Status    Variable Should Exist    ${CREATED_PROJECT_PK}
    Return From Keyword If    not ${has_pk}
    
    ${query}=          Replace String    ${MUTATION_DELETE_PROJECT}    PROJECT_PK_PLACEHOLDER    ${CREATED_PROJECT_PK}
    ${body}=           Create Dictionary    query=${query}
    
    ${response}=       POST On Session    marvel_api    ${GRAPHQL_URI}    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200
    Set Suite Variable    ${CREATED_PROJECT_PK}    ${EMPTY}

Enviar Query GraphQL Para Dados Do Projeto
    [Arguments]        ${project_pk}
    [Documentation]    Dispara a query GraphQL `project` pelo PK.
    ${query}=          Replace String    ${QUERY_PROJECT_BY_PK}    PROJECT_PK_PLACEHOLDER    ${project_pk}
    ${body}=           Create Dictionary    query=${query}
    
    ${response}=       POST On Session    marvel_api    ${GRAPHQL_URI}    json=${body}    expected_status=any
    Set Suite Variable    ${LAST_RESPONSE}    ${response}

Enviar Query GraphQL Mal Formada
    [Documentation]    Envia uma string GraphQL com sintaxe incorreta (API-09).
    ${body}=           Create Dictionary    query=${QUERY_MALFORMED}
    ${response}=       POST On Session    marvel_api    ${GRAPHQL_URI}    json=${body}    expected_status=any
    Set Suite Variable    ${LAST_RESPONSE}    ${response}
    
Validar Resposta GraphQL Em Caso De Erro Sintatico
    [Documentation]    Garante que o GraphQL rejeita a formatação incorreta com 400 Bad Request.
    ${json}=           Set Variable    ${LAST_RESPONSE.json()}
    Dictionary Should Contain Key    ${json}    errors
