#!/bin/bash

# 🚀 Script Maestro - Levantar TODO el Sistema de Logs y Analytics
# Uso: ./scripts/start-all.sh

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOGS_VIEWER_PID=""
TEST_EVENTS_PID=""

# Función para mostrar header
show_header() {
    clear
    echo -e "${WHITE}"
    echo "██████╗ ██████╗ ██████╗     ███████╗██████╗  █████╗ ██████╗ ████████╗██╗   ██╗██████╗ "
    echo "██╔══██╗██╔══██╗██╔══██╗    ██╔════╝██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║   ██║██╔══██╗"
    echo "██████╔╝██████╔╝██████╔╝    ███████╗██████╔╝███████║██████╔╝   ██║   ██║   ██║██████╔╝"
    echo "██╔══██╗╚════██║██╔══██╗    ╚════██║██╔══██╗██╔══██║██╔══██╗   ██║   ██║   ██║██╔═══╝ "
    echo "██████╔╝██████╔╝██████╔╝    ███████║██████╔╝██║  ██║██║  ██║   ██║   ╚██████╔╝██║     "
    echo "╚═════╝ ╚═════╝ ╚═════╝     ╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝     "
    echo -e "${NC}"
    echo -e "${CYAN}🚀 Sistema Completo de Logs y Analytics - Flutter Voice Assistant${NC}"
    echo -e "${WHITE}=================================================================${NC}"
    echo ""
}

# Función para verificar si un puerto está en uso
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
        return 0
    else
        return 1
    fi
}

# Función para esperar que un servicio esté disponible
wait_for_service() {
    local url=$1
    local name=$2
    local max_attempts=30
    local attempt=1
    
    echo -e "${YELLOW}⏳ Esperando que ${name} esté disponible...${NC}"
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s --connect-timeout 2 "$url" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ ${name} está listo!${NC}"
            return 0
        fi
        
        echo -e "${YELLOW}   Intento $attempt/$max_attempts...${NC}"
        sleep 2
        ((attempt++))
    done
    
    echo -e "${RED}❌ ${name} no respondió después de $max_attempts intentos${NC}"
    return 1
}

# Función para cleanup al salir
cleanup() {
    echo -e "\n${WHITE}🛑 Deteniendo servicios...${NC}"
    
    if [ ! -z "$LOGS_VIEWER_PID" ]; then
        kill $LOGS_VIEWER_PID 2>/dev/null
        echo -e "${YELLOW}   ✅ Dashboard de logs detenido${NC}"
    fi
    
    if [ ! -z "$TEST_EVENTS_PID" ]; then
        kill $TEST_EVENTS_PID 2>/dev/null
        echo -e "${YELLOW}   ✅ Generador de eventos detenido${NC}"
    fi
    
    echo -e "${WHITE}👋 ¡Hasta luego!${NC}"
    exit 0
}

# Configurar trap para cleanup
trap cleanup INT TERM

# Función principal
main() {
    show_header
    
    echo -e "${BLUE}📋 FASE 1: Verificación de Prerequisites${NC}"
    echo -e "${WHITE}================================================${NC}"
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker no está instalado${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker encontrado${NC}"
    
    # Verificar Docker Compose
    if ! docker compose version &> /dev/null; then
        echo -e "${RED}❌ Docker Compose no está disponible${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker Compose encontrado${NC}"
    
    # Verificar Python
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}❌ Python3 no está instalado${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Python3 encontrado${NC}"
    
    echo ""
    echo -e "${BLUE}🐳 FASE 2: Levantando Servicios Docker${NC}"
    echo -e "${WHITE}================================================${NC}"
    
    cd "$PROJECT_ROOT"
    
    # Levantar servicios Docker
    echo -e "${YELLOW}🚀 Iniciando contenedores Docker...${NC}"
    if docker compose up -d; then
        echo -e "${GREEN}✅ Contenedores Docker iniciados${NC}"
    else
        echo -e "${RED}❌ Error iniciando contenedores Docker${NC}"
        exit 1
    fi
    
    # Esperar que los servicios estén disponibles
    echo ""
    echo -e "${BLUE}⏳ FASE 3: Verificando Servicios${NC}"
    echo -e "${WHITE}================================================${NC}"
    
    wait_for_service "http://localhost:8001/health" "Auth Service"
    wait_for_service "http://localhost:18083" "EMQX Dashboard"
    wait_for_service "http://localhost:27017" "MongoDB" || echo -e "${YELLOW}⚠️ MongoDB puede tardar más en estar listo${NC}"
    wait_for_service "http://localhost:5678" "n8n Automation"
    
    echo ""
    echo -e "${BLUE}📊 FASE 4: Iniciando Dashboard y Servicios${NC}"
    echo -e "${WHITE}================================================${NC}"
    
    # Verificar si puerto 8080 está libre, si no, matar proceso
    if check_port 8080; then
        echo -e "${YELLOW}⚠️ Puerto 8080 ocupado, liberando...${NC}"
        pkill -f "python3.*server.py" 2>/dev/null || true
        sleep 2
    fi
    
    # Iniciar dashboard de logs
    echo -e "${YELLOW}🌐 Iniciando Dashboard de Logs...${NC}"
    cd "$PROJECT_ROOT/logs_viewer"
    python3 server.py > /dev/null 2>&1 &
    LOGS_VIEWER_PID=$!
    cd "$PROJECT_ROOT"
    
    # Esperar que dashboard esté listo
    wait_for_service "http://localhost:8080" "Dashboard de Logs"
    
    # Iniciar generador de eventos de prueba
    echo -e "${YELLOW}🎭 Iniciando Generador de Eventos de Prueba...${NC}"
    cd "$PROJECT_ROOT/scripts"
    python3 test-all-topic.py > /dev/null 2>&1 &
    TEST_EVENTS_PID=$!
    cd "$PROJECT_ROOT"
    
    echo ""
    echo -e "${BLUE}📱 FASE 5: Verificando Estado del Sistema${NC}"
    echo -e "${WHITE}================================================${NC}"
    
    # Verificar contenedores
    echo -e "${CYAN}📦 Estado de Contenedores:${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep audio- | while read line; do
        echo -e "${GREEN}   ✅ $line${NC}"
    done
    
    # Verificar logs del día
    TODAY=$(date +%Y-%m-%d)
    if [ -d "logs/$TODAY" ]; then
        LOG_COUNT=$(find "logs/$TODAY" -name "*.log" | wc -l)
        echo -e "${GREEN}✅ Archivos de logs del día: $LOG_COUNT${NC}"
    fi
    
    # Verificar eventos en API
    sleep 3
    EVENT_COUNT=$(curl -s "http://localhost:8080/api/logs" | python3 -c "import sys, json; print(json.load(sys.stdin)['total'])" 2>/dev/null || echo "0")
    echo -e "${GREEN}✅ Eventos capturados: $EVENT_COUNT${NC}"
    
    echo ""
    echo -e "${WHITE}🎯 SISTEMA COMPLETAMENTE OPERATIVO${NC}"
    echo -e "${WHITE}=====================================${NC}"
    echo ""
    echo -e "${CYAN}📊 DASHBOARDS DISPONIBLES:${NC}"
    echo -e "${GREEN}   🎯 Logs Tiempo Real:    ${WHITE}http://localhost:8080${NC}"
    echo -e "${GREEN}   📈 Analytics Avanzado:  ${WHITE}http://localhost:5001${NC}"
    echo -e "${GREEN}   🔧 Auth Service:        ${WHITE}http://localhost:8001${NC}"
    echo -e "${GREEN}   📡 EMQX Dashboard:      ${WHITE}http://localhost:18083${NC}"
    echo -e "${GREEN}   🍃 n8n Automation:      ${WHITE}http://localhost:5678${NC}"
    echo ""
    echo -e "${CYAN}📱 PARA EJECUTAR FLUTTER APP:${NC}"
    echo -e "${WHITE}   cd audio_recorder_app && flutter run -d e9bd3f17${NC}"
    echo ""
    echo -e "${CYAN}🔍 COMANDOS ÚTILES:${NC}"
    echo -e "${WHITE}   ./scripts/watch-logs.sh                    # Ver logs en terminal${NC}"
    echo -e "${WHITE}   ./scripts/watch-logs.sh -u user@email.com  # Filtrar por usuario${NC}"
    echo -e "${WHITE}   docker logs audio-mqtt-logger --tail 20    # Ver logs MQTT${NC}"
    echo ""
    echo -e "${YELLOW}⚡ EVENTOS DE PRUEBA: Generando automáticamente cada 2-8 segundos${NC}"
    echo -e "${YELLOW}📊 DASHBOARD: Actualizando cada 2 segundos${NC}"
    echo ""
    echo -e "${WHITE}=================================================================${NC}"
    echo -e "${GREEN}✅ SISTEMA LISTO - Presiona Ctrl+C para ver logs en tiempo real${NC}"
    echo -e "${WHITE}=================================================================${NC}"
    
    # Esperar input del usuario
    echo ""
    echo -e "${CYAN}Presiona ENTER para continuar viendo logs de contenedores...${NC}"
    read -r
    
    echo ""
    echo -e "${BLUE}📊 LOGS EN TIEMPO REAL DE TODOS LOS CONTENEDORES${NC}"
    echo -e "${WHITE}=================================================${NC}"
    echo -e "${YELLOW}💡 Tip: Abre ${WHITE}http://localhost:8080${YELLOW} en tu navegador para el dashboard visual${NC}"
    echo ""
    
    # Mostrar logs en tiempo real de todos los contenedores
    docker compose logs -f --tail 50
}

# Ejecutar función principal
main "$@" 