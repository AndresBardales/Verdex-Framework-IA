#!/bin/bash

# 🏥 Health Check - Asistente Voz Realtime
# Verifica que todos los servicios estén funcionando correctamente

echo "🔍 Verificando servicios del Asistente Voz Realtime..."

# Verificar Docker Compose
echo "📦 Verificando Docker Compose..."
if docker-compose ps | grep -q "Up"; then
    echo "✅ Docker Compose: Servicios ejecutándose"
else
    echo "❌ Docker Compose: Servicios no están ejecutándose"
    echo "💡 Ejecutar: docker-compose up -d"
fi

# Verificar FastAPI Backend
echo "🚀 Verificando FastAPI Backend..."
if curl -s http://localhost:5005/ping > /dev/null; then
    echo "✅ FastAPI: Respondiendo en puerto 5005"
else
    echo "❌ FastAPI: No responde en puerto 5005"
fi

# Verificar MQTT
echo "📡 Verificando MQTT EMQX..."
if curl -s http://localhost:18083 > /dev/null; then
    echo "✅ EMQX: Dashboard disponible en puerto 18083"
else
    echo "❌ EMQX: Dashboard no disponible"
fi

# Verificar MongoDB
echo "🗄️ Verificando MongoDB..."
if docker exec $(docker-compose ps -q mongodb) mongosh --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    echo "✅ MongoDB: Base de datos respondiendo"
else
    echo "❌ MongoDB: Base de datos no responde"
fi

# Verificar n8n
echo "🔄 Verificando n8n..."
if curl -s http://localhost:5678 > /dev/null; then
    echo "✅ n8n: Disponible en puerto 5678"
else
    echo "❌ n8n: No disponible en puerto 5678"
fi

echo ""
echo "🎯 Resumen de servicios:"
echo "   FastAPI Backend: http://localhost:5005"
echo "   EMQX Dashboard: http://localhost:18083 (admin/public)"
echo "   n8n Interface:  http://localhost:5678"
echo "   MongoDB:        localhost:27017"
echo ""
echo "📱 Para probar la app Flutter:"
echo "   cd audio_recorder_app && flutter run" 