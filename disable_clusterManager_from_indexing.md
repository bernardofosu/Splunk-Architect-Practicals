## ✅ Full Setup to Disable Indexing (Cluster Manager) & Forward Logs Using Indexer Discovery

This guide ensures:
✔ **Indexer Discovery** is enabled on the **Cluster Manager**  
✔ **Deployment Server** manages forwarding settings  
✔ **Non-indexers (SH, LM, MC, SH Deployer, DS)** forward logs dynamically to indexers  

---

### 1️⃣ Enable Indexer Discovery on the Cluster Manager

📌 **On the Cluster Manager, enable Indexer Discovery and set up the shared pass4SymmKey for authentication.**  

#### 🔹 Steps to Enable Indexer Discovery

SSH into the Cluster Manager:
```bash
ssh user@<cluster-manager-ip>
```

Edit `server.conf`:
```bash
vi $SPLUNK_HOME/etc/system/local/server.conf
```

Add the following settings:
```ini
[clustering]
mode = master
pass4SymmKey = your-secret-key
```

Restart Splunk to apply changes:
```bash
splunk restart
```

✅ **Now, the Cluster Manager can provide indexer discovery services to forwarders.**  

---

### 2️⃣ Configure Deployment Server to Push Forwarding Configurations

📌 **Since Search Heads, License Masters, Monitoring Consoles, SH Deployers, and other forwarders should not index data, we will configure their settings centrally using the Deployment Server.**  

#### 🔹 Steps to Configure `outputs.conf` on the Deployment Server

SSH into the Deployment Server:
```bash
ssh user@<deployment-server-ip>
```

Create a directory for the deployment app:
```bash
mkdir -p $SPLUNK_HOME/etc/deployment-apps/forwarder_outputs/local
```

Create and edit `outputs.conf`:
```bash
vi $SPLUNK_HOME/etc/deployment-apps/forwarder_outputs/local/outputs.conf
```

Add the following:
```ini
[tcpout]
defaultGroup = indexer_discovery

[tcpout:indexer_discovery]
indexerDiscovery = true
master_uri = https://<cluster-manager-ip>:8089
useACK = true
```

Restart Splunk on the Deployment Server:
```bash
splunk restart
```

✅ **Now, the Deployment Server is ready to push `outputs.conf` to all clients.**  

---

### 3️⃣ Deploy the Forwarding Configurations to Clients

📌 **Ensure that all Search Heads, License Masters, Monitoring Consoles, SH Deployers, and forwarders receive `outputs.conf` from the Deployment Server.**  

#### 🔹 Steps to Deploy `outputs.conf`

Add a server class for the clients:
```bash
splunk add deploy-server-class forwarder_outputs
```

Assign all relevant clients:
```bash
splunk add deploy-client -class forwarder_outputs -clientName <client-hostname>
```

Deploy the configuration:
```bash
splunk reload deploy-server
```

✅ **Now, all configured clients will receive `outputs.conf` and forward logs to indexers dynamically.**  

---

### 4️⃣ Disable Indexing on Clients (Search Heads, License Masters, MC, SH Deployer, and DS)

📌 **To ensure logs are only forwarded (not indexed), modify `inputs.conf`.**  

#### 🔹 Steps to Disable Local Indexing

SSH into any **non-indexing instance** (e.g., Search Head):
```bash
ssh user@<non-indexer-ip>
```

Edit or create `inputs.conf`:
```bash
vi $SPLUNK_HOME/etc/system/local/inputs.conf
```

Add:
```ini
[default]
index = _forwarders
```

Restart Splunk:
```bash
splunk restart
```

✅ **Now, these nodes will not index data locally.**  

---

### 5️⃣ Verify Setup

#### 🔹 Check Forwarding Status on Any Client
```bash
splunk list forward-server
```

✅ **Expected Output:**
```
Indexer Discovery via Cluster Manager:
    indexer1-ip:9997
    indexer2-ip:9997
```

#### 🔹 Verify Logs Are Reaching Indexers
On any indexer, check:
```bash
splunk search "index=_internal | stats count by host"
```

---

## 📌 Summary

| **Task** | **Component** | **Configuration File** | **Action** |
|----------|--------------|--------------------|-----------|
| **Enable Indexer Discovery** | Cluster Manager | `server.conf` | Set `pass4SymmKey` |
| **Push Forwarding Settings** | Deployment Server | `outputs.conf` | Set `indexerDiscovery = true` |
| **Deploy Forwarding Config** | Deployment Server | Server Class | Push `outputs.conf` to clients |
| **Disable Indexing** | Non-Indexers | `inputs.conf` | Prevent local indexing |

✅ **Now, all non-indexers automatically discover indexers and forward logs dynamically!** 🚀

