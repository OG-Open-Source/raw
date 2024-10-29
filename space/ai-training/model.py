import torch
import torch.nn as nn
import logging
from typing import Dict, Any, Optional

logger = logging.getLogger(__name__)

class EnhancedNN(nn.Module):
	def __init__(self, config: Dict[str, Any]):
		super().__init__()
		self.config = config
		
		# 獲取配置參數
		self.hidden_size = config['model']['hidden_size']
		self.output_size = config['model']['output_size']
		self.dropout_rate = config['model']['dropout_rate']
		
		# 嵌入層
		self.embedding = nn.Embedding(
			config['model']['vocab_size'],
			config['model']['input_size']
		)
		
		# 使用簡單的 LSTM 替代 Transformer
		self.lstm = nn.LSTM(
			input_size=config['model']['input_size'],
			hidden_size=self.hidden_size,
			num_layers=2,
			batch_first=True,
			bidirectional=True,
			dropout=self.dropout_rate if config['model']['dropout_rate'] > 0 else 0
		)
		
		# 輸出層
		self.fc = nn.Sequential(
			nn.Linear(self.hidden_size * 2, self.hidden_size),
			nn.ReLU(),
			nn.Dropout(self.dropout_rate),
			nn.Linear(self.hidden_size, self.output_size)
		)
		
	def forward(self, input_ids: torch.Tensor, attention_mask: Optional[torch.Tensor] = None, **kwargs):
		"""
		前向傳播
		Args:
			input_ids: 輸入的token ID
			attention_mask: 注意力遮罩（在LSTM中用於處理填充）
			**kwargs: 其他參數
		"""
		# 嵌入層
		x = self.embedding(input_ids)  # [batch_size, seq_len, embedding_dim]
		
		# 如果有注意力遮罩，使用它來處理序列長度
		if attention_mask is not None:
			# 計算每個序列的實際長度
			lengths = attention_mask.sum(dim=1).cpu()
			
			# 打包序列
			packed_x = nn.utils.rnn.pack_padded_sequence(
				x, lengths, batch_first=True, enforce_sorted=False
			)
			
			# LSTM 處理
			packed_output, _ = self.lstm(packed_x)
			
			# 解包序列
			output, _ = nn.utils.rnn.pad_packed_sequence(packed_output, batch_first=True)
		else:
			output, _ = self.lstm(x)
		
		# 使用最後一個非填充位置的輸出
		if attention_mask is not None:
			# 獲取每個序列的最後一個實際位置
			last_positions = (attention_mask.sum(dim=1) - 1).unsqueeze(1).expand(-1, output.size(-1))
			last_positions = last_positions.unsqueeze(1)
			last_output = output.gather(1, last_positions).squeeze(1)
		else:
			last_output = output[:, -1]
		
		# 輸出層
		output = self.fc(last_output)
		
		return output
	
	@classmethod
	def load_model(cls, model_path: str):
		"""載入模型"""
		checkpoint = torch.load(model_path)
		model = cls(checkpoint['config'])
		model.load_state_dict(checkpoint['model_state_dict'])
		return model
