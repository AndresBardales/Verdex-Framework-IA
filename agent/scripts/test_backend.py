#!/usr/bin/env python3
"""
🧪 Test Backend FastAPI - Asistente Voz Realtime
Prueba todas las funcionalidades del backend
"""

import requests
import time
import json
import argparse
from pathlib import Path

BASE_URL = "http://localhost:5005"

def test_ping():
    """Test endpoint ping"""
    print("🏓 Testing /ping...")
    try:
        response = requests.get(f"{BASE_URL}/ping")
        if response.status_code == 200:
            print("✅ /ping OK:", response.json())
            return True
        else:
            print("❌ /ping FAILED:", response.status_code)
            return False
    except Exception as e:
        print("❌ /ping ERROR:", str(e))
        return False

def test_status():
    """Test status endpoint"""
    print("📊 Testing /status...")
    try:
        response = requests.get(f"{BASE_URL}/status")
        if response.status_code == 200:
            status = response.json()
            print("✅ /status OK:")
            for service, info in status.items():
                if isinstance(info, dict) and 'status' in info:
                    emoji = "✅" if info['status'] == 'healthy' else "❌"
                    print(f"   {emoji} {service}: {info['status']}")
            return True
        else:
            print("❌ /status FAILED:", response.status_code)
            return False
    except Exception as e:
        print("❌ /status ERROR:", str(e))
        return False

def create_mock_audio():
    """Crea un archivo de audio mock para testing"""
    import wave
    import struct
    import math
    
    filename = "/tmp/test_audio.wav"
    duration = 3  # segundos
    sample_rate = 44100
    
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)  # mono
        wav_file.setsampwidth(2)  # 16-bit
        wav_file.setframerate(sample_rate)
        
        for i in range(int(duration * sample_rate)):
            # Generar una onda senoidal simple
            value = int(32767 * math.sin(2 * math.pi * 440 * i / sample_rate))
            wav_file.writeframes(struct.pack('<h', value))
    
    return filename

def test_upload_audio():
    """Test upload de audio"""
    print("🎵 Testing /upload_audio...")
    try:
        # Crear archivo de audio de prueba
        audio_file = create_mock_audio()
        
        with open(audio_file, 'rb') as f:
            files = {'audio': ('test.wav', f, 'audio/wav')}
            data = {
                'user_id': 'test-user',
                'metadata': json.dumps({'test': True})
            }
            
            response = requests.post(f"{BASE_URL}/upload_audio", files=files, data=data)
            
        if response.status_code == 200:
            result = response.json()
            print("✅ /upload_audio OK:")
            print(f"   Record ID: {result.get('record_id')}")
            print(f"   Message: {result.get('message')}")
            return result.get('record_id')
        else:
            print("❌ /upload_audio FAILED:", response.status_code, response.text)
            return None
    except Exception as e:
        print("❌ /upload_audio ERROR:", str(e))
        return None

def test_get_recordings():
    """Test obtener grabaciones"""
    print("📝 Testing /recordings...")
    try:
        response = requests.get(f"{BASE_URL}/recordings", params={'user_id': 'test-user'})
        if response.status_code == 200:
            recordings = response.json()
            print(f"✅ /recordings OK: {len(recordings)} recordings found")
            return recordings
        else:
            print("❌ /recordings FAILED:", response.status_code)
            return []
    except Exception as e:
        print("❌ /recordings ERROR:", str(e))
        return []

def main():
    parser = argparse.ArgumentParser(description='Test Asistente Voz Backend')
    parser.add_argument('-v', '--verbose', action='store_true', help='Verbose output')
    parser.add_argument('--full', action='store_true', help='Run full test suite including audio upload')
    args = parser.parse_args()
    
    print("🧪 Testing Asistente Voz Realtime Backend\n")
    
    # Tests básicos
    results = []
    results.append(("Ping", test_ping()))
    results.append(("Status", test_status()))
    results.append(("Get Recordings", test_get_recordings()))
    
    # Test completo
    if args.full:
        record_id = test_upload_audio()
        if record_id:
            time.sleep(2)  # Esperar procesamiento
            results.append(("Upload Audio", True))
        else:
            results.append(("Upload Audio", False))
    
    # Resumen
    print("\n📊 Resumen de Tests:")
    for test_name, success in results:
        emoji = "✅" if success else "❌"
        print(f"   {emoji} {test_name}")
    
    total_success = sum(1 for _, success in results if success)
    print(f"\n🎯 Resultado: {total_success}/{len(results)} tests exitosos")

if __name__ == "__main__":
    main() 