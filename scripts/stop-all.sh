#!/bin/bash

# 🛑 Script para Detener TODO el Sistema
# Uso: ./scripts/stop-all.sh

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${WHITE}🛑 DETENIENDO SISTEMA COMPLETO${NC}"
echo -e "${WHITE}==============================${NC}"
echo ""

# Detener procesos Python
echo -e "${YELLOW}🐍 Deteniendo servicios Python...${NC}"
pkill -f "python3.*server.py" 2>/dev/null && echo -e "${GREEN}   ✅ Dashboard de logs detenido${NC}" || echo -e "${YELLOW}   ⚠️ Dashboard no estaba corriendo${NC}"
pkill -f "python3.*test-all-topic.py" 2>/dev/null && echo -e "${GREEN}   ✅ Generador de eventos detenido${NC}" || echo -e "${YELLOW}   ⚠️ Generador no estaba corriendo${NC}"

# Detener contenedores Docker
echo ""
echo -e "${YELLOW}🐳 Deteniendo contenedores Docker...${NC}"
if docker compose down; then
    echo -e "${GREEN}✅ Contenedores Docker detenidos${NC}"
else
    echo -e "${RED}❌ Error deteniendo contenedores${NC}"
fi

# Verificar que todo esté detenido
echo ""
echo -e "${YELLOW}🔍 Verificando estado...${NC}"

# Verificar contenedores
RUNNING_CONTAINERS=$(docker ps --format "{{.Names}}" | grep audio- | wc -l)
if [ "$RUNNING_CONTAINERS" -eq 0 ]; then
    echo -e "${GREEN}✅ Todos los contenedores detenidos${NC}"
else
    echo -e "${YELLOW}⚠️ Aún hay $RUNNING_CONTAINERS contenedores corriendo${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}" | grep audio-
fi

# Verificar puertos
for port in 8080 8001 5001 5005 1883 18083 27017 5678; do
    if ! lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Puerto $port liberado${NC}"
    else
        echo -e "${YELLOW}⚠️ Puerto $port aún ocupado${NC}"
    fi
done

echo ""
echo -e "${WHITE}================================================================${NC}"
echo -e "${GREEN}✅ SISTEMA DETENIDO COMPLETAMENTE${NC}"
echo -e "${WHITE}================================================================${NC}"
echo ""
echo -e "${YELLOW}💡 Para volver a iniciar, ejecuta: ${WHITE}./scripts/start-all.sh${NC}" 