---
title: "Stack Docker du Portfolio"
description: "Analyse de l'infrastructure conteneurisée : pourquoi Alpine, comment limiter la RAM, et monitoring."
type: "tool"
tags: ["Docker", "Alpine Linux", "DevOps", "Infrastructure"]
language: "yaml"
difficulty: "intermediate"
---

## 🎯 Philosophie

Faire tourner un portfolio moderne sur un vieux PC recyclé (Intel Core i3, 4 GB RAM, SSD 120 GB) en optimisant chaque ressource.

## 🐳 Services déployés

### 1. Nginx (Reverse Proxy)
```yaml
nginx:
  image: nginx:alpine  # 5 MB seulement
  ports:
    - "80:80"
  volumes:
    - ./frontend/dist:/var/www/frontend:ro  # Read-only pour sécurité
```

**Pourquoi Alpine ?**  
Alpine Linux pèse 5 MB contre 125 MB pour Debian. Sur un vieux PC, ça libère de la RAM pour les vrais services.

### 2. Backend PHP-FPM
```yaml
backend:
  build: ./backend
  image: php:8.2-fpm-alpine
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - /sys/class/thermal:/sys/class/thermal:ro  # Capteurs température
```

**Astuce DevOps** : Le socket Docker permet au backend de monitorer les autres conteneurs sans installer Docker CLI.

### 3. MariaDB
```yaml
mariadb:
  image: mariadb:10.11
  environment:
    - MYSQL_USER=portfolio_user
    - MYSQL_PASSWORD=${DB_PASSWORD}
  volumes:
    - mariadb_data:/var/lib/mysql
```

**MariaDB vs MySQL ?**  
MariaDB a une meilleure gestion mémoire. Sur 4 GB de RAM, ça compte.

## 📊 Consommation réelle

Mesure via `docker stats` :

| Service | RAM | CPU | Taille image |
|---------|-----|-----|--------------|
| Nginx | 8 MB | 0.1% | 23 MB |
| Backend | 45 MB | 0.5% | 87 MB |
| MariaDB | 180 MB | 1.2% | 394 MB |
| **Total** | **233 MB** | **1.8%** | **504 MB** |

Sur un PC avec 4 GB de RAM, il reste **3.7 GB** pour l'OS et autres apps.

## ⚡ Optimisations appliquées

### 1. Images multi-stage (Backend)
```dockerfile
# Stage 1 : Build dependencies
FROM php:8.2-fpm-alpine AS builder
RUN apk add --no-cache composer

# Stage 2 : Production
FROM php:8.2-fpm-alpine
COPY --from=builder /app/vendor /var/www/backend/vendor
```

Résultat : Image finale **87 MB** au lieu de **450 MB**.

### 2. Health checks
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost/api/health"]
  interval: 30s
  timeout: 3s
  retries: 3
```

Si un conteneur plante, Docker le redémarre automatiquement.

### 3. Resource limits
```yaml
deploy:
  resources:
    limits:
      memory: 512M
      cpus: '1.0'
```

Évite qu'un conteneur buggué consomme toute la RAM.

## 🔍 Monitoring

Script personnalisé pour surveiller l'infra :

```bash
#!/bin/bash
# Alerter si un conteneur est down
docker ps --filter "status=exited" --format "{{.Names}}" | while read container; do
    echo "⚠️ Conteneur arrêté : $container"
    # Envoyer notification Discord/Telegram
done
```

## 💡 Leçons apprises

1. **Alpine > Debian** pour les micros-services
2. **Read-only volumes** quand possible (sécurité)
3. **Health checks** = moins de downtime
4. **Resource limits** = pas de surprise

## 🚀 Améliorations futures

- [ ] Ajouter Watchtower pour les mises à jour auto
- [ ] Prometheus + Grafana pour les metrics
- [ ] Traefik au lieu de Nginx (auto-discovery des services)
