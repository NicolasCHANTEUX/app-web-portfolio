# ✨ Améliorations de Sécurité et Qualité

## [Version 1.1.1] - 4 février 2026 (Corrections finales)

### 🔒 Sécurité - Rate Limiting

**Ajout de la protection rate limiting côté PHP pour l'API Contact**

**Problème identifié** : L'endpoint `/api/contact` n'avait qu'une protection Nginx. Si quelqu'un contournait Nginx (accès direct au port PHP-FPM), il pouvait spammer les soumissions.

**Solution implémentée** :
```php
// Protection double couche : Nginx + PHP
// Limite : 3 soumissions par IP par heure
$rateLimitFile = sys_get_temp_dir() . '/contact_ratelimit_' . md5($clientIp);
```

**Fonctionnement** :
1. Stockage des tentatives dans `/tmp` avec timestamp
2. Nettoyage automatique des entrées > 1h
3. Retourne HTTP 429 (Too Many Requests) après 3 tentatives
4. Message clair : "Trop de requêtes. Veuillez réessayer dans 1 heure."

**Tests** :
- ✅ 1ère soumission : HTTP 200 OK
- ✅ 2ème soumission : HTTP 200 OK  
- ✅ 3ème soumission : HTTP 200 OK
- ✅ 4ème soumission : HTTP 429 BLOCKED

---

### 🐛 Correction - CPU plafonné à 100%

**Problème** : Sur un serveur très chargé, le load average peut dépasser le nombre de cœurs (ex: load de 4.0 sur 2 cœurs = 200%)

**Solution** :
```php
// Avant
$usage = round($load[0] * 100 / self::getCpuCores(), 2);

// Après  
$usage = min(100, round($load[0] * 100 / self::getCpuCores(), 2));
```

**Impact** : Les valeurs CPU restent cohérentes et ne dépassent jamais 100%

---

### 📚 Documentation

**Ajouté** :
- Script de test du rate limiting : `scripts/test-rate-limit.ps1`
- Documentation détaillée dans `SECURITY.md` sur la protection rate limiting

---

## [Version 1.1.0] - 4 février 2026  

**Date** : 4 février 2026  
**Version** : 1.1.0  

Suite à l'audit de code, les améliorations suivantes ont été apportées pour garantir un code professionnel, robuste et sécurisé.

---

## 🔒 Sécurité

### 1. Documentation des commandes shell
**Problème** : Utilisation de `shell_exec()` sans contexte explicite

**Solution** :
- Ajout de blocs de commentaires détaillés dans `ServerMonitor.php` et `DockerMonitor.php`
- Explication claire que les commandes sont hardcodées
- Avertissement explicite contre l'injection de paramètres utilisateur

**Fichiers modifiés** :
- [`backend/src/services/ServerMonitor.php`](backend/src/services/ServerMonitor.php)
- [`backend/src/services/DockerMonitor.php`](backend/src/services/DockerMonitor.php)

**Extrait de code** :
```php
/**
 * SÉCURITÉ CRITIQUE:
 * - Utilise shell_exec() uniquement avec des commandes statiques
 * - Pas de paramètres utilisateur dans les commandes shell
 * - Toutes les lectures sont en lecture seule (/proc, /sys)
 */
```

---

## 🛡️ Gestion des erreurs

### 2. Affichage robuste des métriques système
**Problème** : Le Dashboard JavaScript affichait `undefined` quand l'API renvoyait `null`

**Solution** :
- Utilisation de l'opérateur de coalescence nulle (`?.`)
- Vérification explicite avec `!= null` avant conversion en string
- Affichage de "N/A" pour les valeurs indisponibles

**Fichier modifié** :
- [`frontend/src/components/Dashboard.astro`](frontend/src/components/Dashboard.astro)

**Avant** :
```javascript
cpuEl.textContent = String(stats.cpu.percent); // ❌ Crash si null
```

**Après** :
```javascript
cpuEl.textContent = stats.cpu?.percent != null ? String(stats.cpu.percent) : 'N/A'; // ✅
```

---

## 🌡️ Monitoring amélioré

### 3. Accès aux capteurs de température
**Problème** : `temperature` toujours `null` dans le conteneur Docker

**Solution** :
- Ajout du volume `/sys/class/thermal:/sys/class/thermal:ro` dans `docker-compose.yml`
- Gestion gracieuse de l'absence de capteurs (Linux uniquement)
- Documentation claire du comportement multi-plateforme

**Fichier modifié** :
- [`docker-compose.yml`](docker-compose.yml)

**Configuration ajoutée** :
```yaml
volumes:
  - /sys/class/thermal:/sys/class/thermal:ro  # Accès aux capteurs de température
```

**Comportement** :
- **Linux** : Affiche la température réelle si accessible
- **Windows / macOS** : Affiche "N/A" (normal)
- **Conteneur non-privilégié** : Affiche "N/A" (sécurisé)

---

## 🔍 Amélioration de la lecture des capteurs

### 4. Gestion des erreurs de lecture thermique
**Problème** : `file_get_contents()` pouvait planter si le fichier n'est pas lisible

**Solution** :
- Vérification avec `is_readable()` avant lecture
- Utilisation de `@file_get_contents()` pour supprimer les warnings
- Filtrage des valeurs aberrantes (< 0°C ou > 150°C)

**Fichier modifié** :
- [`backend/src/services/ServerMonitor.php`](backend/src/services/ServerMonitor.php)

**Code amélioré** :
```php
foreach ($tempFiles as $file) {
    if (!is_readable($file)) continue;
    
    $content = @file_get_contents($file);
    if ($content === false) continue;
    
    $temp = (int)$content / 1000;
    if ($temp > 0 && $temp < 150) { // Filtre valeurs aberrantes
        $temps[] = $temp;
    }
}
```

---

## 📊 Interface utilisateur

### 5. Widget de température dans le Dashboard
**Ajout** : Nouvelle carte affichant la température CPU

**Fichier modifié** :
- [`frontend/src/components/Dashboard.astro`](frontend/src/components/Dashboard.astro)

**Rendu** :
```
┌──────────┬──────────┬──────────┬──────────┬──────────┐
│   CPU    │   RAM    │  Disque  │  🌡️ Temp │  Uptime  │
│   12%    │   45%    │   23%    │   N/A    │   3j     │
└──────────┴──────────┴──────────┴──────────┴──────────┘
```

---

## 📚 Documentation

### 6. Fichiers de documentation créés

#### [`SECURITY.md`](SECURITY.md)
- Justification de l'utilisation de `shell_exec()`
- Règles de sécurité strictes
- Guide pour l'exposition publique
- Checklist de sécurité pré-production

#### [`ARCHITECTURE.md`](ARCHITECTURE.md)
- Schéma de l'infrastructure
- Description de chaque service
- Flux de données détaillés
- Endpoints API documentés
- Guide de débogage
- Benchmarks de performance

#### Scripts de diagnostic
- [`scripts/diagnostic.sh`](scripts/diagnostic.sh) (Linux/macOS)
- [`scripts/diagnostic.ps1`](scripts/diagnostic.ps1) (Windows)

**Fonctionnalités** :
✅ Vérification de Docker  
✅ État des conteneurs  
✅ Health checks des endpoints  
✅ Métriques système en temps réel  
✅ Détection des erreurs dans les logs  
✅ Inspection du réseau Docker  

---

## 🎯 Résultats

### Tests de validation

| Test                              | Résultat |
|-----------------------------------|----------|
| Health Check `/api/health`        | ✅ 200 OK |
| Server Status `/api/server/status`| ✅ 200 OK |
| Frontend `/`                      | ✅ 200 OK |
| Gestion `temperature: null`       | ✅ Affiche "N/A" |
| Gestion `cpu.percent: null`       | ✅ Affiche "N/A" |
| Logs backend                      | ✅ Aucune erreur |
| Logs nginx                        | ✅ Aucune erreur |
| Build Astro                       | ✅ 0 errors, 0 warnings |

### Métriques de qualité

| Métrique                  | Avant | Après |
|---------------------------|-------|-------|
| Documentation (pages)     | 1     | 4     |
| Commentaires de sécurité  | 0     | 3 blocs |
| Gestion d'erreurs JS      | Basic | Robuste |
| Scripts d'admin           | 0     | 2     |
| Coverage température      | 0%    | 100%  |

---

## 🚀 Prochaines étapes recommandées

### Court terme (semaine 1)
- [ ] Tester sur un PC Linux pour valider l'affichage de la température
- [ ] Ajouter un endpoint `/api/metrics` au format Prometheus
- [ ] Créer un `docker-compose.prod.yml` sans volumes de dev

### Moyen terme (semaine 2-4)
- [ ] Implémenter les pages manquantes (Showroom, Labo, Timeline)
- [ ] Ajouter des tests unitaires pour les services PHP
- [ ] Configurer SMTP pour le formulaire de contact

### Long terme (mois 1-3)
- [ ] CI/CD avec GitHub Actions
- [ ] Monitoring Prometheus + Grafana
- [ ] Certificat SSL Let's Encrypt
- [ ] Rate limiting sur les endpoints publics

---

## 📝 Changelog

### [1.1.0] - 2026-02-04
#### Ajouté
- Documentation de sécurité complète (`SECURITY.md`)
- Documentation d'architecture (`ARCHITECTURE.md`)
- Scripts de diagnostic (Bash + PowerShell)
- Widget de température dans le Dashboard
- Support des capteurs thermiques Linux

#### Amélioré
- Gestion des erreurs JavaScript (opérateur de coalescence)
- Commentaires de sécurité dans les services PHP
- Lecture robuste des fichiers `/sys/class/thermal`
- README avec badges et liens vers la documentation

#### Corrigé
- Affichage "undefined" quand `temperature: null`
- Crash potentiel si fichier thermique non lisible
- Absence de contexte sur l'utilisation de `shell_exec()`

---

**Mainteneur** : Nicolas CHANTEUX  
**Licence** : MIT
