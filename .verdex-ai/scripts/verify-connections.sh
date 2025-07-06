#!/bin/bash

# 🔗 Verdex Framework IA - Verificador de Conexiones MCP
# Verifica que las conexiones MCP Atlassian estén configuradas correctamente

set -euo pipefail

# Colores
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Configuración
readonly MCP_CONFIG_FILE="$HOME/.cursor/mcp.json"
readonly LOG_FILE=".verdex-ai/sessions/agent-interactions.log"

# Función de logging
log_interaction() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] INFO MCP_VERIFY - $1" >> "$LOG_FILE" 2>/dev/null || true
}

# Función principal de verificación
verify_mcp_connections() {
    echo -e "${BLUE}🔍 Verificando conexiones MCP Atlassian...${NC}"
    echo ""
    
    # Verificar archivo de configuración MCP
    if [ ! -f "$MCP_CONFIG_FILE" ]; then
        echo -e "${RED}❌ Archivo de configuración MCP no encontrado${NC}"
        echo -e "${YELLOW}   Ubicación esperada: $MCP_CONFIG_FILE${NC}"
        log_interaction "MCP config file not found at $MCP_CONFIG_FILE"
        return 1
    fi
    
    echo -e "${GREEN}✅ Archivo de configuración MCP encontrado${NC}"
    log_interaction "MCP config file found"
    
    # Verificar servidores MCP configurados
    local atlassian_tool=$(grep -o '"atlassianToolIla"' "$MCP_CONFIG_FILE" 2>/dev/null || echo "")
    local calendar_tool=$(grep -o '"MiCalendarioBitToBit"' "$MCP_CONFIG_FILE" 2>/dev/null || echo "")
    
    echo ""
    echo -e "${BLUE}📋 Servidores MCP configurados:${NC}"
    
    if [ -n "$atlassian_tool" ]; then
        echo -e "${GREEN}  ✅ atlassianToolIla (Jira/Confluence)${NC}"
        log_interaction "atlassianToolIla MCP server configured"
    else
        echo -e "${RED}  ❌ atlassianToolIla no configurado${NC}"
        log_interaction "atlassianToolIla MCP server NOT configured"
    fi
    
    if [ -n "$calendar_tool" ]; then
        echo -e "${GREEN}  ✅ MiCalendarioBitToBit (Google Calendar)${NC}"
        log_interaction "MiCalendarioBitToBit MCP server configured"
    else
        echo -e "${YELLOW}  ⚠️  MiCalendarioBitToBit no configurado (opcional)${NC}"
        log_interaction "MiCalendarioBitToBit MCP server NOT configured"
    fi
    
    # Verificar Node.js y mcp-remote
    echo ""
    echo -e "${BLUE}🛠️  Dependencias MCP:${NC}"
    
    if command -v node >/dev/null 2>&1; then
        local node_version=$(node --version)
        echo -e "${GREEN}  ✅ Node.js: $node_version${NC}"
        log_interaction "Node.js available: $node_version"
    else
        echo -e "${RED}  ❌ Node.js no instalado${NC}"
        log_interaction "Node.js NOT available"
        return 1
    fi
    
    if command -v npx >/dev/null 2>&1; then
        echo -e "${GREEN}  ✅ npx disponible${NC}"
        log_interaction "npx available"
        
        # Intentar verificar mcp-remote
        if npx mcp-remote --version >/dev/null 2>&1; then
            echo -e "${GREEN}  ✅ mcp-remote disponible${NC}"
            log_interaction "mcp-remote available"
        else
            echo -e "${YELLOW}  ⚠️  mcp-remote no instalado o no accesible${NC}"
            log_interaction "mcp-remote NOT available"
        fi
    else
        echo -e "${RED}  ❌ npx no disponible${NC}"
        log_interaction "npx NOT available"
    fi
    
    # Mostrar contenido de configuración MCP
    echo ""
    echo -e "${BLUE}📄 Configuración MCP actual:${NC}"
    echo "   (Ubicación: $MCP_CONFIG_FILE)"
    echo ""
    if command -v jq >/dev/null 2>&1; then
        jq '.' "$MCP_CONFIG_FILE" 2>/dev/null || cat "$MCP_CONFIG_FILE"
    else
        cat "$MCP_CONFIG_FILE"
    fi
    
    # Verificar si el framework está configurado
    echo ""
    echo -e "${BLUE}🎯 Estado del Framework:${NC}"
    
    if [ -f ".verdex-ai/config/framework-settings.yaml" ]; then
        echo -e "${GREEN}  ✅ Framework configurado${NC}"
    else
        echo -e "${YELLOW}  ⚠️  Framework no completamente configurado${NC}"
    fi
    
    # Resumen final
    echo ""
    if [ -n "$atlassian_tool" ] && command -v node >/dev/null 2>&1; then
        echo -e "${GREEN}🎉 Conexiones MCP Atlassian configuradas correctamente${NC}"
        echo -e "${BLUE}   ✅ Listo para crear tickets Jira y usar Confluence${NC}"
        log_interaction "MCP verification PASSED - ready for Atlassian integration"
        return 0
    else
        echo -e "${RED}⚠️  Configuración MCP incompleta${NC}"
        echo -e "${YELLOW}   🔧 Ejecuta: .verdex-ai/scripts/configure-atlassian.sh${NC}"
        log_interaction "MCP verification FAILED - configuration incomplete"
        return 1
    fi
}

# Función de ayuda
show_help() {
    echo "🔗 Verdex Framework IA - Verificador de Conexiones MCP"
    echo ""
    echo "Uso: $0 [opciones]"
    echo ""
    echo "Opciones:"
    echo "  -h, --help     Mostrar esta ayuda"
    echo "  -v, --verbose  Modo detallado"
    echo "  -q, --quiet    Modo silencioso"
    echo ""
    echo "Este script verifica que las conexiones MCP Atlassian estén"
    echo "configuradas correctamente para el Verdex Framework IA."
}

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            set -x
            shift
            ;;
        -q|--quiet)
            exec >/dev/null 2>&1
            shift
            ;;
        *)
            echo "Opción desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Ejecutar verificación principal
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    verify_mcp_connections
    exit $?
fi 