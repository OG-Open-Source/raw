import json
from pathlib import Path
from typing import Dict, Any, List
import logging
from datetime import datetime
import pandas as pd
from tabulate import tabulate
import yaml
import mlflow
from collections import defaultdict

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class TrainingVisualizer:
    def __init__(self, config: Dict[str, Any], experiment_name: str):
        self.config = config
        self.experiment_name = experiment_name
        self.training_history = defaultdict(list)
        self.experiment_info = {}
        
        # 創建實驗目錄
        self.exp_dir = Path(f"experiments/{experiment_name}_{datetime.now().strftime('%Y%m%d_%H%M%S')}")
        self.exp_dir.mkdir(parents=True, exist_ok=True)
        
    def log_experiment_start(self):
        """記錄實驗開始信息"""
        self.experiment_info = {
            "start_time": datetime.now().isoformat(),
            "config": self.config,
            "learning_mode": self.config['learning_mode']['type'],
            "model_architecture": self.config['model']['architecture_type'],
            "hardware_info": self._get_hardware_info(),
        }
        
        # 保存實驗配置
        with open(self.exp_dir / "experiment_config.yaml", 'w') as f:
            yaml.dump(self.experiment_info, f)
            
    def log_batch_metrics(self, metrics: Dict[str, float], step: int):
        """記錄每個batch的指標"""
        for key, value in metrics.items():
            self.training_history[f"batch_{key}"].append((step, value))
            
    def log_epoch_metrics(self, metrics: Dict[str, float], epoch: int):
        """記錄每個epoch的指標"""
        for key, value in metrics.items():
            self.training_history[f"epoch_{key}"].append((epoch, value))
            
    def log_model_analysis(self, model_info: Dict[str, Any]):
        """記錄模型分析結果"""
        self.experiment_info["model_analysis"] = model_info
        
    def generate_training_report(self) -> str:
        """生成訓練報告"""
        report = []
        report.append("=" * 50)
        report.append(f"實驗名稱: {self.experiment_name}")
        report.append(f"開始時間: {self.experiment_info['start_time']}")
        report.append(f"學習模式: {self.experiment_info['learning_mode']}")
        report.append("=" * 50)
        
        # 模型架構摘要
        report.append("\n模型架構:")
        report.append("-" * 30)
        for key, value in self.config['model'].items():
            report.append(f"{key}: {value}")
            
        # 訓練指標摘要
        report.append("\n訓練指標摘要:")
        report.append("-" * 30)
        metrics_df = self._get_metrics_summary()
        report.append(tabulate(metrics_df, headers='keys', tablefmt='grid'))
        
        # 硬體使用摘要
        report.append("\n硬體使用摘要:")
        report.append("-" * 30)
        for key, value in self.experiment_info["hardware_info"].items():
            report.append(f"{key}: {value}")
            
        return "\n".join(report)
    
    def save_training_history(self):
        """保存訓練歷史"""
        history_path = self.exp_dir / "training_history.json"
        with open(history_path, 'w') as f:
            json.dump(self.training_history, f, indent=2)
            
    def generate_comparison_report(self, other_experiment: str) -> str:
        """生成與其他實驗的比較報告"""
        other_history = self._load_experiment_history(other_experiment)
        
        report = []
        report.append(f"比較報告: {self.experiment_name} vs {other_experiment}")
        report.append("=" * 50)
        
        # 比較關鍵指標
        metrics_comparison = self._compare_metrics(other_history)
        report.append("\n指標比較:")
        report.append(tabulate(metrics_comparison, headers='keys', tablefmt='grid'))
        
        return "\n".join(report)
    
    def _get_metrics_summary(self) -> pd.DataFrame:
        """獲取指標摘要"""
        summary = defaultdict(dict)
        
        for key, values in self.training_history.items():
            if values:
                summary[key] = {
                    'min': min(v[1] for v in values),
                    'max': max(v[1] for v in values),
                    'avg': sum(v[1] for v in values) / len(values)
                }
                
        return pd.DataFrame(summary).T
    
    def _get_hardware_info(self) -> Dict[str, Any]:
        """獲取硬體信息"""
        import psutil
        import torch
        
        return {
            "cpu_count": psutil.cpu_count(),
            "memory_total": f"{psutil.virtual_memory().total / (1024**3):.2f}GB",
            "gpu_available": torch.cuda.is_available(),
            "gpu_count": torch.cuda.device_count() if torch.cuda.is_available() else 0,
            "gpu_name": torch.cuda.get_device_name(0) if torch.cuda.is_available() else "N/A"
        }
    
    def _load_experiment_history(self, experiment_name: str) -> Dict[str, List]:
        """載入其他實驗的歷史記錄"""
        exp_path = Path(f"experiments/{experiment_name}/training_history.json")
        if not exp_path.exists():
            raise FileNotFoundError(f"找不到實驗記錄: {experiment_name}")
            
        with open(exp_path) as f:
            return json.load(f)
    
    def _compare_metrics(self, other_history: Dict[str, List]) -> pd.DataFrame:
        """比較兩個實驗的指標"""
        comparison = defaultdict(dict)
        
        for key in set(self.training_history.keys()) & set(other_history.keys()):
            current_values = [v[1] for v in self.training_history[key]]
            other_values = [v[1] for v in other_history[key]]
            
            comparison[key] = {
                'current_avg': sum(current_values) / len(current_values),
                'other_avg': sum(other_values) / len(other_values),
                'diff': (sum(current_values) / len(current_values) - 
                        sum(other_values) / len(other_values))
            }
            
        return pd.DataFrame(comparison).T
