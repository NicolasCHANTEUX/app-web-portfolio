# 🎨 Showroom - Guide d'utilisation

## Vue d'ensemble

La **Showroom** est une vitrine de tes projets organisée selon une approche à 2 niveaux :
- **Niveau 1** (visible immédiatement) : Titre, punchline, tags, image
- **Niveau 2** (accordéon cliquable) : Challenge, Solution, Architecture

Cette approche a été validée par des profils Senior/Lead Tech et est conçue pour :
- ✅ Capter l'attention en 30 secondes (recruteur pressé)
- ✅ Permettre aux curieux d'approfondir (détails techniques)
- ✅ Éviter la sur-ingénierie tout en restant professionnel

---

## 📂 Structure des fichiers

```
app-web-portfolio/
├── backend/
│   ├── database/
│   │   └── seed_projects.sql         # Script SQL pour peupler les projets
│   └── src/api/
│       └── projects.php               # API qui retourne les projets
├── frontend/
│   ├── public/images/projects/        # 📸 Images des projets (à ajouter)
│   │   ├── placeholder.jpg            # Image par défaut
│   │   ├── streaming-app.jpg          # À créer
│   │   ├── portfolio-arch.jpg         # À créer
│   │   └── backup-script.jpg          # À créer
│   ├── src/
│   │   ├── components/
│   │   │   └── ProjectCard.astro      # Composant carte de projet
│   │   └── pages/
│   │       └── showroom.astro         # Page Showroom
└── scripts/
    └── populate-projects.ps1          # Script PowerShell pour peupler la base
```

---

## 🚀 Démarrage rapide

### 1. Lancer l'infrastructure

Si ce n'est pas déjà fait :

```powershell
docker-compose up -d
```

### 2. Peupler la base de données

Exécute le script PowerShell fourni :

```powershell
cd scripts
.\populate-projects.ps1
```

Ou manuellement via Docker :

```bash
docker exec -i <nom_conteneur_mariadb> mysql -u portfolio_user -pportfolio_pass portfolio_db < backend/database/seed_projects.sql
```

### 3. Accéder à la Showroom

Ouvre ton navigateur : **http://localhost/showroom**

---

## 📸 Ajouter des images de projets

### Pourquoi c'est crucial ?

Selon la conversation avec ton mentor, **l'image est l'élément visuel le plus important**. Elle doit montrer :
- L'interface (Desktop + Mobile si pertinent)
- L'architecture (pour les projets infra)
- Le résultat (pour les scripts/outils)

### Recommandations

#### Pour le projet **Streamify (Music Streaming)** :
- Crée un **montage simple** (Canva / Figma / PowerPoint)
- Montre **2 vues côte à côte** :
  - Vue Desktop (bibliothèque musicale)
  - Vue Mobile (lecteur en plein écran)
- Format : 800x450px (16:9) ou 1200x675px
- Nom du fichier : `streaming-app.jpg`

#### Pour le projet **Portfolio Green-IT** :
- Utilise une **capture d'écran du schéma d'architecture**
- Va sur http://localhost/architecture
- Fais une capture d'écran du schéma SVG interactif
- Nom du fichier : `portfolio-arch.jpg`

#### Pour le projet **Backup Script** :
- Capture d'écran d'un **terminal** montrant :
  - Le script en cours d'exécution
  - Les logs de sauvegarde
  - Le message de succès
- Nom du fichier : `backup-script.jpg`

### Où placer les images ?

Place tes images dans :
```
frontend/public/images/projects/
```

Elles seront automatiquement accessibles via :
```
http://localhost/images/projects/ton-image.jpg
```

---

## ✏️ Ajouter ou modifier un projet

### Modifier les projets existants

Édite le fichier `backend/database/seed_projects.sql` :

```sql
INSERT INTO projects (
    slug,                     -- URL-friendly (pas d'espaces)
    title,                    -- Titre affiché
    description,              -- NIVEAU 1 : La punchline (1 phrase)
    content,                  -- NIVEAU 2 : JSON avec challenge/solution/architecture
    technologies,             -- JSON array des technos
    github_url,               -- Lien GitHub
    demo_url,                 -- Lien démo (ou NULL si pas de démo)
    image_url,                -- Chemin vers l'image
    display_order,            -- Ordre d'affichage (1 = premier)
    is_featured,              -- TRUE pour afficher dans "Flagships"
    category                  -- 'showroom' ou 'labo'
) VALUES (
    'mon-nouveau-projet',
    'Mon Nouveau Projet',
    'Une phrase accrocheuse qui résume le projet.',
    JSON_OBJECT(
        'challenge', 'Le problème à résoudre...',
        'solution', 'Comment tu l\'as résolu...',
        'architecture', 'Les choix techniques et infra...'
    ),
    '["React", "Node.js", "Docker"]',
    'https://github.com/NicolasCHANTEUX/mon-projet',
    'https://demo.chanteaux.duckdns.org',
    '/images/projects/mon-projet.jpg',
    4,                        -- Affiché en 4ème position
    FALSE,                    -- Pas dans les Flagships
    'labo'                    -- Catégorie Labo
);
```

Puis ré-exécute le script :
```powershell
.\scripts\populate-projects.ps1
```

---

## 🎯 Conseils de ton mentor (rappel)

### Ce qu'il faut faire ✅
- **Maximum 3-4 projets Flagship** (pas plus, sinon dilution)
- **Punchline de 1 phrase** (scannable en 5 secondes)
- **Wording simple** : "Transcodage adaptatif" plutôt que "Utilisation de ffmpeg avec preset veryslow pour..."
- **Image de qualité** : Montage propre, pas de capture floue
- **Humilité technique** : Plus tu expliques, plus tu t'exposes. Rester sur les principes.

### Ce qu'il faut éviter ❌
- Listes à rallonge de projets "pour remplir"
- Jargon trop technique sans contexte
- Pas d'image ou image de mauvaise qualité
- Accordéon avec trop de texte (limite 3-4 lignes par section)

---

## 🔍 Filtres de catégories

La page Showroom inclut 3 filtres :
- **Tous les Projets** : Affiche tout
- **🚀 Flagships** : Uniquement les projets `is_featured = TRUE` ou `category = 'showroom'`
- **🧪 Labo** : Uniquement les projets `category = 'labo'`

Pour qu'un projet apparaisse dans **Flagships**, il faut :
```sql
is_featured = TRUE
-- OU
category = 'showroom'
```

---

## 📊 Architecture technique

### Frontend (Astro)
- **Page** : `frontend/src/pages/showroom.astro`
- **Composant** : `frontend/src/components/ProjectCard.astro`
- **Fetch API** : Récupère les projets depuis `/api/projects.php`
- **Filtrage** : JavaScript vanilla (pas de framework pour simplicité)

### Backend (PHP)
- **API** : `backend/src/api/projects.php`
- **Base** : Table MariaDB `projects`
- **Format** : JSON avec décodage automatique de `technologies` et `content`

### Accordéon (Détails)
- **Technologie** : Balise HTML native `<details>` et `<summary>`
- **Avantage** : Aucun JavaScript nécessaire, accessible, léger

---

## 🐛 Dépannage

### "Aucun projet à afficher"
→ Lance le script `populate-projects.ps1` pour peupler la base.

### "Impossible de charger les projets"
→ Vérifie que Docker tourne et que l'API est accessible :
```bash
curl http://localhost/api/projects.php
```

### L'image ne s'affiche pas
→ Vérifie que le fichier existe dans `frontend/public/images/projects/`
→ Vérifie que le chemin dans la base commence par `/images/projects/`

### Les filtres ne fonctionnent pas
→ Vérifie que le build a bien été fait : `npm run build`
→ Vérifie la console navigateur pour les erreurs JavaScript

---

## 📝 TODO / Améliorations futures

- [ ] Ajouter les vraies captures d'écran des projets
- [ ] Créer un script pour générer automatiquement des montages d'images
- [ ] Ajouter une page de détail par projet (slug routing)
- [ ] Implémenter un système de tags cliquables
- [ ] Ajouter des animations au scroll (intersection observer)
- [ ] Créer une version "dark mode" optimisée des images

---

**Astuce Pro** 💡 : Si tu veux impressionner, filme un GIF de ton app de streaming en action et remplace l'image statique par le GIF. Les GIF captent beaucoup plus l'attention qu'une image fixe.
