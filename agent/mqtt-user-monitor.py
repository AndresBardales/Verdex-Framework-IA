#!/usr/bin/env python3

"""
📡 MQTT User Monitor - Monitor específico por usuario
Monitorea todos los mensajes MQTT de un usuario específico
"""

import paho.mqtt.client as mqtt
import json
import sys
import time
from datetime import datetime

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

def print_header(user_id):
    """Mostrar header del programa"""
    print(f"{Colors.HEADER}")
    print("╔══════════════════════════════════════════════════════════════════════════╗")
    print("║                                                                          ║")
    print("║               📡 MQTT USER MONITOR - ASISTENTE VOZ                       ║")
    print("║                                                                          ║")
    print(f"║                    Monitoreando usuario: {user_id[:20]:^20}               ║")
    print("║                                                                          ║")
    print("╚══════════════════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}")

def get_topic_info(topic):
    """Analizar y clasificar topic"""
    parts = topic.split('/')
    
    if len(parts) >= 3 and parts[0] == "audio":
        category = parts[1]  # transcription, status, etc.
        user_id = parts[2]
        
        topic_map = {
            "transcription": {"emoji": "🎙️", "color": Colors.GREEN, "name": "TRANSCRIPCIÓN"},
            "status": {"emoji": "⚡", "color": Colors.BLUE, "name": "STATUS"},
            "notification": {"emoji": "📢", "color": Colors.YELLOW, "name": "NOTIFICACIÓN"},
            "task": {"emoji": "✅", "color": Colors.CYAN, "name": "TAREA"},
            "emotion": {"emoji": "😊", "color": Colors.MAGENTA, "name": "EMOCIÓN"},
            "flutter": {"emoji": "📱", "color": Colors.BLUE, "name": "FLUTTER APP"},
            "system": {"emoji": "🔧", "color": Colors.RED, "name": "SISTEMA"},
            "test": {"emoji": "🧪", "color": Colors.YELLOW, "name": "TEST"},
        }
        
        info = topic_map.get(category, {"emoji": "📡", "color": Colors.CYAN, "name": "OTHER"})
        info["user_id"] = user_id
        info["category"] = category
        return info
    
    return {"emoji": "❓", "color": Colors.RED, "name": "INVALID", "user_id": "unknown", "category": "unknown"}

def format_message_content(data, category):
    """Formatear contenido del mensaje según el tipo"""
    try:
        if category == "transcription":
            text = data.get("text", "")
            confidence = data.get("confidence", 0)
            language = data.get("language", "unknown")
            return f"📝 {Colors.CYAN}{text[:100]}{'...' if len(text) > 100 else ''}{Colors.END}\n" \
                   f"   🎯 Confianza: {confidence:.2f} | 🌍 Idioma: {language}"
        
        elif category == "task":
            if "task" in data:
                task_info = data["task"]
                title = task_info.get("title", "Sin título")
                priority = task_info.get("priority", "normal")
                return f"📋 {Colors.BOLD}{title}{Colors.END}\n" \
                       f"   🔥 Prioridad: {priority}"
        
        elif category == "emotion":
            emotions = data.get("emotions", {})
            if emotions:
                primary = max(emotions, key=emotions.get)
                score = emotions[primary]
                return f"😊 Emoción principal: {Colors.BOLD}{primary}{Colors.END} ({score:.2f})\n" \
                       f"   📊 Todas: {emotions}"
        
        elif category == "notification":
            message = data.get("message", "")
            notification_type = data.get("type", "info")
            return f"📢 {Colors.BOLD}{message}{Colors.END}\n" \
                   f"   🏷️  Tipo: {notification_type}"
        
        elif category == "status":
            status = data.get("status", "unknown")
            audio_id = data.get("audio_id", "N/A")
            progress = data.get("progress", 0)
            return f"⚡ Estado: {Colors.BOLD}{status}{Colors.END} ({progress}%)\n" \
                   f"   🎵 Audio ID: {audio_id}"
        
        elif category == "flutter":
            action = data.get("action", "unknown")
            return f"📱 Acción Flutter: {Colors.BOLD}{action}{Colors.END}\n" \
                   f"   📦 Datos: {json.dumps(data, ensure_ascii=False)[:150]}..."
        
        # Formato general para otros tipos
        else:
            return f"📦 {json.dumps(data, indent=2, ensure_ascii=False)[:200]}{'...' if len(str(data)) > 200 else ''}"
                   
    except Exception as e:
        return f"❌ Error formateando mensaje: {e}"

def format_message(topic, payload, user_id):
    """Formatear mensaje completo para display"""
    timestamp = datetime.now().strftime("%H:%M:%S")
    topic_info = get_topic_info(topic)
    
    # Solo mostrar si es del usuario correcto
    if topic_info["user_id"] != user_id:
        return None
    
    header = f"{topic_info['color']}{topic_info['emoji']} {topic_info['name']} [{timestamp}]{Colors.END}"
    header += f" {Colors.BOLD}({topic}){Colors.END}"
    
    try:
        data = json.loads(payload)
        content = format_message_content(data, topic_info['category'])
        return f"{header}\n   {content}\n"
                
    except json.JSONDecodeError:
        return f"{header}\n   ❌ Mensaje no JSON: {payload[:100]}{'...' if len(payload) > 100 else ''}\n"

# Variables globales
monitored_user_id = None
message_count = 0

def on_connect(client, userdata, flags, rc):
    """Callback de conexión"""
    if rc == 0:
        print(f"{Colors.GREEN}✅ Conectado a MQTT broker{Colors.END}")
        
        # Suscribirse a todos los topics del usuario
        user_wildcard = f"audio/+/{monitored_user_id}"
        client.subscribe(user_wildcard)
        print(f"{Colors.GREEN}✅ Suscrito a: {Colors.BOLD}{user_wildcard}{Colors.END}")
        
        print("=" * 80)
        print(f"{Colors.BOLD}📺 MENSAJES EN VIVO PARA USUARIO: {Colors.CYAN}{monitored_user_id}{Colors.END}")
        print(f"{Colors.YELLOW}🔍 Capturando: audio/transcription/{monitored_user_id}{Colors.END}")
        print(f"{Colors.YELLOW}🔍 Capturando: audio/status/{monitored_user_id}{Colors.END}")
        print(f"{Colors.YELLOW}🔍 Capturando: audio/notification/{monitored_user_id}{Colors.END}")
        print(f"{Colors.YELLOW}🔍 Capturando: audio/task/{monitored_user_id}{Colors.END}")
        print(f"{Colors.YELLOW}🔍 Capturando: audio/emotion/{monitored_user_id}{Colors.END}")
        print(f"{Colors.YELLOW}🔍 Capturando: audio/flutter/{monitored_user_id}{Colors.END}")
        print("=" * 80)
        print()
    else:
        print(f"{Colors.RED}❌ Error conectando. Código: {rc}{Colors.END}")

def on_message(client, userdata, msg):
    """Callback de mensaje"""
    global message_count
    
    formatted = format_message(msg.topic, msg.payload.decode(), monitored_user_id)
    
    if formatted:  # Solo mostrar si es del usuario correcto
        message_count += 1
        print(formatted)
        print(f"{Colors.CYAN}{'─' * 60} Mensaje #{message_count} ─{'─' * 20}{Colors.END}")

def on_disconnect(client, userdata, rc):
    """Callback de desconexión"""
    print(f"\n{Colors.YELLOW}👋 Desconectado del broker MQTT{Colors.END}")

def send_test_messages(user_id):
    """Enviar mensajes de prueba para el usuario"""
    print(f"\n{Colors.YELLOW}🧪 ¿Enviar mensajes de prueba para {user_id}? (y/n): {Colors.END}", end="")
    response = input()
    
    if response.lower() == 'y':
        import subprocess
        
        print(f"{Colors.BLUE}🔄 Enviando mensajes de prueba...{Colors.END}")
        
        # Mensaje de transcripción
        transcription_msg = {
            "audio_id": "test_12345",
            "text": f"Mensaje de prueba para el usuario {user_id}",
            "confidence": 0.95,
            "language": "es",
            "timestamp": datetime.now().isoformat() + "Z"
        }
        
        cmd = [
            "mosquitto_pub", "-h", MQTT_HOST, "-t", f"audio/transcription/{user_id}",
            "-m", json.dumps(transcription_msg)
        ]
        
        try:
            subprocess.run(cmd, check=True)
            print(f"{Colors.GREEN}✅ Mensaje de transcripción enviado{Colors.END}")
        except subprocess.CalledProcessError:
            print(f"{Colors.RED}❌ Error enviando mensaje (instala mosquitto-clients){Colors.END}")
        
        time.sleep(1)
        
        # Mensaje de notificación
        notification_msg = {
            "type": "info",
            "title": "Mensaje de prueba",
            "message": f"¡Hola {user_id}! Este es un mensaje de prueba.",
            "timestamp": datetime.now().isoformat() + "Z"
        }
        
        cmd = [
            "mosquitto_pub", "-h", MQTT_HOST, "-t", f"audio/notification/{user_id}",
            "-m", json.dumps(notification_msg)
        ]
        
        try:
            subprocess.run(cmd, check=True)
            print(f"{Colors.GREEN}✅ Mensaje de notificación enviado{Colors.END}")
        except subprocess.CalledProcessError:
            print(f"{Colors.RED}❌ Error enviando mensaje{Colors.END}")

def show_help():
    """Mostrar ayuda"""
    print(f"\n{Colors.CYAN}📋 COMANDOS ÚTILES PARA TESTING:{Colors.END}")
    print(f"\n{Colors.YELLOW}🧪 Enviar mensaje de prueba manualmente:{Colors.END}")
    print(f"mosquitto_pub -h {MQTT_HOST} -t 'audio/notification/{monitored_user_id}' \\")
    print(f"  -m '{{\"type\":\"info\",\"message\":\"Hola usuario!\"}}'")
    
    print(f"\n{Colors.YELLOW}📡 Suscribirse manualmente a un topic:{Colors.END}")
    print(f"mosquitto_sub -h {MQTT_HOST} -t 'audio/transcription/{monitored_user_id}' -v")
    
    print(f"\n{Colors.YELLOW}🔧 Usar el MQTT publisher de agent:{Colors.END}")
    print(f"./mqtt-publisher.py")
    
    print(f"\n{Colors.YELLOW}👤 Crear usuario de prueba:{Colors.END}")
    print(f"./user-creator.py")

def main():
    """Función principal"""
    global monitored_user_id
    
    # Obtener user_id desde argumentos o input
    if len(sys.argv) > 1:
        monitored_user_id = sys.argv[1]
    else:
        print(f"{Colors.YELLOW}📋 Uso: {sys.argv[0]} <user_id>{Colors.END}")
        print(f"{Colors.YELLOW}📋 O proporciona el user_id manualmente:{Colors.END}")
        monitored_user_id = input(f"{Colors.CYAN}🆔 User ID a monitorear: {Colors.END}")
    
    if not monitored_user_id:
        print(f"{Colors.RED}❌ User ID requerido{Colors.END}")
        sys.exit(1)
    
    print_header(monitored_user_id)
    
    print(f"{Colors.GREEN}📡 MQTT Broker: {Colors.BOLD}{MQTT_HOST}:{MQTT_PORT}{Colors.END}")
    print(f"{Colors.GREEN}👤 Usuario: {Colors.BOLD}{monitored_user_id}{Colors.END}")
    print(f"{Colors.GREEN}🔍 Pattern: {Colors.BOLD}audio/+/{monitored_user_id}{Colors.END}")
    
    # Ofrecer enviar mensajes de prueba
    send_test_messages(monitored_user_id)
    
    print(f"\n{Colors.GREEN}🚀 Iniciando monitoreo... (Ctrl+C para salir){Colors.END}")
    
    # Crear cliente MQTT
    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_message = on_message
    client.on_disconnect = on_disconnect
    
    try:
        # Conectar al broker
        client.connect(MQTT_HOST, MQTT_PORT, 60)
        
        # Mostrar ayuda
        show_help()
        
        # Loop para mantener la conexión
        client.loop_forever()
        
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}👋 Deteniendo monitor de usuario...{Colors.END}")
        print(f"📊 Total mensajes capturados: {Colors.BOLD}{message_count}{Colors.END}")
        client.disconnect()
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        client.disconnect()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}👋 ¡Hasta luego!{Colors.END}")
    except ImportError:
        print(f"{Colors.RED}❌ Error: Instala las dependencias:{Colors.END}")
        print("sudo apt install python3-paho-mqtt mosquitto-clients")
        sys.exit(1) 