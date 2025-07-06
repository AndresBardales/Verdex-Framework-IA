# 🚀 Guía para Desarrollador Junior - Asistente Voz Inteligente

## 🎯 ¡Bienvenido al Proyecto!

Eres nuevo en el equipo y esta guía te ayudará a empezar a trabajar con el **Asistente de Voz Inteligente**. Sigue estos pasos paso a paso.

---

## 📱 **PASO 1: Configuración Inicial**

### 🔧 Pre-requisitos
```bash
# Verificar que tienes instalado:
docker --version          # Docker
docker-compose --version  # Docker Compose
flutter --version         # Flutter SDK
python3 --version         # Python 3.8+
```

### 📥 Clonar y Configurar
```bash
# 1. Clonar el repositorio
git clone [URL_DEL_REPO]
cd flutter

# 2. Leer el contexto del sistema (OBLIGATORIO)
cat system_context.md

# 3. Verificar estructura
tree -L 2

# 4. Iniciar servicios
./start-dev.sh
```

---

## 🐳 **PASO 2: Verificar Servicios**

### ✅ Health Check Completo
```bash
# Ejecutar verificación automática
./agent/scripts/health_check.sh

# Verificar manualmente cada servicio:
curl http://localhost:5005/health    # Backend FastAPI
curl http://localhost:8001/          # Auth Service
curl http://localhost:18083         # EMQX Panel (navegador)
curl http://localhost:5678          # n8n (navegador)
```

### 📊 URLs de Servicios
- **Backend API**: http://localhost:5005
- **Auth Service**: http://localhost:8001  
- **EMQX Panel**: http://localhost:18083 (admin/public)
- **n8n Workflows**: http://localhost:5678
- **MongoDB**: localhost:27017

---

## 📱 **PASO 3: Conectar tu Celular**

### 🔧 Configurar Flutter App

1. **Abrir proyecto Flutter:**
```bash
cd audio_recorder_app
flutter pub get
```

2. **Configurar IP del desarrollo:**
```bash
# Editar configuración
nano assets/config/config.json

# Cambiar la IP a tu IP local:
{
  "api_base_url": "http://TU_IP_LOCAL:5005",
  "auth_base_url": "http://TU_IP_LOCAL:8001",
  "mqtt_host": "TU_IP_LOCAL",
  "mqtt_port": 1883
}
```

3. **Obtener tu IP local:**
```bash
# Linux/Mac
ip addr show | grep "inet " | grep -v 127.0.0.1
# o
hostname -I

# Windows
ipconfig | findstr "IPv4"
```

4. **Conectar dispositivo y ejecutar:**
```bash
# Verificar dispositivo conectado
flutter devices

# Ejecutar en dispositivo
flutter run

# O ejecutar en modo debug con logs
flutter run --verbose
```

### 📱 **Primera Prueba**
1. Abre la app en tu celular
2. Registra un usuario nuevo
3. Verifica el código en los logs del backend
4. Graba un audio de prueba
5. Verifica que llegue al backend

---

## 📊 **PASO 4: Monitorear Logs y MQTT**

### 🔍 **Ver Logs en Tiempo Real**

```bash
# Logs de todos los servicios
./scripts/watch-logs.sh

# Logs específicos
docker-compose logs -f backend
docker-compose logs -f auth-service
docker-compose logs -f emqx

# Logs de la app Flutter (desde Android Studio/VS Code)
flutter logs
```

### 📡 **Monitor MQTT (Ver Mensajes en Tiempo Real)**

```bash
# Monitor universal - Ve TODOS los mensajes
python scripts/mqtt-universal-monitor.py

# Monitor específico de usuario
python agent/mqtt-user-monitor.py

# Monitor desde terminal
mosquitto_sub -h localhost -p 1883 -t "#" -v
```

### 🎯 **Qué Buscar en los Logs**

Cuando interactúes con la app, deberías ver:

1. **Registro de usuario**:
```
auth/events: {"action": "register", "user_id": "..."}
```

2. **Grabación de audio**:
```
audios/recordings: {"action": "start", "duration": "..."}
audios/uploads: {"action": "upload", "file_size": "..."}
```

3. **Interacciones UI**:
```
ui/interactions: {"action": "tap", "element": "record_button"}
```

---

## 🧪 **PASO 5: Hacer tu Primera Contribución**

### 🔧 **Protocolo de Desarrollo**

1. **Usar el laboratorio de agentes:**
```bash
# Crear un experimento
cd agent/lab
echo "print('Mi primer experimento')" > mi_test.py
python mi_test.py

# Limpiar después
rm mi_test.py
```

2. **Probar APIs:**
```bash
# Usar el tester de autenticación
python agent/auth-tester.py

# Crear usuarios de prueba
python agent/user-creator.py
```

3. **Documentar cambios:**
```bash
# Si haces cambios importantes, documenta en:
# - 01Doc/ (documentación técnica)
# - last_talk.md (resumen de tu sesión)
```

---

## 🎯 **PASO 6: Flujo de Trabajo Diario**

### 🌅 **Al Comenzar el Día**
```bash
# 1. Revisar contexto
cat system_context.md
cat last_talk.md

# 2. Iniciar servicios
./start-dev.sh

# 3. Health check
./agent/scripts/health_check.sh

# 4. Ver logs de última sesión
ls -la logs/$(date +%Y-%m-%d)/
```

### 🌅 **Durante Desarrollo**
```bash
# Monitor MQTT en una terminal
python scripts/mqtt-universal-monitor.py

# Logs en otra terminal  
./scripts/watch-logs.sh

# Desarrollo de Flutter en otra terminal
cd audio_recorder_app && flutter run
```

### 🌆 **Al Terminar el Día**
```bash
# 1. Documentar lo que hiciste
nano last_talk.md

# 2. Detener servicios
./stop-dev.sh

# 3. Commit si hiciste cambios
git add .
git commit -m "feat: descripción de cambios"
```

---

## 🆘 **TROUBLESHOOTING**

### ❌ **Problemas Comunes**

1. **"No puedo conectar la app al backend"**
```bash
# Verificar IP local
hostname -I

# Verificar que backend esté corriendo
curl http://localhost:5005/health

# Verificar firewall (Linux)
sudo ufw status
```

2. **"No veo mensajes MQTT"**
```bash
# Verificar EMQX
curl http://localhost:18083

# Verificar conexiones
python scripts/mqtt-universal-monitor.py
```

3. **"Flutter no encuentra mi dispositivo"**
```bash
# Verificar USB debugging activado en Android
adb devices

# Permisos de USB (Linux)
sudo usermod -a -G plugdev $USER
```

### 🔧 **Comandos de Rescate**
```bash
# Reiniciar todo desde cero
./stop-dev.sh
docker-compose down -v
./start-dev.sh

# Ver todos los puertos ocupados
netstat -tulpn | grep LISTEN

# Limpiar caché de Flutter
cd audio_recorder_app
flutter clean
flutter pub get
```

---

## 📚 **Recursos Importantes**

### 📖 **Documentación que DEBES leer**
- `system_context.md` - **OBLIGATORIO** (contexto del proyecto)
- `01Doc/Auth-API-Documentation.md` - API de autenticación
- `01Doc/MQTT-Topics-Architecture.md` - Estructura de mensajes
- `agent/README.md` - Herramientas para desarrollo

### 🛠️ **Herramientas Útiles**
- **VS Code Extensions**: Flutter, Docker, Python
- **Android Studio**: Para desarrollo Flutter avanzado
- **Postman**: Para probar APIs
- **MQTT Explorer**: GUI para ver mensajes MQTT

### 🤝 **¿Necesitas Ayuda?**
1. Lee `system_context.md` primero
2. Busca en `01Doc/` la documentación relacionada
3. Prueba en `agent/lab/` antes de hacer cambios
4. Documenta tus experimentos

---

## 🎯 **Tu Primera Misión**

### ✅ **Checklist de Bienvenida**
- [ ] Servicios funcionando (health check ✅)
- [ ] Celular conectado y app funcionando
- [ ] Registro de usuario exitoso
- [ ] Grabación de audio exitosa
- [ ] Logs MQTT visibles
- [ ] Primer experimento en `agent/lab/`
- [ ] Documentación leída

### 🚀 **¡Ahora estás listo para contribuir!**

¿Tienes alguna pregunta? Busca en la documentación o haz un experimento en `agent/lab/` para entender mejor el sistema.

---

*📅 Creado: 2025-07-05*  
*🎯 Tu puerta de entrada al proyecto - ¡Bienvenido al equipo!* 