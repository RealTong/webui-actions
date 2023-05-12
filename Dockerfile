FROM nvidia/cuda:11.7.0-cudnn8-devel-ubuntu22.04

# 换清华大学源
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install git vim iproute2 net-tools wget curl libgl1 libglib2.0-0 python3-venv -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash infmonkeys

USER infmonkeys

WORKDIR /workspace

ADD "webui.sh" "./webui.sh"

RUN bash webui.sh --skip-torch-cuda-test --exit && \
    rm -rf ~/.cache/pip && \
    rm -f "./webui.sh"

WORKDIR /workspace/stable-diffusion-webui

EXPOSE 7860

CMD ["bash", "-c", "source venv/bin/activate && ./webui.sh", "--listen ","--disable-safe-unpickle"]