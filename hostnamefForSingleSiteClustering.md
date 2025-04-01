
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

**Change Hostname in Splunk server.conf 🔧📝**
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

**For Windows (PowerShell) 💻🖥️**
- Change the serverName for your Splunk Universal Forwarder:

```sh
sed -i 's/^serverName = .*/serverName = New_Server_Name 🖥️/' /opt/splunkforwarder/etc/system/local/server.conf
```

**For Windows (PowerShell) 💻:**
- Check the correct path for your Splunk Universal Forwarder; the same method applies if you have installed the full enterprise on Windows as well:

```powershell
(Get-Content "C:\Program Files\Splunk\etc\system\local\server.conf") -replace 'serverName = .*', 'serverName = New_Server_Name 🏢' | Set-Content "C:\Program Files\Splunk\etc\system\local\server.conf"

(Get-Content "C:\Program Files\SplunkUniversalForwarder\etc\system\local\server.conf") -replace 'serverName = .*', 'serverName = New_Server_Name 🏢' | Set-Content "C:\Program Files\SplunkUniversalForwarder\etc\system\local\server.conf"
```