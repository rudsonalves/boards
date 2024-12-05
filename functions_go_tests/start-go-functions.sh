#!/bin/bash

set -e  # Sai imediatamente se um comando falhar

# Diretórios e arquivos
SOURCE_DIR="../functions_go"  # Diretório de produção
TARGET_DIR="./functions"  # Diretório de testes
FUNCTION_FILE="function.go"
TEST_GO_DIR="go-tests"

# Função para encerrar processos ao receber sinais de interrupção
function cleanup {
    echo "Encerrando emulador do Firebase e servidor Go..."
    kill $EMULATOR_PID
    kill $GO_PID
    exit 0
}

# Iniciar o emulador sem funções
echo "Iniciando o emulador do Firebase sem funções..."
firebase emulators:start --only auth,firestore,database,storage --import=./emulator_data &
EMULATOR_PID=$!

# Dar um tempo para o emulador iniciar completamente
sleep 10

# Start go-functions tests
cd $TEST_GO_DIR/

# Verifica se o diretório de destino existe, caso contrário cria
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

# Copia o arquivo functions.go para o diretório de testes
cp $SOURCE_DIR/$FUNCTION_FILE $TARGET_DIR/

# Parar qualquer processo que esteja utilizando a porta 5001
if lsof -i:5001 >/dev/null; then
    echo "Encerrando processo na porta 5001..."
    fuser -k 5001/tcp
fi

# Compila e executa o main.go
echo "Executando go-functions localmente na porta 5001..."
go run main.go &
GO_PID=$!

echo "┌────────────────┬────────────────┬─────────────────────────────────┐"
echo "│ Functions      │ 172.0.0.1:5001 │ http://127.0.0.1:4000/functions │"
echo "└────────────────┴────────────────┴─────────────────────────────────┘"

trap cleanup SIGINT SIGTERM

# Esperar pelos processos
wait $EMULATOR_PID
wait $GO_PID