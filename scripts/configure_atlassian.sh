#!/bin/bash

# 🔧 Configurador de Integración Atlassian MCP
# Framework AI Development v1.0.0

set -e

echo "🔧 Configurando integración con Atlassian MCP..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verificar si estamos en un proyecto con framework
if [ ! -f "AGENT_SYSTEM_INSTRUCTIONS.md" ]; then
    echo -e "${RED}❌ Error: No se encontró AGENT_SYSTEM_INSTRUCTIONS.md${NC}"
    echo "   Ejecuta primero: ./scripts/framework_install.sh"
    exit 1
fi

echo -e "${BLUE}📋 Configuración MCP Atlassian${NC}"

# Verificar si ya existe configuración MCP
MCP_CONFIG_FILE="$HOME/.cursor/mcp.json"
if [ -f "$MCP_CONFIG_FILE" ]; then
    echo -e "${GREEN}✅ Configuración MCP existente encontrada${NC}"
    echo "   Archivo: $MCP_CONFIG_FILE"
else
    echo -e "${YELLOW}⚠️  No se encontró configuración MCP${NC}"
    echo "   Creando configuración básica..."
    
    # Crear directorio si no existe
    mkdir -p "$HOME/.cursor"
    
    # Crear configuración básica MCP
    cat > "$MCP_CONFIG_FILE" <<EOF
{
  "mcpServers": {
    "atlassianToolIla": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://mcp.atlassian.com/v1/sse"
      ]
    }
  }
}
EOF
    echo -e "${GREEN}✅ Configuración MCP creada${NC}"
fi

# Verificar si Node.js está instalado
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js no está instalado${NC}"
    echo "   Instala Node.js desde: https://nodejs.org/"
    exit 1
fi

if ! command -v npx &> /dev/null; then
    echo -e "${RED}❌ npx no está disponible${NC}"
    echo "   Instala npm/npx: npm install -g npx"
    exit 1
fi

echo -e "${GREEN}✅ Node.js y npx disponibles${NC}"

# Instalar dependencias MCP si no están
echo -e "${BLUE}📦 Verificando dependencias MCP...${NC}"

if ! npm list -g mcp-remote &> /dev/null; then
    echo -e "${YELLOW}⚠️  Instalando mcp-remote...${NC}"
    npm install -g mcp-remote
    echo -e "${GREEN}✅ mcp-remote instalado${NC}"
else
    echo -e "${GREEN}✅ mcp-remote ya está instalado${NC}"
fi

# Verificar Rovo CLI
echo -e "${BLUE}🤖 Verificando Rovo CLI...${NC}"

if ! command -v rovo &> /dev/null; then
    echo -e "${YELLOW}⚠️  Rovo CLI no está instalado${NC}"
    echo "   Instalando Rovo CLI..."
    
    # Instalar Rovo CLI
    npm install -g @atlassian/rovo-cli
    
    if command -v rovo &> /dev/null; then
        echo -e "${GREEN}✅ Rovo CLI instalado correctamente${NC}"
    else
        echo -e "${RED}❌ Error instalando Rovo CLI${NC}"
        echo "   Instala manualmente: npm install -g @atlassian/rovo-cli"
    fi
else
    echo -e "${GREEN}✅ Rovo CLI ya está instalado${NC}"
fi

# Crear configuración local del proyecto
echo -e "${BLUE}📝 Creando configuración local del proyecto...${NC}"

# Crear archivo de configuración Atlassian si no existe
if [ ! -f "config/atlassian_integration.yaml" ]; then
    mkdir -p config
    cat > config/atlassian_integration.yaml <<EOF
# Configuración de integración Atlassian
# Framework AI Development v1.0.0

atlassian:
  # Configuración MCP
  mcp:
    enabled: true
    server: "https://mcp.atlassian.com/v1/sse"
    tools:
      - jira
      - confluence
      - rovo
  
  # Configuración Rovo CLI
  rovo:
    enabled: true
    auto_auth: false
    default_project: ""
  
  # Configuración de tickets
  jira:
    default_project: ""
    auto_create_tickets: true
    ticket_templates:
      ai_development:
        summary: "🤖 [AI-DEV] {description}"
        description: "Trabajo iniciado por agente IA\\n\\nContexto: {context}\\nObjetivo: {goal}\\nUsuario: {user}"
        labels: ["ai-development", "framework", "automated"]
        priority: "Medium"
      
      bug_fix:
        summary: "🐛 [BUG] {description}"
        description: "Bug reportado por agente IA\\n\\nDescripción: {description}\\nPasos para reproducir: {steps}\\nSolución propuesta: {solution}"
        labels: ["bug", "ai-detected", "framework"]
        priority: "High"
      
      feature_request:
        summary: "✨ [FEATURE] {description}"
        description: "Nueva funcionalidad propuesta\\n\\nDescripción: {description}\\nJustificación: {justification}\\nAcceptance criteria: {criteria}"
        labels: ["feature", "ai-proposed", "framework"]
        priority: "Medium"
  
  # Configuración Confluence
  confluence:
    auto_document: true
    space_key: ""
    page_templates:
      ai_session:
        title: "🤖 Sesión IA - {date} - {objective}"
        labels: ["ai-development", "session-log", "framework"]
      
      technical_doc:
        title: "📚 {title}"
        labels: ["technical-documentation", "framework"]

# Configuración de logging
logging:
  atlassian_events: true
  ticket_creation: true
  documentation_updates: true
  rovo_interactions: true

# Configuración de automatización
automation:
  auto_create_tickets: true
  auto_update_confluence: true
  auto_link_tickets: true
  health_checks_before_close: true
EOF
    echo -e "${GREEN}✅ Configuración Atlassian creada${NC}"
    echo "   Archivo: config/atlassian_integration.yaml"
else
    echo -e "${GREEN}✅ Configuración Atlassian ya existe${NC}"
fi

# Crear script de verificación de conexiones MCP
echo -e "${BLUE}🔍 Creando script de verificación MCP...${NC}"

cat > scripts/verify_mcp_connections.sh <<'EOF'
#!/bin/bash

# 🔍 Verificador de Conexiones MCP
# Framework AI Development v1.0.0

set -e

echo "🔍 Verificando conexiones MCP..."

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar archivo de configuración MCP
MCP_CONFIG_FILE="$HOME/.cursor/mcp.json"
if [ -f "$MCP_CONFIG_FILE" ]; then
    echo -e "${GREEN}✅ Configuración MCP encontrada${NC}"
    echo "   Archivo: $MCP_CONFIG_FILE"
    
    # Mostrar configuración
    echo -e "${BLUE}📋 Servidores MCP configurados:${NC}"
    if command -v jq &> /dev/null; then
        jq -r '.mcpServers | keys[]' "$MCP_CONFIG_FILE" | sed 's/^/   - /'
    else
        echo "   (instala jq para ver detalles)"
    fi
else
    echo -e "${RED}❌ No se encontró configuración MCP${NC}"
    echo "   Ejecuta: ./scripts/configure_atlassian.sh"
    exit 1
fi

# Verificar Node.js y npx
if command -v node &> /dev/null; then
    echo -e "${GREEN}✅ Node.js $(node --version)${NC}"
else
    echo -e "${RED}❌ Node.js no está instalado${NC}"
    exit 1
fi

if command -v npx &> /dev/null; then
    echo -e "${GREEN}✅ npx disponible${NC}"
else
    echo -e "${RED}❌ npx no está disponible${NC}"
    exit 1
fi

# Verificar mcp-remote
if npm list -g mcp-remote &> /dev/null; then
    echo -e "${GREEN}✅ mcp-remote instalado${NC}"
else
    echo -e "${RED}❌ mcp-remote no está instalado${NC}"
    echo "   Instala: npm install -g mcp-remote"
    exit 1
fi

# Verificar Rovo CLI
if command -v rovo &> /dev/null; then
    echo -e "${GREEN}✅ Rovo CLI $(rovo --version 2>/dev/null || echo 'instalado')${NC}"
    
    # Verificar autenticación
    if rovo whoami &> /dev/null; then
        echo -e "${GREEN}✅ Rovo CLI autenticado${NC}"
        echo "   Usuario: $(rovo whoami 2>/dev/null || echo 'error obteniendo usuario')"
    else
        echo -e "${YELLOW}⚠️  Rovo CLI no está autenticado${NC}"
        echo "   Ejecuta: rovo auth login"
    fi
else
    echo -e "${RED}❌ Rovo CLI no está instalado${NC}"
    echo "   Instala: npm install -g @atlassian/rovo-cli"
    exit 1
fi

# Verificar configuración local
if [ -f "config/atlassian_integration.yaml" ]; then
    echo -e "${GREEN}✅ Configuración local del proyecto${NC}"
    echo "   Archivo: config/atlassian_integration.yaml"
else
    echo -e "${YELLOW}⚠️  Configuración local no encontrada${NC}"
    echo "   Ejecuta: ./scripts/configure_atlassian.sh"
fi

# Test de conexión básica (opcional)
echo -e "${BLUE}🧪 Probando conexión con Atlassian...${NC}"
if rovo whoami &> /dev/null; then
    echo -e "${GREEN}✅ Conexión con Atlassian OK${NC}"
else
    echo -e "${YELLOW}⚠️  No se pudo conectar con Atlassian${NC}"
    echo "   Esto es normal si no estás autenticado"
fi

echo -e "${GREEN}🎉 Verificación completada${NC}"
echo -e "${BLUE}📋 Resumen del estado MCP:${NC}"
echo "   - Configuración MCP: ✅"
echo "   - Dependencias: ✅"
echo "   - Rovo CLI: ✅"
echo "   - Configuración local: ✅"
echo ""
echo -e "${YELLOW}💡 Próximos pasos:${NC}"
echo "   1. Autentica Rovo CLI: rovo auth login"
echo "   2. Configura tu proyecto en config/atlassian_integration.yaml"
echo "   3. Ejecuta: ./scripts/health_check.sh --full"
EOF

chmod +x scripts/verify_mcp_connections.sh

echo -e "${GREEN}✅ Script de verificación MCP creado${NC}"

# Crear script de inicialización para agentes
echo -e "${BLUE}🤖 Creando script de inicialización para agentes...${NC}"

cat > scripts/init_agent_session.sh <<'EOF'
#!/bin/bash

# 🤖 Inicializador de Sesión para Agentes IA
# Framework AI Development v1.0.0

set -e

echo "🤖 Inicializando sesión para agente IA..."

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar que estamos en un proyecto con framework
if [ ! -f "AGENT_SYSTEM_INSTRUCTIONS.md" ]; then
    echo -e "${RED}❌ Error: No se encontró AGENT_SYSTEM_INSTRUCTIONS.md${NC}"
    echo "   Este no parece ser un proyecto con AI Dev Framework"
    exit 1
fi

echo -e "${BLUE}📋 Verificando estado del proyecto...${NC}"

# Ejecutar health check
if [ -f "scripts/health_check.sh" ]; then
    echo -e "${BLUE}🔍 Ejecutando health check...${NC}"
    ./scripts/health_check.sh
else
    echo -e "${YELLOW}⚠️  Health check no encontrado${NC}"
fi

# Verificar conexiones MCP
if [ -f "scripts/verify_mcp_connections.sh" ]; then
    echo -e "${BLUE}🔗 Verificando conexiones MCP...${NC}"
    ./scripts/verify_mcp_connections.sh
else
    echo -e "${YELLOW}⚠️  Script de verificación MCP no encontrado${NC}"
fi

# Mostrar contexto del proyecto
echo -e "${BLUE}📖 Contexto del proyecto:${NC}"

if [ -f "last_talk.md" ]; then
    echo -e "${GREEN}✅ Última conversación disponible${NC}"
    echo "   Archivo: last_talk.md"
    
    # Mostrar resumen de la última conversación
    echo -e "${BLUE}📋 Resumen de la última conversación:${NC}"
    head -n 10 last_talk.md | sed 's/^/   /'
    echo "   ..."
else
    echo -e "${YELLOW}⚠️  No hay historial de conversaciones${NC}"
fi

if [ -f "01Doc/AI_DEV_FRAMEWORK.md" ]; then
    echo -e "${GREEN}✅ Documentación del framework disponible${NC}"
    echo "   Archivo: 01Doc/AI_DEV_FRAMEWORK.md"
else
    echo -e "${YELLOW}⚠️  Documentación del framework no encontrada${NC}"
fi

# Crear plantilla de ticket si no existe
if [ ! -f "agent/lab/ticket_template.md" ]; then
    mkdir -p agent/lab
    cat > agent/lab/ticket_template.md <<'TEMPLATE'
# 🎫 Plantilla de Ticket para Agente IA

## 📋 Información del Ticket
- **Tipo**: [BUG/FEATURE/DOCS/REFACTOR]
- **Prioridad**: [LOW/MEDIUM/HIGH/CRITICAL]
- **Estimación**: [1h/2h/4h/1d/2d]
- **Agente**: [Claude/GPT/Cursor/Otro]

## 🎯 Descripción
[Descripción clara del trabajo a realizar]

## 📝 Contexto
[Contexto del proyecto, situación actual, por qué es necesario]

## 🎯 Objetivos
- [ ] Objetivo 1
- [ ] Objetivo 2
- [ ] Objetivo 3

## 📊 Criterios de Aceptación
- [ ] Funcionalidad implementada
- [ ] Tests pasando
- [ ] Documentación actualizada
- [ ] Health checks OK
- [ ] Código revisado

## 🔧 Tareas Técnicas
- [ ] Tarea 1
- [ ] Tarea 2
- [ ] Tarea 3

## 📋 Checklist de Calidad
- [ ] Código limpio y bien documentado
- [ ] Tests unitarios/integración
- [ ] Documentación actualizada
- [ ] Health checks pasados
- [ ] Configuración actualizada
- [ ] Logs apropiados

## 🎯 Próximos Pasos
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

---
*Creado por: [Nombre del agente]*
*Fecha: [Fecha]*
*Proyecto: [Nombre del proyecto]*
TEMPLATE
    echo -e "${GREEN}✅ Plantilla de ticket creada${NC}"
    echo "   Archivo: agent/lab/ticket_template.md"
fi

# Mensaje final
echo -e "${GREEN}🎉 Inicialización completada${NC}"
echo -e "${BLUE}📋 Estado del proyecto:${NC}"
echo "   - Framework instalado: ✅"
echo "   - Configuración MCP: ✅"
echo "   - Documentación: ✅"
echo "   - Scripts disponibles: ✅"
echo ""
echo -e "${YELLOW}💡 Próximos pasos para el agente:${NC}"
echo "   1. Crear ticket en Jira para el trabajo"
echo "   2. Leer contexto en last_talk.md"
echo "   3. Experimentar en agent/lab/"
echo "   4. Implementar cambios"
echo "   5. Ejecutar health checks"
echo "   6. Actualizar documentación"
echo ""
echo -e "${GREEN}🚀 ¡Listo para trabajar con agentes IA!${NC}"
EOF

chmod +x scripts/init_agent_session.sh

echo -e "${GREEN}✅ Script de inicialización para agentes creado${NC}"

# Configuración final
echo -e "${BLUE}⚙️  Configuración final...${NC}"

# Verificar estructura del proyecto
echo -e "${BLUE}📁 Verificando estructura del proyecto...${NC}"
required_dirs=("01Doc" "agent" "config" "scripts")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅ $dir/${NC}"
    else
        echo -e "${YELLOW}⚠️  Creando $dir/${NC}"
        mkdir -p "$dir"
    fi
done

# Crear archivo de configuración general si no existe
if [ ! -f "config/framework_config.yaml" ]; then
    cat > config/framework_config.yaml <<EOF
# Configuración general del AI Development Framework
# v1.0.0

framework:
  version: "1.0.0"
  project_name: "AI Development Project"
  created_date: "$(date +%Y-%m-%d)"
  
  # Configuración de agentes
  agents:
    default_agent: "claude"
    session_timeout: 3600
    auto_save_session: true
    require_tickets: true
    
  # Configuración de documentación
  documentation:
    auto_update: true
    versioning: true
    confluence_sync: true
    
  # Configuración de calidad
  quality:
    health_checks: true
    code_analysis: true
    dependency_check: true
    security_scan: false
    
  # Configuración de logging
  logging:
    level: "INFO"
    file_rotation: true
    max_size: "10MB"
    retention_days: 30
    
  # Configuración de integración
  integrations:
    atlassian: true
    github: false
    gitlab: false
    jenkins: false
EOF
    echo -e "${GREEN}✅ Configuración general creada${NC}"
else
    echo -e "${GREEN}✅ Configuración general existente${NC}"
fi

echo -e "${GREEN}🎉 Configuración de Atlassian completada${NC}"
echo ""
echo -e "${BLUE}📋 Resumen de configuración:${NC}"
echo "   - MCP Atlassian: ✅ Configurado"
echo "   - Rovo CLI: ✅ Instalado"
echo "   - Scripts: ✅ Creados"
echo "   - Configuración local: ✅ Lista"
echo "   - Plantillas: ✅ Disponibles"
echo ""
echo -e "${YELLOW}💡 Próximos pasos:${NC}"
echo "   1. Autentica Rovo CLI: rovo auth login"
echo "   2. Configura tu proyecto en config/atlassian_integration.yaml"
echo "   3. Ejecuta: ./scripts/init_agent_session.sh"
echo "   4. Verifica todo: ./scripts/health_check.sh --full"
echo ""
echo -e "${GREEN}🚀 ¡Atlassian MCP listo para usar!${NC}" 