from typing import Any, Dict, Union, Tuple
import torch
from torch.utils.data import DataLoader
from .base_adapter import BaseDataAdapter

class MultiTaskDataAdapter(BaseDataAdapter):
    def adapt(self, data: Any) -> Any:
        pass
        
    def load_from_config(self) -> Any:
        pass 