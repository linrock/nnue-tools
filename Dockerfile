FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

ENV PATH=/usr/local/nvidia/bin:${PATH}
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LIBRARY_PATH=/usr/local/cuda/lib64:${LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install -y \
  vim git tig tree cmake tmux wget curl python3 python3-pip

RUN pip3 install --no-cache --upgrade pip setuptools
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install torch==1.13.1+cu117 \
    --extra-index-url https://download.pytorch.org/whl/cu117
RUN --mount=type=cache,target=/root/.cache/pip \
  pip3 install python-chess==0.31.4 psutil \
  asciimatics pytorch-lightning==1.9.4 \
   GPUtil cupy-cuda117
RUN ln -sf python3 /usr/bin/python

RUN git clone https://github.com/linrock/nnue-pytorch /root/nnue-pytorch
WORKDIR /root/nnue-pytorch
RUN git checkout misc-fixes
RUN sh compile_data_loader.bat

WORKDIR /root
COPY .bash_profile .
RUN echo 'source .bash_profile' >> .bashrc
COPY misc .

CMD sleep infinity
