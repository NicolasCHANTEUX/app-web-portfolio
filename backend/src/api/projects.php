<?php
/**
 * Endpoint: Projects
 * Liste tous les projets du portfolio
 */

use App\Services\Database;

try {
    $db = Database::getInstance();
    
    // Paramètre optionnel de filtrage
    $category = $_GET['category'] ?? null;
    $featured = $_GET['featured'] ?? null;
    
    $sql = "SELECT * FROM projects WHERE 1=1";
    $params = [];
    
    if ($category) {
        $sql .= " AND category = :category";
        $params['category'] = $category;
    }
    
    if ($featured !== null) {
        $sql .= " AND is_featured = :featured";
        $params['featured'] = $featured === 'true' ? 1 : 0;
    }
    
    $sql .= " ORDER BY display_order ASC, created_at DESC";
    
    $projects = $db->fetchAll($sql, $params);
    
    // Décoder le JSON des technologies et du contenu enrichi
    foreach ($projects as &$project) {
        $project['technologies'] = json_decode($project['technologies'], true);
        // Décoder le contenu (challenge, solution, architecture)
        if (!empty($project['content'])) {
            $project['details'] = json_decode($project['content'], true);
            unset($project['content']); // On renomme pour plus de clarté côté frontend
        }
    }
    
    echo json_encode([
        'success' => true,
        'data' => $projects,
        'count' => count($projects)
    ], JSON_PRETTY_PRINT);
    
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
