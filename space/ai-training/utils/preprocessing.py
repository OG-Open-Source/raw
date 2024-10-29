from transformers import AutoTokenizer
from torch.utils.data import Dataset, DataLoader
import json
from typing import Dict, Any, Tuple, List
import torch

class EducationDataset(Dataset):
	def __init__(self, data_path: str, config: Dict[str, Any], is_training: bool = True):
		self.config = config
		self.tokenizer = AutoTokenizer.from_pretrained(config['text']['tokenizer'])
		self.max_length = config['text']['max_length']
		
		# 載入數據
		with open(data_path, 'r', encoding='utf-8') as f:
			self.data = json.load(f)
		self.is_training = is_training
		
		# 創建答案到標籤的映射（這裡是示例，您可以根據需要修改）
		self.answer_to_label = self._create_label_mapping()
		
	def _create_label_mapping(self) -> Dict[str, int]:
		"""創建答案到標籤的映射"""
		unique_answers = set()
		for item in self.data:
			unique_answers.add(item['answer'])
		return {answer: idx for idx, answer in enumerate(sorted(unique_answers))}
		
	def __len__(self):
		return len(self.data)
		
	def __getitem__(self, idx):
		item = self.data[idx]
		
		# 處理輸入
		question = item['question']
		context = item.get('context', '')
		
		# 組合輸入文本
		input_text = f"問題：{question}\n背景：{context}" if context else f"問題：{question}"
		
		# Tokenization
		inputs = self.tokenizer(
			input_text,
			max_length=self.max_length,
			padding='max_length',
			truncation=True,
			return_tensors='pt'
		)
		
		if self.is_training:
			# 使用答案映射到標籤
			label = torch.tensor(
				self.answer_to_label[item['answer']], 
				dtype=torch.long
			)
			
			return {
				'input_ids': inputs['input_ids'].squeeze(0),
				'attention_mask': inputs['attention_mask'].squeeze(0),
				'labels': label,
				'solution': item.get('solution', '')
			}
		
		return {
			'input_ids': inputs['input_ids'].squeeze(0),
			'attention_mask': inputs['attention_mask'].squeeze(0)
		}

def load_data(config: Dict[str, Any]) -> Tuple[DataLoader, DataLoader]:
	"""載入並預處理教育數據"""
	train_dataset = EducationDataset(
		config['data']['train_path'],
		config,
		is_training=True
	)
	
	val_dataset = EducationDataset(
		config['data']['val_path'],
		config,
		is_training=True
	)
	
	# 調整 num_workers 以避免警告
	num_workers = min(config['system']['num_workers'], 3)
	
	train_loader = DataLoader(
		train_dataset,
		batch_size=config['training']['batch_size'],
		shuffle=True,
		num_workers=num_workers,
		pin_memory=config['system']['pin_memory']
	)
	
	val_loader = DataLoader(
		val_dataset,
		batch_size=config['training']['batch_size'],
		shuffle=False,
		num_workers=num_workers,
		pin_memory=config['system']['pin_memory']
	)
	
	return train_loader, val_loader
