from typing import Dict, Any, Union, List
from pathlib import Path
import yaml
import logging
import torch
from torch.utils.data import Dataset, DataLoader
from utils.preprocessing import EducationDataset
from learning_modes.data_adapters.supervised_adapter import SupervisedDataAdapter
from learning_modes.data_adapters.unsupervised_adapter import UnsupervisedDataAdapter
from learning_modes.data_adapters.reinforcement_adapter import RLDataAdapter
from learning_modes.data_adapters.gan_adapter import GANDataAdapter
from learning_modes.data_adapters.multi_task_adapter import MultiTaskDataAdapter

logger = logging.getLogger(__name__)

class LearningModeManager:
    """學習模式管理器"""
    
    MODES = {
        'supervised': ('SupervisedLearning', SupervisedDataAdapter),
        'unsupervised': ('UnsupervisedLearning', UnsupervisedDataAdapter),
        'reinforcement': ('ReinforcementLearning', RLDataAdapter),
        'gan': ('GANLearning', GANDataAdapter),
        'multi_task': ('MultiTaskLearning', MultiTaskDataAdapter),
        # ... 其他模式
    }
    
    def __init__(self, config_path: str):
        self.config = self._load_config(config_path)
        self.mode_type = self.config['learning_mode']['type']
        self.mode_instance = None
        self.data_adapter = None
        
    def _load_config(self, config_path: str) -> Dict[str, Any]:
        """載入配置文件"""
        with open(config_path) as f:
            return yaml.safe_load(f)
    
    def _initialize_data_adapter(self):
        """初始化數據適配器"""
        if self.mode_type not in self.MODES:
            raise ValueError(f"Unsupported learning mode: {self.mode_type}")
        
        _, adapter_class = self.MODES[self.mode_type]
        self.data_adapter = adapter_class(self.config)
        
    def initialize_mode(self):
        """初始化指定的學習模式"""
        if self.mode_type not in self.MODES:
            raise ValueError(f"Unsupported learning mode: {self.mode_type}")
        
        # 初始化數據適配器
        self._initialize_data_adapter()
        
        # 動態導入對應的學習模式類
        mode_name, _ = self.MODES[self.mode_type]
        module = __import__(f'learning_modes.{self.mode_type}', fromlist=[mode_name])
        mode_class = getattr(module, mode_name)
        
        # 創建模式實例
        self.mode_instance = mode_class(self.config, self.data_adapter)
        logger.info(f"Initialized learning mode: {self.mode_type}")
    
    def prepare_data(self, data: Union[str, Dict, List, torch.Tensor]):
        """準備數據"""
        if not self.data_adapter:
            self._initialize_data_adapter()
        return self.data_adapter.adapt(data)
    
    def train(self, data=None):
        """執行訓練"""
        if not self.mode_instance:
            self.initialize_mode()
            
        if data is not None:
            adapted_data = self.prepare_data(data)
        else:
            # 使用配置文件中指定的數據路徑
            adapted_data = self.data_adapter.load_from_config()
            
        return self.mode_instance.train(adapted_data)
    
    def evaluate(self, data=None):
        """執行評估"""
        if not self.mode_instance:
            self.initialize_mode()
            
        if data is not None:
            adapted_data = self.prepare_data(data)
        else:
            adapted_data = self.data_adapter.load_from_config()
            
        return self.mode_instance.evaluate(adapted_data)
    
    def predict(self, input_data):
        """執行預測"""
        if not self.mode_instance:
            self.initialize_mode()
            
        adapted_input = self.prepare_data(input_data)
        return self.mode_instance.predict(adapted_input)
