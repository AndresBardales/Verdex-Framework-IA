#!/bin/bash

# 🔧 Verdex Framework IA v3.0 - Configurador de Atlassian
# Script para configurar la integración con Atlassian por primera vez

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

# Header
echo -e "${BLUE}"
echo "=============================================="
echo "🔧 CONFIGURADOR DE ATLASSIAN - VERDEX v3.0"
echo "=============================================="
echo -e "${NC}"

# Verificar si ya está configurado
CONFIG_FILE=".verdex-ai/config/atlassian-connection.yaml"

if [[ -f "$CONFIG_FILE" ]]; then
    print_warning "Atlassian ya está configurado. ¿Quieres reconfigurarlo? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_info "Configuración cancelada."
        exit 0
    fi
fi

# Solicitar información al usuario
echo ""
print_info "Necesito algunos datos para configurar la integración con Atlassian:"
echo ""

# URL de Jira
echo -n "🔗 URL de tu instancia Jira (ej: https://tuempresa.atlassian.net): "
read -r jira_url

# Validar URL
if [[ ! "$jira_url" =~ ^https://.*\.atlassian\.net$ ]]; then
    print_warning "⚠️ La URL debería tener el formato: https://tuempresa.atlassian.net"
    echo -n "¿Continuar de todas formas? (y/N): "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_error "Configuración cancelada. Por favor verifica la URL."
        exit 1
    fi
fi

# Project Key
echo -n "🎫 Clave del proyecto Jira (ej: PROJ, DEV, ADA): "
read -r project_key

# Convertir a mayúsculas
project_key=$(echo "$project_key" | tr '[:lower:]' '[:upper:]')

# Confluence Space
echo -n "📚 Espacio de Confluence (ej: DEV, DOCS, TEAM): "
read -r confluence_space

# Cloud ID (opcional)
echo -n "☁️ Cloud ID (opcional, se puede detectar automáticamente): "
read -r cloud_id

# Crear archivo de configuración
echo ""
print_info "Creando configuración de Atlassian..."

cat > "$CONFIG_FILE" << EOF
# Configuración de Atlassian para Verdex Framework IA v3.0
# Fecha de configuración: $(date)

atlassian:
  configured: true
  jira_url: "$jira_url"
  project_key: "$project_key"
  confluence_space: "$confluence_space"
  cloud_id: "$cloud_id"
  
  # Configuración de trabajo
  auto_ticket_creation: false
  ask_for_existing_ticket: true
  
  # Configurado en: $(date)
  setup_date: "$(date -Iseconds)"
  setup_by: "$(whoami)"
EOF

print_status "Configuración guardada en: $CONFIG_FILE"

# Actualizar el framework-settings.yaml principal
print_info "Actualizando configuración principal del framework..."

# Crear backup
cp .verdex-ai/config/framework-settings.yaml .verdex-ai/config/framework-settings.yaml.bak

# Usar sed para actualizar valores específicos
sed -i 's/configured: false/configured: true/' .verdex-ai/config/framework-settings.yaml
sed -i 's/atlassian_setup_required: true/atlassian_setup_required: false/' .verdex-ai/config/framework-settings.yaml

print_status "Configuración principal actualizada"

# Verificar MCP
echo ""
print_info "Verificando conexión MCP con Atlassian..."

if command -v .verdex-ai/scripts/verify-connections.sh &> /dev/null; then
    .verdex-ai/scripts/verify-connections.sh
else
    print_warning "Script de verificación no encontrado. Verificación manual requerida."
fi

# Resumen
echo ""
print_status "🎉 ¡Configuración de Atlassian completada!"
echo ""
echo "📋 Resumen de configuración:"
echo "   • Jira URL: $jira_url"
echo "   • Proyecto: $project_key"
echo "   • Confluence: $confluence_space"
echo "   • Cloud ID: ${cloud_id:-'(auto-detect)'}"
echo ""
print_info "Ya puedes usar el framework con integración completa de Atlassian."
print_info "Los agentes IA ahora preguntarán por tickets existentes antes de crear nuevos."
echo "" 