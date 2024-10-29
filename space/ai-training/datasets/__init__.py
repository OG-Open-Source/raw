from .supervised import TextClassificationDataset
from .unsupervised import ClusteringDataset
from .reinforcement import RLEnvironmentDataset
from .gan import GANDataset
from .multi_task import MultiTaskDataset

DATASET_MAPPING = {
    ("supervised", "text"): TextClassificationDataset,
    ("unsupervised", "text"): ClusteringDataset,
    ("reinforcement", "sequence"): RLEnvironmentDataset,
    ("gan", "text"): GANDataset,
    ("multi_task", "multi_modal"): MultiTaskDataset
}
