from setuptools import setup, find_packages

setup(
    name="ai_training",
    version="0.1",
    packages=find_packages(),
    install_requires=[
        'torch',
        'transformers',
        'datasets',
        'sentencepiece',
        'jieba',
        'nltk',
        'mlflow',
        'pyyaml',
        'tqdm',
        'numpy',
        'psutil',
        'tensorboard',
        'pandas',
        'scikit-learn',
        'pillow',
        'tabulate'
    ],
) 