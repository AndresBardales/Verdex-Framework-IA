#!/bin/bash
# Script para ver logs en tiempo real con colores
# Uso: ./watch-logs.sh [user_id]

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo "📊 Monitor de Logs en Tiempo Real"
    echo ""
    echo "Uso: $0 [opciones]"
    echo ""
    echo "Opciones:"
    echo "  -u, --user USER_ID     Filtrar por usuario específico"
    echo "  -t, --topic TOPIC      Filtrar por tópico"
    echo "  -f, --file FILE        Ver archivo específico"
    echo "  -a, --all             Ver todos los logs"
    echo "  -h, --help            Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 -u andresbardales15@gmail.com"
    echo "  $0 -t ui/interactions"
    echo "  $0 -f auth_events.log"
    echo "  $0 -a"
}

# Función para colorear logs
colorize_log() {
    while IFS= read -r line; do
        # Colorear por tipo de evento
        if [[ "$line" =~ "ui/interactions" ]]; then
            echo -e "${BLUE}[UI]${NC} $line"
        elif [[ "$line" =~ "audios/recordings" ]]; then
            echo -e "${GREEN}[AUDIO]${NC} $line"
        elif [[ "$line" =~ "auth/events" ]]; then
            echo -e "${RED}[AUTH]${NC} $line"
        elif [[ "$line" =~ "sessions/" ]]; then
            echo -e "${PURPLE}[SESSION]${NC} $line"
        elif [[ "$line" =~ "automation/" ]]; then
            echo -e "${YELLOW}[AUTO]${NC} $line"
        elif [[ "$line" =~ "webhooks/" ]]; then
            echo -e "${CYAN}[WEBHOOK]${NC} $line"
        elif [[ "$line" =~ "ERROR" || "$line" =~ "error" ]]; then
            echo -e "${RED}[ERROR]${NC} $line"
        else
            echo -e "${WHITE}[LOG]${NC} $line"
        fi
    done
}

# Función para mostrar estadísticas
show_stats() {
    echo -e "${WHITE}📊 Estadísticas de Logs${NC}"
    echo "===================="
    
    # Contar archivos de logs
    log_files=$(find logs/ -name "*.log" -type f | wc -l)
    echo -e "📁 Archivos de logs: ${GREEN}$log_files${NC}"
    
    # Tamaño total de logs
    total_size=$(du -sh logs/ | cut -f1)
    echo -e "💾 Tamaño total: ${GREEN}$total_size${NC}"
    
    # Logs de hoy
    today=$(date +%Y-%m-%d)
    if [ -d "logs/$today" ]; then
        today_files=$(ls logs/$today/*.log 2>/dev/null | wc -l)
        echo -e "📅 Logs de hoy: ${GREEN}$today_files${NC} archivos"
    fi
    
    echo ""
}

# Función principal
main() {
    USER_FILTER=""
    TOPIC_FILTER=""
    FILE_FILTER=""
    SHOW_ALL=false
    
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -u|--user)
                USER_FILTER="$2"
                shift 2
                ;;
            -t|--topic)
                TOPIC_FILTER="$2"
                shift 2
                ;;
            -f|--file)
                FILE_FILTER="$2"
                shift 2
                ;;
            -a|--all)
                SHOW_ALL=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Mostrar header
    clear
    echo -e "${WHITE}🚀 Monitor de Logs en Tiempo Real${NC}"
    echo -e "${WHITE}====================================${NC}"
    echo -e "⏰ Iniciado: $(date)"
    echo -e "📂 Directorio: $(pwd)/logs/"
    echo ""
    
    # Mostrar estadísticas
    show_stats
    
    # Determinar qué logs mostrar
    if [ ! -z "$FILE_FILTER" ]; then
        # Archivo específico
        LOG_FILE="logs/$FILE_FILTER"
        if [ ! -f "$LOG_FILE" ]; then
            LOG_FILE="logs/$(date +%Y-%m-%d)/$FILE_FILTER"
        fi
        
        if [ -f "$LOG_FILE" ]; then
            echo -e "${GREEN}📄 Monitoreando archivo: $LOG_FILE${NC}"
            echo ""
            tail -f "$LOG_FILE" | colorize_log
        else
            echo -e "${RED}❌ Archivo no encontrado: $FILE_FILTER${NC}"
            exit 1
        fi
        
    elif [ "$SHOW_ALL" = true ]; then
        # Todos los logs
        echo -e "${GREEN}📊 Monitoreando todos los logs${NC}"
        echo ""
        find logs/ -name "*.log" -type f | xargs tail -f | colorize_log
        
    else
        # Logs del día actual
        today=$(date +%Y-%m-%d)
        TODAY_DIR="logs/$today"
        
        if [ -d "$TODAY_DIR" ]; then
            echo -e "${GREEN}📅 Monitoreando logs de hoy: $today${NC}"
            echo ""
            
            # Aplicar filtros
            if [ ! -z "$USER_FILTER" ]; then
                echo -e "${BLUE}🔍 Filtrando por usuario: $USER_FILTER${NC}"
                find "$TODAY_DIR" -name "*.log" -type f | xargs tail -f | grep "$USER_FILTER" | colorize_log
            elif [ ! -z "$TOPIC_FILTER" ]; then
                echo -e "${BLUE}🔍 Filtrando por tópico: $TOPIC_FILTER${NC}"
                find "$TODAY_DIR" -name "*.log" -type f | xargs tail -f | grep "$TOPIC_FILTER" | colorize_log
            else
                find "$TODAY_DIR" -name "*.log" -type f | xargs tail -f | colorize_log
            fi
        else
            echo -e "${YELLOW}⚠️ No hay logs para hoy. Creando directorio...${NC}"
            mkdir -p "$TODAY_DIR"
            echo -e "${GREEN}✅ Esperando logs...${NC}"
            echo ""
            
            # Monitorear cuando aparezcan logs
            while true; do
                if [ -f "$TODAY_DIR/all_topics.log" ]; then
                    tail -f "$TODAY_DIR/all_topics.log" | colorize_log
                    break
                fi
                sleep 1
            done
        fi
    fi
}

# Manejador de Ctrl+C
trap 'echo -e "\n${WHITE}👋 Cerrando monitor de logs...${NC}"; exit 0' INT

# Ejecutar función principal
main "$@" 