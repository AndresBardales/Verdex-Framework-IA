#!/bin/bash

# 🚀 AI DEV FRAMEWORK - Instalador Automático
# Instala el framework de desarrollo inteligente en cualquier proyecto

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emojis para mejor visualización
ROCKET="🚀"
ROBOT="🤖"
GEAR="⚙️"
CHECK="✅"
CROSS="❌"
WARN="⚠️"
INFO="ℹ️"

# Variables globales
FRAMEWORK_VERSION="1.0.0"
PROJECT_NAME=""
IS_NEW_PROJECT=false
INSTALL_DIR=""
GITHUB_REPO="https://raw.githubusercontent.com/ai-dev-framework/core/main"
TEMP_DIR="/tmp/ai-dev-framework-$$"

# Función para mostrar banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════════════╗"
    echo "║                        🚀 AI DEV FRAMEWORK                           ║"
    echo "║                                                                       ║"
    echo "║  Framework de Desarrollo Inteligente para Proyectos con IA          ║"
    echo "║                          Versión $FRAMEWORK_VERSION                         ║"
    echo "╚═══════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

# Función para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}${WARN} $1${NC}"
}

error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

info() {
    echo -e "${BLUE}${INFO} $1${NC}"
}

success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

# Función para detectar sistema operativo
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Función para verificar dependencias
check_dependencies() {
    log "Verificando dependencias..."
    
    local missing_deps=()
    
    # Verificar git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Verificar curl
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    # Verificar python3
    if ! command -v python3 &> /dev/null; then
        missing_deps+=("python3")
    fi
    
    # Verificar tree (opcional)
    if ! command -v tree &> /dev/null; then
        warn "tree no está instalado - se instalará automáticamente"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        error "Faltan dependencias requeridas: ${missing_deps[*]}"
        error "Por favor instala las dependencias faltantes y ejecuta el script nuevamente."
        exit 1
    fi
    
    success "Todas las dependencias están disponibles"
}

# Función para instalar tree si no está disponible
install_tree() {
    if ! command -v tree &> /dev/null; then
        log "Instalando tree..."
        
        local os=$(detect_os)
        case $os in
            "linux")
                if command -v apt-get &> /dev/null; then
                    sudo apt-get update && sudo apt-get install -y tree
                elif command -v yum &> /dev/null; then
                    sudo yum install -y tree
                elif command -v pacman &> /dev/null; then
                    sudo pacman -S --noconfirm tree
                fi
                ;;
            "macos")
                if command -v brew &> /dev/null; then
                    brew install tree
                else
                    warn "Homebrew no está instalado. Instala tree manualmente."
                fi
                ;;
            "windows")
                warn "En Windows, instala tree manualmente o usa WSL."
                ;;
        esac
    fi
}

# Función para crear estructura de directorios
create_directory_structure() {
    log "Creando estructura de directorios..."
    
    # Crear directorios principales
    mkdir -p "$INSTALL_DIR"/{01Doc,agent,config,logs,scripts,integrations}
    
    # Crear subdirectorios de 01Doc
    mkdir -p "$INSTALL_DIR"/01Doc/{agents_logs,versions,confluence,templates}
    mkdir -p "$INSTALL_DIR"/01Doc/agents_logs/templates
    mkdir -p "$INSTALL_DIR"/01Doc/versions/rollback_plans
    
    # Crear subdirectorios de agent
    mkdir -p "$INSTALL_DIR"/agent/{lab,scripts,tools,examples}
    
    # Crear subdirectorios de logs
    mkdir -p "$INSTALL_DIR"/logs/{$(date +%Y-%m-%d),analytics}
    
    # Crear subdirectorios de config
    mkdir -p "$INSTALL_DIR"/config/{templates,environments}
    
    success "Estructura de directorios creada"
}

# Función para crear archivos base
create_base_files() {
    log "Creando archivos base..."
    
    # Crear README.md principal
    cat > "$INSTALL_DIR/README.md" << 'EOF'
# 🚀 Proyecto con AI Dev Framework

Este proyecto utiliza el **AI Dev Framework** para desarrollo inteligente con agentes IA.

## 🎯 Inicio Rápido

```bash
# 1. Leer contexto del proyecto
cat system_context.md

# 2. Verificar estado del sistema
./agent/scripts/health_check.sh

# 3. Iniciar sesión con agente IA
./agent/scripts/ai_assistant.sh
```

## 📚 Documentación

- **[Contexto del Sistema](./system_context.md)** - Información técnica principal
- **[Documentación Completa](./01Doc/README.md)** - Índice de toda la documentación
- **[Guía de Agentes IA](./01Doc/AI_Agent_System_Message.md)** - Protocolo para agentes
- **[Última Conversación](./last_talk.md)** - Resumen de la sesión más reciente

## 🤖 Agentes IA

Este proyecto está configurado para trabajar con agentes IA como:
- Cursor (Claude)
- ChatGPT
- Rovo CLI (Atlassian)
- Y otros agentes compatibles

## 🔧 Configuración

Ver [Guía de Configuración](./01Doc/Configuration_Guide.md) para configurar integraciones.

---
*Generado automáticamente por AI Dev Framework v1.0.0*
EOF

    # Crear system_context.md
    cat > "$INSTALL_DIR/system_context.md" << 'EOF'
# 🧠 SYSTEM CONTEXT - MI PROYECTO

## 🎯 Descripción del Proyecto
[Describe aquí tu proyecto - qué hace, qué problemas resuelve, quiénes son los usuarios]

## 🏗️ Arquitectura del Sistema

### Componentes Principales
- **Frontend**: [Describe el frontend]
- **Backend**: [Describe el backend]
- **Base de Datos**: [Describe la base de datos]
- **Integraciones**: [Describe las integraciones]

### Tecnologías Utilizadas
- **Lenguajes**: [Lista de lenguajes]
- **Frameworks**: [Lista de frameworks]
- **Servicios**: [Lista de servicios]
- **Herramientas**: [Lista de herramientas]

## 🤖 Protocolo para Agentes IA

### Flujo de Trabajo Obligatorio
1. **Leer contexto**: Revisar este archivo y `last_talk.md`
2. **Health check**: Ejecutar `./agent/scripts/health_check.sh`
3. **Crear log**: Generar log de sesión en `01Doc/agents_logs/`
4. **Experimentar**: Usar `agent/lab/` para pruebas
5. **Documentar**: Actualizar `last_talk.md` al finalizar

### Reglas Estrictas
- ❌ NUNCA crear archivos en la raíz del proyecto
- ✅ Usar `agent/lab/` para experimentos temporales
- ✅ Documentar todos los cambios
- ✅ Seguir las convenciones establecidas

## 📊 Estructura de Directorios

```
mi-proyecto/
├── 01Doc/              # Documentación centralizada
├── agent/              # Laboratorio de agentes IA
├── config/             # Configuraciones
├── logs/               # Logs centralizados
├── scripts/            # Scripts de automatización
├── system_context.md   # Este archivo
├── last_talk.md        # Última conversación
└── README.md           # Documentación principal
```

## 🔧 Configuración Actual

### Estado del Proyecto
- **Versión**: 1.0.0
- **Entorno**: Desarrollo
- **Fecha de creación**: $(date +%Y-%m-%d)

### Integraciones Configuradas
- [ ] Jira
- [ ] Confluence 
- [ ] Rovo CLI
- [ ] MQTT Logging
- [ ] Analytics

---
*Actualizado automáticamente por AI Dev Framework*
EOF

    # Crear last_talk.md
    cat > "$INSTALL_DIR/last_talk.md" << 'EOF'
# 💬 Última Conversación con Agentes IA

## 📅 Información de la Sesión
- **Fecha**: $(date +%Y-%m-%d)
- **Hora**: $(date +%H:%M:%S)
- **Agente**: Framework Installer
- **Tipo**: Instalación inicial

## 🎯 Resumen
Se ha instalado exitosamente el AI Dev Framework en el proyecto. 

### ✅ Acciones Realizadas
1. Creación de estructura de directorios
2. Configuración de archivos base
3. Instalación de scripts de automatización
4. Configuración inicial del framework

### 📋 Próximos Pasos
1. Configurar integraciones (Jira, Confluence, etc.)
2. Personalizar `system_context.md` con información del proyecto
3. Ejecutar `./agent/scripts/health_check.sh`
4. Iniciar primera sesión con agente IA

## 🔧 Configuración Pendiente
- [ ] Configurar proyecto Jira
- [ ] Configurar espacio Confluence
- [ ] Configurar Rovo CLI
- [ ] Configurar logging MQTT
- [ ] Personalizar documentación

---
*Generado automáticamente por AI Dev Framework v1.0.0*
EOF

    success "Archivos base creados"
}

# Función para crear archivos de configuración
create_config_files() {
    log "Creando archivos de configuración..."
    
    # Configuración del framework
    cat > "$INSTALL_DIR/config/framework_config.yaml" << 'EOF'
# 🚀 AI Dev Framework - Configuración Principal

framework:
  version: "1.0.0"
  project_name: "Mi Proyecto"
  created_date: "$(date +%Y-%m-%d)"
  
project:
  type: "general"  # web, mobile, desktop, iot, etc.
  stage: "development"  # development, staging, production
  
integrations:
  atlassian:
    enabled: false
    jira_project: ""
    confluence_space: ""
    rovo_cli: false
  
  logging:
    enabled: true
    type: "file"  # file, mqtt, database
    retention_days: 30
    
  analytics:
    enabled: true
    track_ai_interactions: true
    track_development_metrics: true
    
agents:
  allowed_agents:
    - "cursor"
    - "chatgpt"
    - "rovo"
    - "claude"
  
  logging:
    auto_create_session_logs: true
    auto_update_last_talk: true
    
documentation:
  auto_sync_confluence: false
  auto_generate_changelogs: true
  versioning: true
EOF

    # Configuración de logging
    cat > "$INSTALL_DIR/config/logging_config.json" << 'EOF'
{
  "logging": {
    "enabled": true,
    "level": "INFO",
    "retention_days": 30,
    "max_file_size_mb": 10
  },
  "categories": {
    "ai_interactions": true,
    "development_events": true,
    "system_events": true,
    "user_actions": false
  },
  "outputs": {
    "file": {
      "enabled": true,
      "path": "./logs"
    },
    "mqtt": {
      "enabled": false,
      "broker": "localhost",
      "port": 1883,
      "topics": {
        "ai_interactions": "ai/interactions",
        "development": "dev/events",
        "system": "system/events"
      }
    }
  }
}
EOF

    # Configuración de integraciones Atlassian
    cat > "$INSTALL_DIR/config/atlassian_integration.yaml" << 'EOF'
# Configuración de Atlassian (Jira, Confluence, Rovo CLI)

atlassian:
  base_url: ""  # https://tu-dominio.atlassian.net
  email: ""
  api_token: ""  # Token de API de Atlassian
  
jira:
  enabled: false
  project_key: ""
  default_issue_type: "Task"
  auto_create_issues: false
  
confluence:
  enabled: false
  space_key: ""
  auto_sync_docs: false
  sync_folders:
    - "01Doc"
    
rovo:
  enabled: false
  cli_path: "rovo"  # Ruta al comando rovo
  auto_context: true
EOF

    success "Archivos de configuración creados"
}

# Función para crear scripts de automatización
create_automation_scripts() {
    log "Creando scripts de automatización..."
    
    # Script de health check
    cat > "$INSTALL_DIR/agent/scripts/health_check.sh" << 'EOF'
#!/bin/bash

# 🏥 Health Check del Proyecto
# Verifica el estado general del sistema

echo "🏥 Ejecutando Health Check..."
echo "================================"

# Verificar estructura de directorios
echo "📁 Verificando estructura de directorios..."
if [ -d "01Doc" ] && [ -d "agent" ] && [ -d "config" ]; then
    echo "✅ Estructura de directorios OK"
else
    echo "❌ Estructura de directorios incompleta"
fi

# Verificar archivos esenciales
echo "📄 Verificando archivos esenciales..."
if [ -f "system_context.md" ] && [ -f "last_talk.md" ]; then
    echo "✅ Archivos esenciales OK"
else
    echo "❌ Archivos esenciales faltantes"
fi

# Verificar configuración
echo "⚙️ Verificando configuración..."
if [ -f "config/framework_config.yaml" ]; then
    echo "✅ Configuración OK"
else
    echo "❌ Configuración faltante"
fi

# Verificar herramientas
echo "🔧 Verificando herramientas..."
tools_ok=true
if ! command -v git &> /dev/null; then
    echo "❌ Git no está instalado"
    tools_ok=false
fi
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 no está instalado"
    tools_ok=false
fi
if $tools_ok; then
    echo "✅ Herramientas OK"
fi

echo "================================"
echo "🎯 Health Check completado"
EOF

    chmod +x "$INSTALL_DIR/agent/scripts/health_check.sh"
    
    # Script para crear log de sesión
    cat > "$INSTALL_DIR/agent/scripts/create_session_log.sh" << 'EOF'
#!/bin/bash

# 📝 Crear Log de Sesión para Agente IA
# Genera un archivo de log para la sesión actual

AGENT_NAME=${1:-"unknown"}
SESSION_DATE=$(date +%Y-%m-%d)
SESSION_TIME=$(date +%H%M)
LOG_FILE="01Doc/agents_logs/session_${SESSION_DATE}_${SESSION_TIME}_${AGENT_NAME}.md"

echo "📝 Creando log de sesión para: $AGENT_NAME"

cat > "$LOG_FILE" << EOF
# 🤖 Log de Sesión - Agente IA

## 📊 Información de la Sesión
- **Agente**: $AGENT_NAME  
- **Fecha**: $SESSION_DATE
- **Hora**: $(date +%H:%M:%S)
- **Duración**: [A completar al finalizar]

## 🎯 Objetivo de la Sesión
[Describe el objetivo principal de esta sesión]

## 📋 Tareas Realizadas
- [ ] Tarea 1
- [ ] Tarea 2  
- [ ] Tarea 3

## 🔧 Cambios Realizados
### Archivos Modificados
- archivo1.ext - Descripción del cambio
- archivo2.ext - Descripción del cambio

### Archivos Creados
- nuevo_archivo.ext - Propósito del archivo

## 🧪 Experimentos en agent/lab/
- experimento1.py - Descripción
- test_feature.js - Descripción

## 📊 Resultados
### ✅ Éxitos
- Logro 1
- Logro 2

### ❌ Problemas Encontrados
- Problema 1 - Solución aplicada
- Problema 2 - Pendiente de resolver

## 🎯 Próximos Pasos
1. Paso 1
2. Paso 2
3. Paso 3

## 📝 Notas Adicionales
[Cualquier información adicional relevante]

---
*Log generado automáticamente por AI Dev Framework*
EOF

echo "✅ Log de sesión creado: $LOG_FILE"
EOF

    chmod +x "$INSTALL_DIR/agent/scripts/create_session_log.sh"
    
    # Script de configuración inicial
    cat > "$INSTALL_DIR/scripts/setup_project.sh" << 'EOF'
#!/bin/bash

# ⚙️ Configuración Inicial del Proyecto
# Asistente interactivo para configurar el framework

echo "⚙️ Configuración Inicial del AI Dev Framework"
echo "=============================================="

# Solicitar información del proyecto
read -p "📝 Nombre del proyecto: " PROJECT_NAME
read -p "🎯 Descripción breve: " PROJECT_DESCRIPTION
read -p "🏗️ Tipo de proyecto (web/mobile/desktop/iot/other): " PROJECT_TYPE

# Actualizar system_context.md
echo "📄 Actualizando system_context.md..."
sed -i "s/MI PROYECTO/$PROJECT_NAME/" system_context.md
sed -i "s/\[Describe aquí tu proyecto.*\]/$PROJECT_DESCRIPTION/" system_context.md

# Actualizar README.md
echo "📄 Actualizando README.md..."
sed -i "s/Proyecto con AI Dev Framework/$PROJECT_NAME/" README.md

# Actualizar configuración
echo "⚙️ Actualizando configuración..."
sed -i "s/project_name: \"Mi Proyecto\"/project_name: \"$PROJECT_NAME\"/" config/framework_config.yaml
sed -i "s/type: \"general\"/type: \"$PROJECT_TYPE\"/" config/framework_config.yaml

echo "✅ Configuración inicial completada"
echo "📋 Próximos pasos:"
echo "   1. Ejecutar: ./agent/scripts/health_check.sh"
echo "   2. Configurar integraciones si es necesario"
echo "   3. Iniciar sesión con agente IA"
EOF

    chmod +x "$INSTALL_DIR/scripts/setup_project.sh"
    
    success "Scripts de automatización creados"
}

# Función para crear documentación de 01Doc
create_documentation() {
    log "Creando documentación base..."
    
    # README de 01Doc
    cat > "$INSTALL_DIR/01Doc/README.md" << 'EOF'
# 📚 Documentación del Proyecto

## 📋 Índice de Documentos

### 🎯 Documentos Principales
- **[AI_DEV_FRAMEWORK.md](./AI_DEV_FRAMEWORK.md)** - Documentación completa del framework
- **[AI_Agent_System_Message.md](./AI_Agent_System_Message.md)** - Protocolo para agentes IA
- **[Developer_Onboarding_Guide.md](./Developer_Onboarding_Guide.md)** - Guía de incorporación

### 🤖 Sistema de Agentes IA
- **[agents_logs/](./agents_logs/)** - Logs de sesiones con agentes IA
- **[versions/](./versions/)** - Control de versiones y cambios

### 🔧 Configuración y Arquitectura
- **[Technical_Architecture.md](./Technical_Architecture.md)** - Arquitectura técnica
- **[Configuration_Guide.md](./Configuration_Guide.md)** - Guía de configuración
- **[Integration_Patterns.md](./Integration_Patterns.md)** - Patrones de integración

### 📊 Confluence (Sincronización)
- **[confluence/](./confluence/)** - Documentos sincronizados con Confluence

---

## 🎯 Convenciones de Documentación

### 📝 Formato
- Usar Markdown para toda la documentación
- Incluir emojis para mejor legibilidad
- Estructurar con headers claros (#, ##, ###)

### 📅 Versionado
- Mantener historial en `versions/`
- Usar nomenclatura YYYY-MM-DD
- Documentar cambios significativos

### 🔄 Sincronización
- Mantener docs locales como fuente de verdad
- Sincronizar con Confluence cuando esté configurado
- Actualizar automáticamente cuando sea posible

---

*Creado automáticamente por AI Dev Framework*
EOF

    # Guía de mensaje de sistema para agentes IA
    cat > "$INSTALL_DIR/01Doc/AI_Agent_System_Message.md" << 'EOF'
# 🤖 Protocolo de Sistema para Agentes IA

## 📋 Instrucciones Fundamentales

Eres un agente IA trabajando en un proyecto que utiliza el **AI Dev Framework**. Debes seguir estrictamente estos protocolos:

### 🎯 Flujo de Trabajo Obligatorio

1. **📖 Leer Contexto**
   - Leer `system_context.md` para entender el proyecto
   - Revisar `last_talk.md` para continuidad
   - Consultar `01Doc/README.md` para documentación

2. **🏥 Health Check**
   - Ejecutar `./agent/scripts/health_check.sh`
   - Verificar que todos los sistemas funcionen

3. **📝 Crear Log de Sesión**
   - Ejecutar `./agent/scripts/create_session_log.sh [tu-nombre]`
   - Documentar objetivos de la sesión

4. **🧪 Experimentar Seguro**
   - Usar `agent/lab/` para todas las pruebas
   - No crear archivos en la raíz del proyecto

5. **📊 Documentar Cambios**
   - Actualizar `last_talk.md` al finalizar
   - Crear changelog si hay cambios significativos

### ❌ Reglas Estrictas

- **NUNCA** crear archivos en la raíz del proyecto
- **NUNCA** modificar archivos de producción sin pruebas
- **SIEMPRE** usar `agent/lab/` para experimentos
- **SIEMPRE** documentar cambios realizados
- **SIEMPRE** seguir las convenciones establecidas

### ✅ Buenas Prácticas

- Crear backups antes de cambios importantes
- Usar commits descriptivos en git
- Mantener documentación actualizada
- Comunicar cambios significativos
- Seguir los patrones existentes

## 🔧 Herramientas Disponibles

### 📂 Directorios de Trabajo
- `agent/lab/` - Experimentos temporales
- `agent/scripts/` - Scripts de automatización
- `agent/tools/` - Herramientas utilitarias
- `01Doc/` - Documentación central

### 🛠️ Scripts Útiles
- `health_check.sh` - Verificación del sistema
- `create_session_log.sh` - Crear log de sesión
- `setup_project.sh` - Configuración inicial

## 🎯 Ejemplo de Sesión Típica

```bash
# 1. Leer contexto
cat system_context.md
cat last_talk.md

# 2. Health check
./agent/scripts/health_check.sh

# 3. Crear log
./agent/scripts/create_session_log.sh claude

# 4. Trabajar en agent/lab/
cd agent/lab/
# ... hacer experimentos ...

# 5. Aplicar cambios probados
# ... modificar archivos reales ...

# 6. Documentar
# Actualizar last_talk.md con resumen
```

---

*Este protocolo asegura consistencia y trazabilidad en el desarrollo con IA*
EOF

    # README de agents_logs
    cat > "$INSTALL_DIR/01Doc/agents_logs/README.md" << 'EOF'
# 📊 Logs de Sesiones con Agentes IA

## 🎯 Propósito
Este directorio contiene logs detallados de todas las sesiones de trabajo con agentes IA, proporcionando trazabilidad completa del desarrollo.

## 📁 Estructura de Archivos

### 📝 Nomenclatura
```
session_YYYY-MM-DD_HHMM_[agente].md
```

### 🎯 Ejemplos
```
session_2025-07-06_1430_claude.md
session_2025-07-06_1600_cursor.md
session_2025-07-06_1800_rovo.md
```

## 📋 Contenido de Cada Log

### ✅ Información Obligatoria
- **Agente**: Nombre del agente IA (claude, cursor, rovo, etc.)
- **Fecha y Hora**: Cuándo se realizó la sesión
- **Duración**: Tiempo total de la sesión
- **Objetivo**: Qué se quería lograr
- **Cambios**: Archivos modificados o creados
- **Resultados**: Éxitos y problemas encontrados

### 📝 Plantilla Estándar
Ver `templates/session_template.md` para el formato estándar.

## 🔧 Generación Automática

### 🤖 Script de Creación
```bash
./agent/scripts/create_session_log.sh [nombre-agente]
```

### 📊 Análisis de Logs
- Métricas de efectividad por agente
- Patrones de trabajo identificados
- Problemas comunes y soluciones

---

*Sistema de trazabilidad para desarrollo con IA*
EOF

    # Plantilla de sesión
    cat > "$INSTALL_DIR/01Doc/agents_logs/templates/session_template.md" << 'EOF'
# 🤖 Log de Sesión - Agente IA

## 📊 Información de la Sesión
- **Agente**: [Nombre del agente]
- **Fecha**: [YYYY-MM-DD]
- **Hora**: [HH:MM:SS]
- **Duración**: [A completar al finalizar]

## 🎯 Objetivo de la Sesión
[Describe el objetivo principal de esta sesión]

## 📋 Tareas Planificadas
- [ ] Tarea 1
- [ ] Tarea 2
- [ ] Tarea 3

## 🔧 Cambios Realizados
### Archivos Modificados
- archivo1.ext - Descripción del cambio
- archivo2.ext - Descripción del cambio

### Archivos Creados
- nuevo_archivo.ext - Propósito del archivo

## 🧪 Experimentos en agent/lab/
- experimento1.py - Descripción
- test_feature.js - Descripción

## 📊 Resultados
### ✅ Éxitos
- Logro 1
- Logro 2

### ❌ Problemas Encontrados
- Problema 1 - Solución aplicada
- Problema 2 - Pendiente de resolver

## 🎯 Próximos Pasos
1. Paso 1
2. Paso 2
3. Paso 3

## 📝 Notas Adicionales
[Cualquier información adicional relevante]

---
*Log generado por AI Dev Framework*
EOF

    # README de versions
    cat > "$INSTALL_DIR/01Doc/versions/README.md" << 'EOF'
# 📋 Control de Versiones de Documentación

## 🎯 Propósito
Sistema de versionado para documentación y cambios del proyecto, permitiendo trazabilidad completa y capacidad de rollback.

## 📊 Estructura de Archivos

### 📝 Nomenclatura
```
YYYY-MM-DD_changelog.md               # Cambios del día
YYYY-MM-DD_[componente]_v[version].md # Cambio específico
weekly_YYYY-WW_summary.md             # Resumen semanal
```

### 🗂️ Ejemplos
```
2025-07-06_changelog.md
2025-07-06_auth_api_v2.1.md
2025-07-06_framework_v1.0.md
weekly_2025-27_summary.md
```

## 📄 Contenido de Cada Archivo

### ✅ Información Obligatoria
- **Componente**: Qué se modificó
- **Versión**: Número de versión
- **Fecha**: Cuándo se realizó
- **Autor**: Quien hizo el cambio
- **Cambios**: Qué se modificó
- **Impacto**: Cómo afecta al sistema
- **Rollback**: Cómo revertir

## 🔧 Generación Automática

### 📊 Scripts Disponibles
- `generate_changelog.sh` - Generar changelog diario
- `create_version_doc.sh` - Crear documento de versión
- `rollback_changes.sh` - Revertir cambios

---

*Sistema de control de versiones para documentación*
EOF

    success "Documentación base creada"
}

# Función para crear .gitignore
create_gitignore() {
    log "Creando .gitignore..."
    
    cat > "$INSTALL_DIR/.gitignore" << 'EOF'
# 🚀 AI Dev Framework - .gitignore

# Directorios temporales
agent/lab/*
!agent/lab/README.md
!agent/lab/.gitkeep

# Logs
logs/*
!logs/README.md
*.log

# Configuraciones locales
config/local_*
.env
.env.local

# Archivos temporales
*~
*.tmp
*.temp

# Dependencias
node_modules/
venv/
__pycache__/
*.pyc

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Datos sensibles
*secret*
*token*
*password*
*key*

# Backups
*.backup
*.bak
EOF

    # Crear .gitkeep para directorios vacíos
    touch "$INSTALL_DIR/agent/lab/.gitkeep"
    touch "$INSTALL_DIR/logs/.gitkeep"
    
    success ".gitignore creado"
}

# Función para finalizar instalación
finalize_installation() {
    log "Finalizando instalación..."
    
    # Mostrar tree de la estructura creada
    if command -v tree &> /dev/null; then
        echo ""
        echo -e "${CYAN}📁 Estructura del proyecto creada:${NC}"
        cd "$INSTALL_DIR"
        tree -L 3 -a
        echo ""
    fi
    
    # Crear resumen de instalación
    cat > "$INSTALL_DIR/INSTALLATION_SUMMARY.md" << EOF
# 📋 Resumen de Instalación

## 🎯 AI Dev Framework v$FRAMEWORK_VERSION
**Fecha de instalación**: $(date)
**Directorio**: $INSTALL_DIR

## ✅ Componentes Instalados

### 📚 Documentación
- Sistema de documentación completo en \`01Doc/\`
- Plantillas para logs de agentes IA
- Control de versiones integrado

### 🤖 Agentes IA
- Workspace configurado en \`agent/\`
- Scripts de automatización
- Protocolo estándar para agentes

### ⚙️ Configuración
- Archivos de configuración en \`config/\`
- Integración con Atlassian preparada
- Sistema de logging configurado

## 🚀 Próximos Pasos

### 1. Configuración Básica
\`\`\`bash
# Ejecutar configuración inicial
./scripts/setup_project.sh

# Verificar instalación
./agent/scripts/health_check.sh
\`\`\`

### 2. Personalización
- Editar \`system_context.md\` con información del proyecto
- Configurar integraciones en \`config/\`
- Personalizar documentación en \`01Doc/\`

### 3. Primer Uso
- Ejecutar \`./agent/scripts/create_session_log.sh [agente]\`
- Seguir el protocolo en \`01Doc/AI_Agent_System_Message.md\`
- Documentar cambios en \`last_talk.md\`

## 📚 Recursos

### 📖 Documentación
- **[Framework Overview](01Doc/AI_DEV_FRAMEWORK.md)** - Vista general
- **[Agent Protocol](01Doc/AI_Agent_System_Message.md)** - Protocolo para IA
- **[Configuration Guide](01Doc/Configuration_Guide.md)** - Configuración

### 🔗 Enlaces Útiles
- GitHub: https://github.com/ai-dev-framework/core
- Documentación: https://docs.ai-dev-framework.com
- Comunidad: https://discord.gg/ai-dev-framework

---
*Instalación completada exitosamente*
EOF
    
    success "Instalación completada exitosamente"
}

# Función para mostrar resumen final
show_final_summary() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    ${ROCKET} INSTALACIÓN COMPLETADA ${ROCKET}                    ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}📍 Ubicación del proyecto:${NC} $INSTALL_DIR"
    echo ""
    echo -e "${YELLOW}🚀 Próximos pasos:${NC}"
    echo "   1. ${BLUE}cd $INSTALL_DIR${NC}"
    echo "   2. ${BLUE}./scripts/setup_project.sh${NC}"
    echo "   3. ${BLUE}./agent/scripts/health_check.sh${NC}"
    echo "   4. ${BLUE}cat 01Doc/AI_Agent_System_Message.md${NC}"
    echo ""
    echo -e "${PURPLE}📚 Documentación principal:${NC}"
    echo "   • ${BLUE}README.md${NC} - Información general"
    echo "   • ${BLUE}system_context.md${NC} - Contexto del proyecto"
    echo "   • ${BLUE}01Doc/AI_DEV_FRAMEWORK.md${NC} - Documentación completa"
    echo ""
    echo -e "${GREEN}${CHECK} AI Dev Framework v$FRAMEWORK_VERSION instalado exitosamente${NC}"
    echo ""
}

# Función para mostrar ayuda
show_help() {
    echo "🚀 AI Dev Framework - Instalador"
    echo ""
    echo "Uso:"
    echo "  $0 [opciones]"
    echo ""
    echo "Opciones:"
    echo "  --new-project NAME    Crear nuevo proyecto con nombre específico"
    echo "  --directory DIR       Directorio de instalación (por defecto: actual)"
    echo "  --help               Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0                                    # Instalar en directorio actual"
    echo "  $0 --new-project mi-proyecto         # Crear nuevo proyecto"
    echo "  $0 --directory /path/to/proyecto     # Instalar en directorio específico"
    echo ""
}

# Función principal
main() {
    # Procesar argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            --new-project)
                PROJECT_NAME="$2"
                IS_NEW_PROJECT=true
                shift 2
                ;;
            --directory)
                INSTALL_DIR="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Configurar directorio de instalación
    if [ -z "$INSTALL_DIR" ]; then
        if [ "$IS_NEW_PROJECT" = true ]; then
            INSTALL_DIR="./$PROJECT_NAME"
        else
            INSTALL_DIR="."
        fi
    fi
    
    # Convertir a ruta absoluta
    INSTALL_DIR=$(realpath "$INSTALL_DIR")
    
    # Mostrar banner
    show_banner
    
    # Verificar dependencias
    check_dependencies
    
    # Instalar tree si es necesario
    install_tree
    
    # Crear directorio del proyecto si es necesario
    if [ "$IS_NEW_PROJECT" = true ]; then
        mkdir -p "$INSTALL_DIR"
    fi
    
    # Verificar que el directorio existe
    if [ ! -d "$INSTALL_DIR" ]; then
        error "El directorio $INSTALL_DIR no existe"
        exit 1
    fi
    
    # Ejecutar instalación
    create_directory_structure
    create_base_files
    create_config_files
    create_automation_scripts
    create_documentation
    create_gitignore
    finalize_installation
    
    # Mostrar resumen final
    show_final_summary
    
    # Cleanup
    rm -rf "$TEMP_DIR" 2>/dev/null || true
}

# Ejecutar función principal
main "$@" 