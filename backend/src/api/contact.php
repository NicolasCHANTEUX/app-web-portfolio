<?php
/**
 * Endpoint: Contact Form
 * Traite l'envoi du formulaire de contact
 */

use App\Services\Database;
use App\Services\Mailer;

try {
    // Récupérer les données POST
    $input = json_decode(file_get_contents('php://input'), true);
    
    $name = trim($input['name'] ?? '');
    $email = trim($input['email'] ?? '');
    $message = trim($input['message'] ?? '');
    
    // Validation
    if (empty($name) || empty($email) || empty($message)) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'error' => 'Tous les champs sont requis'
        ]);
        exit;
    }
    
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'error' => 'Email invalide'
        ]);
        exit;
    }
    
    // Protection anti-spam
    if (strlen($message) < 10) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'error' => 'Le message est trop court'
        ]);
        exit;
    }
    
    // Enregistrer dans la base de données
    $db = Database::getInstance();
    $db->query(
        "INSERT INTO contacts (name, email, message, user_agent, ip_address) VALUES (?, ?, ?, ?, ?)",
        [
            $name,
            $email,
            $message,
            $_SERVER['HTTP_USER_AGENT'] ?? null,
            $_SERVER['REMOTE_ADDR'] ?? null
        ]
    );
    
    // Envoyer l'email
    try {
        $mailer = new Mailer();
        $mailer->sendContactEmail($name, $email, $message);
    } catch (Exception $e) {
        // Logger l'erreur mais ne pas échouer la requête
        error_log("Failed to send email: " . $e->getMessage());
    }
    
    echo json_encode([
        'success' => true,
        'message' => 'Message envoyé avec succès'
    ]);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Erreur serveur: ' . $e->getMessage()
    ]);
}
