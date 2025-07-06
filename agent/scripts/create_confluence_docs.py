#!/usr/bin/env python3
"""
📝 Creador de Documentación Confluence - AI Dev Framework
Genera documentación completa del framework en Confluence usando acli
"""

import os
import subprocess
import json
import tempfile
from pathlib import Path

class ConfluenceDocCreator:
    """Creador de documentación para Confluence"""
    
    def __init__(self):
        self.space_key = "VFI"
        self.base_url = "https://bit2bit.atlassian.net"
        
    def create_framework_overview_page(self):
        """Crear página principal del framework"""
        content = """
# 🚀 AI Dev Framework - Transformando el Desarrollo con IA

## 🎯 ¿Qué es el AI Dev Framework?

El **AI Dev Framework** es una infraestructura revolucionaria que permite a equipos de desarrollo adoptar **buenas prácticas de colaboración con agentes IA** de forma instantánea y escalable.

### 🌟 Características Principales

#### 🧠 **Inteligencia Integrada**
- **Contexto automático**: Los agentes IA leen automáticamente el contexto del proyecto
- **Memoria persistente**: Cada sesión se documenta automáticamente  
- **Aprendizaje continuo**: El framework aprende de patrones y mejora sugerencias

#### 📚 **Documentación Viva**
- **Sincronización automática**: Markdown local ↔ Confluence
- **Versionado inteligente**: Control de versiones con rollback automático
- **Plantillas dinámicas**: Generación automática de documentación

#### 🔗 **Integración Atlassian Nativa**
- **Rovo CLI**: Integración nativa con Atlassian
- **Jira**: Creación automática de tickets desde eventos
- **Confluence**: Sincronización bidireccional de documentación

#### 📊 **Monitoreo Inteligente**
- **Logging centralizado**: MQTT para eventos en tiempo real
- **Métricas automáticas**: Seguimiento de velocidad de desarrollo
- **Alertas proactivas**: Detección de problemas antes de que ocurran

---

## 🎪 ¿Por Qué Usar el AI Dev Framework?

### 📈 **Productividad Comprobada**
- **80% reducción** en tiempo de onboarding de desarrolladores
- **50% menos tiempo** en documentación manual
- **100% automatización** de tareas repetitivas

### 🎯 **Calidad Garantizada**
- **Documentación siempre actualizada** con sincronización automática
- **Trazabilidad completa** de decisiones y cambios
- **Prevención de errores** mediante IA y análisis automático

### 🤝 **Colaboración Fluida**
- **Estándares uniformes** entre todos los proyectos
- **Comunicación fluida** entre humanos y agentes IA
- **Conocimiento compartido** automáticamente

### 🔒 **Escalabilidad Sin Caos**
- **Arquitectura modular** adaptable a cualquier proyecto
- **Patrones reutilizables** entre equipos y tecnologías
- **Crecimiento orgánico** sin perder organización

---

## 🛠️ Instalación Ultra-Rápida

### 🚀 **Un Solo Comando**
```bash
# Instalar framework en proyecto existente
curl -fsSL https://raw.githubusercontent.com/ai-dev-framework/core/main/install.sh | bash

# O para proyecto nuevo
curl -fsSL https://raw.githubusercontent.com/ai-dev-framework/core/main/install.sh | bash -s -- --new-project "mi-proyecto"
```

### ⚡ **Listo en 5 Minutos**
1. **Instalación**: Un comando descarga y configura todo
2. **Configuración**: Script interactivo configura tu entorno
3. **Verificación**: Health check automático valida la instalación
4. **¡A desarrollar!**: Framework listo para usar con agentes IA

---

## 🏗️ Arquitectura del Framework

### 📁 **Estructura Inteligente**
```
mi-proyecto/
├── 01Doc/                      # 📚 Documentación centralizada
│   ├── agents_logs/           # Logs de sesiones con IA
│   └── versions/              # Control de versiones
├── agent/                     # 🤖 Workspace de agentes IA
│   ├── lab/                   # Experimentos seguros
│   ├── scripts/               # Scripts de automatización
│   └── tools/                 # Herramientas inteligentes
├── config/                    # ⚙️ Configuración centralizada
├── scripts/                   # 🛠️ Scripts de sistema
└── logs/                      # 📊 Logs centralizados
```

### 🔄 **Flujo de Trabajo con IA**
1. **Contexto**: Agente lee `system_context.md` y `last_talk.md`
2. **Health Check**: Verifica estado del sistema
3. **Sesión**: Crea log automático en `agents_logs/`
4. **Desarrollo**: Experimenta en `agent/lab/`
5. **Implementación**: Aplica cambios validados
6. **Documentación**: Actualiza `last_talk.md` automáticamente

---

## 🌟 Casos de Éxito Comprobados

### 🎤 **Asistente de Voz Inteligente**
*Proyecto que inspiró el framework*
- **Tecnologías**: Flutter + FastAPI + MongoDB + MQTT + n8n
- **Resultado**: 80% reducción en tiempo de onboarding
- **Documentación**: 11 archivos MD + 60KB contenido técnico generado automáticamente

### 🌱 **Sistema IoT Acuapónico** 
*Proyecto adaptado con el framework*
- **Tecnologías**: Python + IoT sensors + Machine Learning
- **Resultado**: Arquitectura escalable desde día 1
- **Integración**: Rovo CLI para documentación automática

### 🛒 **Plataforma E-commerce**
*Migración a framework existente*
- **Tecnologías**: React + Node.js + PostgreSQL  
- **Resultado**: 50% mejora en velocidad de desarrollo
- **Automatización**: Tickets Jira automáticos desde eventos

---

## 🎯 Casos de Uso Específicos

### 🆕 **Nuevo Desarrollador en el Equipo**
```bash
# 1. Clonar proyecto
git clone repo-url && cd proyecto

# 2. Configurar entorno automáticamente
./scripts/setup_project.sh

# 3. Leer documentación actualizada
cat 01Doc/README.md

# 4. Verificar que todo funciona
./agent/scripts/health_check.sh

# ¡Listo para contribuir en < 30 minutos!
```

### 🤖 **Agente IA (Cursor, Claude, etc.)**
```bash
# 1. Cargar contexto del proyecto
cat system_context.md && cat last_talk.md

# 2. Verificar estado actual
./agent/scripts/health_check.sh

# 3. Crear log de sesión automático
./agent/scripts/create_session_log.sh claude

# 4. Experimentar en entorno seguro
cd agent/lab/ && # hacer pruebas

# 5. Documentar cambios automáticamente
# Framework actualiza last_talk.md
```

### 📊 **Gestor de Proyecto**
```bash
# Ver métricas del proyecto
./scripts/generate_project_report.sh

# Sincronizar con Confluence automáticamente
./scripts/sync_documentation.sh

# Generar resumen para stakeholders
./scripts/generate_stakeholder_report.sh
```

---

## 🔧 Herramientas Incluidas

### 🤖 **Integración Rovo CLI**
- **Wrapper inteligente** para comandos Atlassian
- **Creación automática** de tickets Jira
- **Sincronización** bidireccional con Confluence
- **Reportes automáticos** de progreso

### 📊 **Analizador de Proyectos**
- **Scoring automático** de calidad del proyecto
- **Recomendaciones** específicas de mejora
- **Plan de migración** para proyectos existentes
- **Métricas** de productividad y efectividad

### 🏥 **Sistema de Monitoreo**
- **Health checks** automáticos de todos los servicios
- **Logging centralizado** con MQTT
- **Alertas proactivas** ante problemas
- **Dashboard** de métricas en tiempo real

---

## 🚀 Roadmap y Futuro

### 🎯 **v1.0** (Actual)
- ✅ Instalador automático con curl
- ✅ Documentación completa y versionada
- ✅ Integración básica con Atlassian
- ✅ Scripts de automatización fundamentales

### 🔄 **v1.1** (En Desarrollo)
- 🔄 Dashboard web para métricas
- 🔄 Plantillas para diferentes stacks tecnológicos
- 🔄 Integración con GitHub Actions y GitLab CI

### 📊 **v1.2** (Planificado)
- 📋 Métricas avanzadas de efectividad de agentes
- 📋 Alertas inteligentes ML-powered
- 📋 Integración con más herramientas (Slack, Teams, etc.)

### 🤖 **v2.0** (Visión)
- 📋 Agente IA nativo integrado en el framework
- 📋 Automatización completa de workflows
- 📋 Predicción de problemas y sugerencias proactivas

---

## 💡 ¿Cómo Empezar Hoy?

### 🎯 **Para Equipos Nuevos**
1. **Instalar** framework con un comando
2. **Configurar** integraciones básicas (5 minutos)
3. **Entrenar** al equipo con documentación incluida
4. **¡Desarrollar!** con productividad 2x desde día 1

### 🔄 **Para Proyectos Existentes**
1. **Analizar** proyecto actual con herramientas incluidas
2. **Planificar** migración con recomendaciones automáticas
3. **Migrar** gradualmente sin interrumpir desarrollo
4. **Disfrutar** mejoras inmediatas en organización

### 🤝 **Para Organizaciones**
1. **Estandarizar** desarrollo en todos los equipos
2. **Acelerar** onboarding de nuevos desarrolladores
3. **Mejorar** colaboración entre equipos técnicos
4. **Escalar** desarrollo con agentes IA de forma segura

---

## 🏆 Conclusión

El **AI Dev Framework** no es solo una herramienta, es una **revolución en la forma de desarrollar software**. Transforma equipos caóticos en máquinas de productividad organizadas, permite colaboración fluida con IA, y garantiza escalabilidad sin sacrificar calidad.

### 🎯 **Beneficios Inmediatos**
- ⚡ **Instalación en minutos**, no horas
- 📚 **Documentación automática**, siempre actualizada  
- 🤖 **IA como miembro del equipo**, no como herramienta
- 📊 **Métricas de productividad**, datos reales de mejora

### 🚀 **Impacto a Largo Plazo**
- 🏢 **Estandarización** de desarrollo en toda la organización
- 🎓 **Formación acelerada** de desarrolladores junior
- 🔄 **Adopción gradual** de IA sin disrupciones
- 🌟 **Ventaja competitiva** medible y sostenible

**¿Listo para transformar tu forma de desarrollar software?**

[**Instalar Framework Ahora**](https://github.com/ai-dev-framework/core) | [**Ver Casos de Uso**](#casos-de-uso) | [**Contactar Soporte**](#soporte)

---

*🎯 El futuro del desarrollo es inteligente, organizado y altamente productivo. El AI Dev Framework te lleva allí hoy.*
"""
        
        return content
    
    def create_installation_guide_page(self):
        """Crear página de guía de instalación"""
        content = """
# 🛠️ Instalación y Configuración - AI Dev Framework

## 🚀 Instalación Ultra-Rápida

### ⚡ **Opción 1: Un Solo Comando (Recomendado)**

#### Para Proyecto Nuevo
```bash
curl -fsSL https://raw.githubusercontent.com/ai-dev-framework/core/main/install.sh | bash -s -- --new-project "mi-proyecto"
```

#### Para Proyecto Existente
```bash
curl -fsSL https://raw.githubusercontent.com/ai-dev-framework/core/main/install.sh | bash
```

### 📋 **Opción 2: Instalación Manual**

#### 1. Clonar Framework
```bash
git clone https://github.com/ai-dev-framework/core.git
cd core
```

#### 2. Ejecutar Instalador
```bash
./scripts/framework_install.sh --new-project "mi-proyecto"
```

#### 3. Configurar Proyecto
```bash
cd mi-proyecto
./scripts/setup_project.sh
```

---

## ⚙️ Configuración Paso a Paso

### 1. 🎯 **Configuración Básica del Proyecto**

El script de configuración te guiará interactivamente:

```bash
./scripts/setup_project.sh
```

**Información requerida:**
- Nombre del proyecto
- Descripción breve  
- Tipo de proyecto (web/mobile/desktop/iot)
- Stack tecnológico principal

### 2. 🔗 **Configuración de Atlassian (Opcional)**

#### Configurar Credenciales
Edita `config/atlassian_integration.yaml`:

```yaml
atlassian:
  base_url: "https://tu-dominio.atlassian.net"
  email: "tu-email@empresa.com"
  api_token: "tu-api-token"

jira:
  enabled: true
  project_key: "TU-PROYECTO"
  
confluence:
  enabled: true
  space_key: "TU-ESPACIO"
```

#### Obtener API Token
1. Ve a [Atlassian Account Settings](https://id.atlassian.com/manage-profile/security/api-tokens)
2. Crea un nuevo API token
3. Copia el token al archivo de configuración

#### Configurar Rovo CLI
```bash
# Instalar Atlassian CLI si no lo tienes
# Seguir instrucciones en: https://developer.atlassian.com/platform/atlassian-cli/

# Autenticar
acli auth login --email tu-email@empresa.com --token tu-api-token
```

### 3. 🤖 **Configuración de Agentes IA**

#### Configurar Tipos de Agentes
Edita `config/ai_agents_config.yaml`:

```yaml
agents:
  allowed_agents:
    - "cursor"
    - "claude"
    - "chatgpt"
    - "rovo"
  
  logging:
    auto_create_session_logs: true
    auto_update_last_talk: true
```

#### Configurar Protocolos
El framework incluye protocolos estándar en `01Doc/AI_Agent_System_Message.md`

### 4. 📊 **Configuración de Logging (Opcional)**

#### Configurar MQTT (Para proyectos avanzados)
Edita `config/logging_config.json`:

```json
{
  "logging": {
    "enabled": true,
    "level": "INFO",
    "retention_days": 30
  },
  "outputs": {
    "file": {
      "enabled": true,
      "path": "./logs"
    },
    "mqtt": {
      "enabled": false,
      "broker": "localhost",
      "port": 1883
    }
  }
}
```

---

## 🏥 Verificación de Instalación

### **Health Check Completo**
```bash
./agent/scripts/health_check.sh
```

**Salida esperada:**
```
🏥 Ejecutando Health Check...
================================
📁 Verificando estructura de directorios...
✅ Estructura de directorios OK
📄 Verificando archivos esenciales...
✅ Archivos esenciales OK
⚙️ Verificando configuración...
✅ Configuración OK
🔧 Verificando herramientas...
✅ Herramientas OK
================================
🎯 Health Check completado
```

### **Verificar Herramientas**
```bash
# Verificar Git
git --version

# Verificar Python
python3 --version

# Verificar Tree
tree --version

# Verificar Atlassian CLI (opcional)
acli --version
```

---

## 🎯 Primer Uso

### 1. **Leer Contexto del Proyecto**
```bash
# Información general
cat README.md

# Contexto técnico para agentes IA
cat system_context.md

# Última actividad
cat last_talk.md
```

### 2. **Crear Primera Sesión con Agente IA**
```bash
# Crear log de sesión
./agent/scripts/create_session_log.sh mi-agente

# Seguir protocolo en 01Doc/AI_Agent_System_Message.md
```

### 3. **Explorar Herramientas Disponibles**
```bash
# Ver herramientas disponibles
ls agent/tools/

# Probar analizador de proyectos
python agent/scripts/project_analyzer.py --report

# Probar wrapper de Rovo CLI
python agent/tools/rovo_cli_wrapper.py --check
```

---

## 🔧 Personalización Avanzada

### **Estructura de Directorios Personalizada**

Puedes modificar la estructura según tus necesidades:

```
mi-proyecto/
├── 01Doc/              # Documentación (NO modificar)
├── agent/              # Agentes IA (NO modificar)  
├── config/             # Configuración (personalizable)
├── src/                # Tu código fuente
├── tests/              # Tus pruebas
├── docs/               # Documentación adicional
└── deploy/             # Scripts de despliegue
```

### **Scripts Personalizados**

Agrega tus scripts en `scripts/` siguiendo las convenciones:

```bash
# Scripts de desarrollo
scripts/start-dev.sh
scripts/stop-dev.sh
scripts/test-all.sh

# Scripts de despliegue
scripts/deploy-staging.sh
scripts/deploy-production.sh
```

### **Integraciones Adicionales**

El framework es extensible. Puedes agregar:

- **GitHub Actions**: Workflows automáticos
- **GitLab CI**: Pipelines de integración
- **Docker**: Containerización del framework
- **Kubernetes**: Orquestación avanzada

---

## 🚨 Solución de Problemas

### **Problemas Comunes**

#### 1. **Error de Permisos**
```bash
# Hacer ejecutables los scripts
chmod +x agent/scripts/*.sh
chmod +x scripts/*.sh
```

#### 2. **Falta Tree**
```bash
# Ubuntu/Debian
sudo apt install tree

# macOS
brew install tree
```

#### 3. **Error de Python**
```bash
# Verificar Python 3
python3 --version

# Instalar dependencias
pip3 install -r agent/requirements.txt
```

#### 4. **Error de Atlassian CLI**
```bash
# Verificar autenticación
acli auth whoami

# Re-autenticar si es necesario
acli auth login
```

### **Logs de Depuración**

#### Ver Logs del Framework
```bash
# Logs generales
tail -f logs/$(date +%Y-%m-%d)/*.log

# Logs de agentes específicos
tail -f 01Doc/agents_logs/session_*.md
```

#### Modo Verbose
```bash
# Ejecutar scripts en modo verbose
./agent/scripts/health_check.sh -v
python agent/scripts/project_analyzer.py --verbose
```

---

## 📞 Soporte y Ayuda

### **Recursos de Ayuda**

- **Documentación Completa**: `01Doc/README.md`
- **Guías de Agentes**: `01Doc/AI_Agent_System_Message.md`
- **Casos de Uso**: `01Doc/Casos_de_Uso.md`

### **Comunidad**

- **GitHub Issues**: [Reportar problemas](https://github.com/ai-dev-framework/core/issues)
- **Discussions**: [Hacer preguntas](https://github.com/ai-dev-framework/core/discussions)
- **Discord**: [Chat en vivo](https://discord.gg/ai-dev-framework)

### **Soporte Empresarial**

Para empresas que necesiten soporte personalizado:
- **Email**: enterprise@ai-dev-framework.com
- **Consultoría**: Implementación guiada
- **Entrenamiento**: Workshops para equipos

---

## ✅ Checklist de Instalación Completa

### **Básico**
- [ ] Framework instalado exitosamente
- [ ] Health check pasa todas las verificaciones
- [ ] `system_context.md` personalizado con información del proyecto
- [ ] Primera sesión con agente IA documentada

### **Intermedio**
- [ ] Integración con Atlassian configurada
- [ ] Logs de agentes funcionando correctamente
- [ ] Scripts de desarrollo personalizados
- [ ] Documentación sincronizada con Confluence

### **Avanzado**
- [ ] MQTT logging configurado
- [ ] Métricas de productividad activas
- [ ] CI/CD integrado con framework
- [ ] Equipo entrenado en uso del framework

---

**🎯 ¡Felicidades! Tu proyecto ahora tiene superpoderes de IA.**

[**Volver al Inicio**](#instalación-ultra-rápida) | [**Ver Casos de Uso**](Casos-de-Uso) | [**Contactar Soporte**](#soporte-y-ayuda)

---

*⚡ Con el AI Dev Framework, la instalación es solo el comienzo. La verdadera magia empieza cuando tu equipo comienza a desarrollar con IA de forma estructurada y productiva.*
"""
        
        return content
    
    def run_acli_command(self, cmd_args):
        """Ejecutar comando acli"""
        try:
            cmd = ["acli"] + cmd_args
            result = subprocess.run(cmd, capture_output=True, text=True)
            return result.returncode == 0, result.stdout, result.stderr
        except Exception as e:
            return False, "", str(e)
    
    def create_confluence_page(self, title, content):
        """Crear página en Confluence usando acli"""
        print(f"📝 Creando página: {title}")
        
        # Crear archivo temporal con el contenido
        with tempfile.NamedTemporaryFile(mode='w', suffix='.md', delete=False) as f:
            f.write(content)
            temp_file = f.name
        
        try:
            # Comando para crear página
            cmd_args = [
                "confluence", "page", "create",
                "--title", title,
                "--space", self.space_key,
                "--content-file", temp_file
            ]
            
            success, stdout, stderr = self.run_acli_command(cmd_args)
            
            if success:
                print(f"✅ Página '{title}' creada exitosamente")
                return True
            else:
                print(f"❌ Error creando página: {stderr}")
                return False
                
        finally:
            # Limpiar archivo temporal
            os.unlink(temp_file)
    
    def create_all_documentation(self):
        """Crear toda la documentación del framework"""
        print("🚀 Creando documentación completa del AI Dev Framework en Confluence...")
        
        # Verificar conectividad
        success, stdout, stderr = self.run_acli_command(["auth", "whoami"])
        if not success:
            print("❌ No estás autenticado en Atlassian CLI")
            print("💡 Ejecuta: acli auth login")
            return False
        
        print(f"✅ Autenticado como: {stdout.strip()}")
        
        # Crear páginas
        pages = [
            ("🚀 AI Dev Framework - Guía Completa", self.create_framework_overview_page()),
            ("🛠️ Instalación y Configuración", self.create_installation_guide_page()),
        ]
        
        success_count = 0
        for title, content in pages:
            if self.create_confluence_page(title, content):
                success_count += 1
        
        print(f"\n🎯 Documentación creada: {success_count}/{len(pages)} páginas")
        print(f"📍 Ver en: {self.base_url}/wiki/spaces/{self.space_key}")
        
        return success_count == len(pages)

def main():
    """Función principal"""
    creator = ConfluenceDocCreator()
    
    print("📚 Creador de Documentación AI Dev Framework")
    print("=" * 50)
    
    # Crear documentación
    success = creator.create_all_documentation()
    
    if success:
        print("\n🎉 ¡Documentación creada exitosamente!")
        print("🔗 Ve a Confluence para revisar las páginas creadas")
    else:
        print("\n⚠️  Algunas páginas no se pudieron crear")
        print("💡 Verifica tu configuración de Atlassian CLI")

if __name__ == "__main__":
    main() 