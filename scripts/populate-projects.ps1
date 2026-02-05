# Script PowerShell pour peupler la base de donnees avec les projets Showroom
Write-Host "Peuplement de la base de donnees..." -ForegroundColor Cyan

$container = docker ps --filter "name=mariadb" --format "{{.Names}}"
if (-not $container) {
    Write-Host "Conteneur MariaDB non trouve. Lancez docker-compose up -d" -ForegroundColor Red
    exit 1
}

Write-Host "Conteneur trouve : $container" -ForegroundColor Green

$sqlFile = "$PSScriptRoot\..\backend\database\seed_projects.sql"
docker cp $sqlFile ${container}:/tmp/seed.sql
docker exec $container mysql -u portfolio_user -pChangeMeInProduction123! portfolio_db -e "source /tmp/seed.sql"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Succes! Base peuplee." -ForegroundColor Green
    docker exec $container mysql -u portfolio_user -pChangeMeInProduction123! portfolio_db -e "SELECT COUNT(*) as total FROM projects;"
    Write-Host "Showroom : http://localhost/showroom" -ForegroundColor Cyan
}
else {
    Write-Host "Erreur SQL" -ForegroundColor Red
    exit 1
}
