#!/bin/bash

show() {
    echo -e "\e[1;34m$1\e[0m"
}

ARCH=$(uname -m)

show "Checking your system architecture: $ARCH"
echo

if ! command -v screen &> /dev/null; then
    show "Screen not found, installing..."
    sudo apt-get update
    sudo apt-get install -y screen > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        show "Failed to install screen. Please check your package manager."
        exit 1
    fi
fi

if ! command -v jq &> /dev/null; then
    show "jq not found, installing..."
    sudo apt-get update
    sudo apt-get install -y jq > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        show "Failed to install jq. Please check your package manager."
        exit 1
    fi
fi

if [ "$ARCH" == "x86_64" ]; then
    show "Downloading for x86_64 architecture..."
    wget --quiet --show-progress https://github.com/hemilabs/heminetwork/releases/download/v0.3.13/heminetwork_v0.3.13_linux_amd64.tar.gz -O heminetwork_v0.3.13_linux_amd64.tar.gz
    tar -xzf heminetwork_v0.3.13_linux_amd64.tar.gz > /dev/null
    cd heminetwork_v0.3.13_linux_amd64 || { show "Failed to change directory."; exit 1; }

elif [ "$ARCH" == "arm64" ]; then
    show "Downloading for arm64 architecture..."
    wget --quiet --show-progress https://github.com/hemilabs/heminetwork/releases/download/v0.3.13/heminetwork_v0.3.13_linux_arm64.tar.gz -O heminetwork_v0.3.13_linux_arm64.tar.gz
    tar -xzf heminetwork_v0.3.13_linux_arm64.tar.gz > /dev/null
    cd heminetwork_v0.3.13_linux_arm64 || { show "Failed to change directory."; exit 1; }

else
    show "Unsupported architecture: $ARCH"
    exit 1
fi

echo
show "Select only one option:"
show "1. Use new wallet for PoP mining"
show "2. Use existing wallet for PoP mining"
read -p "Enter your choice (1/2): " choice
echo

if [ "$choice" == "1" ]; then
    show "Generating a new wallet..."
    ./keygen -secp256k1 -json -net="testnet" > ~/popm-address.json
    if [ $? -ne 0 ]; then
        show "Failed to generate wallet."
        exit 1
    fi
    cat ~/popm-address.json
    echo
    read -p "Have you saved the above details? (y/N): " saved
    echo
    if [[ "$saved" =~ ^[Yy]$ ]]; then
        pubkey_hash=$(jq -r '.pubkey_hash' ~/popm-address.json)
        show "Join : https://discord.gg/hemixyz"
        show "Request faucet from faucet channel to this address: $pubkey_hash"
        echo
        read -p "Have you requested faucet? (y/N): " faucet_requested
        if [[ "$faucet_requested" =~ ^[Yy]$ ]]; then
            priv_key=$(jq -r '.private_key' ~/popm-address.json)
            read -p "Enter static fee (numerical only, recommended : 100-200): " static_fee
            echo
            export POPM_BTC_PRIVKEY="$priv_key"
            export POPM_STATIC_FEE="$static_fee"
            export POPM_BFG_URL="wss://testnet.rpc.hemi.network/v1/ws/public"
            
            screen -dmS hemipop ./popmd
            if [ $? -ne 0 ]; then
                show "Failed to start PoP mining in screen session."
                exit 1
            fi

            show "PoP mining has started in the detached screen session named 'hemipop'."
        fi
    fi

elif [ "$choice" == "2" ]; then
    read -p "Enter your Private key: " priv_key
    read -p "Enter static fee (numerical only, recommended : 100-200): " static_fee
    echo
    export POPM_BTC_PRIVKEY="$priv_key"
    export POPM_STATIC_FEE="$static_fee"
    export POPM_BFG_URL="wss://testnet.rpc.hemi.network/v1/ws/public"
    
    screen -dmS hemipop ./popmd
    if [ $? -ne 0 ]; then
        show "Failed to start PoP mining in screen session."
        exit 1
    fi

    show "PoP mining has started in the detached screen session named 'hemipop'."
else
    show "Invalid choice."
    exit 1
fi
