# 📸 Photo de Profil

## 📁 Fichier attendu

Placez votre photo de profil ici :
```
frontend/public/images/profile/avatar.jpg
```

## 🎨 Recommandations

### Option 1 : Photo classique (Quick & Simple)
- Format : **JPG ou PNG**
- Dimensions : **400x400px minimum**
- Poids : **< 100Ko** (compression)
- Style : Photo souriante, fond neutre ou flou

### Option 2 : Photo Dithering (Style Tech & Green IT) ⭐
**Pourquoi ?**
- ✅ Ultra stylé (effet Cyberpunk/Retro)
- ✅ Poids 3x plus léger (Green IT argument)
- ✅ Cohérent avec le thème "Terminal/Serveur"

**Comment ?**
1. Va sur [Dither It!](https://ditherit.com/)
2. Upload ta photo
3. Choisis le preset **"1-bit Atkinson"** ou **"GameBoy"**
4. Télécharge le résultat
5. Renomme en `avatar.jpg`

**Argument Green IT bonus :**
> "Même ma photo de profil est optimisée : compression Dithering 1-bit 
> pour économiser 200Ko de bande passante par visite."

## 🔄 Remplacement

Pour remplacer la photo :
1. Supprime `avatar-placeholder.svg`
2. Ajoute `avatar.jpg` (ta vraie photo)
3. Rebuild le frontend : `npm run build`

## 🎭 Alternative : Avatar généré

Si tu préfères un avatar stylisé généré :
- [Boring Avatars](https://boringavatars.com/)
- [DiceBear](https://www.dicebear.com/)
- [Avatar Generator](https://avatar-generator.org/)

---

**Note :** Le placeholder SVG actuel est générique. 
Il sera automatiquement remplacé dès que tu ajouteras `avatar.jpg`.
