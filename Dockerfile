FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

ENV PATH=/usr/local/nvidia/bin:${PATH}
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LIBRARY_PATH=/usr/local/cuda/lib64:${LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

RUN apt update --fix-missing
RUN apt install -y vim git
RUN apt install -y python3 python3-dev python3-pip
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y cmake

RUN pip3 install --no-cache --upgrade pip setuptools
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install torch --extra-index-url https://download.pytorch.org/whl/cu117
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install psutil asciimatics pytorch-lightning GPUtil cupy-cuda117

RUN ln -sf python3 /usr/bin/python

WORKDIR /app
RUN git clone https://github.com/glinscott/nnue-pytorch

CMD sleep infinity
