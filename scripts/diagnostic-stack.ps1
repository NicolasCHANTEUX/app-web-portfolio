# diagnostic-stack.ps1
# Script de diagnostic complet de la stack Portfolio

Write-Host "=== DIAGNOSTIC PORTFOLIO STACK ===" -ForegroundColor Cyan
Write-Host ""

# 1. Status Docker containers
Write-Host "[1/5] Docker Containers Status" -ForegroundColor Yellow
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | Out-String

# 2. Health checks
Write-Host "[2/5] Health Checks" -ForegroundColor Yellow
$services = @("nginx", "php-fpm", "mariadb", "frontend")

foreach ($service in $services) {
    $containerName = "portfolio-$service"
    $running = docker ps --filter "name=$containerName" --format "{{.Names}}" 2>$null
    
    if ($running) {
        Write-Host "  $service : running" -ForegroundColor Green
    } else {
        Write-Host "  $service : stopped or not found" -ForegroundColor Red
    }
}

# 3. Test API endpoint
Write-Host "" 
Write-Host "[3/5] API Endpoint Test" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost/api/projects" -TimeoutSec 5
    Write-Host "  /api/projects : OK ($($response.Count) projects)" -ForegroundColor Green
} catch {
    Write-Host "  /api/projects : FAILED - $($_.Exception.Message)" -ForegroundColor Red
}

# 4. Database connectivity
Write-Host ""
Write-Host "[4/5] Database Connectivity" -ForegroundColor Yellow
try {
    $dbTest = docker exec portfolio-mariadb mysql -uportfolio_user -pChangeMeInProduction123! -e "SELECT COUNT(*) as count FROM portfolio.projects;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  MariaDB : Connected" -ForegroundColor Green
        # Extraire le nombre de projets
        $projectCount = ($dbTest | Select-String -Pattern "\d+").Matches.Value
        if ($projectCount) {
            Write-Host "  Projects in DB : $projectCount" -ForegroundColor Gray
        }
    } else {
        Write-Host "  MariaDB : Connection failed" -ForegroundColor Red
    }
} catch {
    Write-Host "  MariaDB : Error - $($_.Exception.Message)" -ForegroundColor Red
}

# 5. Recent errors in logs
Write-Host ""
Write-Host "[5/5] Recent Errors (last 20 lines)" -ForegroundColor Yellow

$phpErrors = docker logs portfolio-php-fpm --tail 20 2>&1 | Select-String -Pattern "error|warning|fatal" -CaseSensitive:$false
if ($phpErrors) {
    $phpErrors | ForEach-Object {
        Write-Host "  [PHP] $_" -ForegroundColor Red
    }
} else {
    Write-Host "  [PHP] No errors found" -ForegroundColor Green
}

$nginxErrors = docker logs portfolio-nginx --tail 20 2>&1 | Select-String -Pattern "error" -CaseSensitive:$false
if ($nginxErrors) {
    $nginxErrors | ForEach-Object {
        Write-Host "  [Nginx] $_" -ForegroundColor Red
    }
} else {
    Write-Host "  [Nginx] No errors found" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== DIAGNOSTIC COMPLETE ===" -ForegroundColor Cyan
Write-Host ""

# Optionnel: resource usage
Write-Host "Resource Usage:" -ForegroundColor Yellow
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | Out-String
