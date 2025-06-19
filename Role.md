![1500x500](https://github.com/user-attachments/assets/b262662f-848e-4558-9aa4-7945e585b857)

| X        | Minimum              |
|------------------|----------------------------|
| **CPU**          | 4++ |
| **RAM**          | 4++ GB                   |
| **Storage**      | 20+ NVME GB SDD                   |
| **Network**      | 100 Mbps (1 Gbps+ recommended) |

## 1. Server / PC Update : 

```bash
sudo apt update -y && sudo apt upgrade -y
```
## 2. Install Packages:

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

## Screen : 

```bash
screen -S boundlessrole
```

## Install Boundless Repo : 

```bash
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10
```

## Install Bento_CLI : 
```bash
cargo install --git https://github.com/risc0/risc0 bento-client --bin bento_cli
```
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
![image](https://github.com/user-attachments/assets/140f0ddf-ee3f-4202-933d-5c7b27c98e3e)

## Install Boundless CLI  : 
```bash
cargo install --locked boundless-cli
```
```bash
export PATH=$PATH:/root/.cargo/bin
source ~/.bashrc
```

#### Mainnet Base Config : 
```bash
nano .env.base
```
- export PRIVATE_KEY= Wallet Privatekey paste after = at the end
- export RPC_URL="" Paste Alhcemy etc. base mainnet rpc between the export RPC_URL="" quotes.

- CTRL X - CTRL Y - Enter - Saved.

![image](https://github.com/user-attachments/assets/7a6027d2-15b3-4611-b7e3-ec3c707f9a15)


#### Inject : 
```bash
source .env.base
```

#### Prover Role TX ; 
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

- If it gives RPC URL Error, paste the mainnet base rpc url you got directly from Alchemy instead of $ETH_RPC_URL.
- If --private-key gives <PRIVATE_KEY> error, replace $PRIVATE_KEY with your wallet private key.
- I wrote deposit stake 2 - I gave approval with 2.

![image](https://github.com/user-attachments/assets/9556462f-4386-4eaa-9214-40e00b5c0ceb)


## Dev Role TX : 
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
- If it gives RPC URL Error, paste the mainnet base rpc url you got directly from Alchemy instead of $ETH_RPC_URL.
- If --private-key gives <PRIVATE_KEY> error, replace $PRIVATE_KEY with your wallet private key.

![image](https://github.com/user-attachments/assets/98beeaba-e50c-4a55-a0e3-671eaa0d9a81)

## Guild : 

- Link : https://guild.xyz/boundless-xyz#!

![image](https://github.com/user-attachments/assets/495af26f-9b96-4230-8af8-11991b1db590)
