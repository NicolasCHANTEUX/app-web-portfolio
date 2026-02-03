-- Base de données Portfolio
-- Initialisation automatique au premier lancement

CREATE TABLE IF NOT EXISTS contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    user_agent VARCHAR(500),
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    INDEX idx_created_at (created_at),
    INDEX idx_read_at (read_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    slug VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    content LONGTEXT,
    technologies JSON,
    github_url VARCHAR(500),
    demo_url VARCHAR(500),
    image_url VARCHAR(500),
    display_order INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    category ENUM('showroom', 'labo', 'archived') DEFAULT 'labo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_featured (is_featured),
    INDEX idx_order (display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS timeline_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    category VARCHAR(50),
    icon VARCHAR(50),
    image_url VARCHAR(500),
    link_url VARCHAR(500),
    display_order INT DEFAULT 0,
    INDEX idx_date (event_date),
    INDEX idx_order (display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    page_path VARCHAR(500) NOT NULL,
    user_agent VARCHAR(500),
    ip_address VARCHAR(45),
    referer VARCHAR(500),
    visited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_page (page_path),
    INDEX idx_visited (visited_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Données d'exemple pour les projets
INSERT INTO projects (slug, title, description, technologies, category, is_featured, display_order) VALUES
('portfolio-homelab', 'Portfolio Auto-hébergé', 'Infrastructure complète auto-hébergée avec monitoring en temps réel', '["Astro", "PHP", "Docker", "Nginx", "MariaDB"]', 'showroom', TRUE, 1),
('docker-automation', 'Scripts Docker DevOps', 'Collection de scripts d\'automatisation pour environnements Docker', '["Docker", "Bash", "Python"]', 'labo', FALSE, 2),
('api-rest-php', 'API REST Minimaliste', 'API REST légère sans framework en PHP 8', '["PHP 8", "JSON", "REST"]', 'labo', FALSE, 3);

-- Données d'exemple pour la timeline
INSERT INTO timeline_events (title, description, event_date, category, display_order) VALUES
('Premier Raspberry Pi', 'Achat de mon premier Raspberry Pi et début de l\'auto-hébergement', '2020-03-15', 'hardware', 1),
('Apprentissage Docker', 'Début de la containerisation de mes projets', '2021-06-01', 'learning', 2),
('Mise en ligne du Portfolio', 'Déploiement de mon portfolio auto-hébergé', '2026-02-02', 'project', 3);
