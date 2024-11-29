package functions

import (
	"context"
	"fmt"
	"net/http"

	"firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
)

// AddUserRoleClaim is an HTTP Cloud Function.
func AddUserRoleClaim(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	// Initialize the Firebase Auth client.
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	// Get the request parameters.
	userID := r.URL.Query().Get("userId")
	role := r.URL.Query().Get("role")

	if userID == "" || role == "" {
		http.Error(w, "Missing userId or role parameter", http.StatusBadRequest)
		return
	}

	// Define the custom claim for the user.
	claims := map[string]interface{}{
		"role": role,
	}

	if err := client.SetCustomUserClaims(ctx, userID, claims); err != nil {
		http.Error(w, "Failed to set custom claims", http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, "Custom claims successfully defined for user %s", userID)
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
