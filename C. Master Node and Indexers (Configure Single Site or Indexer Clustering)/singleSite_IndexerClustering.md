# 🏗️ Splunk Architect Class (Indexer Clustering - Single Site)

## 📖 Brief Explanation
This class covers the installation, configuration, and setup of a Splunk deployment, focusing on best practices for architecting a scalable Splunk environment.

---

## 🔥 Phase 1 (Day 1) – Installation

### ✅ A. Install Deployment Server / License Master / Monitoring Console
- Set up a **Deployment Server** 🛠️ to centrally manage forwarders.
- Configure a **License Master** 🔑 to manage Splunk licensing.
- Install the **Monitoring Console** 🔎 to monitor cluster performance.

### ✅ B. Install the Forwarders
- Deploy a **Universal Forwarder** on a 🖥️ Windows machine.
- Deploy a **Universal Forwarder** on a 💻 Linux machine.

### ✅ C. Install the Cluster Master and Indexers
- Install and configure the **Cluster Master** 🏢.
- Set up **3 Indexers** 📊 as peer nodes.

### ✅ D. Install the Search Head
- Install a **Search Head** 🧠 to enable distributed searching.
- Join the Search Head to the Indexer Cluster.

### ✅ E. Configure Deployment Server and Forwarders
- Configure forwarders to **phone home** to the Deployment Server.

### ✅ F. Configure Server Classes
- Create **Server Classes** to group forwarders.

---

## 🚀 Phase 2 (Day 1) – Configuration & Optimization

### ✅ G. Indexer Cluster Configuration

#### 🔹 Cluster Master (`manager_node`) - `server.conf`
```ini
[clustering]
mode = master
replication_factor = 3
search_factor = 2
pass4SymmKey = changeme
cluster_label = prod_cluster
```

#### 🔹 Indexers (`indexer1`, `indexer2`, `indexer3`) - `server.conf`
```ini
[clustering]
mode = peer
master_uri = https://<manager_node>:8089
replication_port = 9887
pass4SymmKey = changeme
```

#### 🔹 Search Head - `server.conf`
```ini
[clustering]
mode = searchhead
master_uri = https://<manager_node>:8089
pass4SymmKey = changeme
```

### ✅ H. Enable Listener on Indexers - `inputs.conf`

## 🎯 Step 3: Enable Listener on Manager Node for Indexers

On each **indexer**, enable receiving by modifying `inputs.conf`:
```bash
mkdir -p /opt/splunk/etc/manager-apps/atlgsdach_all_indexers_base/local
cd /opt/splunk/etc/manager-apps/atlgsdach_all_indexers_base/local
vi inputs.conf
```
```ini
[splunktcp://9997]
disabled = 0
```

```bash
./splunk apply cluster-bundle
```
Check if Port 9997 is Enabled on the Indexers


### ✅ I. Create Indexes - `indexes.conf`
```ini
[windows_logs]
homePath = $SPLUNK_DB/windows_logs/db
coldPath = $SPLUNK_DB/windows_logs/colddb
thawedPath = $SPLUNK_DB/windows_logs/thaweddb

[linux_logs]
homePath = $SPLUNK_DB/linux_logs/db
coldPath = $SPLUNK_DB/linux_logs/colddb
thawedPath = $SPLUNK_DB/linux_logs/thaweddb

[application_logs]
homePath = $SPLUNK_DB/application_logs/db
coldPath = $SPLUNK_DB/application_logs/colddb
thawedPath = $SPLUNK_DB/application_logs/thaweddb
```

### ✅ J. Disable Indexers Web UI (optional) - `web.conf`
```ini
[settings]
startwebserver = 0
```

### ✅ K. Install License
- Apply via Splunk Web or CLI.

### ✅ L. Configure Monitoring Console
- Assign Cluster Roles properly.

### ✅ M. Forward Internal Logs - `outputs.conf`
```ini
[tcpout:indexer_group]
server = <indexer1>:9997,<indexer2>:9997,<indexer3>:9997
```

### ✅ N. Install Linux & Windows Apps
- **Splunk Add-on for Windows** 🖥️
- **Splunk Add-on for Linux** 💻

---

## 💻 Final Deployment Overview

| Component | Description |
|-----------|-------------|
| 1x Deployment Server | Manages forwarder configurations |
| 1x License Master | Manages licensing |
| 1x Monitoring Console | Health & performance monitoring |
| 2x Forwarders | Windows & Linux data collection |
| 1x Cluster Master | Manages indexer cluster |
| 3x Indexers | Store and replicate data |
| 1x Search Head | Enables distributed search |

