# 🔐 **Auth Service API Documentation - Asistente Voz Realtime v1.0**

## 📡 **Información General**

### **🌐 Base URL**
```
http://192.168.3.3:8001
```

### **🔧 Configuración**
- **Puerto**: `8001`
- **Base de datos**: `MongoDB - auth_db`
- **Token**: JWT con expiración de 7 días
- **Email**: Simulado en desarrollo (logs)

### **🎯 Funcionalidades**
- ✅ Registro de usuarios con validación de email
- ✅ Login con JWT tokens
- ✅ Verificación de email con códigos de 6 dígitos
- ✅ Recuperación de contraseña
- ✅ Perfil de usuario protegido
- ✅ Estadísticas del servicio

---

## 📖 **Endpoints**

### **🏠 1. Health Check**
**GET** `/`

**Descripción**: Verificar estado del servicio

**Response**:
```json
{
  "service": "🔐 Auth Service",
  "status": "healthy", 
  "version": "1.0.0",
  "timestamp": "2024-01-26T14:30:52.123456"
}
```

**Ejemplo**:
```bash
curl -X GET http://192.168.3.3:8001/
```

---

### **👤 2. Registro de Usuario**
**POST** `/register`

**Descripción**: Registrar un nuevo usuario y enviar código de verificación

**Body (JSON)**:
```json
{
  "email": "usuario@example.com",
  "password": "miPassword123",
  "full_name": "Juan Pérez"
}
```

**Validaciones**:
- Email válido y único
- Contraseña: mínimo 8 caracteres, letras y números
- Nombre completo requerido

**Response Success (201)**:
```json
{
  "success": true,
  "message": "Usuario registrado exitosamente. Revisa tu email para el código de verificación.",
  "user_id": "user_abc12345",
  "verification_required": true
}
```

**Response Error (400)**:
```json
{
  "detail": "El email ya está registrado"
}
```

**Ejemplo**:
```bash
curl -X POST http://192.168.3.3:8001/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testPass123",
    "full_name": "Usuario Test"
  }'
```

---

### **✅ 3. Verificación de Email**
**POST** `/verify-email`

**Descripción**: Verificar email con código de 6 dígitos

**Body (JSON)**:
```json
{
  "email": "usuario@example.com",
  "code": "123456"
}
```

**Response Success (200)**:
```json
{
  "success": true,
  "message": "Email verificado exitosamente. Ya puedes iniciar sesión."
}
```

**Response Error (400)**:
```json
{
  "detail": "Código inválido o expirado"
}
```

**Ejemplo**:
```bash
curl -X POST http://192.168.3.3:8001/verify-email \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "code": "123456"
  }'
```

---

### **🔑 4. Login**
**POST** `/login`

**Descripción**: Iniciar sesión y obtener JWT token

**Body (JSON)**:
```json
{
  "email": "usuario@example.com",
  "password": "miPassword123"
}
```

**Response Success (200)**:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "user": {
    "user_id": "user_abc12345",
    "email": "usuario@example.com",
    "full_name": "Juan Pérez",
    "is_verified": true,
    "created_at": "2024-01-26T14:30:52.123456",
    "last_login": "2024-01-26T15:45:30.789012"
  }
}
```

**Response Error (401)**:
```json
{
  "detail": "Credenciales inválidas"
}
```

**Response Error (401) - Email no verificado**:
```json
{
  "detail": "Debes verificar tu email antes de iniciar sesión"
}
```

**Ejemplo**:
```bash
curl -X POST http://192.168.3.3:8001/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testPass123"
  }'
```

---

### **🔒 5. Solicitar Recuperación de Contraseña**
**POST** `/forgot-password`

**Descripción**: Enviar código de recuperación por email

**Body (JSON)**:
```json
{
  "email": "usuario@example.com"
}
```

**Response Success (200)**:
```json
{
  "success": true,
  "message": "Si el email existe, recibirás un código de recuperación."
}
```

**Ejemplo**:
```bash
curl -X POST http://192.168.3.3:8001/forgot-password \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com"
  }'
```

---

### **🔄 6. Resetear Contraseña**
**POST** `/reset-password`

**Descripción**: Cambiar contraseña con código de recuperación

**Body (JSON)**:
```json
{
  "email": "usuario@example.com",
  "code": "654321",
  "new_password": "nuevaPassword456"
}
```

**Response Success (200)**:
```json
{
  "success": true,
  "message": "Contraseña actualizada exitosamente."
}
```

**Response Error (400)**:
```json
{
  "detail": "Código inválido o expirado"
}
```

**Ejemplo**:
```bash
curl -X POST http://192.168.3.3:8001/reset-password \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "code": "654321",
    "new_password": "newTestPass123"
  }'
```

---

### **👤 7. Perfil de Usuario (Protegido)**
**GET** `/profile`

**Descripción**: Obtener información del usuario autenticado

**Headers**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Response Success (200)**:
```json
{
  "user_id": "user_abc12345",
  "email": "usuario@example.com", 
  "full_name": "Juan Pérez",
  "is_verified": true,
  "created_at": "2024-01-26T14:30:52.123456",
  "last_login": "2024-01-26T15:45:30.789012"
}
```

**Response Error (401)**:
```json
{
  "detail": "Token requerido"
}
```

**Ejemplo**:
```bash
curl -X GET http://192.168.3.3:8001/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### **📊 8. Estadísticas del Servicio**
**GET** `/stats`

**Descripción**: Obtener estadísticas generales del servicio

**Response Success (200)**:
```json
{
  "total_users": 25,
  "verified_users": 20,
  "pending_verification": 5,
  "recent_registrations_7days": 8,
  "verification_rate": 80.0
}
```

**Ejemplo**:
```bash
curl -X GET http://192.168.3.3:8001/stats
```

---

## 🔄 **Flujo de Uso Completo**

### **📝 1. Registro + Verificación**
```bash
# 1. Registrar usuario
curl -X POST http://192.168.3.3:8001/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"testPass123","full_name":"Test User"}'

# 2. Verificar email (revisar logs para obtener código)
curl -X POST http://192.168.3.3:8001/verify-email \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","code":"123456"}'
```

### **🔑 2. Login + Uso del Token**
```bash
# 1. Login
RESPONSE=$(curl -X POST http://192.168.3.3:8001/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"testPass123"}')

# 2. Extraer token (ejemplo con jq)
TOKEN=$(echo $RESPONSE | jq -r '.access_token')

# 3. Usar token para acceder al perfil
curl -X GET http://192.168.3.3:8001/profile \
  -H "Authorization: Bearer $TOKEN"
```

### **🔒 3. Recuperación de Contraseña**
```bash
# 1. Solicitar reset
curl -X POST http://192.168.3.3:8001/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}'

# 2. Reset con código (revisar logs para código)
curl -X POST http://192.168.3.3:8001/reset-password \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","code":"654321","new_password":"newPassword123"}'
```

---

## 📱 **Integración con Flutter**

### **🔧 Configuración en Flutter**
```dart
// En config.json
{
  "auth_base_url": "http://192.168.3.3:8001",
  "endpoints": {
    "register": "/register",
    "verify_email": "/verify-email", 
    "login": "/login",
    "forgot_password": "/forgot-password",
    "reset_password": "/reset-password",
    "profile": "/profile"
  }
}
```

### **📊 Ejemplo de Uso en Dart**
```dart
// Registro
final response = await http.post(
  Uri.parse('${config.authBaseUrl}/register'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'email': email,
    'password': password,
    'full_name': fullName,
  }),
);

// Login
final loginResponse = await http.post(
  Uri.parse('${config.authBaseUrl}/login'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'email': email,
    'password': password,
  }),
);

// Usar token en requests
final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
};
```

---

## 🌐 **Topics MQTT por Usuario**

Una vez autenticado, el `user_id` se usa para los topics MQTT:

### **📡 Estructura de Topics**
```
audio/transcription/{user_id}  # Ej: audio/transcription/user_abc12345
audio/status/{user_id}         # Ej: audio/status/user_abc12345  
audio/notification/{user_id}   # Ej: audio/notification/user_abc12345
audio/task/{user_id}           # Ej: audio/task/user_abc12345
audio/emotion/{user_id}        # Ej: audio/emotion/user_abc12345
audio/flutter/{user_id}        # Ej: audio/flutter/user_abc12345
```

### **🔗 Conexión del Flujo**
1. **Usuario se registra y verifica** → Obtiene `user_id`
2. **App Flutter usa user_id** → Para suscribirse a topics específicos
3. **Backend usa user_id** → Para enviar mensajes al usuario correcto
4. **Monitor universal** → Sigue capturando con wildcard `audio/*`

---

## 🛠️ **Base de Datos**

### **👥 Colección `users`**
```json
{
  "_id": ObjectId("..."),
  "user_id": "user_abc12345",
  "email": "usuario@example.com",
  "password": "salt:hashedpassword",
  "full_name": "Juan Pérez",
  "is_verified": true,
  "created_at": ISODate("2024-01-26T14:30:52.123Z"),
  "last_login": ISODate("2024-01-26T15:45:30.789Z")
}
```

### **📧 Colección `verification_codes`**
```json
{
  "_id": ObjectId("..."),
  "email": "usuario@example.com",
  "code": "123456",
  "expires_at": ISODate("2024-01-26T14:45:52.123Z")
}
```

### **🔑 Colección `password_resets`**
```json
{
  "_id": ObjectId("..."),
  "email": "usuario@example.com",
  "code": "654321",
  "expires_at": ISODate("2024-01-26T15:00:52.123Z")
}
```

---

## 🚨 **Códigos de Error**

| Código | Descripción | Ejemplo |
|--------|-------------|---------|
| 200 | Éxito | Login exitoso |
| 201 | Creado | Usuario registrado |
| 400 | Bad Request | Email ya existe, contraseña débil |
| 401 | No autorizado | Credenciales inválidas, token expirado |
| 404 | No encontrado | Usuario no existe |
| 500 | Error interno | Error de base de datos |

---

## 🧪 **Testing**

### **🔧 Herramientas en `/agent`**
- `auth-tester.py` - Probador interactivo de todos los endpoints
- `user-creator.py` - Creador automático de usuarios de prueba
- `mqtt-user-monitor.py` - Monitor específico por usuario

### **📋 Casos de Prueba**
1. ✅ Registro con email válido
2. ✅ Registro con email duplicado (error)
3. ✅ Verificación con código correcto
4. ✅ Verificación con código expirado (error)
5. ✅ Login con credenciales correctas
6. ✅ Login sin verificar email (error)
7. ✅ Recuperación de contraseña
8. ✅ Reset con código válido
9. ✅ Acceso a perfil con token válido
10. ✅ Acceso a perfil con token expirado (error)

---

*📅 Última actualización: 2024-01-26*  
*🔄 Este documento se mantiene sincronizado con el código del servicio* 