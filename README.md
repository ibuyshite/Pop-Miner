<h2 align=center>Pop Miner At Work</h2>

## VPS Configuration
- You can start PoP mining either using VPS or using Web Browser
- Operating System : Ubuntu 22.04
- RAM : 2 GB, Storage : 50 GB, CPU : 2 Core

## Installation
```bash
[ -f "hemixyz.sh" ] && rm hemixyz.sh; wget -q https://raw.githubusercontent.com/ibuyshite/Pop-Miner/main/hemixyz.sh && chmod +x hemixyz.sh && ./hemixyz.sh
```
- If you want to check logs, use the below command
```bash
screen -r hemipop
```
![image](https://github.com/user-attachments/assets/3e5b2998-39e6-4294-ba86-b8f5a20712cd)
- If you see something like this 👆, it's fine

![image](https://github.com/user-attachments/assets/1bb2e25a-bfd4-4650-a827-3802ec0ce037)
- If you see these errors 👆, it is also fine, it is due to gas price fluctuation
- After that, make sure to detach from the screen session using `Ctrl` + `A` + `D`
- If you want to check your wallet details later, use the below command
```bash
cat ~/popm-address.json
```
## Reward
- Hemi network team directly did not announce any reward for this but you will earn 1 tHEMI for each transactions. May be in near future, team will give reward to active PoP miners one the basis of tHEMI
- You can check how many tHEMI you have collected so far using this [block explorer](https://testnet.explorer.hemi.xyz/)

![image](https://github.com/user-attachments/assets/99218d53-1d07-4337-aeed-a149d91096c2)

Created With Help : https://github.com/BidyutRoy2/PoP-mining-within-Hemi-Network
