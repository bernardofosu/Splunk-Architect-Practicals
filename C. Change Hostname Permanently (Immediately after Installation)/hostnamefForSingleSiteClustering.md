
#### **Change Hostname Permanently (Immediately after Installation) 🖥️🔧**
This is very important to identify all the instances in the search when you query their internal logs, giving you a proper hostname and proper sever name at your monitoring console and cluster manager✨. You can do on splunk UI settings and server settings

**Steps for Hostname Change 🛠️**

**Linux 🐧:**
```sh
sudo hostnamectl set-hostname indexer-01
```

**For Windows 💻:**

```powershell
Rename-Computer -NewName "windows-server" -Force -Restart
```

**To verify, run:**

```sh
hostname
```

**Change serverName in Splunk server.conf 🔧📝**
- Make sure the serverName matches the hostname you’ve set previously.

```ini
[general]
serverName = Search-Head-Deployer 🏠
pass4SymmKey = $7$26KwSrCIHhUFa3ZN0V/tkHNe1Ze3hhcOgS8GC1LXdH5Z1NKueQ1qig==
```

**For Linux/macOS (Using sed) 🐧💡**
- This command updates the serverName without directly accessing server.conf.
```sh
sed -i 's/^serverName = .*/serverName = New_Server_Name 🖥️/' /opt/splunk/etc/system/local/server.conf
```

**For example:**
```sh
sed -i 's/^serverName = .*/serverName = Indexer_03_Site1 🚀/' /opt/splunk/etc/system/local/server.conf
```

```sh
sed -i 's/^serverName = .*/serverName = New_Server_Name 🖥️/' /opt/splunkforwarder/etc/system/local/server.conf
```

**For Windows (PowerShell) 💻🖥️**
- Change the serverName for your Splunk Universal Forwarder:
```sh
(Get-Content "C:\Program Files\SplunkUniversalForwarder\etc\system\local\server.conf") -replace 'serverName = .*', 'serverName = New_Server_Name 🏢' | Set-Content "C:\Program Files\SplunkUniversalForwarder\etc\system\local\server.conf"
```


**For Windows (PowerShell) 💻:**
- Check the correct path for your Splunk Universal Forwarder; the same method applies if you have installed the full enterprise on Windows as well:

```powershell
(Get-Content "C:\Program Files\Splunk\etc\system\local\server.conf") -replace 'serverName = .*', 'serverName = New_Server_Name 🏢' | Set-Content "C:\Program Files\Splunk\etc\system\local\server.conf"
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