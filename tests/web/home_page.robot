*** Settings ***
Documentation    Suíte de testes E2E da Página Inicial do Marvel Rivals.
...              Cobre os cenários WEB-01 e WEB-02 da Matriz de Rastreabilidade.
...
...              WEB-01: Validar carregamento inicial e título da página
...              WEB-02: Validar que o menu Hero exibe as opções corretas
Resource         resources/pages/home_page.resource
Resource         resources/components/nav_menu.resource

Suite Setup      Abrir Navegador
Suite Teardown   Fechar Navegador
Test Teardown    Capturar Screenshot Em Caso De Falha

*** Test Cases ***
WEB-01: Validar Carregamento Inicial E Titulo Da Pagina
    [Documentation]    Smoke test essencial. Garante que o servidor web está respondendo,
    ...                a página principal carrega e o <title> está correto.
    [Tags]             web    smoke    critical    web-01
    Acessar Pagina Inicial
    Validar Titulo Da Pagina
    Validar Que O Logo Esta Visivel

WEB-02: Validar Que O Menu Hero Exibe As Opcoes Corretas
    [Documentation]    Garante que o dropdown do menu HERO exibe as três opções esperadas:
    ...                HEROES, TEAM-UP e HERO HOT LIST.
    [Tags]             web    navigation    high    web-02
    Acessar Pagina Inicial
    Validar Opcoes Do Menu Hero
