![1500x500](https://github.com/user-attachments/assets/b262662f-848e-4558-9aa4-7945e585b857)

## 1. Server Güncelleme : 

```bash
sudo apt update -y && sudo apt upgrade -y
```
## 2. Paketleri Yüklüyoruz:

```bash
sudo apt install htop ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev tmux iptables curl nvme-cli git wget make jq libleveldb-dev build-essential pkg-config ncdu tar clang bsdmainutils lsb-release libssl-dev libreadline-dev libffi-dev jq gcc screen file unzip lz4 -y
```


## Rust : 
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

## Nolur Nolmaz Screen : 

```bash
screen -S boundlessrol
```

## Boundless Repo Çekelim : 

```bash
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10
```

## Bento_CLI Indirme : 
```bash
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli
```
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
![image](https://github.com/user-attachments/assets/140f0ddf-ee3f-4202-933d-5c7b27c98e3e)

## Boundless CLI Indırme : 
```bash
cargo install --locked boundless-cli
```
```bash
export PATH=$PATH:/root/.cargo/bin
source ~/.bashrc
```

#### Mainnet Base Düzenleme : 
```bash
nano .env.base
```
- export PRIVATE_KEY= Cüzdan Privatekey sonuna = den sonra yazıp yapıştırın
- export RPC_URL="" tırnak arasına Alhcemy vb. base mainnet rpc alıp yapıştırın. 

- CTRL X - CTRL Y - Enter - Kaydedecek.

![image](https://github.com/user-attachments/assets/7a6027d2-15b3-4611-b7e3-ec3c707f9a15)


#### Inject - Kayıt Edelim : 
```bash
source .env.base
```

#### Prover Rolü İçin ; 
```bash
boundless \
  --rpc-url "$ETH_RPC_URL" \
  --private-key "$PRIVATE_KEY" \
  --boundless-market-address 0x26759dbB201aFbA361Bec78E097Aa3942B0b4AB8 \
  --set-verifier-address 0x8C5a8b5cC272Fe2b74D18843CF9C3aCBc952a760 \
  --verifier-router-address 0x0b144e07a0826182b6b59788c34b32bfa86fb711 \
  --order-stream-url "https://base-mainnet.beboundless.xyz" \
  account deposit-stake 2
```

- Eğer RPC URL Hatası verir ise $ETH_RPC_URL yerine direkt Alchemyden aldığınız mainnet base rpc url'sini yapıştırın.
- Eğer --private-key <PRIVATE_KEY> hatası verir ise $PRIVATE_KEY yerine cüzdan private key'inizi yazın.
- Deposit stake 2 yazdım - 2 ile onay verdi.

![image](https://github.com/user-attachments/assets/9556462f-4386-4eaa-9214-40e00b5c0ceb)


## Dev Rolü İçin : 
```bash
boundless \
  --rpc-url "$ETH_RPC_URL" \
  --private-key "$PRIVATE_KEY" \
  --boundless-market-address 0x26759dbB201aFbA361Bec78E097Aa3942B0b4AB8 \
  --set-verifier-address 0x8C5a8b5cC272Fe2b74D18843CF9C3aCBc952a760 \
  --verifier-router-address 0x0b144e07a0826182b6b59788c34b32bfa86fb711 \
  --order-stream-url "https://base-mainnet.beboundless.xyz/" \
  account deposit 0.000001
```
- Eğer RPC URL Hatası verir ise $ETH_RPC_URL yerine direkt Alchemyden aldığınız mainnet base rpc url'sini yapıştırın.
- Eğer --private-key <PRIVATE_KEY> hatası verir ise $PRIVATE_KEY yerine cüzdan private key'inizi yazın.

![image](https://github.com/user-attachments/assets/98beeaba-e50c-4a55-a0e3-671eaa0d9a81)

## Guild : 

- Link : https://guild.xyz/boundless-xyz#!

![image](https://github.com/user-attachments/assets/495af26f-9b96-4230-8af8-11991b1db590)

