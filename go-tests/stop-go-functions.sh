#!/bin/bash

echo "Encerrando emulador do Firebase e servidor Go..."

# Encerrar o emulador do Firebase
pkill -f "firebase emulators:start"

# Encerrar o servidor Go
pkill -f "go run main.go"

echo "Processos encerrados."
