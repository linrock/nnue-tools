# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda
# FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
# FROM nvidia/cuda:12.1.0-devel-ubuntu22.04
FROM nvidia/cuda:12.3.0-devel-ubuntu22.04

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch
# FROM nvcr.io/nvidia/pytorch:23.12-py3

RUN apt update -y && apt upgrade -y && apt install -y \
    vim git tig tree gawk cmake tmux wget curl python3 python3-pip

RUN ln -sf python3 /usr/bin/python
RUN pip3 install --no-cache --upgrade pip setuptools

# Clone torch repo, then compile and install
# RUN git clone --recursive https://github.com/pytorch/pytorch /root/pytorch
# WORKDIR /root/pytorch
# RUN git checkout v2.0.1
# RUN git submodule sync
# RUN git submodule update --init --recursive
# RUN python3 setup.py develop

# Install torch 2.0+
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install torch==2.1.2+cu121 \
    --extra-index-url https://download.pytorch.org/whl/cu121

# Install rest of pip dependencies
COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install -r requirements.txt

# RUN git clone https://github.com/linrock/nnue-pytorch /root/nnue-pytorch
RUN git clone https://github.com/official-stockfish/nnue-pytorch /root/nnue-pytorch
WORKDIR /root/nnue-pytorch
# RUN git checkout misc-fixes
RUN sh compile_data_loader.bat

WORKDIR /root
COPY yaml_easy_train.py .
COPY .bash_profile .
RUN echo 'source .bash_profile' >> .bashrc

RUN mkdir misc
COPY misc/utils.sh misc/utils.sh
COPY misc/get_native_properties.sh misc/get_native_properties.sh

WORKDIR /usr/local/bin
COPY easy-train.sh .
COPY fetch-nnue.sh .
RUN chmod +x easy-train.sh
RUN chmod +x fetch-nnue.sh

WORKDIR /root
CMD sleep infinity
