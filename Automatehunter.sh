#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Clear the screen
clear

# Display the logo
echo -e "${RED}"
cat << "EOF"

                _                        _       _    _             _            
     /\        | |                      | |     | |  | |           | |           
    /  \  _   _| |_ ___  _ __ ___   __ _| |_ ___| |__| |_   _ _ __ | |_ ___ _ __ 
   / /\ \| | | | __/ _ \| '_ ` _ \ / _` | __/ _ \  __  | | | | '_ \| __/ _ \ '__|
  / ____ \ |_| | || (_) | | | | | | (_| | ||  __/ |  | | |_| | | | | ||  __/ |   
 /_/    \_\__,_|\__\___/|_| |_| |_|\__,_|\__\___|_|  |_|\__,_|_| |_|\__\___|_|   
                                | ly0kha.net |
                                                                     
                                                                                 

EOF
echo -e "${NC}"

# website input 
read -p "Enter the website URL: " website_url

# amass
echo -e "${YELLOW}Running amass tool...it will take a few minutes..please wait ${NC}"
amass enum -d $website_url
echo -e "${GREEN}amass tools finished.${NC}"

#  whois
echo -e "${YELLOW}Running whois...${NC}"
whois $website_url
echo -e "${GREEN}Whois finished.${NC}"
sleep 5s

# nslookup
echo -e "${YELLOW}Running nslookup...${NC}"
nslookup $website_url
echo -e "${GREEN}Nslookup finished.${NC}"
sleep 5s

# traceroute - map out the target’s network
echo -e "${YELLOW}Running traceroute...${NC}"
traceroute $website_url
echo -e "${GREEN}Traceroute finished.${NC}"
sleep 5s

# wafw00f -idenfiy the Waf 
echo -e "${YELLOW}Running wafw00f...${NC}"
wafw00f $website_url
echo -e "${GREEN}Wafw00f finished.${NC}"
sleep 5s

# nmap - port scanner
echo -e "${YELLOW}Running nmap...${NC}"
nmap -A -T4 $website_url
echo -e "${GREEN}Nmap finished.${NC}"
sleep 5s


# rustscan -also port scanner
echo -e "${YELLOW}Running rustscan...${NC}"
rustscan $website_url
echo -e "${GREEN}Rustscan finished.${NC}"
sleep 5s

# nikto
echo -e "${YELLOW}Running nikto...${NC}"
nikto -h $website_url
nikto_pid=$!
trap "kill $nikto_pid; echo -e '\n${RED}Nikto stopped.${NC}\n'" SIGINT
wait $nikto_pid
echo -e "${GREEN}Nikto finished.${NC}"
sleep 5s

#  nuclei -
echo -e "${YELLOW}Running nuclei...${NC}"
nuclei -u $website_url
nuclei_pid=$!
trap "kill $nuclei_pid; echo -e '\n${RED}Nuclei stopped.${NC}\n'" SIGINT
wait $nuclei_pid
echo -e "${GREEN}nuclei finished.${NC}"
sleep 5s

# ffuf 
echo -e "${YELLOW}Running ffuf...${NC}"
read -p "Enter wordlist file path: " wordlist_path
read -p "Enter filter options: " filter_options
read -p "Enter match condition (default: all): " match_condition
read -p "Enter filter status codes (default: $FILTER_STATUS_CODES): " filter_status_codes
match_condition=${match_condition:-all}
filter_status_codes=${filter_status_codes:-$FILTER_STATUS_CODES}
ffuf -w $wordlist_path -u $website_url/FUZZ -mc $match_condition -fs $filter_options
echo -e "${GREEN}Ffuf finished.${NC}"

sleep 5s

# Save the results to a file
echo -e "${YELLOW}Saving results to file...${NC}"
echo -e "Results for website: $website_url\n" >> results.txt
echo -e "------------------\n" >> results.txt
echo -e "${YELLOW}Reconnaissance tools:${NC}"
echo -e "${GREEN}[] Running whois...${NC}"
whois $website_url >> $output_file
echo -e "${GREEN}[] Running nslookup...${NC}"
nslookup $website_url >> $output_file
echo -e "${GREEN}[] Running traceroute...${NC}"
traceroute $website_url >> $output_file
echo -e "${GREEN}[] Running wafw00f...${NC}"
wafw00f $website_url >> $output_file

echo -e "${GREEN}[+] Scanning completed.${NC}"
echo -e "${YELLOW}Results saved in $output_file.${NC}"
