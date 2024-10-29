from typing import Any, Dict, Union, Tuple
import torch
from abc import ABC, abstractmethod
from ...datasets import DATASET_MAPPING
from ..data_types import DataType

class BaseDataAdapter(ABC):
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.mode_type = config['learning_mode']['type']
        self.data_type = self._determine_data_type()
        
    def _determine_data_type(self) -> str:
        """根據配置確定數據類型"""
        if 'data_type' in self.config['data']:
            return self.config['data']['data_type']
        else:
            # 根據數據路徑或其他配置推斷數據類型
            return self._infer_data_type()
    
    def _infer_data_type(self) -> str:
        """推斷數據類型"""
        data_path = self.config['data']['train_path']
        if data_path.endswith(('.txt', '.json', '.csv')):
            return DataType.TEXT.value
        elif data_path.endswith(('.jpg', '.png', '.jpeg')):
            return DataType.IMAGE.value
        # ... 其他類型的推斷
        return DataType.TEXT.value  # 默認為文本
    
    def _get_dataset_class(self):
        """獲取對應的數據集類"""
        key = (self.mode_type, self.data_type)
        if key not in DATASET_MAPPING:
            raise ValueError(f"Unsupported dataset type: {key}")
        return DATASET_MAPPING[key]
    
    @abstractmethod
    def adapt(self, data: Any) -> Any:
        """將輸入數據轉換為特定學習模式需要的格式"""
        pass
    
    @abstractmethod
    def load_from_config(self) -> Any:
        """從配置文件指定的路徑載入數據"""
        pass
