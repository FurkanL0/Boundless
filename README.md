# Boundless

![1500x500](https://github.com/user-attachments/assets/b95f0be0-3e34-417b-9a3a-38990964a91f)

| X        | Minimum              |
|------------------|----------------------------|
| **CPU**          | X++ |
| **RAM**          | X++ GB ( 20++ )                    |
| **Storage**      | X TB+ NVME GB SDD                   |
| **Network**      | X Mbps (1 Gbps+ recommended) |


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
