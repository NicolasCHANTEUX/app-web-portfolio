# 🎯 Guide de Démarrage Rapide

Ce guide vous permet de mettre en route le portfolio en quelques minutes.

## 📋 Prérequis

- ✅ Windows 10/11
- ✅ [Docker Desktop](https://www.docker.com/products/docker-desktop)
- ✅ [Node.js 20+](https://nodejs.org/)
- ✅ PowerShell (inclus dans Windows)

## 🚀 Installation en 3 étapes

### 1️⃣ Installation

Ouvrir PowerShell dans le dossier du projet et exécuter:

```powershell
.\scripts\install.ps1
```

Ce script va:
- Vérifier que Docker et Node.js sont installés
- Créer le fichier `.env` à partir de `.env.example`
- Installer les dépendances npm
- Construire le frontend Astro

### 2️⃣ Configuration

Éditer le fichier `.env` créé:

```env
# SMTP pour le formulaire de contact (optionnel en dev)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=votre.email@gmail.com
SMTP_PASSWORD=votre_mot_de_passe_application
CONTACT_EMAIL=votre.email@gmail.com
```

**Note:** En mode développement sans SMTP configuré, les messages de contact seront juste loggés dans les logs Docker.

### 3️⃣ Démarrage

```powershell
.\scripts\start.ps1
```

Le portfolio sera accessible sur: **http://localhost**

## 🛠️ Commandes Utiles

### Gestion du Projet

```powershell
# Démarrer
.\scripts\start.ps1

# Arrêter
.\scripts\stop.ps1

# Rebuild du frontend
.\scripts\rebuild-frontend.ps1

# Backup de la base de données
.\scripts\backup-db.ps1
```

### Commandes Docker

```powershell
# Voir les logs
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f backend
docker-compose logs -f nginx

# État des conteneurs
docker-compose ps

# Redémarrer un service
docker-compose restart backend
docker-compose restart nginx

# Entrer dans un conteneur
docker exec -it portfolio_backend sh
docker exec -it portfolio_mariadb mysql -u portfolio_user -p
```

### Développement Frontend

```powershell
# Mode développement avec hot-reload
cd frontend
npm run dev
# Accéder à http://localhost:4321
```

## 📊 Vérification

Après le démarrage, vérifiez que tout fonctionne:

1. **Site web:** http://localhost
2. **API Health:** http://localhost/api/health
3. **Stats serveur:** http://localhost/api/server/status
4. **Projets:** http://localhost/api/projects

## 🔧 Résolution de Problèmes

### Le site ne charge pas

```powershell
# Vérifier que tous les conteneurs tournent
docker-compose ps

# Vérifier les logs
docker-compose logs nginx
docker-compose logs backend
```

### L'API ne répond pas

```powershell
# Vérifier les logs du backend
docker-compose logs backend

# Tester directement
curl http://localhost/api/health
```

### Erreur de build frontend

```powershell
# Nettoyer et reconstruire
cd frontend
Remove-Item -Recurse -Force dist, .astro, node_modules
npm install
npm run build
```

### Port 80 déjà utilisé

Si le port 80 est occupé, modifiez dans `docker-compose.yml`:

```yaml
nginx:
  ports:
    - "8080:80"  # Utiliser le port 8080 au lieu de 80
```

Puis accédez à http://localhost:8080

## 📁 Structure des Fichiers Importants

```
portfolio/
├── .env                      # Configuration (à créer)
├── docker-compose.yml        # Orchestration Docker
├── frontend/
│   ├── src/pages/           # Pages du site
│   └── dist/                # Build (généré)
├── backend/
│   ├── src/api/             # Endpoints API
│   └── public/index.php     # Point d'entrée
└── scripts/                 # Scripts PowerShell
```

## 🌐 Mise en Production

Pour exposer sur Internet via Cloudflare Tunnel:

1. Installer [cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/)
2. S'authentifier: `cloudflared tunnel login`
3. Créer un tunnel: `cloudflared tunnel create portfolio`
4. Configurer le routage (voir README.md principal)

## 💡 Prochaines Étapes

1. ✅ Personnaliser le contenu dans `frontend/src/pages/`
2. ✅ Ajouter vos projets dans la base de données
3. ✅ Modifier le thème dans `frontend/src/styles/global.css`
4. ✅ Configurer SMTP pour le formulaire de contact
5. ✅ Déployer avec Cloudflare Tunnel

## 📞 Besoin d'Aide ?

Consultez le [README.md](../README.md) principal pour plus de détails.

---

**Bon développement ! 🚀**
