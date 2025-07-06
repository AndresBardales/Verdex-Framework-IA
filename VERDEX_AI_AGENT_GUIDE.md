# 🤖 VERDEX FRAMEWORK IA - GUÍA PARA AGENTES

> **Framework de Desarrollo IA Empresarial con Integración Atlassian Obligatoria**

---

## 🎯 PROTOCOLO DE INICIALIZACIÓN OBLIGATORIO

### 📋 CHECKLIST INICIAL (OBLIGATORIO - NO OMITIR)

Antes de cualquier trabajo, el agente DEBE:

1. **📍 Verificar ubicación del framework:**
   ```bash
   ls -la .verdex-ai/
   ```

2. **📖 Leer historial de conversación:**
   ```bash
   cat .verdex-ai/sessions/conversation-history.md
   ```

3. **🔗 Verificar conexiones MCP Atlassian:**
   ```bash
   .verdex-ai/scripts/verify-connections.sh
   ```

4. **🎫 CREAR TICKET JIRA OBLIGATORIO:**
   - Usar MCP Atlassian para crear ticket antes de cualquier trabajo
   - No proceder sin ticket válido
   - Usar plantillas en `.verdex-ai/templates/jira-tickets/`

5. **📝 Actualizar log de sesión:**
   ```bash
   echo "$(date): Agente inicializado - Ticket: [TICKET-ID]" >> .verdex-ai/sessions/agent-interactions.log
   ```

---

## 🔄 FLUJO DE TRABAJO ESTÁNDAR

### 🚀 Fase 1: ANÁLISIS
```bash
# 1. Verificar estado del proyecto
.verdex-ai/scripts/health-check.sh

# 2. Analizar solicitud del usuario
# 3. Identificar tipo de trabajo (Bug/Feature/Docs/Refactor)
```

### 📋 Fase 2: PLANIFICACIÓN
- Crear ticket Jira con descripción detallada
- Documentar plan en `.verdex-ai/sessions/conversation-history.md`
- Definir experimentos necesarios en `.verdex-ai/lab/`

### 🧪 Fase 3: EXPERIMENTACIÓN
- **SIEMPRE** experimentar en `.verdex-ai/lab/experiments/` ANTES de tocar código productivo
- Crear prototipos en `.verdex-ai/lab/prototypes/`
- Ejecutar tests en `.verdex-ai/lab/testing/`

### ⚡ Fase 4: IMPLEMENTACIÓN
- Aplicar cambios al código productivo solo después de experimentación exitosa
- Referenciar ticket Jira en commits
- Mantener logging detallado

### ✅ Fase 5: VALIDACIÓN
- Ejecutar health checks
- Verificar integración con Atlassian
- Actualizar documentación si es necesario

### 📚 Fase 6: DOCUMENTACIÓN
- Actualizar `.verdex-ai/sessions/conversation-history.md`
- Crear/actualizar docs en `.verdex-ai/docs/`
- Cerrar ticket Jira con resumen

---

## 📝 REGLAS DE LOGGING Y CONVERSACIÓN

### 🎯 Archivo de Historial de Conversación
**Ubicación**: `.verdex-ai/sessions/conversation-history.md`

**OBLIGATORIO**: El agente DEBE actualizar este archivo:
- ✅ **Al inicio** de cada conversación (resumen de estado actual)
- ✅ **Durante** cada prompt del usuario (contexto y acciones)
- ✅ **Al final** de cada sesión (resumen de logros)

**Formato estándar:**
```markdown
# Verdex AI - Historial de Conversación

## 📅 Sesión: [FECHA]

### 🎯 Objetivo de la Sesión
[Descripción del objetivo principal]

### 🎫 Tickets Jira Relacionados
- [TICKET-ID]: [Descripción]

### ⚡ Acciones Realizadas
1. [Acción 1]
2. [Acción 2]

### 📊 Estado Actual
[Estado del proyecto después de la sesión]

### 🔄 Próximos Pasos
[Qué debe hacerse en la siguiente sesión]
```

### 📋 Log de Interacciones Detallado
**Ubicación**: `.verdex-ai/sessions/agent-interactions.log`

**Formato**: `[TIMESTAMP] [LEVEL] [ACTION] - [DETAILS]`

Ejemplos:
```
2025-01-07 14:30:15 INFO SESSION_START - Usuario solicita implementación de nueva feature
2025-01-07 14:31:22 INFO TICKET_CREATED - Jira ticket PROJ-123 creado exitosamente
2025-01-07 14:35:45 INFO EXPERIMENT_START - Iniciando pruebas en lab/experiments/
2025-01-07 14:42:10 SUCCESS IMPLEMENTATION - Feature implementada correctamente
2025-01-07 14:45:00 INFO SESSION_END - Sesión completada, documentación actualizada
```

---

## 🎫 PLANTILLAS DE TICKETS JIRA

### 🐛 Bug Report
```yaml
# .verdex-ai/templates/jira-tickets/bug-template.yaml
summary: "[BUG] {{descripcion_corta}}"
description: |
  ## 🐛 Descripción del Bug
  {{descripcion_detallada}}
  
  ## 🔄 Pasos para Reproducir
  1. {{paso_1}}
  2. {{paso_2}}
  
  ## 🎯 Comportamiento Esperado
  {{comportamiento_esperado}}
  
  ## 📊 Información Adicional
  - Verdex Framework IA: Detectado por agente IA
  - Fecha: {{fecha}}
  - Agente: {{agent_id}}

labels: ["bug", "ai-detected", "verdex-framework"]
priority: "Medium"
```

### ✨ Feature Request
```yaml
# .verdex-ai/templates/jira-tickets/feature-template.yaml
summary: "[FEATURE] {{titulo_feature}}"
description: |
  ## ✨ Descripción de la Feature
  {{descripcion}}
  
  ## 🎯 Objetivo de Negocio
  {{objetivo}}
  
  ## 📋 Criterios de Aceptación
  - [ ] {{criterio_1}}
  - [ ] {{criterio_2}}
  
  ## 🛠️ Notas Técnicas
  {{notas_tecnicas}}
  
  ## 📊 Información del Framework
  - Verdex Framework IA: Solicitud procesada por agente IA
  - Fecha: {{fecha}}
  - Estimación: {{estimacion}}

labels: ["enhancement", "ai-processed", "verdex-framework"]
priority: "Medium"
```

---

## 🔧 CONFIGURACIÓN Y SCRIPTS

### 📄 Archivo de Configuración Principal
**Ubicación**: `.verdex-ai/config/framework-settings.yaml`

```yaml
# Verdex Framework IA - Configuración
framework:
  name: "Verdex Framework IA"
  version: "2.0.0"
  
logging:
  conversation_history: true
  detailed_interactions: true
  session_tracking: true
  
atlassian:
  required: true
  jira_integration: true
  confluence_integration: true
  
agent_behavior:
  require_tickets: true
  force_experimentation: true
  auto_documentation: true
```

### 🔗 Scripts Disponibles

#### Configuración Inicial
```bash
.verdex-ai/scripts/setup-framework.sh          # Configuración inicial completa
.verdex-ai/scripts/configure-atlassian.sh      # Configurar integración Atlassian
```

#### Verificación y Monitoreo
```bash
.verdex-ai/scripts/verify-connections.sh       # Verificar conexiones MCP
.verdex-ai/scripts/health-check.sh            # Health check del sistema
```

#### Utilidades
```bash
.verdex-ai/scripts/session-summary.sh          # Generar resumen de sesión
.verdex-ai/scripts/cleanup-lab.sh             # Limpiar experimentos temporales
```

---

## 🚫 REGLAS ESTRICTAS - NO NEGOCIABLES

### ✅ SIEMPRE HACER:
1. **Crear ticket Jira** antes de cualquier trabajo
2. **Experimentar en `.verdex-ai/lab/`** antes de tocar código productivo
3. **Actualizar conversation-history.md** en cada prompt del usuario
4. **Mantener logging detallado** en agent-interactions.log
5. **Usar MCP Atlassian** para todas las integraciones
6. **Seguir el flujo de 6 fases** (Análisis → Planificación → Experimentación → Implementación → Validación → Documentación)

### 🚫 NUNCA HACER:
1. **Trabajar sin ticket Jira válido**
2. **Modificar código productivo sin experimentar primero**
3. **Omitir la actualización del historial de conversación**
4. **Saltarse la fase de experimentación**
5. **Generar archivos fuera de la estructura del framework**
6. **Proceder sin verificar conexiones MCP**

---

## 🎯 PREGUNTAS OBLIGATORIAS AL USUARIO

### 🚀 Al INICIAR conversación:
1. "¿En qué proyecto específico vamos a trabajar hoy?"
2. "¿Qué tipo de trabajo necesitas? (Bug/Feature/Documentación/Refactor)"
3. "¿Tienes algún ticket Jira existente o creo uno nuevo?"

### 🔄 DURANTE la conversación:
1. "¿Este cambio requiere experimentación adicional?"
2. "¿Necesitas documentación en Confluence para esto?"
3. "¿Hay dependencias o riesgos que deba considerar?"

### ✅ Al FINALIZAR conversación:
1. "¿El resultado cumple con tus expectativas?"
2. "¿Necesitas que documente algo adicional?"
3. "¿Hay tareas pendientes para la próxima sesión?"

---

## 📊 MÉTRICAS Y SEGUIMIENTO

El framework automáticamente rastrea:
- ✅ Número de tickets creados/cerrados
- ✅ Tiempo de experimentación vs implementación  
- ✅ Calidad de documentación generada
- ✅ Uso de integraciones Atlassian
- ✅ Adherencia al flujo de trabajo

---

## 🆘 TROUBLESHOOTING

### ❓ Problemas Comunes:
- **MCP no responde**: Ejecutar `.verdex-ai/scripts/verify-connections.sh`
- **No se puede crear ticket**: Verificar credenciales Atlassian
- **Framework no encuentra archivos**: Verificar estructura `.verdex-ai/`

### 📞 Escalación:
Si el agente no puede resolver un problema en 3 intentos, debe:
1. Documentar el issue en agent-interactions.log
2. Crear ticket Jira con label "escalation"
3. Solicitar intervención humana

---

*📅 Verdex Framework IA v2.0 - Diseñado para excelencia en desarrollo asistido por IA* 