#!/bin/bash

# 🎫 Verdex Framework IA - Quick Ticket Creator
# Crea tickets Jira instantáneamente sin romper el flujo de desarrollo

set -euo pipefail

readonly FRAMEWORK_DIR=".verdex-ai"
readonly AGENT_LOG="$FRAMEWORK_DIR/sessions/agent-interactions.log"
readonly CONFIG_FILE="$FRAMEWORK_DIR/config/framework-settings.yaml"
readonly TEMPLATES_DIR="$FRAMEWORK_DIR/templates/jira-tickets"

# Colores
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[0;33m'
readonly RED='\033[0;31m'
readonly PURPLE='\033[0;35m'
readonly NC='\033[0m'

# Logging
log_interaction() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] INFO QUICK_TICKET - $1" >> "$AGENT_LOG" 2>/dev/null || true
}

# Banner
show_banner() {
    echo -e "${PURPLE}🎫 VERDEX QUICK TICKET CREATOR${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Detectar tipo de trabajo automáticamente
detect_work_type() {
    echo -e "${YELLOW}🔍 ¿Qué tipo de trabajo vas a hacer?${NC}"
    echo ""
    echo "1) 🐛 Bug/Fix - Corregir algo que no funciona"
    echo "2) ✨ Feature - Nueva funcionalidad"
    echo "3) 📚 Documentation - Documentación"
    echo "4) 🔧 Refactor - Mejorar código existente"
    echo "5) 🧪 Testing - Pruebas y tests"
    echo "6) 🚀 Deploy - Despliegue y configuración"
    echo "7) 🎨 UI/UX - Interfaz de usuario"
    echo "8) 📊 Analytics - Métricas y análisis"
    echo ""
    read -p "Selecciona (1-8): " choice
    
    case $choice in
        1) echo "bug" ;;
        2) echo "feature" ;;
        3) echo "documentation" ;;
        4) echo "refactor" ;;
        5) echo "testing" ;;
        6) echo "deploy" ;;
        7) echo "ui-ux" ;;
        8) echo "analytics" ;;
        *) echo "feature" ;;
    esac
}

# Generar ID de ticket automático
generate_ticket_id() {
    local work_type="$1"
    local timestamp=$(date "+%m%d%H%M")
    
    case $work_type in
        "bug") echo "BUG-$timestamp" ;;
        "feature") echo "FEAT-$timestamp" ;;
        "documentation") echo "DOC-$timestamp" ;;
        "refactor") echo "REF-$timestamp" ;;
        "testing") echo "TEST-$timestamp" ;;
        "deploy") echo "DEP-$timestamp" ;;
        "ui-ux") echo "UI-$timestamp" ;;
        "analytics") echo "ANAL-$timestamp" ;;
        *) echo "TASK-$timestamp" ;;
    esac
}

# Crear ticket local rápido
create_quick_ticket() {
    local work_type="$1"
    local title="$2"
    local description="$3"
    local priority="${4:-medium}"
    
    local ticket_id=$(generate_ticket_id "$work_type")
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Crear archivo de ticket local
    local ticket_file="$FRAMEWORK_DIR/sessions/tickets/$ticket_id.yaml"
    mkdir -p "$FRAMEWORK_DIR/sessions/tickets"
    
    cat > "$ticket_file" << EOF
# 🎫 Verdex Framework IA - Ticket Local
ticket_id: $ticket_id
type: $work_type
title: "$title"
description: |
  $description
priority: $priority
status: created
created_at: $timestamp
creator: $(whoami)
estimated_hours: 0
actual_hours: 0
tags: []
notes: []
commits: []
EOF

    echo "$ticket_id"
}

# Crear ticket en Jira (usando MCP Atlassian)
create_jira_ticket() {
    local work_type="$1"
    local title="$2"
    local description="$3"
    local priority="$4"
    
    echo -e "${BLUE}🔗 Intentando crear ticket en Jira...${NC}"
    
    # Detectar issue type para Jira
    local jira_issue_type
    case $work_type in
        "bug") jira_issue_type="Bug" ;;
        "feature") jira_issue_type="Story" ;;
        "documentation") jira_issue_type="Task" ;;
        *) jira_issue_type="Task" ;;
    esac
    
    # TODO: Integrar con MCP Atlassian
    # Por ahora crear ticket local y sugerir creación manual en Jira
    echo -e "${YELLOW}⚠️  Crear manualmente en Jira:${NC}"
    echo "   Issue Type: $jira_issue_type"
    echo "   Summary: $title"
    echo "   Description: $description"
    echo "   Priority: $priority"
    echo ""
    echo -e "${BLUE}💡 Usa este comando más tarde para crear en Jira:${NC}"
    echo "   .verdex-ai/scripts/sync-jira-tickets.sh"
}

# Modo interactivo rápido
interactive_mode() {
    show_banner
    
    echo -e "${YELLOW}⚡ Modo Rápido - Crear ticket en 30 segundos${NC}"
    echo ""
    
    # Detectar tipo de trabajo
    local work_type=$(detect_work_type)
    echo ""
    
    # Título rápido
    echo -e "${YELLOW}📝 Título del ticket (describe en pocas palabras):${NC}"
    read -p "> " title
    
    if [ -z "$title" ]; then
        echo -e "${RED}❌ Título requerido${NC}"
        exit 1
    fi
    
    # Descripción opcional
    echo ""
    echo -e "${YELLOW}📋 Descripción (opcional, Enter para omitir):${NC}"
    read -p "> " description
    
    if [ -z "$description" ]; then
        description="Auto-generado por Verdex Framework IA"
    fi
    
    # Prioridad
    echo ""
    echo -e "${YELLOW}🚨 Prioridad (1=alta, 2=media, 3=baja, Enter=media):${NC}"
    read -p "> " priority_num
    
    local priority="medium"
    case $priority_num in
        1) priority="high" ;;
        2) priority="medium" ;;
        3) priority="low" ;;
        *) priority="medium" ;;
    esac
    
    # Crear ticket
    echo ""
    echo -e "${BLUE}🔄 Creando ticket...${NC}"
    
    local ticket_id=$(create_quick_ticket "$work_type" "$title" "$description" "$priority")
    
    # Log de actividad
    log_interaction "TICKET_CREATED - ID: $ticket_id, Type: $work_type, Title: $title"
    
    # Mostrar resultado
    echo ""
    echo -e "${GREEN}✅ Ticket creado exitosamente!${NC}"
    echo ""
    echo -e "${PURPLE}🎫 ID: $ticket_id${NC}"
    echo -e "${BLUE}📋 Título: $title${NC}"
    echo -e "${YELLOW}🔥 Prioridad: $priority${NC}"
    echo ""
    echo -e "${GREEN}🚀 Ya puedes hacer commits con: $ticket_id${NC}"
    echo -e "${BLUE}💡 Ejemplo: git commit -m \"$ticket_id: implementar nueva feature\"${NC}"
    echo ""
    
    # Opción de crear en Jira
    echo -e "${YELLOW}¿Crear también en Jira? (y/N):${NC}"
    read -p "> " create_jira
    
    if [[ "$create_jira" =~ ^[Yy]$ ]]; then
        create_jira_ticket "$work_type" "$title" "$description" "$priority"
    fi
    
    # Copiar ID al clipboard si está disponible
    if command -v xclip >/dev/null 2>&1; then
        echo "$ticket_id" | xclip -selection clipboard
        echo -e "${GREEN}📋 ID copiado al clipboard${NC}"
    elif command -v pbcopy >/dev/null 2>&1; then
        echo "$ticket_id" | pbcopy
        echo -e "${GREEN}📋 ID copiado al clipboard${NC}"
    fi
}

# Modo express (una línea)
express_mode() {
    local title="$1"
    local work_type="${2:-feature}"
    
    local ticket_id=$(create_quick_ticket "$work_type" "$title" "Auto-generado via express mode" "medium")
    
    echo "$ticket_id"
    log_interaction "EXPRESS_TICKET - ID: $ticket_id, Title: $title"
}

# Listar tickets locales
list_tickets() {
    echo -e "${PURPLE}📋 Tickets Locales - Verdex Framework IA${NC}"
    echo ""
    
    local tickets_dir="$FRAMEWORK_DIR/sessions/tickets"
    
    if [ ! -d "$tickets_dir" ] || [ -z "$(ls -A "$tickets_dir" 2>/dev/null)" ]; then
        echo "⚠️  No hay tickets locales aún."
        echo "💡 Crea uno con: .verdex-ai/scripts/quick-ticket.sh"
        return
    fi
    
    echo -e "${BLUE}Estado | ID | Tipo | Título${NC}"
    echo "───────┼─────────────┼─────────────┼────────────────────"
    
    for ticket_file in "$tickets_dir"/*.yaml; do
        if [ -f "$ticket_file" ]; then
            local ticket_id=$(grep "^ticket_id:" "$ticket_file" | cut -d' ' -f2)
            local type=$(grep "^type:" "$ticket_file" | cut -d' ' -f2)
            local title=$(grep "^title:" "$ticket_file" | cut -d'"' -f2)
            local status=$(grep "^status:" "$ticket_file" | cut -d' ' -f2)
            
            local status_icon
            case $status in
                "created") status_icon="🆕" ;;
                "in_progress") status_icon="🔄" ;;
                "done") status_icon="✅" ;;
                *) status_icon="❓" ;;
            esac
            
            printf "%-7s │ %-11s │ %-11s │ %-30s\n" "$status_icon" "$ticket_id" "$type" "$title"
        fi
    done
}

# Función de ayuda
show_help() {
    echo -e "${BLUE}🎫 Verdex Framework IA - Quick Ticket Creator${NC}"
    echo ""
    echo "Uso:"
    echo "  $0                               # Modo interactivo"
    echo "  $0 'título del ticket'           # Modo express (feature)"
    echo "  $0 'título' bug                  # Modo express con tipo"
    echo "  $0 --list                        # Listar tickets locales"
    echo "  $0 --help                        # Mostrar esta ayuda"
    echo ""
    echo "Funcionalidades:"
    echo "  ✅ Creación de tickets en 30 segundos"
    echo "  ✅ IDs automáticos únicos"
    echo "  ✅ Integración con git hooks"
    echo "  ✅ Templates automáticos por tipo"
    echo "  ✅ Sync opcional con Jira"
    echo ""
    echo "Tipos soportados:"
    echo "  bug, feature, documentation, refactor, testing, deploy, ui-ux, analytics"
}

# Manejo de argumentos
case "${1:-}" in
    --list|-l)
        list_tickets
        ;;
    --help|-h)
        show_help
        ;;
    "")
        interactive_mode
        ;;
    *)
        if [ $# -eq 1 ]; then
            express_mode "$1"
        elif [ $# -eq 2 ]; then
            express_mode "$1" "$2"
        else
            echo -e "${RED}❌ Demasiados argumentos${NC}"
            show_help
        fi
        ;;
esac 