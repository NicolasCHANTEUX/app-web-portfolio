# 📄 CV - Instructions de déploiement

## Placement du fichier

Placer votre CV au format PDF dans ce dossier avec le nom : **`CV_Nicolas_CHANTEUX_Dev_FullStack.pdf`**

```
frontend/public/CV_Nicolas_CHANTEUX_Dev_FullStack.pdf
```

## Recommandations

### Format & Poids
- **Format :** PDF (pour compatibilité ATS)
- **Poids :** < 500 Ko (Green IT)
- **Nom fichier :** `CV_Nicolas_CHANTEUX_Dev_FullStack.pdf` (lowercase, pas d'espaces)

### Contenu
Sections essentielles pour les ATS :
1. **Identité** : Nom, Titre, Contact
2. **Expérience** : Dates, Entreprises, Postes, Réalisations
3. **Compétences** : Stack technique avec mots-clés
4. **Formation** : Diplômes, Certifications
5. **Langues** : FR, EN, etc.

### Outils de création
- **Canva** : Templates modernes (gratuit)
- **LaTeX** : Pour les puristes (Overleaf)
- **Figma** : Design from scratch
- **Word/LibreOffice** : Export PDF

### Validation
Avant mise en ligne, vérifier :
- [ ] Les dates sont cohérentes
- [ ] Pas de fautes d'orthographe
- [ ] Le fichier s'appelle bien `CV_Nicolas_CHANTEUX_Dev_FullStack.pdf`
- [ ] Le poids est < 500 Ko
- [ ] Les liens (GitHub, LinkedIn) sont cliquables

## Déploiement

Après avoir placé le fichier `CV_Nicolas_CHANTEUX_Dev_FullStack.pdf` dans ce dossier :

```powershell
cd frontend
npm run build
docker restart portfolio_nginx
```

Le CV sera accessible via :
- Terminal homepage : `curl -O /home/nicolas/CV_Nicolas_CHANTEUX_Dev_FullStack.pdf`
- Footer : Lien "CV"

---

**Note :** Le CV est une "fonctionnalité de rétro-compatibilité" pour les processus RH traditionnels. Ton portfolio reste ta meilleure vitrine technique.
