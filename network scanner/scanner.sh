network="172.16.61.195"
echo "scanning network: $network"
for ip in $(nmap -sn $network | grep "Nmap scan report" | awk '{print $5}' 
)
do
echo "Device found: $ip"
echo "scanning $ip"
nmap -p  1-100 $ip
done


