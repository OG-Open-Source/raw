import sys
import os
sys.path.append(os.path.dirname(__file__))

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
import yaml
import argparse

from utils.visualization import TrainingVisualizer
from learning_modes.mode_manager import LearningModeManager

# 設置日誌格式
def setup_logging(timestamp: str):
    """設置日誌配置"""
    log_dir = Path('logs')
    log_dir.mkdir(exist_ok=True)
    
    # 設置文件處理器
    log_file = log_dir / f"training_{timestamp}.log"
    file_handler = logging.FileHandler(log_file)
    file_handler.setLevel(logging.INFO)
    
    # 設置控制台處理器
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    
    # 設置格式
    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    file_handler.setFormatter(formatter)
    console_handler.setFormatter(formatter)
    
    # 配置根日誌記錄器
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.INFO)
    root_logger.addHandler(file_handler)
    root_logger.addHandler(console_handler)
    
    return log_file

def get_available_configs():
    """獲取所有可用的配置文件"""
    config_dir = Path("config")
    configs = {}
    
    for mode_dir in config_dir.iterdir():
        if mode_dir.is_dir():
            configs[mode_dir.name] = [
                f.stem for f in mode_dir.glob("*.yaml")
            ]
    
    return configs

def update_config_with_args(config: dict, args: argparse.Namespace):
    """使用命令行參數更新配置"""
    if args.batch_size:
        config['training']['batch_size'] = args.batch_size
    if args.learning_rate:
        config['training']['learning_rate'] = args.learning_rate
    if args.epochs:
        config['training']['epochs'] = args.epochs
    if args.hidden_size:
        config['model']['hidden_size'] = args.hidden_size
    if args.dropout:
        config['model']['dropout_rate'] = args.dropout
    if args.device:
        config['system']['device'] = args.device
    if args.num_workers is not None:
        config['system']['num_workers'] = args.num_workers
    
    return config

def train(config_path: str, args: argparse.Namespace):
    """主訓練函數"""
    # 設置時間戳
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    
    # 設置日誌
    log_file = setup_logging(timestamp)
    logger = logging.getLogger(__name__)
    
    # 載入基礎配置
    with open(config_path) as f:
        config = yaml.safe_load(f)
    
    # 使用命令行參數更新配置
    config = update_config_with_args(config, args)
    
    mode_manager = LearningModeManager(config)
    visualizer = TrainingVisualizer(
        config,
        f"{mode_manager.mode_type}_{timestamp}"
    )
    
    try:
        visualizer.log_experiment_start()
        logger.info(f"Starting training with mode: {mode_manager.mode_type}")
        logger.info(f"Log file: {log_file}")
        logger.info(f"Configuration: {config}")
        
        mode_manager.train()
        
        report = visualizer.generate_training_report()
        report_path = Path('reports') / f"training_report_{timestamp}.txt"
        report_path.parent.mkdir(exist_ok=True)
        report_path.write_text(report)
        
        visualizer.save_training_history()
        logger.info("Training completed successfully")
        
    except Exception as e:
        logger.error(f"Training failed: {e}", exc_info=True)
        raise
    finally:
        # 關閉日誌處理器
        for handler in logger.handlers[:]:
            handler.close()
            logger.removeHandler(handler)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='AI Training Framework')
    parser.add_argument('--mode', type=str, required=True,
                      choices=['supervised', 'unsupervised', 'reinforcement', 'gan', 'multi_task'],
                      help='Training mode')
    parser.add_argument('--type', type=str, required=True,
                      help='Specific configuration type')
    
    # 進階設定參數
    parser.add_argument('--batch-size', type=int, help='Batch size')
    parser.add_argument('--learning-rate', type=float, help='Learning rate')
    parser.add_argument('--epochs', type=int, help='Number of epochs')
    parser.add_argument('--hidden-size', type=int, help='Hidden layer size')
    parser.add_argument('--dropout', type=float, help='Dropout rate')
    parser.add_argument('--device', type=str, choices=['cpu', 'cuda'], help='Device to use')
    parser.add_argument('--num-workers', type=int, help='Number of workers')
    
    args = parser.parse_args()
    
    # 構建配置文件路徑
    config_path = Path("config") / args.mode / f"{args.type}.yaml"
    
    if not config_path.exists():
        available_configs = get_available_configs()
        logger.error(f"Configuration not found: {config_path}")
        logger.info("Available configurations:")
        for mode, types in available_configs.items():
            logger.info(f"{mode}: {', '.join(types)}")
        exit(1)
    
    train(str(config_path), args)
