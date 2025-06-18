#!/bin/bash

set -e

echo "🔧 [1/13] Sistem güncelleniyor..."
apt update && apt upgrade -y

echo "📦 [2/13] Temel bağımlılıklar kuruluyor..."
apt install -y curl git wget build-essential jq make gcc nano unzip \
    pkg-config libssl-dev lsb-release ca-certificates gnupg software-properties-common \
    docker.io docker-compose clang libclang-dev libleveldb-dev postgresql-client \
    iptables automake autoconf tmux htop nvme-cli libgbm1 bsdmainutils ncdu nvtop \
    apt-transport-https gnupg-agent

echo "🐳 [3/13] Docker servisi yapılandırılıyor..."
systemctl enable docker || echo "Naber"
systemctl start docker || echo "İyi bende teşekkür ederim"
usermod -aG docker $USER || true

echo "🖥️ [4/13] NVIDIA GPU kontrol ediliyor..."
if nvidia-smi &> /dev/null; then
  echo "✅ NVIDIA GPU algılandı. GPU destekli kurulum başlatılıyor."

  echo "📦 [5/13] NVIDIA Container Toolkit kuruluyor..."
  distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
  curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list \
    | tee /etc/apt/sources.list.d/nvidia-docker.list
  apt update
  apt install -y nvidia-docker2

  cat <<EOF > /etc/docker/daemon.json
{
  "default-runtime": "nvidia",
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
EOF

  systemctl restart docker || echo "ℹ️ systemctl mevcut değil, yeniden başlatılamadı."

  echo "⚙️ [6/13] CUDA Toolkit kuruluyor..."
  cuda_dist=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')$(grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"' | tr -d '.')
  wget https://developer.download.nvidia.com/compute/cuda/repos/$cuda_dist/$(uname -m)/cuda-keyring_1.1-1_all.deb
  dpkg -i cuda-keyring_1.1-1_all.deb
  rm cuda-keyring_1.1-1_all.deb
  apt-get update
  apt-get install -y cuda-toolkit
else
  echo "⚠️ NVIDIA GPU bulunamadı veya erişilemedi. GPU adımları atlanıyor."
fi

echo "🦀 [7/13] Rust kuruluyor..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup update

echo "🛠️ [8/13] Just kuruluyor..."
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

echo "📡 [9/13] rzup (RISC Zero) kuruluyor..."
curl -L https://risczero.com/install | bash
source ~/.bashrc || true
rzup install rust
export PATH="$PATH:/root/.risc0/bin"

echo "🔩 [10/13] cargo-risczero kuruluyor..."
cargo install cargo-risczero
rzup install cargo-risczero

echo "🧱 [11/13] bento-client kuruluyor..."
TOOLCHAIN=$(rustup toolchain list | grep risc0 | head -1)
RUSTUP_TOOLCHAIN=$TOOLCHAIN cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli

echo "📦 [12/13] boundless-cli kuruluyor..."
cargo install --locked boundless-cli

echo "📥 [13/13] Boundless deposu klonlanıyor..."
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10
git submodule update --init --recursive

echo "✅ Kurulum başarıyla tamamlandı!"
