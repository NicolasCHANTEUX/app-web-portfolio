# 🔧 Architecture Technique - QG Numérique

## Vue d'ensemble

Portfolio auto-hébergé avec architecture découplée (Headless) démontrant des compétences full-stack et DevOps.

```
┌─────────────────────────────────────────────────────────────┐
│                      NGINX (Port 80/443)                    │
│                    Reverse Proxy + Static                   │
└─────────────────┬───────────────────────────┬───────────────┘
                  │                           │
         ┌────────▼─────────┐        ┌────────▼─────────┐
         │  Frontend Astro  │        │  Backend PHP-FPM │
         │  (Static Files)  │        │   (API REST)     │
         │  dist/           │        │   Port 9000      │
         └──────────────────┘        └────────┬─────────┘
                                               │
                                      ┌────────▼─────────┐
                                      │  MariaDB 10.11   │
                                      │  (Base données)  │
                                      └──────────────────┘
```

---

## Stack Technique

### Frontend
- **Framework** : Astro 5.17.1 (Static Site Generator)
- **Architecture** : Islands Architecture (JavaScript uniquement où nécessaire)
- **Langages** : TypeScript, HTML5, CSS3
- **Build** : Vite 5.0.10
- **Taille finale** : ~12 KB (index.html compressé)

**Avantages :**
✅ Performance maximale (statique pré-généré)  
✅ SEO optimal (HTML pur)  
✅ Pas de framework JS lourd côté client  

### Backend
- **Langage** : PHP 8.2-FPM (Alpine Linux)
- **Architecture** : Router léger sans framework
- **Dépendances** : Composer (autoload PSR-4)
- **Extensions** : PDO, MySQLi, Zip, Docker CLI

**Choix technique :**  
Pas de Symfony/Laravel pour minimiser la RAM et le CPU sur un vieux PC. Un router simple dans `index.php` suffit pour 7 endpoints.

### Base de données
- **SGBD** : MariaDB 10.11
- **Tables** : `projects`, `timeline_events`, `contacts`, `analytics`
- **Volumes** : Persistance via Docker volume nommé

### Reverse Proxy
- **Serveur** : Nginx Alpine (version minimale)
- **Rôles** :
  1. Servir les fichiers statiques du frontend (`frontend/dist/`)
  2. Proxy FastCGI vers PHP-FPM pour `/api/*`
  3. Gestion du cache (1 an pour les assets)

---

## Flux de données

### 1. Chargement de la page d'accueil
```
Utilisateur → http://localhost/
  ↓
Nginx lit frontend/dist/index.html
  ↓
Navigateur reçoit HTML statique (12 KB)
  ↓
JavaScript charge /api/server/status
  ↓
Nginx route vers backend:9000 (FastCGI)
  ↓
PHP-FPM exécute index.php → ServerMonitor.php
  ↓
JSON renvoyé au navigateur
  ↓
Dashboard mis à jour dynamiquement
```

### 2. Soumission du formulaire de contact
```
Formulaire → POST /api/contact
  ↓
Nginx → FastCGI → backend:9000
  ↓
contact.php valide les données
  ↓
Enregistrement dans la BDD (table contacts)
  ↓
Envoi email via Mailer.php (SMTP)
  ↓
Réponse JSON {success: true}
```

---

## Endpoints API

### Publics (pas d'auth)

| Méthode | Endpoint              | Description                          | Cache |
|---------|-----------------------|--------------------------------------|-------|
| GET     | `/api/health`         | Health check                         | Non   |
| GET     | `/api/server/status`  | Métriques système (CPU, RAM, etc.)   | Non   |
| GET     | `/api/server/docker`  | État des conteneurs Docker           | Non   |
| GET     | `/api/projects`       | Liste des projets du portfolio       | 5min  |
| GET     | `/api/timeline`       | Événements de la timeline            | 10min |
| POST    | `/api/contact`        | Formulaire de contact                | Non   |
| POST    | `/api/analytics/track`| Tracking des pages vues              | Non   |

### Exemple de réponse - `/api/server/status`
```json
{
  "success": true,
  "data": {
    "cpu": { "percent": 12.5, "cores": 16 },
    "memory": { "total_mb": 7752, "used_mb": 855, "percent": 11.03 },
    "disk": { "total_gb": 1006, "used_gb": 53, "percent": 5.35 },
    "uptime": { "seconds": 2079, "formatted": "0j 0h 34m" },
    "temperature": null,
    "timestamp": 1770160057
  }
}
```

---

## Configuration Nginx

### FastCGI vers PHP-FPM
```nginx
location /api/ {
    fastcgi_pass backend:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME /var/www/backend/public/index.php;
    include fastcgi_params;
}
```

**Pièges évités :**
❌ Utiliser `proxy_pass http://backend:9000` → Erreur 502 (PHP-FPM parle FastCGI, pas HTTP)  
✅ Utiliser `fastcgi_pass backend:9000` → Fonctionne

### Cache des assets statiques
```nginx
location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff2)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

---

## Monitoring système

### Métriques collectées

#### CPU
- **Source** : `/proc/loadavg` (Linux) ou `WMIC` (Windows)
- **Valeur** : Load average (0-N × nb_cores)
- **Limitation** : Pas le % instantané mais la file d'attente des processus

#### RAM
- **Source** : `/proc/meminfo` (Linux) ou `WMIC` (Windows)
- **Valeur** : Pourcentage utilisé (0-100%)
- **Calcul** : `(total - available) / total × 100`

#### Température
- **Source** : `/sys/class/thermal/thermal_zone*/temp` (Linux uniquement)
- **Valeur** : Degrés Celsius (ou `null` si inaccessible)
- **Conversion** : Millidegrés → degrés (`/1000`)

#### Disque
- **Source** : `disk_free_space()` + `disk_total_space()`
- **Chemin** : `/var/www` (point de montage du conteneur)
- **Limitation** : Reflète l'espace du volume Docker, pas du disque hôte

---

## Docker Compose

### Services

#### nginx
```yaml
ports: ["80:80", "443:443"]
volumes:
  - ./frontend/dist:/var/www/frontend:ro
  - ./nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf:ro
```

#### backend
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock:ro  # Monitoring Docker
  - /sys/class/thermal:/sys/class/thermal:ro       # Capteurs température
  - ./backend/public:/var/www/backend/public
  - ./backend/src:/var/www/backend/src
```

**Note :** Les volumes montés sélectivement (`public`, `src`) permettent le hot-reload en dev sans écraser le dossier `vendor/` créé par Composer.

#### mariadb
```yaml
environment:
  MARIADB_DATABASE: portfolio_db
  MARIADB_USER: portfolio_user
volumes:
  - db_data:/var/lib/mysql  # Persistance
  - ./backend/database/init.sql:/docker-entrypoint-initdb.d/init.sql:ro
```

---

## Débogage courant

### Problème : 500 Internal Server Error sur `/api/health`

**Causes possibles :**
1. ❌ Nginx utilise `proxy_pass` au lieu de `fastcgi_pass`
2. ❌ Le dossier `vendor/` n'existe pas dans le conteneur
3. ❌ Mauvais chemin dans `SCRIPT_FILENAME`

**Solution :**
```bash
# Vérifier les logs
docker logs portfolio_backend --tail 30

# Vérifier que vendor existe
docker exec portfolio_backend ls -la /var/www/backend/vendor
```

### Problème : Température toujours `null`

**Cause :** Pas d'accès aux capteurs thermiques

**Solution :**
```yaml
# Ajouter dans docker-compose.yml (service backend)
volumes:
  - /sys/class/thermal:/sys/class/thermal:ro
```

Puis :
```bash
docker compose restart backend
```

### Problème : Dashboard affiche `undefined`

**Cause :** L'API renvoie `null` pour une valeur

**Solution :** Vérifier que le JavaScript utilise l'opérateur de coalescence :
```javascript
stats.temperature != null ? String(stats.temperature) + '°C' : 'N/A'
```

---

## Performance

### Benchmarks locaux

| Métrique              | Valeur          |
|-----------------------|-----------------|
| Taille index.html     | 12.6 KB         |
| Temps de build Astro  | < 1 seconde     |
| Réponse `/api/health` | < 50 ms         |
| RAM backend (idle)    | ~40 MB          |
| RAM nginx (idle)      | ~10 MB          |
| Temps premier paint   | < 100 ms (LAN)  |

### Optimisations appliquées
✅ Minification HTML/CSS/JS par Vite  
✅ Inlining critique du CSS (Astro)  
✅ Lazy loading des images  
✅ Cache Nginx 1 an pour les assets  
✅ Gzip/Brotli activé (nginx)  

---

## Évolutions futures

### Phase 2 - Fonctionnalités
- [ ] Page Showroom (projets détaillés avec screenshots)
- [ ] Page Labo (expérimentations techniques)
- [ ] Timeline interactive (style CV visuel)
- [ ] Système de login admin pour gérer les projets

### Phase 3 - DevOps avancé
- [ ] CI/CD avec GitHub Actions (auto-deploy)
- [ ] Monitoring avec Prometheus + Grafana
- [ ] Backup automatique de la BDD
- [ ] Certificat SSL Let's Encrypt

### Phase 4 - Scaling (si besoin)
- [ ] Redis pour le cache de l'API
- [ ] Réplication MariaDB (master/slave)
- [ ] Load balancer Nginx (multi-backend)

---

## Ressources

- [Astro Documentation](https://docs.astro.build/)
- [PHP-FPM Best Practices](https://www.php.net/manual/fr/install.fpm.php)
- [Nginx FastCGI Guide](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)

---

**Dernière mise à jour** : 4 février 2026  
**Mainteneur** : Nicolas CHANTEUX
