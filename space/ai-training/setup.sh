#!/bin/bash

[ -f ~/function.sh ] && source ~/function.sh || bash <(curl -sL raw.ogtt.tk/shell/update-function.sh) && source ~/function.sh

# 檢查系統資源
echo -e "${CLR3}正在檢查系統資源...${CLR0}"
GPU_AVAILABLE=$(command -v nvidia-smi >/dev/null 2>&1 && echo "yes" || echo "no")

echo "CPU 核心數：$(nproc)"
echo "總記憶體：$(MEM_USAGE)"
echo "GPU 可用：$GPU_AVAILABLE"

# 選擇訓練模式
echo -e "${CLR2}請選擇訓練模式：${CLR0}"
echo "1) 監督式學習"
echo "2) 非監督式學習"
echo "3) 半監督式學習"
echo "4) 強化學習"
echo "5) 自監督式學習"
echo "6) 遷移學習"
echo "7) GAN"
echo "8) 多任務學習"
echo "9) 聯邦學習"
read -p "請選擇訓練模式 (1-9)：" TRAINING_MODE

# 選擇數據類型
clear
echo -e "${CLR2}請選擇數據類型：${CLR0}"
echo "1) 文本"
echo "2) 圖像"
echo "3) 表格"
echo "4) 序列"
echo "5) 圖形"
echo "6) 音頻"
echo "7) 多模態"
read -p "請選擇數據類型 (1-7)：" DATA_TYPE

# 詢問性能配置
clear
echo -e "${CLR2}請選擇性能配置：${CLR0}"
echo "1) 低配置 (8GB RAM, CPU)"
echo "2) 中配置 (16GB RAM, GPU)"
echo "3) 高配置 (32GB+ RAM, GPU)"
echo "4) 自定義配置"
read -p "請輸入選擇 (1-4)：" PERFORMANCE_CONFIG

# 進階設定
echo
read -n 1 -r -p "是否需要進階設定？(y/N)：" ADVANCED_CONFIG
echo

if [[ $ADVANCED_CONFIG =~ ^[Yy]$ ]] || [ "$PERFORMANCE_CONFIG" = "4" ]; then
    echo -e "${CLR2}模型參數設定：${CLR0}"
    read -p "隱藏層大小 (默認：256)：" HIDDEN_SIZE
    read -p "注意力頭數 (默認：8)：" ATTENTION_HEADS
    read -p "推理步驟數 (默認：3)：" REASONING_STEPS
    read -p "Dropout率 (0-1, 默認：0.2)：" DROPOUT_RATE

    echo -e "${CLR2}訓練參數設定：${CLR0}"
    read -p "批次大小 (默認：32)：" BATCH_SIZE
    read -p "學習率 (默認：0.001)：" LEARNING_RATE
    read -p "訓練輪數 (默認：20)：" EPOCHS
    read -p "優化器 (adam/adamw/sgd, 默認：adamw)：" OPTIMIZER
fi

# 創建目錄結構
create_directories() {
    echo -e "${CLR3}創建目錄結構...${CLR0}"

    # 主要目錄
    mkdir -p config
    mkdir -p data/{raw,processed}
    mkdir -p models
    mkdir -p logs
    mkdir -p experiments
    mkdir -p learning_modes/data_adapters
    mkdir -p utils
    mkdir -p datasets

    # 創建 __init__.py 文件
    touch __init__.py
    touch learning_modes/__init__.py
    touch learning_modes/data_adapters/__init__.py
    touch utils/__init__.py
    touch datasets/__init__.py
}

# 創建配置文件目錄
create_config_templates() {
    echo -e "${CLR3}創建配置模板...${CLR0}"
    mkdir -p config/templates
    
    # 監督式學習 - 文本配置
    cat > config/templates/supervised_text.yaml << 'EOL'
system:
  device: "auto"
  num_workers: 4
  pin_memory: true
  memory_limit: 0.8

model:
  architecture_type: "transformer"
  input_size: 512
  hidden_size: 256
  output_size: 2
  reasoning_steps: 3
  attention_heads: 8
  dropout_rate: 0.2

text:
  tokenizer: "bert-base-chinese"
  max_length: 512
  padding: "max_length"
  truncation: true
  lowercase: true
  remove_punctuation: false
  special_tokens:
    pad: "[PAD]"
    unk: "[UNK]"
    cls: "[CLS]"
    sep: "[SEP]"

learning_mode:
  type: "supervised"

data:
  data_type: "text"
  train_path: "data/raw/train.json"
  val_path: "data/raw/val.json"
  test_path: "data/raw/test.json"
  format: "json"
  schema:
    text: "string"
    label: "int"
    metadata: "dict"

training:
  batch_size: 32
  learning_rate: 0.001
  epochs: 20
  optimizer: "adamw"
  use_scheduler: true
  early_stopping: true

mixed_precision:
  enabled: true
  dtype: "float16"
EOL

    # GAN - 圖像配置
    cat > config/templates/gan_image.yaml << 'EOL'
system:
  device: "auto"
  num_workers: 4
  pin_memory: true
  memory_limit: 0.8

model:
  architecture_type: "gan"
  input_size: 784
  hidden_size: 256
  latent_dim: 100
  generator_layers: [256, 512, 1024]
  discriminator_layers: [1024, 512, 256]
  dropout_rate: 0.3

learning_mode:
  type: "gan"

data:
  data_type: "image"
  train_path: "data/raw/images"
  image_size: 64
  channels: 3
  format: "jpg"

training:
  batch_size: 64
  learning_rate: 0.0002
  beta1: 0.5
  epochs: 100
  discriminator_steps: 1

mixed_precision:
  enabled: true
  dtype: "float16"
EOL

    # ... 其他模板
}

# 根據選擇複製對應的配置文件
select_config() {
    local mode=$1
    local data_type=$2
    
    case "${mode}_${data_type}" in
        "1_1") # 監督式學習 + 文本
            cp config/templates/supervised_text.yaml config/train_config.yaml
            ;;
        "7_2") # GAN + 圖像
            cp config/templates/gan_image.yaml config/train_config.yaml
            ;;
        # ... 其他組合
        *)
            echo -e "${CLR1}未找到對應的配置模板${CLR0}"
            exit 1
            ;;
    esac
}

# 創建示例數據
create_example_data() {
    echo -e "${CLR3}創建示例數據...${CLR0}"
    cat > data/raw/train.json << 'EOL'
[
    {
        "question": "解方程式：2x + 5 = 13",
        "context": "一元一次方程式的解法：將等號兩邊的項移動，使變數在一邊，常數在另一邊",
        "answer": "x = 4",
        "solution": "1. 2x + 5 = 13\n2. 2x = 13 - 5\n3. 2x = 8\n4. x = 4"
    }
]
EOL

    cat > data/raw/val.json << 'EOL'
[
    {
        "question": "解方程式：3x + 2 = 14",
        "context": "一元一次方程式的解法步驟",
        "answer": "x = 4",
        "solution": "1. 3x + 2 = 14\n2. 3x = 14 - 2\n3. 3x = 12\n4. x = 4"
    }
]
EOL
}

# 安裝依賴
install_dependencies() {
    echo -e "${CLR3}創建虛擬環境...${CLR0}"
    python3 -m venv /root/venv
    source /root/venv/bin/activate

    echo -e "${CLR3}安裝 PyTorch...${CLR0}"
    if [ "$GPU_AVAILABLE" = "yes" ]; then
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
    else
        pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    fi

    echo -e "${CLR3}安裝其他依賴...${CLR0}"
    pip install \
        transformers \
        datasets \
        sentencepiece \
        jieba \
        nltk \
        mlflow \
        pyyaml \
        tqdm \
        numpy \
        psutil \
        tensorboard \
        pandas \
        scikit-learn \
        pillow \
        tabulate \
        matplotlib \
        seaborn \
        plotly
}

# 主流程
clear
echo -e "${CLR2}設定摘要：${CLR0}"
echo "----------------------------------------"
echo "訓練模式：$(case $TRAINING_MODE in
    1) echo "監督式學習";;
    2) echo "非監督式學習";;
    3) echo "半監督式學習";;
    4) echo "強化學習";;
    5) echo "自監督式學習";;
    6) echo "遷移學習";;
    7) echo "GAN";;
    8) echo "多任務學習";;
    9) echo "聯邦學習";;
esac)"
echo "數據類型：$(case $DATA_TYPE in
    1) echo "文本";;
    2) echo "圖像";;
    3) echo "表格";;
    4) echo "序列";;
    5) echo "圖形";;
    6) echo "音頻";;
    7) echo "多模態";;
esac)"
echo "性能配置：$(case $PERFORMANCE_CONFIG in
    1) echo "低配置";;
    2) echo "中配置";;
    3) echo "高配置";;
    4) echo "自定義配置";;
esac)"
echo "----------------------------------------"

read -n 1 -r -p "確認開始安裝？(y/N)：" CONFIRM
echo

if [[ $CONFIRM =~ ^[Yy]$ ]]; then
    create_directories
    create_config_templates
    select_config "$TRAINING_MODE" "$DATA_TYPE"
    create_example_data
    install_dependencies
    
    echo -e "${CLR2}安裝完成！${CLR0}"
    echo -e "${CLR3}使用說明：${CLR0}"
    echo "1. 基本訓練："
    echo "   source /root/venv/bin/activate"
    echo "   python train.py --mode supervised --type text"
    echo
    echo "2. 使用進階設定："
    echo "   python train.py --mode supervised --type text \\"
    echo "       --batch-size 64 \\"
    echo "       --learning-rate 0.0001 \\"
    echo "       --epochs 50 \\"
    echo "       --hidden-size 512 \\"
    echo "       --dropout 0.3 \\"
    echo "       --device cuda \\"
    echo "       --num-workers 8"
    echo
    echo "3. 啟動訓練監控（局域網訪問）："
    echo "   mlflow ui --host 0.0.0.0 --port 5000"
    echo "   在瀏覽器中訪問：http://[伺服器IP]:5000"
    echo
    echo "4. 查看訓練日誌："
    echo "   tail -f logs/training_[timestamp].log"
    echo
    echo "5. 可用的訓練模式："
    echo "   - supervised：監督式學習"
    echo "   - unsupervised：非監督式學習"
    echo "   - reinforcement：強化學習"
    echo "   - gan：生成對抗網路"
    echo "   - multi_task：多任務學習"
    echo
    echo "6. 可用的配置類型："
    echo "   - text：文本處理"
    echo "   - image：圖像處理"
    echo "   - sequence：序列處理"
    echo
    echo "7. 進階設定選項："
    echo "   --batch-size：批次大小"
    echo "   --learning-rate：學習率"
    echo "   --epochs：訓練輪數"
    echo "   --hidden-size：隱藏層大小"
    echo "   --dropout：Dropout率"
    echo "   --device：使用設備 (cpu/cuda)"
    echo "   --num-workers：工作線程數"
    
    # 如果是在 Linux 系統上，提供防火牆設置提示
    if [ -f "/etc/os-release" ]; then
        echo
        echo "注意：如果要從其他機器訪問 MLflow UI，請確保防火牆允許 5000 端口："
        echo "sudo ufw allow 5000/tcp  # Ubuntu/Debian"
        echo "sudo firewall-cmd --permanent --add-port=5000/tcp  # CentOS/RHEL"
        echo "sudo firewall-cmd --reload"
    fi
else
    echo -e "${CLR1}安裝已取消${CLR0}"
    exit 1
fi