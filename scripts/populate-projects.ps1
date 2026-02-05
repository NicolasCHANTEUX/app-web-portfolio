# Script PowerShell pour peupler la base de données avec les projets Showroom
# Usage : .\populate-projects.ps1

Write-Host "🔄 Peuplement de la base de données avec les projets..." -ForegroundColor Cyan

# Vérifier que Docker tourne
$dockerRunning = docker ps 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Docker n'est pas démarré. Lancez Docker Desktop d'abord." -ForegroundColor Red
    exit 1
}

# Vérifier que le conteneur MariaDB existe
$container = docker ps --filter "name=mariadb" --format "{{.Names}}"
if (-not $container) {
    Write-Host "❌ Le conteneur MariaDB n'est pas trouvé. Lancez 'docker-compose up -d' d'abord." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Conteneur MariaDB trouvé : $container" -ForegroundColor Green

# Exécuter le script SQL
$sqlFile = "c:\Users\chant\OneDrive\Documents\prog perso\app-web-portfolio\backend\database\seed_projects.sql"

Write-Host "📝 Exécution du script SQL..." -ForegroundColor Yellow

# Lire le contenu du fichier SQL et l'exécuter
$sqlContent = Get-Content $sqlFile -Raw

# Exécuter via docker exec
docker exec -i $container mysql -u portfolio_user -pportfolio_pass portfolio_db -e "$sqlContent"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Base de données peuplée avec succès!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Vérification des données..." -ForegroundColor Cyan
    
    # Afficher le nombre de projets
    docker exec $container mysql -u portfolio_user -pportfolio_pass portfolio_db -e "SELECT COUNT(*) as total_projects FROM projects;"
    
    Write-Host ""
    Write-Host "🎨 Accédez à la Showroom : http://localhost/showroom" -ForegroundColor Green
} else {
    Write-Host "❌ Erreur lors de l'exécution du script SQL" -ForegroundColor Red
    exit 1
}
