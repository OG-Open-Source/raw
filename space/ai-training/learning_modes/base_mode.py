from abc import ABC, abstractmethod
from typing import Any, Dict, Optional
import torch

class BaseLearningMode(ABC):
    def __init__(self, config: Dict[str, Any], data_adapter: Any):
        self.config = config
        self.data_adapter = data_adapter
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        
    @abstractmethod
    def train(self, data: Optional[Any] = None) -> Any:
        """訓練模型"""
        pass
        
    @abstractmethod
    def evaluate(self, data: Optional[Any] = None) -> Any:
        """評估模型"""
        pass
        
    @abstractmethod
    def predict(self, input_data: Any) -> Any:
        """進行預測"""
        pass
