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
) -> Tuple[float, float]:
	"""評估模型效能"""
	model.eval()
	total_loss = 0
	correct = 0
	total = 0

	# 獲取混合精度設置
	use_amp = config and config['mixed_precision']['enabled'] if config else False

	with torch.no_grad():
		for data, target in data_loader:
			data, target = data.to(device), target.to(device)

			if use_amp:
				with autocast(device_type=device.type):
					output = model(data)
					loss = criterion(output, target)
			else:
				output = model(data)
				loss = criterion(output, target)

			total_loss += loss.item()

			pred = output.argmax(dim=1)
			correct += pred.eq(target).sum().item()
			total += target.size(0)

			# 清理快取
			if config and config['memory']['empty_cache_freq'] > 0:
				if total % config['memory']['empty_cache_freq'] == 0:
					torch.cuda.empty_cache()

	avg_loss = total_loss / len(data_loader)
	accuracy = correct / total

	return avg_loss, accuracy
