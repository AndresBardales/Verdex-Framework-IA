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
