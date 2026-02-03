<?php
/**
 * Endpoint: Server Status
 * Retourne les statistiques du serveur en temps réel
 */

use App\Services\ServerMonitor;

try {
    $stats = ServerMonitor::getStats();
    
    echo json_encode([
        'success' => true,
        'data' => $stats
    ], JSON_PRETTY_PRINT);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
