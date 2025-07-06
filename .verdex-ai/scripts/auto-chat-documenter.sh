#!/bin/bash

# 💬 Verdex Framework IA - Auto Chat Documenter
# Documenta automáticamente cada sesión de chat con estructura estándar

set -euo pipefail

readonly FRAMEWORK_DIR=".verdex-ai"
readonly CHAT_LOG="$FRAMEWORK_DIR/sessions/chat-documentation.md"
readonly AGENT_LOG="$FRAMEWORK_DIR/sessions/agent-interactions.log"
readonly PATTERNS_FILE="$FRAMEWORK_DIR/sessions/user-patterns.json"

# Colores
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[0;33m'
readonly PURPLE='\033[0;35m'
readonly NC='\033[0m'

# Función de logging
log_interaction() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] INFO CHAT_DOC - $1" >> "$AGENT_LOG" 2>/dev/null || true
}

# Detectar tipo de sesión automáticamente basado en contenido
detect_session_type() {
    local content="$1"
    
    # Palabras clave para cada tipo de sesión
    if echo "$content" | grep -iE "(cliente|client|customer|presentación|demo|meeting)" >/dev/null; then
        echo "cliente"
    elif echo "$content" | grep -iE "(team|equipo|standup|retrospective|planning|scrum)" >/dev/null; then
        echo "sesion-teams"
    elif echo "$content" | grep -iE "(debug|bug|issue|problema|error|testing|test)" >/dev/null; then
        echo "sesion-trabajo-individual" 
    elif echo "$content" | grep -iE "(feature|nueva|implementar|desarrollo|code|coding)" >/dev/null; then
        echo "sesion-trabajo-individual"
    elif echo "$content" | grep -iE "(documentación|docs|documentation|guide|manual)" >/dev/null; then
        echo "documentacion"
    else
        echo "otra"
    fi
}

# Generar key summary automático
generate_key_summary() {
    local content="$1"
    local max_length=80
    
    # Extraer primeras palabras significativas
    local summary=$(echo "$content" | head -1 | sed 's/[^a-zA-Z0-9 ]//g' | cut -c1-$max_length)
    
    # Si es muy corto, tomar más contexto
    if [ ${#summary} -lt 20 ]; then
        summary=$(echo "$content" | head -3 | tr '\n' ' ' | sed 's/[^a-zA-Z0-9 ]//g' | cut -c1-$max_length)
    fi
    
    echo "$summary..."
}

# Actualizar patrones de usuario
update_user_patterns() {
    local session_type="$1"
    local key_summary="$2"
    local content="$3"
    
    # Crear archivo de patrones si no existe
    if [ ! -f "$PATTERNS_FILE" ]; then
        cat > "$PATTERNS_FILE" << 'EOF'
{
    "session_types": {},
    "common_keywords": {},
    "frequent_requests": [],
    "productivity_patterns": {
        "most_productive_hours": [],
        "average_session_length": 0,
        "common_topics": []
    },
    "last_updated": ""
}
EOF
    fi
    
    # Actualizar patrones usando Python
    python3 << PYTHON_SCRIPT
import json
import re
from datetime import datetime
from collections import Counter

patterns_file = "$PATTERNS_FILE"
session_type = "$session_type"
key_summary = "$key_summary"
content = "$content"

try:
    with open(patterns_file, 'r') as f:
        patterns = json.load(f)
except:
    patterns = {
        "session_types": {},
        "common_keywords": {},
        "frequent_requests": [],
        "productivity_patterns": {
            "most_productive_hours": [],
            "average_session_length": 0,
            "common_topics": []
        }
    }

# Actualizar tipos de sesión
if "session_types" not in patterns:
    patterns["session_types"] = {}
patterns["session_types"][session_type] = patterns["session_types"].get(session_type, 0) + 1

# Extraer y contar keywords
words = re.findall(r'\b\w+\b', content.lower())
significant_words = [w for w in words if len(w) > 3 and w not in ['this', 'that', 'with', 'from', 'they', 'have', 'will', 'been', 'were']]

if "common_keywords" not in patterns:
    patterns["common_keywords"] = {}

for word in significant_words[:10]:  # Top 10 palabras por sesión
    patterns["common_keywords"][word] = patterns["common_keywords"].get(word, 0) + 1

# Detectar requests frecuentes
request_patterns = [
    "create", "implement", "fix", "debug", "test", "document", 
    "deploy", "refactor", "optimize", "analyze", "review"
]

for pattern in request_patterns:
    if pattern in content.lower():
        if "frequent_requests" not in patterns:
            patterns["frequent_requests"] = []
        if pattern not in patterns["frequent_requests"]:
            patterns["frequent_requests"].append(pattern)

# Actualizar timestamp
patterns["last_updated"] = datetime.now().isoformat()

# Agregar hora de sesión para análisis de productividad
current_hour = datetime.now().hour
if "productivity_patterns" not in patterns:
    patterns["productivity_patterns"] = {"most_productive_hours": []}
patterns["productivity_patterns"]["most_productive_hours"].append(current_hour)

with open(patterns_file, 'w') as f:
    json.dump(patterns, f, indent=2)

print(f"📊 Patrones actualizados: {session_type}, keywords detectados: {len(significant_words)}")
PYTHON_SCRIPT

}

# Crear entrada de documentación automática
create_chat_entry() {
    local key_summary="$1"
    local session_type="$2"
    local content="$3"
    local ticket_ref="$4"
    
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local date_only=$(date "+%Y-%m-%d")
    
    # Crear archivo de documentación si no existe
    if [ ! -f "$CHAT_LOG" ]; then
        cat > "$CHAT_LOG" << 'EOF'
# 💬 Verdex Framework IA - Documentación de Chats

> **Auto-documentación de todas las sesiones de trabajo con agentes IA**
> 
> 📊 **Estructura**: Key Summary | Fecha | Tipo de Reunión | Ticket | Detalles

---

EOF
    fi
    
    # Crear entrada con estructura estándar
    cat >> "$CHAT_LOG" << EOF

## 📅 $date_only - $key_summary

**🔑 Key Summary**: $key_summary  
**📅 Fecha**: $timestamp  
**👥 Tipo de Reunión**: $session_type  
**🎫 Ticket**: $ticket_ref  

### 💼 Detalles de la Sesión
\`\`\`
$content
\`\`\`

### 📊 Auto-análisis
- **Duración estimada**: $(date "+%H:%M")
- **Palabras clave detectadas**: $(echo "$content" | tr ' ' '\n' | sort | uniq -c | sort -nr | head -3 | tr '\n' ' ')
- **Patrón detectado**: $(detect_session_type "$content")

---
EOF

    echo -e "${GREEN}✅ Chat documentado automáticamente${NC}"
    echo -e "${BLUE}📍 Tipo detectado: $session_type${NC}"
    echo -e "${PURPLE}🔑 Summary: $key_summary${NC}"
}

# Sugerir mejoras basadas en patrones
suggest_improvements() {
    if [ ! -f "$PATTERNS_FILE" ]; then
        return
    fi
    
    echo -e "${YELLOW}💡 Sugerencias automáticas basadas en tus patrones:${NC}"
    
    # Leer patrones y generar sugerencias
    python3 << PYTHON_SCRIPT
import json
from collections import Counter

try:
    with open("$PATTERNS_FILE", 'r') as f:
        patterns = json.load(f)
    
    # Sugerencias basadas en session_types
    session_counts = patterns.get("session_types", {})
    if session_counts:
        most_common = max(session_counts, key=session_counts.get)
        print(f"  • Tu tipo de sesión más común es '{most_common}' - considera crear templates específicos")
    
    # Sugerencias basadas en keywords
    keywords = patterns.get("common_keywords", {})
    if keywords:
        top_keywords = sorted(keywords.items(), key=lambda x: x[1], reverse=True)[:3]
        print(f"  • Palabras más usadas: {', '.join([k for k, v in top_keywords])} - considera crear shortcuts")
    
    # Sugerencias de productividad
    hours = patterns.get("productivity_patterns", {}).get("most_productive_hours", [])
    if hours:
        hour_counts = Counter(hours)
        productive_hour = hour_counts.most_common(1)[0][0]
        print(f"  • Tu hora más productiva es {productive_hour}:00 - programa sesiones importantes entonces")
        
except Exception as e:
    print(f"  • Acumulando datos de patrones... (necesitas más sesiones para sugerencias)")
PYTHON_SCRIPT
}

# Función principal para auto-documentar
auto_document_chat() {
    local content="${1:-}"
    local ticket_ref="${2:-sin-ticket}"
    
    if [ -z "$content" ]; then
        echo -e "${YELLOW}💬 Iniciando auto-documentación de chat...${NC}"
        echo "📝 Pega el contenido de tu sesión (Ctrl+D para terminar):"
        content=$(cat)
    fi
    
    # Detectar automáticamente tipo de sesión y generar summary
    local session_type=$(detect_session_type "$content")
    local key_summary=$(generate_key_summary "$content")
    
    # Crear documentación
    create_chat_entry "$key_summary" "$session_type" "$content" "$ticket_ref"
    
    # Actualizar patrones
    update_user_patterns "$session_type" "$key_summary" "$content"
    
    # Log de la actividad
    log_interaction "CHAT_DOCUMENTED - Type: $session_type, Summary: $key_summary"
    
    # Mostrar sugerencias
    suggest_improvements
    
    echo ""
    echo -e "${GREEN}✨ Documentación automática completada${NC}"
    echo -e "${BLUE}📄 Ver en: $CHAT_LOG${NC}"
}

# Función para mostrar estadísticas
show_chat_stats() {
    echo -e "${PURPLE}📊 Estadísticas de Chats - Verdex Framework IA${NC}"
    echo ""
    
    if [ ! -f "$PATTERNS_FILE" ]; then
        echo "⚠️  No hay datos suficientes aún. Documenta más sesiones para ver estadísticas."
        return
    fi
    
    python3 << PYTHON_SCRIPT
import json
from collections import Counter

try:
    with open("$PATTERNS_FILE", 'r') as f:
        patterns = json.load(f)
    
    print("📊 ESTADÍSTICAS DE SESIONES:")
    print("=" * 50)
    
    # Session types
    session_types = patterns.get("session_types", {})
    if session_types:
        print("\n🎯 Tipos de sesión:")
        for session_type, count in sorted(session_types.items(), key=lambda x: x[1], reverse=True):
            print(f"   {session_type}: {count} sesiones")
    
    # Top keywords
    keywords = patterns.get("common_keywords", {})
    if keywords:
        print("\n🔑 Palabras más utilizadas:")
        top_keywords = sorted(keywords.items(), key=lambda x: x[1], reverse=True)[:5]
        for word, count in top_keywords:
            print(f"   {word}: {count} veces")
    
    # Productivity patterns
    hours = patterns.get("productivity_patterns", {}).get("most_productive_hours", [])
    if hours:
        print("\n⏰ Patrones de productividad:")
        hour_counts = Counter(hours)
        for hour, count in sorted(hour_counts.items()):
            print(f"   {hour}:00 - {count} sesiones")
    
    print("\n" + "=" * 50)
    print(f"📅 Última actualización: {patterns.get('last_updated', 'N/A')}")
    
except Exception as e:
    print(f"Error leyendo estadísticas: {e}")
PYTHON_SCRIPT
}

# Función de ayuda
show_help() {
    echo -e "${BLUE}💬 Verdex Framework IA - Auto Chat Documenter${NC}"
    echo ""
    echo "Uso:"
    echo "  $0                           # Documentar sesión interactiva"
    echo "  $0 'contenido' [ticket]      # Documentar con contenido directo"
    echo "  $0 --stats                   # Ver estadísticas de sesiones"
    echo "  $0 --help                    # Mostrar esta ayuda"
    echo ""
    echo "Funcionalidades automáticas:"
    echo "  ✅ Detección automática del tipo de sesión"
    echo "  ✅ Generación de key summary inteligente"
    echo "  ✅ Análisis de patrones de usuario"
    echo "  ✅ Sugerencias de mejora automáticas"
    echo "  ✅ Documentación estructurada estándar"
}

# Manejo de argumentos
case "${1:-}" in
    --stats)
        show_chat_stats
        ;;
    --help|-h)
        show_help
        ;;
    *)
        auto_document_chat "$@"
        ;;
esac 