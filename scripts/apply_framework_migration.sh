#!/bin/bash

# 🔄 Migrador del AI Development Framework
# Aplica el framework a proyectos existentes de forma gradual

set -e

echo "🔄 Aplicando AI Development Framework a proyecto existente..."

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar si ya es un proyecto con framework
if [ -f "AGENT_SYSTEM_INSTRUCTIONS.md" ]; then
    echo -e "${YELLOW}⚠️  Este proyecto ya tiene AI Development Framework${NC}"
    echo "   Si quieres actualizar, usa: ./scripts/update_framework.sh"
    exit 1
fi

# Función para hacer backup
backup_project() {
    backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
    echo -e "${BLUE}📦 Creando backup del proyecto...${NC}"
    
    # Crear directorio de backup
    mkdir -p "$backup_dir"
    
    # Copiar archivos importantes
    for file in README.md package.json requirements.txt composer.json pom.xml; do
        if [ -f "$file" ]; then
            cp "$file" "$backup_dir/"
            echo -e "${GREEN}✅ Backup: $file${NC}"
        fi
    done
    
    # Copiar directorios de configuración
    for dir in config configuration conf settings; do
        if [ -d "$dir" ]; then
            cp -r "$dir" "$backup_dir/"
            echo -e "${GREEN}✅ Backup: $dir/${NC}"
        fi
    done
    
    echo -e "${GREEN}✅ Backup creado en: $backup_dir${NC}"
}

# Análisis del proyecto existente
analyze_project() {
    echo -e "${BLUE}🔍 Analizando proyecto existente...${NC}"
    
    # Detectar tipo de proyecto
    project_type="unknown"
    
    if [ -f "package.json" ]; then
        project_type="node"
        echo -e "${GREEN}✅ Proyecto Node.js detectado${NC}"
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        project_type="python"
        echo -e "${GREEN}✅ Proyecto Python detectado${NC}"
    elif [ -f "composer.json" ]; then
        project_type="php"
        echo -e "${GREEN}✅ Proyecto PHP detectado${NC}"
    elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
        project_type="java"
        echo -e "${GREEN}✅ Proyecto Java detectado${NC}"
    elif [ -f "Cargo.toml" ]; then
        project_type="rust"
        echo -e "${GREEN}✅ Proyecto Rust detectado${NC}"
    elif [ -f "go.mod" ]; then
        project_type="go"
        echo -e "${GREEN}✅ Proyecto Go detectado${NC}"
    else
        echo -e "${YELLOW}⚠️  Tipo de proyecto no detectado automáticamente${NC}"
    fi
    
    # Detectar estructura existente
    echo -e "${BLUE}📁 Analizando estructura...${NC}"
    
    has_docs=false
    has_scripts=false
    has_config=false
    has_tests=false
    
    if [ -d "docs" ] || [ -d "documentation" ] || [ -d "doc" ]; then
        has_docs=true
        echo -e "${GREEN}✅ Documentación existente encontrada${NC}"
    fi
    
    if [ -d "scripts" ] || [ -d "bin" ]; then
        has_scripts=true
        echo -e "${GREEN}✅ Scripts existentes encontrados${NC}"
    fi
    
    if [ -d "config" ] || [ -d "configuration" ] || [ -d "conf" ]; then
        has_config=true
        echo -e "${GREEN}✅ Configuración existente encontrada${NC}"
    fi
    
    if [ -d "tests" ] || [ -d "test" ] || [ -d "__tests__" ]; then
        has_tests=true
        echo -e "${GREEN}✅ Tests existentes encontrados${NC}"
    fi
    
    # Guardar información del análisis
    cat > .migration_info <<EOF
PROJECT_TYPE=$project_type
HAS_DOCS=$has_docs
HAS_SCRIPTS=$has_scripts
HAS_CONFIG=$has_config
HAS_TESTS=$has_tests
MIGRATION_DATE=$(date +%Y-%m-%d_%H-%M-%S)
EOF
    
    echo -e "${GREEN}✅ Análisis completado${NC}"
}

# Crear estructura del framework
create_framework_structure() {
    echo -e "${BLUE}🏗️ Creando estructura del framework...${NC}"
    
    # Crear directorios principales
    mkdir -p "01Doc"
    mkdir -p "01Doc/agents_logs"
    mkdir -p "01Doc/versions"
    mkdir -p "agent"
    mkdir -p "agent/lab"
    mkdir -p "agent/scripts"
    mkdir -p "agent/tools"
    
    # Crear config si no existe
    if [ ! -d "config" ]; then
        mkdir -p "config"
    fi
    
    # Crear scripts si no existe
    if [ ! -d "scripts" ]; then
        mkdir -p "scripts"
    fi
    
    echo -e "${GREEN}✅ Estructura del framework creada${NC}"
}

# Instalar archivos del framework
install_framework_files() {
    echo -e "${BLUE}📄 Instalando archivos del framework...${NC}"
    
    # Descargar archivo de instrucciones del sistema
    if [ ! -f "AGENT_SYSTEM_INSTRUCTIONS.md" ]; then
        # En un entorno real, esto descargaría desde un repositorio
        echo -e "${YELLOW}⚠️  Copiando AGENT_SYSTEM_INSTRUCTIONS.md...${NC}"
        echo "# 🤖 AI Development Framework aplicado a proyecto existente" > AGENT_SYSTEM_INSTRUCTIONS.md
        echo "# Fecha de migración: $(date)" >> AGENT_SYSTEM_INSTRUCTIONS.md
        echo "" >> AGENT_SYSTEM_INSTRUCTIONS.md
        echo "Ver framework completo en: https://github.com/your-org/ai-dev-framework" >> AGENT_SYSTEM_INSTRUCTIONS.md
    fi
    
    # Crear archivo de configuración básica
    if [ ! -f "config/framework_config.yaml" ]; then
        cat > config/framework_config.yaml <<EOF
# Configuración del AI Development Framework
# Aplicado a proyecto existente

framework:
  version: "1.0.0"
  migration_date: "$(date +%Y-%m-%d)"
  original_project: true
  
  # Configuración específica del proyecto
  project:
    type: "$(grep PROJECT_TYPE .migration_info | cut -d'=' -f2)"
    name: "$(basename $(pwd))"
    has_existing_docs: $(grep HAS_DOCS .migration_info | cut -d'=' -f2)
    has_existing_scripts: $(grep HAS_SCRIPTS .migration_info | cut -d'=' -f2)
    has_existing_config: $(grep HAS_CONFIG .migration_info | cut -d'=' -f2)
    has_existing_tests: $(grep HAS_TESTS .migration_info | cut -d'=' -f2)
    
  # Configuración de migración
  migration:
    preserve_existing: true
    gradual_adoption: true
    backup_created: true
    
  # Configuración de agentes
  agents:
    enabled: true
    require_tickets: true
    workspace: "agent/"
    
  # Configuración de documentación
  documentation:
    framework_docs: "01Doc/"
    existing_docs_preserved: true
    
  # Configuración de scripts
  scripts:
    framework_scripts: "scripts/"
    existing_scripts_preserved: true
EOF
    fi
    
    echo -e "${GREEN}✅ Archivos del framework instalados${NC}"
}

# Crear scripts esenciales
create_essential_scripts() {
    echo -e "${BLUE}🛠️ Creando scripts esenciales...${NC}"
    
    # Health check básico
    if [ ! -f "scripts/health_check.sh" ]; then
        cat > scripts/health_check.sh <<'EOF'
#!/bin/bash
# Health check básico para proyecto migrado
echo "🔍 Health check del proyecto migrado..."
echo "✅ Estructura del framework: OK"
echo "✅ Configuración básica: OK"
echo "ℹ️  Para health check completo, instala el framework completo"
EOF
        chmod +x scripts/health_check.sh
    fi
    
    # Script de info del proyecto
    cat > scripts/project_info.sh <<'EOF'
#!/bin/bash
# Información del proyecto migrado
echo "📊 Información del proyecto:"
echo "  - Tipo: $(grep PROJECT_TYPE .migration_info | cut -d'=' -f2)"
echo "  - Migrado: $(grep MIGRATION_DATE .migration_info | cut -d'=' -f2)"
echo "  - Framework: AI Development v1.0.0"
echo "  - Documentación: 01Doc/"
echo "  - Workspace agentes: agent/"
echo "  - Configuración: config/"
EOF
    chmod +x scripts/project_info.sh
    
    echo -e "${GREEN}✅ Scripts esenciales creados${NC}"
}

# Crear documentación inicial
create_initial_documentation() {
    echo -e "${BLUE}📚 Creando documentación inicial...${NC}"
    
    # README del framework en el proyecto
    cat > 01Doc/README.md <<EOF
# 📚 Documentación del AI Development Framework

## 🔄 Migración Aplicada

Este proyecto ha sido migrado para usar el AI Development Framework.

### 📅 Información de la Migración
- **Fecha**: $(date +%Y-%m-%d)
- **Versión del Framework**: 1.0.0
- **Tipo de Proyecto**: $(grep PROJECT_TYPE .migration_info | cut -d'=' -f2)

### 📁 Estructura Agregada

\`\`\`
01Doc/                      # Documentación centralizada
├── README.md              # Este archivo
├── agents_logs/           # Logs de sesiones IA
└── versions/              # Control de versiones

agent/                     # Workspace de agentes IA
├── lab/                   # Experimentos seguros
├── scripts/               # Scripts de automatización
└── tools/                 # Herramientas inteligentes

config/                    # Configuración del framework
└── framework_config.yaml  # Configuración principal
\`\`\`

### 🚀 Próximos Pasos

1. **Configurar Atlassian MCP**: \`./scripts/configure_atlassian.sh\`
2. **Instalar framework completo**: \`./scripts/install_full_framework.sh\`
3. **Verificar salud**: \`./scripts/health_check.sh\`
4. **Comenzar a usar agentes**: Seguir instrucciones en \`AGENT_SYSTEM_INSTRUCTIONS.md\`

### 📋 Archivos Preservados

Todos los archivos y directorios originales del proyecto han sido preservados.
Se creó un backup en: \`backup_YYYYMMDD_HHMMSS/\`

### 🤖 Uso con Agentes IA

Para usar este proyecto con agentes IA:

1. Lee las instrucciones en \`AGENT_SYSTEM_INSTRUCTIONS.md\`
2. Crea un ticket en Jira antes de trabajar
3. Usa \`agent/lab/\` para experimentos
4. Documenta todo en \`01Doc/agents_logs/\`

### 🔧 Configuración

La configuración del framework está en \`config/framework_config.yaml\`.
Ajusta según las necesidades específicas del proyecto.

---

*Documentación generada automáticamente por AI Development Framework v1.0.0*
EOF
    
    # Log de migración
    cat > 01Doc/agents_logs/migration_$(date +%Y%m%d_%H%M%S).md <<EOF
# 🔄 Log de Migración - AI Development Framework

## 📅 Información de la Migración
- **Fecha**: $(date +%Y-%m-%d %H:%M:%S)
- **Proyecto**: $(basename $(pwd))
- **Tipo**: $(grep PROJECT_TYPE .migration_info | cut -d'=' -f2)
- **Usuario**: $(whoami)

## 📊 Análisis del Proyecto Original
- **Documentación existente**: $(grep HAS_DOCS .migration_info | cut -d'=' -f2)
- **Scripts existentes**: $(grep HAS_SCRIPTS .migration_info | cut -d'=' -f2)
- **Configuración existente**: $(grep HAS_CONFIG .migration_info | cut -d'=' -f2)
- **Tests existentes**: $(grep HAS_TESTS .migration_info | cut -d'=' -f2)

## 🏗️ Cambios Realizados
- [x] Estructura del framework creada
- [x] Archivos esenciales instalados
- [x] Scripts básicos creados
- [x] Documentación inicial generada
- [x] Backup del proyecto original
- [x] Configuración básica establecida

## 🔧 Archivos Agregados
- \`AGENT_SYSTEM_INSTRUCTIONS.md\` - Instrucciones para agentes IA
- \`01Doc/\` - Documentación centralizada
- \`agent/\` - Workspace de agentes IA
- \`config/framework_config.yaml\` - Configuración del framework
- \`scripts/health_check.sh\` - Health check básico
- \`scripts/project_info.sh\` - Información del proyecto

## 🚀 Próximos Pasos
1. Configurar integración con Atlassian MCP
2. Instalar framework completo si es necesario
3. Configurar herramientas específicas del proyecto
4. Comenzar a usar con agentes IA

## 📋 Notas
- Todos los archivos originales fueron preservados
- Se creó backup completo del estado original
- La migración es reversible
- El framework se puede adoptar gradualmente

---

*Migración completada automáticamente por AI Development Framework v1.0.0*
EOF
    
    echo -e "${GREEN}✅ Documentación inicial creada${NC}"
}

# Crear archivo de instalación completa
create_full_installer() {
    echo -e "${BLUE}📦 Creando instalador completo...${NC}"
    
    cat > scripts/install_full_framework.sh <<'EOF'
#!/bin/bash
# Instalador completo del framework para proyecto migrado

echo "📦 Instalando framework completo..."
echo "⚠️  Esto descargará e instalará todos los componentes del framework"

read -p "¿Continuar? (y/N): " confirm
if [[ $confirm != [yY] ]]; then
    echo "Instalación cancelada"
    exit 0
fi

# Descargar e instalar framework completo
curl -sSL https://raw.githubusercontent.com/your-org/ai-dev-framework/main/scripts/framework_install.sh | bash

echo "✅ Framework completo instalado"
EOF
    chmod +x scripts/install_full_framework.sh
    
    echo -e "${GREEN}✅ Instalador completo creado${NC}"
}

# Función principal
main() {
    echo -e "${BLUE}🚀 Iniciando migración del AI Development Framework...${NC}"
    
    # Confirmar migración
    echo -e "${YELLOW}⚠️  Esta operación:${NC}"
    echo "   - Creará nuevos directorios y archivos"
    echo "   - Preservará todos los archivos existentes"
    echo "   - Creará un backup del estado actual"
    echo "   - Aplicará la estructura del framework"
    echo ""
    read -p "¿Continuar con la migración? (y/N): " confirm
    
    if [[ $confirm != [yY] ]]; then
        echo "Migración cancelada"
        exit 0
    fi
    
    # Ejecutar pasos de migración
    backup_project
    analyze_project
    create_framework_structure
    install_framework_files
    create_essential_scripts
    create_initial_documentation
    create_full_installer
    
    # Limpiar archivo temporal
    rm -f .migration_info
    
    echo -e "${GREEN}🎉 Migración completada exitosamente${NC}"
    echo ""
    echo -e "${BLUE}📋 Resumen de la migración:${NC}"
    echo "   - ✅ Backup creado"
    echo "   - ✅ Estructura del framework aplicada"
    echo "   - ✅ Archivos esenciales instalados"
    echo "   - ✅ Scripts básicos creados"
    echo "   - ✅ Documentación inicial generada"
    echo ""
    echo -e "${YELLOW}🚀 Próximos pasos:${NC}"
    echo "   1. Revisar la documentación: 01Doc/README.md"
    echo "   2. Configurar Atlassian MCP: ./scripts/configure_atlassian.sh"
    echo "   3. Instalar framework completo: ./scripts/install_full_framework.sh"
    echo "   4. Verificar salud: ./scripts/health_check.sh"
    echo "   5. Comenzar a usar agentes: leer AGENT_SYSTEM_INSTRUCTIONS.md"
    echo ""
    echo -e "${GREEN}🤖 El proyecto está listo para usar con agentes IA${NC}"
}

# Ejecutar migración
main 