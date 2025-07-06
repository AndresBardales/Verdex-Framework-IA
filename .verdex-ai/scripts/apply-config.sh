#!/bin/bash

# 🔧 Apply User Configuration - Asistente Voz Realtime
# Lee user-config.yaml y aplica toda la configuración al sistema

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔧 Applying User Configuration...${NC}"

# Verificar que existe el archivo de configuración
if [ ! -f "user-config.yaml" ]; then
    echo -e "${RED}❌ Error: user-config.yaml not found${NC}"
    echo -e "${YELLOW}💡 Run this script from the project root directory${NC}"
    exit 1
fi

# Función para extraer valores de YAML (simple parser)
get_yaml_value() {
    local key=$1
    local file=$2
    grep "^[[:space:]]*${key}:" "$file" | sed 's/.*: *//; s/#.*//' | tr -d '"' | xargs
}

echo -e "${CYAN}📖 Reading configuration from user-config.yaml...${NC}"

# Extraer valores de configuración
MAX_DURATION=$(get_yaml_value "max_duration_seconds" user-config.yaml)
AUTO_UPLOAD=$(get_yaml_value "auto_upload" user-config.yaml)
DELETE_AFTER_UPLOAD=$(get_yaml_value "delete_after_upload" user-config.yaml)
CHECK_INTERVAL=$(get_yaml_value "check_interval_seconds" user-config.yaml)
LOCAL_IP=$(get_yaml_value "local_ip" user-config.yaml)
AUTH_PORT=$(get_yaml_value "auth_port" user-config.yaml)
USER_ID=$(get_yaml_value "user_id" user-config.yaml)
SHOW_DEBUG=$(get_yaml_value "show_debug_info" user-config.yaml)

# Auto-detectar IP si no está configurada o es genérica
if [ "$LOCAL_IP" = "192.168.3.3" ] || [ -z "$LOCAL_IP" ]; then
    LOCAL_IP=$(hostname -I | awk '{print $1}')
    echo -e "${YELLOW}🔍 Auto-detected IP: $LOCAL_IP${NC}"
    
    # Actualizar el archivo de configuración con la IP real
    sed -i.bak "s/local_ip: .*/local_ip: \"$LOCAL_IP\"/" user-config.yaml
fi

echo -e "${GREEN}✅ Configuration values:${NC}"
echo -e "   📱 Recording Duration: ${CYAN}${MAX_DURATION} seconds${NC}"
echo -e "   🌐 Local IP: ${CYAN}${LOCAL_IP}${NC}"
echo -e "   👤 User ID: ${CYAN}${USER_ID}${NC}"
echo -e "   🔧 Debug Mode: ${CYAN}${SHOW_DEBUG}${NC}"

# 1. Actualizar configuración de Flutter
echo -e "\n${BLUE}📱 Updating Flutter configuration...${NC}"

cat > audio_recorder_app/assets/config/config.json << EOF
{
  "env": "dev",
  "backend_url": "http://${LOCAL_IP}:5005",
  "auth_url": "http://${LOCAL_IP}:${AUTH_PORT}",
  "n8n_webhook": "http://${LOCAL_IP}:5678/webhook/audio",
  "mqtt_host": "${LOCAL_IP}",
  "mqtt_port": 1883,
  "mqtt_topic": "audios/demo",
  "user_id": "${USER_ID}",
  "check_interval_sec": ${CHECK_INTERVAL},
  "max_recording_duration_sec": ${MAX_DURATION},
  "auto_upload": ${AUTO_UPLOAD},
  "delete_after_upload": ${DELETE_AFTER_UPLOAD},
  "show_debug_info": ${SHOW_DEBUG}
}
EOF

# 2. Actualizar valores por defecto en config_service.dart
echo -e "${BLUE}📝 Updating Flutter default values...${NC}"
sed -i.bak "s|backendUrl: 'http://[^']*|backendUrl: 'http://${LOCAL_IP}:5005|g" audio_recorder_app/lib/services/config_service.dart
sed -i.bak "s|n8nWebhook: 'http://[^']*|n8nWebhook: 'http://${LOCAL_IP}:5678/webhook/audio|g" audio_recorder_app/lib/services/config_service.dart
sed -i.bak "s|mqttHost: '[^']*|mqttHost: '${LOCAL_IP}|g" audio_recorder_app/lib/services/config_service.dart
sed -i.bak "s|userId: '[^']*|userId: '${USER_ID}|g" audio_recorder_app/lib/services/config_service.dart

# 3. Actualizar monitor MQTT con IP correcta
echo -e "${BLUE}📡 Updating MQTT monitor...${NC}"
sed -i.bak "s|MQTT_HOST = .*|MQTT_HOST = \"${LOCAL_IP}\"|" scripts/mqtt-live-monitor.py

# 4. Crear archivo de endpoints para referencia
echo -e "${BLUE}🔗 Creating endpoints reference...${NC}"
cat > endpoints.txt << EOF
# 🌐 Asistente Voz Realtime - Endpoints & URLs

## 📊 Web Dashboards
- Backend API:     http://${LOCAL_IP}:5005
- API Docs:        http://${LOCAL_IP}:5005/docs
- Auth Service:    http://${LOCAL_IP}:${AUTH_PORT}
- Auth API Docs:   http://${LOCAL_IP}:${AUTH_PORT}/docs
- n8n Dashboard:   http://${LOCAL_IP}:5678
- EMQX Dashboard:  http://${LOCAL_IP}:18083 (admin/public)

## 📡 MQTT Topics
- Transcriptions:  audio/transcription/${USER_ID}
- Status Updates:  audio/status/${USER_ID}
- Notifications:   audio/notification/${USER_ID}
- Tasks:           audio/task/${USER_ID}
- Emotions:        audio/emotion/${USER_ID}
- System:          audio/system

## 🔗 Database
- MongoDB:         mongodb://${LOCAL_IP}:27017/audio_productivity

## 🎯 n8n Webhooks
- Main:            http://${LOCAL_IP}:5678/webhook/audio
- Transcription:   http://${LOCAL_IP}:5678/webhook/transcript
- Tasks:           http://${LOCAL_IP}:5678/webhook/task
- Custom:          http://${LOCAL_IP}:5678/webhook-test/26334846-b4be-489f-a5bd-caf10aaf63d6

## 🛠️ Testing Commands
- Health Check:    ./agent/scripts/health_check.sh
- MQTT Monitor:    python3 scripts/mqtt-live-monitor.py
- Test Backend:    python agent/scripts/test_backend.py

Updated: $(date)
EOF

echo -e "\n${GREEN}🎉 Configuration applied successfully!${NC}"
echo -e "\n${CYAN}📋 What was updated:${NC}"
echo -e "   ✅ Flutter app configuration"
echo -e "   ✅ Flutter default fallback values"
echo -e "   ✅ MQTT monitor IP address"
echo -e "   ✅ Endpoints reference file created"
echo -e "\n${YELLOW}📄 Check 'endpoints.txt' for all URLs and connection details${NC}"

# Cleanup backup files
rm -f audio_recorder_app/assets/config/config.json.bak
rm -f audio_recorder_app/lib/services/config_service.dart.bak  
rm -f scripts/mqtt-live-monitor.py.bak

echo -e "\n${BLUE}🚀 Next steps:${NC}"
echo -e "   1. ${CYAN}flutter run${NC} - Test the app with new settings"
echo -e "   2. ${CYAN}python scripts/mqtt-live-monitor.py${NC} - Monitor MQTT messages"
echo -e "   3. Open ${CYAN}http://${LOCAL_IP}:5678${NC} - Configure n8n workflows"
echo "" 