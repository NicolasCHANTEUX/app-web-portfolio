# 📸 Photo de Profil

## 📁 Fichier attendu

Placez votre photo de profil **optimisée** ici :
```
frontend/public/images/profile/avatar.webp
```

## 🎨 Recommandations Green IT ⚡

### Option 1 : Photo WebP (Recommandé pour performances) ⭐
**Pourquoi WebP ?**
- ✅ **30% plus léger** qu'un JPG de même qualité
- ✅ **Support navigateurs 95%+**
- ✅ **Cohérent avec ton discours Green IT**

**Comment convertir ?**

**Méthode 1 : En ligne**
1. Va sur [Squoosh.app](https://squoosh.app/)
2. Upload ta photo
3. Sélectionne **WebP** (qualité 80)
4. Télécharge → renomme en `avatar.webp`

**Méthode 2 : PowerShell (si ImageMagick installé)**
```powershell
magick convert avatar.jpg -resize 400x400 -quality 80 avatar.webp
```

**Méthode 3 : NPM (sharp)**
```bash
npm install -g sharp-cli
sharp -i avatar.jpg -o avatar.webp resize 400 400
```

### Option 2 : Photo Dithering (Style Tech & Green IT ultime) 🎨
**Pourquoi Dithering ?**
- ✅ Ultra stylé (effet Cyberpunk/Retro/Terminal)
- ✅ Poids **3x à 5x plus léger** qu'un WebP
- ✅ Cohérent avec le thème "Serveur/Machine"
- ✅ **Argument Green IT visuel**

**Comment ?**
1. Va sur [Dither It!](https://ditherit.com/)
2. Upload ta photo
3. Choisis le preset :
   - **"1-bit Atkinson"** (style Mac Classic)
   - **"GameBoy"** (style rétro gaming)
   - **"CGA"** (style DOS)
4. Télécharge en PNG → Convertis en WebP avec Squoosh

**Argument Green IT bonus pour ton portfolio :**
> "Même ma photo de profil est optimisée : compression WebP + Dithering 1-bit 
> pour économiser 250Ko de bande passante par visite."

## 📐 Spécifications Requises

Pour éviter le **CLS (Cumulative Layout Shift)** et améliorer les scores Lighthouse :

- **Format :** WebP (prioritaire) ou AVIF
- **Dimensions :** Exactement **300x300px** (pour Retina) ou **400x400px** max
- **Poids cible :** **< 15Ko** (critique pour Lighthouse Performance 100)
- **Qualité WebP :** Entre 70-80% sur Squoosh
- **Attributs HTML :** `width="140" height="140"` (déjà définis dans ProfileHero.astro)

### ⚠️ IMPORTANT : Compression agressive requise

Le rapport Lighthouse indique que l'avatar actuel fait **123.9 Ko**, ce qui est **8x trop lourd** !

**Objectif Green IT :** Passer de 123.9 Ko → **< 15 Ko**

**Méthode recommandée :**
1. Ouvre [Squoosh.app](https://squoosh.app/)
2. Upload ton image source
3. Redimensionne à **300x300px** (Edit → Resize)
4. Format : **WebP**
5. Qualité : **70%** (descends jusqu'à voir une dégradation acceptable)
6. Vérifie le poids final en bas à droite : **doit être < 15Ko**
7. Si > 15Ko : descends la qualité à 65% ou réduis à 280x280px

## 🔄 Remplacement

Pour remplacer la photo :
1. Supprime `avatar-placeholder.svg` (si présent)
2. Ajoute `avatar.webp` (ta vraie photo optimisée)
3. Rebuild le frontend : `npm run build`
4. Redémarre Nginx : `docker restart portfolio_nginx`

## 🎭 Alternative : Avatar généré

Si tu préfères un avatar stylisé généré :
- [Boring Avatars](https://boringavatars.com/)
- [DiceBear](https://www.dicebear.com/)
- [Avatar Generator](https://avatar-generator.org/)

**Export en WebP recommandé pour tous les avatars générés.**

---

## ✅ Checklist Green IT

- [ ] Photo convertie en WebP (< 50Ko)
- [ ] Dimensions exactes 400x400px
- [ ] Attributs width/height définis (déjà fait ✓)
- [ ] Test Lighthouse : Score > 95 en Performance
- [ ] Vérification visuelle : Grayscale → Couleur au hover fonctionne

**Note :** Le placeholder SVG actuel sera automatiquement remplacé dès que tu ajouteras `avatar.webp`.

