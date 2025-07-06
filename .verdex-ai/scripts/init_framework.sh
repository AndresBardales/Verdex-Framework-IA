#!/bin/bash

# 🚀 Inicializador Rápido del AI Development Framework
# Script principal para inicializar el framework en cualquier proyecto

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${CYAN}
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║           🤖 AI DEVELOPMENT FRAMEWORK v1.0.0                 ║
║                                                               ║
║     Transforma tu proyecto para trabajar con agentes IA      ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
${NC}"

echo -e "${BLUE}🚀 Inicializando AI Development Framework...${NC}"

# Función para mostrar ayuda
show_help() {
    echo -e "${YELLOW}📋 Uso: ./scripts/init_framework.sh [OPCIONES]${NC}"
    echo ""
    echo -e "${BLUE}Opciones:${NC}"
    echo "  --new-project        Inicializar en proyecto nuevo"
    echo "  --existing-project   Migrar proyecto existente"
    echo "  --quick-setup        Configuración rápida (recomendado)"
    echo "  --full-setup         Configuración completa"
    echo "  --verify-only        Solo verificar instalación"
    echo "  --help               Mostrar esta ayuda"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  ./scripts/init_framework.sh --quick-setup"
    echo "  ./scripts/init_framework.sh --existing-project"
    echo "  ./scripts/init_framework.sh --verify-only"
}

# Función para detectar tipo de proyecto
detect_project_type() {
    if [ -f "AGENT_SYSTEM_INSTRUCTIONS.md" ]; then
        echo "framework_existing"
    elif [ -f "package.json" ] || [ -f "yarn.lock" ]; then
        echo "node_existing"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        echo "python_existing"
    elif [ -f "composer.json" ]; then
        echo "php_existing"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        echo "java_existing"
    elif [ -f "Cargo.toml" ]; then
        echo "rust_existing"
    elif [ -f "go.mod" ]; then
        echo "go_existing"
    elif [ -f "pubspec.yaml" ]; then
        echo "flutter_existing"
    elif [ -f "README.md" ] || [ -f "readme.md" ]; then
        echo "generic_existing"
    else
        echo "new_project"
    fi
}

# Función para verificar prerrequisitos
check_prerequisites() {
    echo -e "${BLUE}🔍 Verificando prerrequisitos...${NC}"
    
    local missing_deps=()
    
    # Verificar Node.js
    if ! command -v node &> /dev/null; then
        missing_deps+=("Node.js")
    else
        echo -e "${GREEN}✅ Node.js $(node --version)${NC}"
    fi
    
    # Verificar npm
    if ! command -v npm &> /dev/null; then
        missing_deps+=("npm")
    else
        echo -e "${GREEN}✅ npm $(npm --version)${NC}"
    fi
    
    # Verificar git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    else
        echo -e "${GREEN}✅ git $(git --version | head -n1)${NC}"
    fi
    
    # Verificar curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    else
        echo -e "${GREEN}✅ curl disponible${NC}"
    fi
    
    # Verificar dependencias faltantes
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}❌ Faltan dependencias requeridas:${NC}"
        printf '%s\n' "${missing_deps[@]}" | sed 's/^/   - /'
        echo ""
        echo -e "${YELLOW}📋 Instrucciones de instalación:${NC}"
        echo "   - Node.js: https://nodejs.org/"
        echo "   - npm: viene con Node.js"
        echo "   - git: sudo apt install git (Ubuntu/Debian)"
        echo "   - curl: sudo apt install curl (Ubuntu/Debian)"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Todos los prerrequisitos están instalados${NC}"
}

# Función para configuración rápida
quick_setup() {
    echo -e "${BLUE}⚡ Configuración rápida...${NC}"
    
    local project_type=$(detect_project_type)
    
    case $project_type in
        "framework_existing")
            echo -e "${GREEN}✅ Framework ya está instalado${NC}"
            verify_installation
            ;;
        "new_project")
            echo -e "${YELLOW}📦 Nuevo proyecto detectado${NC}"
            install_new_project
            ;;
        *_existing)
            echo -e "${YELLOW}🔄 Proyecto existente detectado: ${project_type%_existing}${NC}"
            migrate_existing_project
            ;;
    esac
}

# Función para instalar en proyecto nuevo
install_new_project() {
    echo -e "${BLUE}🆕 Instalando framework en proyecto nuevo...${NC}"
    
    # Verificar si hay archivos en el directorio
    if [ "$(ls -A .)" ]; then
        echo -e "${YELLOW}⚠️  El directorio no está vacío${NC}"
        echo "   Aplicando migración en su lugar..."
        migrate_existing_project
        return
    fi
    
    # Crear estructura básica
    mkdir -p {01Doc,agent,config,scripts}
    mkdir -p {01Doc/agents_logs,01Doc/versions,agent/lab,agent/scripts,agent/tools}
    
    # Descargar archivos del framework
    echo -e "${BLUE}📦 Descargando archivos del framework...${NC}"
    
    # Crear archivo de instrucciones del sistema
    curl -sSL https://raw.githubusercontent.com/your-org/ai-dev-framework/main/AGENT_SYSTEM_INSTRUCTIONS.md > AGENT_SYSTEM_INSTRUCTIONS.md 2>/dev/null || create_basic_instructions
    
    # Crear README básico
    create_basic_readme
    
    # Crear configuración inicial
    create_initial_config
    
    echo -e "${GREEN}✅ Framework instalado en proyecto nuevo${NC}"
}

# Función para migrar proyecto existente
migrate_existing_project() {
    echo -e "${BLUE}🔄 Migrando proyecto existente...${NC}"
    
    # Ejecutar script de migración si existe
    if [ -f "scripts/apply_framework_migration.sh" ]; then
        ./scripts/apply_framework_migration.sh
    else
        # Migración básica
        echo -e "${YELLOW}⚠️  Script de migración no encontrado, aplicando migración básica${NC}"
        
        # Crear estructura
        mkdir -p {01Doc,agent,config}
        mkdir -p {01Doc/agents_logs,01Doc/versions,agent/lab,agent/scripts,agent/tools}
        
        # Crear archivos básicos
        create_basic_instructions
        create_basic_readme
        create_initial_config
        
        echo -e "${GREEN}✅ Migración básica completada${NC}"
    fi
}

# Función para crear instrucciones básicas
create_basic_instructions() {
    cat > AGENT_SYSTEM_INSTRUCTIONS.md <<'EOF'
# 🤖 INSTRUCCIONES DEL SISTEMA PARA AGENTES IA

## 🎯 PROTOCOLO OBLIGATORIO

### ⚠️ ANTES DE CUALQUIER TRABAJO:

1. **📋 CREAR TICKET EN JIRA**
   - Usa MCP Atlassian para crear ticket
   - Plantilla: "🤖 [AI-DEV] Descripción del trabajo"
   - Labels: ai-development, framework, automated

2. **📖 LEER CONTEXTO DEL PROYECTO**
   - last_talk.md (si existe)
   - README.md
   - 01Doc/AI_DEV_FRAMEWORK.md (si existe)

3. **🔗 VERIFICAR CONEXIONES MCP**
   - MCP Atlassian debe estar configurado
   - Verificar: ~/.cursor/mcp.json

## 📁 ESTRUCTURA DEL FRAMEWORK

```
proyecto/
├── 01Doc/                      # Documentación centralizada
├── agent/                      # Workspace de agentes IA
│   ├── lab/                   # Experimentos seguros
│   ├── scripts/               # Scripts de automatización
│   └── tools/                 # Herramientas inteligentes
├── config/                    # Configuración centralizada
├── scripts/                   # Scripts de sistema
└── AGENT_SYSTEM_INSTRUCTIONS.md # Este archivo
```

## 🔄 FLUJO DE TRABAJO

1. **ANÁLISIS** → Crear ticket y leer contexto
2. **PLANIFICACIÓN** → Definir scope y tareas
3. **EXPERIMENTACIÓN** → Usar agent/lab/ para pruebas
4. **IMPLEMENTACIÓN** → Aplicar cambios al código
5. **VALIDACIÓN** → Ejecutar health checks
6. **DOCUMENTACIÓN** → Actualizar docs y cerrar ticket

## 📋 REGLAS OBLIGATORIAS

### ✅ HACER SIEMPRE:
- Crear ticket antes de trabajar
- Experimentar en agent/lab/ primero
- Documentar todos los cambios
- Actualizar last_talk.md al finalizar
- Ejecutar health checks antes de finalizar

### ❌ NUNCA HACER:
- Trabajar sin ticket asociado
- Modificar código sin experimentar primero
- Crear archivos en la raíz del proyecto
- Ignorar health checks
- Trabajar sin leer contexto

## 🎯 PREGUNTAS OBLIGATORIAS AL USUARIO

**AL INICIAR:**
1. "🎫 ¿Tienes un ticket de Jira para este trabajo?"
2. "🔧 ¿Qué objetivo específico quieres lograr?"
3. "📊 ¿Necesitas que analice el estado actual del proyecto?"

**AL FINALIZAR:**
1. "📝 ¿Quieres que actualice el ticket con los resultados?"
2. "🔗 ¿Debo crear documentación en Confluence?"
3. "🎯 ¿Hay tareas de seguimiento para próximas sesiones?"

## 🛠️ COMANDOS ÚTILES

```bash
# Verificar salud del proyecto
./scripts/health_check.sh

# Configurar Atlassian MCP
./scripts/configure_atlassian.sh

# Inicializar sesión de agente
./scripts/init_agent_session.sh

# Información del proyecto
./scripts/project_info.sh
```

---

*AI Development Framework v1.0.0*
*Integración MCP Atlassian Requerida*
EOF
}

# Función para crear README básico
create_basic_readme() {
    if [ ! -f "README.md" ]; then
        cat > README.md <<EOF
# 🤖 Proyecto con AI Development Framework

Este proyecto usa el AI Development Framework para colaboración humano-IA.

## 🚀 Inicio Rápido

\`\`\`bash
# Configurar integración Atlassian
./scripts/configure_atlassian.sh

# Verificar salud del proyecto
./scripts/health_check.sh

# Inicializar sesión de agente
./scripts/init_agent_session.sh
\`\`\`

## 📁 Estructura

- \`01Doc/\` - Documentación centralizada
- \`agent/\` - Workspace de agentes IA
- \`config/\` - Configuración del framework
- \`scripts/\` - Scripts de automatización

## 🤖 Uso con Agentes IA

1. Lee las instrucciones en \`AGENT_SYSTEM_INSTRUCTIONS.md\`
2. Crea un ticket en Jira antes de trabajar
3. Usa \`agent/lab/\` para experimentos
4. Documenta todo en \`01Doc/agents_logs/\`

## 🔧 Configuración

Ver \`config/framework_config.yaml\` para configuración.

---

*Proyecto creado con AI Development Framework v1.0.0*
EOF
    fi
}

# Función para crear configuración inicial
create_initial_config() {
    cat > config/framework_config.yaml <<EOF
# Configuración del AI Development Framework
framework:
  version: "1.0.0"
  project_name: "$(basename $(pwd))"
  created_date: "$(date +%Y-%m-%d)"
  
  # Configuración de agentes
  agents:
    require_tickets: true
    workspace: "agent/"
    default_agent: "claude"
    
  # Configuración de documentación
  documentation:
    auto_update: true
    framework_docs: "01Doc/"
    
  # Configuración de integración
  integrations:
    atlassian: true
    mcp_required: true
    
  # Configuración de calidad
  quality:
    health_checks: true
    code_analysis: true
EOF
}

# Función para verificar instalación
verify_installation() {
    echo -e "${BLUE}🔍 Verificando instalación...${NC}"
    
    local issues=()
    
    # Verificar estructura
    if [ ! -f "AGENT_SYSTEM_INSTRUCTIONS.md" ]; then
        issues+=("Falta AGENT_SYSTEM_INSTRUCTIONS.md")
    fi
    
    if [ ! -d "01Doc" ]; then
        issues+=("Falta directorio 01Doc/")
    fi
    
    if [ ! -d "agent" ]; then
        issues+=("Falta directorio agent/")
    fi
    
    if [ ! -d "config" ]; then
        issues+=("Falta directorio config/")
    fi
    
    if [ ! -d "scripts" ]; then
        issues+=("Falta directorio scripts/")
    fi
    
    # Verificar configuración MCP
    if [ ! -f "$HOME/.cursor/mcp.json" ]; then
        issues+=("Falta configuración MCP en ~/.cursor/mcp.json")
    fi
    
    # Mostrar resultados
    if [ ${#issues[@]} -gt 0 ]; then
        echo -e "${RED}❌ Problemas encontrados:${NC}"
        printf '%s\n' "${issues[@]}" | sed 's/^/   - /'
        echo ""
        echo -e "${YELLOW}💡 Solución: Ejecuta ./scripts/init_framework.sh --quick-setup${NC}"
        return 1
    else
        echo -e "${GREEN}✅ Instalación verificada correctamente${NC}"
        return 0
    fi
}

# Función para configuración completa
full_setup() {
    echo -e "${BLUE}🔧 Configuración completa...${NC}"
    
    # Ejecutar configuración rápida primero
    quick_setup
    
    # Configurar Atlassian MCP
    if [ -f "scripts/configure_atlassian.sh" ]; then
        echo -e "${BLUE}🔗 Configurando Atlassian MCP...${NC}"
        ./scripts/configure_atlassian.sh
    else
        echo -e "${YELLOW}⚠️  Script de configuración Atlassian no encontrado${NC}"
    fi
    
    # Ejecutar health check
    if [ -f "scripts/health_check.sh" ]; then
        echo -e "${BLUE}🔍 Ejecutando health check...${NC}"
        ./scripts/health_check.sh
    fi
    
    echo -e "${GREEN}✅ Configuración completa terminada${NC}"
}

# Función principal
main() {
    local mode=""
    
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --new-project)
                mode="new"
                shift
                ;;
            --existing-project)
                mode="existing"
                shift
                ;;
            --quick-setup)
                mode="quick"
                shift
                ;;
            --full-setup)
                mode="full"
                shift
                ;;
            --verify-only)
                mode="verify"
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Opción desconocida: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Si no se especifica modo, usar configuración rápida
    if [ -z "$mode" ]; then
        mode="quick"
    fi
    
    # Verificar prerrequisitos
    check_prerequisites
    
    # Ejecutar según el modo
    case $mode in
        "new")
            install_new_project
            ;;
        "existing")
            migrate_existing_project
            ;;
        "quick")
            quick_setup
            ;;
        "full")
            full_setup
            ;;
        "verify")
            verify_installation
            ;;
    esac
    
    # Mensaje final
    echo ""
    echo -e "${GREEN}🎉 Inicialización completada${NC}"
    echo ""
    echo -e "${YELLOW}🚀 Próximos pasos:${NC}"
    echo "   1. Configurar Atlassian MCP: ./scripts/configure_atlassian.sh"
    echo "   2. Crear primer ticket en Jira"
    echo "   3. Leer instrucciones: AGENT_SYSTEM_INSTRUCTIONS.md"
    echo "   4. Comenzar a trabajar con agentes IA"
    echo ""
    echo -e "${CYAN}📚 Documentación completa en: 01Doc/README.md${NC}"
    echo -e "${CYAN}🤖 Instrucciones para agentes: AGENT_SYSTEM_INSTRUCTIONS.md${NC}"
}

# Ejecutar función principal
main "$@" 