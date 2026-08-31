*** Settings ***
Documentation    Page Object da Página de Heróis do Marvel Rivals.
...              URL: https://www.marvelrivals.com/heroes/index.html?heroId=0
...              Encapsula seletores e keywords de negócio da página de heróis.
...
...              Comportamentos especiais identificados no discovery:
...              - Renderização assíncrona via JS: aguardamos o container principal antes de interagir.
...              - Botão More Heroes abre painel de seleção com grid de heróis.
...              - Selecionar um herói no painel atualiza nome, role e imagem na tela principal.
Resource         ../base.resource

*** Variables ***
# --- Container Principal ---
${HEROES_CONTAINER}       css=#wrap.heroesDetails

# --- Botão More Heroes ---
# Renderizado via JS como elemento fixo no lado direito da tela
${MORE_HEROES_BTN}        css=.more-btn

# --- Painel de Seleção de Heróis ---
${HEROES_PANEL}           css=.select-box
${HERO_CARD}              css=.select-list li

# --- Informações do Herói Selecionado (tela principal) ---
${HERO_NAME_DISPLAY}      css=.hero-name
${HERO_ROLE_DISPLAY}      css=.hero-role

# --- Modal de Login ---
${LOGIN_BTN}              css=#roleinfo .btn-login
${LOGIN_MODAL}            css=.pop-login
${LOGIN_CLOSE_BTN}        css=.login-close

# --- Modal de Download ---
${DOWNLOAD_BTN}           css=.go-steam.xlz-btn4
${DOWNLOAD_MODAL}         css=.yxz-pop
${DOWNLOAD_CLOSE_BTN}     css=.yxz-close

*** Keywords ***
Acessar Pagina De Herois
    [Documentation]    Navega para a URL da página de heróis e aguarda o container principal renderizar.
    ...                O container #wrap.heroesDetails é injetado pelo JS — aguardamos sua presença
    ...                para garantir que o JavaScript já executou e a página está interativa.
    New Page    ${HEROES_URL}    wait_until=domcontentloaded
    Wait For Elements State    ${HEROES_CONTAINER}    visible    timeout=${TIMEOUT}

Validar Que A Lista De Herois Esta Visivel
    [Documentation]    Valida que o herói padrão foi renderizado na tela principal.
    ...                Aguarda o elemento de nome do herói ser visível — indicador de que
    ...                o JS assíncrono completou a renderização do conteúdo dinâmico.
    Wait For Elements State    ${HERO_NAME_DISPLAY}    visible    timeout=${TIMEOUT}

# ---- More Heroes ----

Abrir Painel More Heroes
    [Documentation]    Clica no botão More Heroes e aguarda o painel de seleção ficar visível.
    Wait For Elements State    ${MORE_HEROES_BTN}    visible    timeout=${TIMEOUT}
    Evaluate JavaScript    ${MORE_HEROES_BTN}    (elem) => elem.click()
    Wait For Elements State    ${HEROES_PANEL}    visible    timeout=${TIMEOUT}

Selecionar Heroi Do Painel
    [Arguments]    ${hero_index}
    [Documentation]    Seleciona um herói pelo índice (posição data-index) no painel de seleção More Heroes.
    ...                Aguarda que o card do herói esteja visível e clicável antes de interagir.
    ${selector}=    Set Variable    css=.select-list li[data-index="${hero_index}"]
    Wait For Elements State    ${selector}    visible    timeout=${TIMEOUT}
    Click    ${selector}

Validar Que O Heroi Foi Atualizado
    [Arguments]    ${expected_hero_name}
    [Documentation]    Verifica que o nome do herói exibido na tela principal corresponde ao herói selecionado.
    Get Text    ${HERO_NAME_DISPLAY}    contains    ${expected_hero_name}

# ---- Modal de Login ----

Abrir Modal De Login
    [Documentation]    Clica no botão LOG IN e aguarda o modal de login ficar visível.
    Wait For Elements State    ${LOGIN_BTN}    visible    timeout=${TIMEOUT}
    Click    ${LOGIN_BTN}
    Wait For Elements State    ${LOGIN_MODAL}    visible    timeout=${TIMEOUT}

Fechar Modal De Login
    [Documentation]    Clica no botão de fechar do modal de login e aguarda ele desaparecer.
    Wait For Elements State    ${LOGIN_CLOSE_BTN}    visible    timeout=${TIMEOUT}
    Click    ${LOGIN_CLOSE_BTN}
    Wait For Elements State    ${LOGIN_MODAL}    hidden    timeout=${TIMEOUT}

Validar Modal De Login Esta Visivel
    [Documentation]    Garante que o modal de login está na tela com suas opções de autenticação.
    Wait For Elements State    ${LOGIN_MODAL}    visible    timeout=${TIMEOUT}

# ---- Modal de Download ----

Abrir Modal De Download
    [Documentation]    Clica no botão DOWNLOAD e aguarda o modal de download ficar visível.
    Wait For Elements State    ${DOWNLOAD_BTN}    visible    timeout=${TIMEOUT}
    Click    ${DOWNLOAD_BTN}
    Wait For Elements State    ${DOWNLOAD_MODAL}    visible    timeout=${TIMEOUT}

Fechar Modal De Download
    [Documentation]    Clica no botão de fechar do modal de download e aguarda ele desaparecer.
    Wait For Elements State    ${DOWNLOAD_CLOSE_BTN}    visible    timeout=${TIMEOUT}
    Click    ${DOWNLOAD_CLOSE_BTN}
    Wait For Elements State    ${DOWNLOAD_MODAL}    hidden    timeout=${TIMEOUT}

Validar Modal De Download Esta Visivel
    [Documentation]    Garante que o modal de download está na tela com suas opções de plataforma.
    Wait For Elements State    ${DOWNLOAD_MODAL}    visible    timeout=${TIMEOUT}
