---
year: "2023"
title: "La Révolution Docker"
description: "Migration complète de mon infrastructure vers des conteneurs. Finis les conflits de dépendances, place à la portabilité et aux fichiers docker-compose."
icon: "container"
category: "devops"
lesson: "L'isolation des services est la clé d'une maintenance sereine."
link: "/architecture"
linkText: "Voir l'Architecture"
---

**Avant :** Installer manuellement PHP, Nginx, MariaDB sur la machine hôte. Résultat : un bordel ingérable.

**Après :** `docker-compose up` et tout démarre proprement, isolé, reproductible.

### Ce que Docker m'a appris
- **Networks** : comprendre comment les conteneurs communiquent
- **Volumes** : persister les données sans polluer l'hôte
- **Multi-stage builds** : optimiser les images (Alpine Linux FTW)

**Moment clé :** Pouvoir détruire et reconstruire toute l'infra en 2 minutes.

**Statistiques :**
- Avant : ~1.2 GB d'images
- Après optimisation Alpine : ~250 MB
