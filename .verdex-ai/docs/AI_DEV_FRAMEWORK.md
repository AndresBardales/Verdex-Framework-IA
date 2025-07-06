# 🚀 AI DEV FRAMEWORK
## Framework de Desarrollo Inteligente para Proyectos con IA

### 🎯 Visión
**Transformar la forma en que los equipos desarrollan software complejo con agentes IA**, proporcionando una infraestructura estandarizada que permite:
- **Onboarding instantáneo** de nuevos desarrolladores
- **Colaboración fluida** entre humanos y agentes IA
- **Documentación automática** y versionado inteligente
- **Trazabilidad completa** de decisiones y cambios
- **Escalabilidad** sin sacrificar organización

---

## 🏗️ Arquitectura del Framework

### 📋 Componentes Principales

#### 🧠 **Core Documentation System**
```
01Doc/
├── README.md                       # Índice maestro
├── AI_Agent_System_Message.md      # Protocolo para agentes IA
├── Developer_Onboarding_Guide.md   # Guía para desarrolladores
├── AI_Ecosystem_Master_Guide.md    # Guía completa del ecosistema
├── agents_logs/                    # Logs de sesiones con IA
│   ├── README.md
│   ├── session_YYYY-MM-DD_HHMM_[agent].md
│   └── templates/
├── versions/                       # Control de versiones
│   ├── README.md
│   ├── YYYY-MM-DD_changelog.md
│   └── rollback_plans/
└── confluence/                     # Docs sincronizadas
```

#### 🤖 **AI Agent Workspace**
```
agent/
├── README.md                       # Guía para agentes
├── lab/                           # Experimentos temporales
│   ├── README.md
│   └── .gitignore
├── scripts/                       # Scripts de automatización
│   ├── health_check.sh
│   ├── test_backend.py
│   └── project_analyzer.py
├── tools/                         # Herramientas utilitarias
│   ├── log_analyzer.py
│   ├── rovo_cli_wrapper.py
│   └── confluence_sync.py
└── examples/                      # Ejemplos y prototipos
```

#### 🔧 **Configuration & Infrastructure**
```
config/
├── framework_config.yaml          # Configuración del framework
├── logging_config.json            # Configuración de logging
├── atlassian_integration.yaml     # Config Jira/Confluence
└── ai_agents_config.yaml          # Configuración de agentes
```

#### 📊 **Monitoring & Analytics**
```
logs/
├── YYYY-MM-DD/                    # Logs por fecha
│   ├── system_events.log
│   ├── ai_interactions.log
│   └── development_metrics.log
└── analytics/                     # Métricas del proyecto
    ├── agent_effectiveness.json
    ├── development_velocity.json
    └── documentation_coverage.json
```

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
# 1. Clonar estructura base
git clone https://github.com/ai-dev-framework/template.git mi-proyecto
cd mi-proyecto

# 2. Ejecutar configuración inicial
./framework_init.sh

# 3. Configurar integraciones
./setup_integrations.sh
```

---

## 🎯 Características Principales

### 🧠 **Inteligencia Integrada**
- **Contexto automático**: Los agentes IA leen automáticamente el contexto del proyecto
- **Memoria persistente**: Cada sesión se documenta automáticamente
- **Aprendizaje continuo**: El framework aprende de patrones de uso y mejora sugerencias

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

## 🔧 Configuración Inicial

### 1. 🎯 Configuración del Proyecto
```bash
# Ejecutar configuración interactiva
./framework_config.sh

# Configurar integraciones
./setup_atlassian.sh --jira-project "PROJ" --confluence-space "SPACE"
```

### 2. 🤖 Configuración de Agentes IA
```bash
# Configurar agentes disponibles
./setup_ai_agents.sh

# Configurar Rovo CLI
rovo login --api-token $ATLASSIAN_API_TOKEN
```

### 3. 📊 Configuración de Monitoreo
```bash
# Configurar MQTT para logging
./setup_mqtt_logging.sh

# Configurar métricas
./setup_analytics.sh
```

---

## 🎪 Casos de Uso

### 🆕 **Nuevo Desarrollador**
```bash
# 1. Clonar proyecto
git clone repo-url && cd proyecto

# 2. Leer contexto automáticamente
./agent/scripts/onboarding.sh

# 3. Configurar entorno
./setup_dev_environment.sh

# 4. Iniciar sesión con agente IA
./agent/scripts/ai_assistant.sh --first-time
```

### 🤖 **Agente IA Iniciando Sesión**
```bash
# 1. Leer contexto del proyecto
cat system_context.md

# 2. Revisar última conversación
cat last_talk.md

# 3. Ejecutar health check
./agent/scripts/health_check.sh

# 4. Iniciar log de sesión
./agent/scripts/create_session_log.sh
```

### 📊 **Gestor de Proyecto**
```bash
# Ver métricas del proyecto
./scripts/generate_project_report.sh

# Sincronizar con Confluence
./scripts/sync_documentation.sh

# Generar resumen para stakeholders
./scripts/generate_stakeholder_report.sh
```

---

## 🌟 Beneficios del Framework

### 📈 **Productividad**
- **Reducción de 80% en tiempo de onboarding**
- **50% menos tiempo en documentación**
- **Automatización de tareas repetitivas**

### 🎯 **Calidad**
- **Documentación siempre actualizada**
- **Trazabilidad completa de decisiones**
- **Prevención de errores mediante IA**

### 🤝 **Colaboración**
- **Estándares uniformes** entre proyectos
- **Comunicación fluida** humano-IA
- **Conocimiento compartido** automático

### 🔒 **Escalabilidad**
- **Arquitectura modular** adaptable
- **Patrones reutilizables** entre proyectos
- **Crecimiento orgánico** sin caos

---

## 🛣️ Roadmap

### 🎯 **v1.0 - MVP** (Actual)
- ✅ Estructura base de documentación
- ✅ Sistema de logs para agentes
- ✅ Integración básica con Atlassian
- ✅ Scripts de automatización básicos

### 🚀 **v1.1 - Instalador Automático**
- 🔄 Script de instalación con curl
- 🔄 Configuración automática de integraciones
- 🔄 Plantillas para diferentes tipos de proyecto

### 📊 **v1.2 - Analytics Avanzados**
- 📋 Métricas de efectividad de agentes
- 📋 Dashboard de velocidad de desarrollo
- 📋 Alertas inteligentes de problemas

### 🤖 **v2.0 - IA Nativa**
- 📋 Agente IA integrado en el framework
- 📋 Automatización completa de documentación
- 📋 Predicción de problemas y sugerencias

---

## 📚 Documentación Completa

### 📖 **Guías Principales**
- **[Guía de Instalación](./Installation_Guide.md)**
- **[Guía para Desarrolladores](./Developer_Guide.md)**
- **[Guía para Agentes IA](./AI_Agent_Guide.md)**
- **[Guía de Configuración](./Configuration_Guide.md)**

### 🔧 **Referencias Técnicas**
- **[API Reference](./API_Reference.md)**
- **[Arquitectura Técnica](./Technical_Architecture.md)**
- **[Patrones de Integración](./Integration_Patterns.md)**

### 📊 **Casos de Estudio**
- **[Proyecto Asistente de Voz](./case_studies/voice_assistant.md)**
- **[Sistema IoT Acuapónico](./case_studies/aquaponics_iot.md)**
- **[Plataforma E-commerce](./case_studies/ecommerce_platform.md)**

---

## 🤝 Contribuir al Framework

### 🔗 **Enlaces Importantes**
- **GitHub**: https://github.com/ai-dev-framework/core
- **Documentación**: https://docs.ai-dev-framework.com
- **Community**: https://discord.gg/ai-dev-framework
- **Issues**: https://github.com/ai-dev-framework/core/issues

### 📝 **Cómo Contribuir**
1. **Fork** el repositorio
2. **Crear** rama feature/nueva-funcionalidad
3. **Implementar** cambios siguiendo las guías
4. **Documentar** cambios en 01Doc/
5. **Crear** pull request con descripción detallada

---

## 📄 Licencia

Este framework está licenciado bajo **MIT License** - ver [LICENSE](LICENSE) para detalles.

---

## 🎯 Próximos Pasos

### 🚀 **Para Empezar**
1. **Instalar** el framework en un proyecto
2. **Configurar** integraciones básicas
3. **Probar** con un agente IA
4. **Documentar** la experiencia

### 🔄 **Para Contribuir**
1. **Identificar** mejoras en el framework
2. **Implementar** nuevas características
3. **Documentar** cambios
4. **Compartir** con la comunidad

---

*🎯 Este framework es el resultado de desarrollar proyectos complejos con IA y aprender de la experiencia. Está diseñado para evolucionar y mejorar continuamente.*

*🚀 ¡Únete a la revolución del desarrollo inteligente!* 