# Boundless

![1500x500](https://github.com/user-attachments/assets/b95f0be0-3e34-417b-9a3a-38990964a91f)

| X        | Minimum              |
|------------------|----------------------------|
| **CPU**          | X++ |
| **RAM**          | X++ GB ( X++ )                    |
| **Storage**      | X TB+ NVME GB SDD                   |
| **Network**      | X Mbps (1 Gbps+ recommended) |
| **UBUNTU**      | UBUNTU 22.04 ! |


| Server Provider        | Link              | Features |
|------------------|----------------------------|----------------------------|
| **Contabo**          | [Link](https://www.dpbolvw.net/click-101330552-12454592)                     | Cheap / Paypal  |
| **PQ**      | [Link](https://pq.hosting/?from=627713)                  | Cheap / Crypto Payment |
| **NetCup**          | [Link](https://www.netcup.com/en/?ref=261820) | Cheap / Paypal |
| **VAST GPU**          | [Link](https://cloud.vast.ai/?ref_id=228932) | Cheap / Paypal |
| **Quickpod GPU**          | [Link](https://console.quickpod.io?affiliate=f26ea1e1-e0d8-4bbc-9e7f-5b03dddde481) | Cheap / Paypal |

## Project : 
- Twitter : https://x.com/boundless_xyz

## 1. Server Update : 

```bash
sudo apt update -y && sudo apt upgrade -y
```
## 2. Install Packages:

```bash
sudo apt install htop ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev tmux iptables curl nvme-cli git wget make jq libleveldb-dev build-essential pkg-config ncdu tar clang bsdmainutils lsb-release libssl-dev libreadline-dev libffi-dev jq gcc screen file unzip lz4 -y
```

## 3. Docker ; 

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
docker version
```

## 4. Install Docker Compose : 

```bash
VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

## 4. Docker User Permissions

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

## 5. Rust : 
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

![image](https://github.com/user-attachments/assets/0efae43c-b5ba-488c-9f3e-de0aa12698f4)


- 1 - Enter
```bash
source $HOME/.cargo/env
```

## Rzup : 
```bash
cargo install rzup
```
```bash
rzup install rust
```

![image](https://github.com/user-attachments/assets/fec1eec2-c86b-4f97-b9e2-d52b54622271)

## JUST : 
```bash
cargo install just
```
```bash
source $HOME/.cargo/env
```
```bash
just --version
```

## Screen : 
```bash
screen -S boundless
```

## Step 1: Clone Boundless Repository

- On Ubuntu 22.04, clone the Boundless monorepos on your proving machine and upgrade to the latest version:

```bash
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10
```

![image](https://github.com/user-attachments/assets/6159be8a-5cae-42a2-8e7c-d5735c59b38d)


## Step 2: Install Dependencies

- Install Docker Compose and Docker Nvidia Support. For Ubuntu 22.04 LTS, run the following command for a quick installation:

```bash
sudo ./scripts/setup.sh
```
![image](https://github.com/user-attachments/assets/f45981cc-18ad-4439-b14d-e811d3745249)

## Step 3: Test Proof

#### Install Bento_CLI : 
```bash
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli
```

![image](https://github.com/user-attachments/assets/140f0ddf-ee3f-4202-933d-5c7b27c98e3e)


- Run Bento : 
```bash
just bento
```
```bash
RUST_LOG=info bento_cli -c 32
```
![image](https://github.com/user-attachments/assets/afb73def-4253-4a3d-83b2-0f9214028da7)


## Install Boundless CLI : 
```bash
cargo install --locked boundless-cli
```

