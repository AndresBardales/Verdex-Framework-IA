#!/usr/bin/env python3

"""
🔗 n8n Webhook Tester - Testing Tool
Herramienta para probar webhooks de n8n con datos realistas
"""

import requests
import json
from datetime import datetime
import uuid

# Configuración
N8N_BASE_URL = "http://192.168.3.3:5678"
WEBHOOK_ID = "26334846-b4be-489f-a5bd-caf10aaf63d6"  # Tu webhook ID personalizado
WEBHOOK_URL = f"{N8N_BASE_URL}/webhook-test/{WEBHOOK_ID}"

# Colores
class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    CYAN = '\033[96m'
    BOLD = '\033[1m'
    END = '\033[0m'

def generate_test_data():
    """Generar datos de prueba realistas"""
    return {
        "audio_id": f"test_{datetime.now().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}",
        "transcription": "Recuérdame llamar a Juan Pérez mañana por la mañana para discutir el proyecto de desarrollo móvil",
        "confidence": 0.92,
        "language": "es",
        "duration": 45.8,
        "emotions": {
            "neutral": 0.6,
            "positivo": 0.3,
            "urgente": 0.1
        },
        "extracted_entities": {
            "persons": ["Juan Pérez"],
            "actions": ["llamar", "discutir"],
            "time": ["mañana por la mañana"],
            "topics": ["proyecto de desarrollo móvil"]
        },
        "metadata": {
            "device": "M2101K6P",
            "app_version": "1.0.0",
            "timestamp": datetime.now().isoformat(),
            "user_id": "single-user"
        }
    }

def test_webhook():
    """Probar webhook de n8n"""
    print(f"{Colors.YELLOW}🔗 Probando webhook de n8n...{Colors.END}")
    print(f"📡 URL: {WEBHOOK_URL}")
    
    # Generar datos de prueba
    test_data = generate_test_data()
    
    print(f"\n{Colors.CYAN}📦 Datos de prueba:{Colors.END}")
    print(json.dumps(test_data, indent=2, ensure_ascii=False))
    
    try:
        # Enviar webhook
        response = requests.post(
            WEBHOOK_URL,
            json=test_data,
            headers={'Content-Type': 'application/json'},
            timeout=10
        )
        
        print(f"\n{Colors.GREEN}✅ Respuesta del webhook:{Colors.END}")
        print(f"Status Code: {response.status_code}")
        
        if response.text:
            try:
                response_json = response.json()
                print(f"Response: {json.dumps(response_json, indent=2, ensure_ascii=False)}")
            except:
                print(f"Response Text: {response.text}")
        
        if response.status_code == 200:
            print(f"\n{Colors.GREEN}🎉 Webhook ejecutado exitosamente!{Colors.END}")
        else:
            print(f"\n{Colors.YELLOW}⚠️  Webhook respondió con código: {response.status_code}{Colors.END}")
            
    except requests.exceptions.ConnectionError:
        print(f"\n{Colors.RED}❌ Error: No se puede conectar a n8n{Colors.END}")
        print(f"Verifica que n8n esté ejecutándose en {N8N_BASE_URL}")
    except requests.exceptions.Timeout:
        print(f"\n{Colors.RED}❌ Error: Timeout conectando al webhook{Colors.END}")
    except Exception as e:
        print(f"\n{Colors.RED}❌ Error: {e}{Colors.END}")

if __name__ == "__main__":
    print(f"{Colors.BOLD}🧪 n8n Webhook Tester{Colors.END}\n")
    test_webhook() 