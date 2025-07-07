#!/bin/bash

# 🤖 VERDEX FRAMEWORK IA - Script de Instalación Cross-Platform
# Version: 3.0.0
# Descripción: Instalador inteligente del framework de desarrollo IA empresarial
# Soporte: Windows (Git Bash/WSL) + Linux + macOS
# Autor: Verdex Development Team

set -euo pipefail

# ========================================================================================
# CONFIGURACIÓN Y VARIABLES GLOBALES
# ========================================================================================

readonly FRAMEWORK_NAME="Verdex Framework IA"
readonly FRAMEWORK_VERSION="3.0.0"
readonly FRAMEWORK_DIR=".verdex-ai"
readonly MAIN_GUIDE="VERDEX_AI_AGENT_GUIDE.md"
readonly GITHUB_RAW_URL="https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main"
readonly TMP_DIR="/tmp/verdex-ai-install"

# Detectar sistema operativo
detect_os() {
    case "$(uname -s)" in
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        Linux*) echo "linux" ;;
        Darwin*) echo "macos" ;;
        *) echo "unknown" ;;
    esac
}

readonly OS_TYPE=$(detect_os)

# Colores para output (compatible con Windows)
if [[ "$OS_TYPE" == "windows" ]]; then
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly PURPLE=''
    readonly CYAN=''
    readonly WHITE=''
    readonly NC=''
else
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[0;33m'
    readonly BLUE='\033[0;34m'
    readonly PURPLE='\033[0;35m'
    readonly CYAN='\033[0;36m'
    readonly WHITE='\033[1;37m'
    readonly NC='\033[0m'
fi

# ========================================================================================
# FUNCIONES DE UTILIDAD
# ========================================================================================

# Función de logging cross-platform
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Crear directorio de logs si no existe
    mkdir -p "$FRAMEWORK_DIR/sessions" 2>/dev/null || true
    local log_file="$FRAMEWORK_DIR/sessions/installation.log"
    
    echo "[$timestamp] [$level] $message" | tee -a "$log_file" 2>/dev/null || echo "[$timestamp] [$level] $message"
    
    case $level in
        "INFO")  echo -e "${BLUE}ℹ️  $message${NC}" ;;
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "ERROR") echo -e "${RED}❌ $message${NC}" ;;
        "HEADER") echo -e "${PURPLE}🚀 $message${NC}" ;;
    esac
}

# Banner cross-platform
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
██╗   ██╗███████╗██████╗ ██████╗ ███████╗██╗  ██╗    ██╗ █████╗ 
██║   ██║██╔════╝██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██║██╔══██╗
██║   ██║█████╗  ██████╔╝██║  ██║█████╗   ╚███╔╝     ██║███████║
╚██╗ ██╔╝██╔══╝  ██╔══██╗██║  ██║██╔══╝   ██╔██╗     ██║██╔══██║
 ╚████╔╝ ███████╗██║  ██║██████╔╝███████╗██╔╝ ██╗    ██║██║  ██║
  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═╝
                                                                    
     Framework de Desarrollo IA Empresarial v3.0
EOF
    echo -e "${NC}"
    echo -e "${WHITE}🏢 Framework de Desarrollo IA Empresarial con Integración Atlassian${NC}"
    echo -e "${CYAN}📅 Version: $FRAMEWORK_VERSION (${OS_TYPE^^})${NC}"
    echo ""
}

# Detectar tipo de proyecto
detect_project_type() {
    local project_type="unknown"
    
    if [ -d "$FRAMEWORK_DIR" ] && [ -f "$MAIN_GUIDE" ]; then
        project_type="verdex_existing"
    elif [ -f "package.json" ]; then
        if [ -f "next.config.js" ] || [ -f "nuxt.config.js" ]; then
            project_type="webapp_modern"
        else
            project_type="node_js"
        fi
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        project_type="python_web"
    elif [ -f "composer.json" ]; then
        project_type="php_web"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        project_type="java_enterprise"
    elif [ -f "pubspec.yaml" ]; then
        project_type="flutter_mobile"
    elif [ -f "docker-compose.yml" ]; then
        project_type="containerized_app"
    elif [ -f "README.md" ] || [ -f "readme.md" ]; then
        project_type="generic_existing"
    else
        project_type="empty_project"
    fi
    
    echo "$project_type"
}

# Verificar prerequisitos cross-platform
check_prerequisites() {
    log "INFO" "Verificando prerequisitos del sistema ($OS_TYPE)..."
    
    local missing_deps=()
    
    # Verificar herramientas básicas
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    command -v mkdir >/dev/null 2>&1 || missing_deps+=("mkdir")
    
    # Verificaciones específicas por OS
    case "$OS_TYPE" in
        "windows")
            if ! command -v node >/dev/null 2>&1; then
                log "WARNING" "Node.js recomendado para Windows - instalar desde nodejs.org"
            fi
            ;;
        "linux")
            command -v bash >/dev/null 2>&1 || missing_deps+=("bash")
            ;;
        "macos")
            command -v zsh >/dev/null 2>&1 || command -v bash >/dev/null 2>&1 || missing_deps+=("shell")
            ;;
    esac
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log "ERROR" "Dependencias faltantes: ${missing_deps[*]}"
        log "INFO" "Por favor instala las dependencias faltantes y ejecuta nuevamente"
        exit 1
    fi
    
    log "SUCCESS" "Todos los prerequisitos están instalados"
}

# ========================================================================================
# FUNCIONES DE INSTALACIÓN
# ========================================================================================

# Crear estructura completa del framework
create_framework_structure() {
    log "INFO" "Creando estructura del framework..."
    
    # Crear directorio principal (oculto como .git)
    mkdir -p "$FRAMEWORK_DIR"
    
    # Crear subdirectorios con estructura profesional v3.0
    mkdir -p "$FRAMEWORK_DIR"/{config,scripts,sessions,lab,docs,templates}
    mkdir -p "$FRAMEWORK_DIR"/sessions/session-logs
    mkdir -p "$FRAMEWORK_DIR"/lab/{experiments,prototypes,testing}
    mkdir -p "$FRAMEWORK_DIR"/templates/{jira-tickets,confluence-pages,session-reports}
    mkdir -p "$FRAMEWORK_DIR"/docs/{guides,troubleshooting}
    
    # Descargar system prompts y documentación adicional desde GitHub
    download_framework_docs
    
    log "SUCCESS" "Estructura del framework creada"
}

# Descargar documentación del framework desde GitHub
download_framework_docs() {
    log "INFO" "Descargando system prompts y documentación..."
    
    # URLs de los archivos a descargar
    local docs_base="$GITHUB_RAW_URL/.verdex-ai/docs"
    
    # System Prompts
    curl -fsSL "$docs_base/SYSTEM_PROMPT.md" -o "$FRAMEWORK_DIR/docs/SYSTEM_PROMPT.md" 2>/dev/null || echo "⚠️  No se pudo descargar SYSTEM_PROMPT.md"
    curl -fsSL "$docs_base/SYSTEM_PROMPT_COMPACT.md" -o "$FRAMEWORK_DIR/docs/SYSTEM_PROMPT_COMPACT.md" 2>/dev/null || echo "⚠️  No se pudo descargar SYSTEM_PROMPT_COMPACT.md"
    curl -fsSL "$docs_base/CURSOR_COPY_PASTE.md" -o "$FRAMEWORK_DIR/docs/CURSOR_COPY_PASTE.md" 2>/dev/null || echo "⚠️  No se pudo descargar CURSOR_COPY_PASTE.md"
    curl -fsSL "$docs_base/HOW_TO_USE_SYSTEM_PROMPTS.md" -o "$FRAMEWORK_DIR/docs/HOW_TO_USE_SYSTEM_PROMPTS.md" 2>/dev/null || echo "⚠️  No se pudo descargar HOW_TO_USE_SYSTEM_PROMPTS.md"
    
    # Documentación adicional
    curl -fsSL "$docs_base/README.md" -o "$FRAMEWORK_DIR/docs/README.md" 2>/dev/null || echo "⚠️  No se pudo descargar docs README.md"
    curl -fsSL "$docs_base/QUICK_START.md" -o "$FRAMEWORK_DIR/docs/QUICK_START.md" 2>/dev/null || echo "⚠️  No se pudo descargar QUICK_START.md"
    curl -fsSL "$docs_base/git-branch-strategy.md" -o "$FRAMEWORK_DIR/docs/git-branch-strategy.md" 2>/dev/null || echo "⚠️  No se pudo descargar git-branch-strategy.md"
    
    # Verificar si se descargaron correctamente
    local downloaded=0
    [ -f "$FRAMEWORK_DIR/docs/SYSTEM_PROMPT.md" ] && downloaded=$((downloaded + 1))
    [ -f "$FRAMEWORK_DIR/docs/SYSTEM_PROMPT_COMPACT.md" ] && downloaded=$((downloaded + 1))
    [ -f "$FRAMEWORK_DIR/docs/CURSOR_COPY_PASTE.md" ] && downloaded=$((downloaded + 1))
    [ -f "$FRAMEWORK_DIR/docs/HOW_TO_USE_SYSTEM_PROMPTS.md" ] && downloaded=$((downloaded + 1))
    
    if [ $downloaded -ge 4 ]; then
        log "SUCCESS" "System prompts descargados correctamente ($downloaded/4)"
    else
        log "WARNING" "Solo se descargaron $downloaded/4 system prompts"
    fi
}

# Crear configuración framework-settings.yaml
create_framework_settings() {
    log "INFO" "Creando configuración del framework..."
    
    local project_name=$(basename "$(pwd)")
    local current_date=$(date "+%Y-%m-%d")
    
    cat > "$FRAMEWORK_DIR/config/framework-settings.yaml" << EOF
# ===================================================================
# VERDEX FRAMEWORK IA v3.0 - Configuración Principal
# ===================================================================

# Información del framework
framework:
  name: "Verdex Framework IA"
  version: "$FRAMEWORK_VERSION"
  installation_date: "$current_date"
  os_type: "$OS_TYPE"
  
# Información del proyecto
project:
  name: "$project_name"
  type: "$(detect_project_type)"
  root_directory: "$(pwd)"
  
# Configuración de agentes IA
agents:
  protocol_enforcement: true
  mandatory_ticket_creation: true
  conversation_logging: true
  experimental_mode: true
  
# Integración Atlassian
atlassian:
  mcp_integration: true
  jira_mandatory: true
  confluence_docs: true
  auto_ticket_creation: false
  
# Configuración de scripts inteligentes v3.0
smart_features:
  git_hooks: true
  auto_documentation: true
  metrics_collection: true
  smart_coaching: true
  quick_tickets: true
  
# Configuración de seguridad
security:
  require_tickets_for_commits: true
  auto_backup_on_changes: true
  session_tracking: true
  
# Configuración de logging
logging:
  conversation_history: true
  session_logs: true
  metrics_auto_feed: true
  installation_logs: true
  
# Paths importantes
paths:
  framework_dir: "$FRAMEWORK_DIR"
  config_dir: "$FRAMEWORK_DIR/config"
  scripts_dir: "$FRAMEWORK_DIR/scripts"
  sessions_dir: "$FRAMEWORK_DIR/sessions"
  lab_dir: "$FRAMEWORK_DIR/lab"
  templates_dir: "$FRAMEWORK_DIR/templates"
  
# Estado del framework
status:
  installed: true
  configured: true
  mcp_connected: false
  first_run: true
EOF

    log "SUCCESS" "Configuración del framework creada"
}

# Crear plantillas Jira YAML
create_jira_templates() {
    log "INFO" "Creando plantillas Jira..."
    
    # Plantilla Bug Report
    cat > "$FRAMEWORK_DIR/templates/jira-tickets/bug-report.yaml" << 'EOF'
# Verdex Framework IA - Plantilla Bug Report
title: "[BUG] Descripción del problema"
type: "Bug"
priority: "Medium"
description: |
  ## 🐛 Descripción del Bug
  Breve descripción del problema encontrado.
  
  ## 🔄 Pasos para Reproducir
  1. Paso uno
  2. Paso dos
  3. Resultado esperado vs actual
  
  ## 💻 Entorno
  - OS: [OS Type]
  - Navegador: [Browser]
  - Versión: [Version]
  
  ## 📎 Información Adicional
  [Screenshots, logs, etc.]

labels:
  - bug
  - framework
  - pending-fix

components:
  - "Frontend"
  - "Backend"
EOF

    # Plantilla Feature Request
    cat > "$FRAMEWORK_DIR/templates/jira-tickets/feature-request.yaml" << 'EOF'
# Verdex Framework IA - Plantilla Feature Request
title: "[FEATURE] Nueva funcionalidad"
type: "Story"
priority: "Medium"
description: |
  ## 🎯 Objetivo
  Descripción clara de la nueva funcionalidad.
  
  ## 💡 Justificación
  Por qué esta feature es necesaria.
  
  ## 📋 Criterios de Aceptación
  - [ ] Criterio 1
  - [ ] Criterio 2
  - [ ] Criterio 3
  
  ## 🔧 Consideraciones Técnicas
  [Notas técnicas relevantes]

labels:
  - enhancement
  - feature
  - pending-analysis

components:
  - "Development"
EOF

    log "SUCCESS" "Plantillas Jira creadas"
}

# Crear scripts inteligentes v3.0
create_intelligent_scripts() {
    log "INFO" "Creando scripts inteligentes v3.0..."
    
    # Script de health check mejorado
    cat > "$FRAMEWORK_DIR/scripts/health-check.sh" << 'EOF'
#!/bin/bash
# Verdex Framework IA v3.0 - Health Check Inteligente

echo "🔍 Verificando estado del Verdex Framework IA v3.0..."
echo "📅 $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# Verificar estructura del framework
echo "📁 Estructura del framework:"
checks=0
passed=0

check_item() {
    local item="$1"
    local desc="$2"
    checks=$((checks + 1))
    if [[ -e "$item" ]]; then
        echo "  ✅ $desc"
        passed=$((passed + 1))
    else
        echo "  ❌ $desc (faltante)"
    fi
}

check_item ".verdex-ai" "Directorio principal"
check_item ".verdex-ai/config/framework-settings.yaml" "Configuración"
check_item ".verdex-ai/scripts" "Scripts del framework"
check_item ".verdex-ai/sessions/conversation-history.md" "Historial"
check_item ".verdex-ai/templates" "Plantillas"
check_item "VERDEX_AI_AGENT_GUIDE.md" "Guía de agentes"

# Verificar MCP (si existe cursor config)
echo ""
echo "🔗 Integración MCP:"
if [ -f "$HOME/.cursor/mcp.json" ]; then
    echo "  ✅ Configuración MCP encontrada"
    if grep -q "atlassianToolIla" "$HOME/.cursor/mcp.json" 2>/dev/null; then
        echo "  ✅ Atlassian MCP configurado"
    else
        echo "  ⚠️  Atlassian MCP no configurado"
    fi
else
    echo "  ⚠️  Configuración MCP no encontrada"
fi

echo ""
echo "📊 Resultado: $passed/$checks checks pasaron"
if [ "$passed" -eq "$checks" ]; then
    echo "✅ Framework funcionando perfectamente"
    exit 0
else
    echo "⚠️  Framework parcialmente configurado"
    exit 1
fi
EOF

    # Script de verificación de conexiones MCP
    cat > "$FRAMEWORK_DIR/scripts/verify-connections.sh" << 'EOF'
#!/bin/bash
# Verdex Framework IA - Verificador MCP

echo "🔗 Verificando conexiones MCP..."

if [ -f "$HOME/.cursor/mcp.json" ]; then
    echo "✅ Archivo MCP encontrado: $HOME/.cursor/mcp.json"
    
    if command -v jq >/dev/null 2>&1; then
        echo "📋 Servidores MCP configurados:"
        jq -r '.mcpServers | keys[]' "$HOME/.cursor/mcp.json" 2>/dev/null | sed 's/^/  - /'
    else
        echo "⚠️  jq no instalado - mostrando contenido básico"
        grep -o '"[^"]*":' "$HOME/.cursor/mcp.json" | sed 's/[":]*//g' | sed 's/^/  - /'
    fi
else
    echo "❌ Archivo MCP no encontrado"
    echo "💡 Configura MCP en Cursor para usar integraciones Atlassian"
fi
EOF

    # Hacer scripts ejecutables
    chmod +x "$FRAMEWORK_DIR/scripts"/*.sh

    log "SUCCESS" "Scripts inteligentes creados"
}

# Crear historial de conversación inicial
create_conversation_history() {
    log "INFO" "Creando historial de conversación inicial..."
    
    local project_name=$(basename "$(pwd)")
    local current_date=$(date "+%Y-%m-%d")
    local current_time=$(date "+%H:%M:%S")
    
    cat > "$FRAMEWORK_DIR/sessions/conversation-history.md" << EOF
# 💬 Verdex Framework IA v3.0 - Historial de Conversación

> **Proyecto**: $project_name  
> **Instalación**: $current_date $current_time  
> **Sistema**: $OS_TYPE  
> **Framework**: v$FRAMEWORK_VERSION  

---

## 📅 Sesión Actual: $current_date

### 🎯 Objetivo de la Sesión
**Instalación Inicial v3.0**: Configuración del Verdex Framework IA con funcionalidades inteligentes

### 🎫 Tickets Jira Relacionados
- Sin tickets (instalación inicial del framework)

### ⚡ Acciones Realizadas
1. ✅ Instalación cross-platform del Verdex Framework IA v$FRAMEWORK_VERSION
2. ✅ Creación de estructura en .$FRAMEWORK_DIR/ (oculta como .git)
3. ✅ Detección automática: Proyecto $(detect_project_type)
4. ✅ Configuración framework-settings.yaml generada
5. ✅ Plantillas Jira YAML creadas
6. ✅ Scripts inteligentes v3.0 instalados

### 📊 Estado Actual
- **Framework**: Verdex Framework IA v$FRAMEWORK_VERSION (cross-platform)
- **Ubicación**: .$FRAMEWORK_DIR/ (carpeta oculta profesional)
- **OS**: $OS_TYPE detectado automáticamente
- **Características v3.0**: Scripts inteligentes, plantillas YAML, configuración avanzada
- **Listo para uso**: ✅

### 🚀 Funcionalidades v3.0 Incluidas
- 🤖 **Control estricto de agentes**: Protocolo obligatorio
- 🎫 **Integración Jira**: Plantillas YAML profesionales
- 📝 **Auto-documentación**: Logging inteligente
- 🔧 **Scripts avanzados**: Health check, MCP verification
- 🎯 **Cross-platform**: Windows, Linux, macOS

### 🔄 Próximos Pasos Sugeridos
1. Ejecutar health check: \`$FRAMEWORK_DIR/scripts/health-check.sh\`
2. Verificar MCP: \`$FRAMEWORK_DIR/scripts/verify-connections.sh\`
3. Leer guía completa: \`cat $MAIN_GUIDE\`
4. Crear primer ticket para trabajo inicial
5. Familiarizarse con plantillas en \`$FRAMEWORK_DIR/templates/\`

### 📝 Notas de Instalación v3.0
- ✅ Framework instalado exitosamente en $OS_TYPE
- ✅ Estructura profesional creada (oculta como .git)
- ✅ Configuración inteligente aplicada
- ✅ Scripts v3.0 con funcionalidades avanzadas
- ✅ Listo para trabajo empresarial con agentes IA

---

*📅 Instalación v3.0 completada: $current_date $current_time*  
*🤖 Instalador: Verdex AI Setup v$FRAMEWORK_VERSION*  
*💻 Sistema: $OS_TYPE*  
*🎯 Estado: Listo para producción*
EOF

    log "SUCCESS" "Historial de conversación inicial creado"
}

# Crear guía principal mejorada
create_agent_guide() {
    log "INFO" "Creando guía principal para agentes..."
    
    cat > "$MAIN_GUIDE" << 'EOF'
# 🤖 VERDEX FRAMEWORK IA v3.0 - GUÍA PARA AGENTES

> **Framework de Desarrollo IA Empresarial Cross-Platform con Integración Atlassian Obligatoria**

## 🎯 PROTOCOLO DE INICIALIZACIÓN OBLIGATORIO

**ANTES de cualquier trabajo, el agente DEBE ejecutar en orden:**

1. **📍 Verificar framework**: `ls -la .verdex-ai/`
2. **⚕️ Health check**: `.verdex-ai/scripts/health-check.sh`
3. **📖 Leer historial**: `cat .verdex-ai/sessions/conversation-history.md`
4. **🔗 Verificar MCP**: `.verdex-ai/scripts/verify-connections.sh`
5. **🎫 Crear ticket Jira**: OBLIGATORIO antes de proceder con trabajo
6. **📝 Actualizar log**: Registrar inicio de sesión

## 🔄 FLUJO DE TRABAJO ESTÁNDAR v3.0

1. **🚀 ANÁLISIS** - Health check y verificar estado actual
2. **📋 PLANIFICACIÓN** - Crear ticket Jira usando plantillas YAML
3. **🧪 EXPERIMENTACIÓN** - Probar en `.verdex-ai/lab/` ANTES de implementar
4. **⚡ IMPLEMENTACIÓN** - Aplicar cambios con referencia a ticket
5. **✅ VALIDACIÓN** - Health checks y verificar integraciones
6. **📚 DOCUMENTACIÓN** - Actualizar conversation-history.md
7. **🎯 CIERRE** - Actualizar ticket y métricas

## 📝 REGLAS DE LOGGING OBLIGATORIAS

**OBLIGATORIO actualizar conversation-history.md:**
- Al inicio de cada conversación (agregar sesión nueva)
- Durante cada prompt del usuario (agregar acciones)
- Al final de cada sesión (agregar resumen)

**Formato estándar para sesiones:**
```markdown
## 📅 Sesión: YYYY-MM-DD

### 🎯 Objetivo de la Sesión
[Descripción clara del objetivo]

### 🎫 Tickets Jira Relacionados
- PROJ-123: [Descripción del ticket]

### ⚡ Acciones Realizadas
1. ✅ [Acción completada]
2. 🔄 [Acción en progreso]
3. ❌ [Acción fallida]

### 📊 Estado Actual
[Estado del proyecto tras la sesión]

### 🔄 Próximos Pasos
[Pasos siguientes claramente definidos]
```

## 🚫 REGLAS ESTRICTAS - NO NEGOCIABLES

### ✅ SIEMPRE HACER:
- **Health check inicial**: Ejecutar antes de cualquier trabajo
- **Crear ticket Jira**: NINGÚN trabajo sin ticket válido
- **Experimentar primero**: Usar `.verdex-ai/lab/` antes de implementar
- **Actualizar historial**: Documentar CADA sesión
- **Usar plantillas**: Seguir templates en `.verdex-ai/templates/`
- **Verificar MCP**: Confirmar conexiones Atlassian

### 🚫 NUNCA HACER:
- Trabajar sin ticket Jira válido
- Modificar código sin experimentar en lab/
- Omitir actualización de conversation-history.md
- Generar archivos fuera de la estructura del framework
- Saltarse health checks
- Ignorar errores de MCP

## 🎯 FUNCIONALIDADES v3.0

### 🔧 Scripts Inteligentes
- **health-check.sh**: Verificación completa del framework
- **verify-connections.sh**: Validación de integraciones MCP

### 📋 Plantillas Profesionales
- **bug-report.yaml**: Template estructurado para bugs
- **feature-request.yaml**: Template para nuevas funcionalidades

### ⚙️ Configuración Avanzada
- **framework-settings.yaml**: Configuración central del framework
- **Cross-platform**: Soporte Windows, Linux, macOS

### 🎫 Sistema de Tickets
- Integración obligatoria con Jira via MCP
- Plantillas YAML para consistency
- Tracking automático en conversation-history.md

## 🚀 COMANDOS RÁPIDOS

```bash
# Health check completo
.verdex-ai/scripts/health-check.sh

# Verificar MCP
.verdex-ai/scripts/verify-connections.sh

# Ver configuración
cat .verdex-ai/config/framework-settings.yaml

# Ver historial
cat .verdex-ai/sessions/conversation-history.md

# Listar plantillas
ls .verdex-ai/templates/jira-tickets/
```

## 💡 TIPS PARA AGENTES IA

1. **Siempre empezar con health check** - nunca asumas que todo funciona
2. **Un ticket = una funcionalidad** - no mezcles múltiples cambios
3. **Lab primero** - experimenta antes de implementar
4. **Documenta todo** - conversation-history.md es obligatorio
5. **Cross-platform aware** - considera Windows, Linux, macOS

---

*📅 Verdex Framework IA v3.0 - Cross-Platform Excellence in AI-Assisted Development*  
*🎯 Mandatory protocols for enterprise-grade AI collaboration*  
*🏢 Professional structure · 🤖 AI-first approach · 📊 Atlassian integrated*
EOF

    log "SUCCESS" "Guía principal para agentes creada: $MAIN_GUIDE"
}

# ========================================================================================
# FUNCIÓN PRINCIPAL DE INSTALACIÓN
# ========================================================================================

install_framework() {
    local project_type=$(detect_project_type)
    
    log "HEADER" "Iniciando instalación del $FRAMEWORK_NAME v$FRAMEWORK_VERSION"
    log "INFO" "Proyecto detectado: $project_type"
    log "INFO" "Sistema operativo: $OS_TYPE"
    
    # Verificar si ya está instalado
    if [ "$project_type" = "verdex_existing" ]; then
        log "WARNING" "El framework ya está instalado en este proyecto"
        log "INFO" "¿Deseas reinstalar? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log "INFO" "Instalación cancelada"
            exit 0
        fi
        log "INFO" "Reinstalando framework..."
    fi
    
    # Crear backup si existe contenido
    if [ -d "$FRAMEWORK_DIR" ]; then
        local backup_dir="$FRAMEWORK_DIR.backup.$(date +%Y%m%d_%H%M%S)"
        log "INFO" "Creando backup en: $backup_dir"
        mv "$FRAMEWORK_DIR" "$backup_dir"
    fi
    
    # Ejecutar instalación v3.0
    create_framework_structure
    create_framework_settings
    create_jira_templates
    create_intelligent_scripts
    create_conversation_history
    create_agent_guide
    
    log "SUCCESS" "✨ $FRAMEWORK_NAME v$FRAMEWORK_VERSION instalado exitosamente!"
    
    # Mostrar resumen
    show_installation_summary
}

# Mostrar resumen final mejorado
show_installation_summary() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✨ INSTALACIÓN COMPLETADA EXITOSAMENTE${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}📁 Framework instalado en:${NC} .verdex-ai/ (oculto como .git)"
    echo -e "${CYAN}📋 Guía para agentes:${NC} VERDEX_AI_AGENT_GUIDE.md"
    echo -e "${CYAN}⚙️  Configuración avanzada:${NC} .verdex-ai/config/framework-settings.yaml"
    echo -e "${CYAN}💬 Historial conversación:${NC} .verdex-ai/sessions/conversation-history.md"
    echo -e "${CYAN}🎫 Plantillas Jira:${NC} .verdex-ai/templates/jira-tickets/"
    echo -e "${CYAN}🔧 Scripts inteligentes:${NC} .verdex-ai/scripts/"
    echo -e "${CYAN}🤖 System Prompts:${NC} .verdex-ai/docs/ (Cursor, Claude, ROVO, ChatGPT)"
    echo -e "${CYAN}💻 Sistema:${NC} $OS_TYPE (cross-platform)"
    echo ""
    echo -e "${YELLOW}🚀 PRÓXIMOS PASOS OBLIGATORIOS:${NC}"
    echo "1. 🔍 Health check: .verdex-ai/scripts/health-check.sh"
    echo "2. 🔗 Verificar MCP: .verdex-ai/scripts/verify-connections.sh"
    echo "3. 📖 Leer guía completa: cat VERDEX_AI_AGENT_GUIDE.md"
    echo "4. 🎫 Configurar Jira MCP en Cursor"
    echo "5. 🤖 Iniciar trabajo siguiendo protocolos obligatorios"
    echo ""
    echo -e "${PURPLE}📚 Para agentes IA: PROTOCOLO OBLIGATORIO en VERDEX_AI_AGENT_GUIDE.md${NC}"
    echo -e "${PURPLE}🎯 Framework v3.0: Cross-platform, inteligente, listo para producción${NC}"
    echo ""
}

# ========================================================================================
# PUNTO DE ENTRADA PRINCIPAL
# ========================================================================================

main() {
    # Verificar permisos de escritura
    if [ ! -w "." ]; then
        log "ERROR" "No tienes permisos de escritura en este directorio"
        exit 1
    fi
    
    # Limpiar pantalla (cross-platform)
    clear 2>/dev/null || printf '\033[2J\033[H'
    
    # Mostrar banner
    show_banner
    
    # Verificar prerequisitos
    check_prerequisites
    
    # Ejecutar instalación
    install_framework
    
    log "SUCCESS" "🎉 $FRAMEWORK_NAME v3.0 listo para usar!"
}

# Ejecutar con manejo de errores (compatible con curl pipe)
if [[ "${BASH_SOURCE[0]:-$0}" == "${0}" ]]; then
    trap 'log "ERROR" "Error en línea $LINENO. Código de salida: $?"' ERR
    main "$@"
fi 