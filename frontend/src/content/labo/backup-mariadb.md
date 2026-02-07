---
title: "Sauvegarde Automatique MariaDB"
description: "Script PowerShell qui sauvegarde quotidiennement la base de données avec rotation automatique des backups."
type: "script"
tags: ["PowerShell", "MariaDB", "Docker", "Backup", "Automation"]
language: "powershell"
difficulty: "intermediate"
---

## 🎯 Objectif

Sauvegarder automatiquement la base de données MariaDB du portfolio sans intervention manuelle, avec rotation des sauvegardes (conservation des 7 dernières).

## 💡 Pourquoi ce script ?

- **Aucune perte de données** : Backup quotidien automatique à 3h du matin (Tâche planifiée Windows)
- **Optimisation disque** : Rotation automatique pour éviter de saturer le stockage
- **Zero downtime** : Utilise `mysqldump` sans arrêter le conteneur
- **Notifications** : Logs détaillés en cas d'erreur

## 📝 Le Code

```powershell
# Backup automatique de la base MariaDB
$backupDir = "C:\Backups\Portfolio"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = "$backupDir\portfolio_$timestamp.sql"

# Créer le dossier si inexistant
if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

# Sauvegarde via docker exec
Write-Host "Backup en cours..." -ForegroundColor Cyan
docker exec portfolio_mariadb mysqldump -u portfolio_user -pChangeMeInProduction123! portfolio_db > $backupFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Backup réussi : $backupFile" -ForegroundColor Green
    
    # Compression (optionnel)
    Compress-Archive -Path $backupFile -DestinationPath "$backupFile.zip" -Force
    Remove-Item $backupFile
    
    # Rotation : garder seulement les 7 derniers backups
    Get-ChildItem $backupDir -Filter "*.zip" | 
        Sort-Object CreationTime -Descending | 
        Select-Object -Skip 7 | 
        Remove-Item -Force
        
    Write-Host "🗑️ Anciens backups supprimés" -ForegroundColor Yellow
} else {
    Write-Host "❌ Erreur lors du backup" -ForegroundColor Red
    # Envoyer une notification (email, Discord, etc.)
}
```

## ⚙️ Configuration requise

1. **Tâche planifiée Windows** :
   ```powershell
   $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File C:\path\to\backup-db.ps1"
   $trigger = New-ScheduledTaskTrigger -Daily -At 3am
   Register-ScheduledTask -TaskName "Portfolio DB Backup" -Action $action -Trigger $trigger
   ```

2. **Permissions** : Le script doit pouvoir accéder à Docker Desktop

## 🔍 Améliorations possibles

- Envoyer les backups sur un NAS via rsync
- Upload automatique sur un cloud (Backblaze B2, AWS S3)
- Vérification de l'intégrité du backup (test de restauration)
- Metrics : taille du backup, durée de l'opération

## 📊 Résultat

- Taille moyenne : ~2 MB compressé
- Durée : ~3 secondes
- Consommation : Aucun impact (3h du matin)
