import json
from pathlib import Path
from typing import Dict, Any, List
import logging
from datetime import datetime
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from tabulate import tabulate
import yaml
import mlflow
from collections import defaultdict
import psutil
import torch

logger = logging.getLogger(__name__)

class TrainingVisualizer:
    def __init__(self, config: Dict[str, Any], experiment_name: str):
        self.config = config
        self.experiment_name = experiment_name
        self.training_history = defaultdict(list)
        self.experiment_info = {}
        
        # 使用精確到秒的時間戳
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        self.report_dir = Path('reports') / f"{experiment_name}_{timestamp}"
        self.report_dir.mkdir(parents=True, exist_ok=True)
        (self.report_dir / 'figures').mkdir(exist_ok=True)
        
        logger.info(f"Creating experiment directory: {self.report_dir}")

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
        config_path = self.report_dir / "experiment_config.yaml"
        with open(config_path, 'w') as f:
            yaml.dump(self.experiment_info, f, default_flow_style=False)
            
        logger.info(f"Started experiment: {self.experiment_name}")
            
    def _get_hardware_info(self) -> Dict[str, Any]:
        """獲取硬體信息"""
        return {
            "cpu_count": psutil.cpu_count(),
            "memory_total": f"{psutil.virtual_memory().total / (1024**3):.2f}GB",
            "memory_available": f"{psutil.virtual_memory().available / (1024**3):.2f}GB",
            "gpu_available": torch.cuda.is_available(),
            "gpu_count": torch.cuda.device_count() if torch.cuda.is_available() else 0,
            "gpu_name": torch.cuda.get_device_name(0) if torch.cuda.is_available() else "N/A"
        }
            
    def log_metrics(self, metrics: Dict[str, float], step: int, phase: str = 'train'):
        """記錄訓練指標"""
        for key, value in metrics.items():
            self.training_history[f"{phase}_{key}"].append((step, value))
            
    def plot_metrics(self):
        """繪製訓練指標圖表"""
        for metric_name, values in self.training_history.items():
            steps, metric_values = zip(*values)
            
            plt.figure(figsize=(10, 6))
            plt.plot(steps, metric_values)
            plt.title(f'{metric_name} over time')
            plt.xlabel('Step')
            plt.ylabel(metric_name)
            plt.grid(True)
            
            # 保存圖表
            plt.savefig(self.report_dir / 'figures' / f'{metric_name}.png')
            plt.close()
            
    def generate_training_report(self) -> str:
        """生成詳細的訓練報告"""
        report = []
        report.append("=" * 50)
        report.append(f"訓練報告 - {self.experiment_name}")
        report.append(f"開始時間: {self.experiment_info['start_time']}")
        report.append("=" * 50)
        
        # 配置摘要
        report.append("\n配置摘要:")
        report.append("-" * 30)
        for key, value in self.config.items():
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
            
        # 生成圖表
        self.plot_metrics()
        report.append("\n訓練圖表已保存至: {}/figures/".format(self.report_dir))
        
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
    
    def save_training_history(self):
        """保存完整的訓練歷史"""
        history_path = self.report_dir / "training_history.json"
        with open(history_path, 'w') as f:
            json.dump(self.training_history, f, indent=2)
            
        # 保存為 CSV 格式方便分析
        history_df = pd.DataFrame(self.training_history)
        history_df.to_csv(self.report_dir / "training_history.csv")
