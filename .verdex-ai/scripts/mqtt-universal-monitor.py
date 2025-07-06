#!/usr/bin/env python3

"""
🌐 MQTT Universal Monitor - Asistente Voz Realtime
Monitorea TODOS los mensajes MQTT con wildcard audio/*
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
WILDCARD_TOPIC = "audio/#"  # Escucha TODOS los topics que empiecen con "audio/"

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

def get_topic_info(topic):
    """Analizar y clasificar topic"""
    parts = topic.split('/')
    
    if len(parts) >= 2:
        category = parts[1]  # transcription, status, etc.
        user_id = parts[2] if len(parts) > 2 else "unknown"
        
        topic_map = {
            "transcription": {"emoji": "🎙️", "color": Colors.GREEN, "name": "TRANSCRIPCIÓN"},
            "status": {"emoji": "⚡", "color": Colors.BLUE, "name": "STATUS"},
            "notification": {"emoji": "📢", "color": Colors.YELLOW, "name": "NOTIFICACIÓN"},
            "task": {"emoji": "✅", "color": Colors.CYAN, "name": "TAREA"},
            "emotion": {"emoji": "😊", "color": Colors.MAGENTA, "name": "EMOCIÓN"},
            "system": {"emoji": "🔧", "color": Colors.RED, "name": "SISTEMA"},
            "flutter": {"emoji": "📱", "color": Colors.BLUE, "name": "FLUTTER APP"},
            "test": {"emoji": "🧪", "color": Colors.YELLOW, "name": "TEST"},
        }
        
        info = topic_map.get(category, {"emoji": "📡", "color": Colors.CYAN, "name": "UNKNOWN"})
        info["user_id"] = user_id
        info["category"] = category
        return info
    
    return {"emoji": "❓", "color": Colors.RED, "name": "INVALID", "user_id": "unknown", "category": "unknown"}

def format_message(topic, payload):
    """Formatear mensaje para display con análisis automático"""
    timestamp = datetime.now().strftime("%H:%M:%S")
    topic_info = get_topic_info(topic)
    
    header = f"{topic_info['color']}{topic_info['emoji']} {topic_info['name']} [{timestamp}]{Colors.END}"
    header += f" {Colors.BOLD}({topic}){Colors.END}"
    
    try:
        data = json.loads(payload)
        
        # Formateo específico por tipo de mensaje
        if topic_info['category'] == "transcription":
            text = data.get("text", "")
            confidence = data.get("confidence", 0)
            language = data.get("language", "unknown")
            return f"{header}\n" \
                   f"   📝 {Colors.CYAN}{text[:150]}{'...' if len(text) > 150 else ''}{Colors.END}\n" \
                   f"   🎯 Confianza: {confidence:.2f} | 🌍 Idioma: {language}\n"
        
        elif topic_info['category'] == "task":
            if "task" in data:
                task_info = data["task"]
                title = task_info.get("title", "Sin título")
                priority = task_info.get("priority", "normal")
                return f"{header}\n" \
                       f"   📋 {Colors.BOLD}{title}{Colors.END}\n" \
                       f"   🔥 Prioridad: {priority}\n"
        
        elif topic_info['category'] == "emotion":
            emotions = data.get("emotions", {})
            if emotions:
                primary = max(emotions, key=emotions.get)
                score = emotions[primary]
                return f"{header}\n" \
                       f"   😊 Emoción principal: {Colors.BOLD}{primary}{Colors.END} ({score:.2f})\n" \
                       f"   📊 Todas: {emotions}\n"
        
        elif topic_info['category'] == "notification":
            message = data.get("message", "")
            notification_type = data.get("type", "info")
            return f"{header}\n" \
                   f"   📢 {Colors.BOLD}{message}{Colors.END}\n" \
                   f"   🏷️  Tipo: {notification_type}\n"
        
        elif topic_info['category'] == "status":
            status = data.get("status", "unknown")
            audio_id = data.get("audio_id", "N/A")
            return f"{header}\n" \
                   f"   ⚡ Estado: {Colors.BOLD}{status}{Colors.END}\n" \
                   f"   🎵 Audio ID: {audio_id}\n"
        
        elif topic_info['category'] == "flutter":
            action = data.get("action", "unknown")
            return f"{header}\n" \
                   f"   📱 Acción Flutter: {Colors.BOLD}{action}{Colors.END}\n" \
                   f"   📦 Datos: {json.dumps(data, indent=2, ensure_ascii=False)[:200]}...\n"
        
        # Formato general para otros tipos
        else:
            return f"{header}\n" \
                   f"   📦 {json.dumps(data, indent=2, ensure_ascii=False)[:300]}{'...' if len(str(data)) > 300 else ''}\n"
                   
    except json.JSONDecodeError:
        return f"{header}\n" \
               f"   ❌ Mensaje no JSON: {payload[:200]}{'...' if len(payload) > 200 else ''}\n"

# Callback functions
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print(f"{Colors.GREEN}✅ Conectado a MQTT broker{Colors.END}")
        # Suscribirse al wildcard
        client.subscribe(WILDCARD_TOPIC)
        print(f"{Colors.GREEN}✅ Suscrito a: {Colors.BOLD}{WILDCARD_TOPIC}{Colors.END} (TODOS los topics audio/*)")
        print("=" * 80)
        print(f"{Colors.BOLD}📺 MENSAJES EN VIVO (Todos los topics audio/*):{Colors.END}\n")
    else:
        print(f"{Colors.RED}❌ Error conectando. Código: {rc}{Colors.END}")

def on_message(client, userdata, msg):
    formatted = format_message(msg.topic, msg.payload.decode())
    print(formatted)
    # Separador visual entre mensajes
    print(f"{Colors.CYAN}{'─' * 40}{Colors.END}")

def on_disconnect(client, userdata, rc):
    print(f"\n{Colors.YELLOW}👋 Desconectado del broker MQTT{Colors.END}")

def main():
    print(f"{Colors.HEADER}")
    print("╔══════════════════════════════════════════════════════════════════════════╗")
    print("║                                                                          ║")
    print("║         🌐 MQTT UNIVERSAL MONITOR - ASISTENTE VOZ REALTIME             ║")
    print("║                                                                          ║")
    print("║              Monitoreando TODOS los topics audio/* 🎯                   ║")
    print("║                                                                          ║")
    print("╚══════════════════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}")
    
    print(f"{Colors.YELLOW}📡 Conectando a MQTT: {MQTT_HOST}:{MQTT_PORT}{Colors.END}")
    print(f"{Colors.CYAN}🔍 Wildcard Topic: {Colors.BOLD}{WILDCARD_TOPIC}{Colors.END}")
    print(f"{Colors.CYAN}📋 Esto captura TODOS los mensajes que empiecen con 'audio/':{Colors.END}")
    print(f"   🎙️ audio/transcription/*")
    print(f"   ⚡ audio/status/*")
    print(f"   📢 audio/notification/*")
    print(f"   ✅ audio/task/*")
    print(f"   😊 audio/emotion/*")
    print(f"   🔧 audio/system")
    print(f"   📱 audio/flutter/*")
    print(f"   🧪 audio/test/*")
    print(f"   📡 Y cualquier otro audio/...")
    
    print(f"\n{Colors.GREEN}🚀 Iniciando monitoreo universal... (Ctrl+C para salir){Colors.END}")
    print("=" * 80)
    
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
        print(f"\n{Colors.YELLOW}👋 Deteniendo monitor universal...{Colors.END}")
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