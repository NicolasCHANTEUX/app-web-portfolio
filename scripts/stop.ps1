# Script d'arrêt du portfolio

Write-Host "🛑 Arrêt du Portfolio..." -ForegroundColor Yellow

# Arrêter les conteneurs
docker-compose down

Write-Host "`n✅ Portfolio arrêté" -ForegroundColor Green
Write-Host "`n💡 Pour redémarrer, lancez: .\scripts\start.ps1" -ForegroundColor Cyan
