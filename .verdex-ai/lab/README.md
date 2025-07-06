# 🤖 Laboratorio de IA - Asistente Voz Realtime

## 🎯 Propósito
Este directorio contiene herramientas, scripts y entorno de pruebas para agentes de IA (Claude, Gemini CLI, Rovo CLI, etc.) que trabajen en el proyecto.

## 📁 Estructura
```
agent/
├── README.md                 # Este archivo
├── scripts/                  # Scripts de testing y desarrollo
│   ├── test_backend.py       # Pruebas del backend FastAPI
│   ├── test_mqtt.py          # Pruebas de MQTT
│   ├── mock_audio.py         # Genera audios de prueba
│   └── health_check.sh       # Verificación completa del sistema
├── tools/                    # Herramientas para desarrollo
│   ├── log_analyzer.py       # Análisis de logs
│   ├── db_inspector.py       # Inspector de MongoDB
│   └── mqtt_monitor.py       # Monitor en tiempo real de MQTT
└── examples/                 # Ejemplos y prototipos
    ├── whisper_test.py       # Test directo de Whisper
    ├── n8n_webhook_test.py   # Test de webhooks n8n
    └── emotion_analysis.py   # Test análisis emocional
```

## 🚀 Scripts Disponibles

### Testing Rápido
```bash
# Verificar todos los servicios
./agent/scripts/health_check.sh

# Probar backend API
python agent/scripts/test_backend.py

# Monitorear MQTT en tiempo real
python agent/tools/mqtt_monitor.py
```

### Herramientas de Desarrollo
```bash
# Analizar logs del sistema
python agent/tools/log_analyzer.py

# Inspeccionar datos en MongoDB
python agent/tools/db_inspector.py

# Generar audio de prueba
python agent/scripts/mock_audio.py --duration 30 --type "meeting"
```

## 📝 Notas para Agentes IA
- Usar estos scripts para pruebas rápidas antes de cambios
- Los logs se guardan automáticamente para análisis
- Todos los scripts tienen modo verbose (-v) para debugging
- Usar `health_check.sh` como primer paso siempre

## 🔧 Instalación de Dependencias
```bash
pip install -r agent/requirements.txt
``` 