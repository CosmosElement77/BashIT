#!/bin/bash

# Colors for pretty output using the ANSI escape codes
GREEN='\033[0;32m'
L_GREEN='\033[1;32m'
VIOLET='\033[1;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Colour in order to stop everything from being written in green colour

echo -e "${GREEN}=======================================${NC}"
echo -e "${L_GREEN}       CPU TESTING & STRESS SCRIPT     ${NC}"
echo -e "${GREEN}=======================================${NC}"

# Gathering CPU Info using lscpu
echo -e "\n${YELLOW}[*] Gathering CPU Information...${NC}"
CPU_MODEL=$(lscpu | grep "Model name:" | sed 's/Model name:\s*//')
CPU_CORES=$(lscpu | grep -E "^CPU\(s\):" | awk '{print $2}')
echo -e "CPU Model: ${L_GREEN}$CPU_MODEL${NC}"
echo -e "Total CPU Cores/Threads: ${L_GREEN}$CPU_CORES${NC}"

# Check for required tool ,i.e, stress-ng
echo -e "\n${YELLOW}[*] Checking dependencies...${NC}"
if ! command -v stress-ng &> /dev/null ; then
    echo -e "${VIOLET}[!] Error: 'stress-ng' is not installed.${NC}"
    echo "${L_GREEN}Please install it using your package manager (e.g. in debian-based OS, sudo apt install stress-ng)${NC}"
    exit 1
fi
echo -e "${GREEN}[✓] All Dependencies met.${NC}"

# Prompt user for test duration
echo -e "\n"
read -p "${YELLOW}Enter stress test duration in seconds (e.g., 60 for 1 minute): ${NC}" DURATION
if [[ ! "$DURATION" =~ ^[0-9]+$ ]]; then
    echo -e "${VIOLET}Hey, that is an invalid input. Please enter a number.${NC}"
    exit 1
fi

# Run the command
echo -e "\n${VIOLET}[!] WARNING: This will push your CPU to 100% utilization and your CPU will be set ablaze(just kidding)${NC}"
echo -e "${YELLOW}[*] Starting stress test for $DURATION seconds...${NC}"
echo "Press Ctrl+C at any time to abort."
echo "---------------------------------------"

# Determine which tool is available
STRESS_CMD="stress-ng --cpu $CPU_CORES --timeout $DURATION"

# Run stress test in the background
$STRESS_CMD > /dev/null 2>&1 &
STRESS_PID=$!

# Monitor temperatures while the background process runs using lm-sensors.
while kill -0 $STRESS_PID 2>/dev/null; do
    if command -v sensors &> /dev/null; then
        TEMP=$(sensors | grep -E '(Package id 0|Core 0|Tctl|CPU)' | head -n 1 | awk '{print $4}')
        echo -ne "Testing... Current Temp: ${YELLOW}$TEMP${NC}\r"
    else
        echo -ne "Testing... (Install 'lm-sensors' to monitor live temperature)\r"
    fi
    sleep 2
done

wait $STRESS_PID
echo -e "\n ${GREEN}---------------------------------------${NC}"
echo -e "${L_GREEN}[✓] Stress test completed successfully!${NC}"

# 5. Final check
if command -v sensors &> /dev/null; then
    echo -e "\n${YELLOW}[*] Final Temperature Check:${NC}"
    sensors | grep -E '(Package id 0|Core 0|Tctl|CPU)'
fi

echo -e "\n${GREEN}=======================================${NC}"
