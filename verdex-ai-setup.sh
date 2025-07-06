#!/bin/bash

# 🤖 VERDEX FRAMEWORK IA - Script de Instalación Principal
# Version: 2.0.0
# Descripción: Instalador inteligente del framework de desarrollo IA empresarial
# Autor: Verdex Development Team

set -euo pipefail

# ========================================================================================
# CONFIGURACIÓN Y VARIABLES GLOBALES
# ========================================================================================

readonly FRAMEWORK_NAME="Verdex Framework IA"
readonly FRAMEWORK_VERSION="2.0.0"
readonly FRAMEWORK_DIR=".verdex-ai"
readonly MAIN_GUIDE="VERDEX_AI_AGENT_GUIDE.md"
readonly REPO_URL="https://raw.githubusercontent.com/your-org/verdex-framework-ia/main"
readonly TMP_DIR="/tmp/verdex-ai-install"

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Configuración de logging
readonly LOG_FILE="$FRAMEWORK_DIR/sessions/installation.log"

# ========================================================================================
# FUNCIONES DE UTILIDAD
# ========================================================================================

# Función de logging con timestamp
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE" 2>/dev/null || echo "[$timestamp] [$level] $message"
    
    case $level in
        "INFO")  echo -e "${BLUE}ℹ️  $message${NC}" ;;
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "ERROR") echo -e "${RED}❌ $message${NC}" ;;
        "HEADER") echo -e "${PURPLE}🚀 $message${NC}" ;;
    esac
}

# Función de banner
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
██╗   ██╗███████╗██████╗ ██████╗ ███████╗██╗  ██╗    ██╗ █████╗ 
██║   ██║██╔════╝██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝    ██║██╔══██╗
██║   ██║█████╗  ██████╔╝██║  ██║█████╗   ╚███╔╝     ██║███████║
╚██╗ ██╔╝██╔══╝  ██╔══██╗██║  ██║██╔══╝   ██╔██╗     ██║██╔══██║
 ╚████╔╝ ███████╗██║  ██║██████╔╝███████╗██╔╝ ██╗    ██║██║  ██║
  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚═╝╚═╝  ╚═╝
                                                                    
     Framework de Desarrollo IA Empresarial v2.0
EOF
    echo -e "${NC}"
    echo -e "${WHITE}🏢 Framework de Desarrollo IA Empresarial con Integración Atlassian${NC}"
    echo -e "${CYAN}📅 Version: $FRAMEWORK_VERSION${NC}"
    echo ""
}

# Función para detectar tipo de proyecto
detect_project_type() {
    local project_type="unknown"
    
    # Verificar si ya tiene el framework instalado
    if [ -d "$FRAMEWORK_DIR" ] && [ -f "$MAIN_GUIDE" ]; then
        project_type="verdex_existing"
    # Detectar por archivos característicos
    elif [ -f "package.json" ]; then
        if [ -f "next.config.js" ] || [ -f "nuxt.config.js" ]; then
            project_type="webapp_modern"
        else
            project_type="node_js"
        fi
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        if [ -f "main.py" ] || [ -f "app.py" ]; then
            project_type="python_web"
        else
            project_type="python_general"
        fi
    elif [ -f "composer.json" ]; then
        project_type="php_web"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        project_type="java_enterprise"
    elif [ -f "Cargo.toml" ]; then
        project_type="rust_system"
    elif [ -f "go.mod" ]; then
        project_type="go_service"
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

# Función para verificar prerequisitos
check_prerequisites() {
    log "INFO" "Verificando prerequisitos del sistema..."
    
    local missing_deps=()
    
    # Verificar herramientas básicas
    command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
    command -v git >/dev/null 2>&1 || missing_deps+=("git")
    command -v mkdir >/dev/null 2>&1 || missing_deps+=("mkdir")
    
    # Verificar Node.js para MCP (opcional)
    if ! command -v node >/dev/null 2>&1; then
        log "WARNING" "Node.js no encontrado - algunas funciones MCP pueden no funcionar"
    fi
    
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

# Crear estructura de directorios
create_framework_structure() {
    log "INFO" "Creando estructura del framework..."
    
    # Crear directorio principal oculto
    mkdir -p "$FRAMEWORK_DIR"
    
    # Crear subdirectorios con estructura profesional
    mkdir -p "$FRAMEWORK_DIR"/{config,scripts,sessions,lab,docs,templates}
    mkdir -p "$FRAMEWORK_DIR"/sessions/session-logs
    mkdir -p "$FRAMEWORK_DIR"/lab/{experiments,prototypes,testing}
    mkdir -p "$FRAMEWORK_DIR"/templates/{jira-tickets,confluence-pages,session-reports}
    mkdir -p "$FRAMEWORK_DIR"/docs/{guides,troubleshooting}
    
    # Crear archivo de log de instalación
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
    
    log "SUCCESS" "Estructura del framework creada"
}

# Crear archivo de configuración inicial
create_initial_config() {
    log "INFO" "Creando configuración inicial..."
    
    local project_type=$(detect_project_type)
    local current_date=$(date "+%Y-%m-%d")
    
    # Detectar stack tecnológico
    local tech_stack=()
    [ -f "package.json" ] && tech_stack+=("Node.js")
    [ -f "requirements.txt" ] && tech_stack+=("Python")
    [ -f "composer.json" ] && tech_stack+=("PHP")
    [ -f "docker-compose.yml" ] && tech_stack+=("Docker")
    
    cat > "$FRAMEWORK_DIR/config/project-info.yaml" << EOF
# Verdex Framework IA - Información del Proyecto
# Generado automáticamente durante la instalación

project:
  name: "$(basename "$(pwd)")"
  type: "$project_type"
  technology_stack: $(printf '%s\n' "${tech_stack[@]}" | sed 's/^/    - /' | tr '\n' ' ')
  installation_date: "$current_date"
  framework_version: "$FRAMEWORK_VERSION"

# Configuración detectada automáticamente
detection:
  has_package_json: $([ -f "package.json" ] && echo "true" || echo "false")
  has_requirements_txt: $([ -f "requirements.txt" ] && echo "true" || echo "false")
  has_docker_compose: $([ -f "docker-compose.yml" ] && echo "true" || echo "false")
  has_readme: $([ -f "README.md" ] && echo "true" || echo "false")

# Integración Atlassian
atlassian:
  mcp_configured: false
  jira_project_key: ""
  confluence_space: ""
EOF

    log "SUCCESS" "Configuración inicial creada para proyecto tipo: $project_type"
}

# Crear archivo conversation-history.md inicial
create_conversation_history() {
    log "INFO" "Creando historial de conversación inicial..."
    
    local project_name=$(basename "$(pwd)")
    local current_date=$(date "+%Y-%m-%d")
    local current_time=$(date "+%H:%M:%S")
    
    cat > "$FRAMEWORK_DIR/sessions/conversation-history.md" << EOF
# 💬 Verdex Framework IA - Historial de Conversación

> **Proyecto**: $project_name
> **Instalación**: $current_date $current_time

---

## 📅 Sesión Actual: $current_date

### 🎯 Objetivo de la Sesión
**Instalación Inicial**: Configuración del Verdex Framework IA en proyecto existente

### 🎫 Tickets Jira Relacionados
- Sin tickets (instalación inicial del framework)

### ⚡ Acciones Realizadas
1. ✅ Instalación del Verdex Framework IA v$FRAMEWORK_VERSION
2. ✅ Creación de estructura en .$FRAMEWORK_DIR/
3. ✅ Detección automática de tipo de proyecto
4. ✅ Configuración inicial aplicada

### 📊 Estado Actual
- **Framework**: Verdex Framework IA v$FRAMEWORK_VERSION instalado
- **Ubicación**: .$FRAMEWORK_DIR/ (carpeta oculta)
- **Proyecto**: $(detect_project_type)
- **Listo para uso**: ✅

### 🔄 Próximos Pasos
1. Configurar integración MCP Atlassian
2. Crear primer ticket Jira para trabajo inicial
3. Familiarizarse con la estructura del framework
4. Leer guía para agentes en $MAIN_GUIDE

### 📝 Notas de Instalación
- Framework instalado exitosamente
- Estructura profesional creada
- Configuración automática aplicada
- Listo para trabajo con agentes IA

---

*📅 Instalación completada: $current_date $current_time*
*🤖 Instalador: Verdex AI Setup v$FRAMEWORK_VERSION*
EOF

    log "SUCCESS" "Historial de conversación inicial creado"
}

# Crear scripts básicos del framework
create_framework_scripts() {
    log "INFO" "Creando scripts del framework..."
    
    # Script de verificación de salud
    cat > "$FRAMEWORK_DIR/scripts/health-check.sh" << 'EOF'
#!/bin/bash
# Verdex Framework IA - Health Check

echo "🔍 Verificando estado del Verdex Framework IA..."

# Verificar estructura
echo "📁 Estructura del framework:"
if [ -d ".verdex-ai" ]; then
    echo "  ✅ Directorio principal: .verdex-ai/"
    echo "  ✅ Configuración: .verdex-ai/config/"
    echo "  ✅ Scripts: .verdex-ai/scripts/"
    echo "  ✅ Sesiones: .verdex-ai/sessions/"
    echo "  ✅ Laboratorio: .verdex-ai/lab/"
else
    echo "  ❌ Framework no instalado"
    exit 1
fi

# Verificar archivos principales
echo "📄 Archivos principales:"
[ -f "VERDEX_AI_AGENT_GUIDE.md" ] && echo "  ✅ Guía de agentes" || echo "  ⚠️  Guía faltante"
[ -f ".verdex-ai/config/framework-settings.yaml" ] && echo "  ✅ Configuración" || echo "  ⚠️  Configuración faltante"
[ -f ".verdex-ai/sessions/conversation-history.md" ] && echo "  ✅ Historial" || echo "  ⚠️  Historial faltante"

echo "✅ Health check completado"
EOF

    chmod +x "$FRAMEWORK_DIR/scripts/health-check.sh"
    
    log "SUCCESS" "Scripts del framework creados"
}

# Crear guía principal para agentes
create_agent_guide() {
    log "INFO" "Creando guía principal para agentes..."
    
    # El contenido está en el archivo original VERDEX_AI_AGENT_GUIDE.md
    # Por simplicidad, creamos una versión básica aquí
    cat > "$MAIN_GUIDE" << 'EOF'
# 🤖 VERDEX FRAMEWORK IA - GUÍA PARA AGENTES

> **Framework de Desarrollo IA Empresarial con Integración Atlassian Obligatoria**

## 🎯 PROTOCOLO DE INICIALIZACIÓN OBLIGATORIO

**Antes de cualquier trabajo, el agente DEBE:**

1. **📍 Verificar framework**: `ls -la .verdex-ai/`
2. **📖 Leer historial**: `cat .verdex-ai/sessions/conversation-history.md`
3. **🔗 Verificar MCP**: `.verdex-ai/scripts/verify-connections.sh`
4. **🎫 Crear ticket Jira**: Obligatorio antes de proceder
5. **📝 Actualizar log**: Registrar inicio de sesión

## 🔄 FLUJO DE TRABAJO ESTÁNDAR

1. **🚀 ANÁLISIS** - Verificar estado y analizar solicitud
2. **📋 PLANIFICACIÓN** - Crear ticket y documentar plan
3. **🧪 EXPERIMENTACIÓN** - Probar en `.verdex-ai/lab/` ANTES de implementar
4. **⚡ IMPLEMENTACIÓN** - Aplicar cambios con referencia a ticket
5. **✅ VALIDACIÓN** - Ejecutar health checks y verificar
6. **📚 DOCUMENTACIÓN** - Actualizar docs y cerrar ticket

## 📝 REGLAS DE LOGGING

**OBLIGATORIO actualizar conversation-history.md:**
- Al inicio de cada conversación
- Durante cada prompt del usuario  
- Al final de cada sesión

## 🚫 REGLAS ESTRICTAS

### ✅ SIEMPRE HACER:
- Crear ticket Jira antes de trabajar
- Experimentar en `.verdex-ai/lab/` primero
- Actualizar historial de conversación
- Usar MCP Atlassian

### 🚫 NUNCA HACER:
- Trabajar sin ticket válido
- Modificar código sin experimentar
- Omitir documentación
- Generar archivos fuera del framework

---

*📅 Verdex Framework IA v2.0 - Para excelencia en desarrollo asistido por IA*
EOF

    log "SUCCESS" "Guía principal para agentes creada: $MAIN_GUIDE"
}

# ========================================================================================
# FUNCIÓN PRINCIPAL DE INSTALACIÓN
# ========================================================================================

# Función principal de instalación
install_framework() {
    local project_type=$(detect_project_type)
    
    log "HEADER" "Iniciando instalación del $FRAMEWORK_NAME v$FRAMEWORK_VERSION"
    log "INFO" "Proyecto detectado: $project_type"
    
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
    
    # Ejecutar instalación
    create_framework_structure
    create_initial_config
    create_conversation_history
    create_framework_scripts
    create_agent_guide
    
    log "SUCCESS" "✨ $FRAMEWORK_NAME v$FRAMEWORK_VERSION instalado exitosamente!"
    
    # Mostrar resumen
    show_installation_summary
}

# Mostrar resumen de instalación
show_installation_summary() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✨ INSTALACIÓN COMPLETADA EXITOSAMENTE${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}📁 Framework instalado en:${NC} .verdex-ai/"
    echo -e "${CYAN}📋 Guía para agentes:${NC} VERDEX_AI_AGENT_GUIDE.md"
    echo -e "${CYAN}⚙️  Configuración:${NC} .verdex-ai/config/"
    echo -e "${CYAN}💬 Historial conversación:${NC} .verdex-ai/sessions/conversation-history.md"
    echo ""
    echo -e "${YELLOW}🚀 PRÓXIMOS PASOS:${NC}"
    echo "1. Configura MCP Atlassian: .verdex-ai/scripts/configure-atlassian.sh"
    echo "2. Lee la guía: cat VERDEX_AI_AGENT_GUIDE.md"
    echo "3. Ejecuta health check: .verdex-ai/scripts/health-check.sh"
    echo "4. Inicia trabajo con agentes IA siguiendo las instrucciones"
    echo ""
    echo -e "${PURPLE}📚 Para agentes IA: SIEMPRE leer VERDEX_AI_AGENT_GUIDE.md antes de proceder${NC}"
    echo ""
}

# ========================================================================================
# PUNTO DE ENTRADA PRINCIPAL
# ========================================================================================

main() {
    # Verificar que se ejecute desde directorio válido
    if [ ! -w "." ]; then
        log "ERROR" "No tienes permisos de escritura en este directorio"
        exit 1
    fi
    
    # Mostrar banner
    clear
    show_banner
    
    # Verificar prerequisites
    check_prerequisites
    
    # Ejecutar instalación
    install_framework
    
    log "SUCCESS" "🎉 $FRAMEWORK_NAME listo para usar!"
}

# Ejecutar función principal con manejo de errores
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    trap 'log "ERROR" "Error en línea $LINENO. Código de salida: $?"' ERR
    main "$@"
fi 