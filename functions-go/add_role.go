package main

import (
	"context"
	"fmt"
	"net/http"
)

// AddUserRoleClaim handles the HTTP request to add a custom role to a user.
func AddUserRoleClaim(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	// Initialize Firebase Auth Client
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	// Parse userId and role from the request parameters
	userID := r.URL.Query().Get("userId")
	role := r.URL.Query().Get("role")

	if userID == "" || role == "" {
		http.Error(w, "Missing userId or role parameter", http.StatusBadRequest)
		return
	}

	// Set custom claims for the user
	claims := map[string]interface{}{
		"role": role,
	}

	if err := client.SetCustomUserClaims(ctx, userID, claims); err != nil {
		http.Error(w, "Failed to set custom claims", http.StatusInternalServerError)
		return
	}

	fmt.Fprintf(w, "Successfully set custom claims for user %s", userID)
}
