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
	functions.HTTP("AssignDefaultUserRole", AssignDefaultUserRole)
	functions.HTTP("SendVerificationEmail", SendVerificationEmail)
	functions.HTTP("ChangeUserRoleClaim", ChangeUserRoleClaim)
}

// AssignDefaultRole is a Callable Cloud Function.
func AssignDefaultUserRole(w http.ResponseWriter, r *http.Request) {
	ctx := context.Background()

	log.Printf("Initializing Firebase App")
	// Initialize the Firebase Auth client.
	client, err := getFirebaseAuthClient(ctx)
	if err != nil {
		http.Error(w, "Failed to initialize Auth client", http.StatusInternalServerError)
		return
	}

	// Obter o token do usuário autenticado que fez a requisição
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

	// Define o papel do novo usuário como "user"
	role := "user"

	// Durante a configuração inicial, altere para "admin" para criar o primeiro administrador
	// role = "admin"

	if err := setUserRole(ctx, client, userId, role); err != nil {
		http.Error(w, "Failed to set custom claims", http.StatusInternalServerError)
		return
	}

	sendSuccessResponse(w, fmt.Sprintf("Custom claims successfully defined for user %s with role %s", userId, role))
}

// ChangeUserRoleClaim is a Callable Cloud Function.
func ChangeUserRoleClaim(w http.ResponseWriter, r *http.Request) {
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

	// Verifica se o solicitante é um admin
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

// decodeRequestPayload decodifica o payload da requisição para obter os dados do usuário
func decodeRequestPayload(r *http.Request) (*RequestPayload, error) {
	var payload struct {
		Data RequestPayload `json:"data"`
	}
	if err := json.NewDecoder(r.Body).Decode(&payload); err != nil {
		return nil, err
	}
	return &payload.Data, nil
}

// setUserRole define o custom claim "role" para um usuário específico
func setUserRole(ctx context.Context, client *auth.Client, userId, role string) error {
	claims := map[string]interface{}{
		"role": role,
	}
	log.Printf("Setting custom claims for userId: %s with role: %s", userId, role)
	return client.SetCustomUserClaims(ctx, userId, claims)
}

// verifyAdminToken verifica se o usuário autenticado possui o papel "admin"
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

// sendSuccessResponse envia uma resposta de sucesso para o cliente
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
