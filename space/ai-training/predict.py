import torch
from model import EnhancedNN, load_model_config
import logging
from pathlib import Path
import numpy as np
from typing import List, Union, Dict, Any

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class Predictor:
	def __init__(self, model_path: str, config: Dict[str, Any]):
		self.config = config
		device_str = config['system'].get('device', 'auto')
		self.device = (torch.device('cuda' if torch.cuda.is_available() else 'cpu')
					  if device_str == 'auto' else torch.device(device_str))

		self.model = EnhancedNN.load_model(model_path).to(self.device)
		self.model.eval()

		# 設置推理參數
		self.min_steps = config['inference'].get('min_reasoning_steps', 2)
		self.max_steps = config['inference'].get('max_reasoning_steps', 5)
		self.threshold = config['inference'].get('reasoning_threshold', 0.85)
		self.temperature = config['inference'].get('temperature', 1.0)

	def predict(self, input_data: Union[np.ndarray, torch.Tensor]) -> List[int]:
		"""進行預測"""
		if isinstance(input_data, np.ndarray):
			input_data = torch.from_numpy(input_data).float()

		input_data = input_data.to(self.device)

		with torch.no_grad():
			# 動態調整推理步驟
			self.model.num_reasoning_steps = self.min_steps
			output = self.model(input_data)
			confidence = torch.max(torch.softmax(output / self.temperature, dim=1))

			# 如果置信度低，增加推理步驟
			while (confidence < self.threshold and
				   self.model.num_reasoning_steps < self.max_steps):
				self.model.num_reasoning_steps += 1
				output = self.model(input_data)
				confidence = torch.max(torch.softmax(output / self.temperature, dim=1))

			predictions = output.argmax(dim=1).cpu().numpy()

		return predictions.tolist()

	def get_reasoning_process(self, input_data: torch.Tensor) -> List[torch.Tensor]:
		"""獲取推理過程"""
		return self.model.get_reasoning_path(input_data)

if __name__ == '__main__':
	config_path = 'config/train_config.yaml'
	model_path = 'models/best_model.pt'

	# 載入配置
	config = load_model_config(config_path)
	predictor = Predictor(model_path, config)

	# 測試預測
	test_input = torch.randn(5, 784)
	predictions = predictor.predict(test_input)
	logger.info(f"Predictions: {predictions}")
