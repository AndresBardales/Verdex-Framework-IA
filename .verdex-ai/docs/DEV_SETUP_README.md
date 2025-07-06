# 🚀 Development Setup Guide - Asistente Voz Realtime v1.0

## ⚡ Quick Start

```bash
# Iniciar todo el stack de desarrollo
./start-dev.sh

# Detener servicios (mantener datos)
./stop-dev.sh

# Para desarrolladores nuevos: solo estos 2 comandos necesitas! 🎉
```

## 🛠️ Scripts Disponibles

### 🚀 `./start-dev.sh`
**Script principal de desarrollo** - Hace todo automáticamente:
- ✅ Detecta tu IP local automáticamente
- ✅ Actualiza configuración de Flutter con IP correcta
- ✅ Inicia todos los servicios Docker
- ✅ Crea datos de ejemplo en primera ejecución
- ✅ Verifica que todos los servicios estén listos
- ✅ Muestra todas las URLs y conexiones útiles
- ✅ Mantiene logs en tiempo real

### 🛑 `./stop-dev.sh`
**Parada segura del entorno**:
- Opción 1: Parar servicios (mantener datos)
- Opción 2: Limpiar todo (⚠️ BORRA DATOS)
- Confirmación de seguridad para evitar pérdidas

### 🔄 `./scripts/update-flutter-config.sh`
**Actualización automática de configuración Flutter**:
- Auto-detecta IP local
- Actualiza `config.json` y `config_service.dart`
- Crea backups automáticos
- Se ejecuta automáticamente en `start-dev.sh`

## 📊 URLs de Desarrollo

Después de ejecutar `./start-dev.sh` tendrás acceso a:

| Servicio | URL Local | URL Red | Descripción |
|----------|-----------|---------|-------------|
| **Backend API** | http://localhost:5005 | http://IP:5005 | FastAPI + Whisper |
| **API Docs** | http://localhost:5005/docs | http://IP:5005/docs | Swagger UI |
| **n8n Automation** | http://localhost:5678 | http://IP:5678 | Workflows |
| **EMQX Dashboard** | http://localhost:18083 | http://IP:18083 | MQTT admin |
| **MongoDB** | mongodb://localhost:27017 | mongodb://IP:27017 | Database |

**Credenciales EMQX**: `admin` / `public`

## 📱 Desarrollo Flutter

```bash
# Instalar dependencias
cd audio_recorder_app && flutter pub get

# Ejecutar en celular (conectado por USB)
flutter run

# Build APK para testing
flutter build apk --release
```

**⚡ Tip**: La configuración se actualiza automáticamente con tu IP local.

## 🧪 Datos de Ejemplo

En primera ejecución se crean automáticamente:
- **MongoDB**: 2 grabaciones de ejemplo con transcripciones completas
- **n8n**: Workflow de procesamiento de audio listo para usar
- **EMQX**: Topics y ejemplos de mensajes MQTT

### Reiniciar con datos frescos:
```bash
./stop-dev.sh  # Opción 2: Limpiar datos
./start-dev.sh # Recrea datos de ejemplo
```

## 🔧 Herramientas de Desarrollo

```bash
# Verificar salud de servicios
./agent/scripts/health_check.sh

# Probar backend con audio sintético
python agent/scripts/test_backend.py

# Monitorear mensajes MQTT en tiempo real
python agent/tools/mqtt_monitor.py

# Ver logs de servicios específicos
docker compose logs -f fastapi-backend
docker compose logs -f emqx
```

## 📂 Estructura de Datos

```
dev-data/
├── mongodb/init/           # Datos iniciales MongoDB
├── n8n/workflows/          # Workflows de ejemplo
├── emqx/                   # Configuración MQTT
└── sample-audio-metadata.json
```

**Persistencia**: Los datos se mantienen en volúmenes Docker entre reinicios.

## 🔄 Workflow Típico de Desarrollo

1. **Inicio**: `./start-dev.sh`
2. **Desarrollo Flutter**: `cd audio_recorder_app && flutter run`
3. **Testing**: Grabar audio → Ver transcripción → Verificar MQTT
4. **Debugging**: Usar dashboards web y herramientas de monitoring
5. **Fin**: `./stop-dev.sh` (Opción 1 para mantener datos)

## 🆘 Troubleshooting

**Problema**: Servicios no inician
```bash
docker compose down -v  # Limpiar todo
./start-dev.sh           # Reiniciar fresh
```

**Problema**: Flutter no conecta
```bash
./scripts/update-flutter-config.sh  # Actualizar IPs
flutter run                         # Relanzar app
```

**Problema**: Datos corruptos
```bash
./stop-dev.sh    # Opción 2: DELETE
./start-dev.sh   # Datos frescos
```

## 🎯 Para AI Agents

Este entorno está optimizado para desarrollo asistido por IA:
- Scripts automatizados que "Just Work"™
- Datos de ejemplo realistas
- Logs y debugging tools
- Documentación completa en `AGENT_README.md`

**Comandos esenciales para AIs**:
- `./start-dev.sh` - Iniciar todo
- `./agent/scripts/health_check.sh` - Verificar estado
- `docker compose logs -f` - Ver logs
- `python agent/tools/mqtt_monitor.py` - Monitor MQTT

---

## 🎉 ¡Eso es todo!

**Con 1 comando tienes un laboratorio completo de desarrollo para tu asistente de voz inteligente.**

¿Problemas? Revisa `AGENT_README.md` para documentación técnica completa. 