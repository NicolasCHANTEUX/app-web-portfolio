# Script de démarrage du portfolio

Write-Host "🚀 Démarrage du Portfolio..." -ForegroundColor Cyan

# Vérifier que Docker tourne
Write-Host "`n📦 Vérification de Docker..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✅ Docker est en cours d'exécution" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker n'est pas démarré. Lancez Docker Desktop d'abord." -ForegroundColor Red
    exit 1
}

# Vérifier que le build frontend existe
if (!(Test-Path "frontend/dist")) {
    Write-Host "`n⚠️  Le frontend n'est pas construit. Construction en cours..." -ForegroundColor Yellow
    Set-Location frontend
    npm run build
    Set-Location ..
}

# Lancer Docker Compose
Write-Host "`n🐳 Lancement des conteneurs..." -ForegroundColor Yellow
docker-compose up -d

# Attendre que les services soient prêts
Write-Host "`n⏳ Attente du démarrage des services..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Vérifier le status
Write-Host "`n📊 État des conteneurs:" -ForegroundColor Cyan
docker-compose ps

# Afficher les logs
Write-Host "`n📋 Derniers logs:" -ForegroundColor Cyan
docker-compose logs --tail=20

Write-Host "`n✅ Portfolio démarré !" -ForegroundColor Green
Write-Host "`n🌐 Accédez au site:" -ForegroundColor Cyan
Write-Host "   http://localhost" -ForegroundColor White
Write-Host "`n🔍 Commandes utiles:" -ForegroundColor Cyan
Write-Host "   Voir les logs:    docker-compose logs -f" -ForegroundColor White
Write-Host "   Arrêter:          docker-compose down" -ForegroundColor White
Write-Host "   Redémarrer:       docker-compose restart" -ForegroundColor White
