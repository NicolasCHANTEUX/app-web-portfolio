# 🔒 Notes de Sécurité - QG Numérique

## Contexte

Ce portfolio est conçu pour être auto-hébergé sur un homelab personnel. Les choix de sécurité sont adaptés à ce contexte (usage privé, réseau local de confiance).

---

## Utilisation de `shell_exec()` et `exec()`

### Services concernés
- **`DockerMonitor.php`** : Monitoring des conteneurs Docker
- **`ServerMonitor.php`** : Lecture des métriques système (CPU, RAM, température)

### Justification
Ces services utilisent `shell_exec()` **uniquement avec des commandes hardcodées** :
```php
// Exemple : DockerMonitor.php
shell_exec('docker ps -a --format "{{.Names}}|{{.Status}}"');

// Exemple : ServerMonitor.php  
shell_exec('wmic os get lastbootuptime'); // Windows uniquement
```

### Sécurité garantie par
✅ **Pas de paramètres utilisateur** : Aucune donnée de `$_GET`, `$_POST`, `$_COOKIE` ou autre input utilisateur n'est passée aux commandes shell  
✅ **Commandes statiques** : Les chaînes de commande sont écrites en dur dans le code source  
✅ **Lecture seule** : Les commandes ne modifient pas le système (pas de `rm`, `mv`, `chmod`, etc.)  
✅ **Accès contrôlé** : Le conteneur backend a un accès limité via les volumes montés dans `docker-compose.yml`

### ⚠️ Règle d'or
**Ne JAMAIS modifier ces services pour y injecter des variables provenant de requêtes HTTP.**

Si un jour vous ajoutez un endpoint qui prend un paramètre (ex: `/api/container/{name}`), utilisez **une validation stricte** et une **liste blanche** :

```php
// ❌ DANGEREUX - JAMAIS FAIRE ÇA
$name = $_GET['name'];
shell_exec("docker inspect $name");

// ✅ BON - Validation stricte
$allowedContainers = ['portfolio_nginx', 'portfolio_backend', 'portfolio_mariadb'];
$name = $_GET['name'];
if (!in_array($name, $allowedContainers, true)) {
    http_response_code(400);
    die('Invalid container name');
}
shell_exec("docker inspect " . escapeshellarg($name));
```

---

## Accès aux capteurs thermiques (Linux)

### Configuration
Dans `docker-compose.yml`, le volume suivant donne accès aux capteurs de température :
```yaml
volumes:
  - /sys/class/thermal:/sys/class/thermal:ro
```

### Implications
- **Mode lecture seule (`:ro`)** : Le conteneur ne peut pas modifier les paramètres thermiques
- **Linux uniquement** : Sur Windows, `temperature` retournera toujours `null`
- **Non-privilégié** : Aucun besoin de `privileged: true` (contrairement à ce que certains tutoriels suggèrent)

### Gestion des erreurs
Le code gère gracieusement l'absence de capteurs :
- Si `/sys/class/thermal` n'existe pas → `temperature: null`
- Si les fichiers ne sont pas lisibles → `temperature: null`
- Le frontend affiche **"N/A"** au lieu de planter

---

## Accès au socket Docker

### Configuration
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock:ro
```

### Risques
⚠️ Donner accès au socket Docker permet au conteneur backend de :
- Lire l'état de tous les conteneurs
- Potentiellement démarrer/arrêter des conteneurs (si le socket n'était pas en `:ro`)

### Mitigation
✅ **Lecture seule (`:ro`)** : Empêche le backend de modifier les conteneurs  
✅ **Commandes limitées** : Seul `docker ps` est utilisé, pas de `docker exec` ou `docker rm`  
✅ **Contexte homelab** : En production publique, privilégier l'API Docker via HTTP/TLS

---

## Gestion des erreurs frontend (JavaScript)

### Problème identifié
Dans `Dashboard.astro`, les anciennes versions pouvaient afficher `undefined` si l'API renvoyait `null`.

### Solution implémentée
```javascript
// Opérateur de coalescence nulle (?.) + vérification explicite
const cpuEl = document.getElementById('cpuValue');
if (cpuEl) cpuEl.textContent = stats.cpu?.percent != null ? String(stats.cpu.percent) : 'N/A';
```

**Cas gérés :**
- ✅ API non disponible → Affiche les valeurs par défaut (`--`)
- ✅ Température `null` (Windows ou capteur inaccessible) → Affiche `N/A`
- ✅ Erreur réseau → Message d'erreur en console, pas de crash visuel

---

## Recommandations pour le déploiement

### En homelab (usage actuel) ✅
- Configuration actuelle parfaite pour un réseau local de confiance
- Pas besoin de TLS si vous accédez uniquement en local

### Si exposition publique (futur) 🌐
1. **Activer HTTPS** : 
   - Certificat Let's Encrypt via Certbot
   - Modifier `nginx/conf.d/default.conf` pour écouter sur le port 443
   
2. **Désactiver le monitoring Docker** :
   - Retirer `/var/run/docker.sock` du `docker-compose.yml`
   - L'endpoint `/api/server/docker` retournera une erreur (acceptable)

3. **Rate limiting** :
   - Ajouter `limit_req_zone` dans Nginx pour l'endpoint `/api/contact`

4. **Authentification pour le Dashboard** :
   - Ajouter une authentification HTTP Basic sur `/api/server/*`
   - Ou utiliser un token secret dans l'en-tête `Authorization`

---

## Checklist de sécurité

Avant de pousser en production :

- [ ] Changer `DB_PASSWORD` dans `.env` (actuellement `ChangeMeInProduction123!`)
- [ ] Configurer un vrai SMTP (actuellement variables d'environnement vides)
- [ ] Vérifier que `display_errors = Off` dans le `Dockerfile` PHP (✅ déjà fait)
- [ ] Tester l'endpoint `/api/contact` pour vérifier que les emails partent bien
- [ ] Ajouter un `robots.txt` si vous ne voulez pas être indexé par Google

---

## Ressources

- [OWASP - Command Injection](https://owasp.org/www-community/attacks/Command_Injection)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [PHP Security Guide](https://www.php.net/manual/en/security.php)

---

**Dernière mise à jour** : 4 février 2026  
**Maintenu par** : Nicolas CHANTEUX
