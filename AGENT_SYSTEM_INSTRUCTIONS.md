# 🤖 INSTRUCCIONES DEL SISTEMA PARA AGENTES IA

## 🎯 PROTOCOLO OBLIGATORIO DE INICIALIZACIÓN

### ⚠️ **ANTES DE CUALQUIER TRABAJO - EJECUTAR SIEMPRE:**

1. **📋 CREAR TICKET DE TRABAJO**
   ```bash
   # OBLIGATORIO: Crear ticket en Jira antes de iniciar
   # Usar estas plantillas según el tipo de trabajo:
   
   # 🐛 Para bugs/fixes:
   "🐛 [BUG] Descripción del problema - Framework Dev"
   
   # ✨ Para features:
   "✨ [FEATURE] Nueva funcionalidad - Framework Dev"
   
   # 📚 Para documentación:
   "📚 [DOCS] Actualización documentación - Framework Dev"
   
   # 🔧 Para refactoring:
   "🔧 [REFACTOR] Mejora código - Framework Dev"
   ```

2. **🔗 VERIFICAR CONEXIONES MCP**
   ```bash
   # Verificar que MCP Atlassian esté conectado
   # Debe estar en ~/.cursor/mcp.json o configuración equivalente
   
   # Conexiones obligatorias:
   ✅ MCP Atlassian (Jira, Confluence, Rovo CLI)
   ✅ MCP Calendario (si aplica)
   ✅ Acceso a herramientas de proyecto
   ```

3. **📖 LEER CONTEXTO DEL PROYECTO**
   ```bash
   # Leer EN ESTE ORDEN:
   1. last_talk.md (contexto de última conversación)
   2. 01Doc/AI_DEV_FRAMEWORK.md (framework completo)
   3. README.md (estado actual del proyecto)
   4. Health check: scripts/health_check.sh
   ```

---

## 🔧 INTEGRACIÓN MCP ATLASSIAN OBLIGATORIA

### ⚡ **CONFIGURACIÓN REQUERIDA**

**El framework REQUIERE integración con Atlassian para seguir las mejores prácticas de desarrollo empresarial.**

#### 🎫 **Flujo de Tickets Obligatorio**

1. **AL INICIAR NUEVA CONVERSACIÓN:**
   ```markdown
   PREGUNTA OBLIGATORIA AL USUARIO:
   "🎫 ¿Tienes un ticket de Jira para este trabajo? 
   Si no, necesito crear uno antes de comenzar.
   
   Opciones:
   A) Ya tengo ticket: [Proporcionar ID]
   B) Crear ticket nuevo: [Describir trabajo]
   C) Trabajo exploratorio: [Usar ticket temporal]"
   ```

2. **CREAR TICKET SI NO EXISTE:**
   ```python
   # Usar MCP Atlassian para crear ticket
   # Plantilla obligatoria:
   {
     "summary": "🤖 [AI-DEV] Trabajo con agente IA - [Descripción]",
     "description": "Trabajo iniciado por agente IA\n\nContexto: [Descripción]\nObjetivo: [Meta]\nUsuario: [Nombre]",
     "labels": ["ai-development", "framework", "automated"],
     "priority": "Medium"
   }
   ```

#### 📋 **Integración con Confluence**

```markdown
**DOCUMENTACIÓN AUTOMÁTICA:**
- Crear página de Confluence para trabajos importantes
- Actualizar documentación existente
- Linkear tickets con documentación
- Mantener bitácora de cambios
```

#### 🔄 **Integración con Rovo CLI**

```bash
# Usar Rovo CLI para consultas contextuales
# Ejemplo: ¿Qué arquitectura usa este proyecto?
rovo ask "¿Cuál es la arquitectura del proyecto [NOMBRE]?"

# Generar documentación automática
rovo generate docs --project-path .
```

---

## 🏗️ ARQUITECTURA DEL FRAMEWORK

### 📁 **Estructura Obligatoria**

```
proyecto/
├── 01Doc/                      # 📚 Documentación centralizada
│   ├── AI_DEV_FRAMEWORK.md    # Framework completo
│   ├── agents_logs/           # Logs de sesiones IA
│   └── versions/              # Control de versiones
├── agent/                     # 🧪 Workspace de agentes IA
│   ├── lab/                   # Experimentos seguros
│   ├── scripts/               # Scripts de automatización
│   └── tools/                 # Herramientas inteligentes
├── config/                    # ⚙️ Configuración centralizada
├── scripts/                   # 🛠️ Scripts de sistema
└── AGENT_SYSTEM_INSTRUCTIONS.md # 🤖 Este archivo
```

### 🔄 **Flujo de Trabajo Estándar**

1. **ANÁLISIS** → Leer contexto y crear ticket
2. **PLANIFICACIÓN** → Definir scope y tareas
3. **EXPERIMENTACIÓN** → Usar `agent/lab/` para pruebas
4. **IMPLEMENTACIÓN** → Aplicar cambios al código
5. **VALIDACIÓN** → Ejecutar tests y health checks
6. **DOCUMENTACIÓN** → Actualizar docs y cerrar ticket

---

## 🚀 COMANDOS DE INICIALIZACIÓN

### 🆕 **Para Proyectos Nuevos**

```bash
# Instalar framework completo
curl -sSL https://raw.githubusercontent.com/tu-org/ai-dev-framework/main/scripts/framework_install.sh | bash

# Configurar integración Atlassian
./scripts/configure_atlassian.sh

# Verificar salud del proyecto
./scripts/health_check.sh
```

### 🔄 **Para Proyectos Existentes**

```bash
# Analizar proyecto existente
python agent/scripts/project_analyzer.py

# Aplicar framework gradualmente
./scripts/apply_framework_migration.sh

# Configurar MCP y herramientas
./scripts/setup_mcp_integration.sh
```

### 🔍 **Verificación de Salud**

```bash
# Health check completo
./scripts/health_check.sh

# Verificar conexiones MCP
./scripts/verify_mcp_connections.sh

# Analizar calidad del código
./scripts/code_quality_check.sh
```

---

## 📋 REGLAS OBLIGATORIAS PARA AGENTES

### ✅ **HACER SIEMPRE:**

1. **📋 Crear ticket antes de trabajar**
2. **📖 Leer contexto completo del proyecto**
3. **🧪 Experimentar en `agent/lab/` primero**
4. **📝 Documentar todos los cambios**
5. **🔄 Actualizar `last_talk.md` al finalizar**
6. **🔗 Linkear trabajo con tickets de Jira**
7. **🔍 Ejecutar health checks antes de finalizar**

### ❌ **NUNCA HACER:**

1. **🚫 Trabajar sin ticket asociado**
2. **🚫 Modificar código sin experimentar primero**
3. **🚫 Crear archivos en la raíz del proyecto**
4. **🚫 Ignorar los health checks**
5. **🚫 Trabajar sin leer el contexto**
6. **🚫 Finalizar sin actualizar documentación**

### 🎯 **PREGUNTAS OBLIGATORIAS AL USUARIO:**

```markdown
**AL INICIAR CONVERSACIÓN:**
1. "🎫 ¿Tienes un ticket de Jira para este trabajo?"
2. "🔧 ¿Qué objetivo específico quieres lograr?"
3. "📊 ¿Necesitas que analice el estado actual del proyecto?"

**DURANTE EL TRABAJO:**
1. "🔍 ¿Quieres que pruebe esto en agent/lab/ primero?"
2. "📋 ¿Debo actualizar la documentación relacionada?"
3. "🔄 ¿Necesitas que ejecute health checks?"

**AL FINALIZAR:**
1. "📝 ¿Quieres que actualice el ticket con los resultados?"
2. "🔗 ¿Debo crear documentación en Confluence?"
3. "🎯 ¿Hay tareas de seguimiento para próximas sesiones?"
```

---

## 🔧 HERRAMIENTAS DISPONIBLES

### 🤖 **MCP Atlassian**
- **Jira**: Crear, leer, actualizar tickets
- **Confluence**: Documentación automática
- **Rovo CLI**: Consultas contextuales inteligentes

### 🛠️ **Scripts del Framework**
- `health_check.sh` - Verificación completa del sistema
- `project_analyzer.py` - Análisis de calidad del proyecto
- `rovo_cli_wrapper.py` - Wrapper inteligente para Rovo CLI

### 📊 **Monitoreo y Logs**
- `mqtt-universal-monitor.py` - Monitor de eventos en tiempo real
- `logs/[fecha]/` - Logs centralizados por fecha
- `01Doc/agents_logs/` - Bitácora de sesiones IA

---

## 📈 MÉTRICAS Y CALIDAD

### 🎯 **Objetivos por Sesión**

- **📋 Ticket creado/actualizado**: ✅ Obligatorio
- **🧪 Experimentos en lab**: ✅ Antes de implementar
- **📝 Documentación actualizada**: ✅ Siempre
- **🔍 Health checks pasados**: ✅ Antes de finalizar
- **🔄 Contexto preservado**: ✅ En `last_talk.md`

### 📊 **Métricas de Calidad**

```python
# Scoring automático del proyecto
project_score = {
    "documentation": 0.25,    # Documentación completa
    "testing": 0.20,          # Tests y health checks
    "structure": 0.20,        # Estructura del framework
    "integration": 0.15,      # Integración MCP/Atlassian
    "automation": 0.20        # Scripts y automatización
}
```

---

## 🎯 COMANDOS RÁPIDOS

### 🚀 **Inicialización Rápida**

```bash
# Setup completo del framework
curl -sSL https://git.io/ai-dev-framework | bash

# Verificar configuración MCP
curl -sSL https://git.io/mcp-check | bash

# Salud del proyecto
./scripts/health_check.sh --full
```

### 🔗 **Integración Atlassian**

```bash
# Configurar Rovo CLI
rovo auth login

# Verificar conexión
rovo whoami

# Crear ticket de prueba
rovo jira create --summary "🤖 Test framework integration"
```

---

## 💡 PLANTILLAS PARA AGENTES

### 🎫 **Plantilla de Ticket**

```markdown
**Título**: 🤖 [AI-DEV] [TIPO] Descripción breve

**Descripción**:
- **Contexto**: Situación actual
- **Objetivo**: Qué se quiere lograr
- **Scope**: Qué incluye/excluye
- **Agente**: Claude/GPT/[Nombre]
- **Sesión**: [Fecha y hora]

**Criterios de Aceptación**:
- [ ] Funcionalidad implementada
- [ ] Tests pasando
- [ ] Documentación actualizada
- [ ] Health checks OK

**Labels**: ai-development, framework, [tipo-trabajo]
```

### 📝 **Plantilla de Documentación**

```markdown
# 📋 Sesión de Desarrollo IA

## 🎯 Objetivo
[Descripción del objetivo]

## 🔗 Ticket Asociado
[JIRA-123] - [Título del ticket]

## 📊 Cambios Realizados
- [x] Cambio 1
- [x] Cambio 2
- [ ] Pendiente

## 🔧 Comandos Ejecutados
```bash
# Comandos utilizados
```

## 📈 Resultados
- **Archivos modificados**: X
- **Health check**: ✅ Pasado
- **Documentación**: ✅ Actualizada

## 🎯 Próximos Pasos
1. [Tarea 1]
2. [Tarea 2]
```

---

## 🔄 PROCESO DE INSTALACIÓN Y VALIDACIÓN

### 🎯 **Cómo Instalar el Framework en Tu App**

```bash
# 1. Clonar o descargar el framework
git clone https://github.com/tu-org/ai-dev-framework.git
cd ai-dev-framework

# 2. Ejecutar instalación
./scripts/framework_install.sh

# 3. Configurar integración Atlassian
./scripts/configure_atlassian.sh

# 4. Verificar salud
./scripts/health_check.sh --full

# 5. Probar con agente
echo "🤖 Framework listo para uso con agentes IA"
```

### ✅ **Validación Post-Instalación**

```bash
# Verificar estructura
tree -I 'node_modules|.git|venv' -L 3

# Verificar conexiones MCP
./scripts/verify_mcp_connections.sh

# Crear ticket de prueba
rovo jira create --summary "🧪 Test framework installation"

# Ejecutar health check completo
./scripts/health_check.sh --verbose
```

---

## 🎯 MENSAJE FINAL

**🤖 Este framework transforma cómo trabajas con agentes IA:**

- ✅ **Estructura profesional** desde el primer día
- ✅ **Integración empresarial** con Atlassian
- ✅ **Documentación automática** siempre actualizada
- ✅ **Experimentos seguros** en entorno controlado
- ✅ **Calidad garantizada** con health checks

**🚀 Próximos pasos:**
1. Ejecutar `curl -sSL https://git.io/ai-dev-framework | bash`
2. Configurar MCP Atlassian
3. Crear primer ticket de trabajo
4. ¡Empezar a desarrollar con IA de forma profesional!

---

*📅 Actualizado: 2025-07-06*  
*🤖 Framework AI Development v1.0.0*  
*🔗 Integración MCP Atlassian Obligatoria* 