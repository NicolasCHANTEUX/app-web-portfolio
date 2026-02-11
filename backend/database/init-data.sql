-- Remplissage de la table projects avec des données enrichies (Structure "Showroom")
-- Exécuter ce fichier pour peupler la base avec tes vrais projets

-- Nettoyage des données d'exemple
DELETE FROM projects;

-- Projet 1 : Music Streaming App (Mise à jour basée sur le code source)
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
    'Streamify (Web & PWA)',
    'Plateforme de streaming musical auto-hébergée avec moteur de téléchargement YouTube intégré et interface Mobile-First.',
    JSON_OBJECT(
        'challenge', 'Concevoir un clone de Spotify léger et indépendant, capable de télécharger, convertir et taguer (ID3) de la musique depuis YouTube tout en offrant une lecture fluide sur mobile sans latence.',
        'solution', 'Architecture "Mobile-First" utilisant l\'API MediaSession pour les contrôles natifs (écran verrouillé). Backend intelligent combinant yt-dlp et FFmpeg pour l\'extraction audio et l\'optimisation automatique des pochettes.',
        'architecture', 'Backend PHP 8 en architecture MVC sur-mesure (From Scratch) pour une performance maximale. Frontend en Vanilla JS avec gestion de file d\'attente, cache local et pré-chargement des pistes suivantes (Gapless playback).'
    ),
    '["PHP 8 (Custom MVC)", "TailwindCSS", "Vanilla JS", "MySQL", "yt-dlp", "FFmpeg"]',
    'https://github.com/NicolasCHANTEUX/streaming-web-app',
    'https://music.chanteaux.duckdns.org',
    'public/images/projects/streaming-app.jpg',
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
    '/home/nicolas - Portfolio Green-IT',
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

-- Projet 3 : KayArt (E-commerce Artisan)
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
    'kayart',
    'KayArt - Boutique Artisanale',
    'Plateforme e-commerce sur mesure : gestion de produits, paiements Stripe et facturation automatisée.',
    JSON_OBJECT(
        'challenge', 'Digitaliser l\'activité complète d\'un artisan (commandes, factures, blog) sans dépendre de solutions lourdes (type Shopify). Contrainte forte : hébergement sur matériel recyclé (PC Linux Mint) et gestion performante d\'images lourdes venant de smartphones.',
        'solution', 'Développement d\'une application MVC optimisée avec CodeIgniter 4. Création d\'un pipeline de traitement d\'images robuste (détection EXIF, redimensionnement intelligent) pour éviter les saturations mémoire. Intégration de Stripe via Webhooks pour la sécurité des paiements.',
        'architecture', 'Stack LAMP légère (Linux Mint, Apache, PHP 8.3, MySQL). Génération de PDF natifs pour les factures (dompdf/tcpdf). Architecture modulaire avec séparation stricte Admin/Client et sécurisation des données sensibles (RGPD).'
    ),
    '["CodeIgniter 4", "PHP 8.3", "Stripe API", "MySQL", "TailwindCSS", "Linux Mint"]',
    'https://github.com/NicolasCHANTEUX/app-web-vincent-2',
    'https://kayart.ddns.net/', 
    '/images/projects/kayart.jpg',
    3,
    TRUE,
    'showroom'
);

-- Note : Pense à ajouter les captures d'écran correspondantes dans frontend/public/images/projects/
-- Fichiers à créer :
-- - streaming-app.jpg (montage Desktop + Mobile)
-- - portfolio-arch.jpg (schéma d'architecture)
-- - kayart.jpg (capture de la boutique en ligne)