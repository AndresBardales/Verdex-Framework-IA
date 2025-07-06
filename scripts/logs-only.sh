#!/bin/bash

# 📊 Script para Ver Solo Logs en Tiempo Real
# Uso: ./scripts/logs-only.sh

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

clear
echo -e "${WHITE}📊 LOGS EN TIEMPO REAL DE TODOS LOS CONTENEDORES${NC}"
echo -e "${WHITE}================================================${NC}"
echo -e "${CYAN}🎯 Dashboard: ${WHITE}http://localhost:8080${NC}"
echo -e "${CYAN}📈 Analytics: ${WHITE}http://localhost:5001${NC}"
echo -e "${YELLOW}💡 Presiona Ctrl+C para salir${NC}"
echo ""

# Verificar que los contenedores estén corriendo
if ! docker ps | grep -q "audio-"; then
    echo -e "${YELLOW}⚠️ No hay contenedores corriendo. Ejecuta primero:${NC}"
    echo -e "${WHITE}   ./scripts/start-all.sh${NC}"
    exit 1
fi

# Mostrar logs en tiempo real
docker compose logs -f --tail 100 