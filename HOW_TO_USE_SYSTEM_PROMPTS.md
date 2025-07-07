# 🎯 GUÍA RÁPIDA: SYSTEM PROMPTS UNIVERSALES

## �� **¿QUÉ TIENES DISPONIBLE?**

### 🔥 **SYSTEM_PROMPT.md** - COMPLETO (11KB, 361 líneas)
✅ **Para proyectos empresariales críticos**
✅ **Incluye**: Protocolos completos, plantillas, troubleshooting
✅ **Usar en**: Claude.ai, APIs personalizadas

### ⚡ **SYSTEM_PROMPT_COMPACT.md** - COMPACTO (2KB, 70 líneas)  
✅ **Para desarrollo ágil y rápido**
✅ **Incluye**: Reglas esenciales, flujo básico
✅ **Usar en**: Cursor User Rules, ChatGPT, ROVO CLI

### 🎪 **CURSOR_COPY_PASTE.md** - LISTO PARA CURSOR
✅ **Optimizado específicamente para Cursor**
✅ **Copy-paste directo en User Rules**

---

## 🚀 **INSTRUCCIONES RÁPIDAS**

### 🎪 **CURSOR (Más Común)**
```bash
1. Cursor: Ctrl+, → Settings
2. Ir a "Rules" → "User Rules" 
3. Copy-paste contenido de: CURSOR_COPY_PASTE.md
```

### 🤖 **CLAUDE**
```bash
1. Al crear nueva conversación
2. En "System" pegar contenido de: SYSTEM_PROMPT.md
```

### 🔧 **ROVO CLI**
```bash
rovo chat --system "$(cat SYSTEM_PROMPT_COMPACT.md)"
```

### 💻 **CHATGPT**
```bash
Custom Instructions → pegar: SYSTEM_PROMPT_COMPACT.md
```

---

## ✅ **VERIFICAR QUE FUNCIONA**

El agente DEBE hacer esto al iniciar:
1. `ls -la .verdex-ai/`
2. `cat .verdex-ai/sessions/conversation-history.md`
3. Crear ticket Jira obligatorio
4. Preguntar tipo de trabajo (Bug/Feature/Docs)

---

## 🆘 **SI NO FUNCIONA**

1. **Agente no sigue protocolo**: Recordar "Sigue protocolo Verdex Framework IA v3.0"
2. **Muy largo para plataforma**: Usar SYSTEM_PROMPT_COMPACT.md  
3. **Agente olvida**: Reiniciar conversación con system prompt

---

**�� RESULTADO**: Cualquier agente IA seguirá automáticamente los protocolos del Verdex Framework IA v3.0**
