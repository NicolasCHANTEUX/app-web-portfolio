# Test du Rate Limiting de l'API Contact
# Usage: .\scripts\test-rate-limit.ps1

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Test Rate Limiting - API Contact" -ForegroundColor Cyan
Write-Host "  Limite: 3 messages par heure par IP" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$body = '{"name":"Test User","email":"test@example.com","message":"Test rate limiting"}'
$headers = @{"Content-Type"="application/json"}

for ($i = 1; $i -le 5; $i++) {
    Write-Host "Tentative $i..." -NoNewline
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost/api/contact" -Method POST -Body $body -Headers $headers -ErrorAction Stop
        Write-Host " OK" -ForegroundColor Green
        Write-Host "  Reponse: $($response.message)" -ForegroundColor Gray
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq 429) {
            Write-Host " BLOQUE (429 Too Many Requests)" -ForegroundColor Yellow
            $errorBody = $_.ErrorDetails.Message | ConvertFrom-Json
            Write-Host "  Message: $($errorBody.error)" -ForegroundColor Gray
            Write-Host ""
            Write-Host "Rate limiting fonctionne correctement!" -ForegroundColor Green
            break
        } else {
            Write-Host " ERREUR ($statusCode)" -ForegroundColor Red
        }
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
