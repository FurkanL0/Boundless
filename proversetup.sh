#!/bin/bash

# =============================================================================
# Boundless Prover Node Setup Script
# Description: Automated installation and configuration of Boundless prover node
# =============================================================================

set -euo pipefail

# Color variables
CYAN='\033[0;36m'
LIGHTBLUE='\033[1;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

# Constants
SCRIPT_NAME="$(basename "$0")"
LOG_FILE="/var/log/boundless_prover_setup.log"
ERROR_LOG="/var/log/boundless_prover_error.log"
INSTALL_DIR="$HOME/boundless"
COMPOSE_FILE="$INSTALL_DIR/compose.yml"
BROKER_CONFIG="$INSTALL_DIR/broker.toml"

# Exit codes
EXIT_SUCCESS=0
EXIT_OS_CHECK_FAILED=1
EXIT_DPKG_ERROR=2
EXIT_DEPENDENCY_FAILED=3
EXIT_GPU_ERROR=4
EXIT_NETWORK_ERROR=5
EXIT_USER_ABORT=6
EXIT_UNKNOWN=99

# Flags
ALLOW_ROOT=false
FORCE_RECLONE=false
START_IMMEDIATELY=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --allow-root)
            ALLOW_ROOT=true
            shift
            ;;
        --force-reclone)
            FORCE_RECLONE=true
            shift
            ;;
        --start-immediately)
            START_IMMEDIATELY=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --allow-root        Allow running as root without warning"
            echo "  --force-reclone     Automatically delete and re-clone directory (if exists)"
            echo "  --start-immediately Automatically launch management script"
            echo "  --help              Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: <span class="math-inline">1"
exit 1
;;
esac
done
\# Trap function for logging on exit
cleanup\_on\_exit\(\) \{
local exit\_code\=</span>?
    if [ $exit_code -ne 0 ]; then
        error "Installation failed with exit code $exit_code."
        echo "[EXIT] Script exited on $(date) with code $exit_code." >> "$ERROR_LOG"
        echo "[EXIT] Last command: ${BASH_COMMAND}" >> "$ERROR_LOG"
        echo "[EXIT] Line number: ${BASH_LINENO[0]}" >> "$ERROR_LOG"
        echo "[EXIT] Function stack: ${FUNCNAME[@]}" >> "<span class="math-inline">ERROR\_LOG"
echo \-e "\\n</span>{RED}<span class="math-inline">\{BOLD\}Installation Failed\!</span>{RESET}"
        echo -e "${YELLOW}Check error log at: <span class="math-inline">ERROR\_LOG</span>{RESET}"
        echo -e "${YELLOW}Check full log at: <span class="math-inline">LOG\_FILE</span>{RESET}"

        case $exit_code in
            <span class="math-inline">EXIT\_DPKG\_ERROR\)
echo \-e "\\n</span>{RED}DPKG Configuration Error Detected!<span class="math-inline">\{RESET\}"
echo \-e "</span>{YELLOW}Please run manually: <span class="math-inline">\{RESET\}"
echo \-e "</span>{BOLD}dpkg --configure -a${RESET}"
                echo -e "<span class="math-inline">\{YELLOW\}Then run this setup script again\.</span>{RESET}"
                ;;
            <span class="math-inline">EXIT\_OS\_CHECK\_FAILED\)
echo \-e "\\n</span>{RED}OS check failed!${RESET}"
                ;;
            <span class="math-inline">EXIT\_DEPENDENCY\_FAILED\)
echo \-e "\\n</span>{RED}Dependency installation failed!${RESET}"
                ;;
            <span class="math-inline">EXIT\_GPU\_ERROR\)
echo \-e "\\n</span>{RED}GPU configuration error!<span class="math-inline">\{RESET\}"
;;
\*\)
echo \-e "\\n</span>{RED}An unknown error occurred!${RESET}"
                ;;
        esac
    fi
}

# Set trap
trap cleanup_on_exit EXIT
trap 'echo "[SIGNAL] Signal ${?} caught at line ${LINENO}" >> "<span class="math-inline">ERROR\_LOG"' ERR
\# Functions
info\(\) \{
printf "</span>{CYAN}[INFO]${RESET} %s\n" "$1"
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "<span class="math-inline">LOG\_FILE"
\}
success\(\) \{
printf "</span>{GREEN}[SUCCESS]${RESET} %s\n" "$1"
    echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "<span class="math-inline">LOG\_FILE"
\}
error\(\) \{
printf "</span>{RED}[ERROR]${RESET} %s\n" "$1" >&2
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "<span class="math-inline">ERROR\_LOG"
\}
warning\(\) \{
printf "</span>{YELLOW}[WARNING]${RESET} %s\n" "$1"
    echo "[WARNING] $(date '+%Y-%m-%d %H:%M:%S') - $1" >> "<span class="math-inline">LOG\_FILE"
\}
prompt\(\) \{
printf "</span>{PURPLE}[PROMPT]${RESET} %s" "<span class="math-inline">1"
\}
\# Check for dpkg errors
check\_dpkg\_status\(\) \{
if dpkg \-\-audit 2\>&1 \| grep \-q "dpkg was interrupted"; then
error "dpkg was interrupted \- manual intervention required"
return 1
fi
return 0
\}
\# Check OS compatibility \(no prompt\)
check\_os\(\) \{
info "İşletim sistemi uyumluluğu kontrol ediliyor\.\.\."
if \[\[ \-f /etc/os\-release \]\]; then
\. /etc/os\-release
if \[\[ "</span>{ID,,}" != "ubuntu" ]]; then
            error "Unsupported OS: $NAME. This script is for Ubuntu."
            exit <span class="math-inline">EXIT\_OS\_CHECK\_FAILED
elif \[\[ "</span>{VERSION_ID,,}" != "22.04" && "${VERSION_ID,,}" != "20.04" ]]; then
            warning "Tested on Ubuntu 20.04/22.04. Your version: $VERSION_ID"
            info "Desteklenmeyen Ubuntu sürümü tespit edildi, ancak kuruluma devam ediliyor." # Prompt kaldırıldı
        else
            info "Operating System: $PRETTY_NAME"
        fi
    else
        error "/etc/os-release not found. Unable to determine OS."
        exit $EXIT_OS_CHECK_FAILED
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if package is installed
is_package_installed() {
    dpkg -s "$1" &> /dev/null
}

# Update system
update_system() {
    info "Sistem paketleri güncelleniyor..."
    if ! check_dpkg_status; then
        exit $EXIT_DPKG_ERROR
    fi
    {
        if ! apt update -y 2>&1; then
            error "apt update başarısız oldu"
            if apt update 2>&1 | grep -q "dpkg was interrupted"; then
                exit $EXIT_DPKG_ERROR
            fi
            exit $EXIT_DEPENDENCY_FAILED
        fi
        if ! apt upgrade -y 2>&1; then
            error "apt upgrade başarısız oldu"
            if apt upgrade 2>&1 | grep -q "dpkg was interrupted"; then
                exit $EXIT_DPKG_ERROR
            fi
            exit $EXIT_DEPENDENCY_FAILED
        fi
    } >> "$LOG_FILE" 2>&1
    success "Sistem paketleri güncellendi"
}

# Install basic dependencies
install_basic_deps() {
    local packages=(
        curl iptables build-essential git wget lz4 jq make gcc nano
        automake autoconf tmux htop nvme-cli libgbm1 pkg-config
        libssl-dev tar clang bsdmainutils ncdu unzip libleveldb-dev
        libclang-dev ninja-build nvtop ubuntu-drivers-common
        gnupg ca-certificates lsb-release postgresql-client
    )
    info "Temel bağımlılıklar yükleniyor..."
    if ! check_dpkg_status; then
        exit <span class="math-inline">EXIT\_DPKG\_ERROR
fi
\{
if \! apt install \-y "</span>{packages[@]}" 2>&1; then
            error "Temel bağımlılıklar yüklenemedi"
            if apt install -y "${packages[@]}" 2>&1 | grep -q "dpkg was interrupted"; then
                exit $EXIT_DPKG_ERROR
            fi
            exit $EXIT_DEPENDENCY_FAILED
        fi
    } >> "$LOG_FILE" 2>&1
    success "Temel bağımlılıklar yüklendi"
}

# Install GPU drivers
install_gpu_drivers() {
    info "GPU sürücüleri yükleniyor..."
    if ! check_dpkg_status; then
        exit $EXIT_DPKG_ERROR
    fi
    {
        if ! ubuntu-drivers install 2>&1; then
            error "GPU sürücüleri yüklenemedi"
            exit $EXIT_GPU_ERROR
        fi
    } >> "$LOG_FILE" 2>&1
    success "GPU sürücüleri yüklendi"
}

# Install Docker
install_docker() {
    if command_exists docker; then
        info "Docker zaten yüklü"
        return
    fi
    info "Docker yükleniyor..."
    if ! check_dpkg_status; then
        exit $EXIT_DPKG_ERROR
    fi
    {
        if ! apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common 2>&1; then
            error "Docker önkoşulları yüklenemedi"
            if apt install -y apt-transport-https 2>&1 | grep -q "dpkg was interrupted"; then
                exit $EXIT_DPKG_ERROR
            fi
            exit <span class="math-inline">EXIT\_DEPENDENCY\_FAILED
fi
<6\>curl \-fsSL https\://download\.docker\.com/linux/ubuntu/gpg \| gpg \-\-dearmor \-o /usr/share/keyrings/docker\-archive\-keyring\.gpg
echo "deb \[arch\=</span>(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        if ! apt update -y 2>&1; then
            error "Docker için paket listesi güncellenemedi"
            exit $EXIT_DEPENDENCY_FAILED
        fi
        if ! apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin 2>&1; then
            error "Docker yüklenemedi"
            if apt install -y docker-ce 2>&1 | grep -q "dpkg was interrupted"; then
                exit $EXIT_DPKG_ERROR
            fi
            exit $EXIT_DEPENDENCY_FAILED
        fi
        systemctl enable docker
        systemctl start docker
        usermod -aG docker $(logname 2>/dev/null || echo "$USER")
    } >> "$LOG_FILE" 2>&1
    success "Docker yüklendi"
}

# Install NVIDIA Container Toolkit
install_nvidia_toolkit() {
    if is_package_installed "nvidia-docker2"; then
        info "NVIDIA Container Toolkit zaten yüklü"
        return
    fi
    info "NVIDIA Container Toolkit yükleniyor..."
    if ! check_dpkg_status; then
        exit <span class="math-inline">EXIT\_DPKG\_ERROR
fi
\{
distribution\=</span>(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')$(grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"'| tr -d '\.')
        curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
        curl -s -L https://nvidia.github.io/nvidia-docker/"$distribution"/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list
        if ! apt update -y 2>&1; then
            error "NVIDIA toolkit için paket listesi güncellenemedi"
            exit $EXIT_DEPENDENCY_FAILED
        fi
        if ! apt install -y nvidia-docker2 2>&1; then
            error "NVIDIA Docker desteği yüklenemedi"
            if apt install -y nvidia-docker2 2>&1 | grep -q "dpkg was interrupted"; then
                exit $EXIT_DPKG_ERROR
            fi
            exit $EXIT_DEPENDENCY_FAILED
        fi
        mkdir -p /etc/docker
        tee /etc/docker/daemon.json <<EOF
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
        systemctl restart docker
    } >> "$LOG_FILE" 2>&1
    success "NVIDIA Container Toolkit yüklendi"
}

# Install Rust
install_rust() {
    if command_exists rustc; then
        info "Rust zaten yüklü"
        return
    fi
    info "Rust yükleniyor..."
    {
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        rustup update
    } >> "$LOG_FILE" 2>&1
    success "Rust yüklendi"
}

# Install Just
install_just() {
    if command_exists just; then
        info "Just komut çalıştırıcısı zaten yüklü"
        return
    fi
    info "Just komut çalıştırıcısı yükleniyor..."
    {
        curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
    } >> "$LOG_FILE" 2>&1
    success "Just yüklendi"
}

# Install CUDA Toolkit (kept commented as in original)
# install_cuda() {
#     if is_package_installed "cuda-toolkit"; then
#         info "CUDA Toolkit is already installed"
#         return
#     fi
#     info "Installing CUDA Toolkit..."
#     if ! check_dpkg_status; then
#         exit <span class="math-inline">EXIT\_DPKG\_ERROR
\#     fi
\#     \{
\#         distribution\=</span>(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')$(grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"'| tr -d '\.')
#         if ! wget https://developer.download.nvidia.com/compute/cuda/repos/<span class="math-inline">distribution/</span>(/usr/bin/uname -m)/cuda-keyring_1.1-1_all.deb 2>&1; then
#             error "Failed to download CUDA keyring"
#             exit $EXIT_DEPENDENCY_FAILED
#         fi
#         if ! dpkg -i cuda-keyring_1.1-1_all.deb 2>&1; then
#             error "Failed to install CUDA keyring"
#             rm cuda-keyring_1.1-1_all.deb
#             exit $EXIT_DEPENDENCY_FAILED
#         fi
#         rm cuda-keyring_1.1-1_all.deb
#         if ! apt-get update 2>&1; then
#             error "Failed to update package list for CUDA"
#             exit $EXIT_DEPENDENCY_FAILED
#         fi
#         if ! apt-get install -y cuda-toolkit 2>&1; then
#             error "Failed to install CUDA Toolkit"
#             if apt-get install -y cuda-toolkit 2>&1 | grep -q "dpkg was interrupted"; then
#                 exit $EXIT_DPKG_ERROR
#             fi
#             exit $EXIT_DEPENDENCY_FAILED
#         fi
#     } >> "$LOG_FILE" 2>&1
#     success "CUDA Toolkit installed"
# }

# Install Rust dependencies
install_rust_deps() {
    info "Rust bağımlılıkları yükleniyor..."

    # Source Rust environment
    source "$HOME/.cargo/env" || {
        error "$HOME/.cargo/env kaynağı sağlanamadı. Rust'ın yüklü olduğundan emin olun."
        exit $EXIT_DEPENDENCY_FAILED
    }

    # Check for cargo and install if not present
    if ! command_exists cargo; then
        if ! check_dpkg_status; then
            exit $EXIT_DPKG_ERROR
        fi
        info "Cargo yükleniyor..."
        apt update >> "$LOG_FILE" 2>&1 || {
            error "Cargo için paket listesi güncellenemedi"
            exit $EXIT_DEPENDENCY_FAILED
        }
        apt install -y cargo >> "$LOG_FILE" 2>&1 || {
            error "Cargo yüklenemedi"
            if apt install -y cargo 2>&1 | grep -q "dpkg was interrupted"; then
                exit $EXIT_DPKG_ERROR
            fi
            exit $EXIT_DEPENDENCY_FAILED
        }
    fi

    # Always install rzup and RISC Zero Rust toolchain
    info "rzup yükleniyor..."
    curl -L https://risczero.com/install | bash >> "$LOG_FILE" 2>&1 || {
        error "rzup yüklenemedi"
        exit $EXIT_DEPENDENCY_FAILED
    }
    # Update PATH in current shell
    export PATH="$PATH:/root/.risc0/bin"
    # Source bashrc to ensure environment is updated
    PS1='' source ~/.bashrc >> "$LOG_FILE" 2>&1 || {
        error "rzup kurulumundan sonra ~/.bashrc kaynağı sağlanamadı"
        exit $EXIT_DEPENDENCY_FAILED
    }
    # Install RISC Zero Rust toolchain
    rzup install rust >> "$LOG_FILE" 2>&1 || {
        error "RISC Zero Rust araç zinciri yüklenemedi"
        exit <span class="math-inline">EXIT\_DEPENDENCY\_FAILED
\}
\# Detect RISC Zero toolchain
TOOLCHAIN\=</span>(rustup toolchain list | grep risc0 | head -1)
    if [ -z "$TOOLCHAIN" ]; then
        error "Kurulumdan sonra RISC Zero araç zinciri bulunamadı"
        exit $EXIT_DEPENDENCY_FAILED
    fi
    info "RISC Zero araç zinciri kullanılıyor: $TOOLCHAIN"

    # Install cargo-risczero
    if ! command_exists cargo-risczero; then
        info "cargo-risczero yükleniyor..."
        cargo install cargo-risczero >> "$LOG_FILE" 2>&1 || {
            error "cargo-risczero yüklenemedi"
            exit $EXIT_DEPENDENCY_FAILED
        }
        rzup install cargo-risczero >> "$LOG_FILE" 2>&1 || {
            error "rzup aracılığıyla cargo-risczero yüklenemedi"
            exit $EXIT_DEPENDENCY_FAILED
        }
    fi

    # Install bento-client with RISC Zero toolchain
    info "bento-client yükleniyor..."
    RUSTUP_TOOLCHAIN=$TOOLCHAIN cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli >> "$LOG_FILE" 2>&1 || {
        error "bento-client yüklenemedi"
        exit $EXIT_DEPENDENCY_FAILED
    }
    # Persist PATH for cargo binaries
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    PS1='' source ~/.bashrc >> "$LOG_FILE" 2>&1 || {
        error "bento-client kurulumundan sonra ~/.bashrc kaynağı sağlanamadı"
        exit $EXIT_DEPENDENCY_FAILED
    }

    # Install boundless-cli
    info "boundless-cli yükleniyor..."
    cargo install --locked boundless-cli >> "$LOG_FILE" 2>&1 || {
        error "boundless-cli yüklenemedi"
        exit $EXIT_DEPENDENCY_FAILED
    }
    # Update PATH for boundless-cli
    export PATH="$PATH:/root/.cargo/bin"
    PS1='' source ~/.bashrc >> "$LOG_FILE" 2>&1 || {
        error "boundless-cli kurulumundan sonra ~/.bashrc kaynağı sağlanamadı"
        exit $EXIT_DEPENDENCY_FAILED
    }

    success "Rust bağımlılıkları yüklendi"
}

# Clone Boundless repository (no prompt)
clone_repository() {
    info "Boundless deposu ayarlanıyor..."
    if [[ -d "$INSTALL_DIR" ]]; then
        if [[ "$FORCE_RECLONE" == "true" ]]; then
            warning "Mevcut dizin $INSTALL_DIR siliniyor (--force-reclone ile zorlandı)"
            rm -rf "$INSTALL_DIR"
        else
            warning "Boundless dizini zaten mevcut: $INSTALL_DIR"
            info "Mevcut depoyu güncellemeye çalışılıyor..." # Prompt kaldırıldı
            cd "$INSTALL_DIR"
            if ! git pull origin release-0.10 2>&1 >> "$LOG_FILE"; then
                error "Depo güncellenemedi"
                exit $EXIT_DEPENDENCY_FAILED
            fi
            info "Mevcut depo güncellendi."
            return
        fi
    fi
    {
        if ! git clone https://github.com/boundless-xyz/boundless "$INSTALL_DIR" 2>&1; then
            error "Depo klonlanamadı"
            exit $EXIT_DEPENDENCY_FAILED
        fi
        cd "$INSTALL_DIR"
        if ! git checkout release-0.10 2>&1; then
            error "release-0.10 dalına geçilemedi"
            exit $EXIT_DEPENDENCY_FAILED
        fi
        if ! git submodule update --init --recursive 2>&1; then
            error "Alt modüller başlatılamadı"
            exit $EXIT_DEPENDENCY_FAILED
        fi
    } >> "$LOG_FILE" 2>&1
    success "Depo klonlandı ve başlatıldı"
}

# Detect GPU configuration
detect_gpus() {
    info "Detecting GPU configuration..."
    if ! command_exists nvidia-smi; then
        warning "nvidia-smi not found. GPU drivers might not be properly installed."
        GPU_COUNT=0
        SEGMENT_SIZE=17 # Set lowest segment size by default
        info "No GPUs detected. SEGMENT_SIZE set to <span class="math-inline">SEGMENT\_SIZE by default\."
return
fi
GPU\_COUNT\=</span>(nvidia-smi -L 2>/dev/null | wc -l)
    if [[ $GPU_COUNT -eq 0 ]]; then
        warning "No GPUs detected."
        SEGMENT_SIZE=17 # Set lowest segment size by default
        info "SEGMENT_SIZE set to $SEGMENT_SIZE by default."
        return
    fi
    info "Found $GPU_COUNT GPU(s)"
    GPU_MEMORY=()
    for i in $(seq 0 <span class="math-inline">\(\(GPU\_COUNT \- 1\)\)\); do
MEM\=</span>(nvidia-smi -i $i --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | tr -d ' ')
        if [[ -z "$MEM" ]]; then
            error "Failed to detect GPU $i memory"
            exit $EXIT_GPU_ERROR
        fi
        GPU_MEMORY+=($MEM)
        info "GPU $i: <span class="math-inline">\{MEM\}MB VRAM"
done
MIN\_VRAM\=</span>(printf '%s\n' "${GPU_MEMORY[@]}" | sort -n | head -1)
    if [[ $MIN_VRAM -ge 40000 ]]; then
        SEGMENT_SIZE=22
    elif [[ $MIN_VRAM -ge 20000 ]]; then
        SEGMENT_SIZE=21
    elif [[ $MIN_VRAM -ge 16000 ]]; then
        SEGMENT_SIZE=20
    elif [[ $MIN_VRAM -ge 12000 ]]; then
        SEGMENT_SIZE=19
    elif [[ $MIN_VRAM -ge 8000 ]]; then
        SEGMENT_SIZE=18
    else
        SEGMENT_SIZE=17
    fi
    info "SEGMENT_SIZE set to $SEGMENT_SIZE based on minimum ${MIN_VRAM}MB VRAM"
}

# Run main
main
