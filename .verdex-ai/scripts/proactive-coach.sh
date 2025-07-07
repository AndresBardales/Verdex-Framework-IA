#!/bin/bash

# 🧠 Verdex Framework IA - Proactive Coach
# Sistema que detecta patrones y sugiere mejoras automáticamente

set -euo pipefail

readonly FRAMEWORK_DIR=".verdex-ai"
readonly AGENT_LOG="$FRAMEWORK_DIR/sessions/agent-interactions.log"
readonly PATTERNS_FILE="$FRAMEWORK_DIR/sessions/user-patterns.json"
readonly COACH_LOG="$FRAMEWORK_DIR/sessions/coaching-insights.md"

# Colores
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[0;33m'
readonly RED='\033[0;31m'
readonly PURPLE='\033[0;35m'
readonly NC='\033[0m'

# Logging
log_coaching() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] COACH - $1" >> "$AGENT_LOG" 2>/dev/null || true
}

# Detectar anti-patrones
detect_bad_practices() {
    local issues=()
    
    # Verificar commits sin tickets
    if git log --oneline --since="1 day ago" | grep -vE "(FEAT-|BUG-|DOC-|REF-|TEST-|DEP-|UI-|ANAL-|#[0-9]+|ticket [0-9]+)" >/dev/null 2>&1; then
        issues+=("commits_without_tickets")
    fi
    
    # Verificar commits muy grandes
    large_commits=$(git log --oneline --since="1 day ago" --pretty=format:"%H" | head -5 | while read hash; do
        changes=$(git show --stat "$hash" | tail -1 | grep -oE '[0-9]+ insertions|[0-9]+ deletions' | grep -oE '[0-9]+' | awk '{sum+=$1} END {print sum}')
        if [ "${changes:-0}" -gt 500 ]; then
            echo "large_commit"
        fi
    done)
    
    if [ -n "$large_commits" ]; then
        issues+=("large_commits")
    fi
    
    # Verificar documentación faltante
    if [ ! -f "$COACH_LOG" ] || [ $(wc -l < "$COACH_LOG") -lt 5 ]; then
        issues+=("missing_documentation")
    fi
    
    printf "%s\n" "${issues[@]}"
}

# Generar sugerencias específicas
generate_suggestions() {
    local bad_practices="$1"
    local suggestions=()
    
    while IFS= read -r practice; do
        case "$practice" in
            "commits_without_tickets")
                suggestions+=("🎫 Crea tickets antes de cada commit: .verdex-ai/scripts/quick-ticket.sh")
                suggestions+=("🔒 Los git hooks están activos para prevenir esto automáticamente")
                ;;
            "large_commits")
                suggestions+=("📦 Divide commits grandes en partes más pequeñas")
                suggestions+=("🎯 Un commit = una funcionalidad específica")
                ;;
            "missing_documentation")
                suggestions+=("📝 Documenta tus sesiones: .verdex-ai/scripts/auto-chat-documenter.sh")
                suggestions+=("📊 Las métricas se alimentan automáticamente de la documentación")
                ;;
        esac
    done <<< "$bad_practices"
    
    printf "%s\n" "${suggestions[@]}"
}

# Analizar patrones de productividad
analyze_productivity_patterns() {
    echo -e "${BLUE}🔍 Analizando patrones de productividad...${NC}"
    
    # Obtener commits por hora
    local current_hour=$(date +%H)
    local commits_this_hour=$(git log --oneline --since="1 hour ago" | wc -l)
    
    # Analizar frecuencia de sesiones
    if [ -f "$PATTERNS_FILE" ]; then
        python3 << 'PYTHON_SCRIPT'
import json
import sys
from datetime import datetime, timedelta

try:
    with open(".verdex-ai/sessions/user-patterns.json", 'r') as f:
        patterns = json.load(f)
    
    # Análisis de horas productivas
    hours = patterns.get("productivity_patterns", {}).get("most_productive_hours", [])
    if len(hours) >= 5:
        from collections import Counter
        hour_counts = Counter(hours)
        best_hours = hour_counts.most_common(3)
        
        current_hour = datetime.now().hour
        
        print("🕐 ANÁLISIS DE HORAS PRODUCTIVAS:")
        for hour, count in best_hours:
            if hour == current_hour:
                print(f"✅ Hora actual ({hour}:00) es una de tus horas más productivas!")
            else:
                print(f"💡 {hour}:00 es productiva para ti ({count} commits históricos)")
        
        # Sugerencia de horario
        best_hour = best_hours[0][0]
        if current_hour != best_hour:
            time_diff = abs(current_hour - best_hour)
            if time_diff <= 2:
                print(f"⏰ Considera trabajar en {best_hour}:00 (tu hora más productiva)")
    
    # Análisis de tipos de sesión
    session_types = patterns.get("session_types", {})
    if session_types:
        most_common = max(session_types, key=session_types.get)
        count = session_types[most_common]
        
        print(f"\n🎯 PATRÓN DE TRABAJO DETECTADO:")
        print(f"   Tu trabajo principal: {most_common} ({count} sesiones)")
        
        if count >= 5:
            print(f"💡 Considera crear templates para sesiones de {most_common}")

except Exception as e:
    print(f"📊 Acumulando datos de patrones... (necesitas más actividad)")
PYTHON_SCRIPT
    fi
}

# Sugerir automatizaciones
suggest_automations() {
    echo -e "${YELLOW}🤖 Detectando oportunidades de automatización...${NC}"
    
    # Analizar logs para actividades repetitivas
    if [ -f "$AGENT_LOG" ]; then
        # Buscar patrones repetitivos
        local repeated_actions=$(grep -E "(CHAT_DOCUMENTED|TICKET_CREATED|COMMIT_ALLOWED)" "$AGENT_LOG" | cut -d'-' -f3 | sort | uniq -c | sort -nr | head -3)
        
        if [ -n "$repeated_actions" ]; then
            echo "🔄 ACTIVIDADES REPETITIVAS DETECTADAS:"
            echo "$repeated_actions" | while read count action; do
                if [ "$count" -ge 3 ]; then
                    case "$action" in
                        *"CHAT_DOCUMENTED"*)
                            echo "💡 $count documentaciones → Automatizar con triggers de sesión"
                            ;;
                        *"TICKET_CREATED"*)
                            echo "💡 $count tickets creados → Crear templates por tipo"
                            ;;
                        *"COMMIT_ALLOWED"*)
                            echo "💡 $count commits → Configurar aliases de git personalizados"
                            ;;
                    esac
                fi
            done
        fi
    fi
    
    # Sugerir automatizaciones basadas en archivos del proyecto
    echo ""
    echo "🎯 AUTOMATIZACIONES SUGERIDAS:"
    
    if [ -f "package.json" ]; then
        echo "   • Configurar git hooks automáticos para linting"
        echo "   • Automatizar tests pre-commit"
    fi
    
    if [ -d ".github" ]; then
        echo "   • Configurar CI/CD automático para deploys"
        echo "   • Automatizar creación de tickets desde PR"
    fi
    
    if [ -f "requirements.txt" ] || [ -f "Pipfile" ]; then
        echo "   • Automatizar updates de dependencias"
        echo "   • Configurar security scans automáticos"
    fi
}

# Crear coaching insights
create_coaching_entry() {
    local insights="$1"
    local suggestions="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Crear archivo de coaching si no existe
    if [ ! -f "$COACH_LOG" ]; then
        cat > "$COACH_LOG" << 'EOF'
# 🧠 Verdex Framework IA - Coaching Insights

> **Sistema de coaching proactivo que aprende de tus patrones**
> 
> 🎯 **Objetivo**: Mejorar productividad y adoptar mejores prácticas automáticamente

---

EOF
    fi
    
    # Agregar nueva entrada
    cat >> "$COACH_LOG" << EOF

## 📅 $timestamp - Análisis Automático

### 🔍 Insights Detectados
$insights

### 💡 Sugerencias Automáticas
$suggestions

### 📊 Métricas de Sesión
- **Hora de análisis**: $(date "+%H:%M")
- **Commits hoy**: $(git log --oneline --since="today" | wc -l)
- **Última actividad**: $(git log -1 --pretty=format:"%ar" 2>/dev/null || echo "No activity")

---
EOF

    log_coaching "COACHING_ENTRY_CREATED - Insights: $(echo "$insights" | wc -l) lines"
}

# Modo coaching proactivo
proactive_coaching() {
    echo -e "${PURPLE}🧠 VERDEX PROACTIVE COACH${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Detectar problemas
    local bad_practices=$(detect_bad_practices)
    local suggestions=""
    
    if [ -n "$bad_practices" ]; then
        echo -e "${YELLOW}⚠️  Anti-patrones detectados:${NC}"
        while IFS= read -r practice; do
            case "$practice" in
                "commits_without_tickets")
                    echo "   🚫 Commits sin referencia a tickets"
                    ;;
                "large_commits")
                    echo "   📦 Commits demasiado grandes detectados"
                    ;;
                "missing_documentation")
                    echo "   📝 Documentación insuficiente"
                    ;;
            esac
        done <<< "$bad_practices"
        
        echo ""
        suggestions=$(generate_suggestions "$bad_practices")
        echo -e "${GREEN}🎯 Sugerencias automáticas:${NC}"
        while IFS= read -r suggestion; do
            echo "   $suggestion"
        done <<< "$suggestions"
    else
        echo -e "${GREEN}✅ No se detectaron anti-patrones. ¡Excelente trabajo!${NC}"
        suggestions="🎉 Mantén las buenas prácticas actuales"
    fi
    
    echo ""
    
    # Análisis de patrones
    analyze_productivity_patterns
    echo ""
    
    # Sugerencias de automatización
    suggest_automations
    
    # Crear entrada de coaching
    local insights_text="Anti-patrones: ${bad_practices:-"Ninguno detectado"}"
    create_coaching_entry "$insights_text" "$suggestions"
    
    echo ""
    echo -e "${GREEN}✨ Coaching proactivo completado${NC}"
    echo -e "${BLUE}📄 Ver historial completo en: $COACH_LOG${NC}"
    
    log_coaching "PROACTIVE_SESSION_COMPLETED"
}

# Función de ayuda
show_help() {
    echo -e "${BLUE}🧠 Verdex Framework IA - Proactive Coach${NC}"
    echo ""
    echo "Uso:"
    echo "  $0                    # Ejecutar coaching proactivo"
    echo "  $0 --analyze          # Solo análisis de patrones" 
    echo "  $0 --suggestions      # Solo sugerencias de automatización"
    echo "  $0 --help             # Mostrar esta ayuda"
    echo ""
    echo "Funcionalidades automáticas:"
    echo "  ✅ Detección de anti-patrones"
    echo "  ✅ Análisis de productividad personal"
    echo "  ✅ Sugerencias de automatización"
    echo "  ✅ Coaching personalizado continuo"
    echo "  ✅ Logging de insights para mejora"
}

# Manejo de argumentos
case "${1:-}" in
    --analyze)
        analyze_productivity_patterns
        ;;
    --suggestions)
        suggest_automations
        ;;
    --help|-h)
        show_help
        ;;
    *)
        proactive_coaching
        ;;
esac 