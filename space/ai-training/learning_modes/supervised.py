from .base_mode import BaseLearningMode
from typing import Any, Dict
import torch
import logging

logger = logging.getLogger(__name__)

class SupervisedLearning(BaseLearningMode):
    def __init__(self, config: Dict[str, Any], data_adapter: Any):
        super().__init__(config, data_adapter)
        self.model = self._build_model()
        self.criterion = self._get_criterion()
        self.optimizer = self._get_optimizer()
        
    def train(self, data: Any = None):
        if data is None:
            data = self.data_adapter.load_from_config()
        # 實現訓練邏輯
        
    def evaluate(self, data: Any = None):
        if data is None:
            data = self.data_adapter.load_from_config()
        # 實現評估邏輯
        
    def predict(self, input_data: Any):
        # 實現預測邏輯
