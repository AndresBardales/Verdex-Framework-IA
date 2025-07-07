# 📚 VERDEX FRAMEWORK IA - DOCUMENTACIÓN COMPLETA

## 🎯 **SYSTEM PROMPTS UNIVERSALES**

### 🤖 **Para Agentes IA:**
- **`SYSTEM_PROMPT.md`** - System prompt COMPLETO (11KB, 361 líneas)
  - Para: Proyectos empresariales críticos, compliance estricto
  - Uso: Claude.ai, APIs personalizadas, integraciones complejas

- **`SYSTEM_PROMPT_COMPACT.md`** - System prompt COMPACTO (2KB, 71 líneas)  
  - Para: Desarrollo ágil, prototipado, sesiones rápidas
  - Uso: Cursor User Rules, ChatGPT, ROVO CLI

- **`CURSOR_COPY_PASTE.md`** - Optimizado para Cursor (73 líneas)
  - Para: Copy-paste directo en Cursor User Rules
  - Específicamente optimizado para Cursor

- **`HOW_TO_USE_SYSTEM_PROMPTS.md`** - Guía de implementación (66 líneas)
  - Instrucciones paso a paso por plataforma
  - Troubleshooting y verificación

## 📋 **GUÍAS DE DESARROLLO**

### 🚀 **Inicio Rápido:**
- **`QUICK_START.md`** - Configuración inicial del framework
  - Primeros pasos después de la instalación
  - Configuración básica de herramientas

### 🌿 **Git & Colaboración:**
- **`git-branch-strategy.md`** - Estrategia de branching para equipos
  - Flujo de trabajo con Git
  - Mejores prácticas de colaboración

## 🎯 **PROTOCOLOS OBLIGATORIOS**

### 📋 **Flujo de 6 Fases OBLIGATORIO:**
1. **ANÁLISIS**: Health check + analizar solicitud
2. **PLANIFICACIÓN**: Crear ticket Jira + documentar plan  
3. **EXPERIMENTACIÓN**: SIEMPRE probar en `.verdex-ai/lab/` ANTES
4. **IMPLEMENTACIÓN**: Aplicar cambios solo después de experimentación
5. **VALIDACIÓN**: Health checks + verificar integraciones
6. **DOCUMENTACIÓN**: Actualizar conversation-history.md + cerrar ticket

### 🎫 **Reglas Absolutas:**
- **SIEMPRE**: Crear ticket Jira antes de cualquier trabajo
- **SIEMPRE**: Experimentar en lab/ antes de tocar código productivo
- **SIEMPRE**: Actualizar conversation-history.md en cada respuesta
- **NUNCA**: Trabajar sin ticket Jira válido
- **NUNCA**: Modificar código productivo sin experimentación

## 🔧 **IMPLEMENTACIÓN POR PLATAFORMA**

### 🎪 **Cursor (Más efectivo):**
```bash
# Opción 1: User Rules
# Settings → Rules → User Rules → pegar CURSOR_COPY_PASTE.md

# Opción 2: Archivo .cursorrules  
cp .verdex-ai/docs/CURSOR_COPY_PASTE.md .cursorrules
```

### 🤖 **Claude.ai:**
```bash
# System prompt completo en nueva conversación
cat .verdex-ai/docs/SYSTEM_PROMPT.md
# → Copy-paste en System prompt al crear conversación
```

### 🔧 **ROVO CLI:**
```bash
# Configuración permanente
rovo config set system-prompt "$(cat .verdex-ai/docs/SYSTEM_PROMPT.md)"

# Por sesión específica
rovo chat --system "$(cat .verdex-ai/docs/SYSTEM_PROMPT_COMPACT.md)"
```

### 💬 **ChatGPT:**
```bash
# Custom Instructions
cat .verdex-ai/docs/SYSTEM_PROMPT_COMPACT.md
# → Copy-paste en Settings → Custom Instructions
```

---

**🏢 Verdex Framework IA v3.0 - Enterprise AI Development Excellence**  
**🎯 Mandatory protocols for professional AI collaboration**

## 📋 Índice de Documentos

### 📄 Documentos Principales
- **`QUICK_START.md`** - Guía rápida de instalación y configuración
- **`git-branch-strategy.md`** - Estrategia de branches y metodología de desarrollo

### 🏗️ Arquitectura Framework
- Estructura modular contenida en directorio `.verdex-ai/`
- Integración obligatoria con Atlassian via MCP
- Automatización inteligente con scripts especializados
- Control de calidad obligatorio mediante Git hooks

### 🎯 Estado del Framework
- **Versión**: v3.0 Inteligente
- **Estado**: Estable y listo para producción
- **Última actualización**: Enero 2025

### 📖 Enlaces Útiles
- **Protocolo obligatorio**: `../../VERDEX_AI_AGENT_GUIDE.md`
- **Configuración**: `../config/framework-settings.yaml`  
- **Laboratorio de pruebas**: `../lab/`
- **Scripts de automatización**: `../scripts/`

### 🔧 Características del Framework
- **Control obligatorio**: Git hooks impiden commits sin tickets
- **Documentación automática**: Se genera sin intervención manual
- **Métricas inteligentes**: Auto-alimentación basada en actividad
- **Integración empresarial**: Compatible con flujos Atlassian

## 📞 Soporte
Para consultas sobre el framework, crear ticket usando templates incluidos en `../templates/jira-tickets/`. 