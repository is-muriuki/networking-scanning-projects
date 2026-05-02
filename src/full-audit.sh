#!/bin/bash
# NetSweep - Full Network Audit Script
# Usage: sudo ./full-audit.sh -t 192.168.1.0/24

TARGET=""
OUTPUT_DIR="results"

# --- Parse command line flags ---
while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--target) 
      TARGET="$2"
      shift 2 
      ;;
    -o|--output)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: sudo $0 -t <target> [-o output_dir]"
      echo "Example: sudo $0 -t 192.168.1.0/24 -o reports"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use -h for help"
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
  echo "Error: Please run as root. Use: sudo $0 -t $TARGET"
  exit 1
fi

if ! command -v nmap &> /dev/null; then
  echo "Error: nmap not found. Install with: sudo apt install nmap"
  exit 1
fi

# --- Setup ---
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%F-%H%M%S)
BASENAME="$OUTPUT_DIR/scan-$TIMESTAMP"

echo "[+] NetSweep Full Audit Started"
echo "[+] Target: $TARGET"
echo "[+] Reports will be saved to: $BASENAME.*"
echo "[+] This may take several minutes..."
echo ""

# --- Main scan ---
# -sS: TCP SYN scan, fast and stealthy
# -sV: Service/version detection 
# -O: OS detection
# -T4: Aggressive timing
# -oA: Output to all formats
sudo nmap -sS -sV -O -T4 -p- --top-ports 1000 $TARGET -oA "$BASENAME"

# --- Finish ---
if [ $? -eq 0 ]; then
  echo ""
  echo "[+] Scan complete!"
  echo "[+] Normal:  $BASENAME.nmap"
  echo "[+] Grepable: $BASENAME.gnmap" 
  echo "[+] XML:     $BASENAME.xml"
  echo ""
  echo "[+] Quick summary:"
  grep "open" "$BASENAME.nmap" | head -10
else
  echo "[!] Scan failed. Check target and permissions."
  exit 1
fi
