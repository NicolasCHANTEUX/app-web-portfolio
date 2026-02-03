<?php
/**
 * Point d'entrée principal de l'API
 * Router simple sans framework
 */

header('Content-Type: application/json');
header('X-Powered-By: Portfolio API');

// CORS (à ajuster en production)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Préflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// Autoloader
require_once dirname(__DIR__) . '/vendor/autoload.php';

// Charger les services
require_once dirname(__DIR__) . '/src/services/Database.php';
require_once dirname(__DIR__) . '/src/services/ServerMonitor.php';
require_once dirname(__DIR__) . '/src/services/DockerMonitor.php';
require_once dirname(__DIR__) . '/src/services/Mailer.php';

// Récupérer la route
$requestUri = $_SERVER['REQUEST_URI'];
$requestMethod = $_SERVER['REQUEST_METHOD'];

// Retirer le préfixe /api/ si présent
$path = preg_replace('#^/api#', '', $requestUri);
$path = strtok($path, '?'); // Retirer les query params

// Router simple
try {
    switch ($path) {
        // Health check
        case '/health':
            require dirname(__DIR__) . '/src/api/health.php';
            break;

        // Status du serveur
        case '/server/status':
            require dirname(__DIR__) . '/src/api/server-status.php';
            break;

        // État des conteneurs Docker
        case '/server/docker':
            require dirname(__DIR__) . '/src/api/docker-status.php';
            break;

        // Liste des projets
        case '/projects':
            require dirname(__DIR__) . '/src/api/projects.php';
            break;

        // Timeline
        case '/timeline':
            require dirname(__DIR__) . '/src/api/timeline.php';
            break;

        // Formulaire de contact
        case '/contact':
            if ($requestMethod !== 'POST') {
                http_response_code(405);
                echo json_encode(['error' => 'Method not allowed']);
                exit;
            }
            require dirname(__DIR__) . '/src/api/contact.php';
            break;

        // Analytics (page view tracking)
        case '/analytics/track':
            if ($requestMethod !== 'POST') {
                http_response_code(405);
                echo json_encode(['error' => 'Method not allowed']);
                exit;
            }
            require dirname(__DIR__) . '/src/api/analytics.php';
            break;

        // Route non trouvée
        default:
            http_response_code(404);
            echo json_encode([
                'error' => 'Endpoint not found',
                'path' => $path,
                'available_endpoints' => [
                    '/health',
                    '/server/status',
                    '/server/docker',
                    '/projects',
                    '/timeline',
                    '/contact (POST)',
                    '/analytics/track (POST)'
                ]
            ]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Internal server error',
        'message' => $e->getMessage()
    ]);
}
