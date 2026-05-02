# Netsweep
> collection of bash scripts to automate Nmap for authorized security audits.

[[License: MIT] (https://img.shields.io/badge/lincense-MIT-yellow.svg)] (Https://opensource.org/lincenses/mit)

This repo contains wrapper scripts and templates to run 'nmap' efficiently for host discovery,port scanning,and service enumaration.

**Legal disclamer** :only scan networks you own or have written permission to test.Unauthorized scanning is illegal.

### **Scripts**
-'Quick-scan.sh' -Fast SYN scan of top 1000 ports.
-'full-audit.sh' -Host discovery+service/version detection+output to html
-'subnet-sweep.sh' -Discovers all live hosts in a /24 and saves to 'hosts.txt'

### ** Quick** 
'''bash
git clone https://github.com/is-muriuki/netsweep.git 
cd netsweep
chmod +X *.sh
sudo ./quick-scan 192.168.1.1
