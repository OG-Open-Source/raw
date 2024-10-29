from abc import ABC, abstractmethod
from typing import Any, Dict

class BaseLearningMode(ABC):
    def __init__(self, config: Dict[str, Any], data_adapter: Any):
        self.config = config
        self.data_adapter = data_adapter
        
    @abstractmethod
    def train(self, data: Any = None) -> Any:
        pass
        
    @abstractmethod
    def evaluate(self, data: Any = None) -> Any:
        pass
        
    @abstractmethod
    def predict(self, input_data: Any) -> Any:
        pass
