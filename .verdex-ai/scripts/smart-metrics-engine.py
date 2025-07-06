#!/usr/bin/env python3

"""
📊 Verdex Framework IA - Smart Metrics Engine
Sistema de métricas automáticas que aprende patrones y se auto-alimenta
"""

import json
import os
import sys
import re
import subprocess
from datetime import datetime, timedelta
from collections import Counter, defaultdict
from pathlib import Path
import yaml
from typing import Dict, List, Any, Optional

class VerdexMetricsEngine:
    def __init__(self):
        self.framework_dir = Path(".verdex-ai")
        self.sessions_dir = self.framework_dir / "sessions"
        self.metrics_file = self.sessions_dir / "smart-metrics.json"
        self.patterns_file = self.sessions_dir / "user-patterns.json"
        self.agent_log = self.sessions_dir / "agent-interactions.log"
        self.chat_log = self.sessions_dir / "chat-documentation.md"
        
        # Ensure directories exist
        self.sessions_dir.mkdir(parents=True, exist_ok=True)
        
        self.metrics = self.load_metrics()
        self.patterns = self.load_patterns()

    def load_metrics(self) -> Dict[str, Any]:
        """Cargar métricas existentes o crear estructura inicial"""
        if self.metrics_file.exists():
            with open(self.metrics_file, 'r') as f:
                return json.load(f)
        
        return {
            "productivity": {
                "daily_commits": {},
                "weekly_commits": {},
                "commits_by_hour": {},
                "productive_hours": [],
                "work_patterns": {}
            },
            "tickets": {
                "total_created": 0,
                "by_type": {},
                "average_completion_time": 0,
                "completion_rate": 0,
                "velocity_trend": []
            },
            "sessions": {
                "total_sessions": 0,
                "by_type": {},
                "average_duration": 0,
                "session_frequency": {},
                "most_active_days": []
            },
            "learning": {
                "frequent_questions": [],
                "automation_opportunities": [],
                "improvement_suggestions": [],
                "skill_development_areas": []
            },
            "quality": {
                "code_quality_trend": [],
                "bug_rate": 0,
                "refactor_frequency": 0,
                "documentation_coverage": 0
            },
            "calendar": {
                "meetings_tracked": 0,
                "time_in_meetings": 0,
                "meeting_efficiency": 0,
                "blocked_time": {}
            },
            "meta": {
                "last_updated": datetime.now().isoformat(),
                "auto_insights_count": 0,
                "predictions_accuracy": 0
            }
        }

    def load_patterns(self) -> Dict[str, Any]:
        """Cargar patrones de usuario"""
        if self.patterns_file.exists():
            with open(self.patterns_file, 'r') as f:
                return json.load(f)
        return {}

    def save_metrics(self):
        """Guardar métricas"""
        self.metrics["meta"]["last_updated"] = datetime.now().isoformat()
        with open(self.metrics_file, 'w') as f:
            json.dump(self.metrics, f, indent=2)

    def analyze_git_activity(self):
        """Analizar actividad de Git automáticamente"""
        try:
            # Obtener commits del día
            today = datetime.now().strftime("%Y-%m-%d")
            git_log_cmd = [
                "git", "log", "--oneline", "--since=today", 
                "--pretty=format:%H|%s|%ad", "--date=iso"
            ]
            
            result = subprocess.run(git_log_cmd, capture_output=True, text=True)
            
            if result.returncode == 0:
                commits = result.stdout.strip().split('\n') if result.stdout.strip() else []
                
                # Actualizar métricas de commits diarios
                self.metrics["productivity"]["daily_commits"][today] = len(commits)
                
                # Analizar patterns de commits
                for commit in commits:
                    if '|' in commit:
                        parts = commit.split('|')
                        if len(parts) >= 3:
                            commit_hash, message, date_str = parts[0], parts[1], parts[2]
                            
                            # Extraer hora del commit
                            try:
                                commit_time = datetime.fromisoformat(date_str.replace(' ', 'T'))
                                hour = commit_time.hour
                                
                                if str(hour) not in self.metrics["productivity"]["commits_by_hour"]:
                                    self.metrics["productivity"]["commits_by_hour"][str(hour)] = 0
                                self.metrics["productivity"]["commits_by_hour"][str(hour)] += 1
                                
                                # Detectar horas productivas
                                self.metrics["productivity"]["productive_hours"].append(hour)
                                
                            except Exception:
                                pass
                
                self.log_insight(f"GIT_ANALYSIS - {len(commits)} commits today")
                
        except Exception as e:
            self.log_insight(f"GIT_ANALYSIS_ERROR - {str(e)}")

    def analyze_session_patterns(self):
        """Analizar patrones de sesiones automáticamente"""
        if not self.chat_log.exists():
            return
        
        try:
            with open(self.chat_log, 'r') as f:
                content = f.read()
            
            # Contar sesiones por tipo
            session_types = re.findall(r'\*\*👥 Tipo de Reunión\*\*: (\w+)', content)
            type_counts = Counter(session_types)
            
            self.metrics["sessions"]["total_sessions"] = len(session_types)
            self.metrics["sessions"]["by_type"] = dict(type_counts)
            
            # Detectar fechas de sesiones
            session_dates = re.findall(r'## 📅 (\d{4}-\d{2}-\d{2})', content)
            date_counts = Counter(session_dates)
            
            # Días más activos
            most_active = sorted(date_counts.items(), key=lambda x: x[1], reverse=True)[:5]
            self.metrics["sessions"]["most_active_days"] = [{"date": d, "sessions": c} for d, c in most_active]
            
            self.log_insight(f"SESSION_ANALYSIS - {len(session_types)} sessions analyzed")
            
        except Exception as e:
            self.log_insight(f"SESSION_ANALYSIS_ERROR - {str(e)}")

    def analyze_ticket_patterns(self):
        """Analizar patrones de tickets automáticamente"""
        tickets_dir = self.sessions_dir / "tickets"
        
        if not tickets_dir.exists():
            return
        
        try:
            ticket_files = list(tickets_dir.glob("*.yaml"))
            self.metrics["tickets"]["total_created"] = len(ticket_files)
            
            type_counts = defaultdict(int)
            completion_times = []
            
            for ticket_file in ticket_files:
                try:
                    with open(ticket_file, 'r') as f:
                        ticket_data = yaml.safe_load(f)
                    
                    ticket_type = ticket_data.get('type', 'unknown')
                    type_counts[ticket_type] += 1
                    
                    # Calcular tiempo de completion si está completo
                    created_at = ticket_data.get('created_at')
                    status = ticket_data.get('status')
                    
                    if status == 'done' and created_at:
                        # Simular completion time para análisis
                        completion_times.append(24)  # Default 24 horas
                        
                except Exception:
                    continue
            
            self.metrics["tickets"]["by_type"] = dict(type_counts)
            
            if completion_times:
                self.metrics["tickets"]["average_completion_time"] = sum(completion_times) / len(completion_times)
                self.metrics["tickets"]["completion_rate"] = len(completion_times) / len(ticket_files) * 100
            
            self.log_insight(f"TICKET_ANALYSIS - {len(ticket_files)} tickets analyzed")
            
        except Exception as e:
            self.log_insight(f"TICKET_ANALYSIS_ERROR - {str(e)}")

    def detect_automation_opportunities(self):
        """Detectar oportunidades de automatización"""
        opportunities = []
        
        # Analizar logs para patrones repetitivos
        if self.agent_log.exists():
            try:
                with open(self.agent_log, 'r') as f:
                    log_content = f.read()
                
                # Buscar comandos repetitivos
                commands = re.findall(r'INFO.*?- (.+)', log_content)
                command_counts = Counter(commands)
                
                # Oportunidades basadas en repetición
                for command, count in command_counts.items():
                    if count >= 3:  # Aparece 3+ veces
                        if "CHAT_DOCUMENTED" in command:
                            opportunities.append({
                                "type": "auto_documentation",
                                "description": "Automatizar documentación de chats",
                                "frequency": count,
                                "potential_time_saved": count * 5  # 5 min por documentación manual
                            })
                        elif "TICKET_CREATED" in command:
                            opportunities.append({
                                "type": "quick_ticket_template",
                                "description": "Crear template para tickets frecuentes",
                                "frequency": count,
                                "potential_time_saved": count * 3
                            })
                
            except Exception:
                pass
        
        # Oportunidades basadas en patrones de sesiones
        session_types = self.metrics["sessions"].get("by_type", {})
        most_common_session = max(session_types, key=session_types.get) if session_types else None
        
        if most_common_session and session_types[most_common_session] >= 5:
            opportunities.append({
                "type": "session_template",
                "description": f"Crear template para sesiones de {most_common_session}",
                "frequency": session_types[most_common_session],
                "potential_time_saved": session_types[most_common_session] * 10
            })
        
        self.metrics["learning"]["automation_opportunities"] = opportunities[:5]  # Top 5

    def generate_insights(self):
        """Generar insights automáticos"""
        insights = []
        
        # Insight sobre productividad
        productive_hours = self.metrics["productivity"]["productive_hours"]
        if productive_hours:
            hour_counts = Counter(productive_hours)
            best_hour = hour_counts.most_common(1)[0][0]
            insights.append(f"Tu hora más productiva es {best_hour}:00 con {hour_counts[best_hour]} commits")
        
        # Insight sobre tipos de trabajo
        ticket_types = self.metrics["tickets"].get("by_type", {})
        if ticket_types:
            main_work = max(ticket_types, key=ticket_types.get)
            insights.append(f"Tu trabajo principal es '{main_work}' ({ticket_types[main_work]} tickets)")
        
        # Insight sobre sesiones
        session_types = self.metrics["sessions"].get("by_type", {})
        if session_types:
            main_session = max(session_types, key=session_types.get)
            insights.append(f"Tus sesiones más frecuentes son de '{main_session}' ({session_types[main_session]} veces)")
        
        # Insight sobre calendario
        daily_commits = self.metrics["productivity"]["daily_commits"]
        if len(daily_commits) >= 3:
            avg_commits = sum(daily_commits.values()) / len(daily_commits)
            insights.append(f"Promedio de {avg_commits:.1f} commits por día")
        
        self.metrics["learning"]["improvement_suggestions"] = insights[:10]
        self.metrics["meta"]["auto_insights_count"] = len(insights)

    def predict_patterns(self):
        """Predecir patrones futuros basado en data histórica"""
        predictions = {}
        
        # Predicción de productividad
        daily_commits = self.metrics["productivity"]["daily_commits"]
        if len(daily_commits) >= 7:  # Al menos una semana de data
            recent_commits = list(daily_commits.values())[-7:]
            avg_weekly = sum(recent_commits)
            predictions["next_week_commits"] = int(avg_weekly * 1.1)  # Optimistic 10% growth
        
        # Predicción de tipos de trabajo
        ticket_types = self.metrics["tickets"].get("by_type", {})
        if ticket_types:
            total_tickets = sum(ticket_types.values())
            for ticket_type, count in ticket_types.items():
                percentage = (count / total_tickets) * 100
                predictions[f"next_{ticket_type}_tickets"] = f"{percentage:.1f}% probability"
        
        self.metrics["learning"]["predictions"] = predictions

    def suggest_calendar_blocks(self):
        """Sugerir bloques de calendario basado en patrones"""
        suggestions = []
        
        # Sugerir bloques para horas productivas
        productive_hours = self.metrics["productivity"]["productive_hours"]
        if productive_hours:
            hour_counts = Counter(productive_hours)
            top_hours = hour_counts.most_common(3)
            
            for hour, count in top_hours:
                suggestions.append({
                    "type": "focus_time",
                    "time": f"{hour}:00-{hour+2}:00",
                    "title": "🎯 Bloque de Desarrollo",
                    "description": f"Hora productiva detectada ({count} commits históricos)",
                    "calendar_entry": f"FOCUS-{hour:02d}00: Desarrollo sin interrupciones"
                })
        
        # Sugerir bloques para documentación
        session_types = self.metrics["sessions"].get("by_type", {})
        if "documentacion" in session_types and session_types["documentacion"] >= 3:
            suggestions.append({
                "type": "documentation_time",
                "time": "16:00-17:00",
                "title": "📚 Bloque de Documentación",
                "description": "Sesiones de documentación detectadas",
                "calendar_entry": "DOC-1600: Documentación y organización"
            })
        
        self.metrics["calendar"]["blocked_time"] = suggestions[:5]

    def log_insight(self, message: str):
        """Log insights y actividades del engine"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"[{timestamp}] METRICS_ENGINE - {message}\n"
        
        with open(self.agent_log, 'a') as f:
            f.write(log_entry)

    def run_full_analysis(self):
        """Ejecutar análisis completo automático"""
        print("🚀 Verdex Smart Metrics Engine - Análisis Automático")
        print("=" * 60)
        
        # Ejecutar todos los análisis
        self.analyze_git_activity()
        self.analyze_session_patterns()
        self.analyze_ticket_patterns()
        self.detect_automation_opportunities()
        self.generate_insights()
        self.predict_patterns()
        self.suggest_calendar_blocks()
        
        # Guardar resultados
        self.save_metrics()
        
        print("\n📊 RESULTADOS DEL ANÁLISIS:")
        print(f"📈 Commits hoy: {self.metrics['productivity']['daily_commits'].get(datetime.now().strftime('%Y-%m-%d'), 0)}")
        print(f"🎫 Total tickets: {self.metrics['tickets']['total_created']}")
        print(f"💬 Total sesiones: {self.metrics['sessions']['total_sessions']}")
        print(f"🤖 Oportunidades automatización: {len(self.metrics['learning']['automation_opportunities'])}")
        print(f"💡 Insights generados: {self.metrics['meta']['auto_insights_count']}")
        
        # Mostrar insights
        insights = self.metrics["learning"]["improvement_suggestions"]
        if insights:
            print("\n💡 INSIGHTS AUTOMÁTICOS:")
            for i, insight in enumerate(insights[:3], 1):
                print(f"   {i}. {insight}")
        
        # Mostrar oportunidades de automatización
        opportunities = self.metrics["learning"]["automation_opportunities"]
        if opportunities:
            print("\n🤖 OPORTUNIDADES DE AUTOMATIZACIÓN:")
            for opp in opportunities[:2]:
                time_saved = opp.get("potential_time_saved", 0)
                print(f"   • {opp['description']} (Ahorro: {time_saved} min)")
        
        # Mostrar sugerencias de calendario
        calendar_suggestions = self.metrics["calendar"]["blocked_time"]
        if calendar_suggestions:
            print("\n📅 SUGERENCIAS DE CALENDARIO:")
            for suggestion in calendar_suggestions[:2]:
                print(f"   • {suggestion['title']} ({suggestion['time']})")
        
        print(f"\n✅ Análisis completado - Métricas guardadas en {self.metrics_file}")
        self.log_insight("FULL_ANALYSIS_COMPLETED")

    def show_dashboard(self):
        """Mostrar dashboard de métricas"""
        print("📊 VERDEX FRAMEWORK IA - DASHBOARD")
        print("=" * 50)
        
        # Productividad
        print("\n🚀 PRODUCTIVIDAD:")
        daily_commits = self.metrics["productivity"]["daily_commits"]
        if daily_commits:
            recent_days = list(daily_commits.items())[-7:]
            for date, commits in recent_days:
                print(f"   {date}: {commits} commits")
        
        # Tickets
        print("\n🎫 TICKETS:")
        ticket_types = self.metrics["tickets"].get("by_type", {})
        for ticket_type, count in ticket_types.items():
            print(f"   {ticket_type}: {count}")
        
        # Sesiones
        print("\n💬 SESIONES:")
        session_types = self.metrics["sessions"].get("by_type", {})
        for session_type, count in session_types.items():
            print(f"   {session_type}: {count}")
        
        print("\n" + "=" * 50)

def main():
    engine = VerdexMetricsEngine()
    
    if len(sys.argv) > 1:
        if sys.argv[1] == "--dashboard":
            engine.show_dashboard()
        elif sys.argv[1] == "--analyze":
            engine.run_full_analysis()
        else:
            print("Uso: python smart-metrics-engine.py [--dashboard|--analyze]")
    else:
        engine.run_full_analysis()

if __name__ == "__main__":
    main() 