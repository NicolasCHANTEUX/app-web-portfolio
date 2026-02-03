#!/bin/bash
# Script de diagnostic pour le portfolio QG Numérique
# Usage: ./scripts/diagnostic.sh

echo "═══════════════════════════════════════════════════"
echo "  🔍 Diagnostic Portfolio - QG Numérique"
echo "═══════════════════════════════════════════════════"
echo ""

# 1. Vérifier Docker
echo "📦 Docker:"
if command -v docker &> /dev/null; then
    echo "  ✅ Docker installé: $(docker --version | cut -d' ' -f3)"
else
    echo "  ❌ Docker non installé"
    exit 1
fi

# 2. État des conteneurs
echo ""
echo "🐳 Conteneurs Docker:"
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

# 3. Santé des services
echo ""
echo "💚 Health Checks:"

# API Health
echo -n "  API Health (/api/health): "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/api/health)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✅ OK ($HTTP_CODE)"
else
    echo "❌ ERREUR ($HTTP_CODE)"
fi

# API Server Status
echo -n "  Server Status (/api/server/status): "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/api/server/status)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✅ OK ($HTTP_CODE)"
else
    echo "❌ ERREUR ($HTTP_CODE)"
fi

# Frontend
echo -n "  Frontend (/): "
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo "✅ OK ($HTTP_CODE)"
else
    echo "❌ ERREUR ($HTTP_CODE)"
fi

# 4. Métriques système (via API)
echo ""
echo "📊 Métriques Système:"
STATS=$(curl -s http://localhost/api/server/status | jq -r '.data')

if [ "$STATS" != "null" ]; then
    CPU=$(echo "$STATS" | jq -r '.cpu.percent')
    RAM=$(echo "$STATS" | jq -r '.memory.percent')
    DISK=$(echo "$STATS" | jq -r '.disk.percent')
    TEMP=$(echo "$STATS" | jq -r '.temperature')
    
    echo "  CPU:  ${CPU}%"
    echo "  RAM:  ${RAM}%"
    echo "  Disk: ${DISK}%"
    
    if [ "$TEMP" != "null" ]; then
        echo "  Temp: ${TEMP}°C"
    else
        echo "  Temp: N/A (capteurs inaccessibles)"
    fi
else
    echo "  ❌ Impossible de récupérer les métriques"
fi

# 5. Dernières erreurs
echo ""
echo "⚠️  Dernières erreurs (10 lignes):"
echo "--- Backend ---"
docker logs portfolio_backend --tail 10 2>&1 | grep -i "error\|warning\|fatal" || echo "  Aucune erreur"

echo ""
echo "--- Nginx ---"
docker logs portfolio_nginx --tail 10 2>&1 | grep -i "error\|warning" || echo "  Aucune erreur"

# 6. Volumes et stockage
echo ""
echo "💾 Volumes Docker:"
docker volume ls | grep portfolio || echo "  Aucun volume trouvé"

# 7. Réseau
echo ""
echo "🌐 Réseau Docker:"
docker network inspect portfolio_network --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}' 2>/dev/null || echo "  Réseau non trouvé"

echo ""
echo "═══════════════════════════════════════════════════"
echo "  ✅ Diagnostic terminé"
echo "═══════════════════════════════════════════════════"
