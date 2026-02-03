# 🎨 Customisation du Portfolio

Guide pour personnaliser le portfolio selon vos besoins.

## 🎨 Changer le Thème

### Couleurs

Éditez `frontend/src/styles/global.css`:

```css
:root {
  --accent-color: #0066cc;     /* Couleur principale */
  --accent-hover: #0052a3;     /* Couleur au survol */
  /* ... */
}
```

### Logo et Nom

Dans `frontend/src/layouts/Layout.astro`:

```astro
<a href="/" class="logo">Votre Nom</a>
```

### Favicon

Remplacez `frontend/public/favicon.svg`

## 📝 Modifier le Contenu

### Page d'Accueil

Éditez `frontend/src/pages/index.astro`:

- Titre et sous-titre dans la section `.hero`
- Ajoutez/supprimez des sections
- Modifiez les technologies dans `.tech-grid`

### Ajouter une Page

Créez un fichier dans `frontend/src/pages/`:

```astro
---
// frontend/src/pages/ma-page.astro
import Layout from '../layouts/Layout.astro';
---

<Layout title="Ma Page">
  <section>
    <div class="container">
      <h1>Ma Nouvelle Page</h1>
      <p>Contenu...</p>
    </div>
  </section>
</Layout>
```

Puis ajoutez le lien dans la navigation (`Layout.astro`):

```astro
<li><a href="/ma-page">Ma Page</a></li>
```

### Modifier les Informations de Contact

Dans `frontend/src/pages/contact.astro`:

```astro
<ul>
  <li>📧 Email: votre@email.fr</li>
  <li>💼 LinkedIn: /in/votre-profil</li>
  <!-- ... -->
</ul>
```

## 🗄️ Gérer les Données

### Ajouter des Projets

Connectez-vous à la base de données:

```powershell
docker exec -it portfolio_mariadb mysql -u portfolio_user -p
# Mot de passe: ChangeMeInProduction123!
```

```sql
USE portfolio_db;

INSERT INTO projects (
  slug, 
  title, 
  description, 
  technologies, 
  category, 
  is_featured
) VALUES (
  'mon-projet',
  'Mon Super Projet',
  'Description de mon projet',
  '["React", "Node.js", "MongoDB"]',
  'showroom',
  TRUE
);
```

### Ajouter des Événements Timeline

```sql
INSERT INTO timeline_events (
  title, 
  description, 
  event_date, 
  category
) VALUES (
  'Diplôme obtenu',
  'Licence en Informatique',
  '2023-06-15',
  'education'
);
```

### Créer un Script d'Import

Créez un fichier `backend/database/custom_data.sql`:

```sql
-- Vos données personnalisées
INSERT INTO projects ...
INSERT INTO timeline_events ...
```

Puis importez:

```powershell
docker exec -i portfolio_mariadb mysql -u portfolio_user -pChangeMeInProduction123! portfolio_db < backend/database/custom_data.sql
```

## 🔌 Ajouter des Fonctionnalités

### Nouvel Endpoint API

1. Créez `backend/src/api/mon-endpoint.php`:

```php
<?php
use App\Services\Database;

$db = Database::getInstance();
$data = $db->fetchAll("SELECT * FROM ma_table");

echo json_encode([
    'success' => true,
    'data' => $data
]);
```

2. Ajoutez la route dans `backend/public/index.php`:

```php
case '/mon-endpoint':
    require __DIR__ . '/src/api/mon-endpoint.php';
    break;
```

### Nouveau Composant Astro

Créez `frontend/src/components/MonComposant.astro`:

```astro
---
// Props
interface Props {
  titre: string;
}
const { titre } = Astro.props;
---

<div class="mon-composant">
  <h3>{titre}</h3>
  <slot />
</div>

<style>
  .mon-composant {
    /* Styles */
  }
</style>
```

Utilisez-le:

```astro
---
import MonComposant from '@components/MonComposant.astro';
---

<MonComposant titre="Test">
  <p>Contenu</p>
</MonComposant>
```

## 📊 Personnaliser le Dashboard

Dans `frontend/src/components/Dashboard.astro`:

- Ajoutez/supprimez des cartes de stats
- Modifiez l'intervalle de mise à jour (ligne `setInterval`)
- Changez les informations affichées

## 🔒 Sécurité

### Changer les Mots de Passe

Dans `.env`:

```env
DB_PASSWORD=VotreNouveauMotDePasse
MYSQL_ROOT_PASSWORD=VotreNouveauRootPassword
```

**Important:** Après changement, recréez les conteneurs:

```powershell
docker-compose down -v
docker-compose up -d
```

### Rate Limiting

Dans `nginx/conf.d/default.conf`:

```nginx
# Ajuster les limites
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;
```

## 🌍 Multi-langue

Pour ajouter le support multi-langue:

1. Créez des dossiers par langue:
```
frontend/src/pages/
├── index.astro          (français)
├── en/
│   └── index.astro      (anglais)
```

2. Utilisez des fichiers de traduction:
```typescript
// frontend/src/i18n/fr.ts
export default {
  hero: {
    title: "Bienvenue",
    subtitle: "Portfolio"
  }
}
```

## 📱 Responsive Design

Les styles sont déjà responsive. Pour personnaliser:

```css
/* Mobile */
@media (max-width: 768px) {
  .mon-element {
    /* Styles mobile */
  }
}

/* Tablet */
@media (min-width: 769px) and (max-width: 1024px) {
  .mon-element {
    /* Styles tablette */
  }
}
```

## 🚀 Optimisation

### Images

1. Placez les images dans `frontend/public/images/`
2. Utilisez des formats modernes (WebP, AVIF)
3. Optimisez avec [Squoosh](https://squoosh.app/)

### Performance

- Minifiez le CSS/JS (déjà fait par Astro)
- Utilisez le cache Nginx (déjà configuré)
- Activez la compression gzip (déjà active)

## 🎓 Ressources

- [Documentation Astro](https://docs.astro.build/)
- [PHP 8 Documentation](https://www.php.net/docs.php)
- [Docker Compose](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)

---

**Bon customisation ! 🎨**
