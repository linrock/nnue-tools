FROM nvidia/cuda:11.6.2-devel-ubuntu20.04

RUN apt update --fix-missing
RUN apt install -y vim git
RUN apt install -y python3 python3-dev python3-pip
RUN ln -sf python3 /usr/bin/python

RUN pip3 install --no-cache --upgrade pip setuptools

ENV PATH=/usr/local/nvidia/bin:${PATH}
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LIBRARY_PATH=/usr/local/cuda/lib64:${LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# Install Pytorch
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y cmake
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install psutil asciimatics pytorch-lightning GPUtil cupy-cuda116

WORKDIR /app
RUN git clone https://github.com/glinscott/nnue-pytorch
