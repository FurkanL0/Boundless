#!/bin/bash

set -e

echo "🔄 Sistem güncelleniyor..."
apt update && apt upgrade -y

echo "📦 Temel bağımlılıklar kuruluyor..."
apt install -y curl git wget build-essential jq make gcc nano unzip \
    pkg-config libssl-dev lsb-release ca-certificates gnupg software-properties-common \
    docker.io docker-compose clang libclang-dev libleveldb-dev postgresql-client \
    ubuntu-drivers-common iptables automake autoconf tmux htop nvme-cli libgbm1 \
    bsdmainutils ncdu nvtop apt-transport-https gnupg-agent

echo "🖥️ NVIDIA sürücüleri kuruluyor..."
ubuntu-drivers install

echo "🐳 Docker servisi başlatılıyor..."
systemctl enable docker
systemctl start docker
usermod -aG docker $USER

echo "⚙️ NVIDIA Container Toolkit kuruluyor..."
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
apt update
apt install -y nvidia-docker2

echo '{
  "default-runtime": "nvidia",
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}' > /etc/docker/daemon.json

systemctl restart docker

echo "📦 CUDA Toolkit kuruluyor..."
distribution=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')$(grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"' | tr -d '.')
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/$(uname -m)/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
rm cuda-keyring_1.1-1_all.deb
apt-get update
apt-get install -y cuda-toolkit

echo "🦀 Rust kuruluyor..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
rustup update

echo "🛠️ Just kuruluyor..."
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

echo "📡 rzup kuruluyor..."
curl -L https://risczero.com/install | bash
source ~/.bashrc || true
rzup install rust
export PATH="$PATH:/root/.risc0/bin"

echo "🔩 cargo-risczero kuruluyor..."
cargo install cargo-risczero
rzup install cargo-risczero

echo "🧱 bento-client kuruluyor..."
TOOLCHAIN=$(rustup toolchain list | grep risc0 | head -1)
RUSTUP_TOOLCHAIN=$TOOLCHAIN cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli

echo "🧠 boundless-cli kuruluyor..."
cargo install --locked boundless-cli

echo "📥 Boundless deposu klonlanıyor..."
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10
git submodule update --init --recursive

echo "✅ Kurulum tamamlandı!"
