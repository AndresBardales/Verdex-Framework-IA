# 🧪 Laboratorio de Experimentos - Agent Lab

## 🎯 Propósito
Este directorio está destinado a **experimentos temporales** y **pruebas destructivas** que realizan los agentes IA durante el desarrollo.

## 📋 Reglas de Uso

### ✅ Permitido
- Scripts de prueba temporal
- Experimentos con nuevas funcionalidades
- Prototipos que pueden fallar
- Archivos de configuración de prueba
- Datos de muestra para testing

### ❌ No Permitido  
- Código productivo
- Archivos permanentes
- Configuraciones críticas
- Documentación oficial

## 🧹 Limpieza Automática
- Los archivos en este directorio pueden ser eliminados automáticamente
- No guardes nada importante aquí
- Usa `.gitignore` para evitar commits accidentales

## 🔗 Directorios Relacionados
- `../scripts/` - Scripts de automatización estables
- `../tools/` - Herramientas utilitarias permanentes  
- `../examples/` - Ejemplos de código documentados
- `../../01Doc/lab/` - Documentación experimental

## 💡 Ejemplos de Uso
```bash
# Crear un experimento temporal
echo "print('Hello Lab!')" > agent/lab/test_experiment.py

# Ejecutar prueba destructiva
python agent/lab/test_experiment.py

# Limpiar al terminar
rm agent/lab/test_experiment.py
```

---
*📅 Creado: 2025-07-05*  
*🤖 Para uso exclusivo de agentes IA y desarrollo experimental* 