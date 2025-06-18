#!/bin/bash

set -euo pipefail

# === Renk tanımları ===
CYAN='\033[0;36m'
LIGHTBLUE='\033[1;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

# === Log dosyaları ===
LOG_FILE="/var/log/kurulum.log"
ERROR_LOG="/var/log/kurulum_error.log"
mkdir -p $(dirname "$LOG_FILE")
touch "$LOG_FILE" "$ERROR_LOG"

# === Hata tuzağı ===
trap 'echo -e "${RED}[HATA]${RESET} Komut basarisiz: $BASH_COMMAND (Satır: $LINENO)" | tee -a "$ERROR_LOG"' ERR

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# === dpkg durumunu kontrol et ===
check_dpkg() {
    if dpkg --audit | grep -q "dpkg was interrupted"; then
        echo -e "${RED}dpkg bir işlemi yarıda kalmış. şu komutu çalıştır: ${RESET}sudo dpkg --configure -a"
        exit 1
    fi
}

# === Komut var mı ===
command_exists() {
    command -v "$1" &> /dev/null
}

log "${CYAN}Kurulum başladı: $(date)${RESET}"

log "${CYAN}[1/12] Sistem güncelleniyor...${RESET}"
check_dpkg
apt update && apt upgrade -y

log "${CYAN}[2/12] Bağımlılıklar kuruluyor...${RESET}"
apt install -y curl git wget build-essential jq make gcc nano unzip \
    pkg-config libssl-dev lsb-release ca-certificates gnupg software-properties-common \
    docker.io docker-compose clang libclang-dev libleveldb-dev postgresql-client \
    iptables automake autoconf tmux htop nvme-cli libgbm1 bsdmainutils ncdu nvtop \
    apt-transport-https gnupg-agent

log "${CYAN}[3/12] Docker kuruluyor...${RESET}"
if ! command_exists docker; then
    apt install -y docker.io
fi

# DinD (Docker-in-Docker) ortamlarında systemd genellikle çalışmadığı için bu adımlar atlanıyor.
# Docker servisi zaten DinD konteyneri tarafından yönetiliyor olmalıdır.
log "${YELLOW}DinD (Docker-in-Docker) ortamı algılandı veya systemd kullanılamıyor. Docker servisi etkinleştirme/başlatma adımları atlanıyor.${RESET}"
# Mevcut kullanıcıyı docker grubuna ekle. root kullanıcısı için bu gerekli değildir.
if [ "$(id -un)" != "root" ]; then
    CURRENT_USER=$(id -un)
    log "${CYAN}Kullanıcı '${CURRENT_USER}' docker grubuna ekleniyor...${RESET}"
    usermod -aG docker "${CURRENT_USER}" || true
else
    log "${YELLOW}Betik root olarak çalıştığı için 'docker' grubuna kullanıcı ekleme adımı atlanıyor.${RESET}"
fi


log "${CYAN}[4/12] NVIDIA GPU kontrol ediliyor...${RESET}"
if command_exists nvidia-smi; then
    log "${GREEN}NVIDIA GPU bulundu. Kurulum devam ediyor...${RESET}"

    log "${CYAN}[5/12] NVIDIA Container Toolkit kuruluyor...${RESET}"
    distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list \
        | tee /etc/apt/sources.list.d/nvidia-docker.list
    apt update
    apt install -y nvidia-docker2

    mkdir -p /etc/docker
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

    # DinD ortamında docker servisini yeniden başlatmak genellikle sorunludur.
    log "${YELLOW}DinD ortamında Docker servisini yeniden başlatma atlanıyor. Değişiklikler için konteynerin yeniden başlatılması gerekebilir.${RESET}"
    # systemctl restart docker || echo "[!] docker yeniden başlatılamadı."

    log "${CYAN}[6/12] CUDA Toolkit kuruluyor...${RESET}"
    cuda_dist=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')$(grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"' | tr -d '.')
    wget https://developer.download.nvidia.com/compute/cuda/repos/$cuda_dist/$(uname -m)/cuda-keyring_1.1-1_all.deb
    dpkg -i cuda-keyring_1.1-1_all.deb
    rm cuda-keyring_1.1-1_all.deb
    apt-get update
    apt-get install -y cuda-toolkit
else
    log "${YELLOW}NVIDIA GPU bulunamadı. GPU adımları atlanıyor.${RESET}"
fi

log "${CYAN}[7/12] Rust kuruluyor...${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup update

log "${CYAN}[8/12] Just kuruluyor...${RESET}"
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin

log "${CYAN}[9/12] rzup ve toolchain kuruluyor...${RESET}"
curl -L https://risczero.com/install | bash
# PATH'e eklemeyi kalıcı hale getirmek için, genellikle .bashrc veya benzeri bir dosyaya eklenir.
# Ancak bu betik çalıştığı sürece yeterli olacaktır.
export PATH="$PATH:$HOME/.risc0/bin" # /root/.risc0/bin yerine $HOME kullanmak daha geneldir.
rzup install rust

log "${CYAN}[10/12] cargo-risczero kuruluyor...${RESET}"
cargo install cargo-risczero
rzup install cargo-risczero

log "${CYAN}[11/12] bento-client kuruluyor...${RESET}"
# rustup toolchain list çıktısı birden fazla satır içerebilir, en uygun olanı seçmek için dikkatli olmalıyız.
# Genellikle ilk satırda varsayılan veya kurulu olan toolchain bulunur.
TOOLCHAIN=$(rustup toolchain list | grep risc0 | head -1 | awk '{print $1}')
if [ -z "$TOOLCHAIN" ]; then
    log "${RED}HATA: risc0 toolchain bulunamadı. Lütfen rzup kurulumunu kontrol edin.${RESET}"
    exit 1
fi
RUSTUP_TOOLCHAIN=$TOOLCHAIN cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli

log "${CYAN}[12/12] boundless-cli kuruluyor...${RESET}"
cargo install --locked boundless-cli

log "${CYAN}Boundless deposu klonlanıyor...${RESET}"
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10
git submodule update --init --recursive

log "${GREEN}✅ Kurulum tamamlandı. Boundless dizinine gidip kullanmaya başlayabilirsiniz.${RESET}"
