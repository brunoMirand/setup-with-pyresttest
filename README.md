# Projeto de Testes Funcionais com PyRestTest

## Instalação

1. Clone o repositório:

```sh
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
```

## Uso do Makefile

O `Makefile` fornece várias ações para facilitar a execução dos testes. Abaixo está a lista de ações disponíveis:

### Mostrar Ações Disponíveis

Para listar todas as ações disponíveis no `Makefile`, use:

```sh
  make usage
```

#### Construir a Imagem E2E

Para construir a imagem Docker para testes end-to-end (E2E), use:

```sh
make build-e2e
```

#### Executar Todos os Testes E2E

Para executar todos os testes E2E, use:

```sh
make all-e2e-tests
```

#### Escolher e Executar um Teste E2E Específico

Para escolher e executar um teste E2E específico pelo número do arquivo de teste, use:

```sh
make choose-e2e-test
```

#### Executar um Teste E2E Específico pelo Nome do Arquivo

Para executar um teste E2E específico pelo nome do arquivo, passe o nome do arquivo como variável **TEST_NAME**:

```sh
make specific-e2e-test TEST_NAME=<nome_do_arquivo>
```

#### Estrutura dos Arquivos de Teste

Os arquivos de teste YAML devem ser colocados na pasta tests. O script **entrypoint.sh** gerencia a execução dos testes e possui as seguintes funcionalidades:

1. Carregar Variáveis de Ambiente: Carrega variáveis do arquivo .env.
2. Verificar BASE_URL: Verifica se a variável BASE_URL está definida.
3. Listar Arquivos de Teste: Lista todos os arquivos de teste disponíveis na pasta tests.
4. Executar Testes:
    - **Modo 1**: Executa todos os testes.
    - **Modo 2**: Permite escolher um teste específico da lista.
    - **Modo 3**: Executa um teste específico pelo nome do arquivo, utilizando a variável TEST_NAME.
