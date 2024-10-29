import torch
from torch import nn, optim
from torch.utils.data import DataLoader
from torch.amp import autocast, GradScaler
import logging
from typing import Dict, Any
from pathlib import Path
import mlflow
from tqdm import tqdm
from datetime import datetime
from utils.visualization import TrainingVisualizer
from learning_modes.mode_manager import LearningModeManager

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def train(config_path: str):
    """主訓練函數"""
    # 初始化模式管理器
    mode_manager = LearningModeManager(config_path)
    
    # 初始化可視化工具
    visualizer = TrainingVisualizer(
        mode_manager.config,
        f"{mode_manager.mode_type}_{datetime.now().strftime('%Y%m%d')}"
    )
    
    try:
        # 記錄實驗開始
        visualizer.log_experiment_start()
        
        # 開始訓練
        logger.info(f"Starting training with mode: {mode_manager.mode_type}")
        mode_manager.train()
        
        # 生成訓練報告
        report = visualizer.generate_training_report()
        report_path = Path('reports') / f"training_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
        report_path.parent.mkdir(exist_ok=True)
        report_path.write_text(report)
        
        # 保存訓練歷史
        visualizer.save_training_history()
        
        logger.info("Training completed successfully")
        
    except Exception as e:
        logger.error(f"Training failed: {e}")
        raise
    
if __name__ == '__main__':
    config_path = 'config/train_config.yaml'
    train(config_path)
