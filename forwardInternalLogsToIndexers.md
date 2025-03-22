## 🛡️ Forwarding Configuration
Disabling and forwarding internal logs to the indexers
```ini
[indexAndForward]
index = false

[tcpout]
defaultGroup = my_search_peers
forwardedindex.filter.disable = true
indexAndForward = false

[tcpout:my_search_peers]
server = 172.31.83.124:9997,172.31.91.156:9997,172.31.80.100:9997
```

## 📦 **OS Logs Configuration**
For the Linux and Windows App outputs.conf on the DS
### 🪟 Windows Logs

```ini
[WinEventLog://Application]
disabled = 0
start_from = oldest
current_only = 0
checkpointInterval = 5
renderXml = true
index = atlgsdach_windows_prod

[WinEventLog://Security]
disabled = 0
start_from = oldest
current_only = 0
evt_resolve_ad_obj = 1
checkpointInterval = 5
blacklist1 = EventCode="4662" Message="Object Type:(?!\s*groupPolicyContainer)"
blacklist2 = EventCode="566" Message="Object Type:(?!\s*groupPolicyContainer)"
renderXml = true
index = atlgsdach_windows_prod

[WinEventLog://System]
disabled = 0
start_from = oldest
current_only = 0
checkpointInterval = 5
renderXml = true
index = atlgsdach_windows_prod
```

### 🐧 **Linux Logs**

```ini
[script://./bin/vmstat_metric.sh]
sourcetype = vmstat_metric
source = vmstat
interval = 60
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/iostat_metric.sh]
sourcetype = iostat_metric
source = iostat
interval = 60
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/ps_metric.sh]
sourcetype = ps_metric
source = ps
interval = 30
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/df_metric.sh]
sourcetype = df_metric
source = df
interval = 300
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/interfaces_metric.sh]
sourcetype = interfaces_metric
source = interfaces
interval = 60
disabled = 0
index = atlgsdach_linux_prod

[script://./bin/cpu_metric.sh]
sourcetype = cpu_metric
source = cpu
interval = 30
disabled = 0
index = atlgsdach_linux_prod
```

## 🛠️ **Creating an App for Forwarder Configuration**

We need to create an app on the **Deployment Server** to manage outputs configurations for forwarders.

```bash
mkdir -p /opt/splunkforwarder/etc/deployment-apps/all_fwd_outputs/local
```

### ✏️ **Add Configuration**
Create an `outputs.conf` inside the app:

```ini
[tcpout]
defaultGroup = default-autolb-group

[tcpout:default-autolb-group]
server = 172.31.83.124:9997,172.31.91.156:9997,172.31.80.100:9997
```

### 🔄 **Reload Deployment Server**
Reload to push the new configuration to all forwarders:

```bash
/opt/splunk/bin/splunk reload deploy-server -class all_ufd
```

```ini
index="_internal" 
index=atlgsdach_linux_prod
```


### Windows Logs Not Showing Due to IP Configuration Issue

I encountered an issue where my Windows logs were not showing up. After troubleshooting, I discovered that the problem was caused by the IP address configuration for the indexers.

My local machine was attempting to send Windows logs to the indexers using their **private IP addresses**. However, on the deployment server, I had created an app that used the **internal IP addresses** of the indexers instead. Since the deployment server controls the configurations through the app, any manual changes I made to the configuration on the forwarder were overridden when it pulled the latest app updates.

### Solution
To resolve this, I updated the configuration to use the **public IP addresses** of the indexers instead of the internal ones. This ensures that logs are properly forwarded from my local machine to the indexers.

Here is the corrected configuration:

```plaintext
[tcpout]
defaultGroup = default-autolb-group

[tcpout:default-autolb-group]
server = <Public_IP_1>:9997,<Public_IP_2>:9997,<Public_IP_3>:9997
```

### Note
- Ensure that the deployment server's app uses the correct **public IP addresses** of the indexers.
- After making changes, run the following command to reload the deployment server and apply the new configuration:

```bash
/opt/splunk/bin/splunk reload deploy-server -class all_ufd
```

This will ensure the correct IP addresses are used and that logs from the Windows machine are successfully sent to the indexers.

