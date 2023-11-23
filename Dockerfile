FROM tensorflow/tensorflow:2.13.0-gpu

ARG DEBIAN_FRONTEND=noninteractive

ENV http_proxy=http://proxy.lan:8118
ENV https_proxy=http://proxy.lan:8118
COPY setup.py /root/
ENV PATH="/root/.local/bin:${PATH}"

# Install apt dependencies
RUN apt-get update && apt-get install -y \
    git \
    gpg-agent \
    python3-cairocffi \
    protobuf-compiler \
    python3-pil \
    python3-lxml \
    python3-tk \
    libgl1 \
    wget \
    && cd ~ \
    && git clone --depth=1 https://github.com/tensorflow/models \
    && cd models/research/ && protoc object_detection/protos/*.proto --python_out=. \
    && mv /root/setup.py . \
    && python -m pip install -U pip \
    && python -m pip install . \
    && rm setup.py \
    && apt-get autoremove -y && apt-get autoclean -y && rm -rf /var/cache/apt/*


WORKDIR /root/models/research/

