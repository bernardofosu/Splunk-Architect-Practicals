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

## 📦 **OS Logs Configuration From Windows and Linux Server**
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
# 🚀 Using Indexer Discovery in Splunk Universal Forwarder

If you are using **indexer discovery**, then you should **not manually specify** the indexers' IPs in the `outputs.conf` file. Instead, the forwarders will dynamically discover available indexers from the **Cluster Master** (Search Head or Indexer Manager).

---

## ✅ Correct `outputs.conf` for Indexer Discovery

Replace your current `[tcpout]` configuration with this:
```ini
[tcpout]
defaultGroup = indexer_discovery

[tcpout:indexer_discovery]
indexerDiscovery = my_cluster_manager
useACK = true
forwardedindex.filter.disable = true   # ✅ Allows _internal and other filtered indexes to be forwarded if needed
pass4SymmKey = splunk123               # ✅ Matches what should be in CM's [indexer_discovery] stanza
indexAndForward = false               # ✅ Typical for UF, disables local indexing

[indexer_discovery:my_cluster_manager]
manager_uri = https://172.31.92.30:8089
```


✅ This should list the discovered indexers instead of manually configured IPs.
```sh
splunk list forward-server
```
if you're using manual indexer configuration (i.e., specifying indexer IPs directly in outputs.conf), then splunk list forward-server will still work, but it will only list the manually configured indexers.

However, if you're using Indexer Discovery, the command will show the discovered indexers dynamically retrieved from the Cluster Manager (Indexer Master).

## 🚀 Explanation:

- **No need to manually specify indexers' IPs.** The forwarder will dynamically get the list of active indexers from the **Cluster Manager**.
- **`indexerDiscovery = my_cluster_manager`** → This tells the forwarder to use indexer discovery.
- **`master_uri = https://<CLUSTER_MANAGER_IP>:8089`** → Replace `<CLUSTER_MANAGER_IP>` with the **Cluster Manager (Search Head or Indexer Master) IP**.
- **`useACK = true`** (optional) → Ensures reliability by waiting for acknowledgment from the indexer.

---

## 📌 Steps to Apply the Configuration

1. **Edit `outputs.conf`** on the Universal Forwarder.
2. **Restart Splunk Forwarder** for changes to take effect:
   ```bash
   splunk restart
   ```
3. **Verify Indexer Discovery:**
   ```bash
   splunk list forward-server
   ```
   This should show the discovered indexers.

---

## ✅ Benefits of Indexer Discovery

- **No manual IP management** → If an indexer fails or changes, the forwarder automatically adapts.
- **Scalability** → New indexers can be added without updating forwarder configs.
- **Load balancing** → Splunk distributes data efficiently.

---

By using **indexer discovery**, you ensure that your Splunk **Universal Forwarders** can dynamically find and send data to the most available indexers without requiring manual configuration updates! 🚀


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

