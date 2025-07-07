#!/bin/bash

# 🔒 Verdex Framework IA - Setup Git Hooks Inteligentes
# Previene commits y calendar entries sin tickets automáticamente

set -euo pipefail

readonly HOOKS_DIR=".git/hooks"
readonly FRAMEWORK_DIR=".verdex-ai"

# Colores
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log() {
    echo -e "${BLUE}🔧 $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# Crear pre-commit hook para validar tickets
create_precommit_hook() {
    log "Creando pre-commit hook para validación de tickets..."
    
    cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/bash

# 🎫 Verdex Framework IA - Pre-commit Hook
# Valida que todo commit tenga referencia a ticket Jira

COMMIT_MSG_FILE="$1"
FRAMEWORK_DIR=".verdex-ai"
LOG_FILE="$FRAMEWORK_DIR/sessions/agent-interactions.log"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Función de logging
log_interaction() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] INFO GIT_HOOK - $1" >> "$LOG_FILE" 2>/dev/null || true
}

# Obtener mensaje de commit
if [ -f "$COMMIT_MSG_FILE" ]; then
    COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")
else
    # Si no hay archivo, obtener de git log (para commits en progreso)
    COMMIT_MSG=$(git log --format=%B -n 1 HEAD 2>/dev/null || echo "")
fi

# Patterns de tickets válidos
TICKET_PATTERNS=(
    "[A-Z]+-[0-9]+"           # PROJ-123
    "#[0-9]+"                 # #123
    "ticket[[:space:]]*[0-9]+" # ticket 123, ticket123
    "issue[[:space:]]*[0-9]+"  # issue 123
)

# Verificar si el commit contiene referencia a ticket
has_ticket=false
for pattern in "${TICKET_PATTERNS[@]}"; do
    if echo "$COMMIT_MSG" | grep -iE "$pattern" >/dev/null 2>&1; then
        has_ticket=true
        break
    fi
done

# Si no tiene ticket, bloquear commit
if [ "$has_ticket" = false ]; then
    echo -e "${RED}🚫 COMMIT BLOQUEADO - Verdex Framework IA${NC}"
    echo ""
    echo -e "${YELLOW}📋 Mensaje de commit debe incluir referencia a ticket:${NC}"
    echo "   • PROJ-123: descripción del cambio"
    echo "   • #123: descripción del cambio" 
    echo "   • ticket 123: descripción del cambio"
    echo "   • issue 123: descripción del cambio"
    echo ""
    echo -e "${BLUE}💡 Crea un ticket primero:${NC}"
    echo "   .verdex-ai/scripts/quick-ticket.sh"
    echo ""
    echo -e "${RED}❌ Commit actual: $COMMIT_MSG${NC}"
    
    log_interaction "COMMIT_BLOCKED - No ticket reference: $COMMIT_MSG"
    exit 1
fi

# Log del commit exitoso
ticket_ref=$(echo "$COMMIT_MSG" | grep -iE "${TICKET_PATTERNS[0]}|${TICKET_PATTERNS[1]}|${TICKET_PATTERNS[2]}|${TICKET_PATTERNS[3]}" -o | head -1)
log_interaction "COMMIT_ALLOWED - Ticket: $ticket_ref, Message: $COMMIT_MSG"

echo -e "${GREEN}✅ Commit aprobado - Ticket detectado: $ticket_ref${NC}"
exit 0
EOF

    chmod +x "$HOOKS_DIR/pre-commit"
    success "Pre-commit hook instalado"
}

# Crear commit-msg hook para auto-documentación
create_commitmsg_hook() {
    log "Creando commit-msg hook para auto-documentación..."
    
    cat > "$HOOKS_DIR/commit-msg" << 'EOF'
#!/bin/bash

# 📝 Verdex Framework IA - Commit-msg Hook
# Auto-documenta commits en conversation-history.md

COMMIT_MSG_FILE="$1"
FRAMEWORK_DIR=".verdex-ai"
HISTORY_FILE="$FRAMEWORK_DIR/sessions/conversation-history.md"
METRICS_FILE="$FRAMEWORK_DIR/sessions/metrics.json"

# Leer mensaje de commit
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Extraer información del commit
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
TICKET_REF=$(echo "$COMMIT_MSG" | grep -iE "[A-Z]+-[0-9]+|#[0-9]+|ticket[[:space:]]*[0-9]+|issue[[:space:]]*[0-9]+" -o | head -1)
COMMIT_TYPE="unknown"

# Detectar tipo de commit
if echo "$COMMIT_MSG" | grep -iE "^(feat|feature)" >/dev/null; then
    COMMIT_TYPE="feature"
elif echo "$COMMIT_MSG" | grep -iE "^(fix|bug)" >/dev/null; then
    COMMIT_TYPE="bugfix"
elif echo "$COMMIT_MSG" | grep -iE "^(docs|doc)" >/dev/null; then
    COMMIT_TYPE="documentation"
elif echo "$COMMIT_MSG" | grep -iE "^(refactor)" >/dev/null; then
    COMMIT_TYPE="refactor"
elif echo "$COMMIT_MSG" | grep -iE "^(test)" >/dev/null; then
    COMMIT_TYPE="testing"
else
    COMMIT_TYPE="maintenance"
fi

# Auto-documentar en conversation-history.md
if [ -f "$HISTORY_FILE" ]; then
    # Buscar sección de "Acciones Realizadas" y agregar
    if grep -q "### ⚡ Acciones Realizadas" "$HISTORY_FILE"; then
        sed -i "/### ⚡ Acciones Realizadas/a\\$(date +%m-%d) ✅ **$COMMIT_TYPE**: $TICKET_REF - $COMMIT_MSG" "$HISTORY_FILE"
    fi
fi

# Actualizar métricas automáticamente
if [ ! -f "$METRICS_FILE" ]; then
    echo '{"commits_today":0,"tickets_worked":[],"commit_types":{}}' > "$METRICS_FILE"
fi

# Actualizar contadores usando Python inline
python3 << PYTHON_SCRIPT
import json
import os
from datetime import datetime

metrics_file = "$METRICS_FILE"
ticket_ref = "$TICKET_REF"
commit_type = "$COMMIT_TYPE"

try:
    with open(metrics_file, 'r') as f:
        metrics = json.load(f)
except:
    metrics = {"commits_today": 0, "tickets_worked": [], "commit_types": {}}

# Actualizar métricas
metrics["commits_today"] = metrics.get("commits_today", 0) + 1

if ticket_ref and ticket_ref not in metrics.get("tickets_worked", []):
    if "tickets_worked" not in metrics:
        metrics["tickets_worked"] = []
    metrics["tickets_worked"].append(ticket_ref)

if "commit_types" not in metrics:
    metrics["commit_types"] = {}
metrics["commit_types"][commit_type] = metrics["commit_types"].get(commit_type, 0) + 1

metrics["last_updated"] = datetime.now().isoformat()

with open(metrics_file, 'w') as f:
    json.dump(metrics, f, indent=2)

print(f"📊 Métricas actualizadas: {commit_type} commit para {ticket_ref}")
PYTHON_SCRIPT

exit 0
EOF

    chmod +x "$HOOKS_DIR/commit-msg"
    success "Commit-msg hook instalado"
}

# Crear post-commit hook para notificaciones
create_postcommit_hook() {
    log "Creando post-commit hook para notificaciones..."
    
    cat > "$HOOKS_DIR/post-commit" << 'EOF'
#!/bin/bash

# 🔔 Verdex Framework IA - Post-commit Hook
# Notificaciones y sugerencias post-commit

FRAMEWORK_DIR=".verdex-ai"
LOG_FILE="$FRAMEWORK_DIR/sessions/agent-interactions.log"

# Obtener información del último commit
LAST_COMMIT=$(git log -1 --pretty=format:"%s")
COMMIT_HASH=$(git log -1 --pretty=format:"%h")

# Logging
log_interaction() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] SUCCESS COMMIT_COMPLETED - $1" >> "$LOG_FILE" 2>/dev/null || true
}

log_interaction "Hash: $COMMIT_HASH, Message: $LAST_COMMIT"

# Sugerencias automáticas basadas en patrones
echo "🎉 Commit completado exitosamente!"
echo "📊 Registrado en métricas automáticamente"

# TODO: Aquí se pueden agregar más sugerencias inteligentes
# como sugerir documentation si es una feature, tests si es bugfix, etc.

exit 0
EOF

    chmod +x "$HOOKS_DIR/post-commit"
    success "Post-commit hook instalado"
}

# Función principal
main() {
    log "Configurando Git Hooks Inteligentes para Verdex Framework IA..."
    
    # Verificar que estamos en un repo git
    if [ ! -d ".git" ]; then
        error "No es un repositorio Git. Inicializa git primero."
        exit 1
    fi
    
    # Crear directorio de hooks si no existe
    mkdir -p "$HOOKS_DIR"
    
    # Instalar hooks
    create_precommit_hook
    create_commitmsg_hook  
    create_postcommit_hook
    
    # Crear directorio de métricas
    mkdir -p "$FRAMEWORK_DIR/sessions"
    
    echo ""
    success "🚀 Git Hooks Inteligentes instalados exitosamente!"
    echo ""
    echo -e "${BLUE}📋 Funcionalidades activadas:${NC}"
    echo "  ✅ Bloqueo de commits sin tickets"
    echo "  ✅ Auto-documentación en conversation-history.md"  
    echo "  ✅ Métricas automáticas de commits"
    echo "  ✅ Logging de todas las actividades"
    echo ""
    echo -e "${YELLOW}💡 Próximo commit debe incluir ticket: PROJ-123, #123, ticket 123${NC}"
}

# Ejecutar si es llamado directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 