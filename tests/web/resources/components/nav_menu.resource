*** Settings ***
Documentation    Componente reutilizável: menu de navegação superior (header-nav).
...              Compartilhado entre a página inicial e a página de heróis.
Resource         ../base.resource

*** Variables ***
# --- Seletores do Menu de Navegação ---
${NAV_HERO_MENU}          css=.nav5
${NAV_HERO_DROPDOWN}      css=.nav5-select
${NAV_OPTION_HEROES}      css=.nav5-select .option[data-link="heroes/index.html?heroId=0"]
${NAV_OPTION_TEAMUP}      css=.nav5-select .option[data-link="heroes/teamup.html"]
${NAV_OPTION_HOTLIST}     css=.nav5-select .option[data-link="heroes_data/"]

*** Keywords ***
Abrir Dropdown Do Menu Hero
    [Documentation]    Passa o mouse sobre o item HERO do menu para revelar o dropdown.
    Hover              ${NAV_HERO_MENU}
    Wait For Elements State    ${NAV_HERO_DROPDOWN}    visible    timeout=${TIMEOUT}

Validar Opcoes Do Menu Hero
    [Documentation]    Verifica que as três opções esperadas estão visíveis no dropdown HERO:
    ...                HEROES, TEAM-UP e HERO HOT LIST.
    Abrir Dropdown Do Menu Hero
    Wait For Elements State    ${NAV_OPTION_HEROES}      visible    timeout=${TIMEOUT}
    Wait For Elements State    ${NAV_OPTION_TEAMUP}      visible    timeout=${TIMEOUT}
    Wait For Elements State    ${NAV_OPTION_HOTLIST}     visible    timeout=${TIMEOUT}
    ${heroes_text}=    Get Text    ${NAV_OPTION_HEROES}
    ${teamup_text}=    Get Text    ${NAV_OPTION_TEAMUP}
    ${hotlist_text}=   Get Text    ${NAV_OPTION_HOTLIST}
    Should Be Equal    ${heroes_text}     HEROES
    Should Be Equal    ${teamup_text}     TEAM-UP
    Should Be Equal    ${hotlist_text}    HERO HOT LIST
