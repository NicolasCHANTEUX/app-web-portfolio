# Scripts PowerShell pour gerer le portfolio

# ============================
# 1. Installation initiale
# ============================

Write-Host "Installation du Portfolio QG Numerique" -ForegroundColor Cyan

# Verifier Docker
Write-Host "`nVerification de Docker..." -ForegroundColor Yellow
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker n'est pas installe. Veuillez l'installer d'abord." -ForegroundColor Red
    Write-Host "Telecharger: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}
Write-Host "Docker est installe" -ForegroundColor Green

# Verifier Node.js
Write-Host "`nVerification de Node.js..." -ForegroundColor Yellow
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js n'est pas installe. Veuillez l'installer d'abord." -ForegroundColor Red
    Write-Host "Telecharger: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}
$nodeVersion = node -v
Write-Host "Node.js $nodeVersion est installe" -ForegroundColor Green

# Creer le fichier .env s'il n'existe pas
if (!(Test-Path ".env")) {
    Write-Host "`nCreation du fichier .env..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "Fichier .env cree. Pensez a le configurer !" -ForegroundColor Green
    Write-Host "Editez le fichier .env pour ajouter vos parametres SMTP" -ForegroundColor Yellow
} else {
    Write-Host "`nFichier .env deja present" -ForegroundColor Green
}

# Installer les dependances frontend
Write-Host "`n Installation des dependances frontend..." -ForegroundColor Yellow
Set-Location frontend
npm install
Write-Host " Dependances frontend installees" -ForegroundColor Green

# Build du frontend
Write-Host "`n Build du frontend..." -ForegroundColor Yellow
npm run build
Write-Host " Frontend construit" -ForegroundColor Green
Set-Location ..

# Creer le dossier dist s'il n'existe pas
if (!(Test-Path "frontend/dist")) {
    Write-Host " Le dossier dist n'a pas ete cree. Verifiez les erreurs ci-dessus." -ForegroundColor Yellow
}

Write-Host "`nInstallation terminee !" -ForegroundColor Green
Write-Host "`nPour lancer le projet:" -ForegroundColor Cyan
Write-Host "  1. Configurez le fichier .env" -ForegroundColor White
Write-Host "  2. Lancez: docker-compose up -d" -ForegroundColor White
Write-Host "  3. Accedez a: http://localhost" -ForegroundColor White
