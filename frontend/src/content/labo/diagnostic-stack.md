---
title: "Diagnostic Stack Complet"
description: "Script PowerShell pour diagnostiquer l'état de toute la stack Docker : containers, logs, connexions API et base de données."
type: "script"
tags: ["PowerShell", "Docker", "Diagnostic", "Debugging", "Automation"]
language: "powershell"
difficulty: "beginner"
---

## 🩺 Contexte

Quand un bug apparaît, il faut rapidement identifier quel composant défaille : Nginx, PHP, MariaDB ou le frontend. Ce script PowerShell automatise le diagnostic complet.

## 📝 Script

```powershell
# diagnostic-stack.ps1
Write-Host "=== DIAGNOSTIC PORTFOLIO STACK ===" -ForegroundColor Cyan
Write-Host ""

# 1. Status Docker containers
Write-Host "[1/5] Docker Containers Status" -ForegroundColor Yellow
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | Out-String

# 2. Health checks
Write-Host "[2/5] Health Checks" -ForegroundColor Yellow
$services = @("nginx", "php-fpm", "mariadb", "frontend")

foreach ($service in $services) {
    $status = docker inspect --format='{{.State.Health.Status}}' "portfolio-$service" 2>$null
    if ($status) {
        $color = if ($status -eq "healthy") { "Green" } else { "Red" }
        Write-Host "  $service : $status" -ForegroundColor $color
    } else {
        Write-Host "  $service : no health check" -ForegroundColor Gray
    }
}

# 3. Test API endpoint
Write-Host "[3/5] API Endpoint Test" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost/api/projects" -TimeoutSec 5
    Write-Host "  /api/projects : OK ($($response.Count) projects)" -ForegroundColor Green
} catch {
    Write-Host "  /api/projects : FAILED - $_" -ForegroundColor Red
}

# 4. Database connectivity
Write-Host "[4/5] Database Connectivity" -ForegroundColor Yellow
$dbTest = docker exec portfolio-mariadb mysql -uportfolio_user -pChangeMeInProduction123! -e "SELECT COUNT(*) FROM portfolio.projects;" 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  MariaDB : Connected" -ForegroundColor Green
} else {
    Write-Host "  MariaDB : Connection failed" -ForegroundColor Red
}

# 5. Recent errors in logs
Write-Host "[5/5] Recent Errors (last 20 lines)" -ForegroundColor Yellow
docker logs portfolio-php-fpm --tail 20 2>&1 | Select-String -Pattern "error|warning|fatal" -CaseSensitive:$false | ForEach-Object {
    Write-Host "  [PHP] $_" -ForegroundColor Red
}

docker logs portfolio-nginx --tail 20 2>&1 | Select-String -Pattern "error" -CaseSensitive:$false | ForEach-Object {
    Write-Host "  [Nginx] $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== DIAGNOSTIC COMPLETE ===" -ForegroundColor Cyan
```

## 🚀 Utilisation

```powershell
# Executer le diagnostic
.\scripts\diagnostic-stack.ps1

# Rediriger vers un fichier
.\scripts\diagnostic-stack.ps1 > diagnostic-report.txt
```

## 📊 Output exemple

```
=== DIAGNOSTIC PORTFOLIO STACK ===

[1/5] Docker Containers Status
NAMES               STATUS              PORTS
portfolio-nginx     Up 2 hours          0.0.0.0:80->80/tcp
portfolio-php-fpm   Up 2 hours          9000/tcp
portfolio-mariadb   Up 2 hours          3306/tcp
portfolio-frontend  Up 2 hours          3000/tcp

[2/5] Health Checks
  nginx : healthy
  php-fpm : healthy
  mariadb : healthy
  frontend : no health check

[3/5] API Endpoint Test
  /api/projects : OK (3 projects)

[4/5] Database Connectivity
  MariaDB : Connected

[5/5] Recent Errors (last 20 lines)
  (no errors found)

=== DIAGNOSTIC COMPLETE ===
```

## 🎯 Variantes

### Diagnostic verbose avec métriques
```powershell
# Ajouter stats ressources
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

### Diagnostic automatique (cron)
```powershell
# Scheduler task Windows (run every 6h)
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\path\diagnostic-stack.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 6am
Register-ScheduledTask -TaskName "Portfolio-Diagnostic" -Action $action -Trigger $trigger
```

### Export JSON pour monitoring
```powershell
# Output JSON pour Grafana/Prometheus
$diagnosticData = @{
    timestamp = Get-Date -Format "o"
    containers = docker ps --format json | ConvertFrom-Json
    api_status = (Invoke-RestMethod "http://localhost/api/projects").Count -gt 0
}
$diagnosticData | ConvertTo-Json | Out-File "diagnostic.json"
```

## 💡 Tips

1. **Ajouter au PATH**: Créer alias `diag` pour lancer rapidement
   ```powershell
   # Profil PowerShell (~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1)
   Set-Alias -Name diag -Value "C:\path\diagnostic-stack.ps1"
   ```

2. **Notification sur erreur**: Envoyer alerte Discord/Slack si API down
   ```powershell
   if ($apiError) {
       Invoke-RestMethod -Uri $webhookUrl -Method Post -Body (@{content="Portfolio API DOWN"} | ConvertTo-Json)
   }
   ```

3. **Temps de réponse**: Mesurer latence API
   ```powershell
   Measure-Command { Invoke-RestMethod "http://localhost/api/projects" }
   ```
