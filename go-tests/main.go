package main

import (
	"fmt"
	"log"
	"net/http"

	"go-tests/functions" // Importe o pacote "functions" da subpasta
)

func main() {
	port := "5001"
	http.HandleFunc("/", functions.AddUserRoleClaim) // Registra a função Cloud
	log.Printf("Servidor iniciado na porta %s\n", port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil)) // Inicia o servidor HTTP local
}
