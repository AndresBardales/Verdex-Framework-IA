#!/bin/bash

echo "🚀 Iniciando Sistema Completo de Analytics y Logging"
echo "==============================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Verificar que Docker esté corriendo
print_header "Verificando Docker..."
if ! docker info > /dev/null 2>&1; then
    print_error "Docker no está corriendo. Por favor inicia Docker primero."
    exit 1
fi
print_status "Docker está corriendo ✅"

# Verificar que los servicios base estén corriendo
print_header "Verificando servicios base..."
cd audio_recorder_app && cd ..

if ! docker compose ps | grep -q "audio-emqx.*Up"; then
    print_warning "EMQX no está corriendo. Iniciando servicios base..."
    docker compose up -d emqx mongo n8n
    sleep 10
fi

if ! docker compose ps | grep -q "audio-auth.*Up"; then
    print_warning "Auth service no está corriendo. Iniciando..."
    docker compose up -d auth-service
    sleep 5
fi

print_status "Servicios base verificados ✅"

# Crear directorios necesarios
print_header "Creando directorios..."
mkdir -p analytics_dashboard/templates
mkdir -p automation_engine
mkdir -p logs
print_status "Directorios creados ✅"

# Instalar dependencias Python para analytics (si no existen)
if [ ! -d "analytics_dashboard/venv" ]; then
    print_header "Configurando entorno Python para Analytics Dashboard..."
    cd analytics_dashboard
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    cd ..
    print_status "Entorno Python configurado ✅"
fi

# Función para ejecutar en background con logs
run_background() {
    local name=$1
    local command=$2
    local logfile=$3
    
    print_status "Iniciando $name en background..."
    nohup $command > $logfile 2>&1 &
    local pid=$!
    echo $pid > "${name}.pid"
    print_status "$name iniciado (PID: $pid) - Logs: $logfile"
}

# Limpiar procesos anteriores
print_header "Limpiando procesos anteriores..."
for pidfile in *.pid; do
    if [ -f "$pidfile" ]; then
        pid=$(cat "$pidfile")
        if ps -p $pid > /dev/null; then
            print_warning "Deteniendo proceso $pid"
            kill $pid 2>/dev/null || true
        fi
        rm "$pidfile"
    fi
done

# Esperar un poco para que terminen
sleep 2

# Iniciar Analytics Dashboard
print_header "Iniciando Analytics Dashboard..."
cd analytics_dashboard
source venv/bin/activate
run_background "analytics_dashboard" "python dashboard.py" "../logs/analytics_dashboard.log"
cd ..

# Iniciar Automation Engine
print_header "Iniciando Automation Engine..."
run_background "automation_engine" "python automation_engine/automation_rules.py" "logs/automation_engine.log"

# Iniciar monitoreo MQTT
print_header "Iniciando monitor MQTT..."
run_background "mqtt_monitor" "mosquitto_sub -h 192.168.3.3 -p 1883 -t '#' -v" "logs/mqtt_monitor.log"

# Esperar que se inicien los servicios
sleep 5

# Mostrar status
print_header "Estado del Sistema"
echo "=================="

# URLs importantes
echo -e "${BLUE}📊 Analytics Dashboard:${NC} http://localhost:5001"
echo -e "${BLUE}🔐 Auth Service:${NC} http://localhost:8001"
echo -e "${BLUE}🌐 n8n:${NC} http://localhost:5678"
echo -e "${BLUE}📡 EMQX Dashboard:${NC} http://localhost:18083 (admin/public)"

echo ""
echo -e "${BLUE}📁 Archivos de logs:${NC}"
echo "  • Analytics Dashboard: logs/analytics_dashboard.log"
echo "  • Automation Engine: logs/automation_engine.log"
echo "  • MQTT Monitor: logs/mqtt_monitor.log"
echo "  • MQTT Logs estructurados: logs/YYYY-MM-DD/"

echo ""
echo -e "${BLUE}🎯 Tópicos MQTT para monitorear:${NC}"
echo "  • auth/events - Eventos de autenticación"
echo "  • ui/interactions - Interacciones de UI"
echo "  • audios/recordings - Grabaciones de audio"
echo "  • automation/alerts - Alertas automáticas"
echo "  • automation/notifications - Notificaciones"

echo ""
echo -e "${BLUE}📱 Para compilar la app Flutter:${NC}"
echo "  cd audio_recorder_app"
echo "  flutter pub get"
echo "  flutter run -d <device_id>"

echo ""
echo -e "${BLUE}🔧 Comandos útiles:${NC}"
echo "  • Ver logs en tiempo real: tail -f logs/analytics_dashboard.log"
echo "  • Monitorear MQTT: mosquitto_sub -h 192.168.3.3 -p 1883 -t 'auth/events' -v"
echo "  • Probar webhook: curl -X POST http://localhost:8001/test-webhook"
echo "  • Ver estadísticas: curl -s http://localhost:5001/api/stats | jq ."

echo ""
print_status "🎉 Sistema completo iniciado exitosamente!"
print_warning "Presiona Ctrl+C para detener todos los servicios"

# Función para cleanup al salir
cleanup() {
    print_header "Deteniendo servicios..."
    
    for pidfile in *.pid; do
        if [ -f "$pidfile" ]; then
            pid=$(cat "$pidfile")
            if ps -p $pid > /dev/null; then
                print_status "Deteniendo $pidfile (PID: $pid)"
                kill $pid 2>/dev/null || true
            fi
            rm "$pidfile"
        fi
    done
    
    print_status "Sistema detenido. ¡Hasta luego! 👋"
    exit 0
}

# Trap para cleanup
trap cleanup SIGINT SIGTERM

# Mostrar logs en tiempo real (opcional)
echo ""
read -p "¿Quieres ver los logs del Analytics Dashboard en tiempo real? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    tail -f logs/analytics_dashboard.log
else
    echo ""
    print_status "Servicios ejecutándose en background."
    print_status "Usa 'tail -f logs/analytics_dashboard.log' para ver logs."
    
    # Mantener el script corriendo
    while true; do
        sleep 10
        # Verificar que los procesos sigan corriendo
        for pidfile in *.pid; do
            if [ -f "$pidfile" ]; then
                pid=$(cat "$pidfile")
                if ! ps -p $pid > /dev/null; then
                    print_error "Proceso $pidfile se ha detenido inesperadamente"
                fi
            fi
        done
    done
fi 