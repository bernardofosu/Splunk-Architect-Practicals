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

## 🎯 Step 3: Enable Listener on Indexers

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
Apply the cluster bundle:
```bash
./splunk apply cluster-bundle
./splunk apply cluster-bundle --skip-validation
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

## 🔧 Step 5: Final Configuration & Deployment

### **Disable Web Interface on Indexers**
📌 Steps to Disable Splunk Web from Splunk UI

**1️⃣** Log in to Splunk Web → http://<splunk-server-ip>:8000 → Enter admin credentials

**2️⃣** Go to Settings → Server Settings → General Setting

**3️⃣** Check No "Enable Splunk Web

**4️⃣** Click Save → Restart Splunk

Edit `web.conf`: 
```bash
vi /opt/splunk/etc/system/local/web.conf
```
```ini
[settings]
startwebserver = false
```
### **Deploy Changes**
```bash
./splunk apply cluster-bundle
./splunk apply cluster-bundle --skip-validation
```
**Disable Splunk Web UI Permanently, Method: Using Splunk CLI**

Run the following command:
```sh
splunk disable webserver
```
✅ This prevents Splunk Web from starting on the next reboot. The Splunk backend (splunkd) will continue running.

To re-enable the web interface later:
```sh
splunk enable webserver
```

Disable Splunk Web UI Temporarily
```sh
splunk stop splunkweb
splunk start splunkweb
```
### 6. Install License and Configure the License Master (in our case its a DS_MC)
change license group vs change to peer"? Are you asking about:

**1️⃣** Changing the license group in Splunk (e.g., changing from a Trial License to an Enterprise License)?

**2️⃣** Changing a Splunk instance to a peer (e.g., adding a search peer to a distributed environment)
[Install License](install_license.md)

Check status
```sh
./splunk show cluster-bundle-status
```
## Configure Monitoring Console
[Monitoring Console](monitoring_console.md)


## 📌 Steps to Install Apps on Deployment Server via Splunk Web & Move to `deployment-apps`

1️⃣ **Log in to Splunk Web** → `http://<deployment-server-ip>:8000` → Enter **admin credentials**  
2️⃣ **Go to Apps** → **Manage Apps** (`App: Find More Apps`)  
3️⃣ **Install the required App** (Either from Splunkbase or upload manually)  
4️⃣ **Navigate to** → `Settings` → `Forwarder Management`  
5️⃣ **Move the Installed App**:  
   - Go to **$SPLUNK_HOME/etc/apps/**  
   - Move the app to **$SPLUNK_HOME/etc/deployment-apps/**  
   
   ```bash
   mv $SPLUNK_HOME/etc/apps/<app-name> $SPLUNK_HOME/etc/deployment-apps/
   ```  
6️⃣ **Restart Splunk** for changes to take effect:  
   
   ```bash
   splunk restart
   ```  
7️⃣ **Verify in Splunk Web** → `Settings` → `Forwarder Management` → **Check Deployment Apps**  
   

## 📌 Steps to Download, Upload, and Extract a Splunk App to `deployment-apps`

### 1️⃣ Download the App from Splunkbase
- Go to **[Splunkbase](https://splunkbase.splunk.com/)**
- Search for the required app
- Click **Download** and save the `.tgz` or `.tar.gz` file on your local machine

### 2️⃣ Upload the App to Deployment Server
#### **Using MobaXterm**
1. Open **MobaXterm**
2. Start an **SFTP session** to your Splunk Deployment Server
3. Navigate to the Splunk directory: `$SPLUNK_HOME/etc/deployment-apps/`
4. Drag and drop the downloaded `.tgz` or `.tar.gz` file to the target directory

#### **Using FileZilla**
1. Open **FileZilla** and connect to the Deployment Server
2. Locate the downloaded `.tgz` or `.tar.gz` file on your local machine
3. Navigate to `$SPLUNK_HOME/etc/deployment-apps/`
4. Upload the file to this directory

### 3️⃣ Extract the App on the Deployment Server
#### **Using SSH (Terminal/Command Line)**
1. SSH into the Deployment Server:
   ```bash
   ssh user@<deployment-server-ip>
   ```
2. Navigate to the `deployment-apps` directory:
   ```bash
   cd $SPLUNK_HOME/etc/deployment-apps/
   ```
3. Extract the app:
   ```bash
   tar -xvzf <app-name>.tgz
   ```
   or if the file is `.tar.gz`:
   ```bash
   tar -xzvf <app-name>.tar.gz
   ```
4. Remove the compressed file after extraction:
   ```bash
   rm <app-name>.tgz
   ```

### 4️⃣ Verify the App Deployment
- Run the following command to list the extracted app:
  ```bash
  ls -l $SPLUNK_HOME/etc/deployment-apps/
  ```
- Check in Splunk Web:
  - **Go to** `Settings` → `Forwarder Management`
  - **Verify** the app appears in **Deployment Apps**

### 5️⃣ Restart Splunk to Apply Changes
```bash
splunk restart
```

## 🚀 Step 6: Deploy Apps to Forwarders
Create the following **apps** on the Deployment Server and push them to forwarders:
- `all_base_inputs_linux`
- `all_base_inputs_windows`

```bash
mkdir -p /opt/splunk/etc/deployment-apps/all_base_inputs_linux/local
mkdir -p /opt/splunk/etc/deployment-apps/all_base_inputs_windows/local
```
Deploy these apps to forwarders using **Deployment Server**.

## How to Disable Search Head, License Master, Monitoring Console, Search Head Deployer and Deployment Server and also discover indexers and foward data to them in Clustering
