*** Variables ***
# =======================================================================
# Este arquivo contém as strings puras do GraphQL (Queries e Mutations)
# Isolamos as strings aqui para manter a camada de Keywords limpa e legível.
# =======================================================================

# --- QUERIES (Leitura) ---

# Query para validar se o usuário está autenticado
${QUERY_USER_AUTH}
...    query { user { pk username email } }

# Query para buscar um projeto pelo seu ID (pk)
${QUERY_PROJECT_BY_PK}
...    query { project(pk: PROJECT_PK_PLACEHOLDER) { pk name uuid isArchived } }

# Query mal formatada intencionalmente para teste de validação do GraphQL (API-09)
${QUERY_MALFORMED}
...    query { user { pkkkk_invalid_field } }


# --- MUTATIONS (Escrita) ---

# Mutation para criar um novo projeto
${MUTATION_CREATE_PROJECT}
...    mutation { createProject(input: {name: "PROJECT_NAME_PLACEHOLDER"}) { ok project { pk name } } }

# Mutation para excluir um projeto existente
${MUTATION_DELETE_PROJECT}
...    mutation { deleteProject(input: {pk: PROJECT_PK_PLACEHOLDER}) { ok } }
