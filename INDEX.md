# 📁 VERDEX FRAMEWORK IA v3.0 - ÍNDICE DE CONTENIDO

## 🎯 **ARCHIVOS PRINCIPALES**

### 🚀 **INSTALACIÓN**
- **`verdex-ai-setup.sh`** - Instalador universal cross-platform (Linux, macOS, Windows)
- **`README.md`** - Documentación completa del framework + instrucciones

### 🤖 **SYSTEM PROMPTS UNIVERSALES**
- **`SYSTEM_PROMPT.md`** - System prompt COMPLETO (11KB, 361 líneas) para proyectos empresariales
- **`SYSTEM_PROMPT_COMPACT.md`** - System prompt COMPACTO (2KB, 71 líneas) para uso ágil
- **`CURSOR_COPY_PASTE.md`** - Optimizado para Cursor User Rules (copy-paste directo)
- **`HOW_TO_USE_SYSTEM_PROMPTS.md`** - Guía de implementación por plataforma

### 📋 **PROTOCOLOS PARA AGENTES**
- **`VERDEX_AI_AGENT_GUIDE.md`** - Protocolo completo obligatorio para agentes IA

---

## 🎯 **CÓMO USAR ESTE FRAMEWORK**

### 🔧 **Para Instalar en un Proyecto:**
```bash
curl -fsSL https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh | bash
```

### 🤖 **Para Configurar Agentes IA:**
1. **Cursor**: Copy-paste `CURSOR_COPY_PASTE.md` en User Rules
2. **Claude**: Copy-paste `SYSTEM_PROMPT.md` en System prompt
3. **ROVO CLI**: `rovo chat --system "$(cat SYSTEM_PROMPT_COMPACT.md)"`
4. **ChatGPT**: Copy-paste `SYSTEM_PROMPT_COMPACT.md` en Custom Instructions

### 📚 **Para Entender el Framework:**
1. Leer `README.md` - Documentación completa
2. Revisar `VERDEX_AI_AGENT_GUIDE.md` - Protocolos para agentes
3. Consultar `HOW_TO_USE_SYSTEM_PROMPTS.md` - Guía por plataforma

---

## 🏗️ **ESTRUCTURA QUE SE INSTALA**

Cuando ejecutas `verdex-ai-setup.sh`, se crea:

```
tu-proyecto/
├── .verdex-ai/                    # Framework (oculto como .git)
│   ├── config/                   # Configuración del proyecto
│   ├── scripts/                  # Health checks, verificaciones
│   ├── sessions/                 # Historial de conversaciones
│   ├── templates/                # Plantillas Jira/Confluence
│   ├── lab/                      # Área de experimentación segura
│   └── docs/                     # Documentación técnica
└── VERDEX_AI_AGENT_GUIDE.md     # Protocolo visible para agentes
```

---

## 🎯 **BENEFICIOS INMEDIATOS**

- ✅ **Control total sobre agentes IA** - Protocolos empresariales obligatorios
- ✅ **Integración Jira forzosa** - 100% trazabilidad de trabajo
- ✅ **Experimentación obligatoria** - Test en lab/ antes de producción
- ✅ **Documentación automática** - conversation-history.md siempre actualizado
- ✅ **Cross-platform** - Funciona en Linux, macOS, Windows
- ✅ **Universal** - Compatible con Cursor, Claude, ROVO, ChatGPT, APIs

---

## 📊 **FLUJO DE TRABAJO**

1. **🚀 Instalación**: Un comando instala todo
2. **🤖 Configuración**: Copy-paste system prompt en tu agente IA
3. **🎫 Trabajo controlado**: Agente crea ticket Jira automáticamente
4. **🧪 Experimentación**: Pruebas seguras en .verdex-ai/lab/
5. **⚡ Implementación**: Cambios a producción solo después de experimentos
6. **📝 Documentación**: Todo queda registrado automáticamente

---

**🏢 Verdex Framework IA v3.0 - Enterprise AI Development Excellence**  
**🎯 Mandatory protocols for professional AI collaboration** 