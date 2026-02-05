# Script de test de l'API Projects
# Vérifie que l'API retourne bien les projets avec la structure enrichie

Write-Host "🔍 Test de l'API Projects..." -ForegroundColor Cyan
Write-Host ""

$apiUrl = "http://localhost/api/projects.php"

try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get -ErrorAction Stop
    
    if ($response.success) {
        Write-Host "✅ API accessible et fonctionnelle" -ForegroundColor Green
        Write-Host "📊 Nombre de projets : $($response.count)" -ForegroundColor Yellow
        Write-Host ""
        
        foreach ($project in $response.data) {
            Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
            Write-Host "📦 $($project.title)" -ForegroundColor Cyan
            Write-Host "   Catégorie : $($project.category)" -ForegroundColor Gray
            Write-Host "   Punchline : $($project.description)" -ForegroundColor White
            
            if ($project.technologies) {
                Write-Host "   Technologies : $($project.technologies -join ', ')" -ForegroundColor Yellow
            }
            
            if ($project.details) {
                Write-Host ""
                Write-Host "   🎯 Défi :" -ForegroundColor Green
                Write-Host "      $($project.details.challenge)" -ForegroundColor Gray
                Write-Host ""
                Write-Host "   💡 Solution :" -ForegroundColor Green
                Write-Host "      $($project.details.solution)" -ForegroundColor Gray
                Write-Host ""
                Write-Host "   ⚙️ Architecture :" -ForegroundColor Green
                Write-Host "      $($project.details.architecture)" -ForegroundColor Gray
            }
            
            Write-Host ""
        }
        
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "🎨 Accédez à la Showroom : http://localhost/showroom" -ForegroundColor Green
        
    } else {
        Write-Host "❌ L'API a retourné une erreur : $($response.error)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ Impossible de contacter l'API" -ForegroundColor Red
    Write-Host "   Erreur : $($_.Exception.Message)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "💡 Vérifiez que :" -ForegroundColor Yellow
    Write-Host "   - Docker Desktop est démarré" -ForegroundColor Gray
    Write-Host "   - Les conteneurs tournent : docker-compose ps" -ForegroundColor Gray
    Write-Host "   - Nginx est accessible : curl http://localhost" -ForegroundColor Gray
}
