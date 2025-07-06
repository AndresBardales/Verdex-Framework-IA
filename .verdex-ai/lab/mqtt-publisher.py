#!/usr/bin/env python3

"""
🧪 MQTT Interactive Publisher - Testing Tool
Herramienta para publicar mensajes de prueba a todos los topics MQTT
"""

import json
import time
from datetime import datetime, timedelta
import paho.mqtt.client as mqtt
import uuid
import sys

# Configuración
MQTT_HOST = "192.168.3.3"
MQTT_PORT = 1883

# Colores para output
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'
    MAGENTA = '\033[35m'

def generate_audio_id():
    """Generar un ID único para audio"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    unique_id = str(uuid.uuid4())[:8]
    return f"{timestamp}_{unique_id}"

def generate_task_id():
    """Generar un ID único para tareas"""
    return f"task_{uuid.uuid4().hex[:8]}"

def get_timestamp():
    """Obtener timestamp ISO"""
    return datetime.now().isoformat() + "Z"

# Templates de mensajes predefinidos
MESSAGE_TEMPLATES = {
    "transcription": {
        "audio_id": generate_audio_id(),
        "text": "Recuérdame llamar a Juan Pérez mañana por la mañana para hablar sobre el proyecto",
        "confidence": 0.92,
        "language": "es",
        "duration": 60.5,
        "timestamp": get_timestamp(),
        "source": "whisper-backend",
        "user_id": "single-user"
    },
    
    "status": {
        "audio_id": generate_audio_id(),
        "status": "transcribing",
        "progress": 75,
        "message": "Procesando audio con Whisper...",
        "timestamp": get_timestamp(),
        "estimated_completion": (datetime.now() + timedelta(seconds=30)).isoformat() + "Z"
    },
    
    "notification": {
        "type": "task_created",
        "title": "Nueva tarea creada",
        "message": "Se ha creado la tarea: Llamar al cliente Juan Pérez",
        "priority": "high",
        "action_url": "/tasks/12345",
        "timestamp": get_timestamp(),
        "metadata": {
            "task_id": generate_task_id(),
            "source": "voice_command"
        }
    },
    
    "task": {
        "task": {
            "id": generate_task_id(),
            "title": "Llamar al cliente Juan Pérez",
            "description": "Seguimiento de propuesta comercial para el proyecto Q1",
            "priority": "high",
            "due_date": (datetime.now() + timedelta(days=1)).isoformat() + "Z",
            "category": "ventas",
            "estimated_duration": 30,
            "created_from_audio": generate_audio_id()
        },
        "trigger": {
            "voice_command": "Recuérdame llamar a Juan Pérez mañana",
            "confidence": 0.92,
            "extracted_entities": {
                "person": "Juan Pérez",
                "action": "llamar",
                "when": "mañana"
            }
        },
        "timestamp": get_timestamp()
    },
    
    "emotion": {
        "audio_id": generate_audio_id(),
        "emotions": {
            "alegria": 0.75,
            "confianza": 0.60,
            "estres": 0.25,
            "neutral": 0.10
        },
        "primary_emotion": "alegria",
        "energy_level": "alto",
        "speech_rate": "normal",
        "confidence": 0.83,
        "analysis_model": "emotion-ai-v2",
        "timestamp": get_timestamp()
    },
    
    "flutter": {
        "action": "recording_started",
        "audio_id": generate_audio_id(),
        "duration_planned": 60,
        "quality": "high",
        "device_info": {
            "model": "M2101K6P",
            "os": "Android 12",
            "app_version": "1.0.0"
        },
        "timestamp": get_timestamp()
    },
    
    "system": {
        "type": "service_health",
        "services": {
            "whisper_service": "healthy",
            "mqtt_broker": "healthy",
            "mongodb": "healthy",
            "n8n": "healthy"
        },
        "total_uptime": 3600,
        "timestamp": get_timestamp()
    }
}

def print_menu():
    """Mostrar menú principal"""
    print(f"\n{Colors.HEADER}╔══════════════════════════════════════════════════════════════════════════╗")
    print("║                                                                          ║")
    print("║               🧪 MQTT PUBLISHER - TESTING TOOL                          ║")
    print("║                                                                          ║")
    print("╚══════════════════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}")
    
    print(f"{Colors.CYAN}📡 Selecciona el tipo de mensaje a enviar:{Colors.END}\n")
    
    topics = [
        ("1", "🎙️  TRANSCRIPCIÓN", "audio/transcription/single-user", "Resultado de Whisper"),
        ("2", "⚡  STATUS", "audio/status/single-user", "Estado de procesamiento"),
        ("3", "📢  NOTIFICACIÓN", "audio/notification/single-user", "Push notification"),
        ("4", "✅  TAREA", "audio/task/single-user", "Tarea creada por IA"),
        ("5", "😊  EMOCIÓN", "audio/emotion/single-user", "Análisis emocional"),
        ("6", "📱  FLUTTER", "audio/flutter/single-user", "Mensaje desde app"),
        ("7", "🔧  SISTEMA", "audio/system", "Estado del sistema"),
        ("8", "🧪  TEST CUSTOM", "audio/test/custom", "Mensaje personalizado"),
        ("9", "🚀  SECUENCIA COMPLETA", "", "Enviar flujo completo"),
        ("0", "❌  SALIR", "", "")
    ]
    
    for num, emoji, topic, desc in topics:
        if topic:
            print(f"   {Colors.BOLD}{num}{Colors.END} - {emoji} {Colors.CYAN}{desc}{Colors.END}")
            print(f"       📡 Topic: {Colors.YELLOW}{topic}{Colors.END}")
        else:
            print(f"   {Colors.BOLD}{num}{Colors.END} - {emoji} {Colors.CYAN}{desc}{Colors.END}")
        print()

def publish_message(client, topic, message):
    """Publicar mensaje a MQTT"""
    try:
        json_str = json.dumps(message, indent=2, ensure_ascii=False)
        result = client.publish(topic, json_str)
        
        if result.rc == 0:
            print(f"{Colors.GREEN}✅ Mensaje enviado exitosamente{Colors.END}")
            print(f"📡 Topic: {Colors.BOLD}{topic}{Colors.END}")
            print(f"📦 Mensaje:")
            print(f"{Colors.CYAN}{json_str[:300]}{'...' if len(json_str) > 300 else ''}{Colors.END}")
        else:
            print(f"{Colors.RED}❌ Error enviando mensaje. Código: {result.rc}{Colors.END}")
            
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")

def send_complete_sequence(client):
    """Enviar una secuencia completa de prueba"""
    print(f"\n{Colors.YELLOW}🚀 Enviando secuencia completa de prueba...{Colors.END}\n")
    
    audio_id = generate_audio_id()
    
    # 1. Estado: Recibido
    status_msg = MESSAGE_TEMPLATES["status"].copy()
    status_msg["audio_id"] = audio_id
    status_msg["status"] = "received"
    status_msg["message"] = "Audio recibido, iniciando procesamiento"
    status_msg["progress"] = 10
    print(f"{Colors.CYAN}1. 📥 Enviando estado: Audio recibido{Colors.END}")
    publish_message(client, "audio/status/single-user", status_msg)
    time.sleep(2)
    
    # 2. Estado: Transcribiendo
    status_msg["status"] = "transcribing"
    status_msg["message"] = "Procesando con Whisper..."
    status_msg["progress"] = 50
    print(f"\n{Colors.CYAN}2. 🎙️  Enviando estado: Transcribiendo{Colors.END}")
    publish_message(client, "audio/status/single-user", status_msg)
    time.sleep(2)
    
    # 3. Transcripción completa
    transcription_msg = MESSAGE_TEMPLATES["transcription"].copy()
    transcription_msg["audio_id"] = audio_id
    print(f"\n{Colors.CYAN}3. 📝 Enviando transcripción{Colors.END}")
    publish_message(client, "audio/transcription/single-user", transcription_msg)
    time.sleep(2)
    
    # 4. Análisis emocional
    emotion_msg = MESSAGE_TEMPLATES["emotion"].copy()
    emotion_msg["audio_id"] = audio_id
    print(f"\n{Colors.CYAN}4. 😊 Enviando análisis emocional{Colors.END}")
    publish_message(client, "audio/emotion/single-user", emotion_msg)
    time.sleep(2)
    
    # 5. Tarea creada
    task_msg = MESSAGE_TEMPLATES["task"].copy()
    task_msg["task"]["created_from_audio"] = audio_id
    print(f"\n{Colors.CYAN}5. ✅ Enviando tarea creada{Colors.END}")
    publish_message(client, "audio/task/single-user", task_msg)
    time.sleep(2)
    
    # 6. Notificación
    notification_msg = MESSAGE_TEMPLATES["notification"].copy()
    notification_msg["metadata"]["audio_id"] = audio_id
    print(f"\n{Colors.CYAN}6. 📢 Enviando notificación{Colors.END}")
    publish_message(client, "audio/notification/single-user", notification_msg)
    time.sleep(2)
    
    # 7. Estado final
    status_msg["status"] = "completed"
    status_msg["message"] = "Procesamiento completado exitosamente"
    status_msg["progress"] = 100
    print(f"\n{Colors.CYAN}7. ✅ Enviando estado: Completado{Colors.END}")
    publish_message(client, "audio/status/single-user", status_msg)
    
    print(f"\n{Colors.GREEN}🎉 ¡Secuencia completa enviada! Revisa el monitor universal para ver todos los mensajes.{Colors.END}")

def get_custom_message():
    """Crear mensaje personalizado"""
    print(f"\n{Colors.YELLOW}🧪 Creando mensaje personalizado{Colors.END}")
    
    topic = input(f"{Colors.CYAN}📡 Topic (ej: audio/test/mi-prueba): {Colors.END}")
    if not topic.startswith("audio/"):
        topic = f"audio/test/{topic}"
    
    print(f"\n{Colors.CYAN}📝 Tipo de mensaje:{Colors.END}")
    print("1 - JSON simple con texto")
    print("2 - Usar template existente")
    print("3 - JSON personalizado")
    
    choice = input(f"\n{Colors.CYAN}Selección: {Colors.END}")
    
    if choice == "1":
        text = input(f"{Colors.CYAN}💬 Mensaje: {Colors.END}")
        message = {
            "text": text,
            "timestamp": get_timestamp(),
            "source": "test-tool"
        }
    elif choice == "2":
        print(f"\n{Colors.CYAN}Selecciona template:{Colors.END}")
        for i, key in enumerate(MESSAGE_TEMPLATES.keys(), 1):
            print(f"{i} - {key}")
        
        template_choice = input(f"\n{Colors.CYAN}Template: {Colors.END}")
        try:
            template_key = list(MESSAGE_TEMPLATES.keys())[int(template_choice) - 1]
            message = MESSAGE_TEMPLATES[template_key].copy()
        except:
            message = {"error": "Template inválido"}
    else:
        print(f"{Colors.CYAN}📝 Introduce JSON (una línea):{Colors.END}")
        json_input = input()
        try:
            message = json.loads(json_input)
        except:
            message = {"error": "JSON inválido", "input": json_input}
    
    return topic, message

def main():
    """Función principal"""
    print(f"{Colors.GREEN}📡 Conectando a MQTT: {MQTT_HOST}:{MQTT_PORT}{Colors.END}")
    
    # Crear cliente MQTT
    client = mqtt.Client()
    
    try:
        client.connect(MQTT_HOST, MQTT_PORT, 60)
        print(f"{Colors.GREEN}✅ Conectado exitosamente{Colors.END}")
        
        while True:
            print_menu()
            choice = input(f"{Colors.BOLD}Selección: {Colors.END}")
            
            if choice == "0":
                print(f"{Colors.YELLOW}👋 ¡Hasta luego!{Colors.END}")
                break
            elif choice == "1":
                publish_message(client, "audio/transcription/single-user", MESSAGE_TEMPLATES["transcription"])
            elif choice == "2":
                publish_message(client, "audio/status/single-user", MESSAGE_TEMPLATES["status"])
            elif choice == "3":
                publish_message(client, "audio/notification/single-user", MESSAGE_TEMPLATES["notification"])
            elif choice == "4":
                publish_message(client, "audio/task/single-user", MESSAGE_TEMPLATES["task"])
            elif choice == "5":
                publish_message(client, "audio/emotion/single-user", MESSAGE_TEMPLATES["emotion"])
            elif choice == "6":
                publish_message(client, "audio/flutter/single-user", MESSAGE_TEMPLATES["flutter"])
            elif choice == "7":
                publish_message(client, "audio/system", MESSAGE_TEMPLATES["system"])
            elif choice == "8":
                topic, message = get_custom_message()
                publish_message(client, topic, message)
            elif choice == "9":
                send_complete_sequence(client)
            else:
                print(f"{Colors.RED}❌ Opción inválida{Colors.END}")
            
            input(f"\n{Colors.CYAN}Presiona Enter para continuar...{Colors.END}")
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error conectando: {e}{Colors.END}")
    finally:
        client.disconnect()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}👋 Interrumpido por usuario{Colors.END}")
    except ImportError:
        print(f"{Colors.RED}❌ Error: Instala paho-mqtt:{Colors.END}")
        print("sudo apt install python3-paho-mqtt")
        sys.exit(1) 