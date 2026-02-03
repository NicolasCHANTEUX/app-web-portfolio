<?php
/**
 * Endpoint: Analytics Tracking
 * Enregistre une page vue (analytics simple)
 */

use App\Services\Database;

try {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $pagePath = $input['path'] ?? '/';
    $referer = $_SERVER['HTTP_REFERER'] ?? null;
    $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? null;
    $ipAddress = $_SERVER['REMOTE_ADDR'] ?? null;
    
    // Anonymiser l'IP (RGPD friendly)
    if ($ipAddress) {
        $ipParts = explode('.', $ipAddress);
        if (count($ipParts) === 4) {
            $ipParts[3] = '0'; // Masquer le dernier octet
            $ipAddress = implode('.', $ipParts);
        }
    }
    
    $db = Database::getInstance();
    $db->query(
        "INSERT INTO analytics (page_path, user_agent, ip_address, referer) VALUES (?, ?, ?, ?)",
        [$pagePath, $userAgent, $ipAddress, $referer]
    );
    
    http_response_code(204); // No Content
    
} catch (Exception $e) {
    // Ne pas échouer même en cas d'erreur d'analytics
    error_log("Analytics error: " . $e->getMessage());
    http_response_code(204);
}
