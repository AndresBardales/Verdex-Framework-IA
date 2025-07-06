#!/usr/bin/env python3
"""
🤖 Rovo CLI Wrapper para AI Dev Framework
Wrapper inteligente para interactuar con Atlassian Rovo CLI
"""

import os
import sys
import json
import subprocess
import argparse
from datetime import datetime
from pathlib import Path
import yaml

class RovoCLIWrapper:
    """Wrapper para Rovo CLI con funciones inteligentes"""
    
    def __init__(self, config_file="config/atlassian_integration.yaml"):
        """Inicializar wrapper con configuración"""
        self.config_file = config_file
        self.config = self.load_config()
        self.rovo_cmd = self.config.get('rovo', {}).get('cli_path', 'rovo')
        
    def load_config(self):
        """Cargar configuración de Atlassian"""
        try:
            with open(self.config_file, 'r') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            print(f"⚠️  Archivo de configuración no encontrado: {self.config_file}")
            return {}
    
    def check_rovo_availability(self):
        """Verificar si Rovo CLI está disponible"""
        try:
            result = subprocess.run([self.rovo_cmd, '--version'], 
                                 capture_output=True, text=True)
            return result.returncode == 0
        except FileNotFoundError:
            return False
    
    def get_project_context(self):
        """Obtener contexto del proyecto actual"""
        context = {}
        
        # Leer system_context.md
        if os.path.exists('system_context.md'):
            with open('system_context.md', 'r') as f:
                context['system_context'] = f.read()
        
        # Leer last_talk.md
        if os.path.exists('last_talk.md'):
            with open('last_talk.md', 'r') as f:
                context['last_talk'] = f.read()
        
        # Obtener configuración del proyecto
        if os.path.exists('config/framework_config.yaml'):
            with open('config/framework_config.yaml', 'r') as f:
                context['framework_config'] = yaml.safe_load(f)
        
        return context
    
    def create_jira_issue(self, summary, description, issue_type="Task"):
        """Crear issue en Jira usando Rovo CLI"""
        if not self.check_rovo_availability():
            print("❌ Rovo CLI no está disponible")
            return None
            
        jira_config = self.config.get('jira', {})
        project_key = jira_config.get('project_key', '')
        
        if not project_key:
            print("❌ Proyecto Jira no configurado")
            return None
        
        try:
            # Comando para crear issue
            cmd = [
                self.rovo_cmd, 'jira', 'workitem', 'create',
                '--summary', summary,
                '--project', project_key,
                '--type', issue_type,
                '--description', description
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"✅ Issue creado exitosamente: {summary}")
                return result.stdout
            else:
                print(f"❌ Error creando issue: {result.stderr}")
                return None
                
        except Exception as e:
            print(f"❌ Error ejecutando Rovo CLI: {str(e)}")
            return None
    
    def create_confluence_page(self, title, content, space_key=None):
        """Crear página en Confluence usando Rovo CLI"""
        if not self.check_rovo_availability():
            print("❌ Rovo CLI no está disponible")
            return None
            
        confluence_config = self.config.get('confluence', {})
        space_key = space_key or confluence_config.get('space_key', '')
        
        if not space_key:
            print("❌ Espacio Confluence no configurado")
            return None
        
        try:
            # Crear archivo temporal con el contenido
            temp_file = f"/tmp/confluence_content_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
            with open(temp_file, 'w') as f:
                f.write(content)
            
            # Comando para crear página
            cmd = [
                self.rovo_cmd, 'confluence', 'page', 'create',
                '--title', title,
                '--space', space_key,
                '--content-file', temp_file
            ]
            
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            # Limpiar archivo temporal
            os.remove(temp_file)
            
            if result.returncode == 0:
                print(f"✅ Página Confluence creada: {title}")
                return result.stdout
            else:
                print(f"❌ Error creando página: {result.stderr}")
                return None
                
        except Exception as e:
            print(f"❌ Error ejecutando Rovo CLI: {str(e)}")
            return None
    
    def sync_documentation(self):
        """Sincronizar documentación local con Confluence"""
        print("🔄 Sincronizando documentación con Confluence...")
        
        docs_dir = Path('01Doc')
        if not docs_dir.exists():
            print("❌ Directorio 01Doc no encontrado")
            return False
        
        sync_count = 0
        
        # Sincronizar archivos markdown principales
        for md_file in docs_dir.glob('*.md'):
            if md_file.name.startswith('_'):
                continue  # Omitir archivos privados
            
            print(f"📄 Sincronizando {md_file.name}...")
            
            with open(md_file, 'r') as f:
                content = f.read()
            
            # Crear página en Confluence
            title = md_file.stem.replace('_', ' ').title()
            if self.create_confluence_page(title, content):
                sync_count += 1
        
        print(f"✅ {sync_count} documentos sincronizados")
        return sync_count > 0
    
    def generate_project_report(self):
        """Generar reporte del proyecto usando contexto"""
        context = self.get_project_context()
        
        report = f"""# 📊 Reporte del Proyecto - {datetime.now().strftime('%Y-%m-%d')}

## 🎯 Información General
- **Fecha**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
- **Framework**: AI Dev Framework v1.0.0

## 📋 Estado del Proyecto
"""
        
        # Agregar información del framework_config si existe
        if 'framework_config' in context:
            config = context['framework_config']
            report += f"""
### ⚙️ Configuración
- **Nombre**: {config.get('project', {}).get('name', 'N/A')}
- **Tipo**: {config.get('project', {}).get('type', 'N/A')}
- **Etapa**: {config.get('project', {}).get('stage', 'N/A')}
"""
        
        # Agregar resumen de última conversación
        if 'last_talk' in context:
            last_talk = context['last_talk'][:500]  # Primeros 500 caracteres
            report += f"""
### 💬 Última Actividad
```
{last_talk}...
```
"""
        
        # Agregar estadísticas de archivos
        stats = self.get_project_stats()
        report += f"""
### 📊 Estadísticas
- **Archivos de documentación**: {stats.get('doc_files', 0)}
- **Logs de agentes**: {stats.get('agent_logs', 0)}
- **Scripts**: {stats.get('scripts', 0)}
"""
        
        return report
    
    def get_project_stats(self):
        """Obtener estadísticas del proyecto"""
        stats = {
            'doc_files': 0,
            'agent_logs': 0,
            'scripts': 0
        }
        
        # Contar archivos de documentación
        docs_dir = Path('01Doc')
        if docs_dir.exists():
            stats['doc_files'] = len(list(docs_dir.glob('*.md')))
        
        # Contar logs de agentes
        logs_dir = Path('01Doc/agents_logs')
        if logs_dir.exists():
            stats['agent_logs'] = len(list(logs_dir.glob('session_*.md')))
        
        # Contar scripts
        scripts_dir = Path('agent/scripts')
        if scripts_dir.exists():
            stats['scripts'] = len(list(scripts_dir.glob('*.sh'))) + len(list(scripts_dir.glob('*.py')))
        
        return stats
    
    def interactive_mode(self):
        """Modo interactivo para usar Rovo CLI"""
        print("🤖 Modo interactivo Rovo CLI")
        print("Comandos disponibles:")
        print("  1. create-issue - Crear issue en Jira")
        print("  2. create-page - Crear página en Confluence")
        print("  3. sync-docs - Sincronizar documentación")
        print("  4. report - Generar reporte del proyecto")
        print("  5. exit - Salir")
        
        while True:
            try:
                choice = input("\n🎯 Selecciona una opción: ").strip()
                
                if choice == '1' or choice == 'create-issue':
                    summary = input("📝 Resumen del issue: ")
                    description = input("📄 Descripción: ")
                    self.create_jira_issue(summary, description)
                    
                elif choice == '2' or choice == 'create-page':
                    title = input("📝 Título de la página: ")
                    content = input("📄 Contenido (o ruta al archivo): ")
                    if os.path.exists(content):
                        with open(content, 'r') as f:
                            content = f.read()
                    self.create_confluence_page(title, content)
                    
                elif choice == '3' or choice == 'sync-docs':
                    self.sync_documentation()
                    
                elif choice == '4' or choice == 'report':
                    report = self.generate_project_report()
                    print(report)
                    
                elif choice == '5' or choice == 'exit':
                    print("👋 ¡Hasta luego!")
                    break
                    
                else:
                    print("❌ Opción inválida")
                    
            except KeyboardInterrupt:
                print("\n👋 ¡Hasta luego!")
                break
            except Exception as e:
                print(f"❌ Error: {str(e)}")


def main():
    """Función principal"""
    parser = argparse.ArgumentParser(description='Rovo CLI Wrapper para AI Dev Framework')
    parser.add_argument('--interactive', '-i', action='store_true', help='Modo interactivo')
    parser.add_argument('--create-issue', help='Crear issue en Jira')
    parser.add_argument('--create-page', help='Crear página en Confluence')
    parser.add_argument('--sync-docs', action='store_true', help='Sincronizar documentación')
    parser.add_argument('--report', action='store_true', help='Generar reporte del proyecto')
    parser.add_argument('--check', action='store_true', help='Verificar disponibilidad de Rovo CLI')
    
    args = parser.parse_args()
    
    wrapper = RovoCLIWrapper()
    
    if args.check:
        if wrapper.check_rovo_availability():
            print("✅ Rovo CLI está disponible")
        else:
            print("❌ Rovo CLI no está disponible")
            print("💡 Instala Rovo CLI: https://developer.atlassian.com/platform/rovo/")
        return
    
    if args.interactive:
        wrapper.interactive_mode()
    elif args.create_issue:
        description = input("📄 Descripción del issue: ")
        wrapper.create_jira_issue(args.create_issue, description)
    elif args.create_page:
        content = input("📄 Contenido de la página: ")
        wrapper.create_confluence_page(args.create_page, content)
    elif args.sync_docs:
        wrapper.sync_documentation()
    elif args.report:
        report = wrapper.generate_project_report()
        print(report)
    else:
        wrapper.interactive_mode()


if __name__ == "__main__":
    main() 