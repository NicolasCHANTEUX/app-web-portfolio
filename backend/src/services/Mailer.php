<?php
namespace App\Services;

class Mailer {
    private string $smtpHost;
    private int $smtpPort;
    private string $smtpUser;
    private string $smtpPassword;
    private string $contactEmail;

    public function __construct() {
        $this->smtpHost = getenv('SMTP_HOST') ?: 'smtp.gmail.com';
        $this->smtpPort = (int)(getenv('SMTP_PORT') ?: 587);
        $this->smtpUser = getenv('SMTP_USER') ?: '';
        $this->smtpPassword = getenv('SMTP_PASSWORD') ?: '';
        $this->contactEmail = getenv('CONTACT_EMAIL') ?: $this->smtpUser;
    }

    /**
     * Envoie un email via SMTP
     */
    public function sendContactEmail(string $name, string $email, string $message): bool {
        // Validation basique
        if (empty($name) || empty($email) || empty($message)) {
            throw new \Exception('All fields are required');
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new \Exception('Invalid email format');
        }

        // Protection anti-spam basique
        if (strlen($message) < 10) {
            throw new \Exception('Message too short');
        }

        if (strlen($message) > 5000) {
            throw new \Exception('Message too long');
        }

        // Si SMTP n'est pas configuré, juste logger (mode dev)
        if (empty($this->smtpUser) || empty($this->smtpPassword)) {
            error_log("Contact form (DEV MODE): From {$email} - {$name}: {$message}");
            return true;
        }

        // Envoi via SMTP (simplifié - en production utiliser PHPMailer ou Symfony Mailer)
        $subject = "Nouveau message de {$name}";
        $body = "Nom: {$name}\n";
        $body .= "Email: {$email}\n\n";
        $body .= "Message:\n{$message}\n";

        $headers = "From: {$email}\r\n";
        $headers .= "Reply-To: {$email}\r\n";
        $headers .= "X-Mailer: Portfolio Contact Form\r\n";

        // Note: mail() nécessite un serveur SMTP configuré
        // En production, utiliser une vraie bibliothèque SMTP
        return mail($this->contactEmail, $subject, $body, $headers);
    }
}
