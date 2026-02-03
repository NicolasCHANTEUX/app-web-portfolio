# Script de diagnostic pour le portfolio QG Numerique
# Usage: .\scripts\diagnostic.ps1

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Diagnostic Portfolio - QG Numerique" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# 1. Verifier Docker
Write-Host "Docker:" -ForegroundColor Yellow
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $dockerVersion = docker --version
    Write-Host "  OK Docker installe: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "  ERREUR Docker non installe" -ForegroundColor Red
    exit 1
}

# 2. Etat des conteneurs
Write-Host ""
Write-Host "Conteneurs Docker:" -ForegroundColor Yellow
docker compose ps

# 3. Sante des services
Write-Host ""
Write-Host "Health Checks:" -ForegroundColor Yellow

# API Health
Write-Host -NoNewline "  API Health (/api/health): "
try {
    $response = Invoke-WebRequest -Uri "http://localhost/api/health" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "OK ($($response.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "ERREUR ($($response.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "ERREUR (Timeout ou connexion refusee)" -ForegroundColor Red
}

# API Server Status
Write-Host -NoNewline "  Server Status (/api/server/status): "
try {
    $response = Invoke-WebRequest -Uri "http://localhost/api/server/status" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "OK ($($response.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "ERREUR ($($response.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "ERREUR" -ForegroundColor Red
}

# Frontend
Write-Host -NoNewline "  Frontend (/): "
try {
    $response = Invoke-WebRequest -Uri "http://localhost/" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "OK ($($response.StatusCode))" -ForegroundColor Green
    } else {
        Write-Host "ERREUR ($($response.StatusCode))" -ForegroundColor Red
    }
} catch {
    Write-Host "ERREUR" -ForegroundColor Red
}

# 4. Metriques systeme (via API)
Write-Host ""
Write-Host "Metriques Systeme:" -ForegroundColor Yellow
try {
    $statsResponse = Invoke-RestMethod -Uri "http://localhost/api/server/status" -UseBasicParsing -TimeoutSec 5
    if ($statsResponse.success) {
        $stats = $statsResponse.data
        Write-Host "  CPU:  $($stats.cpu.percent)%"
        Write-Host "  RAM:  $($stats.memory.percent)%"
        Write-Host "  Disk: $($stats.disk.percent)%"
        
        if ($stats.temperature -ne $null) {
            Write-Host "  Temp: $($stats.temperature) C"
        } else {
            Write-Host "  Temp: N/A (capteurs inaccessibles)"
        }
    }
} catch {
    Write-Host "  ERREUR Impossible de recuperer les metriques" -ForegroundColor Red
}

# 5. Dernieres erreurs
Write-Host ""
Write-Host "Dernieres erreurs (10 lignes):" -ForegroundColor Yellow
Write-Host "--- Backend ---"
$backendLogs = docker logs portfolio_backend --tail 10 2>&1 | Select-String -Pattern "error|warning|fatal" -CaseSensitive:$false
if ($backendLogs) {
    $backendLogs | ForEach-Object { Write-Host $_ -ForegroundColor Red }
} else {
    Write-Host "  Aucune erreur"
}

Write-Host ""
Write-Host "--- Nginx ---"
$nginxLogs = docker logs portfolio_nginx --tail 10 2>&1 | Select-String -Pattern "error|warning" -CaseSensitive:$false
if ($nginxLogs) {
    $nginxLogs | ForEach-Object { Write-Host $_ -ForegroundColor Red }
} else {
    Write-Host "  Aucune erreur"
}

# 6. Volumes et stockage
Write-Host ""
Write-Host "Volumes Docker:" -ForegroundColor Yellow
docker volume ls | Select-String -Pattern "portfolio"

# 7. Reseau
Write-Host ""
Write-Host "Reseau Docker:" -ForegroundColor Yellow
docker network inspect portfolio_network --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}' 2>$null

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Diagnostic termine" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
