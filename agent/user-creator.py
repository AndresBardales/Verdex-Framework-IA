#!/usr/bin/env python3

"""
👤 User Creator - Creador Automático de Usuarios de Prueba
Crea usuarios de prueba para el Auth Service automáticamente
"""

import requests
import json
import time
import random
import sys
from datetime import datetime

# Configuración
AUTH_BASE_URL = "http://192.168.3.3:8001"

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

# Datos de usuarios de ejemplo
SAMPLE_USERS = [
    {"name": "Juan Pérez", "prefix": "juan"},
    {"name": "María García", "prefix": "maria"},
    {"name": "Carlos López", "prefix": "carlos"},
    {"name": "Ana Martínez", "prefix": "ana"},
    {"name": "Pedro González", "prefix": "pedro"},
    {"name": "Laura Rodríguez", "prefix": "laura"},
    {"name": "Diego Hernández", "prefix": "diego"},
    {"name": "Carmen Jiménez", "prefix": "carmen"},
    {"name": "Roberto Silva", "prefix": "roberto"},
    {"name": "Elena Torres", "prefix": "elena"}
]

def print_header():
    """Mostrar header del programa"""
    print(f"{Colors.HEADER}")
    print("╔══════════════════════════════════════════════════════════════════════════╗")
    print("║                                                                          ║")
    print("║                    👤 USER CREATOR - AUTH SERVICE                        ║")
    print("║                                                                          ║")
    print("║               Creador automático de usuarios de prueba                  ║")
    print("║                                                                          ║")
    print("╚══════════════════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}")

def check_service_health():
    """Verificar que el auth service esté disponible"""
    try:
        response = requests.get(f"{AUTH_BASE_URL}/", timeout=5)
        if response.status_code == 200:
            print(f"{Colors.GREEN}✅ Auth Service está disponible{Colors.END}")
            return True
        else:
            print(f"{Colors.RED}❌ Auth Service respondió con código: {response.status_code}{Colors.END}")
            return False
    except Exception as e:
        print(f"{Colors.RED}❌ Error conectando al Auth Service: {e}{Colors.END}")
        return False

def generate_test_email(prefix):
    """Generar email de prueba único"""
    timestamp = int(time.time())
    return f"{prefix}_{timestamp}@test.example.com"

def generate_password():
    """Generar contraseña segura de prueba"""
    return "testPass123"

def create_user(user_data):
    """Crear un usuario individual"""
    email = generate_test_email(user_data["prefix"])
    password = generate_password()
    full_name = user_data["name"]
    
    payload = {
        "email": email,
        "password": password,
        "full_name": full_name
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/register",
            headers={"Content-Type": "application/json"},
            json=payload,
            timeout=10
        )
        
        if response.status_code == 200:
            data = response.json()
            if data.get("success"):
                return {
                    "success": True,
                    "user_id": data.get("user_id"),
                    "email": email,
                    "password": password,
                    "full_name": full_name,
                    "verification_required": True
                }
        
        return {
            "success": False,
            "error": response.json().get("detail", "Unknown error"),
            "email": email
        }
        
    except Exception as e:
        return {
            "success": False,
            "error": str(e),
            "email": email
        }

def verify_user(email, verification_code="123456"):
    """Verificar usuario (usando código por defecto)"""
    payload = {
        "email": email,
        "code": verification_code
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/verify-email",
            headers={"Content-Type": "application/json"},
            json=payload,
            timeout=10
        )
        
        if response.status_code == 200:
            data = response.json()
            return data.get("success", False)
        
        return False
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error verificando {email}: {e}{Colors.END}")
        return False

def login_user(email, password):
    """Hacer login de usuario"""
    payload = {
        "email": email,
        "password": password
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/login",
            headers={"Content-Type": "application/json"},
            json=payload,
            timeout=10
        )
        
        if response.status_code == 200:
            data = response.json()
            return {
                "success": True,
                "token": data.get("access_token"),
                "user": data.get("user")
            }
        
        return {
            "success": False,
            "error": response.json().get("detail", "Login failed")
        }
        
    except Exception as e:
        return {
            "success": False,
            "error": str(e)
        }

def create_single_user():
    """Crear un solo usuario interactivamente"""
    print(f"\n{Colors.YELLOW}👤 Creando usuario individual...{Colors.END}")
    
    full_name = input(f"{Colors.CYAN}👤 Nombre completo: {Colors.END}")
    email_prefix = input(f"{Colors.CYAN}📧 Prefijo del email: {Colors.END}")
    
    user_data = {"name": full_name, "prefix": email_prefix}
    
    print(f"\n{Colors.BLUE}🔄 Creando usuario...{Colors.END}")
    result = create_user(user_data)
    
    if result["success"]:
        print(f"{Colors.GREEN}✅ Usuario creado exitosamente!{Colors.END}")
        print(f"🆔 User ID: {Colors.BOLD}{result['user_id']}{Colors.END}")
        print(f"📧 Email: {Colors.BOLD}{result['email']}{Colors.END}")
        print(f"🔒 Password: {Colors.BOLD}{result['password']}{Colors.END}")
        
        # Preguntar si verificar automáticamente
        verify = input(f"\n{Colors.CYAN}¿Verificar email automáticamente? (y/n): {Colors.END}")
        if verify.lower() == 'y':
            print(f"{Colors.YELLOW}🔄 Verificando email (usando código por defecto)...{Colors.END}")
            # En desarrollo, usar código fijo para simplicidad
            if verify_user(result['email']):
                print(f"{Colors.GREEN}✅ Email verificado!{Colors.END}")
                
                # Hacer login de prueba
                login_result = login_user(result['email'], result['password'])
                if login_result["success"]:
                    user = login_result["user"]
                    print(f"\n{Colors.GREEN}🔑 Login exitoso!{Colors.END}")
                    print(f"🆔 User ID: {Colors.BOLD}{user['user_id']}{Colors.END}")
                    print(f"\n{Colors.YELLOW}📡 Topics MQTT para este usuario:{Colors.END}")
                    print(f"    {Colors.CYAN}audio/transcription/{user['user_id']}{Colors.END}")
                    print(f"    {Colors.CYAN}audio/status/{user['user_id']}{Colors.END}")
                    print(f"    {Colors.CYAN}audio/notification/{user['user_id']}{Colors.END}")
                    print(f"    {Colors.CYAN}audio/task/{user['user_id']}{Colors.END}")
                    
                    return user
        
        return result
    else:
        print(f"{Colors.RED}❌ Error creando usuario: {result['error']}{Colors.END}")
        return None

def create_multiple_users():
    """Crear múltiples usuarios automáticamente"""
    print(f"\n{Colors.YELLOW}👥 Creando múltiples usuarios...{Colors.END}")
    
    try:
        count = int(input(f"{Colors.CYAN}🔢 ¿Cuántos usuarios crear? (máx 10): {Colors.END}"))
        count = min(count, 10)
    except:
        count = 3
    
    print(f"\n{Colors.BLUE}🔄 Creando {count} usuarios de prueba...{Colors.END}")
    
    created_users = []
    
    for i in range(count):
        user_data = random.choice(SAMPLE_USERS)
        print(f"\n{Colors.CYAN}👤 Creando: {user_data['name']}...{Colors.END}")
        
        result = create_user(user_data)
        
        if result["success"]:
            print(f"   {Colors.GREEN}✅ {result['email']}{Colors.END}")
            created_users.append(result)
            
            # Verificar automáticamente (en desarrollo)
            if verify_user(result['email']):
                print(f"   {Colors.GREEN}✅ Verificado{Colors.END}")
                result["verified"] = True
            else:
                print(f"   {Colors.YELLOW}⚠️  Verificación pendiente{Colors.END}")
                result["verified"] = False
        else:
            print(f"   {Colors.RED}❌ Error: {result['error']}{Colors.END}")
        
        time.sleep(1)  # Evitar spam
    
    # Resumen
    print(f"\n{Colors.BOLD}📊 RESUMEN:{Colors.END}")
    print(f"👥 Usuarios creados: {Colors.GREEN}{len(created_users)}{Colors.END}")
    
    if created_users:
        print(f"\n{Colors.YELLOW}📋 Lista de usuarios:{Colors.END}")
        for user in created_users:
            status = "✅ Verificado" if user.get("verified") else "⏳ Pendiente"
            print(f"  📧 {user['email']}")
            print(f"  🔒 {user['password']}")
            print(f"  🆔 {user['user_id']}")
            print(f"  🟢 {status}")
            print()
        
        # Mostrar topics MQTT
        print(f"{Colors.YELLOW}📡 Topics MQTT disponibles:{Colors.END}")
        for user in created_users:
            print(f"  {Colors.CYAN}audio/*/{user['user_id']}{Colors.END}")
    
    return created_users

def get_service_stats():
    """Obtener estadísticas del servicio"""
    print(f"\n{Colors.YELLOW}📊 Obteniendo estadísticas...{Colors.END}")
    
    try:
        response = requests.get(f"{AUTH_BASE_URL}/stats", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print(f"\n{Colors.BOLD}📊 ESTADÍSTICAS DEL AUTH SERVICE:{Colors.END}")
            print(f"👥 Total usuarios: {Colors.GREEN}{data.get('total_users', 0)}{Colors.END}")
            print(f"✅ Verificados: {Colors.GREEN}{data.get('verified_users', 0)}{Colors.END}")
            print(f"⏳ Pendientes: {Colors.YELLOW}{data.get('pending_verification', 0)}{Colors.END}")
            print(f"📈 Registros últimos 7 días: {Colors.CYAN}{data.get('recent_registrations_7days', 0)}{Colors.END}")
            print(f"📊 Tasa de verificación: {Colors.BOLD}{data.get('verification_rate', 0)}%{Colors.END}")
            return data
        else:
            print(f"{Colors.RED}❌ Error obteniendo estadísticas{Colors.END}")
            return None
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def show_menu():
    """Mostrar menú principal"""
    print(f"\n{Colors.CYAN}📋 Selecciona una opción:{Colors.END}\n")
    
    options = [
        ("1", "👤 Crear Usuario Individual", "Crear un usuario paso a paso"),
        ("2", "👥 Crear Múltiples Usuarios", "Crear varios usuarios automáticamente"),
        ("3", "📊 Ver Estadísticas", "Estadísticas del servicio"),
        ("4", "🧪 Usuario de Prueba Rápido", "Crear usuario listo para usar"),
        ("0", "❌ Salir", "Salir del programa")
    ]
    
    for num, title, desc in options:
        print(f"   {Colors.BOLD}{num}{Colors.END} - {title}")
        print(f"       {Colors.YELLOW}{desc}{Colors.END}\n")

def create_quick_test_user():
    """Crear usuario de prueba rápido y completo"""
    print(f"\n{Colors.YELLOW}🧪 Creando usuario de prueba rápido...{Colors.END}")
    
    timestamp = int(time.time())
    test_user = {
        "name": f"Test User {timestamp}",
        "prefix": "testuser"
    }
    
    print(f"{Colors.BLUE}🔄 Creando usuario de prueba...{Colors.END}")
    result = create_user(test_user)
    
    if result["success"]:
        print(f"{Colors.GREEN}✅ Usuario creado!{Colors.END}")
        
        # Verificar automáticamente
        print(f"{Colors.BLUE}🔄 Verificando email...{Colors.END}")
        if verify_user(result['email']):
            print(f"{Colors.GREEN}✅ Email verificado!{Colors.END}")
            
            # Login automático
            print(f"{Colors.BLUE}🔄 Haciendo login...{Colors.END}")
            login_result = login_user(result['email'], result['password'])
            
            if login_result["success"]:
                user = login_result["user"]
                print(f"\n{Colors.GREEN}🎉 ¡Usuario de prueba listo!{Colors.END}")
                print(f"\n{Colors.BOLD}📋 DATOS DEL USUARIO:{Colors.END}")
                print(f"📧 Email: {Colors.CYAN}{result['email']}{Colors.END}")
                print(f"🔒 Password: {Colors.CYAN}{result['password']}{Colors.END}")
                print(f"🆔 User ID: {Colors.CYAN}{user['user_id']}{Colors.END}")
                print(f"🔑 Token: {Colors.CYAN}{login_result['token'][:30]}...{Colors.END}")
                
                print(f"\n{Colors.BOLD}📡 TOPICS MQTT:{Colors.END}")
                topics = [
                    f"audio/transcription/{user['user_id']}",
                    f"audio/status/{user['user_id']}",
                    f"audio/notification/{user['user_id']}",
                    f"audio/task/{user['user_id']}",
                    f"audio/emotion/{user['user_id']}",
                    f"audio/flutter/{user['user_id']}"
                ]
                
                for topic in topics:
                    print(f"  📡 {Colors.YELLOW}{topic}{Colors.END}")
                
                print(f"\n{Colors.BOLD}🔧 COMANDOS ÚTILES:{Colors.END}")
                print(f"{Colors.CYAN}# Monitor este usuario específico:{Colors.END}")
                print(f"./mqtt-user-monitor.py {user['user_id']}")
                print(f"\n{Colors.CYAN}# Enviar mensaje de prueba:{Colors.END}")
                print(f"mosquitto_pub -h 192.168.3.3 -t 'audio/notification/{user['user_id']}' \\")
                print(f"  -m '{{\"type\":\"info\",\"message\":\"Hola {user['full_name']}!\"}}'")
                
                return user
    
    print(f"{Colors.RED}❌ Error creando usuario de prueba{Colors.END}")
    return None

def main():
    """Función principal"""
    print_header()
    
    print(f"{Colors.GREEN}📡 Auth Service URL: {Colors.BOLD}{AUTH_BASE_URL}{Colors.END}")
    
    # Verificar servicio
    if not check_service_health():
        print(f"{Colors.RED}❌ El Auth Service no está disponible. Asegúrate de que esté corriendo.{Colors.END}")
        print(f"{Colors.YELLOW}💡 Ejecuta: docker-compose up auth-service{Colors.END}")
        return
    
    while True:
        show_menu()
        choice = input(f"{Colors.BOLD}Selección: {Colors.END}")
        
        try:
            if choice == "0":
                print(f"{Colors.YELLOW}👋 ¡Hasta luego!{Colors.END}")
                break
            elif choice == "1":
                create_single_user()
            elif choice == "2":
                create_multiple_users()
            elif choice == "3":
                get_service_stats()
            elif choice == "4":
                create_quick_test_user()
            else:
                print(f"{Colors.RED}❌ Opción inválida{Colors.END}")
        
        except KeyboardInterrupt:
            print(f"\n{Colors.YELLOW}👋 Interrumpido por usuario{Colors.END}")
            break
        except Exception as e:
            print(f"{Colors.RED}❌ Error inesperado: {e}{Colors.END}")
        
        input(f"\n{Colors.CYAN}Presiona Enter para continuar...{Colors.END}")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}👋 ¡Hasta luego!{Colors.END}")
    except ImportError:
        print(f"{Colors.RED}❌ Error: Instala requests:{Colors.END}")
        print("pip install requests")
        sys.exit(1) 