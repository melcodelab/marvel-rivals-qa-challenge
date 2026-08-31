*** Settings ***
Documentation    Configurações base para os testes E2E (Web) do Marvel Rivals.
...              Utiliza a Browser Library (Playwright) para controlar o navegador.
Library          Browser

*** Variables ***
${HOME_URL}        https://www.marvelrivals.com/index.html
${HEROES_URL}      https://www.marvelrivals.com/heroes/index.html?heroId=0
${BROWSER}         chromium
${HEADLESS}        False
${VIEWPORT_W}      1920
${VIEWPORT_H}      1080
${TIMEOUT}         30s

*** Keywords ***
Abrir Navegador
    [Documentation]    Inicializa o browser Chromium com viewport desktop (1920x1080).
    ...                O viewport e User-Agent forçados evitam o redirecionamento mobile
    ...                detectado no discovery exploratório.
    New Browser    browser=${BROWSER}    headless=${HEADLESS}
    New Context
    ...    viewport={'width': ${VIEWPORT_W}, 'height': ${VIEWPORT_H}}
    ...    userAgent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
    Set Browser Timeout    ${TIMEOUT}

Fechar Navegador
    [Documentation]    Encerra todos os contextos e o browser ao final da suíte.
    Close Browser

Capturar Screenshot Em Caso De Falha
    [Documentation]    Keyword de teardown de teste — tira screenshot somente se o teste falhou.
    Run Keyword If Test Failed    Run Keyword And Ignore Error    Take Screenshot    filename=${TEST NAME}_falha
