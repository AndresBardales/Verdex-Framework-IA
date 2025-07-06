#!/bin/bash

# 🌱 Sample Data Initializer for Asistente Voz Realtime
# Este script crea datos de ejemplo para desarrollo

echo "🌱 Initializing sample data for development..."

# Crear datos de ejemplo para MongoDB
cat > dev-data/mongodb/init/sample-recordings.json << 'EOF'
[
  {
    "_id": {"$oid": "507f1f77bcf86cd799439011"},
    "record_id": "demo_recording_001",
    "user_id": "single-user",
    "filename": "demo_meeting_call.aac",
    "duration": 45.2,
    "size": 1024000,
    "transcription": {
      "text": "Hola, necesito programar una reunión para el viernes a las 2 PM con el equipo de marketing. También recordarme comprar los materiales para la presentación.",
      "confidence": 0.95,
      "language": "es",
      "emotions": {
        "happy": 0.7,
        "neutral": 0.2,
        "stressed": 0.1
      },
      "entities": {
        "tasks": ["programar reunión", "comprar materiales"],
        "dates": ["viernes 2 PM"],
        "people": ["equipo de marketing"]
      }
    },
    "automation": {
      "suggested_actions": [
        {
          "type": "calendar_event",
          "description": "Crear evento: Reunión equipo marketing",
          "data": {
            "title": "Reunión equipo marketing",
            "date": "2024-01-19T14:00:00Z",
            "duration": 60
          }
        },
        {
          "type": "task",
          "description": "Crear tarea: Comprar materiales presentación",
          "data": {
            "title": "Comprar materiales presentación",
            "priority": "medium"
          }
        }
      ],
      "n8n_triggered": true,
      "webhook_response": "success"
    },
    "created_at": {"$date": "2024-01-15T10:30:00Z"},
    "updated_at": {"$date": "2024-01-15T10:32:00Z"},
    "metadata": {
      "sample_data": true,
      "environment": "development"
    }
  },
  {
    "_id": {"$oid": "507f1f77bcf86cd799439012"},
    "record_id": "demo_recording_002",
    "user_id": "single-user",
    "filename": "demo_voice_note.aac",
    "duration": 23.8,
    "size": 512000,
    "transcription": {
      "text": "Recordatorio: llamar al doctor Martinez mañana a las 10 AM para confirmar la cita. Muy importante no olvidar llevar los análisis de sangre.",
      "confidence": 0.92,
      "language": "es",
      "emotions": {
        "neutral": 0.6,
        "stressed": 0.3,
        "happy": 0.1
      },
      "entities": {
        "tasks": ["llamar al doctor", "llevar análisis"],
        "dates": ["mañana 10 AM"],
        "people": ["doctor Martinez"]
      }
    },
    "automation": {
      "suggested_actions": [
        {
          "type": "reminder",
          "description": "Recordatorio: Llamar Dr. Martinez",
          "data": {
            "title": "Llamar Dr. Martinez",
            "time": "2024-01-16T10:00:00Z",
            "notes": "Llevar análisis de sangre"
          }
        }
      ],
      "n8n_triggered": true,
      "webhook_response": "success"
    },
    "created_at": {"$date": "2024-01-15T16:45:00Z"},
    "updated_at": {"$date": "2024-01-15T16:47:00Z"},
    "metadata": {
      "sample_data": true,
      "environment": "development"
    }
  }
]
EOF

# Crear workflow de ejemplo para n8n
cat > dev-data/n8n/workflows/audio-processing-workflow.json << 'EOF'
{
  "name": "Audio Processing Workflow",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "audio",
        "responseMode": "responseNode",
        "options": {}
      },
      "id": "webhook-node",
      "name": "Audio Webhook",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [
        240,
        300
      ]
    },
    {
      "parameters": {
        "respondWith": "json",
        "responseBody": {
          "status": "success",
          "message": "Audio processed successfully",
          "webhook_received": "={{$now}}"
        }
      },
      "id": "response-node",
      "name": "Webhook Response",
      "type": "n8n-nodes-base.respondToWebhook",
      "typeVersion": 1,
      "position": [
        880,
        300
      ]
    },
    {
      "parameters": {
        "functionCode": "// Procesar datos de audio transcrito\nconst audioData = items[0].json;\n\n// Extraer información relevante\nconst transcription = audioData.transcription;\nconst emotions = transcription.emotions;\nconst entities = transcription.entities;\n\n// Crear acciones sugeridas basadas en el contenido\nconst actions = [];\n\n// Si hay tareas mencionadas\nif (entities.tasks && entities.tasks.length > 0) {\n  entities.tasks.forEach(task => {\n    actions.push({\n      type: 'task',\n      description: `Crear tarea: ${task}`,\n      priority: emotions.stressed > 0.5 ? 'high' : 'medium'\n    });\n  });\n}\n\n// Si hay fechas/citas\nif (entities.dates && entities.dates.length > 0) {\n  entities.dates.forEach(date => {\n    actions.push({\n      type: 'calendar',\n      description: `Programar: ${date}`,\n      urgency: emotions.stressed > 0.5 ? 'urgent' : 'normal'\n    });\n  });\n}\n\n// Si hay personas mencionadas\nif (entities.people && entities.people.length > 0) {\n  actions.push({\n    type: 'contact',\n    description: `Contactar: ${entities.people.join(', ')}`,\n    emotion_context: emotions.happy > 0.5 ? 'positive' : 'neutral'\n  });\n}\n\nreturn [{\n  json: {\n    ...audioData,\n    processed_actions: actions,\n    processing_timestamp: new Date().toISOString(),\n    emotion_summary: {\n      primary_emotion: Object.keys(emotions).reduce((a, b) => emotions[a] > emotions[b] ? a : b),\n      stress_level: emotions.stressed || 0,\n      happiness_level: emotions.happy || 0\n    }\n  }\n}];"
      },
      "id": "process-audio-node",
      "name": "Process Audio Data",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [
        460,
        300
      ]
    },
    {
      "parameters": {
        "functionCode": "// Simular integración con calendario/tareas\nconst processedData = items[0].json;\nconst actions = processedData.processed_actions;\n\n// Log de acciones que se ejecutarían\nconsole.log('=== AUTOMATION ACTIONS ===');\nconsole.log(`Transcription: ${processedData.transcription.text}`);\nconsole.log(`Primary Emotion: ${processedData.emotion_summary.primary_emotion}`);\nconsole.log('Suggested Actions:');\n\nactions.forEach((action, index) => {\n  console.log(`${index + 1}. [${action.type.toUpperCase()}] ${action.description}`);\n});\n\n// En un entorno real, aquí se harían llamadas a APIs reales\n// Google Calendar, Todoist, Slack, etc.\n\nreturn [{\n  json: {\n    automation_completed: true,\n    actions_executed: actions.length,\n    timestamp: new Date().toISOString(),\n    original_data: processedData\n  }\n}];"
      },
      "id": "automation-node",
      "name": "Execute Automations",
      "type": "n8n-nodes-base.function",
      "typeVersion": 1,
      "position": [
        680,
        300
      ]
    }
  ],
  "connections": {
    "Audio Webhook": {
      "main": [
        [
          {
            "node": "Process Audio Data",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Process Audio Data": {
      "main": [
        [
          {
            "node": "Execute Automations",
            "type": "main",
            "index": 0
          }
        ]
      ]
    },
    "Execute Automations": {
      "main": [
        [
          {
            "node": "Webhook Response",
            "type": "main",
            "index": 0
          }
        ]
      ]
    }
  },
  "active": true,
  "settings": {},
  "versionId": "demo-v1.0"
}
EOF

# Crear configuración de ejemplo para EMQX
cat > dev-data/emqx/demo-topics.txt << 'EOF'
# 📡 MQTT Topics for Voice Assistant Development

## Main Topics:
- audio/transcription/single-user    # Transcription results
- audio/status/single-user          # Processing status updates  
- audio/notification/single-user    # User notifications
- audio/task/single-user           # Task creation events
- audio/emotion/single-user        # Emotion analysis results
- audio/system                     # System-wide messages

## Topic Structure:
audio/{message_type}/{user_id}

## Example Messages:

### Transcription Complete:
Topic: audio/transcription/single-user
{
  "type": "transcription",
  "user_id": "single-user", 
  "record_id": "audio_12345",
  "text": "Recordar comprar leche mañana",
  "confidence": 0.95,
  "emotions": {"happy": 0.7, "neutral": 0.3},
  "entities": {"tasks": ["comprar leche"], "dates": ["mañana"]}
}

### Task Created:
Topic: audio/task/single-user
{
  "type": "task",
  "user_id": "single-user",
  "record_id": "audio_12345", 
  "task": {
    "title": "Comprar leche",
    "due_date": "2024-01-16",
    "priority": "medium"
  }
}
EOF

# Crear datos de demostración para el backend
cat > dev-data/sample-audio-metadata.json << 'EOF'
{
  "demo_files": [
    {
      "filename": "demo_meeting_call.aac",
      "description": "Reunión de trabajo con tareas y fechas",
      "expected_entities": ["reunión", "viernes", "marketing"],
      "expected_emotions": ["happy", "neutral"],
      "use_case": "Meeting planning and task creation"
    },
    {
      "filename": "demo_voice_note.aac", 
      "description": "Nota de voz con recordatorio médico",
      "expected_entities": ["doctor", "mañana", "análisis"],
      "expected_emotions": ["neutral", "stressed"],
      "use_case": "Medical appointment reminder"
    }
  ],
  "testing_scenarios": [
    {
      "scenario": "Task Creation",
      "test_phrase": "Recordarme comprar pan mañana por la mañana",
      "expected_outcome": "Should create a task 'Comprar pan' for tomorrow"
    },
    {
      "scenario": "Meeting Scheduling",
      "test_phrase": "Programar reunión con Juan el viernes a las 3 PM",
      "expected_outcome": "Should create calendar event for Friday 3 PM with Juan"
    },
    {
      "scenario": "Emotional Context",
      "test_phrase": "Estoy muy estresado, necesito terminar el proyecto urgente",
      "expected_outcome": "Should detect stress and mark task as high priority"
    }
  ]
}
EOF

# Crear README para desarrolladores
cat > dev-data/README.md << 'EOF'
# 🧪 Development Sample Data

Este directorio contiene datos de ejemplo para facilitar el desarrollo y testing del Asistente Voz Realtime.

## 📂 Estructura

```
dev-data/
├── mongodb/init/          # Datos iniciales para MongoDB
├── n8n/workflows/         # Workflows de ejemplo para n8n  
├── emqx/                  # Configuración y topics de EMQX
└── sample-audio-metadata.json  # Metadatos de archivos de prueba
```

## 🔧 Uso

Los datos se inicializan automáticamente cuando ejecutas `./start-dev.sh` por primera vez.

### MongoDB
- Registros de audio de ejemplo con transcripciones
- Análisis emocional y extracción de entidades
- Acciones sugeridas y respuestas de automatización

### n8n
- Workflow completo de procesamiento de audio
- Integración con webhooks
- Lógica de automatización basada en contenido

### EMQX
- Topics predefinidos para MQTT
- Ejemplos de mensajes
- Estructura de comunicación en tiempo real

## 🚀 Escenarios de Prueba

1. **Creación de Tareas**: Frases que deben generar tareas automáticamente
2. **Programación de Reuniones**: Detección de fechas y creación de eventos  
3. **Análisis Emocional**: Respuesta basada en el estado emocional detectado

## 🔄 Reiniciar Datos

Para reinicializar los datos de ejemplo:

```bash
rm dev-data/.initialized
./start-dev.sh
```

Los volúmenes persistentes mantienen los datos entre reinicios del sistema.
EOF

echo "✅ Sample data created successfully!"
echo "   - MongoDB sample recordings"
echo "   - n8n automation workflow"
echo "   - EMQX topic structure"
echo "   - Development documentation" 