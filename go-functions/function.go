package functions

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"net/smtp"
	"strings"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
	"google.golang.org/api/iterator"
)

const (
	smtpServer = "smtp.gmail.com"
	smtpPort   = "587"
	smtpUser   = "board.contato2024@gmail.com"
	smtpPass   = "awytrt6k36yt"
	appName    = "Boards"
)

// Struct for the payload received in the request body
type RequestPayload struct {
	UserId string `json:"userId"`
	Role   string `json:"role"`
}

// Struct for the summarized data model of boardgames
type BGNameModel struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	PublishYear int    `json:"publishYear"`
}

func init() {
	// Register the functions as Callable
	functions.HTTP("AssignDefaultUserRole", AssignDefaultUserRole)
	functions.HTTP("SendVerificationEmail", SendVerificationEmail)
	functions.HTTP("ChangeUserRole", ChangeUserRole)
	functions.HTTP("GetBoardgameNames", GetBoardgameNames)
}

// GetBoardgameNames is a Callable Cloud Function that retrieves
// boardgame names with specific fields.
func GetBoardgameNames(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	client, err := getFirebaseFirestoreClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Firestore client", http.StatusInternalServerError)
		return
	}
	defer client.Close()

	iter := client.Collection("boardgames").Select("name", "publishYear").Documents(ctx)

	var boardgames []BGNameModel

	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			// Log the error and continue returning an empty list if iteration fails
			log.Printf("Error iterating over boardgames collection: %v", err)
			http.Error(w, "Failed to iterate boardgames collection", http.StatusInternalServerError)
			return
		}

		data := doc.Data()

		// Type verification before converting values
		name, ok1 := data["name"].(string)
		publishYear, ok2 := data["publishYear"].(int64)
		if !ok1 || !ok2 {
			log.Printf("Failed to parse document fields for document ID %s", doc.Ref.ID)
			continue
		}

		bg := BGNameModel{
			ID:          doc.Ref.ID,
			Name:        name,
			PublishYear: int(publishYear),
		}
		boardgames = append(boardgames, bg)
	}

	// Log the retrieved data to verify
	log.Printf("Boardgames retrieved: %v", boardgames)

	// Even if the collection is empty, we return an empty JSON list
	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(boardgames); err != nil {
		http.Error(w, "Failed to encode response", http.StatusInternalServerError)
		return
	}

	log.Println("Successfully retrieved boardgame names")
}

// Function to initialize the Firesotre client
func getFirebaseFirestoreClient(ctx context.Context) (*firestore.Client, error) {
	app, err := firebase.NewApp(ctx, nil)
	if err != nil {
		return nil, fmt.Errorf("error initializing app: %v", err)
	}

	client, err := app.Firestore(ctx)
	if err != nil {
		return nil, fmt.Errorf("error getting Firestore client: %v", err)
	}

	return client, nil
}

// AssignDefaultRole is a Callable Cloud Function.
func AssignDefaultUserRole(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	// Initialize the Firebase Auth client.
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	// Get the token of the authenticated user who made the request
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
		http.Error(w, "Missing or invalid Authorization header", http.StatusUnauthorized)
		return
	}

	idToken := strings.TrimPrefix(authHeader, "Bearer ")
	token, err := client.VerifyIDToken(ctx, idToken)
	if err != nil {
		http.Error(w, "Invalid token", http.StatusUnauthorized)
		return
	}

	userId := token.UID
	if userId == "" {
		http.Error(w, "Could not extract user ID from token", http.StatusBadRequest)
		return
	}

	// Set the new user's role to "user"
	role := "user"

	// During initial setup, change to "admin" to create the first administrator
	// role = "admin"

	if err := setUserRole(ctx, client, userId, role); err != nil {
		http.Error(w, "Failed to set custom claims", http.StatusInternalServerError)
		return
	}

	sendSuccessResponse(w, fmt.Sprintf("Custom claims successfully defined for user %s with role %s", userId, role))
}

// ChangeUserRole is a Callable Cloud Function.
func ChangeUserRole(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	payload, err := decodeRequestPayload(r)
	if err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	userId := payload.UserId
	newRole := payload.Role
	if userId == "" || newRole == "" {
		http.Error(w, "Missing userId or role parameter", http.StatusBadRequest)
		return
	}

	// Chack if the requester is admin
	if err := verifyAdminToken(r, client, ctx); err != nil {
		http.Error(w, err.Error(), http.StatusForbidden)
		return
	}

	if err := setUserRole(ctx, client, userId, newRole); err != nil {
		http.Error(w, "Failed to set custom claims", http.StatusInternalServerError)
		return
	}

	sendSuccessResponse(w, fmt.Sprintf("Custom claims successfully updated for user %s to role %s", userId, newRole))
}

// decodeRequestPayload decodes the request payload to get the user data
func decodeRequestPayload(r *http.Request) (*RequestPayload, error) {
	var payload struct {
		Data RequestPayload `json:"data"`
	}
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		return nil, err
	}
	return &payload.Data, nil
}

// setUserRole sets the custom claim "role" to a specific user
func setUserRole(ctx context.Context, client *auth.Client, userId, role string) error {
	claims := map[string]interface{}{
		"role": role,
	}
	log.Printf("Setting custom claims for userId: %s with role: %s", userId, role)
	return client.SetCustomUserClaims(ctx, userId, claims)
}

// verifyAdminToken verifies whetever the authenticated user has
// the "admin" role
func verifyAdminToken(r *http.Request, client *auth.Client, ctx context.Context) error {
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
		return fmt.Errorf("missing or invalid Authorization header")
	}

	idToken := strings.TrimPrefix(authHeader, "Bearer ")
	token, err := client.VerifyIDToken(ctx, idToken)
	if err != nil {
		return fmt.Errorf("invalid token")
	}

	if role, ok := token.Claims["role"]; !ok || role != "admin" {
		return fmt.Errorf("permission denied: only admin can change user roles")
	}
	return nil
}

// sendSuccessResponse sends a success response to the client
func sendSuccessResponse(w http.ResponseWriter, message string) {
	response := map[string]interface{}{
		"result": message,
	}
	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, "Failed to encode response", http.StatusInternalServerError)
	}

	log.Println(message)
}

// getFirebaseAuthClient initializes Firebase and returns an
// authentication client.
func getFirebaseAuthClient(ctx context.Context) (*auth.Client, error) {
	// If you are using Application Default Credentials (ADC), you can
	// omit the option.WithCredentialsFile.
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

func SendVerificationEmail(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	log.Printf("Initializing Firebase App")
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	// Decodes the received payload
	var payload struct {
		Email       string `json:"email"`
		DisplayName string `json:"displayName"`
	}
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	email := payload.Email
	displayName := payload.DisplayName

	if email == "" || displayName == "" {
		http.Error(w, "Missing email or display name", http.StatusBadRequest)
		return
	}

	log.Printf("Sending verification email to: %s", email)
	if err := sendVerificationEmail(client, email, displayName); err != nil {
		log.Printf("Failed to send verification email: %v", err)
		http.Error(w, "Failed to send verification email", http.StatusInternalServerError)
		return
	}

	response := map[string]interface{}{
		"result": fmt.Sprintf("Verification email sent successfully to %s", email),
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, "Failed to encode response", http.StatusInternalServerError)
		return
	}

	log.Printf("Finished SendVerificationEmail function")
}

func sendVerificationEmail(
	client *auth.Client,
	email string,
	displayName string,
) error {
	// Generates the verification link via Firebase.
	ctx := context.Background()
	verificationLink, err := client.EmailVerificationLinkWithSettings(ctx, email, nil)
	if err != nil {
		return fmt.Errorf("failed to generate verification link: %v", err)
	}

	// Email template.
	emailTemplate := `
Olá {{.DisplayName}},

Clique no link abaixo para verificar seu endereço de email:

{{.VerificationLink}}

Se você não pediu para verificar este endereço, você pode ignorar este e-mail.

Obrigado,

Equipe da {{.AppName}}
`

	// Data for the template.
	data := map[string]string{
		"DisplayName":      displayName,
		"VerificationLink": verificationLink,
		"AppName":          appName,
	}

	// Generates the body of the email.
	body := new(bytes.Buffer)
	tmpl := template.Must(template.New("email").Parse(emailTemplate))
	if err := tmpl.Execute(body, data); err != nil {
		return fmt.Errorf("failed to parse email template: %v", err)
	}

	// Assemble the email message.
	msg := fmt.Sprintf("From: %s\nTo: %s\nSubject: Verify your email address\n\n%s", smtpUser, email, body.String())

	// Configure the SMTP client.
	auth := smtp.PlainAuth("", smtpUser, smtpPass, smtpServer)

	// Send the email.
	err = smtp.SendMail(smtpServer+":"+smtpPort, auth, smtpUser, []string{email}, []byte(msg))
	if err != nil {
		return fmt.Errorf("failed to send email: %v", err)
	}

	log.Printf("Verification email sent to %s", email)
	return nil
}
