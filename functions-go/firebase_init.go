package main

import (
	"context"
	"fmt"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"google.golang.org/api/option"
)

// getFirebaseAuthClient initializes Firebase if not already initialized and returns an Auth client.
func getFirebaseAuthClient(ctx context.Context) (*auth.Client, error) {
	// Initialize the Firebase app.
	opt := option.WithCredentialsFile("serviceAccountKey.json")
	app, err := firebase.NewApp(ctx, nil, opt)
	if err != nil {
		return nil, fmt.Errorf("error initializing app: %v", err)
	}

	// Get Auth Client
	client, err := app.Auth(ctx)
	if err != nil {
		return nil, fmt.Errorf("error getting Auth client: %v", err)
	}

	return client, nil
}
