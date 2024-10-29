import torch
from torch import nn
from torch.utils.data import DataLoader
from typing import Tuple, Dict, Any
import numpy as np
from torch.amp import autocast

def evaluate_model(
	model: nn.Module,
	data_loader: DataLoader,
	criterion: nn.Module,
	device: torch.device,
	config: Dict[str, Any] = None
) -> Tuple[float, Dict[str, float]]:
	"""評估模型效能"""
	model.eval()
	total_loss = 0
	correct = 0
	total = 0

	# 獲取混合精度設置
	use_amp = config and config['mixed_precision']['enabled'] if config else False

	with torch.no_grad():
		for batch in data_loader:
			# 處理輸入數據
			inputs = {k: v.to(device) for k, v in batch.items() 
					 if isinstance(v, torch.Tensor)}
			
			if use_amp:
				with autocast(device_type=device.type):
					outputs = model(**inputs)
					loss = criterion(outputs, inputs['labels'])
			else:
				outputs = model(**inputs)
				loss = criterion(outputs, inputs['labels'])

			total_loss += loss.item()

			# 計算準確率
			pred = outputs.argmax(dim=1)
			correct += pred.eq(inputs['labels']).sum().item()
			total += inputs['labels'].size(0)

			# 清理快取
			if config and config['memory']['empty_cache_freq'] > 0:
				if total % config['memory']['empty_cache_freq'] == 0:
					torch.cuda.empty_cache()

	avg_loss = total_loss / len(data_loader)
	accuracy = correct / total if total > 0 else 0

	metrics = {
		'accuracy': accuracy,
		'total_samples': total,
		'correct_predictions': correct
	}

	return avg_loss, metrics
