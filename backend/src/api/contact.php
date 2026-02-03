<?php
/**
 * Endpoint: Contact Form
 * Traite l'envoi du formulaire de contact
 * 
 * PROTECTION RATE LIMITING:
 * - Limite à 3 soumissions par IP par heure
 * - Protection double couche (Nginx + PHP)
 */

use App\Services\Database;
use App\Services\Mailer;

// Rate limiting côté PHP (protection supplémentaire)
$clientIp = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$rateLimitFile = sys_get_temp_dir() . '/contact_ratelimit_' . md5($clientIp);

// Vérifier le rate limit (3 messages max par heure par IP)
if (file_exists($rateLimitFile)) {
    $attempts = json_decode(file_get_contents($rateLimitFile), true);
    $oneHourAgo = time() - 3600;
    
    // Nettoyer les tentatives de plus d'1h
    $attempts = array_filter($attempts, fn($t) => $t > $oneHourAgo);
    
    if (count($attempts) >= 3) {
        http_response_code(429);
        header('Content-Type: application/json');
        echo json_encode([
            'success' => false,
            'error' => 'Trop de requêtes. Veuillez réessayer dans 1 heure.'
        ]);
        exit;
    }
    
    $attempts[] = time();
    file_put_contents($rateLimitFile, json_encode($attempts));
} else {
    file_put_contents($rateLimitFile, json_encode([time()]));
}

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
