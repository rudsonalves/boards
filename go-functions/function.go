package functions

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
)

// Estrutura para o payload recebido no corpo da requisição
type RequestPayload struct {
	UserID string `json:"userId"`
	Role   string `json:"role"`
}

// AddUserRoleClaim is an HTTP Cloud Function.
func AddUserRoleClaim(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	log.Printf("Initializing Firebase App")
	// Initialize the Firebase Auth client.
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	// Decodifica o corpo da requisição
	var payload RequestPayload
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	userId := payload.UserID
	role := payload.Role
	log.Printf("Starting AddUserRoleClaim function for userId: %s, role: %s", userId, role)

	if userId == "" || role == "" {
		http.Error(w, "Missing userId or role parameter", http.StatusBadRequest)
		return
	}

	claims := map[string]interface{}{
		"role": role,
	}

	log.Printf("Setting custom claims for userId: %s", userId)
	if err := client.SetCustomUserClaims(ctx, userId, claims); err != nil {
		http.Error(w, "Failed to set custom claims", http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, "Custom claims successfully defined for user %s", userId)
	log.Printf("Finished AddUserRoleClaim function")
}

// getFirebaseAuthClient initializes Firebase and returns an authentication client.
func getFirebaseAuthClient(ctx context.Context) (*auth.Client, error) {
	// If you are using Application Default Credentials (ADC), you can omit the option.WithCredentialsFile.
	app, err := firebase.NewApp(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("error initializing app: %v", err)
	}

	client, err := app.Auth(ctx)
	if err != nil {
		return nil, fmt.Errorf("error getting Auth client: %v", err)
	}

	return client, nil
}
