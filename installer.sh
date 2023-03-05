#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if git is installed
if ! command -v git &> /dev/null
then
    echo -e "${RED}Git is not installed. Please install git and try again.${NC}"
    exit 1
fi

# Check if Automatehunter.sh exists and is executable
if [ ! -x "Automatehunter.sh" ]; then
    echo -e "${YELLOW}Automatehunter.sh not found or is not executable. Adding execute permission...${NC}"
    chmod +x Automatehunter.sh
fi

# Check if dependencies are installed, install them if not
echo -e "${YELLOW}Checking dependencies...${NC}"
declare -a dependencies=("amass" "whois" "dnsutils" "traceroute" "wafw00f" "nmap" "rustscan" "nikto" "nuclei" "ffuf")
for dependency in "${dependencies[@]}"
do
    if ! command -v "$dependency" &> /dev/null
    then
        echo -e "${YELLOW}$dependency is not installed. Installing now...${NC}"
        sudo apt-get update
        sudo apt-get install -y "$dependency"
        echo -e "${GREEN}Successfully installed $dependency.${NC}"
    fi
done

# Install ffuf
if ! command -v "ffuf" &> /dev/null
then
    echo -e "${YELLOW}ffuf is not installed. Installing now...${NC}"
    wget https://github.com/ffuf/ffuf/releases/download/v1.3.1/ffuf_1.3.1_linux_amd64.tar.gz
    tar -xzvf ffuf_1.3.1_linux_amd64.tar.gz
    sudo mv ffuf /usr/local/bin/
    echo -e "${GREEN}Successfully installed ffuf.${NC}"
    rm -rf ffuf_1.3.1_linux_amd64.tar.gz
fi

echo -e "${GREEN}The installation is complete.${NC}"
