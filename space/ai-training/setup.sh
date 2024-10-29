#!/bin/bash

[ -f ~/function.sh ] && source ~/function.sh || bash <(curl -sL raw.ogtt.tk/shell/update-function.sh) && source ~/function.sh

# 檢查系統資源
echo -e "${CLR3}正在檢查系統資源...${CLR0}"
GPU_AVAILABLE=$(command -v nvidia-smi >/dev/null 2>&1 && echo "yes" || echo "no")

echo "CPU 核心數: $(nproc)"
echo "總記憶體: $(MEM_USAGE)"
echo "GPU 可用: $GPU_AVAILABLE"

# 選擇訓練模式
echo -e "${CLR2}請選擇訓練模式:${CLR0}"
echo "1) 監督式學習"
echo "2) 非監督式學習"
echo "3) 半監督式學習"
echo "4) 強化學習"
echo "5) 自監督學習"
echo "6) 遷移學習"
echo "7) GAN"
echo "8) 多任務學習"
echo "9) 聯邦學習"
read -p "請選擇訓練模式 (1-9): " TRAINING_MODE

# 選擇數據類型
echo -e "${CLR2}請選擇數據類型:${CLR0}"
echo "1) 文本"
echo "2) 圖像"
echo "3) 表格"
echo "4) 序列"
echo "5) 圖形"
echo "6) 音頻"
echo "7) 多模態"
read -p "請選擇數據類型 (1-7): " DATA_TYPE

# 詢問性能配置
echo -e "${CLR2}請選擇性能配置:${CLR0}"
echo "1) 低配置 (8GB RAM, CPU)"
echo "2) 中配置 (16GB RAM, GPU)"
echo "3) 高配置 (32GB+ RAM, GPU)"
echo "4) 自定義配置"
read -p "請輸入選擇 (1-4): " PERFORMANCE_CONFIG

# 進階設定
if [ "$PERFORMANCE_CONFIG" = "4" ] || read -p "是否需要進階設定? (y/n): " ADVANCED_CONFIG && [ "$ADVANCED_CONFIG" = "y" ]; then
    # 模型參數設定
    echo -e "${CLR2}模型參數設定:${CLR0}"
    read -p "隱藏層大小 (默認: 256): " HIDDEN_SIZE
    read -p "注意力頭數 (默認: 8): " ATTENTION_HEADS
    read -p "推理步驟數 (默認: 3): " REASONING_STEPS
    read -p "Dropout率 (0-1, 默認: 0.2): " DROPOUT_RATE
    
    # 訓練參數設定
    echo -e "${CLR2}訓練參數設定:${CLR0}"
    read -p "批次大小 (默認: 32): " BATCH_SIZE
    read -p "學習率 (默認: 0.001): " LEARNING_RATE
    read -p "訓練輪數 (默認: 20): " EPOCHS
    read -p "優化器 (adam/adamw/sgd, 默認: adamw): " OPTIMIZER
    read -p "是否使用混合精度訓練? (y/n, 默認: y): " USE_AMP
    read -p "是否使用梯度檢查點? (y/n, 默認: n): " USE_CHECKPOINT
    read -p "是否使用學習率調度? (y/n, 默認: y): " USE_SCHEDULER
    read -p "是否使用早停? (y/n, 默認: y): " USE_EARLY_STOPPING
fi

# 更新系統
echo -e "${CLR3}更新系統...${CLR0}"
sudo apt-get update
sudo apt-get upgrade -y

# 安裝必要的系統套件
echo -e "${CLR3}安裝系統套件...${CLR0}"
sudo apt-get install -y \
		python3 \
		python3-pip \
		python3-venv \
		git \
		wget \
		curl

# 如果有GPU，安裝CUDA
if [ "$GPU_AVAILABLE" = "yes" ]; then
		echo -e "${CLR3}安裝 CUDA 工具包...${CLR0}"
		sudo apt-get install -y nvidia-cuda-toolkit
fi

# 創建虛擬環境
echo -e "${CLR3}創建 Python 虛擬環境...${CLR0}"
python3 -m venv venv
source venv/bin/activate

# 配置文件處理
CONFIG_FILE="config/train_config.yaml"
BACKUP_CONFIG="${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"

# 備份原始配置文件
if [ -f "$CONFIG_FILE" ]; then
    echo -e "${CLR3}備份原始配置文件到 ${BACKUP_CONFIG}${CLR0}"
    cp "$CONFIG_FILE" "$BACKUP_CONFIG"
fi

# 生成新配置文件
echo -e "${CLR3}生成配置文件...${CLR0}"
cat > "$CONFIG_FILE" << EOL
# 系統資源設定
system:
  device: "$([ "$GPU_AVAILABLE" = "yes" ] && echo "cuda" || echo "cpu")"
  num_workers: $(nproc)
  pin_memory: $([ "$GPU_AVAILABLE" = "yes" ] && echo "true" || echo "false")
  memory_limit: 0.8

# 學習模式設定
learning_mode:
  type: "$(case $TRAINING_MODE in
    1) echo "supervised";;
    2) echo "unsupervised";;
    3) echo "semi_supervised";;
    4) echo "reinforcement";;
    5) echo "self_supervised";;
    6) echo "transfer";;
    7) echo "gan";;
    8) echo "multi_task";;
    9) echo "federated";;
  esac)"

# 數據設定
data:
  data_type: "$(case $DATA_TYPE in
    1) echo "text";;
    2) echo "image";;
    3) echo "tabular";;
    4) echo "sequence";;
    5) echo "graph";;
    6) echo "audio";;
    7) echo "multi_modal";;
  esac)"

# 模型架構參數
model:
  architecture_type: "transformer"
  input_size: 512
  hidden_size: ${HIDDEN_SIZE:-256}
  attention_heads: ${ATTENTION_HEADS:-8}
  reasoning_steps: ${REASONING_STEPS:-3}
  dropout_rate: ${DROPOUT_RATE:-0.2}

# 訓練參數
training:
  batch_size: ${BATCH_SIZE:-32}
  learning_rate: ${LEARNING_RATE:-0.001}
  epochs: ${EPOCHS:-20}
  optimizer: ${OPTIMIZER:-adamw}
  use_scheduler: ${USE_SCHEDULER:-true}
  early_stopping: ${USE_EARLY_STOPPING:-true}
  
# 性能優化
performance:
  mixed_precision:
    enabled: ${USE_AMP:-true}
    dtype: "float16"
  gradient_checkpointing: ${USE_CHECKPOINT:-false}
EOL

echo -e "${GREEN}配置文件已更新。原始配置已備份到 ${BACKUP_CONFIG}${NC}"
echo -e "${YELLOW}如需恢復原始配置，請執行: mv ${BACKUP_CONFIG} ${CONFIG_FILE}${NC}"

# 安裝 PyTorch
echo -e "${CLR3}安裝 PyTorch...${CLR0}"
if [ "$GPU_AVAILABLE" = "yes" ]; then
	pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
else
	pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
fi

# 安裝其他依賴
echo -e "${CLR3}安裝其他依賴...${CLR0}"
pip install -r requirements.txt

# 安裝專案
echo -e "${CLR3}安裝專案...${CLR0}"
pip install -e .

# 顯示完成信息
echo -e "${CLR2}安裝完成！${CLR0}"
echo -e "${CLR3}配置摘要:${CLR0}"
echo "訓練類型: $([ "$TRAINING_MODE" = "1" ] && echo "文本訓練" || echo "圖像訓練")"
echo "性能配置: $([ "$PERFORMANCE_CONFIG" = "1" ] && echo "低配置" || ([ "$PERFORMANCE_CONFIG" = "2" ] && echo "中配置" || echo "高配置"))"
echo "批次大小: ${BATCH_SIZE:-32}"
echo "學習率: ${LEARNING_RATE:-0.001}"
echo "訓練輪數: ${EPOCHS:-20}"
echo "使用設備: $([ "$GPU_AVAILABLE" = "yes" ] && echo "GPU" || echo "CPU")"

echo -e "${CLR2}使用說明:${CLR0}"
echo "1. 啟動訓練:"
echo "   source venv/bin/activate"
echo "   python train.py"
echo "2. 監控訓練:"
echo "   mlflow ui"
echo "3. 查看訓練日誌:"
echo "   tail -f logs/training.log"

# 檢查安裝
python -c "import torch; print('CUDA available:', torch.cuda.is_available())"