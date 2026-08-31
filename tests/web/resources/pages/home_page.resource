*** Settings ***
Documentation    Page Object da Página Inicial do Marvel Rivals.
...              URL: https://www.marvelrivals.com/index.html
...              Encapsula seletores e keywords de negócio da home page.
Resource         ../base.resource
Resource         ../components/nav_menu.resource

*** Variables ***
# --- Seletores da Página Inicial ---
${HOME_NAV}           css=.header-nav
${HOME_LOGO}          css=.nav-logo img
${HOME_TITLE}         Marvel Rivals -  The Super Hero Team-based PVP Shooter

*** Keywords ***
Acessar Pagina Inicial
    [Documentation]    Navega para a URL da página inicial e aguarda o carregamento do header.
    New Page    ${HOME_URL}    wait_until=domcontentloaded
    Wait For Elements State    ${HOME_NAV}    visible    timeout=${TIMEOUT}

Validar Titulo Da Pagina
    [Documentation]    Verifica o <title> da página inicial.
    ${title}=    Get Title
    Should Be Equal    ${title}    ${HOME_TITLE}

Validar Que O Logo Esta Visivel
    [Documentation]    Verifica que o logo Marvel Rivals está visível no header.
    Wait For Elements State    ${HOME_LOGO}    visible    timeout=${TIMEOUT}
