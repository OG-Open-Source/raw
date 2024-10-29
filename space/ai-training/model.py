import torch
import torch.nn as nn
import torch.nn.functional as F
from typing import Dict, Any, List, Tuple
import yaml
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class BaseModel(nn.Module):
	"""基礎模型類別"""
	def __init__(self, config: Dict[str, Any]):
		super().__init__()
		self.config = config
		self.build_model()

	def build_model(self):
		"""建立模型架構 (由子類別實作)"""
		raise NotImplementedError

	def forward(self, x):
		"""前向傳播 (由子類別實作)"""
		raise NotImplementedError

	def save_model(self, path: str):
		"""儲存模型"""
		try:
			torch.save({
				'model_state_dict': self.state_dict(),
				'config': self.config
			}, path)
			logger.info(f"Model saved to {path}")
		except Exception as e:
			logger.error(f"Error saving model: {e}")

	@classmethod
	def load_model(cls, path: str):
		"""載入模型"""
		try:
			checkpoint = torch.load(path)
			model = cls(checkpoint['config'])
			model.load_state_dict(checkpoint['model_state_dict'])
			logger.info(f"Model loaded from {path}")
			return model
		except Exception as e:
			logger.error(f"Error loading model: {e}")
			raise e

class AttentionLayer(nn.Module):
	"""多頭注意力層"""
	def __init__(self, embed_dim, num_heads):
		super().__init__()
		self.attention = nn.MultiheadAttention(embed_dim, num_heads)
		self.norm = nn.LayerNorm(embed_dim)

	def forward(self, x):
		attn_output, _ = self.attention(x, x, x)
		return self.norm(x + attn_output)

class ReasoningBlock(nn.Module):
	"""推理區塊"""
	def __init__(self, hidden_size):
		super().__init__()
		self.rnn = nn.GRU(
			input_size=hidden_size * 2,
			hidden_size=hidden_size,
			bidirectional=True,
			batch_first=True
		)
		self.attention = AttentionLayer(hidden_size * 2, 4)
		self.ffn = nn.Sequential(
			nn.Linear(hidden_size * 2, hidden_size * 4),
			nn.ReLU(),
			nn.Linear(hidden_size * 4, hidden_size * 2)
		)
		self.norm = nn.LayerNorm(hidden_size * 2)

		# 添加記憶整合層
		self.memory_integration = nn.Linear(hidden_size * 4, hidden_size * 2)

	def forward(self, x, memory: List[torch.Tensor] = None):
		# 調整輸入格式
		x = x.transpose(0, 1)  # [batch, seq_len, hidden_size * 2]

		# GRU 處理
		rnn_out, _ = self.rnn(x)

		# 轉回原來的格式
		rnn_out = rnn_out.transpose(0, 1)  # [seq_len, batch, hidden_size * 2]

		# 注意力機制
		attended = self.attention(rnn_out)

		# 記憶整合
		if memory and len(memory) > 0:
			# 將所有記憶壓縮成一個張量
			memory_tensor = torch.stack(memory)  # [num_memories, seq_len, batch, hidden]
			memory_mean = memory_tensor.mean(dim=0)  # [seq_len, batch, hidden]

			# 連接當前狀態和記憶
			combined = torch.cat([attended, memory_mean], dim=-1)  # [seq_len, batch, hidden*4]

			# 整合記憶
			attended = self.memory_integration(combined)  # [seq_len, batch, hidden*2]

		# 前饋網路處理
		ffn_out = self.ffn(attended)
		return self.norm(attended + ffn_out)

class EnhancedNN(BaseModel):
	"""增強型神經網路"""
	def build_model(self):
		input_size = self.config.get('input_size', 784)
		hidden_size = self.config.get('hidden_size', 256)
		output_size = self.config.get('output_size', 10)
		self.num_reasoning_steps = self.config.get('reasoning_steps', 3)

		# 理解層
		self.understanding = nn.Sequential(
			nn.Linear(input_size, hidden_size),
			nn.ReLU(),
			nn.Linear(hidden_size, hidden_size * 2)
		)

		# 推理層
		self.reasoning_blocks = nn.ModuleList([
			ReasoningBlock(hidden_size)
			for _ in range(self.num_reasoning_steps)
		])

		# 輸出層
		self.output_layer = nn.Sequential(
			nn.Linear(hidden_size * 2, hidden_size),
			nn.ReLU(),
			nn.Linear(hidden_size, output_size)
		)

		# 思維鏈優化器
		self.chain_optimizer = nn.Parameter(
			torch.randn(self.num_reasoning_steps, hidden_size * 2)
		)

	def forward(self, x):
		batch_size = x.size(0)

		# 1. 理解階段
		understanding = self.understanding(x)  # [batch_size, hidden_size * 2]
		understanding = understanding.unsqueeze(0)  # [1, batch_size, hidden_size * 2]

		# 2. 多步推理
		memory = []
		current_state = understanding

		for i, reasoning_block in enumerate(self.reasoning_blocks):
			# 應用思維鏈優化
			chain_weight = F.softmax(self.chain_optimizer[i], dim=0)
			chain_weight = chain_weight.view(1, 1, -1)  # [1, 1, hidden_size * 2]
			weighted_state = current_state * chain_weight  # [1, batch_size, hidden_size * 2]

			# 進行推理
			reasoned = reasoning_block(weighted_state, memory)
			memory.append(reasoned)
			current_state = reasoned

		# 3. 整合所有推理結果
		final_state = torch.stack(memory).mean(0)  # [1, batch_size, hidden_size * 2]
		final_state = final_state.squeeze(0)  # [batch_size, hidden_size * 2]

		# 4. 生成輸出
		output = self.output_layer(final_state)  # [batch_size, output_size]
		return output

	def get_reasoning_path(self, x) -> List[torch.Tensor]:
		"""獲取推理路徑，用於分析模型的思考過程"""
		with torch.no_grad():
			understanding = self.understanding(x)
			understanding = understanding.unsqueeze(0)

			reasoning_states = []
			current_state = understanding

			for reasoning_block in self.reasoning_blocks:
				reasoned = reasoning_block(current_state)
				reasoning_states.append(reasoned)
				current_state = reasoned

			return reasoning_states

def load_model_config(config_path: str) -> Dict[str, Any]:
	"""載入模型設定"""
	try:
		with open(config_path, 'r') as f:
			config = yaml.safe_load(f)
		return config
	except Exception as e:
		logger.error(f"Error loading config: {e}")
		raise e
