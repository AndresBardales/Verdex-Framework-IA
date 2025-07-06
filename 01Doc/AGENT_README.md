## 🤖 Asistente Voz Realtime - Guía Técnica para Agentes IA

### 📊 Estado del Proyecto (Enero 2025)
- **Versión**: v1.0 MVP Completo ✅
- **Estado**: Funcional - Listo para testing end-to-end
- **Última actualización**: Enero 5, 2025
- **Arquitectura**: Microservicios containerizados con Docker Compose

---

## 🎯 ¿Qué es este proyecto?

**Asistente Voz Realtime** es una aplicación móvil Flutter que actúa como asistente personal inteligente. Graba conversaciones/audio hasta 5 minutos, las transcribe con Whisper (local o OpenAI), realiza análisis emocional, y ejecuta acciones automáticas via n8n. Todo comunicado en tiempo real via MQTT.

### 🔑 Funcionalidades Implementadas
- ✅ Grabación de audio AAC hasta 5 minutos
- ✅ Upload automático al backend FastAPI  
- ✅ Transcripción con Whisper local o OpenAI API
- ✅ Análisis emocional básico (5 emociones)
- ✅ Extracción de entidades (tareas, fechas, personas)
- ✅ Comunicación MQTT tiempo real (6 tipos de mensajes)
- ✅ Integración n8n para automatización
- ✅ UI Material 3 moderna con estado de servicios
- ✅ Base de datos MongoDB para persistencia
- ✅ Sistema de health checking completo

---

## 🏗️ Arquitectura Técnica

```
┌─────────────────┐    HTTP POST     ┌─────────────────┐    
│  Flutter App    │ ────────────────► │  FastAPI        │    
│  (Mobile)       │                   │  Backend        │    
│  - Grabación    │◄─── MQTT ────────┤  - Whisper      │    
│  - UI Material3 │                   │  - Análisis IA  │    
└─────────────────┘                   └─────────────────┘    
                                               │              
                                               ▼              
┌─────────────────┐    Webhooks      ┌─────────────────┐    
│     n8n         │◄─────────────────┤    MongoDB      │    
│  Automation     │                   │   Database      │    
│  - Workflows    │                   │  - Recordings   │    
│  - Actions      │                   │  - Metadata     │    
└─────────────────┘                   └─────────────────┘    
         │                                     ▲              
         ▼                                     │              
┌─────────────────┐                   ┌─────────────────┐    
│   EMQX MQTT     │                   │   Audio Files   │    
│   Broker        │                   │   Storage       │    
│  - 6 topic types│                   │  - Temporary    │    
│  - Real-time    │                   │  - Processing   │    
└─────────────────┘                   └─────────────────┘    
```

### 🐳 Servicios Docker
```yaml
# docker-compose.yml incluye:
- fastapi_backend    # Puerto 5005 - API principal
- mongodb           # Puerto 27017 - Base de datos  
- emqx              # Puerto 1883/18083 - MQTT broker
- n8n               # Puerto 5678 - Automatización
```

---

## 📁 Estructura del Proyecto

```
flutter/
├── 📱 audio_recorder_app/          # App Flutter principal
│   ├── lib/
│   │   ├── models/                 # Modelos de datos
│   │   │   ├── audio_recording.dart
│   │   │   ├── config_model.dart  
│   │   │   └── mqtt_message.dart   # 6 tipos de mensajes
│   │   ├── providers/              # Estado global
│   │   │   └── audio_provider.dart # Provider principal
│   │   ├── services/               # Servicios
│   │   │   ├── audio_service.dart     # Grabación AAC
│   │   │   ├── config_service.dart    # Configuración
│   │   │   ├── connectivity_service.dart
│   │   │   ├── mqtt_service.dart      # Cliente MQTT
│   │   │   └── upload_service.dart    # HTTP requests
│   │   ├── screens/
│   │   │   └── home_screen.dart       # UI principal
│   │   └── widgets/                # Componentes UI
│   └── assets/config/config.json   # user_id: single-user
├── 🔧 backend/                     # FastAPI Python
│   ├── fastapi_app/
│   │   └── main.py                 # API endpoints
│   ├── services/
│   │   └── whisper_service.py      # Transcripción + IA
│   ├── utils/
│   │   ├── mqtt_publisher.py       # MQTT topics
│   │   └── n8n_integration.py      # Webhooks
│   ├── requirements.txt           # Dependencies
│   └── Dockerfile                 # Container
├── 📚 01Doc/                      # Documentación técnica
│   ├── documentacion-tecnica-completa.txt
│   ├── git-branch-strategy.md
│   └── modelo-negocio-oficial.pdf
├── 🤖 agent/                      # Laboratorio IA
│   ├── scripts/                   # Testing tools
│   ├── tools/                     # Monitoring
│   └── examples/                  # Prototypes
├── docker-compose.yml             # Orquestación
├── README.md                      # Documentación usuario
└── AGENT_README.md               # Este archivo (para IAs)
```

---

## 🔌 APIs y Endpoints

### FastAPI Backend (localhost:5005)
```http
GET  /ping                         # Health check básico
GET  /status                       # Estado de todos los servicios
POST /upload_audio                 # Upload de audio con metadata
GET  /recordings?user_id=X         # Lista grabaciones usuario
GET  /recording/{record_id}        # Detalles grabación específica
POST /transcribe/{record_id}       # Trigger transcripción manual
```

### Parámetros de /upload_audio
```javascript
FormData {
  audio: File,                     // Archivo AAC/WAV/MP3
  user_id: "single-user",         // ID usuario (fijo v1.0)
  metadata: JSON.stringify({      // Metadata opcional
    duration: 45.2,
    file_size: 1024000,
    app_version: "1.0.0"
  })
}
```

---

## 📡 Estructura MQTT

### Topics por Usuario
```
asistente/{user_id}/transcription  # Texto transcrito
asistente/{user_id}/status         # Estado procesamiento  
asistente/{user_id}/notification   # Notificaciones app
asistente/{user_id}/task           # Tareas detectadas
asistente/{user_id}/emotion        # Análisis emocional
asistente/{user_id}/system         # Mensajes sistema
```

### Ejemplos de Mensajes
```json
// Transcripción completada
{
  "type": "transcription_complete",
  "record_id": "67827...",
  "text": "Tengo que llamar a María mañana por la mañana",
  "confidence": 0.95,
  "timestamp": "2025-01-05T10:30:00Z"
}

// Emoción detectada  
{
  "type": "emotion_detected", 
  "emotion": "happy",
  "confidence": 0.78,
  "keywords": ["bien", "excelente", "perfecto"]
}

// Tarea identificada
{
  "type": "task_created",
  "action_type": "call_contact", 
  "description": "Llamar a María",
  "priority": "medium",
  "suggested_due": "2025-01-06T09:00:00Z"
}
```

---

## 🧠 Análisis IA Implementado

### Whisper Transcripción
```python
# Configuración actual
WHISPER_MODEL = "base"              # tiny/base/small/medium/large
USE_OPENAI_API = False             # Local by default
LANGUAGE = "es"                    # Español
```

### Análisis Emocional
```python
EMOTIONS = {
    "happy": ["bien", "excelente", "genial", "perfecto"],
    "sad": ["mal", "triste", "horrible", "fatal"], 
    "angry": ["enfadado", "molesto", "furioso"],
    "stressed": ["estresado", "agobiado", "presión"],
    "neutral": []  # Default
}
```

### Extracción de Entidades
```python
# Patrones implementados
TASK_PATTERNS = [
    r"tengo que (.*)",
    r"debo (.*)", 
    r"necesito (.*)",
    r"recordar (.*)"]

DATE_PATTERNS = [
    r"mañana",
    r"hoy", 
    r"el \w+ que viene",
    r"\d{1,2} de \w+"]

PEOPLE_PATTERNS = [
    r"llamar a (\w+)",
    r"hablar con (\w+)",
    r"(\w+) me dijo"]
```

---

## 🔄 Flujo de Datos Completo

### 1. Grabación (Flutter)
```dart
// AudioService.dart
await audioRecorder.startRecorder(
  toFile: filePath,
  codec: Codec.aacADTS,  // Formato AAC
  audioSource: AudioSource.microphone
);
```

### 2. Upload (HTTP)
```dart
// UploadService.dart  
final response = await http.post(
  Uri.parse('$baseUrl/upload_audio'),
  headers: {'Content-Type': 'multipart/form-data'},
  body: formData
);
```

### 3. Processing Pipeline (Backend)
```python
# main.py background task
async def process_audio_complete(record_id: str):
    # 1. Transcribir con Whisper
    result = await whisper_service.transcribe_audio(audio_path)
    
    # 2. Análisis emocional + entidades  
    analysis = analyze_content(result['text'])
    
    # 3. Guardar en MongoDB
    await save_to_database(record_id, result, analysis)
    
    # 4. Publicar MQTT
    await mqtt_publisher.publish_transcription(user_id, result)
    
    # 5. Trigger n8n webhook
    await n8n_integration.trigger_workflow(record_id, result)
```

### 4. Real-time Updates (MQTT)
```dart
// MqttService.dart
mqttClient.subscribe('asistente/single-user/+', MqttQos.atMostOnce);
mqttClient.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
  // Process message and update UI
});
```

---

## 🛠️ Herramientas de Testing

### Health Check Completo
```bash
./agent/scripts/health_check.sh
# Verifica Docker, FastAPI, MQTT, MongoDB, n8n
```

### Test Backend API
```bash
python agent/scripts/test_backend.py --full
# Incluye upload de audio de prueba
```

### Monitor MQTT Real-time
```bash
python agent/tools/mqtt_monitor.py -v
# Monitor con output detallado
```

### Comandos Docker Útiles
```bash
# Logs en tiempo real
docker-compose logs -f fastapi_backend

# Restart específico
docker-compose restart emqx

# MongoDB shell
docker exec -it $(docker-compose ps -q mongodb) mongosh

# EMQX dashboard
# http://localhost:18083 (admin/public)
```

---

## 🗄️ Esquema MongoDB

### Collection: audio_recordings
```javascript
{
  _id: ObjectId,
  record_id: "uuid-string",
  user_id: "single-user", 
  audio_file_path: "/app/audios/filename.aac",
  upload_timestamp: ISODate,
  file_size: 1024000,
  duration: 45.2,
  processing_status: "completed",
  
  // Resultado transcripción
  transcription: {
    text: "Texto transcrito aquí",
    confidence: 0.95,
    language: "es",
    model_used: "whisper-base",
    processing_time: 12.5
  },
  
  // Análisis IA
  analysis: {
    emotion: {
      primary: "happy", 
      confidence: 0.78,
      keywords: ["bien", "excelente"]
    },
    entities: {
      tasks: ["llamar a María"],
      dates: ["mañana"],
      people: ["María"]
    },
    category: "personal",
    summary: "Recordatorio personal"
  },
  
  // Metadata
  metadata: {
    app_version: "1.0.0",
    device_info: "...",
    audio_quality: "high"
  }
}
```

---

## 🔧 Variables de Entorno (.env)

```bash
# Whisper Configuration
WHISPER_MODEL=base                 # tiny/base/small/medium/large
USE_OPENAI_API=false              # true para usar OpenAI API
OPENAI_API_KEY=sk-...             # Si usa OpenAI API

# MQTT Configuration  
MQTT_HOST=emqx
MQTT_PORT=1883
MQTT_USERNAME=admin               # Opcional
MQTT_PASSWORD=public              # Opcional

# n8n Configuration
N8N_WEBHOOK_URL=http://n8n:5678/webhook/audio-processed
N8N_TIMEOUT=30                    # Timeout en segundos

# MongoDB Configuration
MONGO_URL=mongodb://mongodb:27017
MONGO_DATABASE=asistente_voz

# General
LOG_LEVEL=INFO                    # DEBUG/INFO/WARNING/ERROR
USER_ID=single-user              # Fixed para v1.0
```

---

## 🚀 Setup Rápido para Agentes

### 1. Clonar y Setup Inicial
```bash
git clone <repo>
cd flutter
cp backend/.env.example backend/.env  # Configurar variables
```

### 2. Levantar Servicios
```bash
docker-compose up -d              # Todos los servicios
./agent/scripts/health_check.sh   # Verificar estado
```

### 3. Setup Flutter App
```bash
cd audio_recorder_app
flutter pub get                   # Dependencias
flutter run                       # Ejecutar en dispositivo/emulador
```

### 4. Testing End-to-End
```bash
# Terminal 1: Monitor MQTT
python agent/tools/mqtt_monitor.py -v

# Terminal 2: Test backend
python agent/scripts/test_backend.py --full

# Terminal 3: App Flutter
# Grabar audio -> Verificar transcripción en monitor
```

---

## 🐛 Troubleshooting Común

### ❌ FastAPI no responde
```bash
docker-compose logs fastapi_backend
# Check logs para errores Whisper/dependencias
```

### ❌ MQTT desconectado  
```bash
docker-compose restart emqx
# Verificar: http://localhost:18083
```

### ❌ Audio no se procesa
```bash
# Verificar permisos en carpeta audios/
ls -la backend/audios/
# Debe tener permisos de escritura
```

### ❌ Flutter no conecta
```bash
# Verificar IP en config.json
cat audio_recorder_app/assets/config/config.json
# Cambiar localhost por IP real si testing en dispositivo
```

---

## 📈 Roadmap v2.0

### 🔄 Próximas Funcionalidades
- [ ] Multiusuario con autenticación
- [ ] Streaming de audio en tiempo real  
- [ ] Análisis emocional avanzado con ML
- [ ] Integración GPT-4 para contexto
- [ ] Dashboard web para administración
- [ ] API REST completa para terceros
- [ ] Workflows n8n pre-configurados
- [ ] Sincronización con Google Calendar/Jira
- [ ] Notificaciones push inteligentes
- [ ] Exportación de datos/reportes

### 🏗️ Mejoras Técnicas Planificadas
- [ ] Kubernetes deployment
- [ ] Redis para caching
- [ ] Elasticsearch para búsquedas
- [ ] Métricas con Prometheus
- [ ] CI/CD con GitHub Actions
- [ ] Tests automatizados completos
- [ ] Documentación API con Swagger
- [ ] Monitoreo con Grafana

---

## 📞 Contacto & Soporte

- **Proyecto**: Asistente Voz Realtime v1.0
- **Mantenedor**: Jose Andres Bardales Calva  
- **Documentación**: `/01Doc` folder
- **Issues**: Usar GitHub Issues
- **Testing**: Use `/agent` tools

---

## 🏷️ Tags para Agentes IA

`#flutter` `#fastapi` `#whisper` `#mqtt` `#mongodb` `#n8n` `#docker` `#voice-assistant` `#real-time` `#microservices` `#ai-analysis` `#mobile-app` `#backend-api` `#automation` `#transcription` `#emotion-analysis` 