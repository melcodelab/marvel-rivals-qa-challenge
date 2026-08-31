# 🧪 Marvel - Prova Técnica (QA Pleno)

Bem-vindo(a) ao repositório de automação de testes do **Marvel**. Este projeto foi desenvolvido para demonstrar práticas modernas de engenharia de qualidade aplicadas tanto no teste de APIs baseadas em GraphQL quanto em validações funcionais de frontend responsivo.

O projeto utiliza o **Robot Framework** integrado com a biblioteca **Browser (Playwright)** para testes de interface e **RequestsLibrary** para testes de API.

---

## 📁 Estrutura da Documentação do Projeto

Abaixo estão os links para as documentações detalhadas do planejamento, análises de risco e mapeamentos de testes elaborados para este desafio:

1. 🕵️‍♂️ **[Testes Exploratórios - API GraphQL](docs/1.%20[%20Discovery%20]%20Testes%20Explorat%C3%B3rios%20API.md)**
   * Estudo inicial da API GraphQL, detalhamento de chamadas `user`, `createProject`, `deleteProject`, comportamentos de tokens válidos e tratamento de erros sob o schema fallback `PublicQueries`.

2. 🖥️ **[Testes Exploratórios - Frontend / Web](docs/2.%20[%20Discovery%20]%20Testes%20Explorat%C3%B3rios%20WEB.md)**
   * Mapeamento de seletores CSS, fluxos de login/download e regras de responsividade com redirecionamento de User-Agent.

3. 🗺️ **[Planejamento e Estratégia de Testes](docs/3.%20[%20Documenta%C3%A7%C3%A3o%20]%20Planejamento%20e%20Estrat%C3%A9gia%20de%20Testes.md)**
   * Metas de qualidade, a estratégia baseada na pirâmide de testes, matriz de severidade/riscos e definição dos Quality Gates para a esteira de CI/CD.

4. 📊 **[Matriz de Cenários de Testes](docs/4.%20[%20Documenta%C3%A7%C3%A3o%20]%20Matriz%20de%20Cen%C3%A1rios.md)**
   * Tabela de rastreabilidade contendo os 28 cenários identificados nas camadas de API e E2E, com priorizações e justificativas de automação.

5. 🐛 **[Registro de Bugs e Inconsistências](docs/5.%20[%20Documenta%C3%A7%C3%A3o%20]%20Registro%20de%20Bugs.md)**
   * Documentação de inconsistências de design e comportamento identificadas no backend e no frontend durante os testes manuais.

6. 📅 **[Implementação de Schedules no GitHub Actions](docs/6.%20[%20Discovery%20]%20Implementa%C3%A7%C3%A3o%20de%20Schedules%20-%20Github%20Actions.md)**
   * Detalhamento técnico da montagem da esteira de CI/CD com execuções agendadas (Cron) e injeção segura de segredos.

---

## 🏗️ Organização do Código de Automação

Os testes estão organizados em diretórios específicos visando a manutenibilidade:

```
tests/
├── api/                            # Suíte de API GraphQL
│   ├── heroes/                     # Casos de teste de negócio
│   └── resources/                  # Keywords e variáveis reutilizáveis da API
│
└── web/                            # Suíte de Frontend
    ├── heroes/                     # Casos de teste de interface
    └── resources/                  # Seletores e Keywords customizadas de UI
```

---

## ⚙️ Instruções de Instalação e Execução (Local)

### Pré-requisitos
* Python 3.10 ou superior instalado.
* Node.js (necessário para a Browser Library do Robot Framework).

### Passo a Passo

1. **Configurar Ambiente Virtual (Virtualenv)**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

2. **Instalar Dependências**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Instalar Dependências de Browsers (Playwright)**:
   ```bash
   rfbrowser clean-install
   ```

4. **Configurar Variáveis de Ambiente**:
   * Duplique o arquivo `.env.example` e renomeie para `.env`.
   * Substitua o valor de `MARVEL_API_TOKEN` com o seu token de desenvolvedor gerado na MarvelApp.

5. **Executar a Suíte de Testes**:
   * Executar todos os testes:
     ```bash
     robot -d results tests/
     ```
   * Executar apenas testes de API:
     ```bash
     robot -d results tests/api/
     ```
   * Executar apenas testes de UI/E2E:
     ```bash
     robot -d results tests/web/
     ```
