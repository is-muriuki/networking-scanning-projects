#!/bin/bash
# NetSweep - Subnet Host Discovery 
# Usage: sudo ./subnet-sweep.sh -t 192.168.1.0/24

TARGET=""
OUTPUT_FILE="results/live-hosts.txt"

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--target) 
      TARGET="$2"
      shift 2 
      ;;
    -o|--output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: sudo $0 -t <subnet> [-o output_file]"
      echo "Example: sudo $0 -t 192.168.1.0/24 -o hosts.txt"
      echo "Discovers live hosts using ARP + ICMP ping sweep"
      exit 0
      ;;
    *)
      echo "Unknown option: $1. Use -h for help"
      exit 1
      ;;
  esac
done

# --- Checks ---
if [ -z "$TARGET" ]; then 
  echo "Error: --target is required"
  echo "Usage: sudo $0 -t 192.168.1.0/24"
  exit 1
fi

if [ "$EUID" -ne 0 ]; then 
  echo "Error: ARP scan needs root. Use: sudo $0 -t $TARGET"
  exit 1
fi

if ! command -v nmap &> /dev/null; then
  echo "Error: nmap not found. Install: sudo apt install nmap"
  exit 1
fi

# --- Setup ---
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "[+] NetSweep Subnet Discovery"
echo "[+] Target: $TARGET"
echo "[+] Scanning for live hosts..."
echo ""

# --- Main scan ---
# -sn: Ping scan, no port scan
# -PR: ARP ping on local network, fastest + most accurate
# -PE: ICMP echo request for hosts outside ARP range
# --min-rate 5000: Go fast
sudo nmap -sn -PR -PE --min-rate 5000 "$TARGET" -oG - | awk '/Up$/{print $2}' > "$OUTPUT_FILE"

# --- Finish ---
if [ $? -eq 0 ]; then
  echo ""
  echo "[+] Discovery complete!"
  echo "[+] Live hosts saved to: $OUTPUT_FILE"
  echo "[+] Total hosts found: $(wc -l < "$OUTPUT_FILE")"
  echo ""
  echo "[+] Sample:"
  head -10 "$OUTPUT_FILE"
else
  echo "[!] Scan failed."
  exit 1
fi
