# Script de test de l'API Projects
Write-Host "Test de l'API Projects..." -ForegroundColor Cyan

$apiUrl = "http://localhost/api/projects"

try {
    $response = Invoke-RestMethod -Uri $apiUrl -Method Get -ErrorAction Stop
    
    if ($response.success) {
        Write-Host "API fonctionnelle - $($response.count) projets" -ForegroundColor Green
        
        foreach ($project in $response.data) {
            Write-Host "
--- $($project.title) ---" -ForegroundColor Cyan
            Write-Host "Categorie : $($project.category)"
            Write-Host "Description : $($project.description)"
            
            if ($project.technologies) {
                Write-Host "Technos : $($project.technologies -join ', ')" -ForegroundColor Yellow
            }
            
            if ($project.details) {
                Write-Host "
Defi : $($project.details.challenge)" -ForegroundColor Gray
                Write-Host "Solution : $($project.details.solution)" -ForegroundColor Gray
            }
        }
        
        Write-Host "
Showroom : http://localhost/showroom" -ForegroundColor Green
    }
    else {
        Write-Host "Erreur API : $($response.error)" -ForegroundColor Red
    }
}
catch {
    Write-Host "Impossible de contacter l'API" -ForegroundColor Red
    Write-Host "Erreur : $($_.Exception.Message)" -ForegroundColor Gray
    Write-Host "
Verifiez que Docker et les conteneurs tournent" -ForegroundColor Yellow
}
