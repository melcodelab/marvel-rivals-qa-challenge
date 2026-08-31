*** Settings ***
Documentation    Suíte de testes E2E da Página de Heróis do Marvel Rivals.
...              Cobre os cenários WEB-03 a WEB-06 da Matriz de Rastreabilidade.
...
...              WEB-03: Validar exibição da lista de heróis do jogo
...              WEB-04: Validar abertura do painel More Heroes e seleção de herói
...              WEB-05: Validar abertura e fechamento do modal de Login
...              WEB-06: Validar abertura e fechamento do modal de Download
Resource         resources/pages/heroes_page.resource

Suite Setup      Iniciar Suite De Herois
Suite Teardown   Fechar Navegador
Test Setup       Recarregar Pagina De Herois
Test Teardown    Capturar Screenshot Em Caso De Falha

*** Variables ***
${HERO_REFERENCIA}    ADAM WARLOCK

*** Keywords ***
Iniciar Suite De Herois
    [Documentation]    Abre o navegador e acessa a página de heróis uma vez para a suíte inteira.
    Abrir Navegador
    Acessar Pagina De Herois

Recarregar Pagina De Herois
    [Documentation]    Recarrega a página antes de cada teste para garantir estado limpo
    ...                (evita que modais ou painéis abertos num teste afetem o próximo).
    Reload
    Wait For Elements State    ${HEROES_CONTAINER}    visible    timeout=${TIMEOUT}

*** Test Cases ***
WEB-03: Validar Exibicao Da Lista De Herois Do Jogo
    [Documentation]    Funcionalidade core do portal. Garante que a lista de heróis é renderizada
    ...                corretamente pelo JavaScript da página após o carregamento assíncrono.
    [Tags]             web    heroes    critical    web-03
    Validar Que A Lista De Herois Esta Visivel

WEB-04: Validar Abertura Do Painel More Heroes E Selecao De Heroi
    [Documentation]    Garante que o botão "MORE HEROES" abre o painel de seleção com o grid
    ...                de heróis e que clicar em um herói atualiza as informações exibidas na tela.
    ...                Herói de referência: ${HERO_REFERENCIA}
    [Tags]             web    heroes    high    web-04
    Abrir Painel More Heroes
    Selecionar Heroi Do Painel    ${HERO_REFERENCIA}
    Validar Que O Heroi Foi Atualizado    ${HERO_REFERENCIA}

WEB-05: Validar Abertura E Fechamento Do Modal De Login
    [Documentation]    Fluxo de interação crítico do usuário. Valida que o modal de login abre
    ...                ao clicar em LOG IN e fecha corretamente ao clicar no botão de fechar.
    [Tags]             web    login    high    web-05
    Abrir Modal De Login
    Validar Modal De Login Esta Visivel
    Fechar Modal De Login

WEB-06: Validar Abertura E Fechamento Do Modal De Download
    [Documentation]    Fluxo crítico de aquisição do jogo. Valida que o modal de download abre
    ...                ao clicar em DOWNLOAD e fecha corretamente ao clicar no botão de fechar.
    [Tags]             web    download    high    web-06
    Abrir Modal De Download
    Validar Modal De Download Esta Visivel
    Fechar Modal De Download
