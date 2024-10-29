from .supervised import (
    TextClassificationDataset,
    ImageClassificationDataset,
    TabularDataset
)
from .unsupervised import (
    ClusteringDataset,
    AutoEncoderDataset
)
from .reinforcement import (
    RLEnvironmentDataset,
    ReplayBufferDataset
)
from .gan import (
    GANDataset,
    ImageGenerationDataset
)
from .multi_task import MultiTaskDataset
from .self_supervised import (
    MaskedLanguageDataset,
    ContrastiveDataset
)
from .federated import FederatedDataset

DATASET_MAPPING = {
    # 監督式學習
    ("supervised", "text"): TextClassificationDataset,
    ("supervised", "image"): ImageClassificationDataset,
    ("supervised", "tabular"): TabularDataset,
    
    # 非監督式學習
    ("unsupervised", "text"): ClusteringDataset,
    ("unsupervised", "image"): AutoEncoderDataset,
    
    # 強化學習
    ("reinforcement", "sequence"): RLEnvironmentDataset,
    ("reinforcement", "memory"): ReplayBufferDataset,
    
    # GAN
    ("gan", "image"): ImageGenerationDataset,
    ("gan", "text"): GANDataset,
    
    # 多任務學習
    ("multi_task", "multi_modal"): MultiTaskDataset,
    
    # 自監督學習
    ("self_supervised", "text"): MaskedLanguageDataset,
    ("self_supervised", "image"): ContrastiveDataset,
    
    # 聯邦學習
    ("federated", "any"): FederatedDataset
}
