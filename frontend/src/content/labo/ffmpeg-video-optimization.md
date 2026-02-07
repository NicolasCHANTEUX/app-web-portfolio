---
title: "Video Optimization avec FFmpeg"
description: "Commande FFmpeg pour optimiser les vidéos web avec H.264/AAC, taille réduite de 78% sans perte visuelle."
type: "snippet"
tags: ["FFmpeg", "Multimedia", "Optimization", "CLI", "H.264"]
language: "bash"
difficulty: "intermediate"
---

## 🎬 Contexte

Pour le projet **Streamify**, j'avais des vidéos de démonstration de 120 MB qui ralentissaient le chargement de la page. FFmpeg permet de réduire drastiquement la taille tout en conservant une qualité visuelle acceptable pour le web.

## 📝 Commande

```bash
ffmpeg -i input.mp4 \
  -c:v libx264 \
  -preset slow \
  -crf 23 \
  -c:a aac \
  -b:a 128k \
  -movflags +faststart \
  -vf "scale=1920:-2" \
  output.mp4
```

## 🔍 Détails des paramètres

| Paramètre | Fonction | Raison |
|-----------|----------|--------|
| `-c:v libx264` | Codec vidéo H.264 | Compatibilité universelle navigateurs |
| `-preset slow` | Vitesse d'encodage | Meilleure compression (+ lent = + petit) |
| `-crf 23` | Qualité (18-28) | Sweet spot qualité/taille (23 = good) |
| `-c:a aac` | Codec audio AAC | Standard web, support natif HTML5 |
| `-b:a 128k` | Bitrate audio | 128 kbps suffisant pour voix/musique web |
| `-movflags +faststart` | Metadata en début | Streaming progressif (lecture avant download complet) |
| `-vf scale=1920:-2` | Résolution max 1080p | -2 = hauteur auto (garde ratio), limit résolution |

## 📊 Résultats réels

**Streamify demo video:**
- Avant: 120 MB (1080p, bitrate 12 Mbps)
- Après: 26 MB (1080p, CRF 23)
- **Réduction: 78%**
- Qualité visuelle: Indistinguable à l'œil nu
- Temps de chargement: 14s → 3s (4G)

## 🎯 Variantes utiles

### Ultra-light pour mobile (720p)
```bash
ffmpeg -i input.mp4 -c:v libx264 -preset slow -crf 26 \
       -c:a aac -b:a 96k -movflags +faststart \
       -vf "scale=1280:-2" output_mobile.mp4
```

### GIF animé (pour démos courtes)
```bash
ffmpeg -i input.mp4 -vf "fps=10,scale=640:-2:flags=lanczos" \
       -t 5 output.gif
```

### Extract thumbnail (frame à 5s)
```bash
ffmpeg -i input.mp4 -ss 00:00:05 -vframes 1 thumbnail.jpg
```

## 💡 Astuces

1. **Tester avant commit**: Encoder 30s pour valider paramètres
   ```bash
   ffmpeg -i input.mp4 -t 30 -c:v libx264 -crf 23 test.mp4
   ```

2. **Batch processing**: Script PowerShell pour encoder un dossier
   ```powershell
   Get-ChildItem *.mp4 | ForEach-Object {
       ffmpeg -i $_.Name -c:v libx264 -crf 23 "optimized_$($_.Name)"
   }
   ```

3. **Check metadata**: Vérifier que faststart est activé
   ```bash
   ffmpeg -i output.mp4  # Chercher "moov atom not at front"
   ```

## 🌱 Green IT Impact

- **Bandwidth économisé**: 94 MB par visionnage
- **CO2 saved**: ~47g par 1000 vues (calcul: 0.5g CO2/MB transfert)
- **UX améliorée**: Lecture instantanée sur mobile 3G/4G
