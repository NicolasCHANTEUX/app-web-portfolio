# Script de rebuild du frontend

Write-Host "🔨 Rebuild du frontend..." -ForegroundColor Cyan

Set-Location frontend

# Clean
Write-Host "`n🧹 Nettoyage..." -ForegroundColor Yellow
if (Test-Path "dist") {
    Remove-Item -Recurse -Force dist
}
if (Test-Path ".astro") {
    Remove-Item -Recurse -Force .astro
}

# Build
Write-Host "`n🏗️  Construction..." -ForegroundColor Yellow
npm run build

Set-Location ..

# Redémarrer Nginx pour prendre en compte les changements
Write-Host "`n🔄 Redémarrage de Nginx..." -ForegroundColor Yellow
docker-compose restart nginx

Write-Host "`n✅ Frontend reconstruit et déployé !" -ForegroundColor Green
Write-Host "🌐 Rechargez http://localhost dans votre navigateur" -ForegroundColor Cyan
