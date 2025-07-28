#!/usr/bin/env python3
"""
WILL.wiki Workflow Monitor - Never Miss a Beat
Integrates with existing SKENAI workflows for comprehensive monitoring

Daily monitoring, blog automation, and workflow orchestration
"""

import json
import subprocess
import schedule
import time
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Any
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/will-wiki-monitor.log'),
        logging.StreamHandler()
    ]
)

class WillWikiWorkflowMonitor:
    """Integrates WILL.wiki management with existing SKENAI workflows"""
    
    def __init__(self, base_path: str = "C:/Users/ASUS/CascadeProjects/SKENAI-R"):
        self.base_path = Path(base_path)
        self.scripts_path = self.base_path / "scripts"
        self.workflows_path = self.base_path / "workflows"
        self.registries_path = self.base_path / "registries"
        
        # Ensure directories exist
        for path in [self.registries_path, Path("logs")]:
            path.mkdir(exist_ok=True)
        
        # Integration points
        self.guardian_script = self.scripts_path / "will-wiki-guardian.ps1"
        self.span_script = self.scripts_path / "span-address-manager.ps1"
        self.master_script = self.scripts_path / "will-wiki-master.ps1"
        self.register_workflow = self.workflows_path / "register.py"
        
        # Blog integration
        self.blog_scripts = [
            self.scripts_path / "create-encore-blogs.ps1",
            self.scripts_path / "generate-encore-blog-series.ps1",
            self.scripts_path / "simple-encore-blogs.ps1",
            self.scripts_path / "span-blog-auto.ps1"  # SPAN blog automation
        ]
        
        self.status_file = self.base_path / "will-wiki-monitor-status.json"
        
    def run_powershell_script(self, script_path: Path, args: List[str] = None) -> Dict[str, Any]:
        """Execute PowerShell script and return results"""
        try:
            cmd = ["powershell", "-ExecutionPolicy", "Bypass", "-File", str(script_path)]
            if args:
                cmd.extend(args)
            
            result = subprocess.run(
                cmd, 
                capture_output=True, 
                text=True, 
                cwd=str(self.base_path)
            )
            
            return {
                "success": result.returncode == 0,
                "stdout": result.stdout,
                "stderr": result.stderr,
                "returncode": result.returncode
            }
        except Exception as e:
            logging.error(f"Error running {script_path}: {e}")
            return {"success": False, "error": str(e)}
    
    def run_python_workflow(self, workflow_path: Path) -> Dict[str, Any]:
        """Execute Python workflow and return results"""
        try:
            result = subprocess.run(
                ["python", str(workflow_path)],
                capture_output=True,
                text=True,
                cwd=str(self.base_path)
            )
            
            return {
                "success": result.returncode == 0,
                "stdout": result.stdout,
                "stderr": result.stderr,
                "returncode": result.returncode
            }
        except Exception as e:
            logging.error(f"Error running {workflow_path}: {e}")
            return {"success": False, "error": str(e)}
    
    def daily_monitoring_cycle(self):
        """Complete daily monitoring cycle - NEVER MISS A BEAT"""
        logging.info("[GUARDIAN] Starting daily WILL.wiki monitoring cycle")
        
        results = {
            "timestamp": datetime.now().isoformat(),
            "cycle_type": "daily",
            "results": {}
        }
        
        try:
            # 1. Run Guardian system scan
            logging.info("[SCAN] Running Guardian system scan...")
            guardian_result = self.run_powershell_script(
                self.guardian_script, 
                ["-Mode", "Scan"]
            )
            results["results"]["guardian_scan"] = guardian_result
            
            # 2. Check for changes and update if needed
            if self.check_wiki_changes():
                logging.info("[UPDATE] Changes detected - running update cycle")
                
                # Run Guardian update
                guardian_update = self.run_powershell_script(
                    self.guardian_script,
                    ["-Mode", "Update"]
                )
                results["results"]["guardian_update"] = guardian_update
                
                # Update SPAN addresses
                span_update = self.run_powershell_script(
                    self.span_script,
                    ["-GenerateAll", "-UpdateRegistry"]
                )
                results["results"]["span_update"] = span_update
                
                # Generate blog posts
                self.generate_blog_posts()
                results["results"]["blog_generation"] = {"success": True}
                
                # Update registries
                if self.register_workflow.exists():
                    registry_update = self.run_python_workflow(self.register_workflow)
                    results["results"]["registry_update"] = registry_update
            
            # 3. Validate system integrity
            validation_result = self.validate_system_integrity()
            results["results"]["validation"] = validation_result
            
            # 4. Update monitoring status
            self.update_monitoring_status(results)
            
            logging.info("[SUCCESS] Daily monitoring cycle completed successfully")
            
        except Exception as e:
            logging.error("[ERROR] Error in daily monitoring cycle: {e}")
            results["results"]["error"] = str(e)
        
        return results
    
    def check_wiki_changes(self) -> bool:
        """Check if WILL.wiki has changes"""
        try:
            result = subprocess.run(
                ["git", "status", "--porcelain", "WILL.wiki"],
                capture_output=True,
                text=True,
                cwd=str(self.base_path)
            )
            
            return bool(result.stdout.strip())
        except Exception as e:
            logging.error(f"Error checking wiki changes: {e}")
            return False
    
    def generate_blog_posts(self):
        """Generate blog posts using SPAN blog automation"""
        logging.info("[BLOG] Generating SPAN blog posts for WILL.wiki updates...")
        
        # Priority: Use SPAN blog automation for WILL.wiki updates
        span_blog_script = self.scripts_path / "span-blog-auto.ps1"
        if span_blog_script.exists():
            try:
                result = self.run_powershell_script(span_blog_script, ["-BatchMode", "-Deploy"])
                if result["success"]:
                    logging.info("[SUCCESS] SPAN blog automation completed successfully")
                    return  # SPAN blog handles WILL.wiki updates
                else:
                    logging.warning(f"[WARNING] SPAN blog automation issues: {result.get('stderr', 'Unknown error')}")
            except Exception as e:
                logging.error(f"Error running SPAN blog automation: {e}")
        
        # Fallback: Use other blog scripts
        for blog_script in self.blog_scripts:
            if blog_script.exists() and blog_script.name != "span-blog-auto.ps1":
                try:
                    result = self.run_powershell_script(blog_script, ["-Deploy"])
                    if result["success"]:
                        logging.info(f"[SUCCESS] Successfully ran {blog_script.name}")
                    else:
                        logging.warning(f"[WARNING] Issues with {blog_script.name}: {result.get('stderr', 'Unknown error')}")
                except Exception as e:
                    logging.error(f"Error running {blog_script.name}: {e}")
    
    def validate_system_integrity(self) -> Dict[str, Any]:
        """Validate WILL.wiki system integrity"""
        validation_results = {
            "timestamp": datetime.now().isoformat(),
            "checks": {}
        }
        
        # Check WILL.wiki exists and has content
        wiki_path = self.base_path / "WILL.wiki"
        if wiki_path.exists():
            md_files = list(wiki_path.rglob("*.md"))
            validation_results["checks"]["wiki_files"] = {
                "exists": True,
                "file_count": len(md_files),
                "status": "healthy" if len(md_files) > 0 else "empty"
            }
        else:
            validation_results["checks"]["wiki_files"] = {
                "exists": False,
                "status": "missing"
            }
        
        # Check SPAN registry
        span_registry = self.registries_path / "span_addresses.json"
        if span_registry.exists():
            try:
                with open(span_registry, 'r') as f:
                    span_data = json.load(f)
                validation_results["checks"]["span_registry"] = {
                    "exists": True,
                    "address_count": len(span_data) if isinstance(span_data, list) else 0,
                    "status": "healthy"
                }
            except Exception as e:
                validation_results["checks"]["span_registry"] = {
                    "exists": True,
                    "status": "corrupt",
                    "error": str(e)
                }
        else:
            validation_results["checks"]["span_registry"] = {
                "exists": False,
                "status": "missing"
            }
        
        # Check blog directory
        blog_path = self.base_path / "frontend/website/SPAN-blog-v3/content/blog"
        if blog_path.exists():
            blog_posts = list(blog_path.glob("*will-wiki-update*.md"))
            validation_results["checks"]["blog_posts"] = {
                "exists": True,
                "post_count": len(blog_posts),
                "status": "healthy"
            }
        else:
            validation_results["checks"]["blog_posts"] = {
                "exists": False,
                "status": "missing"
            }
        
        return validation_results
    
    def update_monitoring_status(self, results: Dict[str, Any]):
        """Update monitoring status file"""
        status = {
            "last_run": datetime.now().isoformat(),
            "status": "active",
            "results": results,
            "next_scheduled": (datetime.now() + timedelta(days=1)).isoformat(),
            "system_health": self.calculate_system_health(results)
        }
        
        with open(self.status_file, 'w') as f:
            json.dump(status, f, indent=2)
    
    def calculate_system_health(self, results: Dict[str, Any]) -> str:
        """Calculate overall system health"""
        success_count = 0
        total_count = 0
        
        for key, result in results.get("results", {}).items():
            total_count += 1
            if isinstance(result, dict) and result.get("success", False):
                success_count += 1
        
        if total_count == 0:
            return "unknown"
        
        health_ratio = success_count / total_count
        
        if health_ratio >= 0.9:
            return "excellent"
        elif health_ratio >= 0.7:
            return "good"
        elif health_ratio >= 0.5:
            return "fair"
        else:
            return "poor"
    
    def hourly_check(self):
        """Lightweight hourly check"""
        logging.info("[CHECK] Hourly WILL.wiki check")
        
        if self.check_wiki_changes():
            logging.info("[TRIGGER] Changes detected - triggering update")
            self.run_powershell_script(
                self.master_script,
                ["-Action", "Update"]
            )
    
    def emergency_response(self):
        """Emergency response system"""
        logging.error("[EMERGENCY] WILL.wiki system issues detected")
        
        # Run emergency maintenance
        emergency_result = self.run_powershell_script(
            self.master_script,
            ["-Action", "Emergency"]
        )
        
        # Log emergency response
        logging.error(f"Emergency response result: {emergency_result}")
        
        return emergency_result
    
    def start_monitoring(self):
        """Start the never-miss-a-beat monitoring system"""
        logging.info("[MONITOR] Starting WILL.wiki Never-Miss-A-Beat monitoring system")
        
        # Schedule daily monitoring at 6 AM
        schedule.every().day.at("06:00").do(self.daily_monitoring_cycle)
        
        # Schedule hourly checks
        schedule.every().hour.do(self.hourly_check)
        
        # Initial run
        self.daily_monitoring_cycle()
        
        # Keep monitoring running
        while True:
            try:
                schedule.run_pending()
                time.sleep(60)  # Check every minute
            except KeyboardInterrupt:
                logging.info("[STOP] Monitoring stopped by user")
                break
            except Exception as e:
                logging.error(f"Error in monitoring loop: {e}")
                # Continue monitoring despite errors
                time.sleep(300)  # Wait 5 minutes before retrying

def main():
    """Main entry point"""
    monitor = WillWikiWorkflowMonitor()
    
    import sys
    if len(sys.argv) > 1:
        command = sys.argv[1].lower()
        
        if command == "daily":
            monitor.daily_monitoring_cycle()
        elif command == "check":
            monitor.hourly_check()
        elif command == "emergency":
            monitor.emergency_response()
        elif command == "validate":
            results = monitor.validate_system_integrity()
            print(json.dumps(results, indent=2))
        elif command == "monitor":
            monitor.start_monitoring()
        else:
            print("Usage: python will-wiki-monitor.py [daily|check|emergency|validate|monitor]")
    else:
        # Default: start full monitoring
        monitor.start_monitoring()

if __name__ == "__main__":
    main()
