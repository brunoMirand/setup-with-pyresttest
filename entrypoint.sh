#!/bin/bash

generate_ulid() {
    echo $(uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-26)  # Simula um ULID, corta para 26 caracteres
}

# Carrega variáveis do arquivo .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Verifica se a variável BASE_URL está definida
if [ -z "$BASE_URL" ]; then
    echo -e "\033[0;31mURL não encontrada. Defina a variável BASE_URL.\033[0m"
    exit 1
fi

echo -e "\033[0;32mExecutando testes na BASE_URL: $BASE_URL\033[0m"

# Listar todos os arquivos de teste disponíveis na pasta tests
TEST_FILES=(tests/*.yaml)

# Se não houver arquivos de teste
if [ ${#TEST_FILES[@]} -eq 0 ]; then
    echo -e "\033[0;31mNenhum arquivo de teste encontrado em tests/. Saindo.\033[0m"
    exit 1
fi

# Verifica o argumento de execução
case "$1" in
    1)
        # Executar todos os testes
        echo -e "\033[0;32mExecutando todos os testes...\033[0m"
        for file in "${TEST_FILES[@]}"; do
            ulid=$(generate_ulid)
            tmp_file="${file%.yaml}-temp.yaml"
            # Substitui o placeholder {{hash}} pelo ULID gerado
            sed "s/{{hash}}/$ulid/g" "$file" > "$tmp_file"
            echo -e "\033[0;32mExecutando: $tmp_file\033[0m"
            pyresttest --test="$tmp_file" --url="$BASE_URL"
            rm "$tmp_file"  # Limpa o arquivo temporário
        done
        ;;
    2)
        # Escolher um teste da lista
        echo -e "\033[0;33mEscolha um arquivo de teste para executar:\033[0m"
        for i in "${!TEST_FILES[@]}"; do
            echo "$i: ${TEST_FILES[$i]}"
        done

        read -p "Digite o número do teste que deseja executar: " test_choice
        if [[ "$test_choice" =~ ^[0-9]+$ ]] && [ "$test_choice" -ge 0 ] && [ "$test_choice" -lt "${#TEST_FILES[@]}" ]; then
            ulid=$(generate_ulid)
            tmp_file="${TEST_FILES[$test_choice]%.yaml}-temp.yaml"
            # Substitui o placeholder {{hash}} pelo ULID gerado
            sed "s/{{hash}}/$ulid/g" "${TEST_FILES[$test_choice]}" > "$tmp_file"
            echo -e "\033[0;32mExecutando: $tmp_file\033[0m"
            pyresttest --test="$tmp_file" --url="$BASE_URL"
            rm "$tmp_file"  # Limpa o arquivo temporário
        else
            echo -e "\033[0;31mEscolha inválida. Saindo.\033[0m"
            exit 1
        fi
        ;;
    3)
        # Executar um teste específico pelo nome
        if [ -z "$TEST_NAME" ]; then
            echo -e "\033[0;31mNome do teste não fornecido. Use a variável TEST_NAME.\033[0m"
            exit 1
        fi

        TEST_FILE="tests/${TEST_NAME}.yaml"
        if [ -f "$TEST_FILE" ]; then
            ulid=$(generate_ulid)
            tmp_file="${TEST_FILE%.yaml}-temp.yaml"
            # Substitui o placeholder {{hash}} pelo ULID gerado
            sed "s/{{hash}}/$ulid/g" "$TEST_FILE" > "$tmp_file"
            echo -e "\033[0;32mExecutando teste: $tmp_file\033[0m"
            pyresttest --test="$tmp_file" --url="$BASE_URL"
            rm "$tmp_file"  # Limpa o arquivo temporário
        else
            echo -e "\033[0;31mArquivo de teste $TEST_FILE não encontrado. Saindo.\033[0m"
            exit 1
        fi
        ;;
    *)
        echo -e "\033[0;31mModo de execução inválido. Use 1, 2 ou 3.\033[0m"
        exit 1
        ;;
esac
