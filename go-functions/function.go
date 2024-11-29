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

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
)

const (
	smtpServer = "smtp.gmail.com"
	smtpPort   = "587"
	smtpUser   = "board.contato2024@gmail.com"
	smtpPass   = "awytrt6k36yt"
	appName    = "Boards"
)

// Estrutura para o payload recebido no corpo da requisição
type RequestPayload struct {
	UserId string `json:"userId"`
	Role   string `json:"role"`
}

func init() {
	// Registra a função como Callable
	functions.HTTP("AddUserRoleClaim", AddUserRoleClaim)
	functions.HTTP("SendVerificationEmail", SendVerificationEmail)
}

// AddUserRoleClaim is a Callable Cloud Function.
func AddUserRoleClaim(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	log.Printf("Initializing Firebase App")
	// Initialize the Firebase Auth client.
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	// Decodifica o corpo da requisição para Callable Functions
	var payload struct {
		Data RequestPayload `json:"data"`
	}
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	userId := payload.Data.UserId
	role := payload.Data.Role
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

	response := map[string]interface{}{
		"result": fmt.Sprintf("Custom claims successfully defined for user %s", userId),
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(response); err != nil {
		http.Error(w, "Failed to encode response", http.StatusInternalServerError)
		return
	}

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

func SendVerificationEmail(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	log.Printf("Initializing Firebase App")
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	// Decodifica o payload recebido
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
	// Gera o link de verificação pelo Firebase.
	ctx := context.Background()
	verificationLink, err := client.EmailVerificationLinkWithSettings(ctx, email, nil)
	if err != nil {
		return fmt.Errorf("failed to generate verification link: %v", err)
	}

	// Template do e-mail.
	emailTemplate := `
Olá {{.DisplayName}},

Clique no link abaixo para verificar seu endereço de email:

{{.VerificationLink}}

Se você não pediu para verificar este endereço, você pode ignorar este e-mail.

Obrigado,

Equipe da {{.AppName}}
`

	// Dados para o template.
	data := map[string]string{
		"DisplayName":      displayName,
		"VerificationLink": verificationLink,
		"AppName":          appName,
	}

	// Gera o corpo do e-mail.
	body := new(bytes.Buffer)
	tmpl := template.Must(template.New("email").Parse(emailTemplate))
	if err := tmpl.Execute(body, data); err != nil {
		return fmt.Errorf("failed to parse email template: %v", err)
	}

	// Monta a mensagem do e-mail.
	msg := fmt.Sprintf("From: %s\nTo: %s\nSubject: Verify your email address\n\n%s", smtpUser, email, body.String())

	// Configura o cliente SMTP.
	auth := smtp.PlainAuth("", smtpUser, smtpPass, smtpServer)

	// Envia o e-mail.
	err = smtp.SendMail(smtpServer+":"+smtpPort, auth, smtpUser, []string{email}, []byte(msg))
	if err != nil {
		return fmt.Errorf("failed to send email: %v", err)
	}

	log.Printf("Verification email sent to %s", email)
	return nil
}
