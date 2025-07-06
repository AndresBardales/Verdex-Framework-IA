#!/bin/bash

# 🔄 Auto-Update Flutter Configuration
# Este script actualiza automáticamente la configuración de la app Flutter con las IPs correctas

set -e

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}🔄 Updating Flutter App Configuration...${NC}"

# Obtener IP local
LOCAL_IP=$(hostname -I | awk '{print $1}')
echo -e "${CYAN}📍 Detected Local IP: ${GREEN}$LOCAL_IP${NC}"

# Paths
CONFIG_FILE="audio_recorder_app/assets/config/config.json"
SERVICE_FILE="audio_recorder_app/lib/services/config_service.dart"

# Backup configs
echo -e "${YELLOW}💾 Creating backups...${NC}"
cp "$CONFIG_FILE" "$CONFIG_FILE.backup"
cp "$SERVICE_FILE" "$SERVICE_FILE.backup"

# Actualizar config.json
echo -e "${BLUE}📝 Updating config.json...${NC}"
cat > "$CONFIG_FILE" << EOF
{
  "env": "dev",
  "backend_url": "http://$LOCAL_IP:5005",
  "n8n_webhook": "http://$LOCAL_IP:5678/webhook/audio",
  "mqtt_host": "$LOCAL_IP",
  "mqtt_port": 1883,
  "mqtt_topic": "audios/demo",
  "user_id": "single-user",
  "check_interval_sec": 10,
  "max_recording_duration_sec": 300,
  "auto_upload": true,
  "delete_after_upload": true,
  "show_debug_info": true
}
EOF

# Actualizar config_service.dart (fallback values)
echo -e "${BLUE}📝 Updating config_service.dart defaults...${NC}"
sed -i.tmp "s|backendUrl: 'http://[^']*|backendUrl: 'http://$LOCAL_IP:5005|g" "$SERVICE_FILE"
sed -i.tmp "s|n8nWebhook: 'http://[^']*|n8nWebhook: 'http://$LOCAL_IP:5678/webhook/audio|g" "$SERVICE_FILE"
sed -i.tmp "s|mqttHost: '[^']*|mqttHost: '$LOCAL_IP|g" "$SERVICE_FILE"
rm "$SERVICE_FILE.tmp" 2>/dev/null || true

echo -e "${GREEN}✅ Configuration updated successfully!${NC}"
echo ""
echo -e "${CYAN}📋 Updated endpoints:${NC}"
echo -e "   Backend:  ${GREEN}http://$LOCAL_IP:5005${NC}"
echo -e "   n8n:      ${GREEN}http://$LOCAL_IP:5678${NC}"
echo -e "   MQTT:     ${GREEN}$LOCAL_IP:1883${NC}"
echo ""
echo -e "${YELLOW}🔄 To restore backups if needed:${NC}"
echo -e "   mv $CONFIG_FILE.backup $CONFIG_FILE"
echo -e "   mv $SERVICE_FILE.backup $SERVICE_FILE"
echo "" 