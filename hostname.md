
## Change Hostname Permanently
```sh
sudo hostnamectl set-hostname indexer_01
Rename-Computer -NewName "windows-server" -Force -Restart
```
To verify, run:
```sh
hostname
```

### If it still shows ip-172-31-93-40, try:
```sh
echo "master-node" | sudo tee /etc/hostname
```
Then restart the hostname service:
```sh
sudo systemctl restart systemd-hostnamed
```
Or simply reboot:
```sh
sudo reboot
```

### If Splunk is still showing the old hostname, update its config file:
```sh
sudo nano /opt/splunk/etc/system/local/server.conf
```
Modify or add:
```sh
[general]
serverName = master-node
```
Then restart Splunk again:
```sh
sudo /opt/splunk/bin/splunk restart
```

### Difference Between /etc/hosts and /etc/hostname

Both files are used for hostname management in Linux but serve different purposes:

1. /etc/hostname
- Purpose: Stores the system’s permanent hostname.
- Contents: A single line containing the system’s hostname (e.g., master-node).
- Effect: When the system boots, it reads this file to set the hostname.

Example Content (/etc/hostname):
```sh
master-node
```
Command to View:
```sh
cat /etc/hostname
```
Command to Edit:
```sh
sudo nano /etc/hostname
```
Command to Apply Changes Without Rebooting:
```sh
sudo systemctl restart systemd-hostnamed
```

### 2. /etc/hosts
- Purpose: Maps hostnames to IP addresses locally (before querying DNS).
- Contents: Multiple lines mapping IP addresses to hostnames.
- Effect: Helps resolve hostnames to IP addresses without querying an external DNS server.
- Example Content (/etc/hosts):
```sh
127.0.0.1   localhost
127.0.1.1   master-node
172.31.93.40   master-node
```
Command to View:
```sh
cat /etc/hosts
```
Command to Edit:
```sh
sudo nano /etc/hosts
```