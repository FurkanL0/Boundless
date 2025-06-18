# Boundless

![1500x500](https://github.com/user-attachments/assets/b95f0be0-3e34-417b-9a3a-38990964a91f)

| X        | Minimum              |
|------------------|----------------------------|
| **İşlemci**          | 16++ |
| **RAM**          | 32++ GB                   |
| **Disk Alanı**      | 200+ NVME GB SDD                   |
| **Internet Hızı**      | 100 Mbps (1 Gbps+ recommended) |
| **UBUNTU**      | UBUNTU 22.04 ! |


| Server Sağlayıcısı        | Link              | Neden |
|------------------|----------------------------|----------------------------|
| **VAST GPU**          | [Link](https://cloud.vast.ai/?ref_id=228932) | İstediğimiz Sunucular / Kripto Ödeme |

## Project : 
- Twitter : https://x.com/boundless_xyz

![image](https://github.com/user-attachments/assets/5fbb7dcd-ab59-4d63-9bc4-a3b1ec89b2a5)

- Ubuntu 22.04 VM
- 16 CPU - 3 GHZ üstü EPYC , Ryzen İşlemcili Serverlara Bakabilirsiniz
- 100 Mbps üstü indirme hızı olan serverlar +
- Minimum Container alanını 250+ ayarla

## 1. Server Güncelleme : 

```bash
sudo apt update -y && sudo apt upgrade -y
```
## 2. Paketleri İndirelim :

```bash
sudo apt install htop ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev tmux iptables curl nvme-cli git wget make jq libleveldb-dev build-essential pkg-config ncdu tar clang bsdmainutils lsb-release libssl-dev libreadline-dev libffi-dev jq gcc screen file nano btop unzip lz4 -y
```

## 3. Docker ; 

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
docker version
```

## 4. Docker Compose : 

```bash
VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

## 4. Docker User İzinleri

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

## JUST Indirme : 
```bash
cargo install just
```
```bash
source $HOME/.cargo/env
```
```bash
just --version
```

## Screen Açalım  : 

```bash
screen -S boundless
```

## Boundless Reposunu İndirelim.

```bash
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10
```

![image](https://github.com/user-attachments/assets/6159be8a-5cae-42a2-8e7c-d5735c59b38d)


## ./Scripts Setup İle Gerekli Yüklemeleri Yapalım

- Bu kısım Biraz Uzun Sürebilir.

```bash
sudo ./scripts/setup.sh
```
![image](https://github.com/user-attachments/assets/f45981cc-18ad-4439-b14d-e811d3745249)

## Deneme Atalım - Test Proof

#### Bento_CLI Indirelim : 
```bash
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli
```
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
![image](https://github.com/user-attachments/assets/140f0ddf-ee3f-4202-933d-5c7b27c98e3e)


- Bento'yu Çalıştıralım : 
```bash
just bento
```
```bash
RUST_LOG=info bento_cli -c 32
```
![image](https://github.com/user-attachments/assets/afb73def-4253-4a3d-83b2-0f9214028da7)

- Herhangi bir sorun yoksa onaylayıp kapatacaktır.

## Boundless CLI Indirelim : 
```bash
cargo install --locked boundless-cli
```
```bash
export PATH=$PATH:/root/.cargo/bin
source ~/.bashrc
```


## Base Sepolia : 

- Base Sepolia RPC İçin : https://dashboard.blockpi.io/rpc/endpoint


```bash
nano .env.base-sepolia
```

- export PRIVATE_KEY=   Buraya cüzdan private keyiniz
- Add export RPC_URL=""  2 Tırnak arasına base sepolia rpc'niz.

![image](https://github.com/user-attachments/assets/7a6027d2-15b3-4611-b7e3-ec3c707f9a15)


- Inject : 
```bash
source .env.base-sepolia
```
#### Stake : 

- Eth'den Sepoli'ya Bridge İçin : 
- 1 : https://testnet.brid.gg/base-sepolia?amount=&originChainId=11155111&token=ETH
- 2 : https://testnets.relay.link/bridge/base-sepolia?fromChainId=11155111
- USDC Faucet : 

- Base Chain - USDC - Minimum 5 USDC : https://faucet.circle.com/

```bash
boundless account deposit-stake STAKE_AMOUNT
```

![image](https://github.com/user-attachments/assets/9556462f-4386-4eaa-9214-40e00b5c0ceb)

- Base Chain - ETH - Minimum 0.00001
```bash
boundless account deposit 0.000001
```
![image](https://github.com/user-attachments/assets/98beeaba-e50c-4a55-a0e3-671eaa0d9a81)


## Start : 
```bash
just broker
```

![wos](https://github.com/user-attachments/assets/744e92bb-5b99-4e6f-bd88-4bd45d760faa)

- Logs : 
```bash
just broker logs
```
 - Logs :
```bash
docker compose logs -f broker
```
```bash
docker compose logs -fn 100
```
- Dashboard : https://explorer.beboundless.xyz/orders
- Guild : https://guild.xyz/boundless-xyz#!
