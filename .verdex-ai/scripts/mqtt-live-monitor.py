#!/usr/bin/env python3

"""
🔍 MQTT Live Monitor - Asistente Voz Realtime
Monitorea TODOS los mensajes MQTT en tiempo real
"""

import json
import logging
from datetime import datetime
import paho.mqtt.client as mqtt
import sys
import time

# Configuración
MQTT_HOST = "192.168.3.3"
MQTT_PORT = 1883
TOPICS = [
    "audio/transcription/single-user",
    "audio/status/single-user", 
    "audio/notification/single-user",
    "audio/task/single-user",
    "audio/emotion/single-user",
    "audio/system"
]

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

def get_emoji(topic):
    """Emoji según el tipo de mensaje"""
    if "transcription" in topic:
        return "🎙️"
    elif "status" in topic:
        return "⚡"
    elif "notification" in topic:
        return "📢"
    elif "task" in topic:
        return "✅"
    elif "emotion" in topic:
        return "😊"
    elif "system" in topic:
        return "🔧"
    return "📡"

def format_message(topic, payload):
    """Formatear mensaje para display"""
    timestamp = datetime.now().strftime("%H:%M:%S")
    emoji = get_emoji(topic)
    
    try:
        data = json.loads(payload)
        
        # Formato especial para transcripciones
        if "transcription" in topic:
            text = data.get("text", "")[:100] + "..." if len(data.get("text", "")) > 100 else data.get("text", "")
            confidence = data.get("confidence", 0)
            return f"{Colors.GREEN}{emoji} TRANSCRIPCIÓN [{timestamp}]{Colors.END}\n" \
                   f"   📝 {Colors.CYAN}{text}{Colors.END}\n" \
                   f"   🎯 Confianza: {confidence:.2f}\n"
        
        # Formato especial para tareas
        elif "task" in topic:
            task_title = data.get("task", {}).get("title", "")
            return f"{Colors.YELLOW}{emoji} TAREA CREADA [{timestamp}]{Colors.END}\n" \
                   f"   📋 {Colors.BOLD}{task_title}{Colors.END}\n"
        
        # Formato especial para emociones
        elif "emotion" in topic:
            emotions = data.get("emotions", {})
            primary = max(emotions, key=emotions.get) if emotions else "neutral"
            return f"{Colors.BLUE}{emoji} EMOCIÓN [{timestamp}]{Colors.END}\n" \
                   f"   😊 Principal: {Colors.BOLD}{primary}{Colors.END}\n"
        
        # Formato general para otros mensajes
        else:
            return f"{Colors.CYAN}{emoji} {topic.upper()} [{timestamp}]{Colors.END}\n" \
                   f"   📦 {json.dumps(data, indent=2, ensure_ascii=False)[:200]}...\n"
                   
    except json.JSONDecodeError:
        return f"{Colors.RED}{emoji} {topic} [{timestamp}]{Colors.END}\n" \
               f"   ❌ Mensaje no JSON: {payload}\n"

# Callback functions
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print(f"{Colors.GREEN}✅ Conectado a MQTT broker{Colors.END}")
        # Suscribirse a todos los topics
        for topic in TOPICS:
            client.subscribe(topic)
            emoji = get_emoji(topic)
            print(f"{Colors.GREEN}✅ Suscrito a: {emoji} {topic}{Colors.END}")
        print("=" * 70)
        print(f"{Colors.BOLD}📺 MENSAJES EN VIVO:{Colors.END}\n")
    else:
        print(f"{Colors.RED}❌ Error conectando. Código: {rc}{Colors.END}")

def on_message(client, userdata, msg):
    formatted = format_message(msg.topic, msg.payload.decode())
    print(formatted)

def on_disconnect(client, userdata, rc):
    print(f"\n{Colors.YELLOW}👋 Desconectado del broker MQTT{Colors.END}")

def main():
    print(f"{Colors.HEADER}")
    print("╔════════════════════════════════════════════════════════════════╗")
    print("║                                                                ║")
    print("║         🔍 MQTT LIVE MONITOR - ASISTENTE VOZ REALTIME         ║")
    print("║                                                                ║")
    print("║              Monitoreando mensajes en tiempo real             ║")
    print("║                                                                ║")
    print("╚════════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}")
    
    print(f"{Colors.YELLOW}📡 Conectando a MQTT: {MQTT_HOST}:{MQTT_PORT}{Colors.END}")
    print(f"{Colors.CYAN}📋 Topics a suscribir:{Colors.END}")
    for topic in TOPICS:
        emoji = get_emoji(topic)
        print(f"   {emoji} {topic}")
    
    print(f"\n{Colors.GREEN}🚀 Iniciando monitoreo... (Ctrl+C para salir){Colors.END}")
    print("=" * 70)
    
    # Crear cliente MQTT
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_message = on_message
    client.on_disconnect = on_disconnect
    
    try:
        # Conectar al broker
        client.connect(MQTT_HOST, MQTT_PORT, 60)
        
        # Loop para mantener la conexión
        client.loop_forever()
        
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}👋 Deteniendo monitor...{Colors.END}")
        client.disconnect()
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        client.disconnect()

if __name__ == "__main__":
    # Configurar logging para mostrar solo errores
    logging.getLogger("paho").setLevel(logging.WARNING)
    
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}👋 ¡Hasta luego!{Colors.END}")
    except ImportError:
        print(f"{Colors.RED}❌ Error: Instala las dependencias:{Colors.END}")
        print("sudo apt install python3-paho-mqtt")
        sys.exit(1) 