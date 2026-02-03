# 🚀 Portfolio - QG Numérique

[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker)](https://www.docker.com/)
[![Astro](https://img.shields.io/badge/Astro-5.17.1-FF5D01?logo=astro)](https://astro.build/)
[![PHP](https://img.shields.io/badge/PHP-8.2-777BB4?logo=php)](https://www.php.net/)
[![MariaDB](https://img.shields.io/badge/MariaDB-10.11-003545?logo=mariadb)](https://mariadb.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Un portfolio auto-hébergé avec **architecture découplée (Headless)** démontrant expertise technique en développement full-stack et DevOps.

> 📚 **Documentation complète** :  
> - [🔧 Architecture Technique](ARCHITECTURE.md) - Détails techniques, flux de données, monitoring  
> - [🔒 Notes de Sécurité](SECURITY.md) - Justification des choix, bonnes pratiques  

---

## 🏗️ Architecture

### Stack Technique
- **Frontend**: Astro 5.17.1 (HTML statique avec Islands Architecture)
- **Backend**: PHP 8.2-FPM Alpine (API REST sans framework)
- **Base de données**: MariaDB 10.11
- **Reverse Proxy**: Nginx Alpine
- **Orchestration**: Docker Compose
- **Hébergement**: Auto-hébergé (homelab)

### Principe de fonctionnement
```
Internet → Nginx (Port 80) → {
    / → Frontend (HTML statique pré-généré)
    /api/* → Backend PHP-FPM (FastCGI)
}
                ↓
           MariaDB (BDD)
```

**Avantages de cette architecture :**
✅ Performance maximale (frontend statique)  
✅ Consommation minimale (PHP léger, pas de framework lourd)  
✅ Scalabilité facile (backend API séparé)  
✅ SEO optimal (HTML pré-rendu)  

---

## 📁 Structure du projet

```
portfolio/
├── docker-compose.yml      # Orchestration des services
├── .env                    # Variables d'environnement (à créer)
│
├── frontend/               # Site statique Astro
│   ├── src/
│   │   ├── pages/         # Pages du site
│   │   ├── components/    # Composants réutilisables
│   │   ├── layouts/       # Templates de mise en page
│   │   └── assets/        # Images, CSS, JS
│   └── dist/              # Build de production
│
├── backend/               # API PHP
│   ├── src/
│   │   ├── api/          # Endpoints API
│   │   ├── services/     # Logique métier
│   │   └── models/       # Modèles de données
│   ├── database/
│   │   └── init.sql      # Script d'initialisation DB
│   └── Dockerfile
│
└── nginx/                # Configuration serveur web
    ├── nginx.conf        # Config principale
    └── conf.d/           # Configs spécifiques
        └── default.conf
```

## 🎯 Fonctionnalités

### 1. La Dimension Narrative
- **Timeline interactive**: Parcours professionnel chronologique
- **Stack contextuelle**: Technologies avec liens vers projets associés

### 2. La Dimension HomeLab
- **Dashboard live**: Métriques serveur en temps réel (CPU, RAM, Uptime)
- **Architecture réseau**: Schéma SVG interactif de l'infrastructure
- **Status page**: Journal des incidents et résolutions

### 3. La Dimension Expérimentale
- **Showroom**: 3-4 projets phares avec case studies détaillés
- **Le Labo**: Petits scripts et expérimentations
- **Digital Garden**: Notes techniques type TIL (Today I Learned)

### 4. La Dimension Interactive
- **Terminal Easter Egg**: Console interactive (Ctrl+T)
- **Mode Jour/Nuit**: Synchronisé avec l'heure du serveur

## 🚀 Installation

### Prérequis
- Docker & Docker Compose installés
- Node.js 20+ (pour le build frontend)
- Un nom de domaine (ou `localhost` pour test local)

### 1. Cloner et configurer

```powershell
# Cloner le projet (si Git)
git clone <votre-repo>
cd app-web-portfolio

# Configurer l'environnement
cp .env.example .env
# Éditer .env avec vos vraies valeurs
```

### 2. Construire le frontend

```powershell
cd frontend
npm install
npm run build
cd ..
```

### 3. Lancer l'infrastructure

```powershell
# Production
docker-compose up -d

# Développement (avec hot-reload Astro)
docker-compose --profile dev up
```

### 4. Vérifier

- Frontend: http://localhost
- API Health: http://localhost/api/health
- Dashboard stats: http://localhost/api/server/status

## 🔧 Développement

### Frontend (Astro)

```powershell
cd frontend

# Dev avec hot-reload
npm run dev

# Build pour production
npm run build

# Preview du build
npm run preview
```

### Backend (PHP)

```powershell
# Logs de l'API
docker logs -f portfolio_backend

# Entrer dans le conteneur
docker exec -it portfolio_backend sh

# Redémarrer après modification
docker-compose restart backend
```

### Base de données

```powershell
# Se connecter à MariaDB
docker exec -it portfolio_mariadb mysql -u portfolio_user -p

# Backup
docker exec portfolio_mariadb mysqldump -u portfolio_user -p portfolio_db > backup.sql

# Restore
docker exec -i portfolio_mariadb mysql -u portfolio_user -p portfolio_db < backup.sql
```

## 🌐 Mise en ligne avec Cloudflare Tunnel

### Pourquoi Cloudflare Tunnel ?
- ✅ Pas besoin d'ouvrir de ports sur votre box
- ✅ SSL automatique
- ✅ Protection DDoS gratuite
- ✅ Cache global

### Installation

```powershell
# 1. Installer cloudflared
# Télécharger: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/

# 2. S'authentifier
cloudflared tunnel login

# 3. Créer un tunnel
cloudflared tunnel create portfolio-tunnel

# 4. Router le domaine
cloudflared tunnel route dns portfolio-tunnel votredomaine.fr

# 5. Lancer le tunnel
cloudflared tunnel --config tunnel-config.yml run portfolio-tunnel
```

Fichier `tunnel-config.yml` (à créer):
```yaml
tunnel: <TUNNEL_ID>
credentials-file: /path/to/.cloudflared/<TUNNEL_ID>.json

ingress:
  - hostname: votredomaine.fr
    service: http://localhost:80
  - service: http_status:404
```

## 📊 API Endpoints

### Serveur
- `GET /api/health` - Vérification de santé
- `GET /api/server/status` - Stats CPU, RAM, Uptime
- `GET /api/server/docker` - État des conteneurs Docker

### Contact
- `POST /api/contact` - Envoi de message
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "message": "Votre message"
  }
  ```

### Projets
- `GET /api/projects` - Liste des projets
- `GET /api/projects/{id}` - Détails d'un projet

## 🔒 Sécurité

### En production, pensez à:
1. Changer tous les mots de passe dans `.env`
2. Activer HTTPS avec Let's Encrypt ou Cloudflare
3. Configurer un pare-feu (UFW)
4. Limiter le rate-limiting sur l'API
5. Sauvegarder régulièrement la base de données

### Rate limiting Nginx (déjà configuré)
- 10 requêtes/seconde par IP sur l'API
- Protection contre les bots

## 📈 Monitoring

### Logs
```powershell
# Tous les services
docker-compose logs -f

# Un service spécifique
docker-compose logs -f nginx
docker-compose logs -f backend
```

### Métriques
Le dashboard affiche en temps réel:
- Charge CPU
- Utilisation RAM
- Température (si capteurs disponibles)
- Uptime du serveur
- État des conteneurs Docker

## 🎨 Personnalisation

### Modifier le thème
Éditer `frontend/src/styles/theme.css`

### Ajouter une page
```powershell
# Créer dans frontend/src/pages/
# Exemple: ma-page.astro
```

### Ajouter un endpoint API
Créer un fichier dans `backend/src/api/`

## 🐛 Dépannage

### Le site ne charge pas
```powershell
# Vérifier que les conteneurs tournent
docker-compose ps

# Vérifier les logs Nginx
docker-compose logs nginx
```

### L'API ne répond pas
```powershell
# Vérifier le backend
docker-compose logs backend

# Tester directement
curl http://localhost/api/health
```

### Problème de permissions
```powershell
# Sur Linux/Mac
sudo chown -R $USER:$USER .
```

## 📝 TODO / Roadmap

- [ ] Ajouter analytics (Plausible auto-hébergé ?)
- [ ] Terminal interactif (Easter egg)
- [ ] Schéma d'architecture réseau SVG
- [ ] Section "Digital Garden"
- [ ] Tests automatisés (PHPUnit + Playwright)
- [ ] CI/CD avec GitHub Actions

## 📄 Licence

Projet personnel - Tous droits réservés

## 🤝 Contact

Pour toute question: [Votre email ou formulaire de contact]

---

**Fait avec ❤️ et auto-hébergé sur un vieux PC** 🖥️
