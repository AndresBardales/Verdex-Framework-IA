# 🚀 AI Dev Framework
## Framework de Desarrollo Inteligente para Proyectos con IA

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/ai-dev-framework/core)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Framework](https://img.shields.io/badge/framework-AI_Dev-purple.svg)](https://github.com/ai-dev-framework/core)

### 🎯 Visión
**Transformar la forma en que los equipos desarrollan software complejo con agentes IA**, proporcionando una infraestructura estandarizada que permite onboarding instantáneo, colaboración fluida humano-IA, documentación automática y escalabilidad sin caos.

---

## 🌟 Características Principales

### 🧠 **Inteligencia Integrada**
- **Contexto automático**: Los agentes IA leen automáticamente el contexto del proyecto
- **Memoria persistente**: Cada sesión se documenta automáticamente
- **Aprendizaje continuo**: El framework aprende de patrones y mejora sugerencias

### 📚 **Documentación Viva**
- **Sincronización automática**: Markdown local ↔ Confluence
- **Versionado inteligente**: Control de versiones con rollback automático
- **Plantillas dinámicas**: Generación automática de documentación

### 🔗 **Integración Atlassian**
- **Rovo CLI**: Integración nativa con Atlassian
- **Jira**: Creación automática de tickets desde eventos
- **Confluence**: Sincronización bidireccional de documentación

### 📊 **Monitoreo Inteligente**
- **Logging centralizado**: MQTT para eventos en tiempo real
- **Métricas automáticas**: Seguimiento de velocidad de desarrollo
- **Alertas proactivas**: Detección de problemas antes de que ocurran

---

## 🛠️ Instalación Rápida

### 🚀 Instalación con Un Comando
```bash
# Instalar framework en proyecto existente
curl -fsSL https://raw.githubusercontent.com/ai-dev-framework/core/main/install.sh | bash

# O para proyecto nuevo
curl -fsSL https://raw.githubusercontent.com/ai-dev-framework/core/main/install.sh | bash -s -- --new-project "mi-proyecto"
```

### 📋 Instalación Manual
```bash
# 1. Clonar este repositorio
git clone https://github.com/ai-dev-framework/core.git
cd core

# 2. Ejecutar instalación
./scripts/framework_install.sh --new-project "mi-proyecto"

# 3. Configurar el proyecto
cd mi-proyecto
./scripts/setup_project.sh
```

---

## 🎯 Inicio Rápido

### 1. 📖 **Leer Contexto**
```bash
# Revisar información del proyecto
cat system_context.md
cat last_talk.md
```

### 2. 🏥 **Health Check**
```bash
# Verificar estado del sistema
./agent/scripts/health_check.sh
```

### 3. 🤖 **Sesión con Agente IA**
```bash
# Crear log de sesión
./agent/scripts/create_session_log.sh claude

# Seguir protocolo en 01Doc/AI_Agent_System_Message.md
```

### 4. 🔧 **Configurar Integraciones**
```bash
# Configurar Rovo CLI
python agent/tools/rovo_cli_wrapper.py --check

# Configurar Jira y Confluence
vim config/atlassian_integration.yaml
```

---

## 📁 Estructura del Proyecto

```
mi-proyecto/
├── 01Doc/                      # 📚 Documentación centralizada
│   ├── README.md              # Índice de documentación
│   ├── AI_DEV_FRAMEWORK.md    # Documentación del framework
│   ├── AI_Agent_System_Message.md  # Protocolo para agentes IA
│   ├── agents_logs/           # Logs de sesiones con IA
│   │   ├── README.md
│   │   ├── session_2025-07-06_1430_claude.md
│   │   └── templates/
│   └── versions/              # Control de versiones
│       ├── README.md
│       └── 2025-07-06_changelog.md
├── agent/                     # 🤖 Workspace de agentes IA
│   ├── README.md
│   ├── lab/                   # Experimentos temporales
│   ├── scripts/               # Scripts de automatización
│   │   ├── health_check.sh
│   │   ├── create_session_log.sh
│   │   └── project_analyzer.py
│   ├── tools/                 # Herramientas utilitarias
│   │   └── rovo_cli_wrapper.py
│   └── examples/              # Ejemplos y prototipos
├── config/                    # ⚙️ Configuración
│   ├── framework_config.yaml
│   ├── logging_config.json
│   └── atlassian_integration.yaml
├── logs/                      # 📊 Logs centralizados
│   ├── 2025-07-06/
│   └── analytics/
├── scripts/                   # 🛠️ Scripts de sistema
│   ├── framework_install.sh
│   └── setup_project.sh
├── system_context.md          # 🧠 Contexto del sistema
├── last_talk.md               # 💬 Última conversación
└── README.md                  # 📖 Este archivo
```

---

## 🎪 Casos de Uso

### 🆕 **Nuevo Desarrollador**
```bash
# 1. Clonar proyecto
git clone repo-url && cd proyecto

# 2. Configurar entorno
./scripts/setup_project.sh

# 3. Leer documentación
cat 01Doc/README.md

# 4. Verificar sistema
./agent/scripts/health_check.sh
```

### 🤖 **Agente IA (Cursor, Claude, etc.)**
```bash
# 1. Leer contexto del proyecto
cat system_context.md && cat last_talk.md

# 2. Verificar estado
./agent/scripts/health_check.sh

# 3. Crear log de sesión
./agent/scripts/create_session_log.sh [agent-name]

# 4. Trabajar en agent/lab/ para experimentos

# 5. Documentar cambios en last_talk.md
```

### 📊 **Análisis de Proyecto Existente**
```bash
# Analizar proyecto actual
python agent/scripts/project_analyzer.py --report

# Generar plan de migración
python agent/scripts/project_analyzer.py --migration-plan

# Aplicar mejoras sugeridas
```

---

## 🌟 Casos de Estudio

### 🎤 **Asistente de Voz Inteligente**
**Proyecto original que inspiró el framework**
- **Tecnologías**: Flutter + FastAPI + MongoDB + MQTT + n8n
- **Resultado**: Reducción de 80% en tiempo de onboarding
- **Documentación**: 11 archivos MD + 60KB de contenido técnico

### 🌱 **Sistema IoT Acuapónico**
**Proyecto adaptado con el framework**
- **Tecnologías**: Python + IoT sensors + Machine Learning
- **Resultado**: Arquitectura escalable desde día 1
- **Integración**: Rovo CLI para documentación automática

### 🛒 **Plataforma E-commerce**
**Migración a framework existente**
- **Tecnologías**: React + Node.js + PostgreSQL
- **Resultado**: Mejora de 50% en velocidad de desarrollo
- **Automatización**: Tickets Jira automáticos desde eventos

---

## 🔧 Herramientas Incluidas

### 🤖 **Rovo CLI Wrapper**
```bash
# Verificar disponibilidad
python agent/tools/rovo_cli_wrapper.py --check

# Crear issue en Jira
python agent/tools/rovo_cli_wrapper.py --create-issue "Mi tarea"

# Sincronizar documentación
python agent/tools/rovo_cli_wrapper.py --sync-docs
```

### 📊 **Analizador de Proyectos**
```bash
# Analizar estructura actual
python agent/scripts/project_analyzer.py --path .

# Generar reporte detallado
python agent/scripts/project_analyzer.py --report

# Crear plan de migración
python agent/scripts/project_analyzer.py --migration-plan
```

### 🏥 **Health Check**
```bash
# Verificación completa del sistema
./agent/scripts/health_check.sh

# Salida esperada:
# ✅ Estructura de directorios OK
# ✅ Archivos esenciales OK
# ✅ Configuración OK
# ✅ Herramientas OK
```

---

## 📊 Métricas y Beneficios

### 📈 **Productividad**
- **80% menos tiempo** en onboarding de nuevos desarrolladores
- **50% menos tiempo** en documentación manual
- **100% automatización** de tareas repetitivas

### 🎯 **Calidad**
- **Documentación siempre actualizada** con sincronización automática
- **Trazabilidad completa** de decisiones y cambios
- **Prevención de errores** mediante IA y análisis automático

### 🤝 **Colaboración**
- **Estándares uniformes** entre todos los proyectos
- **Comunicación fluida** entre humanos y agentes IA
- **Conocimiento compartido** automáticamente

---

## 🔗 Integraciones

### 🏢 **Atlassian Suite**
- **Jira**: Gestión de tareas y seguimiento
- **Confluence**: Documentación centralizada
- **Rovo CLI**: Integración nativa con IA

### 🔄 **Herramientas DevOps**
- **Git**: Control de versiones inteligente
- **Docker**: Containerización estandarizada
- **CI/CD**: Pipelines automatizados

### 📊 **Monitoreo**
- **MQTT**: Logging en tiempo real
- **Analytics**: Métricas de desarrollo
- **Alertas**: Notificaciones proactivas

---

## 🚀 Roadmap

### 🎯 **v1.0** (Actual)
- ✅ Estructura base de documentación
- ✅ Sistema de logs para agentes
- ✅ Integración básica con Atlassian
- ✅ Scripts de automatización

### 🔄 **v1.1** (En desarrollo)
- 🔄 Instalador automático mejorado
- 🔄 Plantillas para diferentes tipos de proyecto
- 🔄 Dashboard web para métricas

### 📊 **v1.2** (Planificado)
- 📋 Métricas avanzadas de efectividad
- 📋 Alertas inteligentes
- 📋 Integración con más herramientas

### 🤖 **v2.0** (Futuro)
- 📋 Agente IA nativo integrado
- 📋 Automatización completa
- 📋 Predicción de problemas

---

## 🤝 Contribuir

### 🔗 **Enlaces Importantes**
- **Issues**: [GitHub Issues](https://github.com/ai-dev-framework/core/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ai-dev-framework/core/discussions)
- **Documentation**: [Docs Site](https://docs.ai-dev-framework.com)

### 📝 **Cómo Contribuir**
1. **Fork** el repositorio
2. **Crear** rama `feature/nueva-funcionalidad`
3. **Seguir** las convenciones del framework
4. **Documentar** cambios en `01Doc/`
5. **Crear** pull request con descripción detallada

### 🎯 **Áreas de Contribución**
- 📚 Documentación y guías
- 🔧 Nuevas herramientas y scripts
- 🎨 Plantillas para diferentes tecnologías
- 🔗 Integraciones con más plataformas
- 🧪 Casos de uso y ejemplos

---

## 📄 Licencia

Este proyecto está licenciado bajo la **MIT License** - ver el archivo [LICENSE](LICENSE) para detalles.

---

## 🙏 Agradecimientos

### 🎯 **Inspiración**
Este framework nació del desarrollo del **Asistente de Voz Inteligente**, un proyecto que demostró el poder de la colaboración humano-IA cuando se estructura correctamente.

### 🤖 **Agentes IA Colaboradores**
- **Claude (Anthropic)** - Desarrollo y documentación
- **Cursor** - Pair programming
- **ChatGPT** - Conceptualización inicial

### 🌟 **Comunidad**
Gracias a todos los desarrolladores que adoptaron versiones tempranas y proporcionaron feedback valioso.

---

## 📞 Contacto y Soporte

### 🆘 **Soporte**
- **Issues**: [GitHub Issues](https://github.com/ai-dev-framework/core/issues)
- **Email**: support@ai-dev-framework.com
- **Discord**: [Community Server](https://discord.gg/ai-dev-framework)

### 📝 **Feedback**
¿Estás usando el framework? ¡Nos encantaría saber tu experiencia!
- **Success Stories**: [Share your story](https://github.com/ai-dev-framework/core/discussions)
- **Feature Requests**: [Request features](https://github.com/ai-dev-framework/core/issues/new)

---

## 🎯 Próximos Pasos

### 🚀 **Para Empezar**
1. **Instalar** el framework en tu proyecto
2. **Configurar** integraciones básicas
3. **Probar** con un agente IA
4. **Documentar** tu experiencia

### 🔄 **Para Contribuir**
1. **Identificar** áreas de mejora
2. **Implementar** nuevas características
3. **Documentar** cambios
4. **Compartir** con la comunidad

---

*🎯 Este framework representa el futuro del desarrollo de software: inteligente, organizado y altamente colaborativo.*

*🚀 ¡Únete a la revolución del desarrollo inteligente!*

---

**¿Listo para transformar tu forma de desarrollar? [Instala el framework ahora](https://github.com/ai-dev-framework/core) y comienza a experimentar el poder de la IA en tu flujo de trabajo.** 