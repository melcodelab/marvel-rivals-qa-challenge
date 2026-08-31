*** Settings ***
Documentation    Configurações base para os testes de API (GraphQL) da MarvelApp.
Library          RequestsLibrary
Library          Collections
Library          OperatingSystem

*** Variables ***
${BASE_URL}      https://api.marvelapp.com
${GRAPHQL_URI}   /graphql/

*** Keywords ***
Criar Sessao GraphQL
    [Documentation]    Inicia uma sessão HTTP com a API da MarvelApp e injeta o Token de autorização.
    # Lê o token da variável de ambiente (garantindo que não vaze credencial)
    ${token}=          Get Environment Variable    MARVEL_API_TOKEN    default=
    Should Not Be Empty    ${token}    msg=A variável de ambiente MARVEL_API_TOKEN não foi configurada!
    
    ${headers}=        Create Dictionary
    ...                Authorization=Bearer ${token}
    ...                Content-Type=application/json
    
    Create Session     marvel_api    ${BASE_URL}    headers=${headers}    verify=True

Encerrar Sessao GraphQL
    [Documentation]    Encerra a sessão HTTP atual.
    Delete All Sessions
