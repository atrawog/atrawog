pixi init
pixi add python=3.12 pip jupyter jupyter_server Pillow piexif mutagen pymediainfo  jupyter-ai jupyter-cache  mystmd nodejs jupyterlab-myst altair matplotlib numpy pandas geopandas vega_datasets jupyter-book
pixi add --pypi vllm mistral mistral_common
pixi add --pypi torch torchvision torchaudio transformers accelerate sentencepiece huggingface_hub sentencepiece bitsandbytes
pixi task add jupyterlab  -- "python -m jupyter lab"
pixi shell