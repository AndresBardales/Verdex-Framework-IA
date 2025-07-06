# 🚀 Verdex Framework IA v3.0

> **Framework de Desarrollo IA Empresarial Cross-Platform con Integración Atlassian Obligatoria**

[![Status](https://img.shields.io/badge/status-stable-green)](https://github.com/AndresBardales/Verdex-Framework-IA)
[![Version](https://img.shields.io/badge/version-3.0.0-blue)](https://github.com/AndresBardales/Verdex-Framework-IA/releases)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey)](https://github.com/AndresBardales/Verdex-Framework-IA)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

Un framework revolucionario para colaboración inteligente entre humanos y agentes IA, con integración obligatoria a Atlassian y controles de calidad empresariales.

---

## ⚡ Instalación Ultra-Rápida

### 🎯 Un Solo Comando (Recomendado)

```bash
curl -fsSL https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh | bash
```

> **📋 Lo que hace**: Descarga e instala automáticamente el framework en tu proyecto actual

### 🔄 Instalación Manual (Si curl falla)

```bash
# Opción 1: wget
wget https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh
chmod +x verdex-ai-setup.sh
./verdex-ai-setup.sh

# Opción 2: git clone
git clone https://github.com/AndresBardales/Verdex-Framework-IA.git
cd Verdex-Framework-IA
./verdex-ai-setup.sh
cd .. && rm -rf Verdex-Framework-IA
```

### ✅ Verificación Post-Instalación

```bash
# Verificar que todo funciona
.verdex-ai/scripts/health-check.sh

# Deberías ver: "✅ Framework funcionando perfectamente"
```

### 🚀 Primeros Pasos Después de Instalar

```bash
# 1. Ver qué se instaló
ls -la .verdex-ai/

# 2. Leer el protocolo para agentes IA
cat VERDEX_AI_AGENT_GUIDE.md

# 3. Verificar configuración detectada
cat .verdex-ai/config/framework-settings.yaml

# 4. Revisar integraciones MCP disponibles
.verdex-ai/scripts/verify-connections.sh
```

> **🎯 ¡Ya estás listo!** El framework está configurado y funcionando. Los agentes IA ahora seguirán protocolos profesionales en tu proyecto.

---

## 🌟 ¿Qué es el Verdex Framework IA?

### 🎯 **Características Principales**

- 🤖 **Control total de agentes IA**: Protocolos obligatorios empresariales
- 🎫 **Integración Jira obligatoria**: Ningún trabajo sin ticket válido
- 📱 **Cross-platform**: Windows, Linux, macOS
- 🏗️ **Estructura profesional**: Todo contenido en `.verdex-ai/` (oculto como `.git`)
- 📊 **Auto-configuración**: Detecta tipo de proyecto automáticamente
- 🔧 **Scripts inteligentes**: Health checks, verificación MCP, plantillas

### 🎪 **Para Quién es Este Framework**

- 👩‍💻 **Desarrolladores** que trabajan con agentes IA (Claude, Cursor, etc.)
- 🏢 **Equipos empresariales** que necesitan control y trazabilidad
- 📊 **Proyectos con Atlassian** (Jira, Confluence)
- 🚀 **Organizaciones** que buscan estándares en IA

---

## 🔧 Funcionalidades v3.0

### 📁 **Estructura Profesional**

```
tu-proyecto/
├── .verdex-ai/              # 🔧 Framework (oculto como .git)
│   ├── config/             # ⚙️ framework-settings.yaml
│   ├── scripts/            # 🛠️ health-check.sh, verify-connections.sh
│   ├── sessions/           # 📝 conversation-history.md
│   ├── templates/          # 📋 jira-tickets/*.yaml
│   ├── lab/                # 🧪 Experimentación segura
│   └── docs/               # 📚 Documentación
├── VERDEX_AI_AGENT_GUIDE.md # 🤖 Protocolo obligatorio para agentes
└── [archivos de tu proyecto] # 📁 Tu código intacto
```

### 🚀 **Scripts Inteligentes**

| Script | Función | Comando |
|--------|---------|---------|
| **health-check.sh** | Verificación completa del framework | `.verdex-ai/scripts/health-check.sh` |
| **verify-connections.sh** | Validación de integraciones MCP | `.verdex-ai/scripts/verify-connections.sh` |

### 📋 **Plantillas Profesionales**

- **🐛 bug-report.yaml**: Template estructurado para reportes de bugs
- **✨ feature-request.yaml**: Template para solicitudes de funcionalidades
- **📊 session-reports**: Plantillas para documentación de sesiones

### ⚙️ **Auto-Configuración**

El framework detecta automáticamente:
- 💻 **Sistema operativo**: Windows, Linux, macOS
- 📦 **Tipo de proyecto**: Node.js, Python, PHP, Java, Flutter, Docker, etc.
- 🔗 **Integraciones MCP**: Atlassian, Google Calendar, etc.
- 📁 **Estructura existente**: Se adapta sin interferir

---

## 🎯 Flujo de Trabajo para Agentes IA

### 📋 **Protocolo Obligatorio**

Antes de cualquier trabajo, los agentes IA **DEBEN**:

1. **📍 Verificar framework**: `ls -la .verdex-ai/`
2. **⚕️ Health check**: `.verdex-ai/scripts/health-check.sh`
3. **📖 Leer historial**: `cat .verdex-ai/sessions/conversation-history.md`
4. **🔗 Verificar MCP**: `.verdex-ai/scripts/verify-connections.sh`
5. **🎫 Crear ticket Jira**: OBLIGATORIO antes de proceder
6. **📝 Actualizar log**: Registrar inicio de sesión

### 🔄 **Flujo Estándar**

1. **🚀 ANÁLISIS** - Health check y verificar estado
2. **📋 PLANIFICACIÓN** - Crear ticket usando plantillas YAML
3. **🧪 EXPERIMENTACIÓN** - Probar en `.verdex-ai/lab/` ANTES de implementar
4. **⚡ IMPLEMENTACIÓN** - Aplicar cambios con referencia a ticket
5. **✅ VALIDACIÓN** - Health checks y verificar integraciones
6. **📚 DOCUMENTACIÓN** - Actualizar conversation-history.md

---

## 💡 Casos de Uso

### 🏢 **Para Empresas**

```bash
# Instalar en proyecto existente
cd mi-proyecto-empresarial
curl -fsSL https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh | bash

# El framework detecta automáticamente y configura
# ✅ Control total sobre agentes IA
# ✅ Integración obligatoria con Jira
# ✅ Documentación automática de sesiones
```

### 👩‍💻 **Para Desarrolladores**

```bash
# En cualquier proyecto
curl -fsSL https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh | bash

# Beneficios inmediatos:
# ✅ Agentes IA siguen protocolos estrictos
# ✅ Plantillas profesionales para tickets
# ✅ Health checks automáticos
# ✅ Experimentación segura en lab/
```

### 🤖 **Para Agentes IA**

El framework incluye `VERDEX_AI_AGENT_GUIDE.md` con **protocolos obligatorios**:

- 🚫 **Trabajar sin ticket Jira válido**: PROHIBIDO
- 📝 **Omitir documentación**: PROHIBIDO  
- 🧪 **Implementar sin experimentar**: PROHIBIDO
- ⚕️ **Saltarse health checks**: PROHIBIDO

---

## 🛠️ Comandos Útiles

### 🔍 **Verificación**

```bash
# Health check completo
.verdex-ai/scripts/health-check.sh

# Verificar conexiones MCP
.verdex-ai/scripts/verify-connections.sh

# Ver configuración
cat .verdex-ai/config/framework-settings.yaml
```

### 📊 **Documentación**

```bash
# Ver historial de conversaciones
cat .verdex-ai/sessions/conversation-history.md

# Listar plantillas disponibles
ls .verdex-ai/templates/jira-tickets/

# Ver logs de instalación
cat .verdex-ai/sessions/installation.log
```

### 🧪 **Experimentación**

```bash
# Área segura para pruebas
cd .verdex-ai/lab/experiments

# Prototipos rápidos
cd .verdex-ai/lab/prototypes

# Testing aislado
cd .verdex-ai/lab/testing
```

---

## 🎯 Compatibilidad

### 💻 **Sistemas Operativos**

- ✅ **Linux** (Ubuntu, CentOS, RHEL, etc.)
- ✅ **macOS** (Intel & Apple Silicon)
- ✅ **Windows** (Git Bash, WSL)

### 📦 **Tipos de Proyecto**

- ✅ **Node.js** (`package.json`)
- ✅ **Python** (`requirements.txt`, `pyproject.toml`)
- ✅ **PHP** (`composer.json`)
- ✅ **Java** (`pom.xml`, `build.gradle`)
- ✅ **Flutter** (`pubspec.yaml`)
- ✅ **Docker** (`docker-compose.yml`)
- ✅ **Genérico** (cualquier proyecto con README)

### 🔗 **Integraciones MCP**

- ✅ **Atlassian** (Jira, Confluence)
- ✅ **Google Calendar**
- ✅ **Extensible** a cualquier MCP

---

## 📋 Solución de Problemas

### ❌ **Error: `curl: (22) The requested URL returned error: 404`**

**Causa**: Cache de GitHub o URL incorrecta.

```bash
# 1. Verificar URL manualmente
curl -I https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh

# 2. Si hay cache, usar instalación manual
git clone https://github.com/AndresBardales/Verdex-Framework-IA.git
cd Verdex-Framework-IA
./verdex-ai-setup.sh
cd .. && rm -rf Verdex-Framework-IA
```

### ❌ **Error: `bash: line 732: BASH_SOURCE[0]: unbound variable`**

**Causa**: Cache de GitHub con versión antigua del script.

**Soluciones**:
```bash
# Opción 1: Esperar 10-15 minutos y reintentar
curl -fsSL https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh | bash

# Opción 2: Instalación manual inmediata
wget https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh
chmod +x verdex-ai-setup.sh
./verdex-ai-setup.sh
```

### ❌ **Error: Permission denied**

```bash
# Verificar permisos del directorio
ls -la
chmod +w .

# Si sigues teniendo problemas
sudo ./verdex-ai-setup.sh  # Solo como último recurso
```

### ❌ **Health Check Falla**

```bash
# 1. Reinstalar framework limpio
rm -rf .verdex-ai VERDEX_AI_AGENT_GUIDE.md
./verdex-ai-setup.sh

# 2. Verificar integraciones MCP
.verdex-ai/scripts/verify-connections.sh

# 3. Si persiste, verificar estructura manualmente
tree .verdex-ai -L 2
```

### ❌ **Framework no detecta MCP**

```bash
# Verificar que Cursor esté configurado
cat ~/.cursor/mcp.json

# Si no existe, configurar MCP en Cursor primero
# Luego reinstalar framework:
./verdex-ai-setup.sh
```

---

## 🤝 Contribuciones

### 🐛 **Reportar Bugs**

Usa la plantilla incluida:
```bash
cat .verdex-ai/templates/jira-tickets/bug-report.yaml
```

### ✨ **Solicitar Features**

Usa la plantilla incluida:
```bash
cat .verdex-ai/templates/jira-tickets/feature-request.yaml
```

### 📝 **Contribuir Código**

1. Fork del repositorio
2. Crear branch: `git checkout -b feature/nueva-funcionalidad`
3. Instalar framework: `./verdex-ai-setup.sh`
4. Seguir protocolos en `VERDEX_AI_AGENT_GUIDE.md`
5. Commit con referencia a ticket
6. Pull Request

---

## 📄 Licencia

MIT License - ver [LICENSE](LICENSE) para detalles.

---

## 🏆 Créditos

**Verdex Framework IA v3.0** - Desarrollado para excelencia en colaboración IA empresarial.

- 🤖 **Para agentes IA**: Protocolos obligatorios y control de calidad
- 🏢 **Para empresas**: Trazabilidad y integración Atlassian
- 👩‍💻 **Para desarrolladores**: Productividad y estructura profesional

---

### 🚀 **¿Listo para transformar tu desarrollo con IA?**

```bash
curl -fsSL https://raw.githubusercontent.com/AndresBardales/Verdex-Framework-IA/main/verdex-ai-setup.sh | bash
```

**⚡ 30 segundos. Tu proyecto. Control total sobre IA. Calidad empresarial.**

---

*📅 Verdex Framework IA v3.0 - Cross-Platform Excellence in AI-Assisted Development*  
*🎯 Mandatory protocols for enterprise-grade AI collaboration*  
*🏢 Professional structure · 🤖 AI-first approach · 📊 Atlassian integrated* 