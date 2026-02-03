<?php
/**
 * Endpoint: Timeline
 * Retourne les événements de la timeline
 */

use App\Services\Database;

try {
    $db = Database::getInstance();
    
    $events = $db->fetchAll(
        "SELECT * FROM timeline_events ORDER BY event_date DESC, display_order ASC"
    );
    
    echo json_encode([
        'success' => true,
        'data' => $events,
        'count' => count($events)
    ], JSON_PRETTY_PRINT);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
