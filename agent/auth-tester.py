#!/usr/bin/env python3

"""
🧪 Auth Service Interactive Tester
Herramienta para probar todos los endpoints del Auth Service
"""

import requests
import json
from datetime import datetime
import time
import sys

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

def print_header():
    """Mostrar header del programa"""
    print(f"{Colors.HEADER}")
    print("╔══════════════════════════════════════════════════════════════════════════╗")
    print("║                                                                          ║")
    print("║                 🔐 AUTH SERVICE INTERACTIVE TESTER                       ║")
    print("║                                                                          ║")
    print("║              Prueba todos los endpoints del Auth Service                 ║")
    print("║                                                                          ║")
    print("╚══════════════════════════════════════════════════════════════════════════╝")
    print(f"{Colors.END}")

def print_response(response, title="Response"):
    """Imprimir respuesta HTTP formateada"""
    status_color = Colors.GREEN if 200 <= response.status_code < 300 else Colors.RED
    print(f"\n{Colors.BOLD}{title}:{Colors.END}")
    print(f"Status: {status_color}{response.status_code}{Colors.END}")
    
    try:
        data = response.json()
        print(f"Body: {Colors.CYAN}{json.dumps(data, indent=2, ensure_ascii=False)}{Colors.END}")
        return data
    except:
        print(f"Body: {Colors.YELLOW}{response.text}{Colors.END}")
        return None

def test_health_check():
    """Probar health check"""
    print(f"\n{Colors.YELLOW}🏠 Testing Health Check...{Colors.END}")
    
    try:
        response = requests.get(f"{AUTH_BASE_URL}/")
        return print_response(response, "Health Check")
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def test_register():
    """Probar registro de usuario"""
    print(f"\n{Colors.YELLOW}👤 Testing User Registration...{Colors.END}")
    
    email = input(f"{Colors.CYAN}📧 Email: {Colors.END}")
    password = input(f"{Colors.CYAN}🔒 Password: {Colors.END}")
    full_name = input(f"{Colors.CYAN}👤 Full Name: {Colors.END}")
    
    payload = {
        "email": email,
        "password": password,
        "full_name": full_name
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/register",
            headers={"Content-Type": "application/json"},
            json=payload
        )
        data = print_response(response, "User Registration")
        
        if data and data.get("success"):
            print(f"\n{Colors.GREEN}✅ Usuario registrado exitosamente!{Colors.END}")
            print(f"🆔 User ID: {Colors.BOLD}{data.get('user_id')}{Colors.END}")
            print(f"📧 Revisa los logs del auth-service para el código de verificación")
            
            # Guardar datos para próximos tests
            global test_email, test_user_id
            test_email = email
            test_user_id = data.get('user_id')
        
        return data
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def test_verify_email():
    """Probar verificación de email"""
    print(f"\n{Colors.YELLOW}✅ Testing Email Verification...{Colors.END}")
    
    email = input(f"{Colors.CYAN}📧 Email: {Colors.END}")
    code = input(f"{Colors.CYAN}🔢 Verification Code (6 digits): {Colors.END}")
    
    payload = {
        "email": email,
        "code": code
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/verify-email",
            headers={"Content-Type": "application/json"},
            json=payload
        )
        data = print_response(response, "Email Verification")
        
        if data and data.get("success"):
            print(f"\n{Colors.GREEN}✅ Email verificado exitosamente!{Colors.END}")
        
        return data
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def test_login():
    """Probar login"""
    print(f"\n{Colors.YELLOW}🔑 Testing Login...{Colors.END}")
    
    email = input(f"{Colors.CYAN}📧 Email: {Colors.END}")
    password = input(f"{Colors.CYAN}🔒 Password: {Colors.END}")
    
    payload = {
        "email": email,
        "password": password
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/login",
            headers={"Content-Type": "application/json"},
            json=payload
        )
        data = print_response(response, "Login")
        
        if data and data.get("access_token"):
            print(f"\n{Colors.GREEN}✅ Login exitoso!{Colors.END}")
            print(f"🔑 Token: {Colors.BOLD}{data['access_token'][:30]}...{Colors.END}")
            print(f"👤 User ID: {Colors.BOLD}{data['user']['user_id']}{Colors.END}")
            
            # Guardar token para próximos tests
            global test_token, test_user_id
            test_token = data['access_token']
            test_user_id = data['user']['user_id']
        
        return data
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def test_forgot_password():
    """Probar solicitud de recuperación de contraseña"""
    print(f"\n{Colors.YELLOW}🔒 Testing Forgot Password...{Colors.END}")
    
    email = input(f"{Colors.CYAN}📧 Email: {Colors.END}")
    
    payload = {
        "email": email
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/forgot-password",
            headers={"Content-Type": "application/json"},
            json=payload
        )
        data = print_response(response, "Forgot Password")
        
        if data and data.get("success"):
            print(f"\n{Colors.GREEN}✅ Código de recuperación enviado!{Colors.END}")
            print(f"📧 Revisa los logs del auth-service para el código")
        
        return data
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def test_reset_password():
    """Probar reset de contraseña"""
    print(f"\n{Colors.YELLOW}🔄 Testing Password Reset...{Colors.END}")
    
    email = input(f"{Colors.CYAN}📧 Email: {Colors.END}")
    code = input(f"{Colors.CYAN}🔢 Reset Code: {Colors.END}")
    new_password = input(f"{Colors.CYAN}🔒 New Password: {Colors.END}")
    
    payload = {
        "email": email,
        "code": code,
        "new_password": new_password
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/reset-password",
            headers={"Content-Type": "application/json"},
            json=payload
        )
        data = print_response(response, "Password Reset")
        
        if data and data.get("success"):
            print(f"\n{Colors.GREEN}✅ Contraseña actualizada exitosamente!{Colors.END}")
        
        return data
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def test_profile():
    """Probar obtener perfil (requiere token)"""
    print(f"\n{Colors.YELLOW}👤 Testing Get Profile...{Colors.END}")
    
    # Usar token guardado o pedir uno nuevo
    token = test_token if 'test_token' in globals() else None
    
    if not token:
        token = input(f"{Colors.CYAN}🔑 JWT Token: {Colors.END}")
    
    headers = {
        "Authorization": f"Bearer {token}"
    }
    
    try:
        response = requests.get(f"{AUTH_BASE_URL}/profile", headers=headers)
        data = print_response(response, "Profile")
        
        if data:
            print(f"\n{Colors.GREEN}✅ Perfil obtenido exitosamente!{Colors.END}")
            print(f"🆔 User ID: {Colors.BOLD}{data.get('user_id')}{Colors.END}")
            print(f"📧 Email: {Colors.BOLD}{data.get('email')}{Colors.END}")
            print(f"👤 Name: {Colors.BOLD}{data.get('full_name')}{Colors.END}")
        
        return data
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def test_stats():
    """Probar estadísticas del servicio"""
    print(f"\n{Colors.YELLOW}📊 Testing Service Stats...{Colors.END}")
    
    try:
        response = requests.get(f"{AUTH_BASE_URL}/stats")
        data = print_response(response, "Service Stats")
        
        if data:
            print(f"\n{Colors.GREEN}✅ Estadísticas obtenidas!{Colors.END}")
            print(f"👥 Total usuarios: {Colors.BOLD}{data.get('total_users', 0)}{Colors.END}")
            print(f"✅ Verificados: {Colors.BOLD}{data.get('verified_users', 0)}{Colors.END}")
            print(f"⏳ Pendientes: {Colors.BOLD}{data.get('pending_verification', 0)}{Colors.END}")
        
        return data
        
    except Exception as e:
        print(f"{Colors.RED}❌ Error: {e}{Colors.END}")
        return None

def run_complete_flow():
    """Ejecutar flujo completo de prueba"""
    print(f"\n{Colors.YELLOW}🚀 Running Complete Auth Flow...{Colors.END}")
    
    # Datos de prueba
    test_email = f"test_{int(time.time())}@example.com"
    test_password = "testPass123"
    test_name = "Test User"
    
    print(f"\n📧 Using test email: {Colors.BOLD}{test_email}{Colors.END}")
    
    # 1. Health check
    print(f"\n{Colors.CYAN}1. Health Check{Colors.END}")
    health_data = test_health_check()
    if not health_data:
        print(f"{Colors.RED}❌ Auth service no está disponible{Colors.END}")
        return
    
    # 2. Register
    print(f"\n{Colors.CYAN}2. Register User{Colors.END}")
    register_data = {
        "email": test_email,
        "password": test_password,
        "full_name": test_name
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/register",
            headers={"Content-Type": "application/json"},
            json=register_data
        )
        reg_data = print_response(response, "Registration")
        
        if not reg_data or not reg_data.get("success"):
            print(f"{Colors.RED}❌ Registration failed{Colors.END}")
            return
        
        user_id = reg_data.get("user_id")
        print(f"\n{Colors.GREEN}✅ Usuario registrado: {user_id}{Colors.END}")
        
    except Exception as e:
        print(f"{Colors.RED}❌ Registration error: {e}{Colors.END}")
        return
    
    # 3. Verificar (necesitamos el código de los logs)
    print(f"\n{Colors.CYAN}3. Email Verification{Colors.END}")
    print(f"{Colors.YELLOW}⚠️  Necesitas obtener el código de verificación de los logs del auth-service{Colors.END}")
    print(f"{Colors.YELLOW}    Ejecuta: docker logs audio-auth | grep 'código de verificación'{Colors.END}")
    
    verify_code = input(f"{Colors.CYAN}🔢 Ingresa el código de verificación: {Colors.END}")
    
    verify_data = {
        "email": test_email,
        "code": verify_code
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/verify-email",
            headers={"Content-Type": "application/json"},
            json=verify_data
        )
        ver_data = print_response(response, "Verification")
        
        if not ver_data or not ver_data.get("success"):
            print(f"{Colors.RED}❌ Verification failed{Colors.END}")
            return
        
        print(f"\n{Colors.GREEN}✅ Email verificado{Colors.END}")
        
    except Exception as e:
        print(f"{Colors.RED}❌ Verification error: {e}{Colors.END}")
        return
    
    # 4. Login
    print(f"\n{Colors.CYAN}4. Login{Colors.END}")
    login_data = {
        "email": test_email,
        "password": test_password
    }
    
    try:
        response = requests.post(
            f"{AUTH_BASE_URL}/login",
            headers={"Content-Type": "application/json"},
            json=login_data
        )
        log_data = print_response(response, "Login")
        
        if not log_data or not log_data.get("access_token"):
            print(f"{Colors.RED}❌ Login failed{Colors.END}")
            return
        
        token = log_data.get("access_token")
        print(f"\n{Colors.GREEN}✅ Login exitoso{Colors.END}")
        print(f"🔑 Token: {token[:30]}...")
        
    except Exception as e:
        print(f"{Colors.RED}❌ Login error: {e}{Colors.END}")
        return
    
    # 5. Profile
    print(f"\n{Colors.CYAN}5. Get Profile{Colors.END}")
    headers = {"Authorization": f"Bearer {token}"}
    
    try:
        response = requests.get(f"{AUTH_BASE_URL}/profile", headers=headers)
        prof_data = print_response(response, "Profile")
        
        if prof_data:
            print(f"\n{Colors.GREEN}✅ Perfil obtenido{Colors.END}")
            print(f"🆔 User ID: {prof_data.get('user_id')}")
            print(f"📧 Email: {prof_data.get('email')}")
            print(f"👤 Name: {prof_data.get('full_name')}")
            
            # Guardar user_id para MQTT testing
            global test_user_id
            test_user_id = prof_data.get('user_id')
            
            print(f"\n{Colors.YELLOW}📡 Para MQTT testing, usa este user_id:{Colors.END}")
            print(f"    {Colors.BOLD}audio/transcription/{test_user_id}{Colors.END}")
            print(f"    {Colors.BOLD}audio/status/{test_user_id}{Colors.END}")
            print(f"    {Colors.BOLD}audio/notification/{test_user_id}{Colors.END}")
        
    except Exception as e:
        print(f"{Colors.RED}❌ Profile error: {e}{Colors.END}")
        return
    
    print(f"\n{Colors.GREEN}🎉 ¡Flujo completo exitoso!{Colors.END}")

def show_menu():
    """Mostrar menú principal"""
    print(f"\n{Colors.CYAN}📋 Selecciona una opción:{Colors.END}\n")
    
    options = [
        ("1", "🏠 Health Check", "Verificar estado del servicio"),
        ("2", "👤 Register User", "Registrar nuevo usuario"),
        ("3", "✅ Verify Email", "Verificar email con código"),
        ("4", "🔑 Login", "Iniciar sesión"),
        ("5", "🔒 Forgot Password", "Solicitar recuperación"),
        ("6", "🔄 Reset Password", "Resetear contraseña"),
        ("7", "👤 Get Profile", "Obtener perfil (requiere token)"),
        ("8", "📊 Service Stats", "Estadísticas del servicio"),
        ("9", "🚀 Complete Flow", "Ejecutar flujo completo"),
        ("0", "❌ Exit", "Salir del programa")
    ]
    
    for num, title, desc in options:
        print(f"   {Colors.BOLD}{num}{Colors.END} - {title}")
        print(f"       {Colors.YELLOW}{desc}{Colors.END}\n")

def main():
    """Función principal"""
    print_header()
    
    print(f"{Colors.GREEN}📡 Auth Service URL: {Colors.BOLD}{AUTH_BASE_URL}{Colors.END}")
    print(f"{Colors.YELLOW}🔧 Asegúrate de que el auth-service esté corriendo{Colors.END}")
    
    # Variables globales para mantener estado
    global test_token, test_email, test_user_id
    test_token = None
    test_email = None
    test_user_id = None
    
    while True:
        show_menu()
        choice = input(f"{Colors.BOLD}Selección: {Colors.END}")
        
        try:
            if choice == "0":
                print(f"{Colors.YELLOW}👋 ¡Hasta luego!{Colors.END}")
                break
            elif choice == "1":
                test_health_check()
            elif choice == "2":
                test_register()
            elif choice == "3":
                test_verify_email()
            elif choice == "4":
                test_login()
            elif choice == "5":
                test_forgot_password()
            elif choice == "6":
                test_reset_password()
            elif choice == "7":
                test_profile()
            elif choice == "8":
                test_stats()
            elif choice == "9":
                run_complete_flow()
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