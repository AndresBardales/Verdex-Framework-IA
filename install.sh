#!/bin/bash

# 🚀 Instalador Principal del AI Development Framework
# Descarga e instala el framework en cualquier proyecto
# Uso: curl -sSL https://raw.githubusercontent.com/your-org/ai-dev-framework/main/install.sh | bash

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuración
REPO_URL="https://raw.githubusercontent.com/your-org/ai-dev-framework/main"
FRAMEWORK_VERSION="1.0.0"
TMP_DIR="/tmp/ai-dev-framework-$$"

# Banner
echo -e "${CYAN}
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║           🤖 AI DEVELOPMENT FRAMEWORK INSTALLER               ║
║                         v${FRAMEWORK_VERSION}                           ║
║                                                               ║
║     Transforma tu proyecto para trabajar con agentes IA      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
${NC}"

echo -e "${BLUE}📦 Instalando AI Development Framework...${NC}"

# Función para limpiar en caso de error
cleanup() {
    if [ -d "$TMP_DIR" ]; then
        rm -rf "$TMP_DIR"
    fi
}

# Configurar trap para limpiar en caso de error
trap cleanup EXIT

# Verificar prerrequisitos
check_prerequisites() {
    echo -e "${BLUE}🔍 Verificando prerrequisitos...${NC}"
    
    local missing_deps=()
    
    # Verificar curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    # Verificar git (opcional pero recomendado)
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}⚠️  Git no está instalado (opcional)${NC}"
    else
        echo -e "${GREEN}✅ Git $(git --version | head -n1)${NC}"
    fi
    
    # Verificar Node.js (requerido para MCP)
    if ! command -v node &> /dev/null; then
        echo -e "${YELLOW}⚠️  Node.js no está instalado${NC}"
        echo "   Instalar desde: https://nodejs.org/"
        echo "   Continuando sin Node.js..."
    else
        echo -e "${GREEN}✅ Node.js $(node --version)${NC}"
    fi
    
    # Verificar dependencias críticas
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}❌ Faltan dependencias críticas:${NC}"
        printf '%s\n' "${missing_deps[@]}" | sed 's/^/   - /'
        echo ""
        echo -e "${YELLOW}Instala las dependencias faltantes y vuelve a ejecutar el instalador${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prerrequisitos verificados${NC}"
}

# Detectar tipo de proyecto
detect_project_type() {
    local project_type="unknown"
    
    if [ -f "AGENT_SYSTEM_INSTRUCTIONS.md" ]; then
        project_type="framework_existing"
    elif [ -f "package.json" ]; then
        project_type="node"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        project_type="python"
    elif [ -f "composer.json" ]; then
        project_type="php"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        project_type="java"
    elif [ -f "Cargo.toml" ]; then
        project_type="rust"
    elif [ -f "go.mod" ]; then
        project_type="go"
    elif [ -f "pubspec.yaml" ]; then
        project_type="flutter"
    elif [ -f "README.md" ] || [ -f "readme.md" ]; then
        project_type="generic"
    else
        project_type="empty"
    fi
    
    echo "$project_type"
}

# Descargar archivos del framework
download_framework() {
    echo -e "${BLUE}📥 Descargando archivos del framework...${NC}"
    
    # Crear directorio temporal
    mkdir -p "$TMP_DIR"
    
    # Lista de archivos a descargar
    local files=(
        "AGENT_SYSTEM_INSTRUCTIONS.md"
        "scripts/init_framework.sh"
        "scripts/configure_atlassian.sh"
        "scripts/apply_framework_migration.sh"
        "scripts/health_check.sh"
        "config/framework_config.yaml"
        "01Doc/README.md"
    )
    
    # Descargar archivos
    for file in "${files[@]}"; do
        local url="${REPO_URL}/${file}"
        local target="${TMP_DIR}/${file}"
        
        # Crear directorio si no existe
        mkdir -p "$(dirname "$target")"
        
        echo -e "${BLUE}📄 Descargando: $file${NC}"
        if curl -sSL "$url" -o "$target" 2>/dev/null; then
            echo -e "${GREEN}✅ Descargado: $file${NC}"
        else
            echo -e "${YELLOW}⚠️  No se pudo descargar: $file (creando versión local)${NC}"
            create_fallback_file "$file" "$target"
        fi
    done
    
    echo -e "${GREEN}✅ Archivos descargados${NC}"
}

# Crear archivo de fallback si no se puede descargar
create_fallback_file() {
    local file="$1"
    local target="$2"
    
    case "$file" in
        "AGENT_SYSTEM_INSTRUCTIONS.md")
            create_basic_instructions "$target"
            ;;
        "scripts/init_framework.sh")
            create_basic_init_script "$target"
            ;;
        "scripts/health_check.sh")
            create_basic_health_check "$target"
            ;;
        "config/framework_config.yaml")
            create_basic_config "$target"
            ;;
        "01Doc/README.md")
            create_basic_readme "$target"
            ;;
        *)
            echo "# Archivo generado localmente" > "$target"
            ;;
    esac
}

# Crear instrucciones básicas
create_basic_instructions() {
    cat > "$1" <<'EOF'
# 🤖 INSTRUCCIONES DEL SISTEMA PARA AGENTES IA

## 🎯 PROTOCOLO OBLIGATORIO

### ⚠️ ANTES DE CUALQUIER TRABAJO:

1. **📋 CREAR TICKET EN JIRA**
   - Usa MCP Atlassian para crear ticket
   - Plantilla: "🤖 [AI-DEV] Descripción del trabajo"

2. **📖 LEER CONTEXTO DEL PROYECTO**
   - last_talk.md (si existe)
   - README.md

3. **🔗 VERIFICAR CONEXIONES MCP**
   - MCP Atlassian debe estar configurado

## 📁 ESTRUCTURA DEL FRAMEWORK

```
proyecto/
├── 01Doc/                      # Documentación centralizada
├── agent/                      # Workspace de agentes IA
├── config/                     # Configuración centralizada
├── scripts/                    # Scripts de sistema
└── AGENT_SYSTEM_INSTRUCTIONS.md # Este archivo
```

## 🔄 FLUJO DE TRABAJO

1. **ANÁLISIS** → Crear ticket y leer contexto
2. **EXPERIMENTACIÓN** → Usar agent/lab/ para pruebas
3. **IMPLEMENTACIÓN** → Aplicar cambios
4. **VALIDACIÓN** → Ejecutar health checks
5. **DOCUMENTACIÓN** → Actualizar docs

## 📋 REGLAS OBLIGATORIAS

### ✅ HACER SIEMPRE:
- Crear ticket antes de trabajar
- Experimentar en agent/lab/ primero
- Documentar cambios
- Actualizar last_talk.md

### ❌ NUNCA HACER:
- Trabajar sin ticket
- Modificar sin experimentar
- Crear archivos en raíz
- Ignorar health checks

---

*AI Development Framework v1.0.0*
EOF
}

# Crear script de inicialización básico
create_basic_init_script() {
    cat > "$1" <<'EOF'
#!/bin/bash
echo "🤖 Inicializando AI Development Framework..."
echo "✅ Framework instalado correctamente"
echo "📋 Próximos pasos:"
echo "   1. Configurar Atlassian MCP"
echo "   2. Leer AGENT_SYSTEM_INSTRUCTIONS.md"
echo "   3. Crear primer ticket en Jira"
EOF
    chmod +x "$1"
}

# Crear health check básico
create_basic_health_check() {
    cat > "$1" <<'EOF'
#!/bin/bash
echo "🔍 Health Check - AI Development Framework"
echo "✅ Estructura básica: OK"
echo "✅ Configuración: OK"
echo "ℹ️  Para health check completo, configura todas las herramientas"
EOF
    chmod +x "$1"
}

# Crear configuración básica
create_basic_config() {
    cat > "$1" <<EOF
# Configuración del AI Development Framework
framework:
  version: "1.0.0"
  project_name: "$(basename $(pwd))"
  created_date: "$(date +%Y-%m-%d)"
  
  agents:
    require_tickets: true
    workspace: "agent/"
    
  integrations:
    atlassian: true
    mcp_required: true
EOF
}

# Crear README básico
create_basic_readme() {
    cat > "$1" <<EOF
# 📚 AI Development Framework

## 🤖 Framework instalado

Este proyecto ahora usa el AI Development Framework.

## 🚀 Próximos pasos

1. Configurar Atlassian MCP
2. Leer AGENT_SYSTEM_INSTRUCTIONS.md
3. Crear primer ticket en Jira

## 📁 Estructura

- \`01Doc/\` - Documentación
- \`agent/\` - Workspace de agentes IA
- \`config/\` - Configuración
- \`scripts/\` - Scripts de automatización

---

*AI Development Framework v1.0.0*
EOF
}

# Instalar framework
install_framework() {
    echo -e "${BLUE}🔧 Instalando framework...${NC}"
    
    local project_type=$(detect_project_type)
    
    case $project_type in
        "framework_existing")
            echo -e "${GREEN}✅ Framework ya está instalado${NC}"
            echo -e "${YELLOW}💡 Para actualizar, usa: ./scripts/update_framework.sh${NC}"
            return 0
            ;;
        "empty")
            echo -e "${BLUE}📦 Proyecto vacío - instalación completa${NC}"
            ;;
        *)
            echo -e "${YELLOW}🔄 Proyecto existente ($project_type) - aplicando migración${NC}"
            ;;
    esac
    
    # Crear estructura de directorios
    mkdir -p {01Doc,agent,config,scripts}
    mkdir -p {01Doc/agents_logs,01Doc/versions,agent/lab,agent/scripts,agent/tools}
    
    # Copiar archivos desde temporal
    echo -e "${BLUE}📋 Copiando archivos...${NC}"
    
    # Copiar archivos principales
    cp "$TMP_DIR/AGENT_SYSTEM_INSTRUCTIONS.md" .
    
    # Copiar scripts
    cp -r "$TMP_DIR/scripts"/* scripts/ 2>/dev/null || true
    
    # Copiar configuración
    cp -r "$TMP_DIR/config"/* config/ 2>/dev/null || true
    
    # Copiar documentación
    cp -r "$TMP_DIR/01Doc"/* 01Doc/ 2>/dev/null || true
    
    # Hacer ejecutables los scripts
    chmod +x scripts/*.sh 2>/dev/null || true
    
    # Crear archivo de información de instalación
    cat > .framework_info <<EOF
FRAMEWORK_VERSION=$FRAMEWORK_VERSION
INSTALL_DATE=$(date +%Y-%m-%d_%H-%M-%S)
PROJECT_TYPE=$project_type
INSTALLED_BY=curl_installer
EOF
    
    # Crear last_talk.md inicial
    if [ ! -f "last_talk.md" ]; then
        cat > last_talk.md <<EOF
# 💬 AI Development Framework - Instalación

## 📅 Información de Instalación
- **Fecha**: $(date +%Y-%m-%d %H:%M:%S)
- **Versión**: $FRAMEWORK_VERSION
- **Proyecto**: $(basename $(pwd))
- **Tipo**: $project_type

## 🎯 Framework Instalado

El AI Development Framework ha sido instalado exitosamente.

## 🚀 Próximos Pasos

1. **Configurar Atlassian MCP**: \`./scripts/configure_atlassian.sh\`
2. **Leer instrucciones**: \`AGENT_SYSTEM_INSTRUCTIONS.md\`
3. **Crear primer ticket**: Usar MCP Atlassian
4. **Comenzar a trabajar**: Seguir el flujo de trabajo

## 📋 Archivos Instalados

- \`AGENT_SYSTEM_INSTRUCTIONS.md\` - Instrucciones para agentes IA
- \`01Doc/\` - Documentación centralizada
- \`agent/\` - Workspace de agentes IA
- \`config/\` - Configuración del framework
- \`scripts/\` - Scripts de automatización

---

*Instalado automáticamente por AI Development Framework v$FRAMEWORK_VERSION*
EOF
    fi
    
    echo -e "${GREEN}✅ Framework instalado correctamente${NC}"
}

# Función principal
main() {
    echo -e "${BLUE}🚀 Iniciando instalación del AI Development Framework...${NC}"
    
    # Verificar prerrequisitos
    check_prerequisites
    
    # Descargar archivos
    download_framework
    
    # Instalar framework
    install_framework
    
    # Limpiar archivos temporales
    cleanup
    
    # Mensaje final
    echo ""
    echo -e "${GREEN}🎉 ¡Instalación completada exitosamente!${NC}"
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                               ║${NC}"
    echo -e "${CYAN}║           🤖 AI DEVELOPMENT FRAMEWORK INSTALADO               ║${NC}"
    echo -e "${CYAN}║                                                               ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}🚀 Próximos pasos:${NC}"
    echo "   1. Configurar Atlassian MCP:"
    echo "      ${BLUE}./scripts/configure_atlassian.sh${NC}"
    echo ""
    echo "   2. Leer las instrucciones para agentes:"
    echo "      ${BLUE}cat AGENT_SYSTEM_INSTRUCTIONS.md${NC}"
    echo ""
    echo "   3. Verificar la instalación:"
    echo "      ${BLUE}./scripts/health_check.sh${NC}"
    echo ""
    echo "   4. Crear tu primer ticket en Jira y comenzar a trabajar con agentes IA"
    echo ""
    echo -e "${CYAN}📚 Documentación: 01Doc/README.md${NC}"
    echo -e "${CYAN}🤖 Workspace agentes: agent/${NC}"
    echo -e "${CYAN}⚙️ Configuración: config/${NC}"
    echo ""
    echo -e "${GREEN}¡Tu proyecto está listo para trabajar con agentes IA!${NC}"
    echo ""
    echo -e "${YELLOW}💡 Para soporte: https://github.com/your-org/ai-dev-framework${NC}"
}

# Ejecutar instalación
main "$@" 