import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from typing import Dict, Any, Optional
import torch
from torch import nn, optim
from torch.utils.data import DataLoader
import logging
from pathlib import Path
import yaml
from tqdm import tqdm
import mlflow
from datetime import datetime

from model import EnhancedNN
from utils.preprocessing import load_data
from utils.evaluation import evaluate_model

logger = logging.getLogger(__name__)

class LearningModeManager:
    def __init__(self, config: Dict[str, Any]):
        self.config = config if isinstance(config, dict) else self._load_config(config)
        self.mode_type = self.config['learning_mode']['type']
        self.device = torch.device('cuda' if torch.cuda.is_available() and 
                                 self.config['system']['device'] != 'cpu' else 'cpu')
        
        # 初始化模型
        self.model = EnhancedNN(self.config).to(self.device)
        
        # 初始化優化器
        self.optimizer = self._setup_optimizer()
        
        # 初始化學習率調度器
        self.scheduler = self._setup_scheduler()
        
        # 初始化損失函數
        self.criterion = self._setup_criterion()
        
        # 設置檢查點目錄
        self.checkpoint_dir = Path('models/checkpoints')
        self.checkpoint_dir.mkdir(parents=True, exist_ok=True)
        
        logger.info(f"Initialized {self.mode_type} mode on {self.device}")
        
    def _load_config(self, config_path: str) -> Dict[str, Any]:
        """載入配置文件"""
        with open(config_path) as f:
            return yaml.safe_load(f)
            
    def _setup_optimizer(self) -> optim.Optimizer:
        """設置優化器"""
        optimizer_config = self.config['training']
        optimizer_type = optimizer_config.get('optimizer', 'adamw').lower()
        lr = optimizer_config.get('learning_rate', 0.001)
        
        if optimizer_type == 'adam':
            return optim.Adam(self.model.parameters(), lr=lr)
        elif optimizer_type == 'adamw':
            return optim.AdamW(self.model.parameters(), lr=lr)
        elif optimizer_type == 'sgd':
            return optim.SGD(self.model.parameters(), lr=lr)
        else:
            raise ValueError(f"Unsupported optimizer: {optimizer_type}")
            
    def _setup_scheduler(self) -> Optional[optim.lr_scheduler._LRScheduler]:
        """設置學習率調度器"""
        if not self.config['training'].get('use_scheduler', False):
            return None
            
        return optim.lr_scheduler.ReduceLROnPlateau(
            self.optimizer,
            mode='min',
            factor=0.1,
            patience=5,
            verbose=True
        )
        
    def _setup_criterion(self) -> nn.Module:
        """設置損失函數"""
        if self.mode_type == 'supervised':
            return nn.CrossEntropyLoss()
        # 可以添加其他模式的損失函數
        return nn.CrossEntropyLoss()
        
    def save_checkpoint(self, epoch: int, metrics: Dict[str, float], is_best: bool = False):
        """保存模型檢查點"""
        checkpoint = {
            'epoch': epoch,
            'model_state_dict': self.model.state_dict(),
            'optimizer_state_dict': self.optimizer.state_dict(),
            'scheduler_state_dict': self.scheduler.state_dict() if self.scheduler else None,
            'metrics': metrics,
            'config': self.config
        }
        
        # 保存一般檢查點
        checkpoint_path = self.checkpoint_dir / f"checkpoint_epoch_{epoch}.pt"
        torch.save(checkpoint, checkpoint_path)
        
        # 如果是最佳模型，另存一份
        if is_best:
            best_path = self.checkpoint_dir / "best_model.pt"
            torch.save(checkpoint, best_path)
            
        # 清理舊的檢查點
        self._cleanup_checkpoints(keep_last_n=5)
        
    def load_checkpoint(self, checkpoint_path: str):
        """載入檢查點"""
        checkpoint = torch.load(checkpoint_path, map_location=self.device)
        self.model.load_state_dict(checkpoint['model_state_dict'])
        self.optimizer.load_state_dict(checkpoint['optimizer_state_dict'])
        if self.scheduler and checkpoint['scheduler_state_dict']:
            self.scheduler.load_state_dict(checkpoint['scheduler_state_dict'])
        return checkpoint['epoch'], checkpoint['metrics']
        
    def _cleanup_checkpoints(self, keep_last_n: int = 5):
        """清理舊的檢查點，只保留最新的N個"""
        checkpoints = sorted(self.checkpoint_dir.glob("checkpoint_epoch_*.pt"))
        if len(checkpoints) > keep_last_n:
            for checkpoint in checkpoints[:-keep_last_n]:
                checkpoint.unlink()
                
    def train(self, data=None):
        """訓練模型"""
        train_loader, val_loader = load_data(self.config) if data is None else data
        
        # 設置 MLflow 實驗
        mlflow.set_experiment(self.mode_type)
        
        with mlflow.start_run(run_name=f"training_{datetime.now().strftime('%Y%m%d_%H%M%S')}"):
            # 記錄參數
            mlflow.log_params({
                "model_type": self.config['model']['architecture_type'],
                "hidden_size": self.config['model']['hidden_size'],
                "learning_rate": self.config['training']['learning_rate'],
                "batch_size": self.config['training']['batch_size'],
                "epochs": self.config['training']['epochs']
            })
            
            best_val_loss = float('inf')
            early_stopping_counter = 0
            early_stopping_patience = self.config['training'].get('patience', 5)
            
            for epoch in range(self.config['training']['epochs']):
                # 訓練階段
                self.model.train()
                train_loss = 0
                train_steps = 0
                
                progress_bar = tqdm(train_loader, desc=f"Epoch {epoch+1}")
                for batch in progress_bar:
                    # 移動數據到設備
                    inputs = {k: v.to(self.device) for k, v in batch.items() 
                             if isinstance(v, torch.Tensor)}
                    
                    # 前向傳播
                    self.optimizer.zero_grad()
                    outputs = self.model(**inputs)
                    loss = self.criterion(outputs, inputs['labels'])
                    
                    # 反向傳播
                    loss.backward()
                    
                    # 梯度裁剪
                    if self.config['memory'].get('max_grad_norm', 0) > 0:
                        torch.nn.utils.clip_grad_norm_(
                            self.model.parameters(), 
                            self.config['memory']['max_grad_norm']
                        )
                    
                    self.optimizer.step()
                    
                    train_loss += loss.item()
                    train_steps += 1
                    
                    # 更新進度條
                    progress_bar.set_postfix({
                        'loss': f'{loss.item():.4f}',
                        'avg_loss': f'{train_loss/train_steps:.4f}'
                    })
                    
                avg_train_loss = train_loss / train_steps
                
                # 驗證階段
                val_loss, val_metrics = evaluate_model(
                    self.model, val_loader, self.criterion, self.device, self.config
                )
                
                # 記錄指標到 MLflow
                mlflow.log_metrics({
                    "train_loss": avg_train_loss,
                    "val_loss": val_loss,
                    "val_accuracy": val_metrics['accuracy']
                }, step=epoch)
                
                # 更新學習率
                if self.scheduler:
                    self.scheduler.step(val_loss)
                    
                # 保存檢查點
                metrics = {
                    'train_loss': avg_train_loss,
                    'val_loss': val_loss,
                    **val_metrics
                }
                
                is_best = val_loss < best_val_loss
                if is_best:
                    best_val_loss = val_loss
                    early_stopping_counter = 0
                else:
                    early_stopping_counter += 1
                    
                self.save_checkpoint(epoch, metrics, is_best)
                
                # 如果是最佳模型，保存到 MLflow
                if is_best:
                    mlflow.pytorch.log_model(self.model, "best_model")
                
                # 早停
                if early_stopping_counter >= early_stopping_patience:
                    logger.info(f"Early stopping triggered after {epoch+1} epochs")
                    break
                    
                logger.info(f"Epoch {epoch+1}: train_loss={avg_train_loss:.4f}, val_loss={val_loss:.4f}")
                
    def evaluate(self, data=None):
        """評估模型"""
        _, val_loader = load_data(self.config) if data is None else data
        self.model.eval()
        return evaluate_model(self.model, val_loader, self.criterion, self.device, self.config)
        
    def predict(self, input_data):
        """進行預測"""
        self.model.eval()
        with torch.no_grad():
            if not isinstance(input_data, torch.Tensor):
                input_data = torch.tensor(input_data).to(self.device)
            return self.model(input_data)
