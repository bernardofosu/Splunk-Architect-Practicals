# 🔎 Using Indexer Discovery to Connect Forwarders to Peer Nodes

## 🎯 Overview
Indexer discovery allows **forwarders** to dynamically discover **indexers (peer nodes)** using a **manager node**. This setup ensures efficient load balancing and optimized data forwarding.

### 🛠️ Key Components
- **Manager Node**: Enables indexer discovery and shares a security key.
- **Forwarders**: Connect to the manager node and distribute data to indexers based on their disk capacity.
- **Peer Nodes (Indexers)**: Receive and store data from forwarders.

📖 **Reference**: [Splunk Documentation](https://docs.splunk.com/Documentation/Splunk/9.4.0/Indexer/indexerdiscovery)

---

## 🏗️ Step 1: Configure Indexer Discovery on Manager Node

Edit `server.conf` on the **manager node**:
```ini
[indexer_discovery]
pass4SymmKey = splunk1234
indexerWeightByDiskCapacity = true
```
🔹 The **pass4SymmKey** ensures security between manager and forwarders.
🔹 The **indexerWeightByDiskCapacity** setting distributes data based on indexer storage capacity.

---

## 📦 Step 2: Configure Forwarders for Indexer Discovery

Create an **app** for forwarders on the Deployment Server:
```bash
cd /opt/splunk/etc/deployment-apps/
mkdir -p /opt/splunk/etc/deployment-apps/atlgsdach_all_indexers_discovery_base/local
vi outputs.conf
```
```ini
[indexer_discovery:manager1]
pass4SymmKey = 20260918
manager_uri = https://172.31.92.30:8089

[tcpout:group1]
autoLBFrequency = 30
forceTimebasedAutoLB = true
indexerDiscovery = manager1
useACK=true

[tcpout]
defaultGroup = group1

[indexer_discovery:manager1]
pass4SymmKey = 20260918
manager_uri = https://172.31.92.30:8089

[tcpout:group1]
autoLBFrequency = 30
forceTimebasedAutoLB = true
indexerDiscovery = manager1
useACK=true

[tcpout]
defaultGroup = group1
```
🔹 **manager_uri** points to the manager node.
🔹 **useACK** ensures data integrity using indexer acknowledgment.

---

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

Run the following on each indexer:
```sh
/opt/splunk/bin/splunk btool inputs list --debug | grep 9997
```

## 📂 Step 4: Create Indexes

On the **manager node**, create an app and define `indexes.conf`:
```bash
mkdir -p /opt/splunk/etc/manager-apps/atlsdach_all_indexers_base/local
cd /opt/splunk/etc/manager-apps/atlsdach_all_indexers_base/local
vi indexes.conf

mv atlsdach_all_indexers_base/ atlgsdach_all_indexes_base/
```

### 🔹 Define Storage Volumes and Create Indexes for Different Data Types
```ini
[volume:one]
path = /opt/splunk/hot/one/
maxVolumeDataSizeMB = 40000

[volume:two]
path = /opt/splunk/warm/two/
maxVolumeDataSizeMB = 60000

[volume:three]
path = /opt/splunk/cold/three/
maxVolumeDataSizeMB = 80000

[atlgsdach_os_prod]
homePath = volume:one/atlgsdach_os_prod/db
coldPath = volume:three/atlgsdach_os_prod/colddb
coldToFrozenDir = /opt/splunk/frozen/atlgsdach_os_prod/frozendb
thawedPath = /opt/splunk/thawed/atlgsdach_os_prod/thaweddb
maxHotSpanSecs = 2592000
frozenTimePeriodInSecs = 7776000
maxDataSize = auto
maxTotalDataSizeMB = 102400
repFactor = auto

[atlgsdach_linux_prod]
homePath = volume:one/atlgsdach_linux_prod/db
coldPath = volume:three/atlgsdach_linux_prod/colddb
coldToFrozenDir = /opt/splunk/frozen/atlgsdach_linux_prod/frozendb
thawedPath = /opt/splunk/thawed/atlgsdach_linux_prod/thaweddb
maxHotSpanSecs = 2592000
frozenTimePeriodInSecs = 7776000
maxDataSize = auto
maxTotalDataSizeMB = 102400
repFactor = auto

[atlgsdach_windows_prod]
homePath = volume:one/atlgsdach_windows_prod/db
coldPath = volume:three/atlgsdach_windows_prod/colddb
coldToFrozenDir = /opt/splunk/frozen/atlgsdach_windows_prod/frozendb
thawedPath = /opt/splunk/thawed/atlgsdach_windows_prod/thaweddb
maxHotSpanSecs = 2592000
frozenTimePeriodInSecs = 7776000
maxDataSize = auto
maxTotalDataSizeMB = 102400
repFactor = auto
```
```bash
./splunk apply cluster-bundle
```
>[!NOTE]
> Apply the cluster bundle anytime you create apps under manager-apps in the Cluster Master to push the chnages to the indexers

### After applying the cluster bundle, You check peer-apps on the peers
```sh
cd /opt/splunk/etc/peer-apps # go inside the apps to check the conf
```


Disable Splunk Web UI Temporarily
```sh
splunk stop splunkweb
splunk start splunkweb
```