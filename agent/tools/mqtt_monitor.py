#!/usr/bin/env python3
"""
📡 MQTT Monitor - Asistente Voz Realtime
Monitor en tiempo real de mensajes MQTT
"""

import asyncio
import json
from datetime import datetime
import argparse
import sys

try:
    import aiomqtt
except ImportError:
    print("❌ Error: Instalar aiomqtt")
    print("💡 pip install aiomqtt")
    sys.exit(1)

class MQTTMonitor:
    def __init__(self, host="localhost", port=1883, user_id="single-user"):
        self.host = host
        self.port = port
        self.user_id = user_id
        self.message_count = 0
        
    async def monitor(self, verbose=False):
        """Monitor MQTT messages"""
        print(f"📡 Conectando a MQTT broker {self.host}:{self.port}")
        print(f"👤 Monitoreando usuario: {self.user_id}")
        print("🔄 Presiona Ctrl+C para salir\n")
        
        try:
            async with aiomqtt.Client(hostname=self.host, port=self.port) as client:
                # Suscribirse a todos los topics del usuario
                topics = [
                    f"asistente/{self.user_id}/transcription",
                    f"asistente/{self.user_id}/status", 
                    f"asistente/{self.user_id}/notification",
                    f"asistente/{self.user_id}/task",
                    f"asistente/{self.user_id}/emotion",
                    f"asistente/{self.user_id}/system"
                ]
                
                for topic in topics:
                    await client.subscribe(topic)
                    if verbose:
                        print(f"✅ Suscrito a: {topic}")
                
                print("🎯 Esperando mensajes...\n")
                
                async for message in client.messages:
                    self.message_count += 1
                    await self.process_message(message, verbose)
                    
        except KeyboardInterrupt:
            print(f"\n👋 Monitor detenido. Total mensajes: {self.message_count}")
        except Exception as e:
            print(f"❌ Error: {e}")
    
    async def process_message(self, message, verbose):
        """Procesa un mensaje MQTT"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        topic = str(message.topic)
        
        # Extraer tipo de mensaje del topic
        topic_parts = topic.split('/')
        msg_type = topic_parts[-1] if len(topic_parts) > 0 else "unknown"
        
        # Emojis por tipo
        emoji_map = {
            "transcription": "🎤",
            "status": "📊", 
            "notification": "🔔",
            "task": "✅",
            "emotion": "😊",
            "system": "🔧"
        }
        emoji = emoji_map.get(msg_type, "📨")
        
        try:
            payload = json.loads(message.payload.decode())
            
            # Mostrar resumen
            print(f"{emoji} [{timestamp}] {msg_type.upper()}")
            
            if verbose:
                print(f"   Topic: {topic}")
                print(f"   Payload: {json.dumps(payload, indent=2, ensure_ascii=False)}")
            else:
                # Mostrar campos relevantes según el tipo
                if msg_type == "transcription":
                    text = payload.get('text', 'N/A')[:100]
                    print(f"   💬 Texto: {text}...")
                elif msg_type == "status":
                    status = payload.get('status', 'N/A')
                    print(f"   📊 Estado: {status}")
                elif msg_type == "emotion":
                    emotion = payload.get('emotion', 'N/A')
                    confidence = payload.get('confidence', 0)
                    print(f"   😊 Emoción: {emotion} ({confidence:.2f})")
                elif msg_type == "task":
                    action = payload.get('action_type', 'N/A')
                    description = payload.get('description', 'N/A')[:50]
                    print(f"   ✅ Acción: {action} - {description}...")
                else:
                    # Para otros tipos, mostrar mensaje genérico
                    if 'message' in payload:
                        print(f"   💬 {payload['message']}")
            
            print()  # Línea en blanco
            
        except json.JSONDecodeError:
            print(f"{emoji} [{timestamp}] {msg_type.upper()}")
            print(f"   📝 Raw: {message.payload.decode()}")
            print()
        except Exception as e:
            print(f"❌ Error procesando mensaje: {e}")

def main():
    parser = argparse.ArgumentParser(description='Monitor MQTT para Asistente Voz')
    parser.add_argument('--host', default='localhost', help='MQTT broker host')
    parser.add_argument('--port', type=int, default=1883, help='MQTT broker port')
    parser.add_argument('--user', default='single-user', help='User ID to monitor')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')
    args = parser.parse_args()
    
    monitor = MQTTMonitor(args.host, args.port, args.user)
    
    try:
        asyncio.run(monitor.monitor(args.verbose))
    except KeyboardInterrupt:
        print("\n👋 Monitor detenido por usuario")

if __name__ == "__main__":
    main() 