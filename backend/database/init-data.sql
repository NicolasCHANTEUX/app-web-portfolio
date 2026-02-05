-- Remplissage de la table projects avec des données enrichies (Structure "Showroom")
-- Exécuter ce fichier pour peupler la base avec tes vrais projets

-- Nettoyage des données d'exemple
DELETE FROM projects;

-- Projet 1 : Music Streaming App
INSERT INTO projects (
    slug, 
    title, 
    description, 
    content, 
    technologies, 
    github_url, 
    demo_url, 
    image_url, 
    display_order, 
    is_featured, 
    category
) VALUES (
    'music-streaming-app',
    'Streamify (Web & Android)',
    'Alternative à Spotify auto-hébergée avec import YouTube et application Android native.',
    JSON_OBJECT(
        'challenge', 'Créer une expérience de streaming fluide sur mobile et en voiture (via Z-Link), sans dépendre d\'un abonnement tiers, avec gestion de cache hors-ligne.',
        'solution', 'Architecture hybride : une Web App responsive encapsulée en APK via Capacitor pour l\'accès natif, couplée à un script d\'import YouTube (yt-dlp) côté serveur.',
        'architecture', 'Backend PHP MVC sur mesure (sans framework lourd) pour la performance, Frontend Vanilla JS avec chargement infini et API MediaSession pour les contrôles écran verrouillé.'
    ),
    '["PHP 8 MVC", "Capacitor", "MySQL", "TailwindCSS", "yt-dlp"]',
    'https://github.com/NicolasCHANTEUX/streaming-web-app',
    'https://music.chanteaux.duckdns.org',
    '/images/projects/streaming-app.jpg',
    1,
    TRUE,
    'showroom'
);

-- Projet 2 : Portfolio Green-IT (le site actuel)
INSERT INTO projects (
    slug,
    title,
    description,
    content,
    technologies,
    github_url,
    demo_url,
    image_url,
    display_order,
    is_featured,
    category
) VALUES (
    'portfolio-green-it',
    'QG Numérique Green-IT',
    'Vitrine technique éco-conçue hébergée sur du matériel recyclé (< 5 Watts).',
    JSON_OBJECT(
        'challenge', 'Héberger un site performant et moderne sur du vieux matériel recyclé, avec monitoring en temps réel et consommation énergétique minimale.',
        'solution', 'Architecture hybride (Statique + API légère) servie via Cloudflare Tunnel, avec optimisation extrême des ressources.',
        'architecture', 'Frontend Astro (Islands Architecture) générant du statique ultra-léger, Backend PHP 8.2-FPM minimal, Nginx avec cache agressif, conteneurs Alpine Linux optimisés.'
    ),
    '["Astro", "PHP 8.2", "Docker Compose", "Nginx", "MariaDB", "Alpine Linux"]',
    'https://github.com/NicolasCHANTEUX/app-web-portfolio',
    '#',
    '/images/projects/portfolio-arch.jpg',
    2,
    TRUE,
    'showroom'
);

-- Projet 3 : Exemple de projet "Labo" (Script d'automatisation)
INSERT INTO projects (
    slug,
    title,
    description,
    content,
    technologies,
    github_url,
    demo_url,
    image_url,
    display_order,
    is_featured,
    category
) VALUES (
    'docker-backup-automation',
    'Système de Backup Docker',
    'Script automatisé de sauvegarde incrémentale des volumes Docker avec rotation.',
    JSON_OBJECT(
        'challenge', 'Sauvegarder automatiquement tous les volumes Docker sans arrêter les services et sans saturer le disque.',
        'solution', 'Script Bash + Cron utilisant rsync pour les sauvegardes incrémentales, avec compression et rotation automatique (7 jours + 4 semaines).',
        'architecture', 'Architecture simple : Hook systemd pour notification en cas d\'échec, logs centralisés, script modulaire pour ajout facile de nouveaux volumes.'
    ),
    '["Bash", "Docker", "rsync", "systemd"]',
    'https://github.com/NicolasCHANTEUX/docker-backup',
    NULL,
    '/images/projects/backup-script.jpg',
    3,
    FALSE,
    'labo'
);

-- Note : Pense à ajouter les captures d'écran correspondantes dans frontend/public/images/projects/
-- Fichiers à créer :
-- - streaming-app.jpg (montage Desktop + Mobile)
-- - portfolio-arch.jpg (schéma d'architecture)
-- - backup-script.jpg (terminal avec logs du script)
