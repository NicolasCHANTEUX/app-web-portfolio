<?php
/**
 * Endpoint: Docker Status
 * Retourne l'état des conteneurs Docker
 */

use App\Services\DockerMonitor;

try {
    $summary = DockerMonitor::getSummary();
    
    echo json_encode([
        'success' => true,
        'data' => $summary
    ], JSON_PRETTY_PRINT);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
