#!/usr/bin/env python3
"""
🎭 Script para inyectar eventos de prueba al tópico "all"
Para probar el dashboard en tiempo real
"""

import paho.mqtt.client as mqtt
import json
import time
import random
from datetime import datetime

# Configuración MQTT
MQTT_HOST = "localhost"
MQTT_PORT = 1883

def create_test_events():
    """Crear eventos de prueba variados"""
    
    users = [
        "andresbardales15@gmail.com",
        "andresbardaleswork@gmail.com",
        "test@example.com",
        "usuario_demo@gmail.com"
    ]
    
    events = [
        # Eventos de UI
        {
            "topic": "ui/interactions",
            "data": {
                "user_id": random.choice(users),
                "screen": "home_screen",
                "element": "recording_button",
                "action": "tap",
                "session_id": f"session_{random.randint(1000, 9999)}"
            }
        },
        {
            "topic": "ui/interactions",
            "data": {
                "user_id": random.choice(users),
                "screen": "profile_screen",
                "element": "settings_button",
                "action": "tap",
                "session_id": f"session_{random.randint(1000, 9999)}"
            }
        },
        
        # Eventos de Audio
        {
            "topic": "audios/recordings",
            "data": {
                "user_id": random.choice(users),
                "recording_id": f"rec_{random.randint(1000, 9999)}",
                "duration": random.randint(10, 120),
                "quality": random.choice(["high", "medium", "low"]),
                "file_size": random.randint(1024, 8192),
                "format": "aac"
            }
        },
        {
            "topic": "audios/uploads",
            "data": {
                "user_id": random.choice(users),
                "recording_id": f"rec_{random.randint(1000, 9999)}",
                "status": random.choice(["success", "failed", "pending"]),
                "upload_time": random.randint(1, 30),
                "file_url": f"https://storage.example.com/audio_{random.randint(1000, 9999)}.aac"
            }
        },
        
        # Eventos de Sesión
        {
            "topic": "sessions/start",
            "data": {
                "user_id": random.choice(users),
                "session_id": f"session_{random.randint(1000, 9999)}",
                "device_info": {
                    "platform": "android",
                    "model": "M2101K6P",
                    "version": "11"
                },
                "app_info": {
                    "version": "1.0.0",
                    "build": "1"
                }
            }
        },
        {
            "topic": "sessions/end",
            "data": {
                "user_id": random.choice(users),
                "session_id": f"session_{random.randint(1000, 9999)}",
                "duration": random.randint(300, 7200),
                "interactions": random.randint(5, 50),
                "recordings": random.randint(0, 20)
            }
        },
        
        # Eventos de Auth
        {
            "topic": "auth/events",
            "data": {
                "event_type": "login",
                "user_id": random.choice(users),
                "user_email": random.choice(users),
                "timestamp": datetime.now().isoformat(),
                "ip_address": f"192.168.1.{random.randint(1, 255)}",
                "user_agent": "Flutter/Android"
            }
        },
        {
            "topic": "auth/events",
            "data": {
                "event_type": "logout",
                "user_id": random.choice(users),
                "session_duration": random.randint(600, 3600),
                "timestamp": datetime.now().isoformat()
            }
        },
        
        # Eventos de Automatización
        {
            "topic": "automation/alerts",
            "data": {
                "alert_type": "high_activity",
                "user_id": random.choice(users),
                "message": f"Usuario ha realizado {random.randint(20, 50)} grabaciones en la última hora",
                "priority": "medium",
                "timestamp": datetime.now().isoformat()
            }
        },
        {
            "topic": "automation/notifications",
            "data": {
                "notification_type": "reminder",
                "user_id": random.choice(users),
                "message": "Recuerda revisar tus grabaciones pendientes",
                "sent_at": datetime.now().isoformat()
            }
        }
    ]
    
    return events

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("✅ Conectado a MQTT broker")
        print("🎭 Iniciando inyección de eventos de prueba...")
    else:
        print(f"❌ Error conectando: {rc}")

def main():
    print("🚀 Iniciando generador de eventos de prueba...")
    print("🎯 Enviando eventos al tópico 'all'")
    
    client = mqtt.Client()
    client.on_connect = on_connect
    
    try:
        client.connect(MQTT_HOST, MQTT_PORT, 60)
        client.loop_start()
        
        # Esperar conexión
        time.sleep(2)
        
        # Generar eventos por 5 minutos
        start_time = time.time()
        event_count = 0
        
        while time.time() - start_time < 300:  # 5 minutos
            # Elegir evento aleatorio
            events = create_test_events()
            event = random.choice(events)
            
            # Crear mensaje completo
            message = {
                "timestamp": datetime.now().isoformat(),
                "service": "test-generator",
                "topic": event["topic"],
                "data": event["data"]
            }
            
            # Enviar a tópico "all"
            client.publish("all", json.dumps(message))
            
            # Enviar también a tópico específico
            client.publish(event["topic"], json.dumps(message))
            
            event_count += 1
            print(f"📊 Evento {event_count}: {event['topic']} -> {event['data'].get('user_id', 'N/A')}")
            
            # Esperar tiempo aleatorio entre eventos
            time.sleep(random.uniform(2, 8))
        
        print(f"🎉 Generación completada! {event_count} eventos enviados")
        
    except KeyboardInterrupt:
        print("\n⚠️ Interrumpido por usuario")
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        client.loop_stop()
        client.disconnect()
        print("👋 Desconectado del broker MQTT")

if __name__ == "__main__":
    main() 