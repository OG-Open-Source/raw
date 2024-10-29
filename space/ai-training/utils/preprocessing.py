from transformers import AutoTokenizer
from torch.utils.data import Dataset, DataLoader
import pandas as pd
import json
from typing import Dict, Any, Tuple, List
import torch

class EducationDataset(Dataset):
	def __init__(self, data_path: str, config: Dict[str, Any], is_training: bool = True):
		self.config = config
		self.tokenizer = AutoTokenizer.from_pretrained(config['text']['tokenizer'])
		self.max_length = config['text']['max_length']
		
		# 載入數據
		self.data = self.load_data(data_path)
		self.is_training = is_training
		
	def load_data(self, data_path: str) -> List[Dict]:
		"""載入教育數據"""
		with open(data_path, 'r', encoding='utf-8') as f:
			data = json.load(f)
		return data
		
	def __len__(self):
		return len(self.data)
		
	def __getitem__(self, idx):
		item = self.data[idx]
		
		# 處理輸入
		question = item['question']
		context = item.get('context', '')  # 可能的背景知識
		
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
			# 處理答案
			answer = item['answer']
			solution = item.get('solution', '')  # 解題步驟
			
			# 將答案轉換為模型可用格式
			answer_encoding = self.tokenizer(
				answer,
				max_length=self.max_length,
				padding='max_length',
				truncation=True,
				return_tensors='pt'
			)
			
			return {
				'input_ids': inputs['input_ids'].squeeze(0),
				'attention_mask': inputs['attention_mask'].squeeze(0),
				'labels': answer_encoding['input_ids'].squeeze(0),
				'solution': solution  # 用於訓練過程分析
			}
		
		return {
			'input_ids': inputs['input_ids'].squeeze(0),
			'attention_mask': inputs['attention_mask'].squeeze(0)
		}

def load_data(config: Dict[str, Any]) -> Tuple[DataLoader, DataLoader]:
	"""載入並預處理教育數據"""
	data_config = config['data']
	system_config = config['system']
	training_config = config['training']
	
	# 創建數據集
	train_dataset = EducationDataset(
		data_config['train_path'],
		config,
		is_training=True
	)
	
	val_dataset = EducationDataset(
		data_config['val_path'],
		config,
		is_training=True
	)
	
	# 創建數據加載器
	train_loader = DataLoader(
		train_dataset,
		batch_size=training_config['batch_size'],
		shuffle=True,
		num_workers=system_config['num_workers'],
		pin_memory=system_config['pin_memory']
	)
	
	val_loader = DataLoader(
		val_dataset,
		batch_size=training_config['batch_size'],
		shuffle=False,
		num_workers=system_config['num_workers'],
		pin_memory=system_config['pin_memory']
	)
	
	return train_loader, val_loader
