FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

ENV PATH=/usr/local/nvidia/bin:${PATH}
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LIBRARY_PATH=/usr/local/cuda/lib64:${LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

RUN apt update --fix-missing
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y \
  vim git cmake wget curl python3 python3-dev python3-pip

RUN pip3 install --no-cache --upgrade pip setuptools
RUN --mount=type=cache,target=/root/.cache/pip pip3 install \
  torch --extra-index-url https://download.pytorch.org/whl/cu117
RUN --mount=type=cache,target=/root/.cache/pip pip3 install \
  python-chess==0.31.4 psutil asciimatics pytorch-lightning==1.7.7 GPUtil cupy-cuda117

RUN ln -sf python3 /usr/bin/python

WORKDIR /app
RUN git clone https://github.com/glinscott/nnue-pytorch

WORKDIR /app/nnue-pytorch
RUN sh compile_data_loader.bat

WORKDIR /app
CMD sleep infinity
