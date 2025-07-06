# 🚀 Quick Start - Sistema de Logs y Analytics

## Un Solo Comando para Iniciar TODO

```bash
./scripts/start-all.sh
```

Este comando:
- ✅ **Levanta todos los contenedores Docker**
- ✅ **Inicia el dashboard de logs** (puerto 8080)
- ✅ **Genera eventos de prueba** automáticamente
- ✅ **Verifica que todo funcione**
- ✅ **Muestra todas las URLs disponibles**
- ✅ **Queda mostrando logs en tiempo real**

## 📊 Dashboards Disponibles

| Dashboard | URL | Descripción |
|-----------|-----|-------------|
| **🎯 Logs Tiempo Real** | `http://localhost:8080` | **Dashboard principal** |
| **📈 Analytics** | `http://localhost:5001` | Métricas avanzadas |
| **🔧 Auth Service** | `http://localhost:8001` | API de autenticación |
| **📡 EMQX** | `http://localhost:18083` | MQTT broker admin |
| **🍃 n8n** | `http://localhost:5678` | Automatización |

## 📱 Ejecutar Flutter App

```bash
cd audio_recorder_app
flutter run -d e9bd3f17
```

## 🛠️ Comandos Útiles

```bash
# Solo ver logs (si ya está todo corriendo)
./scripts/logs-only.sh

# Ver logs filtrados por usuario
./scripts/watch-logs.sh -u andresbardales15@gmail.com

# Ver logs de un tópico específico
./scripts/watch-logs.sh -t ui/interactions

# Detener todo el sistema
./scripts/stop-all.sh
```

## 🎭 Eventos Generados Automáticamente

El sistema genera eventos de prueba cada 2-8 segundos:
- **UI Interactions**: Taps, swipes, navegación
- **Audio Events**: Grabaciones, uploads
- **Auth Events**: Login, logout, verificaciones
- **Session Events**: Inicio/fin de sesión
- **Automation**: Alertas, notificaciones

## 🔄 Workflow Típico

1. **Iniciar sistema**: `./scripts/start-all.sh`
2. **Abrir dashboard**: `http://localhost:8080`
3. **Ejecutar Flutter app**: Ver eventos reales aparecer
4. **Filtrar por usuario**: Para ver solo tus eventos
5. **Detener sistema**: `./scripts/stop-all.sh`

## ⚡ Características

- **📊 Dashboard en tiempo real** (actualiza cada 2 segundos)
- **🎯 Tópico universal "all"** que captura todo
- **🔍 Filtros avanzados** por usuario y tópico
- **📱 Analytics automático** de Flutter app
- **🤖 Eventos sintéticos** para testing
- **📈 Múltiples dashboards** especializados

¡Todo el sistema de logs y analytics en **UN SOLO COMANDO**! 🎉 