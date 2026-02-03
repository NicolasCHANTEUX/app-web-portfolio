# 🛠️ Scripts d'Administration

Collection de scripts pour gérer, diagnostiquer et tester le portfolio QG Numérique.

---

## 📋 Scripts disponibles

### 1. `diagnostic.ps1` / `diagnostic.sh`
**Diagnostic complet du système**

Vérifie l'état de santé de tous les services du portfolio.

#### Usage
```powershell
# Windows
.\scripts\diagnostic.ps1

# Linux/macOS
./scripts/diagnostic.sh
```

#### Ce qui est vérifié
- ✅ Installation Docker
- ✅ État des conteneurs (Up/Down)
- ✅ Health checks des APIs
- ✅ Métriques système (CPU, RAM, Disk, Temp)
- ✅ Dernières erreurs dans les logs
- ✅ Volumes Docker
- ✅ Configuration réseau

#### Exemple de sortie
```
===============================================
  Diagnostic Portfolio - QG Numérique
===============================================

Docker:
  ✅ Docker installé: Docker version 29.2.0

Conteneurs Docker:
  portfolio_nginx    Up 30 minutes
  portfolio_backend  Up 30 minutes
  portfolio_mariadb  Up 30 minutes

Health Checks:
  API Health (/api/health): ✅ OK (200)
  Server Status (/api/server/status): ✅ OK (200)
  Frontend (/): ✅ OK (200)

Métriques Système:
  CPU:  12.5%
  RAM:  11.03%
  Disk: 5.35%
  Temp: 45°C (ou N/A sur Windows)
```

---

### 2. `test-rate-limit.ps1`
**Test de la protection rate limiting**

Teste le système de limitation de requêtes de l'API Contact.

#### Usage
```powershell
.\scripts\test-rate-limit.ps1
```

#### Ce qui est testé
- ✅ Envoi de 5 tentatives consécutives
- ✅ Vérification du blocage après la 3ème
- ✅ Code HTTP 429 (Too Many Requests)
- ✅ Message d'erreur approprié

#### Exemple de sortie
```
==================================================
  Test Rate Limiting - API Contact
  Limite: 3 messages par heure par IP
==================================================

Tentative 1... ✅ OK
  Réponse: Message envoyé avec succès
Tentative 2... ✅ OK
  Réponse: Message envoyé avec succès
Tentative 3... ✅ OK
  Réponse: Message envoyé avec succès
Tentative 4... 🚫 BLOQUÉ (429 Too Many Requests)
  Message: Trop de requêtes. Veuillez réessayer dans 1 heure.

✅ Rate limiting fonctionne correctement!
```

#### Réinitialisation manuelle
Pour nettoyer les fichiers de rate limiting et retester :
```bash
docker exec portfolio_backend rm -f /tmp/contact_ratelimit_*
```

---

### 3. `install.ps1` / `install.sh`
**Installation initiale du portfolio**

Script d'installation automatique pour déployer le portfolio.

#### Usage
```powershell
# Windows
.\scripts\install.ps1

# Linux/macOS
./scripts/install.sh
```

#### Actions effectuées
1. Vérification des prérequis (Docker, Node.js)
2. Installation des dépendances frontend (npm install)
3. Build du frontend (npm run build)
4. Démarrage des conteneurs Docker
5. Test des endpoints API
6. Affichage de l'URL d'accès

---

## 🔧 Scripts utiles en one-liner

### Redémarrer tous les services
```bash
docker compose restart
```

### Voir les logs en temps réel
```bash
# Tous les services
docker compose logs -f

# Backend uniquement
docker logs -f portfolio_backend

# Nginx uniquement
docker logs -f portfolio_nginx
```

### Reconstruire le frontend
```bash
cd frontend
npm run build
```

### Reconstruire le backend
```bash
docker compose build backend
docker compose up -d backend
```

### Nettoyer complètement
```bash
# Arrêter et supprimer tout (ATTENTION: supprime la BDD)
docker compose down -v

# Supprimer les images
docker rmi app-web-portfolio-backend
```

### Accéder au conteneur backend
```bash
docker exec -it portfolio_backend sh
```

### Voir l'utilisation des ressources
```bash
docker stats
```

---

## 📊 Scripts de monitoring

### Surveiller les métriques en continu
```powershell
# Rafraîchir toutes les 5 secondes
while($true) {
    Clear-Host
    Invoke-RestMethod "http://localhost/api/server/status" | 
        Select-Object -ExpandProperty data | 
        ConvertTo-Json
    Start-Sleep 5
}
```

### Suivre le trafic Nginx
```bash
docker exec portfolio_nginx tail -f /var/log/nginx/access.log
```

---

## 🐛 Scripts de débogage

### Tester tous les endpoints API
```powershell
@(
    "/api/health",
    "/api/server/status",
    "/api/server/docker",
    "/api/projects",
    "/api/timeline"
) | ForEach-Object {
    Write-Host "Testing $_..." -NoNewline
    try {
        $r = Invoke-RestMethod "http://localhost$_"
        Write-Host " OK" -ForegroundColor Green
    } catch {
        Write-Host " ERREUR ($($_.Exception.Response.StatusCode.value__))" -ForegroundColor Red
    }
}
```

### Vérifier la connectivité BDD
```bash
docker exec portfolio_backend php -r "
try {
    \$pdo = new PDO('mysql:host=mariadb;dbname=portfolio_db', 'portfolio_user', 'ChangeMeInProduction123!');
    echo 'Connexion BDD OK\n';
} catch(Exception \$e) {
    echo 'Erreur: ' . \$e->getMessage() . '\n';
}
"
```

---

## 🔐 Scripts de sécurité

### Générer un mot de passe aléatoire pour la BDD
```bash
openssl rand -base64 32
```

### Vérifier les permissions Docker
```bash
docker exec portfolio_backend ls -la /var/www/backend/
```

### Scanner les vulnérabilités de l'image
```bash
docker scan app-web-portfolio-backend
```

---

## 📝 Créer de nouveaux scripts

### Template de base (PowerShell)
```powershell
#!/usr/bin/env pwsh
# Description: Mon nouveau script
# Usage: .\scripts\mon-script.ps1

param(
    [string]$Param1 = "valeur_par_defaut"
)

Write-Host "Démarrage du script..." -ForegroundColor Cyan

# Votre code ici

Write-Host "Terminé!" -ForegroundColor Green
```

### Template de base (Bash)
```bash
#!/bin/bash
# Description: Mon nouveau script
# Usage: ./scripts/mon-script.sh

set -e  # Arrêter en cas d'erreur

echo "Démarrage du script..."

# Votre code ici

echo "Terminé!"
```

---

**Mainteneur** : Nicolas CHANTEUX  
**Dernière mise à jour** : 4 février 2026
