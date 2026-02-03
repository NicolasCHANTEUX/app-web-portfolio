# Script de backup de la base de données

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = "backup_$timestamp.sql"
$backupDir = "backups"

Write-Host "💾 Backup de la base de données..." -ForegroundColor Cyan

# Créer le dossier de backup s'il n'existe pas
if (!(Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

# Faire le dump
Write-Host "`n📦 Création du dump SQL..." -ForegroundColor Yellow
docker exec portfolio_mariadb mysqldump -u portfolio_user -pChangeMeInProduction123! portfolio_db > "$backupDir\$backupFile"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Backup créé: $backupDir\$backupFile" -ForegroundColor Green
    
    # Afficher la taille
    $size = (Get-Item "$backupDir\$backupFile").Length / 1KB
    Write-Host "📊 Taille: $([math]::Round($size, 2)) KB" -ForegroundColor Cyan
    
    # Nettoyer les vieux backups (garder les 7 derniers)
    Write-Host "`n🧹 Nettoyage des anciens backups..." -ForegroundColor Yellow
    Get-ChildItem $backupDir -Filter "backup_*.sql" | 
        Sort-Object CreationTime -Descending | 
        Select-Object -Skip 7 | 
        Remove-Item -Force
    
    $remaining = (Get-ChildItem $backupDir -Filter "backup_*.sql").Count
    Write-Host "✅ $remaining backups conservés" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors du backup" -ForegroundColor Red
}
