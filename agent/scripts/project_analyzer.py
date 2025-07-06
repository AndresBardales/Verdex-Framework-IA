#!/usr/bin/env python3
"""
🔍 Analizador de Proyectos - AI Dev Framework
Analiza la estructura actual del proyecto y sugiere mejoras
"""

import os
import json
import yaml
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Tuple
import argparse

class ProjectAnalyzer:
    """Analizador de estructura de proyectos"""
    
    def __init__(self, project_path="."):
        self.project_path = Path(project_path)
        self.analysis_results = {}
        self.recommendations = []
        
    def analyze_project(self) -> Dict:
        """Realizar análisis completo del proyecto"""
        print("🔍 Iniciando análisis del proyecto...")
        
        # Análisis de estructura
        structure_score = self.analyze_directory_structure()
        
        # Análisis de documentación
        docs_score = self.analyze_documentation()
        
        # Análisis de configuración
        config_score = self.analyze_configuration()
        
        # Análisis de scripts y automatización
        automation_score = self.analyze_automation()
        
        # Análisis de git y versionado
        git_score = self.analyze_git_structure()
        
        # Cálculo de score general
        total_score = (structure_score + docs_score + config_score + 
                      automation_score + git_score) / 5
        
        self.analysis_results = {
            'timestamp': datetime.now().isoformat(),
            'project_path': str(self.project_path),
            'scores': {
                'structure': structure_score,
                'documentation': docs_score,
                'configuration': config_score,
                'automation': automation_score,
                'git': git_score,
                'total': total_score
            },
            'recommendations': self.recommendations
        }
        
        return self.analysis_results
    
    def analyze_directory_structure(self) -> float:
        """Analizar estructura de directorios"""
        print("📁 Analizando estructura de directorios...")
        
        score = 0
        max_score = 10
        
        # Verificar directorios esenciales del framework
        essential_dirs = [
            '01Doc',
            'agent',
            'config',
            'logs',
            'scripts'
        ]
        
        existing_dirs = []
        for directory in essential_dirs:
            dir_path = self.project_path / directory
            if dir_path.exists():
                existing_dirs.append(directory)
                score += 1
        
        # Verificar subdirectorios específicos
        subdir_checks = [
            ('01Doc/agents_logs', 'Logs de agentes IA'),
            ('01Doc/versions', 'Control de versiones'),
            ('agent/lab', 'Laboratorio de experimentos'),
            ('agent/scripts', 'Scripts de automatización'),
            ('config', 'Configuración centralizada')
        ]
        
        for subdir, description in subdir_checks:
            if (self.project_path / subdir).exists():
                score += 1
            else:
                self.recommendations.append(f"🔧 Crear directorio {subdir} para {description}")
        
        # Verificar archivos en la raíz
        root_files = list(self.project_path.glob('*'))
        non_essential_files = [f for f in root_files if f.is_file() and 
                              f.name not in ['README.md', 'system_context.md', 'last_talk.md', 
                                           '.gitignore', 'docker-compose.yml', 'requirements.txt',
                                           'package.json', 'setup.py', 'Dockerfile']]
        
        if len(non_essential_files) > 5:
            score -= 1
            self.recommendations.append(f"🧹 Limpiar raíz del proyecto - {len(non_essential_files)} archivos no esenciales")
        
        return min(score, max_score)
    
    def analyze_documentation(self) -> float:
        """Analizar documentación del proyecto"""
        print("📚 Analizando documentación...")
        
        score = 0
        max_score = 10
        
        # Verificar archivos de documentación esenciales
        doc_files = [
            ('README.md', 'Documentación principal'),
            ('system_context.md', 'Contexto del sistema'),
            ('last_talk.md', 'Última conversación'),
            ('01Doc/README.md', 'Índice de documentación'),
            ('01Doc/AI_Agent_System_Message.md', 'Protocolo para agentes')
        ]
        
        for file_path, description in doc_files:
            if (self.project_path / file_path).exists():
                score += 1
            else:
                self.recommendations.append(f"📝 Crear {file_path} - {description}")
        
        # Verificar calidad de documentación
        if (self.project_path / 'README.md').exists():
            readme_content = (self.project_path / 'README.md').read_text()
            if len(readme_content) > 500:
                score += 1
            else:
                self.recommendations.append("📝 Expandir README.md con más detalles")
        
        # Verificar logs de agentes
        agents_logs_dir = self.project_path / '01Doc/agents_logs'
        if agents_logs_dir.exists():
            log_files = list(agents_logs_dir.glob('session_*.md'))
            if len(log_files) > 0:
                score += 1
            else:
                self.recommendations.append("🤖 Crear logs de sesiones con agentes IA")
        
        # Verificar control de versiones
        versions_dir = self.project_path / '01Doc/versions'
        if versions_dir.exists():
            version_files = list(versions_dir.glob('*.md'))
            if len(version_files) > 0:
                score += 1
            else:
                self.recommendations.append("📋 Implementar control de versiones de documentación")
        
        # Verificar documentación técnica
        tech_docs = ['API_Documentation.md', 'Technical_Architecture.md', 'Configuration_Guide.md']
        tech_doc_count = sum(1 for doc in tech_docs if (self.project_path / '01Doc' / doc).exists())
        score += min(tech_doc_count, 2)
        
        return min(score, max_score)
    
    def analyze_configuration(self) -> float:
        """Analizar configuración del proyecto"""
        print("⚙️ Analizando configuración...")
        
        score = 0
        max_score = 10
        
        # Verificar archivos de configuración
        config_files = [
            ('config/framework_config.yaml', 'Configuración del framework'),
            ('config/logging_config.json', 'Configuración de logging'),
            ('config/atlassian_integration.yaml', 'Integración con Atlassian'),
            ('.env.example', 'Ejemplo de variables de entorno'),
            ('.gitignore', 'Configuración de Git')
        ]
        
        for file_path, description in config_files:
            if (self.project_path / file_path).exists():
                score += 1
            else:
                self.recommendations.append(f"⚙️ Crear {file_path} - {description}")
        
        # Verificar configuración de Docker
        docker_files = ['docker-compose.yml', 'Dockerfile']
        docker_count = sum(1 for f in docker_files if (self.project_path / f).exists())
        if docker_count > 0:
            score += 1
        else:
            self.recommendations.append("🐳 Configurar Docker para desarrollo")
        
        # Verificar configuración de dependencias
        dep_files = ['requirements.txt', 'package.json', 'pubspec.yaml', 'setup.py']
        dep_count = sum(1 for f in dep_files if (self.project_path / f).exists())
        if dep_count > 0:
            score += 1
        else:
            self.recommendations.append("📦 Configurar gestión de dependencias")
        
        # Verificar configuración de CI/CD
        ci_dirs = ['.github/workflows', '.gitlab-ci.yml', 'azure-pipelines.yml']
        ci_count = sum(1 for d in ci_dirs if (self.project_path / d).exists())
        if ci_count > 0:
            score += 1
        else:
            self.recommendations.append("🔄 Configurar CI/CD")
        
        return min(score, max_score)
    
    def analyze_automation(self) -> float:
        """Analizar scripts y automatización"""
        print("🤖 Analizando automatización...")
        
        score = 0
        max_score = 10
        
        # Verificar scripts esenciales
        essential_scripts = [
            ('agent/scripts/health_check.sh', 'Health check del sistema'),
            ('agent/scripts/create_session_log.sh', 'Crear log de sesión'),
            ('scripts/setup_project.sh', 'Configuración del proyecto'),
            ('agent/tools/rovo_cli_wrapper.py', 'Wrapper de Rovo CLI')
        ]
        
        for script_path, description in essential_scripts:
            if (self.project_path / script_path).exists():
                score += 1
            else:
                self.recommendations.append(f"🔧 Crear {script_path} - {description}")
        
        # Verificar scripts de desarrollo
        dev_scripts = ['start-dev.sh', 'stop-dev.sh', 'restart.sh']
        dev_count = sum(1 for s in dev_scripts if (self.project_path / s).exists())
        if dev_count > 0:
            score += 1
        else:
            self.recommendations.append("🚀 Crear scripts de desarrollo (start, stop, restart)")
        
        # Verificar herramientas de agentes
        agent_tools_dir = self.project_path / 'agent/tools'
        if agent_tools_dir.exists():
            tools = list(agent_tools_dir.glob('*.py'))
            if len(tools) > 0:
                score += 1
            else:
                self.recommendations.append("🛠️ Crear herramientas para agentes IA")
        
        # Verificar laboratorio de experimentos
        lab_dir = self.project_path / 'agent/lab'
        if lab_dir.exists():
            if (lab_dir / 'README.md').exists():
                score += 1
            else:
                self.recommendations.append("🧪 Configurar laboratorio de experimentos")
        
        return min(score, max_score)
    
    def analyze_git_structure(self) -> float:
        """Analizar estructura de Git"""
        print("🔄 Analizando estructura de Git...")
        
        score = 0
        max_score = 10
        
        # Verificar si es un repositorio Git
        if (self.project_path / '.git').exists():
            score += 2
            
            # Verificar .gitignore
            if (self.project_path / '.gitignore').exists():
                score += 1
            else:
                self.recommendations.append("📝 Crear .gitignore apropiado")
            
            # Verificar estructura de branches
            try:
                import subprocess
                result = subprocess.run(['git', 'branch', '-r'], 
                                      cwd=self.project_path, 
                                      capture_output=True, text=True)
                if result.returncode == 0:
                    branches = result.stdout.strip().split('\n')
                    if len(branches) > 1:
                        score += 1
                    else:
                        self.recommendations.append("🌿 Configurar estrategia de branches")
            except:
                pass
            
            # Verificar README
            if (self.project_path / 'README.md').exists():
                score += 1
            
            # Verificar commits recientes
            try:
                result = subprocess.run(['git', 'log', '--oneline', '-10'], 
                                      cwd=self.project_path, 
                                      capture_output=True, text=True)
                if result.returncode == 0:
                    commits = result.stdout.strip().split('\n')
                    if len(commits) >= 5:
                        score += 1
                    else:
                        self.recommendations.append("📝 Mantener historial de commits consistente")
            except:
                pass
                
        else:
            self.recommendations.append("🔄 Inicializar repositorio Git")
        
        return min(score, max_score)
    
    def get_technology_stack(self) -> List[str]:
        """Detectar stack tecnológico del proyecto"""
        technologies = []
        
        # Python
        if (self.project_path / 'requirements.txt').exists() or \
           (self.project_path / 'setup.py').exists():
            technologies.append('Python')
        
        # Node.js
        if (self.project_path / 'package.json').exists():
            technologies.append('Node.js')
        
        # Flutter/Dart
        if (self.project_path / 'pubspec.yaml').exists():
            technologies.append('Flutter/Dart')
        
        # Java
        if (self.project_path / 'pom.xml').exists() or \
           (self.project_path / 'build.gradle').exists():
            technologies.append('Java')
        
        # Docker
        if (self.project_path / 'docker-compose.yml').exists() or \
           (self.project_path / 'Dockerfile').exists():
            technologies.append('Docker')
        
        # React
        if (self.project_path / 'package.json').exists():
            try:
                with open(self.project_path / 'package.json', 'r') as f:
                    package_data = json.load(f)
                    if 'react' in package_data.get('dependencies', {}):
                        technologies.append('React')
            except:
                pass
        
        return technologies
    
    def generate_migration_plan(self) -> str:
        """Generar plan de migración al framework"""
        plan = f"""# 🚀 Plan de Migración al AI Dev Framework

## 📊 Análisis del Proyecto
- **Fecha**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
- **Ruta**: {self.project_path}
- **Score Total**: {self.analysis_results['scores']['total']:.1f}/10

## 🎯 Tecnologías Detectadas
{', '.join(self.get_technology_stack()) if self.get_technology_stack() else 'No detectadas automáticamente'}

## 📋 Recomendaciones Prioritarias

### 🔴 Alta Prioridad
"""
        high_priority = [rec for rec in self.recommendations if '🔧' in rec or '📝' in rec]
        for rec in high_priority[:5]:
            plan += f"- {rec}\n"
        
        plan += """
### 🟡 Media Prioridad
"""
        medium_priority = [rec for rec in self.recommendations if '🛠️' in rec or '⚙️' in rec]
        for rec in medium_priority[:5]:
            plan += f"- {rec}\n"
        
        plan += """
### 🟢 Baja Prioridad
"""
        low_priority = [rec for rec in self.recommendations if rec not in high_priority and rec not in medium_priority]
        for rec in low_priority[:5]:
            plan += f"- {rec}\n"
        
        plan += f"""
## 🛠️ Pasos de Implementación

### 1. Preparación
```bash
# Crear backup del proyecto
cp -r {self.project_path} {self.project_path}_backup

# Instalar framework
curl -fsSL https://raw.githubusercontent.com/ai-dev-framework/core/main/install.sh | bash
```

### 2. Configuración Inicial
```bash
# Ejecutar configuración
./scripts/setup_project.sh

# Verificar instalación
./agent/scripts/health_check.sh
```

### 3. Migración de Documentación
```bash
# Mover documentación existente
mkdir -p 01Doc/legacy
mv *.md 01Doc/legacy/ 2>/dev/null || true

# Crear nuevos archivos de documentación
./agent/scripts/create_session_log.sh migration
```

### 4. Verificación
```bash
# Verificar estructura
tree -L 3

# Ejecutar análisis nuevamente
python agent/scripts/project_analyzer.py --report
```

## 📊 Métricas Esperadas
- **Score Objetivo**: 8.5/10
- **Tiempo Estimado**: 2-4 horas
- **Beneficios**: Documentación automática, mejor organización, colaboración con IA

---
*Plan generado automáticamente por AI Dev Framework*
"""
        
        return plan
    
    def save_analysis(self, output_file="project_analysis.json"):
        """Guardar análisis en archivo JSON"""
        output_path = self.project_path / output_file
        with open(output_path, 'w') as f:
            json.dump(self.analysis_results, f, indent=2)
        print(f"✅ Análisis guardado en {output_path}")
    
    def generate_report(self) -> str:
        """Generar reporte detallado"""
        if not self.analysis_results:
            self.analyze_project()
        
        scores = self.analysis_results['scores']
        
        report = f"""# 📊 Reporte de Análisis - AI Dev Framework

## 📋 Resumen Ejecutivo
- **Proyecto**: {self.project_path}
- **Fecha**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
- **Score Total**: {scores['total']:.1f}/10

## 🎯 Puntuaciones Detalladas

### 📁 Estructura de Directorios: {scores['structure']:.1f}/10
{'🟢 Excelente' if scores['structure'] >= 8 else '🟡 Necesita mejoras' if scores['structure'] >= 5 else '🔴 Crítico'}

### 📚 Documentación: {scores['documentation']:.1f}/10
{'🟢 Excelente' if scores['documentation'] >= 8 else '🟡 Necesita mejoras' if scores['documentation'] >= 5 else '🔴 Crítico'}

### ⚙️ Configuración: {scores['configuration']:.1f}/10
{'🟢 Excelente' if scores['configuration'] >= 8 else '🟡 Necesita mejoras' if scores['configuration'] >= 5 else '🔴 Crítico'}

### 🤖 Automatización: {scores['automation']:.1f}/10
{'🟢 Excelente' if scores['automation'] >= 8 else '🟡 Necesita mejoras' if scores['automation'] >= 5 else '🔴 Crítico'}

### 🔄 Git: {scores['git']:.1f}/10
{'🟢 Excelente' if scores['git'] >= 8 else '🟡 Necesita mejoras' if scores['git'] >= 5 else '🔴 Crítico'}

## 🎯 Recomendaciones ({len(self.recommendations)} total)

"""
        
        for i, rec in enumerate(self.recommendations, 1):
            report += f"{i}. {rec}\n"
        
        report += f"""
## 🚀 Próximos Pasos

### Migración Inmediata
1. Instalar AI Dev Framework
2. Crear estructura de directorios
3. Migrar documentación existente

### Configuración
1. Configurar integraciones (Jira, Confluence)
2. Crear scripts de automatización
3. Configurar logging centralizado

### Optimización
1. Implementar workflows con agentes IA
2. Configurar métricas y análisis
3. Automatizar documentación

---
*Análisis realizado por AI Dev Framework Analyzer*
"""
        
        return report


def main():
    """Función principal"""
    parser = argparse.ArgumentParser(description='Analizador de Proyectos - AI Dev Framework')
    parser.add_argument('--path', '-p', default='.', help='Ruta del proyecto a analizar')
    parser.add_argument('--report', '-r', action='store_true', help='Generar reporte detallado')
    parser.add_argument('--migration-plan', '-m', action='store_true', help='Generar plan de migración')
    parser.add_argument('--save', '-s', action='store_true', help='Guardar análisis en JSON')
    parser.add_argument('--output', '-o', default='project_analysis.json', help='Archivo de salida')
    
    args = parser.parse_args()
    
    analyzer = ProjectAnalyzer(args.path)
    
    # Realizar análisis
    results = analyzer.analyze_project()
    
    print("\n" + "="*70)
    print(f"🎯 ANÁLISIS COMPLETADO - Score: {results['scores']['total']:.1f}/10")
    print("="*70)
    
    if args.report:
        report = analyzer.generate_report()
        print(report)
    
    if args.migration_plan:
        plan = analyzer.generate_migration_plan()
        print(plan)
        
        # Guardar plan
        plan_file = Path(args.path) / 'MIGRATION_PLAN.md'
        with open(plan_file, 'w') as f:
            f.write(plan)
        print(f"\n✅ Plan de migración guardado en {plan_file}")
    
    if args.save:
        analyzer.save_analysis(args.output)
    
    # Mostrar resumen
    print(f"\n📊 Resumen:")
    print(f"   • Estructura: {results['scores']['structure']:.1f}/10")
    print(f"   • Documentación: {results['scores']['documentation']:.1f}/10")
    print(f"   • Configuración: {results['scores']['configuration']:.1f}/10")
    print(f"   • Automatización: {results['scores']['automation']:.1f}/10")
    print(f"   • Git: {results['scores']['git']:.1f}/10")
    print(f"\n🎯 Recomendaciones: {len(results['recommendations'])}")
    
    if results['scores']['total'] < 7:
        print("\n💡 Recomendamos instalar el AI Dev Framework para mejorar la estructura del proyecto")


if __name__ == "__main__":
    main() 