FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
# FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

ENV PATH=/usr/local/nvidia/bin:${PATH}
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LIBRARY_PATH=/usr/local/cuda/lib64:${LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
  apt update && apt install -y \
    vim git tig tree cmake tmux wget curl python3 python3-pip

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
  pip3 install torch==2.0.1+cu118 \
    --extra-index-url https://download.pytorch.org/whl/cu118

# Install rest of pip dependencies
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install python-chess==0.31.4 psutil \
  asciimatics pytorch-lightning==1.9.5 \
  tensorboardx GPUtil cupy-cuda11x

RUN git clone https://github.com/linrock/nnue-pytorch /root/nnue-pytorch
WORKDIR /root/nnue-pytorch
RUN git checkout misc-fixes
RUN sh compile_data_loader.bat

WORKDIR /root
COPY yaml_easy_train.py .
COPY .bash_profile .
RUN echo 'source .bash_profile' >> .bashrc

RUN mkdir misc
COPY misc/utils.sh misc/utils.sh

WORKDIR /usr/local/bin
COPY easy-train.sh .
RUN chmod +x easy-train.sh

WORKDIR /root
CMD sleep infinity
