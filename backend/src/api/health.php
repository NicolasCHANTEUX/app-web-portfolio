<?php
/**
 * Health check endpoint
 */

use App\Services\Database;

$status = 'ok';
$checks = [];

// Vérifier la connexion DB
try {
    $db = Database::getInstance();
    $db->getConnection()->query('SELECT 1');
    $checks['database'] = 'ok';
} catch (Exception $e) {
    $checks['database'] = 'error';
    $status = 'degraded';
}

// Vérifier l'espace disque
$freeSpace = disk_free_space('/');
$totalSpace = disk_total_space('/');
$percentFree = ($freeSpace / $totalSpace) * 100;

if ($percentFree < 10) {
    $checks['disk'] = 'warning';
    $status = 'degraded';
} else {
    $checks['disk'] = 'ok';
}

$response = [
    'status' => $status,
    'timestamp' => time(),
    'version' => '1.0.0',
    'checks' => $checks
];

http_response_code($status === 'ok' ? 200 : 503);
echo json_encode($response, JSON_PRETTY_PRINT);
