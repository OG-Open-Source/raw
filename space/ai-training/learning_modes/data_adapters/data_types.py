from enum import Enum

class DataType(Enum):
    TEXT = "text"
    IMAGE = "image"
    TABULAR = "tabular"
    SEQUENCE = "sequence"
    GRAPH = "graph"
    AUDIO = "audio"
    MULTI_MODAL = "multi_modal"
